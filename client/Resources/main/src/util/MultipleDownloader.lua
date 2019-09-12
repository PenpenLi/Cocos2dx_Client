MultipleDownloader = class("MultipleDownloader")

local records = {}
local downloader = cc.Downloader:new({timeoutInSeconds = 20})

function MultipleDownloader:createFileDownLoad(params)
	local oParams = records[params.identifier]
	if oParams then
		oParams.onFileTaskSuccess = params.onFileTaskSuccess
		oParams.onDataTaskSuccess = params.onDataTaskSuccess
		oParams.onTaskProgress = params.onTaskProgress
		oParams.onTaskError = params.onTaskError
	else
		records[params.identifier] = params
		downloader:createDownloadFileTask(params.fileUrl, params.storagePath, params.identifier)
	end
end

function MultipleDownloader:createDataDownLoad(params)
	local oParams = records[params.identifier]
	if oParams then
		oParams.onFileTaskSuccess = params.onFileTaskSuccess
		oParams.onDataTaskSuccess = params.onDataTaskSuccess
		oParams.onTaskProgress = params.onTaskProgress
		oParams.onTaskError = params.onTaskError
	else
		records[params.identifier] = params
		downloader:createDownloadDataTask(params.fileUrl, params.identifier)
	end
end

function MultipleDownloader:removeFileDownload(identifier)
	local params = records[identifier]
	if params then
		params.onFileTaskSuccess = nil
		params.onDataTaskSuccess = nil
		params.onTaskProgress = nil
		params.onTaskError = nil
	end
end

function MultipleDownloader:_removeFileDownload(identifier)
	records[identifier] = nil
end

local function onFileTaskSuccess(dataTask)
	local params = records[dataTask.identifier]
	MultipleDownloader:_removeFileDownload(dataTask.identifier)

	if params and params.onFileTaskSuccess then
		params.onFileTaskSuccess(dataTask)
	end
end

local function onDataTaskSuccess(dataTask, bytes)
	local params = records[dataTask.identifier]
	MultipleDownloader:_removeFileDownload(dataTask.identifier)

	if params and params.onDataTaskSuccess then
		params.onDataTaskSuccess(dataTask, bytes)
	end
end

local function onTaskProgress(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
	local params = records[dataTask.identifier]
	if params and params.onTaskProgress then
		params.onTaskProgress(dataTask, bytesReceived, totalBytesReceived, totalBytesExpected)
	end
end

local function onTaskError(dataTask, errorCode, errorCodeInternal, errorMsg)
	local params = records[dataTask.identifier]
	MultipleDownloader:_removeFileDownload(dataTask.identifier)

	if params and params.onTaskError then
		params.onTaskError(dataTask, errorCode, errorCodeInternal, errorMsg)
	end
end

downloader:setOnFileTaskSuccess(onFileTaskSuccess)
downloader:setOnDataTaskSuccess(onDataTaskSuccess)
downloader:setOnTaskProgress(onTaskProgress)
downloader:setOnTaskError(onTaskError)
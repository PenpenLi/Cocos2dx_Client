ui_image_remote_t = class("ui_image_remote_t", NodeBase)

local fileUtils = cc.FileUtils:getInstance()

function ui_image_remote_t:ctor(urlImage, sizeImage, pathMask, rect9Mask, sizeMask)
	ui_image_remote_t.super.ctor(self)

	self.urlImage_ = urlImage
	self.sizeImage_ = sizeImage
	self.pathMask_ = pathMask
	self.rect9Mask_ = rect9Mask
	self.sizeMask_ = sizeMask

	self.identifier_ = cc.utils:getDataMD5Hash(self.urlImage_)
	self.storagePath_ = string.format("%simage_%s.jpg", device.writablePath, self.identifier_)

	self:download()
end

function ui_image_remote_t:download()
	if fileUtils:isFileExist(self.storagePath_) then
		--文件已存在
		self:makeRemoteImage()
	else
		--文件不存在,开始下载
        MultipleDownloader:createFileDownLoad(
                {
                    identifier = self.identifier_,
                    fileUrl = self.urlImage_,
                    storagePath = self.storagePath_,
                    onFileTaskSuccess = function(dataTask)
			        		self:makeRemoteImage()
			            end,
                    onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
			        		self:makeLocalImage()
			            end,
                }
            )
	end
end

function ui_image_remote_t:makeRemoteImage()
	local imageSprite = cc.Sprite:create(self.storagePath_)
    local size = imageSprite:getContentSize()
    local scale = self.sizeImage_.width / size.width
    imageSprite:setScale(scale)

    if self.pathMask_ then
	    local maskSprite = ccui.Scale9Sprite:create(self.rect9Mask_, self.pathMask_)
	    maskSprite:setContentSize(self.sizeMask_)

	    local clipingNode = cc.ClippingNode:create(maskSprite)
		clipingNode:setInverted(false)
		clipingNode:setAlphaThreshold(0.5)
		clipingNode:addChild(imageSprite)
		self:addChild(clipingNode)
    else
    	self:addChild(imageSprite)
    end
end

function ui_image_remote_t:makeLocalImage()

end

function ui_image_remote_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload(self.identifier_)
end
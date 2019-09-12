LocalVersions = class("LocalVersions")

LOCAL_MAIN_VERSION_KEY = "mainVersion"
LOCAL_MAIN_VERSION_PATH = "main"
LOCAL_VERSION_NONE = 0

local fileUtils = cc.FileUtils:getInstance()

function LocalVersions:setModuleVersion(modulename, version)
	LocalDataBase:setLocalData(modulename, version)
end

function LocalVersions:getModuleVersion(modulename)
	return LocalDataBase:getLocalData(modulename, LOCAL_VERSION_NONE)
end

function LocalVersions:checkOldVersion()
	local mainVersion = self:getModuleVersion(LOCAL_MAIN_VERSION_KEY)
	local configVersion = LocalConfig:getConfigVersion()
	if mainVersion == LOCAL_VERSION_NONE then
		self:setModuleVersion(LOCAL_MAIN_VERSION_KEY, configVersion)
	elseif mainVersion < configVersion then
		local mainPath = fileUtils:getWritablePath() .. LOCAL_MAIN_VERSION_PATH
		fileUtils:removeDirectory(mainPath)
		self:setModuleVersion(LOCAL_MAIN_VERSION_KEY, configVersion)
	end
end
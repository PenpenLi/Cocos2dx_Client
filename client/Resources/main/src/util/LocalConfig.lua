LocalConfig = class("LocalConfig")

local dataJson = cc.FileUtils:getInstance():getStringFromFile("config.json")

local dataLock = nil

if dataJson == "" then
	dataLock = {}
else
	dataLock = json.decode(dataJson)
end

function LocalConfig:getConfigUpdate()
	return dataLock.hotUpdate
end

function LocalConfig:getConfigVersion()
	return dataLock.version or 0
end

function LocalConfig:getLockSpreader()
	return dataLock.lockSpreader or 0
end

function LocalConfig:getLockData(key)
    local platform = cc.Application:getInstance():getTargetPlatform()
    if cc.PLATFORM_OS_ANDROID == platform then
	    local content = calljavaMethodS("getAppInstallExtras", {"InstallConversionData"})
	    if content ~= "" then
	    	local InstallConversionData = json.decode(content)

	    	for k, v in pairs(InstallConversionData) do
	    		dataLock[k] = v
	    	end
	    end
	end

	return dataLock[key]
end
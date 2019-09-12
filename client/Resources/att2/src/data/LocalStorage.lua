---模块名：
--      本地存储类
--
--模块介绍：
--      提供本地存储的相关操作
--
-------------------------------------------------------------------------------

module( "LocalStorage", package.seeall )

local LOCAL_DATA_KEY = "locate"

function init(self)
	self:openLocalData()
end

function openLocalData(self)
	LocalStorage:localStorageInit(string.format("%s%s.dat", cc.FileUtils:getInstance():getWritablePath(), LOCAL_DATA_KEY))

	local locate = LocalStorage:localStorageGetItem(LOCAL_DATA_KEY)
	if locate == "" then
		--未初始化
		self:saveLocalData()
	else
		--已初始化
		self.locate_ = serializable.unserialize(locate)
	end
end

function closeLocalData(self)
	LocalStorage:localStorageFree()
end

function saveLocalData(self)
	local locateStr = serializable.serialize(self.locate_)
	LocalStorage:localStorageSetItem(LOCAL_DATA_KEY, locateStr)
end

function setLocalData(self, key, value)
	self.locate_[key] = value

	self:saveLocalData()
end

function getLocalData(self, key, default)
	return self.locate_[key] or default
end


--底分
function setMusicVolume(self, volume)
	self:setLocalData("musicVolume", volume)
end

function getMusicVolume(self)
	return self.locate_.musicVolume or 0.5
end


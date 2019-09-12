LocalDataBase = class("LocalDataBase")

local LOCAL_DATA_KEY = "locate"

function LocalDataBase:openLocalData()
	LocalStorage:localStorageInit(string.format("%s%s.dat", device.writablePath, LOCAL_DATA_KEY))

	local locate = LocalStorage:localStorageGetItem(LOCAL_DATA_KEY)
	if locate == "" then
		--未初始化
		self.locate_ = {}
		self:saveLocalData()
	else
		--已初始化
		self.locate_ = serializable.unserialize(locate)
	end
end

function LocalDataBase:setLocalData(key, value)
	self.locate_[key] = value

	self:saveLocalData()
end

function LocalDataBase:getLocalData(key, default)
	return self.locate_[key] or default
end

function LocalDataBase:saveLocalData()
	local locateStr = serializable.serialize(self.locate_)
	LocalStorage:localStorageSetItem(LOCAL_DATA_KEY, locateStr)
end

function LocalDataBase:closeLocalData()
	LocalStorage:localStorageFree()
end

LocalDataBase:openLocalData()
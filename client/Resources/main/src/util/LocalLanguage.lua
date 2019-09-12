LocalLanguage = class("LocalLanguage")

local fileUtils = cc.FileUtils:getInstance()

local LANGUAGE_FILE_FORMAT = "main.src.language.%s.lua"
local DEFAULT_LANGUAGE_CODE = "vn"
local DEFAULT_LANGUAGE_FILE = string.format(LANGUAGE_FILE_FORMAT, DEFAULT_LANGUAGE_CODE)

local currentLanguage = string.format(LANGUAGE_FILE_FORMAT, device.language)
if not fileUtils:isFileExist(currentLanguage) then
	currentLanguage = DEFAULT_LANGUAGE_FILE
end

local dataLanguage = require_ex(currentLanguage)

function LocalLanguage:getLanguageString(key)
	return dataLanguage[key] or ""
end
module("gamesvr", package.seeall)

-------------解包-----------------
function onSystemMessage(buffObj)
	local mType = buffObj:readShort()
	local len = buffObj:readShort()
	local msg = buffObj:readString(len * 2)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SYSTEM_MESSAGE, msg)
end

-------------封包-----------------
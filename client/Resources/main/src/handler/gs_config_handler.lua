module("gamesvr", package.seeall)

--------------------解包-----------------
function onConfigRoom(buffObj)
	local tableCount = buffObj:readShort()
	local chairCount = buffObj:readShort()
	local serverType = buffObj:readShort()
	local serverRule = buffObj:readInt()

	global.g_mainPlayer:initRoomConfig(tableCount, chairCount, serverType, serverRule)
	print("接收到房间配置", tableCount, chairCount, serverType, serverRule)
end

function onConfigFinish(buffObj)
	print("房间配置接收成功")
end

--------------- 封包 --------------------
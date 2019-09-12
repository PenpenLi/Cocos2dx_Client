module( "gatesvr", package.seeall )

--------------- 解包 --------------------
function onAppUserStatus(buffObj)
	local serverId = buffObj:readShort()
	local serverName = buffObj:readString(64)
	local tableId = buffObj:readShort()
	local chairId = buffObj:readShort()
	local kindId = buffObj:readInt()

	if serverId == 501 and kindId == 501 then
		global.g_mainPlayer:setDeviceLogin(0, 0)
	else
		if chairId == -1 or (serverId == 0 and serverName == "") then
			return
		end

		global.g_mainPlayer:setAppLoginData(serverId, serverName, tableId, chairId, kindId)
	end
end

function onAppSitdown(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)

	if ret == 0 then
		--成功
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APP_SITDOWN_SUCCESS, desc)
	else
		--失败
		WarnTips.showTips(
				{
					text = desc,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onAppGetServerSuccess(buffObj)
	local kindId = buffObj:readShort()
	local nodeId = buffObj:readShort()
	local sortId = buffObj:readShort()
	local serverId = buffObj:readShort()
	local serverKind = buffObj:readShort()
	local serverType = buffObj:readShort()
	local serverLevel = buffObj:readShort()
	local serverPort = buffObj:readUShort()
	local cellScore = buffObj:readInt64()
	local enterScore = buffObj:readInt64()
	local serverRule = buffObj:readInt()
	local onlineCount = buffObj:readInt()
	local androidCount = buffObj:readInt()
	local onFullCount = buffObj:readInt()
	local serverUrl = buffObj:readString(64)
	local serverName = buffObj:readString(64)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APP_GET_SEVER_SUCCESS,
		{
			kindId = kindId,
			nodeId = nodeId,
			sortId = sortId,
			serverId = serverId,
			serverKind = serverKind,
			serverType = serverType,
			serverLevel = serverLevel,
			serverPort = serverPort,
			cellScore = cellScore,
			enterScore = enterScore,
			serverRule = serverRule,
			onlineCount = onlineCount,
			androidCount = androidCount,
			onFullCount = onFullCount,
			serverUrl = serverUrl,
			serverName = serverName
		})
end

function onAppGetServerFailure(buffObj)
	LoadingView.closeTips()

	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_b4e1e6fae7efdc3b"),
				style = WarnTips.STYLE_Y
			}
		)
end

--------------- 封包 --------------------
function sendAppSitdown(gameId, hallVer, socketId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_APP)
	buff:setSubCmd(pt_gate.SUB_APP_SITDOWN)
	buff:writeShort(gameId)
	buff:writeInt(hallVer)
	buff:writeChar(DeviceType)
	buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	buff:writeString(global.g_mainPlayer:getLoginAccount(), 64)
	buff:writeMD5(MachineUUID, 66)
	buff:writeString("", 24)
	buff:writeInt(socketId)

	netmng.sendGtData(buff)
end

function sendAppSitdownWX(gameId, hallVer, socketId, unionId, location)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_APP)
	buff:setSubCmd(pt_gate.SUB_APP_SITDOWN_WX)
	buff:writeShort(gameId)
	buff:writeInt(hallVer)
	buff:writeChar(DeviceType)
	buff:writeChar(1)
	buff:writeChar(WX_PLATFORM)
	buff:writeString(unionId, 66)
	buff:writeString(global.g_mainPlayer:getPlayerName(), 64)
	buff:writeString(global.g_mainPlayer:getPlayerName(), 32)
	buff:writeMD5(MachineUUID, 66)
	buff:writeString("", 24)
	buff:writeString(location, 64)
	buff:writeInt(socketId)

	netmng.sendGtData(buff)
end

function sendAppStandUp()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_APP)
	buff:setSubCmd(pt_gate.SUB_APP_STANDUP)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function sendAppGetServer(serverId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_APP)
	buff:setSubCmd(pt_gate.SUB_APP_GET_SERVER)
	buff:writeInt(serverId)

	netmng.sendGtData(buff)
end
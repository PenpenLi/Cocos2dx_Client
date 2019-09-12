module("gatesvr", package.seeall)

----------解包
function onHeartbeat(buffObj)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_KN_COMMAND)
	buff:setSubCmd(pt_gate.SUB_KN_DETECT_SOCKET)

	netmng.sendGtData(buff)
end

function addGateHeartbeatHandler()
	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = {
			[pt_gate.SUB_KN_DETECT_SOCKET] = gatesvr.onHeartbeat,
		}
end

function removeHeartbeatHandler()
	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = nil
end

function onCoinMBLogin(buffObj)
	local ret = buffObj:readInt()
	local desc = buffObj:readString(100)
	local playerId = buffObj:readInt()
	local deviceId = buffObj:readInt()
	local score = buffObj:readInt()

	if ret == 0 then
		global.g_mainPlayer:setDeviceLogin(deviceId, score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_LOGIN)

		addGateHeartbeatHandler()
	else
		WarnTips.showTips(
				{
					text = desc,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onCoinMBInfo(buffObj)
	local ret = buffObj:readInt()
	local desc = buffObj:readString(100)
	local playerId = buffObj:readInt()
	local deviceId = buffObj:readInt()
	local score = buffObj:readInt()

	if ret == 0 then
		global.g_mainPlayer:setDeviceLogin(deviceId, score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_INFO)
	else
		global.g_mainPlayer:cleanDeviceLogin()
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_LOST)

		removeHeartbeatHandler()
		gatesvr.sendInsureInfoQuery(true)
	end
end

function onCoinMBUpScore(buffObj)
	local ret = buffObj:readInt()
	local desc = buffObj:readString(100)
	local playerId = buffObj:readInt()
	local deviceId = buffObj:readInt()
	local score = buffObj:readInt()
	
	if ret == 0 then
		global.g_mainPlayer:setDeviceLogin(deviceId, score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_UPSCORE, ret)
	else
		sendCoinMBInfo()
		
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_LOST)

		removeHeartbeatHandler()

		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_452e02bc01db0445"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onCoinMBDownScore(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(100)
	local playerId = buffObj:readInt()
	local deviceId = buffObj:readInt()
	local score = buffObj:readInt()

	if ret == 0 then
		global.g_mainPlayer:cleanDeviceLogin()
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_DOWNSCORE)

		removeHeartbeatHandler()
		gatesvr.sendInsureInfoQuery(true)
	else
		sendCoinMBInfo()

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DEVICE_LOST)

		removeHeartbeatHandler()

		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_0a1074628bb1b35a"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

----------封包
function sendCoinMBLogin()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_COIN_DEVICE)
	buff:setSubCmd(pt_gate.SUB_COIN_MBLOGON)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(global.g_mainPlayer:getDeviceLoginId())

	netmng.sendGtData(buff)
end

function sendCoinMBInfo()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_COIN_DEVICE)
	buff:setSubCmd(pt_gate.SUB_COIN_MBINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(global.g_mainPlayer:getDeviceLoginId())

	netmng.sendGtData(buff)
end

function sendCoinMBUpScore(addScore)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_COIN_DEVICE)
	buff:setSubCmd(pt_gate.SUN_COIN_MBUPSCORE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(global.g_mainPlayer:getDeviceLoginId())
	buff:writeInt(addScore)

	netmng.sendGtData(buff)
end

function sendCoinMBDownScore()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_COIN_DEVICE)
	buff:setSubCmd(pt_gate.SUN_COIN_MBDOWNSCORE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(global.g_mainPlayer:getDeviceLoginId())

	netmng.sendGtData(buff)
end
module( "gatesvr", package.seeall )

--------------------解包-----------------------
function onScoreGet(buffObj)
	local orderId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local account = buffObj:readString(64)
	local spreaderId = buffObj:readInt()
	local scoreType = buffObj:readInt()
	local score = buffObj:readInt64()
	local msg = buffObj:readString(100)
	local time = buffObj:readString(40)

	if orderId == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SCORE_ORDER_EMPTY)
	else
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SCORE_ORDER_EXIST, orderId, playerId, account, spreaderId, scoreType, score, msg, time)
	end
end

function onScoreApply(buffObj)
	local orderId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local account = buffObj:readString(64)
	local spreaderId = buffObj:readInt()
	local scoreType = buffObj:readInt()
	local score = buffObj:readInt64()
	local msg = buffObj:readString(100)
	local time = buffObj:readString(40)
	local retCode = buffObj:readInt64()
	local desc = buffObj:readString(buffObj:getLength() - 236)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)

	if retCode == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SCORE_APPLY_SUCCESS)
	end
end

function onScoreApplyCancel(buffObj)
	local orderId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local retCode = buffObj:readInt64()
	local desc = buffObj:readString(buffObj:getLength() - 16)
	
	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)

	if retCode == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SCORE_CANCEL_SUCCESS)
	end
end

--------------------封包-----------------------
function sendScoreGet()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_SCORE_UPDOWN)
	buff:setSubCmd(pt_gate.SUB_SCORE_GET)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function sendScoreApply(applyType, password, score, msg)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_SCORE_UPDOWN)
	buff:setSubCmd(pt_gate.SUB_SCORE_ADD)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(applyType)
	buff:writeInt64(score)
	buff:writeMD5(password, 66)
	buff:writeString(msg, 100)

	netmng.sendGtData(buff)
end

function sendScoreApplyCancel(orderId, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_SCORE_UPDOWN)
	buff:setSubCmd(pt_gate.SUB_SCORE_DEL)
	buff:writeInt(orderId)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(password, 66)

	netmng.sendGtData(buff)
end
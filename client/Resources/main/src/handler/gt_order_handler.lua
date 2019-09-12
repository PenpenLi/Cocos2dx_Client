module("gatesvr", package.seeall)

--解包
function onWriteOrderResult(buffObj)
	local ret = buffObj:readInt()
	local order = buffObj:readString(64)
	local desc = buffObj:readString(buffObj:getLength() - 68)

	if ret == 0 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_WRITE_ORDER_SUCCESS, order)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

--封包
function sendWriteOrder(order, sharedId, orderAmount)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_MB_WRITE_ORDER)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeString(order, 64)
	buff:writeString(global.g_mainPlayer:getLoginAccount(), 64)
	buff:writeInt(sharedId)
	buff:writeInt(orderAmount)

	netmng.sendGtData(buff)
end
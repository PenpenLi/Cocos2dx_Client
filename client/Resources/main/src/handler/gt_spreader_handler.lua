module("gatesvr", package.seeall)

--------------------解包-----------------------
function onCompleteSpreader(buffObj)
	local ret = buffObj:readInt()
	local spreaderId = buffObj:readInt()
	local desc = buffObj:readString(256)
	local lottery = buffObj:readChar()
	local momo = buffObj:readString(30)

	if ret == 0 then
		global.g_mainPlayer:setSpreaderId(spreaderId)
		global.g_mainPlayer:setViMomo(momo)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS)

		if lottery == 1 then
			PopUpView.showPopUpView(ui_turntable_t, 0)
		end
	else
		WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
	end
end

function onCompleteSpreaderPassword(buffObj)
	local ret = buffObj:readInt()
	local spreaderId = buffObj:readInt()
	local desc = buffObj:readString(256)

	WarnTips.showTips(
		{
			text = desc,
			style = WarnTips.STYLE_Y
		}
	)

	if ret == 0 then
		global.g_mainPlayer:setSpreaderId(spreaderId)
		global.g_mainPlayer:setInsureEnabled(1)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS)
	end
end
--------------------封包-----------------------
function sendCompleteSpreader(spreaderId, spreaderAcc, eamil, phone)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_WX_INPUTSPRINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(spreaderId)
	buff:writeString(spreaderAcc, 64)
	buff:writeString(eamil, 40)
	buff:writeString(phone, 40)

	netmng.sendGtData(buff)
end

function sendCompleteSpreaderPassword(spreaderId, spreaderAcc, password,eamil)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_WX_INPUTSPRINFO2)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(password, 66)
	buff:writeInt(spreaderId)
	buff:writeString(spreaderAcc, 64)
	buff:writeString(eamil, 40)

	netmng.sendGtData(buff)
end
module("gatesvr", package.seeall)

local ignorePop = nil

--------------------解包--------------
function onInsureEnable(buffObj)
	local insureEnable = buffObj:readChar()
	local desc = buffObj:readString(buffObj:getLength() - 1)

	print("银行开通结果:", insureEnable, desc)
	global.g_mainPlayer:setInsureEnabled(insureEnable)
	if insureEnable == 1 then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BANK_OPEN_SUCCESS)
	else
		WarnTips.showTips({
				text = desc,
				style = WarnTips.STYLE_Y
			})
	end
end

function onUserInsureInfo(buffObj)
	local enableTransfer = buffObj:readChar()
	local revenueTake = buffObj:readShort()
	local revenueTransfer = buffObj:readShort()
	local revenueTransferMember = buffObj:readShort()
	local serverId = buffObj:readShort()
	local userScore = buffObj:readInt64()
	local userInsure = buffObj:readInt64()
	local transferRequire = buffObj:readInt64()
	local todayCanGet = buffObj:readInt()
	local tomorrowCanGet = buffObj:readInt()

	print("银行信息:", enableTransfer, revenueTake, revenueTransfer, revenueTransferMember,
		serverId, userScore, userInsure, transferRequire, todayCanGet, tomorrowCanGet)

	global.g_mainPlayer:setPlayerScore(userScore)
	global.g_mainPlayer:setInsureMoney(userInsure)
	global.g_mainPlayer:setRebateToday(todayCanGet)
	global.g_mainPlayer:setRebateTomorrow(tomorrowCanGet)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)

	if ignorePop then
		ignorePop = nil
	else
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BANK_INFO, enableTransfer, revenueTake, revenueTransfer, revenueTransferMember,
			serverId, userScore, userInsure, transferRequire)
	end
end

function onUserInsureSuccess(buffObj)
	local playerId = buffObj:readInt()
	local userScore = buffObj:readInt64()
	local userInsure = buffObj:readInt64()
	local desc = buffObj:readString(buffObj:getLength() - 20)

	WarnTips.showTips({
			text = desc,
			style = WarnTips.STYLE_Y
		})

	global.g_mainPlayer:setPlayerScore(userScore)
	global.g_mainPlayer:setInsureMoney(userInsure)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_BANK_SUCCESS, userScore, userInsure)
end

function onUserInsureFailure(buffObj)
	local errcode = buffObj:readInt()
	local errmsg = buffObj:readString(buffObj:getLength() - 4)

	WarnTips.showTips({
			text = errmsg,
			style = WarnTips.STYLE_Y
		})
end

--------------------封包--------------
function sendEnableInsure(insurePass)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_ENABLE_INSURE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	buff:writeMD5(insurePass, 66)
	buff:writeMD5(MachineUUID, 66)

	netmng.sendGtData(buff)
end

function sendWXEnableInsure(unionId, loginPass, insurePass, location)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_ENABLE_INSURE_WX)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeString(unionId, 66)
	buff:writeMD5(loginPass, 66)
	buff:writeMD5(insurePass, 66)
	buff:writeMD5(MachineUUID, 66)
	buff:writeString(location, 64)

	netmng.sendGtData(buff)
end

function sendInsureInfoQuery(ignore)
	if global.g_mainPlayer:isVisitorLogin() then
		return
	end

	ignorePop = ignore

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_QUERY_INSURE_INFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end

	netmng.sendGtData(buff)
end

function sendInsureSaveScore(saveScore)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_SAVE_SCORE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt64(saveScore)
	buff:writeMD5(MachineUUID, 66)

	netmng.sendGtData(buff)
end

function sendInsureTaskScore(takeScore, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_TAKE_SCORE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt64(takeScore)
	buff:writeMD5(password, 66)
	buff:writeMD5(MachineUUID, 66)

	netmng.sendGtData(buff)
end
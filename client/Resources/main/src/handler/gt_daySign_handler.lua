module("gatesvr", package.seeall)

local count = 0
local series = nil
local todaySign = nil
local rewards = nil
local condition = nil
local score = nil
local takeTimes = nil

--------------------解包--------------
function onCheckInInfo(buffObj)
	LoadingView.closeTips()
	
	series = buffObj:readShort()
	todaySign = buffObj:readChar()
	rewards = {}
	for i = 1, 7 do
		table.insert(rewards, buffObj:readInt64())
	end
	print("收到签到信息:", series, todaySign, rewards)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CHECK_INFO, series, todaySign, rewards)

	-- count = count + 1
	-- if count >= 2 then
	-- 	count = 0
	-- 	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_REWARDS_INFO, series, todaySign, rewards, condition, score, takeTimes)
	-- end
end

function onCheckInResult(buffObj)
	local ret = buffObj:readChar()
	local score = buffObj:readInt64()
	local content = buffObj:readString(buffObj:getLength() - 9)

	print("收到签到结果:", ret, score, content)
	if ret == 1 then
		global.g_mainPlayer:setPlayerScore(score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_DAYSIGN_SUCCESS)
	else
		WarnTips.showTips({
				text = content,
				style = WarnTips.STYLE_Y
			})
	end
end

function onBaseEnsureParam(buffObj)
	condition = buffObj:readInt64()
	score = buffObj:readInt64()
	takeTimes = buffObj:readChar()
	print("收到低保信息:", condition, score, takeTimes)
	-- count = count + 1
	-- if count >= 2 then
	-- 	count = 0
	-- 	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_REWARDS_INFO, series, todaySign, rewards, condition, score, takeTimes)
	-- end
end

function onBaseEnsureResult(buffObj)
	local ret = buffObj:readChar()
	local score = buffObj:readInt64()
	local content = buffObj:readString(buffObj:getLength() - 9)

	print("收到领取低保结果:", ret, score, content)
	if ret == 1 then
		global.g_mainPlayer:setPlayerScore(score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_TAKE_BASEENSURE_SUCCESS)
	end
	WarnTips.showTips({
			text = content,
			style = WarnTips.STYLE_Y
		})
end

--------------------封包--------------
function sendCheckInQuery()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_CHECKIN_QUERY)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end

	netmng.sendGtData(buff)
end

function sendCheckInDone()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_CHECKIN_DONE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeString(MachineUUID, 66)

	netmng.sendGtData(buff)
end

function sendBaseEnsureQuery()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_BASEENSURE_LOAD)

	netmng.sendGtData(buff)
end

function sendBaseEnsureTake()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_BASEENSURE_TAKE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeString(MachineUUID, 66)

	netmng.sendGtData(buff)
end
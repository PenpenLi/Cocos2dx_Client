module( "gatesvr", package.seeall )

local applyServerId = nil
local shared_scene = nil
local email_take = nil

-----------------------解包-----------------------
function onServerList(buffObj)
	print("接收到房间列表", buffObj:getLength())
	local len = math.floor(buffObj:getLength() / 176)
	for i = 1, len do
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

		global.g_mainPlayer:addRoomToList(kindId, nodeId, sortId, serverId, serverKind, serverType, serverLevel, serverPort, cellScore, enterScore, serverRule, onlineCount, androidCount, onFullCount, serverUrl, serverName)
	end
end

function onMatchList(buffObj)
	print("接收到比赛列表", buffObj:getLength())
	local nowDate = os.date("*t")
	local len = math.floor(buffObj:getLength() / 123)
	for i = 1, len do
		local serverId = buffObj:readShort()
		local matchId = buffObj:readInt()
		local matchNo = buffObj:readInt()
		local matchType = buffObj:readChar()
		local matchName = buffObj:readString(64)
		local memberOrder = buffObj:readChar()
		local matchFeeType = buffObj:readChar()
		local matchFee = buffObj:readInt64()
		local startUserCount = buffObj:readShort()
		local matchPlayCount = buffObj:readShort()
		local rewardCount = buffObj:readShort()
		local startTime = {}
		startTime.year = buffObj:readShort()
		startTime.month = buffObj:readShort()
		startTime.dayofweek = buffObj:readShort()
		startTime.day = buffObj:readShort()
		startTime.hour = buffObj:readShort()
		startTime.minute = buffObj:readShort()
		startTime.second = buffObj:readShort()
		startTime.milliseconds = buffObj:readShort()

		local todayStart = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = startTime.hour,
				min = startTime.minute,
				sec = startTime.second
			}
		)

		local lastStart = os.time(
			{
				year = startTime.year,
				month = startTime.month,
				day = startTime.day,
				hour = startTime.hour,
				min = startTime.minute,
				sec = startTime.second
			}
		)

		local endTime = {}
		endTime.year = buffObj:readShort()
		endTime.month = buffObj:readShort()
		endTime.dayofweek = buffObj:readShort()
		endTime.day = buffObj:readShort()
		endTime.hour = buffObj:readShort()
		endTime.minute = buffObj:readShort()
		endTime.second = buffObj:readShort()
		endTime.milliseconds = buffObj:readShort()

		local todayEnd = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = endTime.hour,
				min = endTime.minute,
				sec = endTime.second
			}
		)

		local lastEnd = os.time(
			{
				year = endTime.year,
				month = endTime.month,
				day = endTime.day,
				hour = endTime.hour,
				min = endTime.minute,
				sec = endTime.second
			}
		)

		if lastEnd < todayEnd then
			startTime.timestamp = lastStart
			endTime.timestamp = lastEnd
		else
			startTime.timestamp = todayStart
			endTime.timestamp = todayEnd
		end

		global.g_mainPlayer:addMatchToList(serverId, matchId, matchNo, matchType, matchName, memberOrder, matchFeeType,
			matchFee, startUserCount, matchPlayCount, rewardCount, startTime, endTime)
	end
end

function onListFinish(buffObj)
	-- netmng.g_gt_sock:close()
end

function onConfigList(buffObj)

end

function onProcessList(buffObj)

end

function onPropList(buffObj)

end

function onApplyList(buffObj)

end

function onOperateSuccess(buffObj)
	local len = buffObj:getLength()
	local code = buffObj:readInt64()
	local desc = buffObj:readString(len - 8)

	if global.g_modify_type == MODIFY_LOGIN_PASSWORD then
		--修改登录密码
		global.g_mainPlayer:setLocalData("password", global.g_modify_value)
	elseif global.g_modify_type == MODIFY_INSURE_PASSWORD then
		--修改保险密码
	elseif global.g_modify_type == MODIFY_LOCK_MACHINE then
		--修改绑定机器
		global.g_mainPlayer:setMachineLock(global.g_modify_value)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_LOCK_MACHINE_SUCCESS)
	end

	TextTipsUtils:showTips(desc)
end

function onOperateFailure(buffObj)
	local len = buffObj:getLength()
	local code = buffObj:readInt64()
	local desc = buffObj:readString(len - 8)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
end

function onMatchSignUpInfo(buffObj)
	print("收到比赛报名记录")
	local len = buffObj:getLength() / 10
	for i = 1, len do
		local serverId = buffObj:readShort()
		local matchId = buffObj:readInt()
		local matchNo = buffObj:readInt()
		global.g_mainPlayer:addMatchSignUp(serverId, matchId, matchNo)
	end
end

function onMatchSignUpResult(buffObj)
	local signUp = buffObj:readChar()
	local ret = buffObj:readChar()
	local desc = buffObj:readString(buffObj:getLength() - 2)

	print("收到报名结果:", signUp, ret, desc)

	if ret == 1 then
		local md = global.g_mainPlayer:getMatchData(applyServerId)
		global.g_mainPlayer:addMatchSignUp(md.serverId, md.matchId, md.matchNo)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APPLY_MATCH_SUCCESS, md.serverId)
	else
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_APPLY_MATCH_FAILED, applyServerId)

		WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
	end
end

function onBindWechatResult(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)

	if ret == 0 then
		global.g_mainPlayer:setLogin3rdBind(1)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_3RD_BIND_SUCCESS)
	end
end

function onQueryTurntable(buffObj)
	local ret = buffObj:readInt()
	if ret == 1 then
		--启动
		PopUpView.showPopUpView(ui_turntable_t, shared_scene)
	end
end

function onTurntableLottery(buffObj)
	LoadingView.closeTips()

	local ret = buffObj:readInt()
	local desc = buffObj:readString(256)
	local lottery = buffObj:readInt()
	local score = buffObj:readInt64()
	local insure = buffObj:readInt64()
	local orderId = buffObj:readInt()

	print("收到抽奖结果:", ret, desc, lottery, score, insure, orderId)

	if ret == 0 then
		global.g_mainPlayer:setPlayerScore(score)
		global.g_mainPlayer:setInsureMoney(insure)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_LOTTERY_RESULT, lottery, orderId)
	else
		WarnTips.showTips(
				{
					text = desc,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onSpreaderInfo(buffObj)
	local spreader = buffObj:readString(64)
	global.g_mainPlayer:setSpreaderAcc(spreader)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GET_SPREADER_SUCCESS)
end

function onGetSystemName(buffObj)
	local systemName = buffObj:readString(100)
	global.g_mainPlayer:setSystemName(systemName)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_GET_SYSTEM_NAME_SUCCESS)
end

function onGetWxFace(buffObj)
	local playerId = buffObj:readInt()
	local faceUrl = buffObj:readString(500)
	
	global.g_mainPlayer:cacheHead3rd(playerId, faceUrl)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GET_WECHAT_FACE, playerId, faceUrl)
end

function onRequestMatchRank(buffObj)
	LoadingView.closeTips()

	local t = {}
	for i = 1, 10 do
		local rank = buffObj:readInt()
		local score = buffObj:readInt64()
		local playerId = buffObj:readInt()
		local prize = buffObj:readInt()
		local name = buffObj:readString(64)

		t[rank] = {rank = rank, score = score, playerId = playerId, prize = prize, name = name}
	end

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_REQUEST_MATCH_RANK, t)
end

function onShareObtain(buffObj)
	LoadingView.closeTips()

	local playerId = buffObj:readInt()
	local prize = buffObj:readInt()
	local score = buffObj:readInt()

	if prize > 0 then
		global.g_mainPlayer:setPlayerScore(score)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)

		PopUpView.showPopUpView(ui_share_obtain_t, prize)
	end
end

function onTakeEmailReward(buffObj)
	LoadingView.closeTips()

	local retcode = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)

	if retcode == 0 then
		gatesvr.sendInsureInfoQuery(true)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_TAKE_EMAIL_REWARD_SUCCESS, email_take)
	else
		WarnTips.showTips(
				{
					text = desc,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function onGetUserInfoNew(buffObj)
	LoadingView.closeTips()

	removeHeartbeatHandler()

	local playerId = buffObj:readInt()
	local spreader = buffObj:readInt()
	local realname = buffObj:readString(100)
	local momo = buffObj:readString(100)
	local zalopay = buffObj:readString(100)
	local extra1 = buffObj:readString(100)
	local extra2 = buffObj:readString(100)
	local extra3 = buffObj:readString(100)
	print("获取绑定信息:", spreader, realname, momo, zalopay, extra1, extra2, extra3)
	global.g_mainPlayer:setDataBind(spreader, realname, momo, zalopay, extra1, extra2, extra3)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GET_DATA_BIND_SUCCESS)
end

function onUserInfoUpdateNew(buffObj)
	LoadingView.closeTips()

	local retcode = buffObj:readInt()
	local desc = buffObj:readString(256)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
	
	if retcode == 0 then
		local playerId = buffObj:readInt()
		local spreader = buffObj:readInt()
		local realname = buffObj:readString(100)
		local momo = buffObj:readString(100)
		local zalopay = buffObj:readString(100)
		local extra1 = buffObj:readString(100)
		local extra2 = buffObj:readString(100)
		local extra3 = buffObj:readString(100)
		print("修改绑定信息:", spreader, realname, momo, zalopay, extra1, extra2, extra3)
		global.g_mainPlayer:setDataBind(spreader, realname, momo, zalopay, extra1, extra2, extra3)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS)
	end

end

-----------------------封包-----------------------
--获取微信头像
function sendGetWxFace(dwUserID)	
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_GETWXFACE)
	buff:writeInt(dwUserID)
	netmng.sendGtData(buff)
end

--设置微信头像（没有返回）
function sendSetWxFace(FaceUrl)	
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_SETWXFACE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeString(FaceUrl,500)
	netmng.sendGtData(buff)
end

function sendModifyLoginPassword(playerId, opassword, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_MODIFY_LOGON_PASS)
	buff:writeInt(playerId)
	buff:writeMD5(password, 66)
	buff:writeMD5(opassword, 66)

	global.g_modify_type = MODIFY_LOGIN_PASSWORD
	global.g_modify_value = password

	netmng.sendGtData(buff)
end

function sendModifyInsurePassword(playerId, opassword, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_MODIFY_INSURE_PASS)
	buff:writeInt(playerId)
	buff:writeMD5(password, 66)
	buff:writeMD5(opassword, 66)

	global.g_modify_type = MODIFY_INSURE_PASSWORD
	global.g_modify_value = password

	netmng.sendGtData(buff)
end

function sendMatchSignUp(serverId, matchId, matchNo)
	applyServerId = serverId

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_MATCH_SIGNUP)
	buff:writeShort(serverId)
	buff:writeInt(matchId)
	buff:writeInt(matchNo)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	buff:writeMD5(MachineUUID, 66)

	netmng.sendGtData(buff)
end

function sendBindWechat(unionId)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_BIND_WX)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	buff:writeChar(WX_PLATFORM)
	buff:writeString(unionId, 66)

	netmng.sendGtData(buff)
end

function sendQueryTurntable(scene)
	shared_scene = scene

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_WX_SHAREINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeInt(scene)

	netmng.sendGtData(buff)
end

function sendTurntableLottery(scene)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_WX_GETPRICE)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	if global.g_mainPlayer:isLogin3rdAvailable() then
		local data = global.g_mainPlayer:getLoginData3rd()
		buff:writeString(data.userid, 66)
	else
		buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	end
	buff:writeInt(scene)

	netmng.sendGtData(buff)
end

function sendGetSpreaderInfo()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_WX_GETSPRINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function sendGetSystemName()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_USER_GETSYSNAME)
	buff:writeInt(0)

	netmng.sendGtData(buff)
end

function sendRequestMatchRank()
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_GETMATCHRANDLIST)

	netmng.sendGtData(buff)
end

function sendShareObtain(shareType)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_C_USER_WX_SHAREINFO)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(shareType)

	netmng.sendGtData(buff)
end

function sendTakeEmailReward(emailId)
	email_take = emailId

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_GP_USER_SERVICE)
	buff:setSubCmd(pt_gate.SUB_GP_MATCHPRICEGET)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(emailId)

	netmng.sendGtData(buff)
end

function sendGetUserInfoNew()
	addGateHeartbeatHandler()
	print("请求绑定信息")
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_USERINFONEW)
	buff:writeInt(global.g_mainPlayer:getPlayerId())

	netmng.sendGtData(buff)
end

function sendUserInfoUpdateNew(spreader, realname, momo, zalopay, extra1, extra2, extra3)
	print("发送修改绑定信息:", spreader, realname, momo, zalopay, extra1, extra2, extra3)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_PAIMAIHANG)
	buff:setSubCmd(pt_gate.SUB_PMH_USERINFONEW_MODIFY)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(spreader)
	buff:writeString(realname, 100)
	buff:writeString(momo, 100)
	buff:writeString(zalopay, 100)
	buff:writeString(extra1, 100)
	buff:writeString(extra2, 100)
	buff:writeString(extra3, 100)

	netmng.sendGtData(buff)
end
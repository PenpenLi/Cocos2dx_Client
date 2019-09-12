module( "gamesvr", package.seeall )

local roomList = {}
local matchList = {}

--------------------解包-----------------
function onLoginForRoomListSuccess(buffObj)
	LoadingView.closeTips()

	print("登录获取房间成功")
	local faceId = buffObj:readShort()
	local sex = buffObj:readChar()
	local customId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local gameId = buffObj:readInt()
	local exp = buffObj:readInt()
	local loveLiness = buffObj:readInt()
	local wxBind = buffObj:readInt()
	local spreaderId = buffObj:readInt()
	local account = buffObj:readString(64)
	local name = buffObj:readString(64)
	local dynamicPass = buffObj:readString(66)
	local score = buffObj:readInt64()
	local ingot = buffObj:readInt64()
	local insure = buffObj:readInt64()
	local beans = buffObj:readInt64()
	local insureEnabled = buffObj:readChar()
	local momo = buffObj:readString(30)
	local ext = {}
	for i = 1, 10 do
		ext[i] = buffObj:readChar() 
	end

	global.g_mainPlayer:initPlayerData(spreaderId, faceId, sex, customId, playerId, gameId, exp, loveLiness, wxBind, name, dynamicPass, score, ingot, insure, beans, insureEnabled, momo, ext)
	global.g_mainPlayer:initRoomList()
	global.g_mainPlayer:initRoomTable()
	global.g_mainPlayer:initRoomUser()
end

function onLoginForRoomListFailed(buffObj)
	LoadingView.closeTips()

	local errorCode = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_265c32ae9d148d43") .. desc,
				style = WarnTips.STYLE_Y
			}
		)
end

function onLoginForRoomListFinish(buffObj)
	TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_9b1fa58fa3c73459"))
end

function onLoginForRoomAgain(buffObj)
	TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_16fa812396aa3f35"))
end

function onRoomList(buffObj)
	print("获取房间列表", buffObj:getLength())
	local len = math.floor(buffObj:getLength() / 176)
	local gameId = global.g_mainPlayer:getCurrentGameId()
	for i = 1, len do
		local kindId = buffObj:readShort()
		if gameId == kindId then
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

			table.insert(roomList, {
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
						serverName = serverName,
					}
				)
			-- global.g_mainPlayer:addRoomToList(kindId, nodeId, sortId, serverId, serverKind, serverType, serverLevel, serverPort, cellScore, enterScore, serverRule, onlineCount, androidCount, onFullCount, serverUrl, serverName)
		end
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

		table.insert(matchList, {
					serverId = serverId,
					matchId = matchId,
					matchNo = matchNo,
					matchType = matchType,
					matchName = matchName,
					memberOrder = memberOrder,
					matchFeeType = matchFeeType,
					matchFee = matchFee,
					startUserCount = startUserCount,
					matchPlayCount = matchPlayCount,
					rewardCount = rewardCount,
					startTime = startTime,
					endTime = endTime,
				}
			)

		-- global.g_mainPlayer:addMatchToList(serverId, matchId, matchNo, matchType, matchName, memberOrder, matchFeeType,
		-- 	matchFee, startUserCount, matchPlayCount, rewardCount, startTime, endTime)
	end
end

function onListFinish(buffObj)
	LoadingView.closeTips()
	
	--完成接收房间列表
	global.g_mainPlayer:initRoomList()
	global.g_mainPlayer:initRoomTable()
	global.g_mainPlayer:initRoomUser()

	for k, v in pairs(roomList) do
		global.g_mainPlayer:addRoomToList(v.kindId, v.nodeId, v.sortId, v.serverId, v.serverKind, v.serverType, v.serverLevel, v.serverPort, v.cellScore, v.enterScore, v.serverRule, v.onlineCount, v.androidCount, v.onFullCount, v.serverUrl, v.serverName)
	end

	for k, v in pairs(matchList) do
		global.g_mainPlayer:addMatchToList(v.serverId, v.matchId, v.matchNo, v.matchType, v.matchName, v.memberOrder, v.matchFeeType, v.matchFee, v.startUserCount, v.matchPlayCount, v.rewardCount, v.startTime, v.endTime)
	end

	print("接收到比赛列表完成", buffObj:getLength())

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	if global.g_game_ext_type == 1 then
		--比赛房
		-- local selectLevel = createObj(ui_selectLevel_h_match_t, gameId)
		-- replaceScene(selectLevel:getCCScene(), selectLevel)
		replaceScene(SelectMatchScene, TRANS_CONST.TRANS_SCALE, gameId)
	elseif global.g_mainPlayer:isMatchRoomExist() and gameId == 200 then
		--选择房间类型
		-- local selectMode = createObj(ui_selectMode_t, gameId)
		-- replaceScene(selectMode:getCCScene(), selectMode)
		replaceScene(SelectModeScene, TRANS_CONST.TRANS_SCALE, gameId)
	elseif cfg.style == GameStyleVertical then
		-- local selectLevel = createObj(ui_selectLevel_v_t, gameId)
		-- replaceScene(selectLevel:getCCScene(), selectLevel)
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)
	elseif cfg.style == GameStyleHorizontal then
		-- local selectLevel = createObj(ui_selectLevel_v_t, gameId)
		-- replaceScene(selectLevel:getCCScene(), selectLevel)
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)
	end
end

function onHeartbeat(buffObj)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_KN_COMMAND)
	buff:setSubCmd(pt_game.SUB_KN_DETECT_SOCKET)

	netmng.sendGsData(buff)
end

function onLoginRoomSuccess(buffObj)
	print("登录房间成功")
	local playerId = buffObj:readInt()
end

function onLoginRoomFailed(buffObj)
	LoadingView.closeTips()

	local errorCode = buffObj:readInt()
	local desc = buffObj:readString(buffObj:getLength() - 4)

	WarnTips.showTips(
			{
				text = desc,
				style = WarnTips.STYLE_Y
			}
		)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_LOGIN_ROOM_FAILED)
end

function onRoomUserCome(buffObj)
	print("收到进入房间")
	local gameId = buffObj:readInt()
	local playerId = buffObj:readInt()
	local faceId = buffObj:readShort()
	local customId = buffObj:readInt()
	local sex = buffObj:readChar()
	local vipLevel = buffObj:readChar()
	local tableId = buffObj:readShort()
	local chairId = buffObj:readShort()
	local userState = buffObj:readChar()
	local score = buffObj:readInt64()
	local ingot = buffObj:readInt64()
	local winCount = buffObj:readInt()
	local lostCount = buffObj:readInt()
	local drawCount = buffObj:readInt()
	local fleeCount = buffObj:readInt()
	local exp = buffObj:readInt()
	local nickname = nil
	local remain = buffObj:getLength() - 57
	while remain >= 4 do
		local size = buffObj:readShort()
		local desc = buffObj:readShort()
		remain = remain - 4
		if desc == 0 then
			break
		elseif desc == 10 then
			nickname = buffObj:readString(size)
			remain = remain - size
		end
	end

	print(playerId, nickname, tableId, chairId)

	if playerId == global.g_mainPlayer:getPlayerId() then
		global.g_mainPlayer:setPlayerScore(score)
	end

	global.g_mainPlayer:addRoomUser(gameId, playerId, faceId, customId, sex, vipLevel, tableId, chairId, userState, score, ingot, winCount, lostCount, drawCount, fleeCount, exp, nickname)

	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_COME, playerId)
end

function onRoomUserScore(buffObj)
	print("用户分数")
	local playerId = buffObj:readInt()
	local score = buffObj:readInt64()
	local winCount = buffObj:readInt()
	local lostCount = buffObj:readInt()
	local drawCount = buffObj:readInt()
	local fleeCount = buffObj:readInt()
	local exp = buffObj:readInt()

	print(playerId, score, winCount, lostCount, drawCount, fleeCount, exp)
	global.g_mainPlayer:updateRoomUserData(playerId, score, winCount, lostCount, drawCount, fleeCount, exp)

	if playerId == global.g_mainPlayer:getPlayerId() then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)
	end
end

function onRoomUserStatus(buffObj)
	print("用户状态变更")
	local playerId = buffObj:readInt()
	local tableId = buffObj:readShort()
	local chairId = buffObj:readShort()
	local status = buffObj:readChar()

	print(playerId == global.g_mainPlayer:getPlayerId(), playerId, tableId, chairId, status)

	local pd = global.g_mainPlayer:getRoomPlayer(playerId)
	if not pd then
		return
	end

	local oTableId = pd.tableId
	local oChairId = pd.chairId
	
	if status == ROOM_USER_NULL then
		--用户离开房间
		if global.g_mainPlayer:isPlayerInTable(playerId) then
			--从桌子上移除
			global.g_mainPlayer:removeUserFromTable(playerId)
		end
		--从房间移除
		global.g_mainPlayer:removeRoomUser(playerId)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_LEAVE, playerId, oTableId, oChairId, status)
	elseif status == ROOM_USER_FREE then
		--用户空闲
		if global.g_mainPlayer:isPlayerInTable(playerId) then
			--从桌子上移除
			global.g_mainPlayer:removeUserFromTable(playerId)
		end
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_FREE, playerId, oTableId, oChairId, status)
	elseif status == ROOM_USER_SIT then
		--用户坐下
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)
		global.g_mainPlayer:sitdownRoom(playerId, tableId, chairId)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_SITDOWN, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_READY then
		--用户准备
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)
		global.g_mainPlayer:sitdownRoom(playerId, tableId, chairId)
		
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_READY, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_LOOKON then
		--用户旁观
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_LOOKON, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_PLAY then
		--用户游戏
		if not global.g_mainPlayer:isPlayerInTable(playerId) then
			--坐下到桌子
			global.g_mainPlayer:sitdownRoom(playerId, tableId, chairId)
		end
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_PLAY, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_OFFLINE then
		--用户掉线
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_OFFLINE, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_QUEUE then
		--用户排队
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)

		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_QUEUE, playerId, tableId, chairId, status)
	elseif status == ROOM_USER_LEAVE then
		--用户离开
		global.g_mainPlayer:updateRoomUserStatus(playerId, tableId, chairId, status)
		
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_QUIT, playerId, tableId, chairId, status)
	end
end

function onRoomUserSitFailed(buffObj)
	LoadingView.closeTips()

	local errCode = buffObj:readInt()
	local errStr = buffObj:readString(buffObj:getLength() - 4)
	
	WarnTips.showTips(
			{
				text = errStr,
				style = WarnTips.STYLE_Y
			}
		)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_SITDOWN_FAILED)
end

function onRoomUserWaitDistrubute(buffObj)
	LoadingView.closeTips()
	
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_USER_WAIT_DISTRUBUTE)
end

function onLoginRoomFinished(buffObj)
	LoadingView.closeTips()
	
	print("登录房间完成")
end

function onRoomTableInfo(buffObj)
	print("桌子信息")
	local tableCount = buffObj:readShort()
	for i = 1, tableCount do
		local lock = buffObj:readChar()
		local status = buffObj:readChar()
		local cellScore = buffObj:readInt()

		if i <= global.g_mainPlayer:getConfigTableCount() then
			global.g_mainPlayer:addRoomTable(i - 1, lock, status, cellScore)
		end
	end

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	if not cfg then return end
	
	if global.g_modify_type == 100 then
		global.g_modify_type = nil
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_LOGIN_ROOM)
	elseif global.g_mainPlayer:isInAvoidCheatRoom() then
		-- require_ex(string.format("%s.src.ui.selectLevel.ui_match_room_t", cfg.path))

		-- local matchRoomUI = createObj(ui_match_room_t)
		-- replaceScene(matchRoomUI:getCCScene(), matchRoomUI)
	elseif cfg.style == GameStyleVertical then
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_LOGIN_ROOM)
	elseif cfg.style == GameStyleHorizontal then
		-- local handlerId = nil
		-- handlerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
		-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handlerId)

		-- 		local selectTable = createObj(ui_selectTable_t)
		-- 		replaceScene(selectTable:getCCScene(), selectTable)
		-- end, 0.5, false)
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_ROOM_LOGIN_ROOM)
	end
end

function onRoomTableStatus(buffObj)
	local tableId = buffObj:readShort()
	local lock = buffObj:readChar()
	local playStatus = buffObj:readChar()
	local cellScore = buffObj:readInt()
	print("桌子状态:", tableId, lock, playStatus, cellScore)
end

function onUpdateNotify(buffObj)
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_02f0de8efa765208"),
				style = WarnTips.STYLE_Y
			}
		)
end
--------------- 封包 --------------------
function sendLoginForRoomList(gameId)
	global.g_mainPlayer:setCurrentGameId(gameId)

	-- local buff = sendBuff:new()

	-- local loginWay = global.g_mainPlayer:getLoginWay()
	-- if loginWay == LOGIN_WAY.VISITOR_LOGIN then
	-- 	--游客方式
	-- 	buff:setMainCmd(pt_game.MDM_MB_LOGON)
	-- 	buff:setSubCmd(pt_game.SUB_MB_LOGON_VISITOR)
	-- 	buff:writeShort(gameId)
	-- 	buff:writeInt(PlazaVersion)
	-- 	buff:writeChar(DeviceType)
	-- elseif loginWay == LOGIN_WAY.ACCOUNT_LOGIN then
	-- 	--帐号方式
	-- 	buff:setMainCmd(pt_game.MDM_MB_LOGON)
	-- 	buff:setSubCmd(pt_game.SUB_MB_LOGON_ACCOUNTS)
	-- 	buff:writeShort(gameId)
	-- 	buff:writeInt(PlazaVersion )
	-- 	buff:writeChar(DeviceType)
	-- 	buff:writeMD5(global.g_mainPlayer:getLoginPassword(), 66)
	-- 	buff:writeString(global.g_mainPlayer:getLoginAccount(), 64)
	-- 	buff:writeMD5(MachineUUID, 66)
	-- 	buff:writeString("", 24)
	-- 	buff:writeChar(WX_PLATFORM)
	-- elseif loginWay == LOGIN_WAY.ONE_KEY_LOGIN then
	-- 	--一键方式
	-- 	local location = global.g_mainPlayer:getLocationCity()
	-- 	buff:setMainCmd(pt_gate.MDM_MB_LOGON)
	-- 	buff:setSubCmd(pt_gate.SUB_MB_ONE_KEY_LOGIN)
	-- 	buff:writeShort(gameId)
	-- 	buff:writeInt(PlazaVersion)
	-- 	buff:writeChar(DeviceType)
	-- 	buff:writeMD5(MachineUUID, 66)
	-- 	buff:writeMD5(MachineId, 66)
	-- 	buff:writeString(location, 64)
	-- 	buff:writeChar(WX_PLATFORM)
	-- 	buff:writeInt(getLockSpreader())
	-- end

	-- netmng.sendGsData(buff)

	roomList = {}
	matchList = {}

	local buff = sendBuff:new()
	buff:setMainCmd(pt_gate.MDM_MB_SERVER_LIST)
	buff:setSubCmd(pt_gate.SUB_MB_LIST_KIND)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeInt(gameId)

	netmng.sendGsData(buff)
end

function sendLoginRoom(password)
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]

	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_LOGON)
	buff:setSubCmd(pt_game.SUB_GR_LOGON_MOBILE)
	buff:writeShort(global.g_mainPlayer:getCurrentGameId())
	buff:writeInt(cfg.version)
	buff:writeChar(DeviceType)
	buff:writeShort(289)
	buff:writeShort(3)
	buff:writeInt(global.g_mainPlayer:getPlayerId())
	buff:writeString(global.g_mainPlayer:getDynamicPassword(), 66)
	buff:writeMD5(MachineUUID, 66)
	if password then
		buff:writeString(password, 66)
	end

	global.g_mainPlayer:initRoomTable()
	global.g_mainPlayer:initRoomUser()

	netmng.sendGsData(buff)
end

function sendRequireSitdown(tableId, chairId, password)
	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_GR_USER)
	buff:setSubCmd(pt_game.SUB_GR_USER_SITDOWN)
	buff:writeShort(tableId)
	buff:writeShort(chairId)
	buff:writeString(password, 66)

	netmng.sendGsData(buff)
end

function sendLoginOtherPlatform(sex, gameId, unionId, nickname, realname, mobilePhone, location)
	global.g_mainPlayer:setCurrentGameId(gameId)

	local buff = sendBuff:new()
	buff:setMainCmd(pt_game.MDM_MB_LOGON)
	buff:setSubCmd(pt_game.SUB_MB_LOGON_OTHERPLATFORM)
	buff:writeShort(gameId)
	buff:writeInt(PlazaVersion)
	buff:writeChar(DeviceType)
	buff:writeChar(sex)
	buff:writeChar(WX_PLATFORM)
	buff:writeString(unionId, 66)
	buff:writeString(nickname, 64)
	buff:writeString(realname, 32)
	buff:writeMD5(MachineId, 66)
	buff:writeString(mobilePhone, 24)
	buff:writeString(location, 64)
	buff:writeMD5(MachineUUID, 66)
	buff:writeInt(getLockSpreader())

	global.g_mainPlayer:initRoomTable()
	global.g_mainPlayer:initRoomUser()

	netmng.sendGsData(buff)
end
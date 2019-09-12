---模块名：
--      玩家类
--
--模块介绍：
--      提供玩家的相关操作
--
-------------------------------------------------------------------------------

module( "player_t", package.seeall )

function init(self)
	self:openLocalData()
end

function openLocalData(self)
	self.locate_ = LocalDataBase.locate_

	self:initialize()
end

function initialize(self)
	--新增locate数据
	self.locate_.loginCount = self.locate_.loginCount or 0
	self.locate_.popSpreader = self.locate_.popSpreader or {}
	self.locate_.popAuction = self.locate_.popAuction or {}
	self.locate_.popEarnings = self.locate_.popEarnings or {}
	self.locate_.transactions = self.locate_.transactions or {}
	self:saveLocalData()

	self.guides_ = {
		currentStep = 0,
		guideTypes = {},
	}
end

function saveLocalData(self)
	LocalDataBase:saveLocalData()
end

function setLocalData(self, key, value)
	LocalDataBase:setLocalData(key, value)
end

function getLocalData(self, key, default)
	return LocalDataBase:getLocalData(key, default)
end

function isOpenAuction(self)
	return self.locate_.popAuction[self.playerId_] or false
end

function setOpenAuction(self, value)
	self.locate_.popAuction[self.playerId_] = value
	self:saveLocalData()
end

function isOpenEarnings(self)
	return self.locate_.popEarnings[self.playerId_] or false
end

function setOpenEarnings(self, value)
	self.locate_.popEarnings[self.playerId_] = value
	self:saveLocalData()
end

function setSystemName(self, systemName)
	self.systemName_ = systemName
end

function getSystemName(self)
	return self.systemName_
end

function addLoginCount(self)
	local count = self.locate_.loginCount or 0
	self:setLocalData("loginCount", count + 1)
end

function isLoginEnough(self)
	local count = self.locate_.loginCount or 0
	return count > 4
end

function addPopSpreaderCount(self)
	local count = self.locate_.popSpreader[self.playerId_] or 0
	if count > 3 then
		return
	end

	self.locate_.popSpreader[self.playerId_] = count + 1
	self:saveLocalData()
end

function getPopSpreaderCount(self)
	return self.locate_.popSpreader[self.playerId_] or 0
end

function isNeedPopSpreader(self)
	return self:getPopSpreaderCount() < 3
end

function setMusicVolume(self, volume)
	self:setLocalData("musicVolume", volume)
end

function getMusicVolume(self)
	return self.locate_.musicVolume or 0.5
end

function setEffectVolume(self, volume)
	self:setLocalData("effectVolume", volume)
end

function getEffectVolume(self)
	return self.locate_.effectVolume or 0.5
end

function setLocationData(self, value)
	self:setLocalData("location", value)
end

function isLocationExist(self)
	return self.locate_.location ~= nil
end

function getLocationCity(self)
	return self.locate_.location.province .. self.locate_.location.city
end

function isTransactionsEmpty(self)
	return table.nums(self.locate_.transactions) < 1
end

function addTransaction(self, transaction)
	transaction.platform = PLATFROM
	self.locate_.transactions[transaction.orderid] = transaction
	self:saveLocalData()
end

function removeTransaction(self, orderId)
	self.locate_.transactions[orderId] = nil
	self:saveLocalData()
end

function getTransactions(self)
	return self.locate_.transactions
end

function getTransaction(self, orderId)
	return self.locate_.transactions[orderId]
end

function isVisitorLogin(self)
	return self.playerId_ >= REGISTER_COUNT_MAX
end

function getLoginAccount(self)
	return self.locate_.account or ""
end

function getLoginPassword(self)
	return self.locate_.password or MachineUUID
end

function setCurrentGameId(self, gameId)
	self.currentGameId_ = gameId
end

function getCurrentGameId(self)
	return self.currentGameId_
end

function setCurrentGameNum(self, gameNum)
	self.currentGameNum_ = gameNum or 0
end

function getCurrentGameNum(self)
	return self.currentGameNum_ or 4
end

function getCurrentGameKey(self)
	return self.currentGameId_ 
end


function setFanLiInfo(self,fanli)
	self.FanLi=fanli
end

function getFanLiInfo(self,fanli)
	return self.FanLi
end

function initPlayerData(self, spreaderId, faceId, sex, customId, playerId, gameId, exp, loveLiness, bind3rd, name, dynamicPass, score, ingot, insure, beans, insureEnabled, momo, ext)
	self.playerId_ = playerId
	self.spreaderId_ = spreaderId
	self.faceId_ = faceId
	self.customId_ = customId
	self.gameId_ = gameId
	self.exp_ = exp
	self.loveLiness_ = loveLiness
	self.name_ = name
	self.dynamicPass_ = dynamicPass
	self.score_ = score
	self.ingot_ = ingot
	self.insure_ = insure
	self.beans_ = beans
	self.insureEnabled_ = insureEnabled
	self.bind3rd_ = bind3rd
	self.head3rd_ = {}
	self.momo_ = momo
	self.extTbl_ = ext
	self.dataBind_ = self.dataBind_ or {}
end

function setDataBind(self, spreader, realname, momo, zalopay, extra1, extra2, extra3)
	self.dataBind_ = {
		spreader = spreader,
		realname = realname,
		momo = momo,
		zalopay = zalopay,
		extra1 = extra1,
		extra2 = extra2,
		extra3 = extra3,
	}
end

function getPlayerLevel(self)
	return self.extTbl_[1]
end

function setPlayerLevel(self, level)
	self.extTbl_[1] = level
end

function getPlayerVipLevel(self)
	return self.extTbl_[2]
end

function setPlayerVipLevel(self, vipLevel)
	self.extTbl_[2] = vipLevel
end

function getPlayerMedals(self)
	local t = {}
	for i = 3, 9 do
		local v = self.extTbl_[i]
		if v == 1 then
			table.insert(t, i + 3)
		end
	end
	return t
end

function setPlayerMedal(self, itemId, value)
	self.extTbl_[itemId - 3] = value
end

function isItem1Buyed(self)
	return self.extTbl_[10] == 1
end

function setItem1Buyed(self)
	self.extTbl_[10] = 1
end

function initAppLoginData(self)
	self.appLoginData_ = {}
end

function setAppLoginData(self, serverId, serverName, tableId, chairId, kindId)
	self.appLoginData_.serverId = serverId
	self.appLoginData_.serverName = serverName
	self.appLoginData_.tableId = tableId
	self.appLoginData_.chairId = chairId
	self.appLoginData_.kindId = kindId
end

function getAppLoginData(self)
	return self.appLoginData_
end

function isAppLogin(self)
	return self.appLoginData_.serverId ~= nil
end

function cleanAppLogin(self)
	self.appLoginData_ = {}
end

function initDeviceLoginData(self)
	self.deviceLoginData_ = {}
end

function setDeviceLogin(self, deviceId, score)
	self.deviceLoginData_.deviceId = deviceId
	self.deviceLoginData_.score = score
end

function isDeviceLogin(self)
	return self.deviceLoginData_.deviceId ~= nil
end

function getDeviceLoginId(self)
	return self.deviceLoginData_.deviceId
end

function getDeviceLoginData(self)
	return self.deviceLoginData_
end

function cleanDeviceLogin(self)
	self.deviceLoginData_ = {}
end

function pushGuide(self, guideTypes)
	self.guides_.currentStep = 1
	self.guides_.guideTypes = {}

	for i = 1, #guideTypes do
		table.insert(self.guides_.guideTypes, guideTypes[i])
	end
end

function nextGuideStep(self)
	self.guides_.currentStep = self.guides_.currentStep + 1
end

function previousGuideStep(self)
	self.guides_.currentStep = self.guides_.currentStep - 1
end

function getCurrentGuide(self)
	return self.guides_.guideTypes[self.guides_.currentStep]
end

function popGuide(self)
	self.guides_.currentStep = 0
	self.guides_.guideTypes = {}
end

function isInsureEnabled(self)
	return self.insureEnabled_ == 1
end

function setInsureEnabled(self, enabled)
	self.insureEnabled_ = enabled
end

function getInsureMoney(self)
	return self.insure_
end

function setInsureMoney(self, money)
	self.insure_ = money
end

function isMachineLock(self)
	return self.ingot_ == 1
end

function setMachineLock(self, val)
	self.ingot_ = val
end

function getPlayerId(self)
	return self.playerId_
end

function getRealname(self)
	return self.dataBind_.realname or ""
end

function getSpreaderId(self)
	return self.dataBind_.spreader or self.spreaderId_
end

function setSpreaderId(self, spreaderId)
	self.dataBind_.spreader = spreaderId
	self.spreaderId_ = spreaderId
end

function isBindSpreader(self)
	local spreader = self:getSpreaderId()
	return spreader > 0
end

function getViMomo(self)
	return self.dataBind_.momo or self.momo_
end

function setViMomo(self, momo)
	self.dataBind_.momo = momo
	self.momo_ = momo
end

function isBindMoMo(self)
	local momo = self:getViMomo()
	return utf8.len(momo) >= 10
end

function getZaloPay(self)
	return self.dataBind_.zalopay or ""
end

function setZaloPay(self, zalopay)
	self.dataBind_.zalopay = zalopay
end

function isBindZaloPay(self)
	local zalopay = self:getZaloPay()
	return utf8.len(zalopay) >= 10
end

function isBind3rdPay(self)
	return self:isBindMoMo() or self:isBindZaloPay()
end

function getSpreaderAcc(self)
	return self.spreaderAcc_
end

function setSpreaderAcc(self, spreader)
	self.spreaderAcc_ = spreader
end

function getGameId(self)
	return self.gameId_
end

function getDynamicPassword(self)
	return self.dynamicPass_
end

function getPlayerFace(self)
	return self.faceId_
end

function getPlayerName(self)
	-- return self.name_
	return tostring(self.gameId_)
end

function getPlayerScore(self)
	return self.score_
end

function setPlayerScore(self, score)
	self.score_ = score
end

function setRebateToday(self, today)
	self.rebateToday_ = today
end

function getRebateToday(self)
	return self.rebateToday_ or 0
end

function setRebateTomorrow(self, tomorrow)
	self.rebateTomorrow_ = tomorrow
end

function getRebateTomorrow(self)
	return self.rebateTomorrow_ or 0
end

function initRoomList(self)
	self.roomList_ = {}
	self.matchList_ = {}
end

function initMatchSignUp(self)
	self.matchSignUp_ = {}
end

function addMatchSignUp(self, serverId, matchId, matchNo)
	self.matchSignUp_[serverId] = {
		serverId = serverId,
		matchId = matchId,
		matchNo = matchNo,
		matchHinted = false,
	}
end

function isMatchSignUp(self, serverId, matchId, matchNo)
	local dataSignUp = self.matchSignUp_[serverId]
	if dataSignUp then
		return dataSignUp.serverId == serverId and dataSignUp.matchId == matchId and dataSignUp.matchNo == matchNo
	else
		return false
	end
end

function setMatchHinted(self, serverId)
	local dataSignUp = self.matchSignUp_[serverId]
	if dataSignUp then
		dataSignUp.matchHinted = true
	end
end

function needMatchHinted(self, serverId)
	local dataSignUp = self.matchSignUp_[serverId]
	if not dataSignUp then
		return false
	end

	if dataSignUp.matchHinted then
		return false
	else
		return true
	end
end

function isInMatchRoom(self)
	local serverId = self:getCurrentRoom()
	local rd = self:getRoomData(serverId)

	return rd.serverType == 4
end

function isInAvoidCheatRoom(self)
	local serverId = self:getCurrentRoom()
	local rd = self:getRoomData(serverId)

	return rd.serverRule == 64
end

function getRoomType(self, serverId)
	local rd = self.roomList_[serverId]
	if rd.serverType == 8 then
		return ROOM_TYPE_TIYAN, LocalLanguage:getLanguageString("L_db588284cabf7dd1")
	elseif rd.sortId == 1 then
		--普通房
		return ROOM_TYPE_PUTONG, "初级房"
	elseif rd.sortId == 2 then
		--会员房
		return ROOM_TYPE_HUIYUAN, "中级房"
	elseif rd.sortId == 3 then
		--豪华房
		return ROOM_TYPE_HAOHUA, "高级房"
	end
end

function addRoomToList(self, kindId, nodeId, sortId, serverId, serverKind, serverType, serverLevel, serverPort, cellScore, enterScore, serverRule, onlineCount, androidCount, onFullCount, serverUrl, serverName)
	self.roomList_[serverId] = {
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
end

function addMatchToList(self, serverId, matchId, matchNo, matchType, matchName, memberOrder, matchFeeType, matchFee, startUserCount, matchPlayCount, rewardCount, startTime, endTime)
	self.matchList_[serverId] = {
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
end

function removeRoomFromList(self, serverId)
	self.roomList_[serverId] = nil
end

function getRoomList(self)
	local t = {}
	for k, v in pairs(self.roomList_) do
		if v.serverType ~= 4 then
			table.insert(t, k)
		end
	end
	--table.sort(t)
	table.sort(t, function(a, b)
			local da = self.roomList_[a]
			local db = self.roomList_[b]
			if da.serverType > db.serverType then
				return true
			elseif da.serverType < db.serverType then
				return false
			elseif da.sortId < db.sortId then
				return true
			elseif da.sortId > db.sortId then
				return false
			elseif da.nodeId < db.nodeId then
				return true
			else
				return false
			end
		end)

	return t
end

function setCurrentRoom(self, serverId)
	self.currentRoom_ = serverId
end

function getCurrentRoom(self)
	return self.currentRoom_
end

function getRoomData(self, serverId)
	return self.roomList_[serverId]
end

function getMatchList(self)
	local t = {}
	for k, v in pairs(self.matchList_) do
		table.insert(t, k)
	end
	return t
end

function getNeedMatch(self)
	local luaTbl = self:getMatchList()
	table.sort(luaTbl, function(a, b)
			local da = self:getMatchData(a)
			local db = self:getMatchData(b)

			return da.startTime.timestamp < db.startTime.timestamp
		end)

	local matchId = nil
	local nowTime = os.time()
	for i = 1, #luaTbl do
		matchId = luaTbl[i]

		local matchData = self:getMatchData(matchId)
		local timeStart = matchData.startTime.timestamp
		local timeEnd = matchData.endTime.timestamp
		if nowTime < timeStart or (nowTime > timeStart and nowTime < timeEnd) then
			return matchId
		end
	end
	return matchId
end

function getMatchData(self, serverId)
	return self.matchList_[serverId]
end

function isMatchRoomExist(self)
	return table.nums(self.matchList_) > 0
end

function getCurrentRoomBeilv(self)
	return self.roomList_[self.currentRoom_].cellScore
end

function initRoomUser(self)
	self.roomUser_ = {}
end

function initRoomConfig(self, tableCount, chairCount, serverType, serverRule)
	self.roomConfig_ = {
		tableCount = tableCount,
		chairCount = chairCount,
		serverType = serverType,
		serverRule = serverRule,
	}
end

function getRoomConfig(self)
	return self.roomConfig_
end

function getConfigTableCount(self)
	if self.roomConfig_ then 
	 	return self.roomConfig_.tableCount 
	else
		return 0
	end
end

function isRoomChairFull(self)
	local chairMax = self.roomConfig_.tableCount * self.roomConfig_.chairCount
	local chairUse = self:getPlayerInTableNum()

	return chairMax <= chairUse
end

function addRoomUser(self, gameId, playerId, faceId, customId, sex, vipLevel, tableId, chairId, status, score, ingot, winCount, lostCount, drawCount, fleeCount, exp, name)
	self.roomUser_[playerId] = {
		gameId = gameId,
		playerId = playerId,
		faceId = faceId,
		customId = customId,
		sex = sex,
		vipLevel = vipLevel,
		tableId = tableId,
		chairId = chairId,
		status = status,
		score = score,
		ingot = ingot,
		winCount = winCount,
		lostCount = lostCount,
		drawCount = drawCount,
		fleeCount = fleeCount,
		exp = exp,
		name = name,
	}
end

function updateRoomUserData(self, playerId, score, winCount, lostCount, drawCount, fleeCount, exp)
	local pd = self:getRoomPlayer(playerId)
	if not pd then return end

	pd.score = score
	pd.winCount = winCount
	pd.lostCount = lostCount
	pd.drawCount = drawCount
	pd.fleeCount = fleeCount
	pd.exp = exp

	if playerId == self.playerId_ then
		self:setPlayerScore(score)
	end
end

function removeRoomUser(self, playerId)
	self.roomUser_[playerId] = nil
end

function isRoomUserExist(self, playerId)
	return self.roomUser_[playerId] ~= nil
end

function updateRoomUserStatus(self, playerId, tableId, chairId, status)
	local pd = self:getRoomPlayer(playerId)
	pd.tableId = tableId
	pd.chairId = chairId
	pd.status = status
end

function sitdownRoom(self, playerId, tableId, chairId)
	self:addUserToTable(tableId, chairId, playerId)
end

function getRoomPlayer(self, playerId)
	return self.roomUser_[playerId]
end

function initRoomTable(self)
	self.roomTable_ = {}
end

function addRoomTable(self, tableId, tableLock, tableStatus, tableCellScore)
	local td = self.roomTable_[tableId] or {}
	td.tableId = tableId
	td.tableLock = tableLock
	td.tableStatus = tableStatus
	td.tableCellScore = tableCellScore

	self.roomTable_[tableId] = td
end

function getPlayerInTableNum(self)
	local count = 0
	for k, v in pairs(self.roomUser_) do
		if v.tableId ~= -1 and v.chairId ~= -1 then
			count = count + 1
		end
	end
	return count
end

function addUserToTable(self, tableId, chairId, playerId)
	local pd = self.roomUser_[playerId]

	if not pd then return end

	pd.tableId = tableId
	pd.chairId = chairId
end

function removeUserFromTable(self, playerId)
	local pd = self.roomUser_[playerId]

	if not pd then return end

	pd.tableId = -1
	pd.chairId = -1
end

function isPlayerInTable(self, playerId)
	local pd = self.roomUser_[playerId]

	return not (pd.tableId == -1 or pd.chairId == -1)
end

function getTableList(self)
	return self.roomTable_
end

function getTableUser(self, tableId)
	local t = {}
	for k, v in pairs(self.roomUser_) do
		if v.tableId == tableId and v.status ~= ROOM_USER_LOOKON then
			t[v.chairId] = v.playerId
		end
	end
	return t
end

function isTableAnyLookon(self, tableId)
	for k, v in pairs(self.roomUser_) do
		if v.tableId == tableId and v.status == ROOM_USER_LOOKON then
			return true
		end
	end
	return false
end

function isTableEmpty(self, tableId)
	local tu = self:getTableUser(tableId)

	return table.nums(tu) < 1
end

function getTableChairUser(self, tableId, chairId)
	local t = self:getTableUser(tableId)

	return t[chairId]
end

function isChairEmpty(self, tableId, chairId)
	return not self:getTableChairUser(tableId, chairId)
end

function getCurrentTableId(self)
	local pd = self:getRoomPlayer(self.playerId_)

	return pd.tableId
end

function getCurrentChairId(self)
	local pd = self:getRoomPlayer(self.playerId_)

	return pd.chairId
end

function isSilence(self)
	return self.locate_.silence
end

function setRememb(self, value)
	self:setLocalData("rememb", value)
end

function isRememb(self)
	return self.locate_.rememb
end

function setLoginWay(self, way)
	self.loginWay_ = way
end

function getLoginWay(self)
	return self.loginWay_
end

function setChatInfo(self, infoList)
	if self.charinfo==nil then
		self.charinfo={}
	end
	local badd=true--是否增加记录
	for i = #self.charinfo,1,-1 do
		if self.charinfo[i].chatID==infoList.chatID then
			badd=false
			break
		end
	end	
	if badd==true then
		self.charinfo[#self.charinfo + 1] = infoList
		if self.MaxChatID==nil then
			self.MaxChatID=tonumber(infoList.chatID)
		elseif self.MaxChatID<infoList.chatID then
			self.MaxChatID=tonumber(infoList.chatID)			
		end
	end
end

function getChatInfo(self)
	return self.charinfo or {}
	-- return self:getLocalData("chatInfoRe") or {}
end

function setMaxChatID(self)
	local maxID=self.MaxChatID or 0
	self:setLocalData("maxChatID", maxID)
end

function getMaxChatID(self)
	return self:getLocalData("maxChatID") or 0
end

function getLastChatTime(self)
	return self.chatLastTime_ or 0
end

function getChatCount(self)
	return self.chatCount_ or 0
end

function markLastChatTime(self)
	self.chatLastTime_ = os.time()

	local count = self:getChatCount()
	self.chatCount_ = count + 1
end

function isAllowChat(self)
	local count = self:getChatCount()
	if count < 5 then
		return true
	else
		local time = self:getLastChatTime()
		local delta = os.time() - time
		return delta > 30
	end
end

function setLoginData3rd(self, data)
	self:setLocalData("login3rd", data)
end

function getLoginData3rd(self)
	return self.locate_.login3rd
end

function isLogined3rd(self)
	return self.locate_.login3rd
end

function isLogin3rdBind(self)
	return self.bind3rd_ == 1
end

function setLogin3rdBind(self, value)
	self.bind3rd_ = value
end

function isLogin3rdAvailable(self)
	return self:isLogined3rd() and self:isLogin3rdBind()
end

function cacheHead3rd(self, playerId, faceUrl)
	self.head3rd_[playerId] = faceUrl
end

function isHead3rdExist(self, playerId)
	return self.head3rd_[playerId]
end

function getHead3rd(self, playerId)
	return self.head3rd_[playerId]
end
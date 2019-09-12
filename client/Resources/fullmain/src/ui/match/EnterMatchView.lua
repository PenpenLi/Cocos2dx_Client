--自动进入比赛房
EnterMatchView = class("EnterMatchView", PopUpView)

MATCH_ROOM_CYCLE = {
	ENTER_GAME = 1, --进入游戏
	LEAVE_GAME = 2, --离开游戏
}

function EnterMatchView:ctor(options)
	EnterMatchView.super.ctor(self, true)

	self.options_ = options

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_loading.json")
	self.nodeUI_:addChild(root)

	self.labelContent_ = ccui.Helper:seekWidgetByName(root, "Label_2")
	self.labelContent_:setString(LocalLanguage:getLanguageString("L_0ef3cc99a0ff7fee"))

	local iconLoad = ccui.Helper:seekWidgetByName(root, "Image_1")
	iconLoad:setScale(0.6)

	local btnCancel = ccui.Button:create("main/res/common/btn_cancel.png", "main/res/common/btn_cancel.png", "main/res/common/btn_cancel.png")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))
	btnCancel:setVisible(self.options_.cycle == MATCH_ROOM_CYCLE.ENTER_GAME)
	btnCancel:setPosition(cc.p(0, -120))
	btnCancel:setScale(0.6)
	self.nodeUI_:addChild(btnCancel)

	local action = cc.RepeatForever:create(cc.RotateBy:create(5, 359))
	iconLoad:runAction(action)
end

function EnterMatchView:onPopUpComplete()
	if self.options_.cycle == MATCH_ROOM_CYCLE.ENTER_GAME then
		self:checkApply()
	elseif self.options_.cycle == MATCH_ROOM_CYCLE.LEAVE_GAME then
		netmng.gsClose()
		global.g_mainPlayer:setCurrentRoom(0)
		self:close()

		-- mainLayout()

		-- local gameId = global.g_mainPlayer:getCurrentGameId()
		-- local selectMode = createObj(select_mode_t, gameId)
		-- replaceScene(selectMode:getCCScene(), selectMode)
	end
end

function EnterMatchView:checkApply()
	local md = global.g_mainPlayer:getMatchData(self.options_.serverId)
	if not global.g_mainPlayer:isMatchSignUp(md.serverId, md.matchId, md.matchNo) then
		--未报名
		gatesvr.sendMatchSignUp(md.serverId, md.matchId, md.matchNo)
	else
		--已报名
		self:checkPassword()
	end
end

function EnterMatchView:checkPassword()
	local rd = global.g_mainPlayer:getRoomData(self.options_.serverId)

	if bit.band(rd.serverKind, 0x0002) ~= 0 then
		--需要密码
		PopUpView.showPopUpView(EnterMatchPasswordView, self.options_.serverId, handler(self, self.onEnterGame), handler(self, self.onCancel))
	else
		--不需要密码
		self:onEnterGame(self.options_.serverId)
	end
end

function EnterMatchView:onEnterGame(serverId, password)
	self.password_ = password or ""

	local rd = global.g_mainPlayer:getRoomData(self.options_.serverId)

	netmng.gsClose()
	global.g_mainPlayer:setCurrentGameId(rd.kindId)
	global.g_mainPlayer:setCurrentRoom(self.options_.serverId)

	local handlerId = nil
	handlerId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(handlerId)

			netmng.setGsNetAddress(rd.serverUrl, rd.serverPort)
			if password then
				gamesvr.sendLoginRoom(self.password_)
			else
				gamesvr.sendLoginRoom()
			end
		end, 0.5, false)
	global.g_modify_type = 100
end

function EnterMatchView:onCancel()
	netmng.gsClose()
	global.g_mainPlayer:setCurrentRoom(0)
	self:close()
end

function EnterMatchView:openGameScene()
	self:close()

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	local funcName = string.format("start_%s", cfg.path)

	require_ex(string.format("%s.src.main", cfg.path))
	_G[funcName]()
end

function EnterMatchView:onRoomLoginSuccess()
	if self.options_.cycle == MATCH_ROOM_CYCLE.ENTER_GAME then
		local playerId = global.g_mainPlayer:getPlayerId()
		local pd = global.g_mainPlayer:getRoomPlayer(playerId)

		if pd.status == ROOM_USER_PLAY or pd.status == ROOM_USER_SIT or pd.status == ROOM_USER_READY then
			self:openGameScene()
		else
			gamesvr.sendRequireSitdown(-1, -1, "")
		end
	elseif self.options_.cycle == MATCH_ROOM_CYCLE.LEAVE_GAME then

	end

	return true
end

function EnterMatchView:onRoomLoginFailed()
	self:close()
	global.g_mainPlayer:setCurrentRoom(0)
end

function EnterMatchView:onRoomConnectFailed()
	self:close()
	global.g_mainPlayer:setCurrentRoom(0)

	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_00e6204209e85303"),
				style = WarnTips.STYLE_Y
			}
		)
end

function EnterMatchView:onMatchNum(current, total)
	return true
end

function EnterMatchView:onMatchStatus(status)
	return true
end

function EnterMatchView:onRoomUserSitdown(playerId, tableId, chairId, status)
	print("玩家坐下", playerId, tableId, chairId, status)
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		self:openGameScene()
	end

	return true
end

function EnterMatchView:onRoomUserReady(playerId, tableId, chairId, status)
	print("玩家准备", playerId, tableId, chairId, status)
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		-- self:openGameScene()
	end

	return true
end

function EnterMatchView:onRoomUserPlay(playerId, tableId, chairId, status)
	print("玩家游戏", playerId, tableId, chairId, status)
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		self:openGameScene()
	end

	return true
end

function EnterMatchView:onRoomSitdownFailed()
	netmng.gsClose()
	global.g_mainPlayer:setCurrentRoom(0)
	self:close()
end

function EnterMatchView:onApplyMatchSuccess(serverId)
	if serverId == self.options_.serverId then
		self:checkPassword()
	end
end

function EnterMatchView:onApplyMatchFailed(serverId)
	if serverId == self.options_.serverId then
		self:onCancel()
	end
end

function EnterMatchView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self, self.onRoomLoginSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self, self.onRoomConnectFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_LOGIN_ROOM_FAILED, self, self.onRoomLoginFailed)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MATCH_NUM, self, self.onMatchNum)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MATCH_STATUS, self, self.onMatchStatus)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN, self, self.onRoomUserSitdown)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_READY, self, self.onRoomUserReady)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN_FAILED, self, self.onRoomSitdownFailed)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APPLY_MATCH_SUCCESS, self, self.onApplyMatchSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APPLY_MATCH_FAILED, self, self.onApplyMatchFailed)
end

function EnterMatchView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_LOGIN_ROOM_FAILED, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MATCH_NUM, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MATCH_STATUS, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_READY, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_SITDOWN_FAILED, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APPLY_MATCH_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APPLY_MATCH_FAILED, self)
end
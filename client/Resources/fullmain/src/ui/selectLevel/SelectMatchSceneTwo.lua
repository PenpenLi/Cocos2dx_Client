SelectMatchSceneTwo = class("SelectMatchSceneTwo", LayerBase)

local MATCH_TYPE_NAME = {
	[0] = LocalLanguage:getLanguageString("L_7f52068284ab5bed"),
	[1] = LocalLanguage:getLanguageString("L_d92fd2719d8585a9"),
}

function SelectMatchSceneTwo:ctor(gameId)
	self.keypadHanlder_ = {
	  [6] = self.keyboardBackClicked,
	}

	SelectMatchSceneTwo.super.ctor(self)

	self.gameId_ = gameId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/selectLevel/ui_main_select_match.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	local labelName = ccui.Helper:seekWidgetByName(root,"Label_6")
	labelName:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelName:setString(global.g_mainPlayer:getPlayerName())

	self.labelScore_ = ccui.Helper:seekWidgetByName(root,"Label_7")
	self.labelScore_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelScore_:setString(global.g_mainPlayer:getPlayerScore())

	local btnBack = ccui.Helper:seekWidgetByName(root,"Button_8")
	btnBack:addTouchEventListener(makeClickHandler(self, self.onBack))

	self.iconMachine_ = ccui.Helper:seekWidgetByName(root, "Image_9")
	self.iconMachine_:loadTexture(string.format("fullmain/res/selectLevel/horizontal/level_%d.png", self.gameId_))
	self.ox_, self.oy_ = self.iconMachine_:getPosition()

	self.btnEnter_ = ccui.Helper:seekWidgetByName(root,"Button_15")
	self.btnEnter_:addTouchEventListener(makeClickHandler(self, self.onEnterRoom))

	local btnLeft = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnLeft:addTouchEventListener(makeClickHandler(self, self.onLeft))

	local btnRight = ccui.Helper:seekWidgetByName(root, "Button_9")
	btnRight:addTouchEventListener(makeClickHandler(self, self.onRight))

	local iconHead = ccui.Helper:seekWidgetByName(root,"Image_4")
	iconHead:setOpacity(0)
	iconHead:addTouchEventListener(makeClickHandler(self, self.onHead))
	
	local px, py = iconHead:getPosition()
	local nodeClip = cc.ClippingNode:create(cc.Sprite:create("fullmain/res/hall/headMask.png"))
	nodeClip:setInverted(false)
	nodeClip:setAlphaThreshold(0.5)
	nodeClip:setPosition(cc.p(px, py))
	iconHead:getParent():addChild(nodeClip, 10)

	local headPath, scale = getPlayerHeadPath()
	self.iconHead_ = cc.Sprite:create(headPath)
	self.iconHead_:setScale(scale)
	nodeClip:addChild(self.iconHead_)

	self.labelCountDown_ = ccui.Helper:seekWidgetByName(root,"Label_213")
	self.labelMode_ = ccui.Helper:seekWidgetByName(root, "Label_206")
	self.labelRound_ = ccui.Helper:seekWidgetByName(root, "Label_211")
	self.labelStartTime_ = ccui.Helper:seekWidgetByName(root, "Label_207")
	self.labelCondition_ = ccui.Helper:seekWidgetByName(root, "Label_210")
	self.labelEndTime_ = ccui.Helper:seekWidgetByName(root, "Label_208")
	self.labelUserCount_ = ccui.Helper:seekWidgetByName(root, "Label_212")
	self.labelCost_ = ccui.Helper:seekWidgetByName(root, "Label_209")
	self.labelName_ = ccui.Helper:seekWidgetByName(root, "Label_214")
	self.panel_ = ccui.Helper:seekWidgetByName(root, "Image_205")

	self:initSurface()
end

function SelectMatchSceneTwo:initSurface()
	self.matchList_ = global.g_mainPlayer:getMatchList()

	if #self.matchList_ == 0 then
		self.btnEnter_:setVisible(false)
		self.iconMachine_:setVisible(false)
		self.panel_:setVisible(false)
		return
	end

	self.currentIndex_ = 1
	self:refreshCurrentRoom()
end

function SelectMatchSceneTwo:keyboardBackClicked()
	self:onBack()
	self:keyboardHandleRelease()
end

function SelectMatchSceneTwo:onHead()
	-- PopUpView.showPopUpView(PersonalScene)
	replaceScene(PersonalScene, TRANS_CONST.TRANS_SCALE)
end

function SelectMatchSceneTwo:onLeft()
	self:onFront()
end

function SelectMatchSceneTwo:onRight()
	self:onNext()
end

function SelectMatchSceneTwo:startCountDown()
	self:stopCountDown()

	local serverId = self.matchList_[self.currentIndex_]
	local md = global.g_mainPlayer:getMatchData(serverId)
	if md.matchType == 1 then
		self.labelCountDown_:setString(LocalLanguage:getLanguageString("L_3fe5cbee6fb19f5a"))
	else
		local nowTime = os.time()
		local nowDate = os.date("*t")
		local startTime = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = md.startTime.hour,
				min = md.startTime.minute,
				sec = md.startTime.second
			}
		) or 0

		local endToday = os.time(
			{
				year = nowDate.year,
				month = nowDate.month,
				day = nowDate.day,
				hour = md.endTime.hour,
				min = md.endTime.minute,
				sec = md.endTime.second
			}
		)

		local endTime = os.time(
			{
				year = md.endTime.year,
				month = md.endTime.month,
				day = md.endTime.day,
				hour = md.endTime.hour,
				min = md.endTime.minute,
				sec = md.endTime.second
			}
		) or 0

		if nowTime > endTime or nowTime > endToday then
			self.labelCountDown_:setString(LocalLanguage:getLanguageString("L_d168c8ad47c140f5"))
		elseif nowTime < startTime then
			self.remainTime_ = startTime - nowTime
			self.labelCountDown_:setString(string.format(LocalLanguage:getLanguageString("L_7224b6c1b8e18ace"), formatTimeString(self.remainTime_)))
			self.countDownHandler_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
					self:onCountDown()
				end, 1, false)
		else
			self.labelCountDown_:setString(LocalLanguage:getLanguageString("L_3fe5cbee6fb19f5a"))
		end
	end
end

function SelectMatchSceneTwo:onCountDown()
	self.remainTime_ = self.remainTime_ - 1

	if self.remainTime_ > 0 then
		self.labelCountDown_:setString(string.format(LocalLanguage:getLanguageString("L_7224b6c1b8e18ace"), formatTimeString(self.remainTime_)))
	else
		self:stopCountDown()
		self.labelCountDown_:setString(LocalLanguage:getLanguageString("L_3fe5cbee6fb19f5a"))
	end
end

function SelectMatchSceneTwo:stopCountDown()
	if self.countDownHandler_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.countDownHandler_)
		self.countDownHandler_ = nil
	end
end

function SelectMatchSceneTwo:refreshCurrentRoom()
	local serverId = self.matchList_[self.currentIndex_]
	local md = global.g_mainPlayer:getMatchData(serverId)

	self.labelMode_:setString(string.format(LocalLanguage:getLanguageString("L_d7fa8e05f54f7149"), MATCH_TYPE_NAME[md.matchType]))
	self.labelRound_:setString(string.format(LocalLanguage:getLanguageString("L_945757b0fbeb7143"), md.matchPlayCount))
	self.labelUserCount_:setString(string.format(LocalLanguage:getLanguageString("L_29c2254ce35a2512"), md.startUserCount))
	self.labelCost_:setString(string.format(LocalLanguage:getLanguageString("L_656fd61a08b2e52c"), md.matchFee))
	self.labelName_:setString(string.format(LocalLanguage:getLanguageString("L_bf978be3e59a4cef"), md.matchName))
	if md.matchType == 0 then
		self.labelStartTime_:setString(string.format(LocalLanguage:getLanguageString("L_060a0cb89609e106"), md.startTime.hour, md.startTime.minute, md.startTime.second))
		self.labelEndTime_:setString(string.format(LocalLanguage:getLanguageString("L_c72a28b5407287d5"), md.endTime.hour, md.endTime.minute, md.endTime.second))
	else
		self.labelStartTime_:setString(string.format(LocalLanguage:getLanguageString("L_a73879025a5603dc"), md.startUserCount))
		self.labelEndTime_:setString("")
	end
	self:startCountDown()
end

function SelectMatchSceneTwo:onBack()
	netmng.gsClose()
	
	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function SelectMatchSceneTwo:onEnterRoom()
	local serverId = self.matchList_[self.currentIndex_]
	local md = global.g_mainPlayer:getMatchData(serverId)
	if md.matchType == 0 then
		if self:checkTime(serverId) then
			if not global.g_mainPlayer:isMatchSignUp(md.serverId, md.matchId, md.matchNo) then
				--未报名
				WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_2486c101e2c4f5b9"),
						style = WarnTips.STYLE_YN,
						confirm = handler(self, self.doApplyMatch),
					}
				)
			else
				self:checkPassword(serverId)
			end
		end
	else
		self:checkPassword(serverId)
	end
end

function SelectMatchSceneTwo:checkPassword(serverId)
	local rd = global.g_mainPlayer:getRoomData(serverId)

	if bit.band(rd.serverKind, 0x0002) ~= 0 then
		--需要密码
		PopUpView.showPopUpView(ui_selectLevel_password_t, serverId, handler(self, self.onEnterGame))
	else
		--不需要密码
		self:onEnterGame(serverId)
	end
end

function SelectMatchSceneTwo:onEnterGame(serverId, password)
	LoadingView.showTips()

	self.password_ = password or ""

	netmng.gsClose()
	global.g_mainPlayer:setCurrentRoom(serverId)

	local rd = global.g_mainPlayer:getRoomData(serverId)
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

function SelectMatchSceneTwo:doApplyMatch()
	local serverId = self.matchList_[self.currentIndex_]
	local md = global.g_mainPlayer:getMatchData(serverId)

	gatesvr.sendMatchSignUp(md.serverId, md.matchId, md.matchNo)
end

function SelectMatchSceneTwo:onFront()
	if self.moving_ or self.currentIndex_ <= 1 then
		return
	end

	self.currentIndex_ = self.currentIndex_ - 1

	self.moving_ = true

	local size = self.iconMachine_:getContentSize()
	local machine = cc.Sprite:create(string.format("fullmain/res/selectLevel/horizontal/level_%d.png", self.gameId_))
	local parent = self.iconMachine_:getParent()
	machine:setPosition(self.ox_ - (size.width + 200), self.oy_)
	parent:addChild(machine)

	local moveAc = cc.MoveTo:create(0.5, cc.p(self.ox_ + size.width + 200, self.oy_))
	self.iconMachine_:runAction(moveAc)

	local action = cc.Sequence:create(
			{
				cc.MoveTo:create(0.5, cc.p(self.ox_, self.oy_)),
				cc.CallFunc:create(function()
						machine:removeFromParent()
						self.iconMachine_:setPosition(self.ox_, self.oy_)
						self.moving_ = false
						self:refreshCurrentRoom()
					end)
			}
		)
	machine:runAction(action)
end

function SelectMatchSceneTwo:onNext()
	if self.moving_ or self.currentIndex_ >= #self.matchList_ then
		return
	end

	self.currentIndex_ = self.currentIndex_ + 1

	self.moving_ = true

	local size = self.iconMachine_:getContentSize()
	local machine = cc.Sprite:create(string.format("fullmain/res/selectLevel/horizontal/level_%d.png", self.gameId_))
	local parent = self.iconMachine_:getParent()
	machine:setPosition(self.ox_ + size.width + 200, self.oy_)
	parent:addChild(machine)

	local moveAc = cc.MoveTo:create(0.5, cc.p(self.ox_ - (size.width + 200), self.oy_))
	self.iconMachine_:runAction(moveAc)

	local action = cc.Sequence:create(
			{
				cc.MoveTo:create(0.5, cc.p(self.ox_, self.oy_)),
				cc.CallFunc:create(function()
						machine:removeFromParent()
						self.iconMachine_:setPosition(self.ox_, self.oy_)
						self.moving_ = false
						self:refreshCurrentRoom()
					end)
			}
		)
	machine:runAction(action)
end

function SelectMatchSceneTwo:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
	if self.moving_ or #self.matchList_ == 0 then
		return false
	end

	self.touchX_, self.touchY_ = _touchX, _touchY
	return true
end

function SelectMatchSceneTwo:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)

end

function SelectMatchSceneTwo:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
	local deltaX = _touchX - self.touchX_
	local distance = math.abs(deltaX)
	if distance > 150 then
		if deltaX > 0 then
			self:onNext()
		else			
			self:onFront()
		end
	end
end

function SelectMatchSceneTwo:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
	self:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
end

function SelectMatchSceneTwo:onEnterRoomFailed()
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_00e6204209e85303"),
				style = WarnTips.STYLE_Y
			}
		)
end

function SelectMatchSceneTwo:onApplyMatchSuccess(serverId)
	if self:checkTime(serverId, true) then
		self:checkPassword(serverId)
	end
end

function SelectMatchSceneTwo:checkTime(serverId, ignoreTips)
	local md = global.g_mainPlayer:getMatchData(serverId)
	local nowTime = os.time()
	local nowDate = os.date("*t")
	local startTime = os.time(
		{
			year = nowDate.year,
			month = nowDate.month,
			day = nowDate.day,
			hour = md.startTime.hour,
			min = md.startTime.minute,
			sec = md.startTime.second
		}
	) or 0

	local endToday = os.time(
		{
			year = nowDate.year,
			month = nowDate.month,
			day = nowDate.day,
			hour = md.endTime.hour,
			min = md.endTime.minute,
			sec = md.endTime.second
		}
	)

	local endTime = os.time(
		{
			year = md.endTime.year,
			month = md.endTime.month,
			day = md.endTime.day,
			hour = md.endTime.hour,
			min = md.endTime.minute,
			sec = md.endTime.second
		}
	) or 0

	if nowTime > endTime or nowTime > endToday then
		if not ignoreTips then
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_5aab7663d3b158d6"),
					style = WarnTips.STYLE_Y
				}
			)
		end
		return false
	elseif nowTime < startTime then
		if not ignoreTips then
			WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_96fc610f75a99588"),
					style = WarnTips.STYLE_Y
				}
			)
		end
		return false
	else
		return true
	end
end

function SelectMatchSceneTwo:onRoomUserPlay(playerId, tableId, chairId, status)
	print("玩家游戏")
	local ownerId = global.g_mainPlayer:getPlayerId()
	if ownerId == playerId then
		--玩家本人
		self:startGame()
	else
		--其他玩家
	end
end

function SelectMatchSceneTwo:onLoginRoomSuccess()
	local serverId = self.matchList_[self.currentIndex_]
	local md = global.g_mainPlayer:getMatchData(serverId)
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]

	if md.matchType == 0 then
		-- require_ex(string.format("%s.src.ui.selectLevel.ui_match_setTime_t", cfg.path))

		-- local matchUI = createObj(ui_match_setTime_t, self.password_)
		-- replaceScene(matchUI:getCCScene(), matchUI)
	elseif md.matchType == 1 then
		-- require_ex(string.format("%s.src.ui.selectLevel.ui_match_instant_t", cfg.path))

		-- local matchUI = createObj(ui_match_instant_t, self.password_)
		-- replaceScene(matchUI:getCCScene(), matchUI)
	end
end

function SelectMatchSceneTwo:onSystemMessage(msg)
	WarnTips.showTips(
			{
				text = msg,
				style = WarnTips.STYLE_Y,
			}
		)
end

function SelectMatchSceneTwo:startGame()
	LoadingView.closeTips()
	
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	local funcName = string.format("start_%s", cfg.path)

	require_ex(string.format("%s.src.main", cfg.path))
	_G[funcName]()
end

function SelectMatchSceneTwo:onHallScoreChange()
	self.labelScore_:setString(global.g_mainPlayer:getPlayerScore())
end

function SelectMatchSceneTwo:onEndEnterTransition()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self, self.onLoginRoomSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self, self.onEnterRoomFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APPLY_MATCH_SUCCESS, self, self.onApplyMatchSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SYSTEM_MESSAGE, self, self.onSystemMessage)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onHallScoreChange)
end

function SelectMatchSceneTwo:onStartExitTransition()
	self:stopCountDown()

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_LOGIN_ROOM, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APPLY_MATCH_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SYSTEM_MESSAGE, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
end
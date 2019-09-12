SelectModeScene = class("SelectModeScene", LayerBase)

function SelectModeScene:ctor(gameId)
	self.keypadHanlder_ = {
	  [6] = self.keyboardBackClicked,
	}

	SelectModeScene.super.ctor(self)

	self.gameId_ = gameId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/selectLevel/ui_main_room_mode.json")
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

	local btnNormal = ccui.Helper:seekWidgetByName(root, "Button_43")
	btnNormal:addTouchEventListener(makeClickHandler(self, self.onNormalHandler))

	local btnMatch = ccui.Helper:seekWidgetByName(root, "Button_42")
	btnMatch:addTouchEventListener(makeClickHandler(self, self.onMatchHandler))
end

function SelectModeScene:keyboardBackClicked()
	self:onBack()
	self:keyboardHandleRelease()
end

function SelectModeScene:onNormalHandler()
	local cfg = games_config[self.gameId_]
	if cfg.style == GameStyleVertical then
		-- local selectLevel = createObj(ui_selectLevel_v_t, self.gameId_)
		-- replaceScene(selectLevel:getCCScene(), selectLevel)
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, self.gameId_)
	elseif cfg.style == GameStyleHorizontal then
		-- local selectLevel = createObj(ui_selectLevel_h_t, self.gameId_)
		-- replaceScene(selectLevel:getCCScene(), selectLevel)
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, self.gameId_)
	end
end

function SelectModeScene:onMatchHandler()
	-- local selectMatch = createObj(ui_selectMatch_t, self.gameId_)
	-- replaceScene(selectMatch:getCCScene(), selectMatch)
	replaceScene(SelectMatchSceneTwo, TRANS_CONST.TRANS_SCALE, self.gameId_)
end

function SelectModeScene:onHead()
	-- PopUpView.showPopUpView(PersonalScene)
	replaceScene(PersonalScene, TRANS_CONST.TRANS_SCALE)
end

function SelectModeScene:onBack()
	netmng.gsClose()

	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function SelectModeScene:onHallScoreChange()
	self.labelScore_:setString(global.g_mainPlayer:getPlayerScore())
end

function SelectModeScene:onEndEnterTransition()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onHallScoreChange)
end

function SelectModeScene:onStartExitTransition()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
end
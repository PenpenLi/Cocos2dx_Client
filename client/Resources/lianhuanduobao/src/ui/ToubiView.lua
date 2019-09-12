ToubiView = class("ToubiView", PopUpView)

function ToubiView:ctor()
	ToubiView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("feiqinzoushou/res/json/ui_toubi.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "closebtn")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local labelRatio = ccui.Helper:seekWidgetByName(root, "scoretext")
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	labelRatio:setString(ratio)

	self.labelGold_ = ccui.Helper:seekWidgetByName(root, "goldnumtext")
	self.labelGold_:setString(GameScene.gold_)

	local btnSub = ccui.Helper:seekWidgetByName(root, "pusbtn")
	btnSub:addTouchEventListener(makeClickHandler(self, self.onSubHandler))

	local btnAdd = ccui.Helper:seekWidgetByName(root, "addbtn")
	btnAdd:addTouchEventListener(makeClickHandler(self, self.onAddHandler))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "surebtn")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))

	self.checkBox1_ = ccui.Helper:seekWidgetByName(root, "cheaxbox1")
	self.checkBox1_:addEventListener(handler(self, self.onSelectChangeHandler))

	self.checkBox5_ = ccui.Helper:seekWidgetByName(root, "cheaxbox5")
	self.checkBox5_:addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkBox5_:setSelected(true)

	self.checkBox10_ = ccui.Helper:seekWidgetByName(root, "cheaxbox10")
	self.checkBox10_:addEventListener(handler(self, self.onSelectChangeHandler))

	self.checkBox50_ = ccui.Helper:seekWidgetByName(root, "cheaxbox50")
	self.checkBox50_:addEventListener(handler(self, self.onSelectChangeHandler))

	self.checkBox100_ = ccui.Helper:seekWidgetByName(root, "cheaxbox100")
	self.checkBox100_:addEventListener(handler(self, self.onSelectChangeHandler))

	self.checkBox500_ = ccui.Helper:seekWidgetByName(root, "cheaxbox500")
	self.checkBox500_:addEventListener(handler(self, self.onSelectChangeHandler))

	self.currentScore_ = 0
	self.goldBase_ = 5
	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "sconetxet")

	self.selectedBox_ = self.checkBox5_
	self:refreshCurrentScore()
end

function ToubiView:refreshRemainGold()
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	local remain = GameScene.gold_ - (self.currentScore_/ratio)
	self.labelGold_:setString(remain)
end

function ToubiView:onSelectChangeHandler(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedBox_ ~= sender then
			self.selectedBox_:setSelected(false)
			self.selectedBox_ = sender
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end

	self:switchGoldBase(self.selectedBox_:getName())
end

function ToubiView:refreshCurrentScore()
	self.labelScore_:setString(self.currentScore_)

	self:refreshRemainGold()
end

function ToubiView:switchGoldBase(name)
	if name == "cheaxbox1" then
		self.goldBase_ = 1
	elseif name == "cheaxbox5" then
		self.goldBase_ = 5
	elseif name == "cheaxbox10" then
		self.goldBase_ = 10
	elseif name == "cheaxbox50" then
		self.goldBase_ = 50
	elseif name == "cheaxbox100" then
		self.goldBase_ = 100
	elseif name == "cheaxbox500" then
		self.goldBase_ = 500
	end

	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	local maxScore = GameScene.gold_ * ratio
	if self.currentScore_ >= maxScore then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_11aa0fec27a5f21f"))
		return
	end

	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	local maxScore = GameScene.gold_ * ratio

	self.currentScore_ = math.min(maxScore, self.currentScore_ + self.goldBase_ * ratio)
	self:refreshCurrentScore()
end

function ToubiView:onSubHandler()
	if self.currentScore_ <= 0 then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_96d76f0800ca8095"))
		return
	end

	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	self.currentScore_ = math.max(0, self.currentScore_ - self.goldBase_ * ratio)
	self:refreshCurrentScore()
end

function ToubiView:onAddHandler()
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	local maxScore = GameScene.gold_ * ratio
	if self.currentScore_ >= maxScore then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_11aa0fec27a5f21f"))
		return
	end

	self.currentScore_ = math.min(maxScore, self.currentScore_ + self.goldBase_ * ratio)
	self:refreshCurrentScore()
end

function ToubiView:onConfirmHandler()
	if self.currentScore_ > 0 then
		local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
		GameScene.gold_ = GameScene.gold_ - (self.currentScore_/ratio)
		GameScene.score_ = GameScene.score_ + self.currentScore_

		global.g_gameDispatcher:sendMessage(GAME_EXCHANGE_SCORE_SUCCESS)
	end
	self:close()
end

function ToubiView:onCloseHandler()
	self:close()
end
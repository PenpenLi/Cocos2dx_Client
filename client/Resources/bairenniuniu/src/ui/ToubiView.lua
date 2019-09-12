--
-- Author: Yang
-- Date: 2016-10-27 14:47:37
--
ToubiView = class("ToubiView",PopUpView)

function ToubiView:ctor()
	ToubiView.super.ctor(self,true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_toubi.json")
	self.nodeUI_:addChild(root)

	--关闭按钮
	local btn_close  = ccui.Helper:seekWidgetByName(root,"btn_close")
	local btn_pus    = ccui.Helper:seekWidgetByName(root,"btn_pus")
	local btn_add    = ccui.Helper:seekWidgetByName(root,"btn_add")
	local btn_ok     = ccui.Helper:seekWidgetByName(root,"btn_ok")
	--加减数字显示的label
	self.scorelab_   = ccui.Helper:seekWidgetByName(root,"scorelab")
	-- 1 5 10 50 100 500
	self.checkbox1_  = ccui.Helper:seekWidgetByName(root,"checkbox1")
	self.checkbox5_  = ccui.Helper:seekWidgetByName(root,"checkbox5")
	self.checkbox10_ = ccui.Helper:seekWidgetByName(root,"checkbox10")
	self.checkbox50_ = ccui.Helper:seekWidgetByName(root,"checkbox50")
	self.checkbox100_= ccui.Helper:seekWidgetByName(root,"checkbox100")
	self.checkbox500_= ccui.Helper:seekWidgetByName(root,"checkbox500")

	btn_close:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))
	btn_pus  :addTouchEventListener(makeClickHandler(self, self.onPusHandler))
	btn_add  :addTouchEventListener(makeClickHandler(self, self.onAddHandler))
	btn_ok   :addTouchEventListener(makeClickHandler(self, self.onOkHandler))

	self.checkbox1_  :addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox5_  :addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox5_  :setSelected(true)
	self.checkbox10_ :addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox50_ :addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox100_:addEventListener(handler(self, self.onSelectChangeHandler))
	self.checkbox500_:addEventListener(handler(self, self.onSelectChangeHandler))
	--显示比例
	local bl_score   = ccui.Helper:seekWidgetByName(root,"scoretest")
	local bl         = global.g_mainPlayer:getCurrentRoomBeilv()
	bl_score:setString(bl)
	--goldmetext 自己的金币数
	self.goldmetest_ = ccui.Helper:seekWidgetByName(root,"goldmetext")
	self.goldmetest_:setString(GameScene.gold_)

	--正确的分数
	self.currentScore_ = 0
	--金币默认选项
	self.goldBase_     = 5
	--选中复选框,默认选项
	self.selectedBox_  = self.checkbox5_
	self:refreshCurrentScore()
end

function ToubiView:refreshCurrentScore()
	--加减数字显示的label
	self.scorelab_:setString(self.currentScore_)
	--刷新自己剩下的金币
	self:refreshRemainGold()
end
--刷新自己剩余的金币数
function ToubiView:refreshRemainGold()
	--获取房间倍数
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	--剩余金币数
	local remain = GameScene.gold_ - (self.currentScore_/ratio)
	self.goldmetest_:setString(remain)
end

--复选框
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
--选择复选框
function ToubiView:switchGoldBase(name)
	if name == "checkbox1" then
		self.goldBase_ = 1
	elseif name == "checkbox5" then
		self.goldBase_ = 5
	elseif name == "checkbox10" then
		self.goldBase_ = 10
	elseif name == "checkbox50" then
		self.goldBase_ = 50
	elseif name == "checkbox100" then
		self.goldBase_ = 100
	elseif name == "checkbox500" then
		self.goldBase_ = 500
	end

	local ratio    = global.g_mainPlayer:getCurrentRoomBeilv()
	-- local ratio    = 10000
	local maxscore = GameScene.gold_ * ratio
	if self.currentScore_ >= maxscore then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_11aa0fec27a5f21f"))
		return
	end
	self.currentScore_ = math.min(maxscore, self.currentScore_ + self.goldBase_ * ratio)
	self:refreshCurrentScore()
end
-- -按钮
function ToubiView:onPusHandler()
	if self.currentScore_ <= 0 then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_96d76f0800ca8095"))
		return
	end
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	self.currentScore_ = math.max(0, self.currentScore_ - self.goldBase_ * ratio)
	self:refreshCurrentScore()
	print("减按钮...")
end
-- +按钮
function ToubiView:onAddHandler()
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	-- local ratio = 10000
	local maxScore = GameScene.gold_ * ratio
	if self.currentScore_ >= maxScore then
		TextTipsUtils:showTips(LocalLanguage:getLanguageString("L_11aa0fec27a5f21f"))
		return
	end
	self.currentScore_ = math.min(maxScore, self.currentScore_ + self.goldBase_ * ratio)
	self:refreshCurrentScore()
	print("加按钮...")
end
-- ok按钮
function ToubiView:onOkHandler()
	if self.currentScore_ > 0 then
		local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
		GameScene.gold_  = GameScene.gold_ - (self.currentScore_/ratio)
		GameScene.score_ = GameScene.score_ + self.currentScore_
		print("GameScene.gold_",GameScene.gold_,"GameScene.score_",GameScene.score_)
		--用户上分
		gamesvr.sendUpScore(GameScene.score_)
		global.g_gameDispatcher:sendMessage(GAME_EXCHANGE_SCORE_SUCCESS)
	end
	self:close()
	print("ok按钮...")
end

--关闭按钮
function ToubiView:onCloseHandler()
	self:close()
end

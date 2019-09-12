SettleView = class("SettleView", PopUpView)

function SettleView:ctor()
	SettleView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("daxiao/res/json/ui_settle.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "closebtn")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	local labelRatio = ccui.Helper:seekWidgetByName(root, "numtext")
	labelRatio:setString(ratio)

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "surebtn")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))

	local labelScore = ccui.Helper:seekWidgetByName(root, "scoretext")
	labelScore:setString(GameScene.score_)

	local gold = math.floor(GameScene.score_/ratio)
	local labelGold = ccui.Helper:seekWidgetByName(root, "goldtext")
	labelGold:setString(gold)
end

function SettleView:onConfirmHandler()
	local ratio = global.g_mainPlayer:getCurrentRoomBeilv()
	if GameScene.score_ > ratio then
		local gold = math.floor(GameScene.score_/ratio)
		local remain = GameScene.score_ % ratio

		GameScene.gold_ = GameScene.gold_ + gold
		GameScene.score_ = remain

		global.g_gameDispatcher:sendMessage(GAME_EXCHANGE_GOLD_SUCCESS)
	end
	self:close()
end

function SettleView:onCloseHandler()
	self:close()
end
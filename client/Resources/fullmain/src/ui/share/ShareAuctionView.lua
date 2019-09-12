ShareAuctionView = class("ShareAuctionView", PopUpView)

function ShareAuctionView:ctor(itemId)
	ShareAuctionView.super.ctor(self, true)

	self.itemId_ = itemId

	self.panelRoot_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_share_auction.json")
	self.panelRoot_:setPosition(cc.p(0, 50))
	self.panelRoot_:setVisible(false)
	self.nodeUI_:addChild(self.panelRoot_)

	local panelTitle = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Title")
	local sp = cc.Sprite:create("fullmain/res/acquire/auction/title_auction/title_auction_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/auction/title_auction/title_auction_", 0.05, 10000000000)
	sp:runAction(action)
	panelTitle:addChild(sp)

	local panelAnimation = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Animation")
	sp = cc.Sprite:create("fullmain/res/acquire/acquire_flash/acquire_flash_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/acquire_flash/acquire_flash_", 0.05, 10000000000)
	sp:runAction(action)
	panelAnimation:addChild(sp)

	local itemIcon = ccui.Helper:seekWidgetByName(self.panelRoot_, "Image_Icon")
	itemIcon:loadTexture(string.format("fullmain/res/acquire/auction/items/item%d.png", self.itemId_))

	local labelTips = ccui.Helper:seekWidgetByName(self.panelRoot_, "Label_Tips")
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local isBind = global.g_mainPlayer:isBindMoMo()
	self.labelBindMoMo_ = ccui.Helper:seekWidgetByName(self.panelRoot_, "Label_MoMoBind")
	self.labelBindMoMo_:setVisible(not isBind)

	self.btnBindMoMo_ = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_BindMoMo")
	self.btnBindMoMo_:setPressedActionEnabled(true)
	self.btnBindMoMo_:addTouchEventListener(makeClickHandler(self, self.onBindMoMoHandler))
	self.btnBindMoMo_:setVisible(not isBind)

	if not isBind then
		self.guideBindFinger_ = GuideFinger.new()
		self.guideBindFinger_:setPosition(cc.p(50, 25))
		self.btnBindMoMo_:addChild(self.guideBindFinger_)
	end

	local btnConfirm = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnShare = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Share")
	btnShare:setPressedActionEnabled(true)
	btnShare:addTouchEventListener(makeClickHandler(self, self.onShare))
end

function ShareAuctionView:onPopUpComplete()
	self.panelRoot_:setVisible(true)
	ccs.ActionManagerEx:getInstance():playActionByName("fullmain/res/json/ui_main_share_auction.json", "Start");
end

function ShareAuctionView:onBindMoMoHandler()
	PopUpView.showPopUpView(ui_complete_spreader_t)
end

function ShareAuctionView:onConfirm()
	self:close()
end

function ShareAuctionView:onShare()
	PopUpView.showPopUpView(ShareView, SHARE_AUCTION_CONST)

	self:close()
end

function ShareAuctionView:onCompleteSpreaderSuccess()
	local isBind = global.g_mainPlayer:isBindMoMo()
	self.labelBindMoMo_:setVisible(not isBind)
	self.btnBindMoMo_:setVisible(not isBind)

	if not isBind then
		self.guideBindFinger_:removeFromParent()
	end
end

function ShareAuctionView:onCompleteSpreaderPasswordSuccess()
	local isBind = global.g_mainPlayer:isBindMoMo()
	self.labelBindMoMo_:setVisible(not isBind)
	self.btnBindMoMo_:setVisible(not isBind)

	if not isBind then
		self.guideBindFinger_:removeFromParent()
	end
end

function ShareAuctionView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self, self.onCompleteSpreaderSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self, self.onCompleteSpreaderPasswordSuccess)
end

function ShareAuctionView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self)
end
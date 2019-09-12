AuctionTipsView = class("AuctionTipsView", PopUpView)

function AuctionTipsView:ctor()
	AuctionTipsView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_auction_tips.json")
	self.nodeUI_:addChild(root)

	local content = string.format(LocalLanguage:getLanguageString("L_5566037aae2b78f6"), ITEM1_COST)
	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_Content")
	labelContent:setString(content)

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_Cancel")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))
end

function AuctionTipsView:onPopUpComplete()

end

function AuctionTipsView:onCancel()
	global.g_mainPlayer:setOpenEarnings(true)

	self:close()
end

function AuctionTipsView:onConfirm()
	global.g_mainPlayer:setOpenEarnings(true)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_AUTO_EXIT)

	self:close()
end

function AuctionTipsView:initMsgHandler()

end

function AuctionTipsView:removeMsgHandler()

end
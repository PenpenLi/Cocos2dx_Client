ShareEmailTakeView = class("ShareEmailTakeView", PopUpView)

function ShareEmailTakeView:ctor(count)
	ShareEmailTakeView.super.ctor(self, true)

	self.panelRoot_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_share_take_email.json")
	self.panelRoot_:setVisible(false)
	self.nodeUI_:addChild(self.panelRoot_)

	local panelTitle = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Title")
	local sp = cc.Sprite:create("fullmain/res/acquire/email_take/title_email_take/title_email_take_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/email_take/title_share/title_email_take_", 0.05, 10000000000)
	sp:runAction(action)
	panelTitle:addChild(sp)

	local panelAnimation = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Animation")
	sp = cc.Sprite:create("fullmain/res/acquire/acquire_flash/acquire_flash_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/acquire_flash/acquire_flash_", 0.05, 10000000000)
	sp:runAction(action)
	panelAnimation:addChild(sp)

	local labelCount = ccui.Helper:seekWidgetByName(self.panelRoot_, "AtlasLabel_Count")
	labelCount:setString(count)

	local labelTips = ccui.Helper:seekWidgetByName(self.panelRoot_, "Label_Tips")
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelTips:setString(string.format(LocalLanguage:getLanguageString("L_1b69824152921308"), count))

	local btnConfirm = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnShare = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Share")
	btnShare:setPressedActionEnabled(true)
	btnShare:addTouchEventListener(makeClickHandler(self, self.onShare))
end

function ShareEmailTakeView:onPopUpComplete()
	self.panelRoot_:setVisible(true)
	ccs.ActionManagerEx:getInstance():playActionByName("fullmain/res/json/ui_main_share_take_email.json", "Start");
end

function ShareEmailTakeView:onConfirm()
	self:close()
end

function ShareEmailTakeView:onShare()
	PopUpView.showPopUpView(ShareView, SHARE_MATCH_CONST)

	self:close()
end
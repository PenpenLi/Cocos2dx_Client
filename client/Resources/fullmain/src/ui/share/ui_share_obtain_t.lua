ui_share_obtain_t = class("ui_share_obtain_t", PopUpView)

function ui_share_obtain_t:ctor(prize)
	ui_share_obtain_t.super.ctor(self, true)

	self.panelRoot_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_share_obtain.json")
	self.panelRoot_:setVisible(false)
	self.nodeUI_:addChild(self.panelRoot_)

	local panelTitle = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Title")
	local sp = cc.Sprite:create("fullmain/res/acquire/share/title_share/title_share_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/share/title_share/title_share_", 0.05, 10000000000)
	sp:runAction(action)
	panelTitle:addChild(sp)

	local panelAnimation = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Animation")
	sp = cc.Sprite:create("fullmain/res/acquire/acquire_flash/acquire_flash_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/acquire_flash/acquire_flash_", 0.05, 10000000000)
	sp:runAction(action)
	panelAnimation:addChild(sp)

	local labelCount = ccui.Helper:seekWidgetByName(self.panelRoot_, "AtlasLabel_Count")
	labelCount:setString(prize)

	local labelTips = ccui.Helper:seekWidgetByName(self.panelRoot_, "Label_Tips")
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelTips:setString(string.format(LocalLanguage:getLanguageString("L_7e746dc76020d393"), prize))

	local btnConfirm = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))
end

function ui_share_obtain_t:onPopUpComplete()
	self.panelRoot_:setVisible(true)
	ccs.ActionManagerEx:getInstance():playActionByName("fullmain/res/json/ui_main_share_obtain.json", "Start");
end

function ui_share_obtain_t:onConfirm()
	self:close()
end
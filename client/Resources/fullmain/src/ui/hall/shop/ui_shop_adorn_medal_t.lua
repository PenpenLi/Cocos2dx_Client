ui_shop_adorn_medal_t = class("ui_shop_adorn_medal_t", PopUpView)

function ui_shop_adorn_medal_t:ctor(itemData)
	ui_shop_adorn_medal_t.super.ctor(self, true)

	self.itemData_ = itemData

	local cfg = shop_config[self.itemData_.index]

	self.panelRoot_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_adorn_medal.json")
	self.panelRoot_:setVisible(false)
	self.nodeUI_:addChild(self.panelRoot_)

	local panelTitle = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Title")
	local sp = cc.Sprite:create("fullmain/res/acquire/adorn/title_adorn/title_adorn_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/adorn/title_adorn/title_adorn_", 0.05, 10000000000)
	sp:runAction(action)
	panelTitle:addChild(sp)

	local panelAnimation = ccui.Helper:seekWidgetByName(self.panelRoot_, "Panel_Animation")
	sp = cc.Sprite:create("fullmain/res/acquire/acquire_flash/acquire_flash_1.png")
	local action = createWithFrameFileName("fullmain/res/acquire/acquire_flash/acquire_flash_", 0.05, 10000000000)
	sp:runAction(action)
	panelAnimation:addChild(sp)

	local itemIcon = ccui.Helper:seekWidgetByName(self.panelRoot_, "Image_Icon")
	itemIcon:loadTexture(string.format("fullmain/res/acquire/adorn/medal_%d.png", self.itemData_.index))

	local labelCount = ccui.Helper:seekWidgetByName(self.panelRoot_, "AtlasLabel_Count")
	labelCount:setString(self.itemData_.propertyGold)

	local labelTips = ccui.Helper:seekWidgetByName(self.panelRoot_, "Label_Tips")
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelTips:setString(string.format(LocalLanguage:getLanguageString("L_ef5ce420dd230f3b"), cfg.name, self.itemData_.propertyGold))

	local btnConfirm = ccui.Helper:seekWidgetByName(self.panelRoot_, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))
end

function ui_shop_adorn_medal_t:onPopUpComplete()
	self.panelRoot_:setVisible(true)
	ccs.ActionManagerEx:getInstance():playActionByName("fullmain/res/json/ui_main_adorn_medal.json", "Start");
end

function ui_shop_adorn_medal_t:onConfirm()
	self:close()
end
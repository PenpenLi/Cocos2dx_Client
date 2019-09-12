ui_shop_deal_t = class("ui_shop_deal_t", PopUpView)

function ui_shop_deal_t:ctor(itemData)
	ui_shop_deal_t.super.ctor(self, true)

	self.itemData_ = itemData

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shop_deal.json")
	self.nodeUI_:addChild(root)

	local cfg = shop_config[self.itemData_.index]

	local icon = ccui.Helper:seekWidgetByName(root, "Image_Icon")
	icon:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))

	local labelname = ccui.Helper:seekWidgetByName(root, "Label_Name")
	labelname:setString(string.format("%s", cfg.name))

	local labelPrice = ccui.Helper:seekWidgetByName(root, "Label_Price")
	labelPrice:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold)))

	local labelCount = ccui.Helper:seekWidgetByName(root, "Label_Count")
	labelCount:setString(string.format("%s", self.itemData_.count))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnRecovery = ccui.Helper:seekWidgetByName(root, "Button_Recovery")
	btnRecovery:addTouchEventListener(makeClickHandler(self, self.onRecovery))

	self.btnAuction_ = ccui.Helper:seekWidgetByName(root, "Button_Auction")
	self.btnAuction_:addTouchEventListener(makeClickHandler(self, self.onAuction))
end

function ui_shop_deal_t:onPopUpComplete()
	local guide = global.g_mainPlayer:getCurrentGuide()
	if not guide then return end

	if guide == GAME_GUIDES.GUIDE_SHOP_AUCTION then
		self.guideFinger_ = GuideFinger.new()

		self.guideFinger_:setPosition(cc.p(90, 18))
		self.btnAuction_:addChild(self.guideFinger_)
	end
end

function ui_shop_deal_t:onRecovery()
	PopUpView.showPopUpView(ui_shop_recovery_t, self.itemData_)

	self:close()
end

function ui_shop_deal_t:onAuction()
	PopUpView.showPopUpView(PutawayView, self.itemData_.index)

	self:close()
end

function ui_shop_deal_t:onCloseHandler()
	self:close()
end
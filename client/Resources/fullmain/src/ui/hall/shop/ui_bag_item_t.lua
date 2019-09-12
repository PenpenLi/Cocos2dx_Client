ui_bag_item_t = class("ui_bag_item_t")

function ui_bag_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_bag_item.json")
	local cfg = shop_config[self.itemData_.index]
	self.icon_ = ccui.Helper:seekWidgetByName(self.node_, "Image_2")
	self.labelCount_ = ccui.Helper:seekWidgetByName(self.node_, "Label_6")
	self.labelBuyPrice_ = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_3")

	if self.itemData_ then
		labelname:setString(cfg.name)
		self.icon_:setVisible(true)
		self.labelCount_:setVisible(true)
		self.labelBuyPrice_:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold)))
		self.icon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))
		self.labelCount_:setString(self.itemData_.count)
	else
		self.icon_:setVisible(false)
		self.labelCount_:setVisible(false)
		self.labelBuyPrice_:setVisible(false)
	end

	local btnRecovery = ccui.Helper:seekWidgetByName(self.node_, "Button_Recovery")
	btnRecovery:setPressedActionEnabled(true)
	btnRecovery:addTouchEventListener(makeClickHandler(self, self.onRecovery))
		
	local btnAuction = ccui.Helper:seekWidgetByName(self.node_, "Button_Auction")
	btnAuction:setPressedActionEnabled(true)
	btnAuction:addTouchEventListener(makeClickHandler(self, self.onAuction))
end

function ui_bag_item_t:setItemData(itemData)
	self.itemData_ = itemData
	if self.itemData_ then
		self.icon_:setVisible(true)
		self.labelCount_:setVisible(true)
		
		local cfg = shop_config[self.itemData_.index]
		self.icon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))
		self.labelCount_:setString(self.itemData_.count)
		self.labelBuyPrice_:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold)))
	else
		self.icon_:setVisible(false)
		self.labelCount_:setVisible(false)
		self.labelCount_:setVisible(false)
	end
end

function ui_bag_item_t:isEmpty()
	return self.itemData_ == nil
end

function ui_bag_item_t:getItemData()
	return self.itemData_
end

function ui_bag_item_t:onRecovery()
	if self:isEmpty() then
		return
	end

	if not global.g_mainPlayer:isBind3rdPay() then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_e368a61b336c7ede"),
					style = WarnTips.STYLE_YN,
					confirm = function()
							global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPLETE_MOMO)
						end
				}
			)
		return
	end

	PopUpView.showPopUpView(ui_shop_recovery_t, self.itemData_)
end

function ui_bag_item_t:onAuction()
	if self:isEmpty() then
		return
	end

	if not global.g_mainPlayer:isBind3rdPay() then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_e368a61b336c7ede"),
					style = WarnTips.STYLE_YN,
					confirm = function()
							global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPLETE_MOMO)
						end
				}
			)
		return
	end

	PopUpView.showPopUpView(PutawayView, self.itemData_.index)
end
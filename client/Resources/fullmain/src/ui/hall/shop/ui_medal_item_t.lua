ui_medal_item_t = class("ui_medal_item_t")

function ui_medal_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_medal_item.json")
	local cfg = shop_config[self.itemData_.index]
	self.icon_ = ccui.Helper:seekWidgetByName(self.node_, "Image_2")

	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_Name")

	if self.itemData_ then
		labelname:setString(cfg.name)
		self.icon_:setVisible(true)
		self.icon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))
	else
		self.icon_:setVisible(false)
	end

	local btnAdorn = ccui.Helper:seekWidgetByName(self.node_, "Button_Adorn")
	btnAdorn:setPressedActionEnabled(true)
	btnAdorn:addTouchEventListener(makeClickHandler(self, self.onAdorn))

	local btnGive = ccui.Helper:seekWidgetByName(self.node_, "Button_Give")
	btnGive:setPressedActionEnabled(true)
	btnGive:addTouchEventListener(makeClickHandler(self, self.onGive))
end

function ui_medal_item_t:setItemData(itemData)
	self.itemData_ = itemData
	if self.itemData_ then
		self.icon_:setVisible(true)
		
		local cfg = shop_config[self.itemData_.index]
		self.icon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))
	else
		self.icon_:setVisible(false)
	end
end

function ui_medal_item_t:isEmpty()
	return self.itemData_ == nil
end

function ui_medal_item_t:getItemData()
	return self.itemData_
end

function ui_medal_item_t:onAdorn()
	if self:isEmpty() then
		return
	end

	local cfg = shop_config[self.itemData_.index]
	WarnTips.showTips(
			{
				text = string.format(LocalLanguage:getLanguageString("L_b5bfd5953a22ea61"), cfg.name),
				style = WarnTips.STYLE_YN,
				confirm = function()
					gatesvr.sellPropertyItem(self.itemData_.index, 1)
				end
			}
		)
end

function ui_medal_item_t:onGive()
	if self:isEmpty() then
		return
	end

	PopUpView.showPopUpView(ui_shop_give_t, self.itemData_)
end
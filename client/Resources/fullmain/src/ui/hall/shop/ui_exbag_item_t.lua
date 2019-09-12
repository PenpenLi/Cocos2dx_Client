ui_exbag_item_t = class("ui_exbag_item_t")

function ui_exbag_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shopItem.json")

	self.panelIcon_ = ccui.Helper:seekWidgetByName(self.node_, "Panel_Icon")

	local tip = ccui.Helper:seekWidgetByName(self.node_, "Image_10")
	tip:loadTexture("fullmain/res/shop/img_yysl.png")

	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_3")

	self.labelCount_ = ccui.Helper:seekWidgetByName(self.node_, "Label_6")
	self.labelBuyPrice_ = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	
	if self.itemData_ then
		labelname:setString(self.itemData_.ItemName)
		self.labelCount_:setVisible(true)
		self.labelBuyPrice_:setString(string.format("%s", moneyFormat(self.itemData_.ItemPrice)))
		if self.itemData_.Amount > 1 then
			self.labelCount_:setString(self.itemData_.Amount)
			tip:setVisible(true)
		else
			self.labelCount_:setString("")
			tip:setVisible(false)
		end

		if self.itemData_.Virtual then
			local imageLocal = ui_image_local_t.new(self.itemData_.ItemImg)
			self.panelIcon_:addChild(imageLocal)
		else
			local imageRemote = ui_image_remote_t.new(self.itemData_.ItemImg, cc.size(98, 98))
			self.panelIcon_:addChild(imageRemote)
		end
	else
		self.labelCount_:setVisible(false)
	end

	local btn_operate = ccui.Helper:seekWidgetByName(self.node_, "Button_11")
	btn_operate:loadTextures("fullmain/res/shop/btn_smzf.png", "fullmain/res/shop/btn_smzf.png", "fullmain/res/shop/btn_smzf.png")
	btn_operate:setPressedActionEnabled(true)
	btn_operate:addTouchEventListener(makeClickHandler(self, self.onTouchItem))
end

function ui_exbag_item_t:isEmpty()
	return self.itemData_ == nil
end

function ui_exbag_item_t:getItemData()
	return self.itemData_
end

function ui_exbag_item_t:onTouchItem()
	if self:isEmpty() then return end

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

	if self.itemData_.Virtual then
		PopUpView.showPopUpView(ui_pay_code_t)
	else
		PopUpView.showPopUpView(ui_exchange_code_t, self.itemData_.OrderID)
	end
end
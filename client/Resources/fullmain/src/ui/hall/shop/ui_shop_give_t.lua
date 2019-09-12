ui_shop_give_t = class("ui_shop_give_t", PopUpView)

function ui_shop_give_t:ctor(itemData)
	ui_shop_give_t.super.ctor(self, true)

	self.itemData_ = itemData

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shop_give.json")
	self.nodeUI_:addChild(root)

	local cfg = shop_config[self.itemData_.index]

	local icon = ccui.Helper:seekWidgetByName(root, "Image_5")
	icon:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))

	local labelname = ccui.Helper:seekWidgetByName(root, "Label_6")
	labelname:setString(string.format("%s", cfg.name))

	local labelCount = ccui.Helper:seekWidgetByName(root, "Label_7")
	labelCount:setString(self.itemData_.count)

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancelHandler))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.inputUser_ = createCursorTextField(root, "TextField_User", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputCount_ = createCursorTextField(root, "TextField_Count", cc.EDITBOX_INPUT_MODE_NUMERIC)
end

function ui_shop_give_t:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedBox_ ~= sender then
			self.selectedBox_:setSelected(false)
			self.selectedBox_ = sender

			if self.selectedBox_ == self.checkId_ then
				self.giveSign_ = 0
				self.inputReceiver_:setPlaceHolder(LocalLanguage:getLanguageString("L_9df6d77db43efbde"))
				self.inputReceiver_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
			elseif self.selectedBox_ == self.checkAccount_ then
				self.giveSign_ = 1
				self.inputReceiver_:setPlaceHolder(LocalLanguage:getLanguageString("L_4ba9bd7a91ce0703"))
				self.inputReceiver_:setInputMode(cc.EDITBOX_INPUT_MODE_ANY)
			end
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function ui_shop_give_t:onCancelHandler()
	self:close()
end

function ui_shop_give_t:onCloseHandler()
	self:close()
end

function ui_shop_give_t:onConfirmHandler()
	local receiver = string.trim(self.inputUser_:getText())
	local len = utf8.len(receiver)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_2b85ac2501ed4b22"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	local count = tonumber(self.inputCount_:getText())
	if count <= 0 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_81204b6924f3b15d"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	elseif count > self.itemData_.count then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_837773af36acbc34"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	gatesvr.sendItemGive(self.itemData_.index, count, tonumber(receiver))
end

function ui_shop_give_t:onGiveSuccessHandler()
	self:close()
end

function ui_shop_give_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS, self, self.onGiveSuccessHandler)
end

function ui_shop_give_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS, self)
end
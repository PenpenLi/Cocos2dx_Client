ui_shop_recovery_t = class("ui_shop_recovery_t", PopUpView)

function ui_shop_recovery_t:ctor(itemData)
	ui_shop_recovery_t.super.ctor(self, true)

	self.itemData_ = itemData

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shop_recovery.json")
	self.nodeUI_:addChild(root)

	local cfg = shop_config[self.itemData_.index]

	local icon = ccui.Helper:seekWidgetByName(root, "Image_5")
	icon:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))

	local labelname = ccui.Helper:seekWidgetByName(root, "Label_6")
	labelname:setString(string.format("%s", cfg.name))

	local labelRecoveryPrice = ccui.Helper:seekWidgetByName(root, "Label_7")
	labelRecoveryPrice:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold*cfg.discount/100)))

	local labelCount = ccui.Helper:seekWidgetByName(root, "Label_8")
	labelCount:setString(string.format("%s", self.itemData_.count))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_27")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnRecovery = ccui.Helper:seekWidgetByName(root, "Button_23")
	btnRecovery:setPressedActionEnabled(true)
	btnRecovery:addTouchEventListener(makeClickHandler(self, self.onRecoveryHandler))

	local btnGive = ccui.Helper:seekWidgetByName(root, "Button_24")
	btnGive:setPressedActionEnabled(true)
	btnGive:addTouchEventListener(makeClickHandler(self, self.onGiveHandler))

	local labelId = ccui.Helper:seekWidgetByName(root, "Label_25")
	labelId:setString(string.format("%d", global.g_mainPlayer:getGameId()))
	labelId:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local score = global.g_mainPlayer:getPlayerScore()
	local labelScore = ccui.Helper:seekWidgetByName(root, "Label_26")
	labelScore:setString(string.format("%s", number_format(score)))
	labelScore:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	if cfg.canGive == 0 then
		btnGive:setVisible(false)
		btnRecovery:setPositionX(0)
	end

	self.inputCount_ = createCursorTextField(root, "TextField_Count", cc.EDITBOX_INPUT_MODE_NUMERIC)
	-- self.inputCount_:setFontColor(cc.c3b(0, 0, 0))
end

function ui_shop_recovery_t:onPopUpComplete()
	-- gatesvr.sendGetPayCode2(self.itemData_.index, self.itemData_.count)
	-- gatesvr.sendUserExchange()
end

function ui_shop_recovery_t:onRecoveryHandler()
	local strCount = string.trim(self.inputCount_:getText())
	len = utf8.len(strCount)
	if len < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_9b804b388b0107b3"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local count = tonumber(strCount)
	gatesvr.sellPropertyItem(self.itemData_.index, count)
end

function ui_shop_recovery_t:onGiveHandler()
	PopUpView.showPopUpView(ui_shop_give_t, self.itemData_)

	self:close()
end

function ui_shop_recovery_t:onCloseHandler()
	self:close()
end

function ui_shop_recovery_t:onSellSuccessHandler()
	self:close()
end

function ui_shop_recovery_t:onGetPaycode2SuccessHandler(paycode)
	local content = string.format("%s%d", paycode, global.g_mainPlayer:getPlayerId())

	local qr = util:createQRSprite(content, 120, 5)
	qr:setPosition(130, 100)
	self.nodeUI_:addChild(qr)
end

function ui_shop_recovery_t:onCodeExchangeSuccess()
	WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_f71b0775fe3eafdc"),
			style = WarnTips.STYLE_Y
		}
	)

	self:close()
end

function ui_shop_recovery_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self, self.onSellSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE2_SUCCESS, self, self.onGetPaycode2SuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self, self.onCodeExchangeSuccess)
end

function ui_shop_recovery_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE2_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self)
end
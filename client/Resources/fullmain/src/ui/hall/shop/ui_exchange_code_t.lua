ui_exchange_code_t = class("ui_exchange_code_t", PopUpView)

function ui_exchange_code_t:ctor(orderId)
	ui_exchange_code_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_exchange_code.json")
	self.nodeUI_:addChild(root)

	local labelOrder = ccui.Helper:seekWidgetByName(root, "Label_2")
	labelOrder:setString(string.format(LocalLanguage:getLanguageString("L_f78aa406d3d4865f"), orderId))

	local qr = util:createQRSprite(orderId, 300, 5)
	qr:setPosition(-155, -210)
	root:addChild(qr)

	-- local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_3")
	-- btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))
end

function ui_exchange_code_t:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
	self:close()
end

function ui_exchange_code_t:onPopUpComplete()
	gatesvr.sendUserExchange()
end

function ui_exchange_code_t:onPopBackComplete()
	gatesvr.sendInsureInfoQuery(true)
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS)
end

function ui_exchange_code_t:onConfirmHandler()
	self:close()
end

function ui_exchange_code_t:onCodeExchangeSuccess()
	WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_f71b0775fe3eafdc"),
			style = WarnTips.STYLE_Y
		}
	)

	self:close()
end

function ui_exchange_code_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self, self.onCodeExchangeSuccess)
end

function ui_exchange_code_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self)
end
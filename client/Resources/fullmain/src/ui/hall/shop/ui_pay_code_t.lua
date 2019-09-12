ui_pay_code_t = class("ui_pay_code_t", PopUpView)

function ui_pay_code_t:ctor()
	ui_pay_code_t.super.ctor(self, true)

	self.root_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_pay_code.json")
	self.nodeUI_:addChild(self.root_)

	self.labelCode_ = ccui.Helper:seekWidgetByName(self.root_, "Label_2")
	self.labelCode_:setString("")
	-- local btnConfirm = ccui.Helper:seekWidgetByName(self.root_, "Button_3")
	-- btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))
end

function ui_pay_code_t:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
	self:close()
end

function ui_pay_code_t:onPopUpComplete()
	gatesvr.sendGetPayCode()
	gatesvr.sendUserExchange()
end

function ui_pay_code_t:onPopBackComplete()
	gatesvr.sendInsureInfoQuery(true)
	
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS)
end

function ui_pay_code_t:onConfirmHandler()
	self:close()
end

function ui_pay_code_t:onGetPayCodeSuccessHandler(paycode)
	local content = string.format("%s%d", paycode, global.g_mainPlayer:getPlayerId())

	self.labelCode_:setString(content)

	local qr = util:createQRSprite(content, 180, 5)
	qr:setPosition(-95, -120)
	self.root_:addChild(qr)
end

function ui_pay_code_t:onCodeExchangeSuccess()
	WarnTips.showTips(
		{
			text = LocalLanguage:getLanguageString("L_f71b0775fe3eafdc"),
			style = WarnTips.STYLE_Y
		}
	)

	self:close()
end

function ui_pay_code_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS, self, self.onGetPayCodeSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self, self.onCodeExchangeSuccess)
end

function ui_pay_code_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_CODE_EXCHANGE_SUCCESS, self)
end
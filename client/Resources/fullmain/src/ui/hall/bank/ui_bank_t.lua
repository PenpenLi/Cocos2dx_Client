ui_bank_t = class("ui_bank_t", PopUpView)

function ui_bank_t:ctor(cash, save)
	ui_bank_t.super.ctor(self, true)

	self.cash_ = cash
	self.save_ = save

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_bank.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnSave = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnSave:addTouchEventListener(makeClickHandler(self, self.onSaveHandler))

	local btnTake = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnTake:addTouchEventListener(makeClickHandler(self, self.onTakeHandler))

	self.labelCash_ = ccui.Helper:seekWidgetByName(root, "Label_4")

	self.labelSave_ = ccui.Helper:seekWidgetByName(root, "Label_5")

	self.inputMoney_ = ccui.EditBox:create(cc.size(315, 40), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputMoney_:setMaxLength(9)
	self.inputMoney_:setInputMode(cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputMoney_:setPlaceHolder(LocalLanguage:getLanguageString("L_5774019a88ce92a7"))
	self.inputMoney_:setPosition(cc.p(-59, -17))
	self.inputMoney_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputMoney_)

	self.inputPassword_ = ccui.EditBox:create(cc.size(315, 40), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputPassword_:setPlaceHolder(LocalLanguage:getLanguageString("L_70504651fb010f6d"))
	self.inputPassword_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.inputPassword_:setPosition(cc.p(-59, -82))
	self.inputPassword_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputPassword_)

	self:refreshData()
end

function ui_bank_t:refreshData()
	self.labelCash_:setString("$" .. number_format(self.cash_))
	self.labelSave_:setString(LocalLanguage:getLanguageString("L_438f2dd7a1354c8a") .. number_format(self.save_))
end

function ui_bank_t:onSaveHandler()
	local moneyStr = string.trim(self.inputMoney_:getText())
	local len = utf8.len(moneyStr)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_6fb43b32a447132e"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	local num = tonumber(moneyStr)
	gatesvr.sendInsureSaveScore(num)
end

function ui_bank_t:onTakeHandler()
	local moneyStr = string.trim(self.inputMoney_:getText())
	local len = utf8.len(moneyStr)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_6fb43b32a447132e"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	local num = tonumber(moneyStr)
	local password = string.trim(self.inputPassword_:getText())
	len = utf8.len(password)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_7bd9653371994efc"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end
	gatesvr.sendInsureTaskScore(num, password)
end

function ui_bank_t:onCloseHandler()
	self:close()
end

function ui_bank_t:onPopUpComplete()
	gatesvr.sendInsureInfoQuery()
end

function ui_bank_t:onSuccessHandler(cash, save)
	self.cash_ = cash
	self.save_ = save

	self.inputMoney_:setText("")
	self.inputPassword_:setText("")
	self:refreshData()
end

function ui_bank_t:onBankInfoHandler(enableTransfer, revenueTake, revenueTransfer, revenueTransferMember, serverId, userScore, userInsure, transferRequire)
	self.cash_ = userScore
	self.save_ = userInsure

	self:refreshData()
end	

function ui_bank_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BANK_INFO, self, self.onBankInfoHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BANK_SUCCESS, self, self.onSuccessHandler)
end

function ui_bank_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BANK_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BANK_SUCCESS, self)
end
ui_bank_openUp_t = class("ui_bank_openUp_t", PopUpView)

function ui_bank_openUp_t:ctor()
	ui_bank_openUp_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_bank_openUp.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnOpen = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnOpen:addTouchEventListener(makeClickHandler(self, self.onOpenHandler))

	self.input1_ = ccui.EditBox:create(cc.size(315, 42), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.input1_:setMaxLength(MAX_PWD_LEN)
	self.input1_:setPlaceHolder(LocalLanguage:getLanguageString("L_d0fd6ce55c8329a3"))
	self.input1_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.input1_:setPosition(cc.p(-28, 20))
	self.input1_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.input1_)

	self.input2_ = ccui.EditBox:create(cc.size(315, 42), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.input2_:setMaxLength(MAX_PWD_LEN)
	self.input2_:setPlaceHolder(LocalLanguage:getLanguageString("L_70504651fb010f6d"))
	self.input2_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.input2_:setPosition(cc.p(-28, -60))
	self.input2_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.input2_)

	local bg2 = ccui.Helper:seekWidgetByName(root, "Image_3")
	if global.g_mainPlayer:isLogin3rdAvailable() then
		bg2:loadTexture("fullmain/res/bank/bankInput3.png")
		self.input2_:setPlaceHolder(LocalLanguage:getLanguageString("L_d0fd6ce55c8329a3"))
	else
		bg2:loadTexture("fullmain/res/bank/bankInput2.png")
		self.input2_:setPlaceHolder(LocalLanguage:getLanguageString("L_70504651fb010f6d"))
	end
end

function ui_bank_openUp_t:onOpenHandler()
	local password = string.trim(self.input1_:getText())
	if not checkPasswordValid(password) then
		return
	end

	if global.g_mainPlayer:isLogin3rdAvailable() then
		--微信帐号开通银行
		local loginPass = string.trim(self.input2_:getText())
		if not checkPasswordValid(loginPass) then
			return
		end

		local data = global.g_mainPlayer:getLoginData3rd()
		local location = global.g_mainPlayer:getLocationCity()
		
		gatesvr.sendWXEnableInsure(data.userid, loginPass, password, location)
	else
		--普通开通银行
		local apass = string.trim(self.input2_:getText())
		if password ~= apass then
			WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_4cc52d214af137f5"),
						style = WarnTips.STYLE_Y
					}
				)
			return
		end

		gatesvr.sendEnableInsure(password)
	end
end

function ui_bank_openUp_t:onCloseHandler()
	self:close()
end

function ui_bank_openUp_t:onBankOpenSuccess()
	self:close()

	PopUpView.showPopUpView(ui_bank_t, 0, 0)
end

function ui_bank_openUp_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BANK_OPEN_SUCCESS, self, self.onBankOpenSuccess)
end

function ui_bank_openUp_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BANK_OPEN_SUCCESS, self)
end
ui_changePassword_t = class("ui_changePassword_t", PopUpView)

function ui_changePassword_t:ctor()
	PopUpView.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_password.json")
	self.nodeUI_:addChild(root)

	self.inputold_ = ccui.EditBox:create(cc.size(282, 45), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputold_:setMaxLength(MAX_PWD_LEN)
	self.inputold_:setPlaceHolder(LocalLanguage:getLanguageString("L_52e6596f1817ecad"))
	self.inputold_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.inputold_:setPosition(cc.p(-58, 70))
	self.inputold_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputold_)

	self.inputnew1_ = ccui.EditBox:create(cc.size(282, 45), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputnew1_:setMaxLength(MAX_PWD_LEN)
	self.inputnew1_:setPlaceHolder(LocalLanguage:getLanguageString("L_2ad8f246428e11be"))
	self.inputnew1_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.inputnew1_:setPosition(cc.p(-58, 12))
	self.inputnew1_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputnew1_)

	self.inputnew2_ = ccui.EditBox:create(cc.size(282, 45), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputnew2_:setMaxLength(MAX_PWD_LEN)
	self.inputnew2_:setPlaceHolder(LocalLanguage:getLanguageString("L_f9a5897bc35eab45"))
	self.inputnew2_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.inputnew2_:setPosition(cc.p(-58, -46))
	self.inputnew2_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputnew2_)

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_5")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirn))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))
end

function ui_changePassword_t:onConfirn()
	local pass1 = string.trim(self.inputold_:getText())
	if not checkPasswordValid(pass1) then
		return
	end

	local pass2 = string.trim(self.inputnew1_:getText())
	if not checkPasswordValid(pass2) then
		return
	end

	local pass3 = string.trim(self.inputnew2_:getText())
	if pass3 ~= pass2 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_4cc52d214af137f5"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local playerId = global.g_mainPlayer:getPlayerId()
	gatesvr.sendModifyLoginPassword(playerId, pass1, pass2)
	self:close()
end

function ui_changePassword_t:onCancel()
	self:close()
end
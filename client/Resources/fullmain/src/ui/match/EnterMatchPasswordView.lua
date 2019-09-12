EnterMatchPasswordView = class("EnterMatchPasswordView", PopUpView)

function EnterMatchPasswordView:ctor(serverId, cbConfirm, cbCancel)
	EnterMatchPasswordView.super.ctor(self, true)

	self.serverId_ = serverId
	self.cbConfirm_ = cbConfirm
	self.cbCancel_ = cbCancel

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/selectLevel/ui_main_room_password.json")
	self.nodeUI_:addChild(root)

	local tip=ccui.Helper:seekWidgetByName(root, "Label_8")
	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_5")
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))

	-- self.inputPassword_ = ccui.EditBox:create(cc.size(275, 35), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	-- self.inputPassword_:setPlaceHolder(LocalLanguage:getLanguageString("L_2e390028ca4d2476"))
	-- self.inputPassword_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	-- self.inputPassword_:setPosition(cc.p(-80, -5))
	-- self.inputPassword_:setAnchorPoint(cc.p(0, 0.5))
	self.inputPassword_ = createCursorTextField(root, "TextField_Pass")
	-- root:addChild(self.inputPassword_)
end

function EnterMatchPasswordView:onConfirm()
	local password = string.trim(self.inputPassword_:getText())
	len = utf8.len(password)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_2e390028ca4d2476"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	if self.cbConfirm_ then
		self.cbConfirm_(self.serverId_, password)
	end

	self:close()
end

function EnterMatchPasswordView:onCancel()
	if self.cbCancel_ then
		self.cbCancel_(self.serverId_)
	end
	self:close()
end
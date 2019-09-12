ui_cancelShangXiaFen_t = class("ui_cancelShangXiaFen_t", PopUpView)

function ui_cancelShangXiaFen_t:ctor(orderId, playerId, account, spreaderId, scoreType, score, msg, time)
	ui_cancelShangXiaFen_t.super.ctor(self, true)

	self.orderId_ = orderId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_cancelshangxiafen.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_11")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_10")
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCanel))

	local labelType = ccui.Helper:seekWidgetByName(root, "Label_4")
	labelType:setString(LocalLanguage:getLanguageString("L_25d17cea9ace7d38")[scoreType])

	local labelScore = ccui.Helper:seekWidgetByName(root, "Label_5")
	labelScore:setString(score)

	local labelMsg = ccui.Helper:seekWidgetByName(root, "Label_7")
	labelMsg:setString(msg)

	local labelTime = ccui.Helper:seekWidgetByName(root, "Label_8")
	labelTime:setString(time)

	self.inputPwd_ = createCursorTextField(root, "TextField_Password")
end

function ui_cancelShangXiaFen_t:onCanel()
	local password = string.trim(self.inputPwd_:getText())
	if utf8.len(password) < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_3c28084be659ee3d"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	gatesvr.sendScoreApplyCancel(self.orderId_, password)

	self:close()
end

function ui_cancelShangXiaFen_t:onClose()
	self:close()
end
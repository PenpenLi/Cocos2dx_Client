ui_applyShangXiaFen_t = class("ui_applyShangXiaFen_t", PopUpView)

function ui_applyShangXiaFen_t:ctor()
	ui_applyShangXiaFen_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_applyshangxiafen.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	local btnUp = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnUp:addTouchEventListener(makeClickHandler(self, self.onShangeFen))

	local btnDown = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnDown:addTouchEventListener(makeClickHandler(self, self.onXiaFen))

	self.inputScore_ = createCursorTextField(root, "TextField_Score", cc.EDITBOX_INPUT_MODE_NUMERIC)

	self.inputPwd_ = createCursorTextField(root, "TextField_Password")

	self.inputMsg_ = createCursorTextField(root, "TextField_Msg")
end

-- function ui_applyShangXiaFen_t:onInputMsgHandler(event)
-- 	if event == "began" then
-- 		self.labelMsg_:setVisible(false)
-- 		self.inputMsg_:setVisible(true)
-- 	elseif event == "ended" then
-- 		local msg = self.inputMsg_:getText()
-- 		local len = utf8.len(msg)

-- 		if len > 0 then
-- 			self.labelMsg_:setString(msg)
-- 			self.labelMsg_:setTextColor(cc.c4b(255, 255, 255, 255))
-- 		else
-- 			self.labelMsg_:setString(LocalLanguage:getLanguageString("L_a3a865a127089884"))
-- 			self.labelMsg_:setTextColor(cc.c4b(166, 166, 166, 255))
-- 		end

-- 		self.labelMsg_:setVisible(true)
-- 		self.inputMsg_:setVisible(false)
-- 	elseif event == "return" then

-- 	elseif event == "changed" then

-- 	elseif event == "cancel" then
-- 		self.labelMsg_:setVisible(true)
-- 		self.inputMsg_:setVisible(false)
-- 	end
-- end

-- function ui_applyShangXiaFen_t:onLabelMsgHandler()
-- 	self.inputMsg_:touchDownAction(self.inputMsg_, ccui.TouchEventType.ended)
-- end

function ui_applyShangXiaFen_t:onShangeFen()
	local score = tonumber(self.inputScore_:getText())
	if not score or score < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b0b2f330b55df29"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end
	
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
	local msg = self.inputMsg_:getText()
	gatesvr.sendScoreApply(APPLY_SCORE_TYPE_ADD, password, score, msg)

	self:close()
end

function ui_applyShangXiaFen_t:onXiaFen()
	local score = tonumber(self.inputScore_:getText())
	if not score or score < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8b0b2f330b55df29"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end
	
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
	local msg = self.inputMsg_:getText()
	gatesvr.sendScoreApply(APPLY_SCORE_TYPE_DOWN, password, score, msg)

	self:close()
end

function ui_applyShangXiaFen_t:onClose()
	self:close()
end
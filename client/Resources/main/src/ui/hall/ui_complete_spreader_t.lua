ui_complete_spreader_t = class("ui_complete_spreader_t", PopUpView)

function ui_complete_spreader_t:ctor(confirmCall, cancelCall)
	PopUpView.ctor(self, true)

	self.confirmCall_ = confirmCall
	self.cancelCall_ = cancelCall

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_complete_spreader.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_12")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local labelTips = ccui.Helper:seekWidgetByName(root, "Label_Tips")
	labelTips:setTextColor(cc.c4b(255,255,0,255))
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local panelRealName = ccui.Helper:seekWidgetByName(root, "Image_RealName")
	local panelMoMo = ccui.Helper:seekWidgetByName(root, "Image_Momo")
	local panelZaloPay = ccui.Helper:seekWidgetByName(root, "Image_ZaloPay")

	self.inputSpreaderId_ = createCursorTextField(root, "TextField_Spreader", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputRealName_ = createCursorTextField(root, "TextField_RealName")
	self.inputViMomo_ = createCursorTextField(root, "TextField_ViMoMo", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputZaloPay_ = createCursorTextField(root, "TextField_ZaloPay", cc.EDITBOX_INPUT_MODE_NUMERIC)

	local spreaderId = global.g_mainPlayer:getSpreaderId()
	if spreaderId > 0 then
		local panelSpreader = ccui.Helper:seekWidgetByName(root, "Image_7")
		panelSpreader:setVisible(false)

		self.inputSpreaderId_:setText(spreaderId)
		self.inputSpreaderId_:setEnabled(false)
	end

	local realname = global.g_mainPlayer:getRealname()
	self.inputRealName_:setText(realname)

	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	if isBindMoMo then
		panelMoMo:setVisible(false)
		panelRealName:setVisible(false)

		local momo = global.g_mainPlayer:getViMomo()
		self.inputViMomo_:setText(momo)
		self.inputViMomo_:setEnabled(false)
	end

	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()
	if isBindZaloPay then
		panelZaloPay:setVisible(false)
		panelRealName:setVisible(false)

		local zalopay = global.g_mainPlayer:getZaloPay()
		self.inputZaloPay_:setText(zalopay)
		self.inputZaloPay_:setEnabled(false)
	end
end

function ui_complete_spreader_t:onPopUpComplete()
	global.g_mainPlayer:addPopSpreaderCount()
end

function ui_complete_spreader_t:onCancelCall()
	if self.cancelCall_ then
		self.cancelCall_()
	end
end

function ui_complete_spreader_t:onConfirmCall()
	if self.confirmCall_ then
		self.confirmCall_()
	end
end

function ui_complete_spreader_t:onClose()
	self:onCancelCall()

	self:close()
end

function ui_complete_spreader_t:onConfirm()
	local spreaderId = global.g_mainPlayer:getSpreaderId()

	if spreaderId <= 0 then
		local strSpreaderId = string.trim(self.inputSpreaderId_:getText())
		spreaderId = tonumber(strSpreaderId) or 0

		if spreaderId <= 0 then
			WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_a93efaf69e57f8a5"),
						style = WarnTips.STYLE_Y
					}
				)
			return
		end
	end

	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()

	local strname = string.trim(self.inputRealName_:getText())
	local strmomo = string.trim(self.inputViMomo_:getText())
	local strzalopay = string.trim(self.inputZaloPay_:getText())
	if (utf8.len(strname) < 1 and utf8.len(strmomo) < 1 and utf8.len(strzalopay) < 1) or (isBindMoMo and isBindZaloPay) then
		gatesvr.sendUserInfoUpdateNew(spreaderId, strname, strmomo, strzalopay, "", "", "")
	elseif utf8.len(strname) < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_26e44355b1255301"),
					style = WarnTips.STYLE_Y
				}
			)
	elseif utf8.len(strmomo) < 1 and utf8.len(strzalopay) < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_6345b2ec3788f4b4"),
					style = WarnTips.STYLE_Y
				}
			)
	else
		local rmomo = string.find(strmomo, "^0%d%d%d%d%d%d%d%d%d%d?$")
		if not rmomo then
			strmomo = ""
		end

		local rzalopay = string.find(strzalopay, "^0%d%d%d%d%d%d%d%d%d%d?$")
		if not rzalopay then
			strzalopay = ""
		end

		if isBindMoMo and not rzalopay then
			WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_02213ba031e6a1f6"),
						style = WarnTips.STYLE_Y
					}
				)
			return
		elseif isBindZaloPay and not rmomo then
			WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_957d37d06c98b9d0"),
						style = WarnTips.STYLE_Y
					}
				)
			return
		elseif not rmomo and not rzalopay then
			WarnTips.showTips(
					{
						text = LocalLanguage:getLanguageString("L_6345b2ec3788f4b4"),
						style = WarnTips.STYLE_Y
					}
				)
			return
		end

		gatesvr.sendUserInfoUpdateNew(spreaderId, strname, strmomo, strzalopay, "", "", "")
	end
end

function ui_complete_spreader_t:onCancel()
	self:onCancelCall()

	self:close()
end

function ui_complete_spreader_t:onCompleteSpreaderSuccess()
	self:onConfirmCall()
	
	self:close()
end

function ui_complete_spreader_t:onCompleteSpreaderPasswordSuccess()
	self:onConfirmCall()
	
	self:close()
end

function ui_complete_spreader_t:onModifyDataBindSuccess()
	self:onConfirmCall()
	
	self:close()
end

function ui_complete_spreader_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self, self.onCompleteSpreaderSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self, self.onCompleteSpreaderPasswordSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self, self.onModifyDataBindSuccess)
end

function ui_complete_spreader_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self)
end
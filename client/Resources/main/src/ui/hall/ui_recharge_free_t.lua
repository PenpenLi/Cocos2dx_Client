ui_recharge_free_t = class("ui_recharge_free_t", PopUpView)

function ui_recharge_free_t:ctor(min)
	PopUpView.ctor(self, true)

	self.minCount_ = min

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_recharge_free.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_Confirm")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	self.inputCount_ = createCursorTextField(root, "TextField_Count", cc.EDITBOX_INPUT_MODE_NUMERIC)
end

function ui_recharge_free_t:onConfirm()
	local countStr = string.trim(self.inputCount_:getText())
	local count = tonumber(countStr) or 0
	count = math.ceil(count)

	if count < self.minCount_ then
		WarnTips.showTips(
				{
					text = string.format(LocalLanguage:getLanguageString("L_bba676f3e88d7d13"), self.minCount_),
					style = WarnTips.STYLE_Y
				}
			)
	else
		global.g_gameDispatcher:sendMessage(GAME_MESSAGE_NGANLUONG_FREE_COUNT, count)
		self:close()
	end
end

function ui_recharge_free_t:onCloseHandler()
	self:close()
end
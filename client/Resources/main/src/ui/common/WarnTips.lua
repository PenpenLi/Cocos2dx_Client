WarnTips = class("WarnTips", PopUpView)

WarnTips.STYLE_YN = 1
WarnTips.STYLE_Y = 2

function WarnTips.showTips(options)
	PopUpView.showPopUpView(WarnTips, options)
end

function WarnTips:ctor(options)
	WarnTips.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_warmTips.json")
	self.nodeUI_:addChild(root)

	local bg = ccui.Helper:seekWidgetByName(root, "Image_1")
	local size = bg:getContentSize()

	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_2")
	labelContent:setTextColor(cc.c3b(0x46, 0x34, 0x7f))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local content = ""
	local style = STYLE_YN
	if type(options) == "string" then
		content = options
	elseif type(options) == "table" then
		content = options.text or ""

		root:setScale(options.scale or 1)
		self.cbConfirm_ = options.confirm
		self.cbCancel_ = options.cancel
		style = options.style or STYLE_YN
	end

	if style == WarnTips.STYLE_Y then
		btnCancel:setVisible(false)

		btnConfirm:setPositionX(size.width / 2)
	end

	labelContent:setString(content)
end

function WarnTips:onConfirm()
	if self.cbConfirm_ then
		self.cbConfirm_()
	end

	self:close()
end

function WarnTips:onCancel()
	if self.cbCancel_ then
		self.cbCancel_()
	end

	self:close()
end

function WarnTips:onReplaceScene()
	self:close()
end

function WarnTips:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_REPLACE_SCENE, self, self.onReplaceScene)
end

function WarnTips:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_REPLACE_SCENE, self)
end
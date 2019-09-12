VendingTips = class("VendingTips", PopUpView)

VendingTips.STYLE_YN = 1
VendingTips.STYLE_Y = 2

function VendingTips.showTips(options)
	PopUpView.showPopUpView(VendingTips, options)
end

function VendingTips:ctor(options)
	VendingTips.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_vending.json")
	self.nodeUI_:addChild(root)

	local bg = ccui.Helper:seekWidgetByName(root, "Image_1")
	local size = bg:getContentSize()

	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_2")

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCancel))

	local content = ""
	local style = STYLE_YN
	if type(options) == "string" then
		content = options
	elseif type(options) == "table" then
		content = options.text or ""
		self.cbConfirm_ = options.confirm
		self.cbCancel_ = options.cancel
		style = options.style or STYLE_YN
	end

	if style == VendingTips.STYLE_Y then
		btnCancel:setVisible(false)

		btnConfirm:setPositionX(size.width / 2)
	end

	labelContent:setString(content)
end

function VendingTips:onConfirm()
	if self.cbConfirm_ then
		self.cbConfirm_()
	end

	self:close()
end

function VendingTips:onCancel()
	if self.cbCancel_ then
		self.cbCancel_()
	end

	self:close()
end
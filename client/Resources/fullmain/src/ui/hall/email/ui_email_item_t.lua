ui_email_item_t = class("ui_email_item_t")

function ui_email_item_t:ctor(emailData)
	self.emailData_ = emailData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_email_item.json")

	local labelTitle = ccui.Helper:seekWidgetByName(self.node_, "Label_3")
	labelTitle:setString(self.emailData_.Title)

	local labelSender = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	labelSender:setString(LocalLanguage:getLanguageString("L_1224824cbefeaee0"))

	local labelTime = ccui.Helper:seekWidgetByName(self.node_, "Label_5")
	labelTime:setString(self.emailData_.InsertTime)

	self.redPoint_ = ccui.Helper:seekWidgetByName(self.node_, "Image_RedPoint")
	self.redPoint_:setVisible(self.emailData_.boolRead == 0)

	local check = ccui.Helper:seekWidgetByName(self.node_, "Button_12")
	check:setPressedActionEnabled(true)
	check:addTouchEventListener(makeClickHandler(self, self.onTouchItem))
end

function ui_email_item_t:onTouchItem()
	self.redPoint_:setVisible(false)
	PopUpView.showPopUpView(ui_email_info_t, self.emailData_)
end
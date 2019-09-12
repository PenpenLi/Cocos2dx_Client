ui_email_info_t = class("ui_email_info_t", PopUpView)

local LABLE_STATUS = {
	[1] = LocalLanguage:getLanguageString("L_e0b7f27dbb6083d5"),
	[11] = LocalLanguage:getLanguageString("L_836f9a9c557b8b3b"),
	[12] = LocalLanguage:getLanguageString("L_3724c60de0ba02b8"),
	[13] = LocalLanguage:getLanguageString("L_40d0596e541cb46d"),
}

function ui_email_info_t:ctor(emailData)
	ui_email_info_t.super.ctor(self, true)

	self.emailData_ = emailData

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_email_info.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local labelTitle = ccui.Helper:seekWidgetByName(root, "Label_3")
	labelTitle:setString(self.emailData_.Title)

	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_4")
	print(self.emailData_.Content)
	labelContent:setString(self.emailData_.Content)


	local labelName = ccui.Helper:seekWidgetByName(root, "Label_5")
	labelName:setString(LocalLanguage:getLanguageString("L_ed3b240d1e0c5660"))


	local labelStatus = ccui.Helper:seekWidgetByName(root, "Label_6")
	-- labelStatus:setTextColor(cc.c4b(255, 255, 0, 255))
	labelStatus:setString(string.format(LocalLanguage:getLanguageString("L_be3989aae1bd17da"), LABLE_STATUS[self.emailData_.status]))
end

function ui_email_info_t:onPopUpComplete()
	if self.emailData_.boolRead == 0 then
	  	LoadingView.showTips()

	  	local url = string.format(mailReadUrl, self.emailData_.ID)

		MultipleDownloader:createDataDownLoad(
			{
				identifier = "EmailInformation",
				fileUrl = url,
				onDataTaskSuccess = function(dataTask, params)
					LoadingView.closeTips()

					local luaTbl = json.decode(params)
					if luaTbl.code == 100 then
						self.emailData_.boolRead = 1
					end
				end,
				onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
					LoadingView.closeTips()

					WarnTips.showTips(
						{
							text = errorMsg,
							style = WarnTips.STYLE_Y
						}
					)
				end,
			}
		)
	end
end

function ui_email_info_t:onCloseHandler()
	self:close()
end

function ui_email_info_t:initMsgHandler()

end

function ui_email_info_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("EmailInformation")
end
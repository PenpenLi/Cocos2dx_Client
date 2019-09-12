ForgotPasswordView = class("ForgotPasswordView", PopUpView)

function ForgotPasswordView:ctor()
	PopUpView.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_password_forgot.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnForgot = ccui.Helper:seekWidgetByName(root, "Button_Forgot")
	btnForgot:addTouchEventListener(makeClickHandler(self, self.onForgot))

	self.inputEmail_ = createCursorTextField(root, "TextField_Email")
end

function ForgotPasswordView:onForgot()
	local email = string.trim(self.inputEmail_:getText())
	if not isRightEmail(email) then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_feaeb597fc478f58"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	LoadingView.showTips()

	local url = string.format(passwordForgotUrl, email)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "PasswordForgot",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

			    local luaTbl = json.decode(params)
					WarnTips.showTips(
							{
								text = luaTbl.msg,
								style = WarnTips.STYLE_Y
							}
						)

			    if luaTbl.code == 200 then
			    	self:close()
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

function ForgotPasswordView:onCloseHandler()
	self:close()
end

function ForgotPasswordView:initMsgHandler()

end

function ForgotPasswordView:removeMsgHandler()
	MultipleDownloader:removeFileDownload("PasswordForgot")
end
ui_customer_service_t = class("ui_customer_service_t", PopUpView)

CUSTOMER_DATA_URL = "http://23.91.108.8:81/WS/GetConfig.ashx?action=getcontactconfig&configkey=ContactConfig"

function ui_customer_service_t:ctor()
	ui_customer_service_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_customer_service.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.labelPhone_ = ccui.Helper:seekWidgetByName(root, "Label_Phone")
	self.labelPhone_:setTextColor(cc.c4b(253, 231, 169, 255))
	self.labelPhone_:addTouchEventListener(makeClickHandler(self, self.onOpenPhoneCall))

	self.labelZalo_ = ccui.Helper:seekWidgetByName(root, "Label_Zalo")
	self.labelZalo_:setTextColor(cc.c4b(253, 231, 169, 255))
	self.labelZalo_:addTouchEventListener(makeClickHandler(self, self.onOpenZalo))

	self.labelFacebook_ = ccui.Helper:seekWidgetByName(root, "Label_Facebook")
	self.labelFacebook_:setTextColor(cc.c4b(253, 231, 169, 255))
	self.labelFacebook_:addTouchEventListener(makeClickHandler(self, self.onOpenFacebook))

	self.labelPhone_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))
	self.labelZalo_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))
	self.labelFacebook_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))

	local labelTips = ccui.Helper:seekWidgetByName(root, "Label_Tips")
	labelTips:setTextColor(cc.c4b(255, 255, 0, 255))
	labelTips:enableOutline(cc.c4b(0, 0, 0, 255), 1)
end

function ui_customer_service_t:onPopUpComplete()
	self:requestCustomerConfig()
end

function ui_customer_service_t:requestCustomerConfig()
	LoadingView.showTips()

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "CustomerData",
			fileUrl = CUSTOMER_DATA_URL,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 200 then
					self.phoneStr_ = string.split(luaTbl.data.Field1, "/")[1]
					self.labelPhone_:setString(self.phoneStr_)

					self.zaloStr_ = string.split(luaTbl.data.Field2, "/")[1]
					self.labelZalo_:setString(self.zaloStr_)

					self.facebookStr_ = string.split(luaTbl.data.Field3, "/")[1]
					self.labelFacebook_:setString(self.facebookStr_)
				end
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				LoadingView.closeTips()
				
				self.phoneStr_ = ""
				self.zaloStr_ = ""
				self.facebookStr_ = ""

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

function ui_customer_service_t:onOpenPhoneCall()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.phoneStr_})
		cc.Application:getInstance():openURL(string.format("tel:%s", self.phoneStr_))
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openPhoneCall", {content = self.phoneStr_})
	end
end

function ui_customer_service_t:onOpenZalo()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.zaloStr_})
		calljavaMethodV("openAppWithUrl", {"com.zing.zalo", "https://zalo.me/"})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openZaloApp", {content = self.zaloStr_})
	end
end

function ui_customer_service_t:onOpenFacebook()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.facebookStr_})
		calljavaMethodV("openAppWithUrl", {"com.facebook.katana", "http://m.facebook.com/"})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openFacebookApp", {content = self.facebookStr_})
	end
end

function ui_customer_service_t:onCloseHandler()
	self:close()
end

function ui_customer_service_t:initMsgHandler()

end

function ui_customer_service_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("CustomerData")
end
ShareView = class("ShareView", PopUpView)

function ShareView:ctor(dataShare)
	ShareView.super.ctor(self, true)

	self.dataShare_ = dataShare

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_share.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnZalo = ccui.Helper:seekWidgetByName(root, "Button_Zalo")
	btnZalo:setPressedActionEnabled(true)
	btnZalo:addTouchEventListener(makeClickHandler(self, self.onZalo))

	local btnFacebook = ccui.Helper:seekWidgetByName(root, "Button_Facebook")
	btnFacebook:setPressedActionEnabled(true)
	btnFacebook:addTouchEventListener(makeClickHandler(self, self.onFacebook))
end

function ShareView:onZalo()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("openZaloShare",
				{
					self.dataShare_.MESSAGE,
					self.dataShare_.LINK,
					self.dataShare_.LINK_TITLE,
					self.dataShare_.LINK_SOURCE,
					self.dataShare_.LINK_DESC,
					self.dataShare_.LINK_THUMB,
				}
			)
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openZaloShare",
				{
					message = self.dataShare_.MESSAGE,
					link = self.dataShare_.LINK,
					linkTitle = self.dataShare_.LINK_TITLE,
					linkSource = self.dataShare_.LINK_SOURCE,
					linkDesc = self.dataShare_.LINK_DESC,
					linkThumb = self.dataShare_.LINK_THUMB,
				}
			)
	end
end

function ShareView:onFacebook()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("openFacebookShare",
				{
					self.dataShare_.MESSAGE,
					self.dataShare_.LINK,
					self.dataShare_.LINK_TITLE,
					self.dataShare_.LINK_SOURCE,
					self.dataShare_.LINK_DESC,
					self.dataShare_.LINK_THUMB,
				}
			)
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openFacebookShare",
				{
					message = self.dataShare_.MESSAGE,
					link = self.dataShare_.LINK,
					linkTitle = self.dataShare_.LINK_TITLE,
					linkSource = self.dataShare_.LINK_SOURCE,
					linkDesc = self.dataShare_.LINK_DESC,
					linkThumb = self.dataShare_.LINK_THUMB,
				}
			)
	end
end

function ShareView:onCloseHandler()
	self:close()
end

function ShareView:onZaloShareSuccess()
	LoadingView.showTips()

	gatesvr.sendShareObtain(self.dataShare_.SHARE_TYPE)

	self:close()
end

function ShareView:onFacebookShareSuccess()
	LoadingView.showTips()

	gatesvr.sendShareObtain(self.dataShare_.SHARE_TYPE)

	self:close()
end

function ShareView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ZALO_SHARE_SUCCESS, self, self.onZaloShareSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_FACEBOOK_SHARE_SUCCESS, self, self.onFacebookShareSuccess)
end

function ShareView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ZALO_SHARE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_FACEBOOK_SHARE_SUCCESS, self)
end
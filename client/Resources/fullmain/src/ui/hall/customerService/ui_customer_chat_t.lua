--
-- Author: lzg
-- Date: 2018-04-12 17:43:51
-- Function: 客服UI界面

ui_customer_chat_t = class("ui_customer_chat_t", PopUpView)

MAX_UPLOAD_FILE_SIZE = 1024 * 1024 * 2
LIMIT_WIDTH = 999
LIMIT_HEIGHT = 999

SERVICE_URL = "http://23.91.108.8:81/WS/GetConfig.ashx?action=getcontactconfig&configkey=ContactConfig"

UPLOAD_EXTENSIONS = {
	jpg = true,
	png = true,
}

function ui_customer_chat_t:ctor()
	ui_customer_chat_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_customer_chat.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnSend = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnSend:setPressedActionEnabled(true)
	btnSend:addTouchEventListener(makeClickHandler(self, self.onSendHandler))

	local btnUpload = ccui.Helper:seekWidgetByName(root, "Button_Upload")
	btnUpload:setPressedActionEnabled(true)
	btnUpload:addTouchEventListener(makeClickHandler(self, self.onUploadHandler))

	self.lblSend = createCursorTextField(root, "TextField_8")
	self.lblSend:setFontColor(cc.c3b(0, 0, 0))
	
	self.listView_ = ccui.Helper:seekWidgetByName(root, "ListView_12")

	-- local tips = ccui.Helper:seekWidgetByName(root, "Label_9")
	-- tips:enableOutline(cc.c4b(0,0,0,255))

	self.items = {}

	local labelPhoneFont = ccui.Helper:seekWidgetByName(root, "Label_PhoneFont")
	local labelFacebookFont = ccui.Helper:seekWidgetByName(root, "Label_FacebookFont")
	local labelZaloFont = ccui.Helper:seekWidgetByName(root, "Label_ZaloFont")

	labelPhoneFont:setTextColor(cc.c4b( 0xfe, 0xe9, 0x94, 0xff ))
	labelFacebookFont:setTextColor(cc.c4b( 0xfe, 0xe9, 0x94, 0xff ))
	labelZaloFont:setTextColor(cc.c4b( 0xfe, 0xe9, 0x94, 0xff ))

	labelPhoneFont:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelFacebookFont:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelZaloFont:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	self.labelPhone_ = ccui.Helper:seekWidgetByName(root, "Label_Phone")
	self.labelFacebook_ = ccui.Helper:seekWidgetByName(root, "Label_Facebook")
	self.labelZalo_ = ccui.Helper:seekWidgetByName(root, "Label_Zalo")

	self.labelPhone_:setTextColor(cc.c4b( 0x72, 0xcc, 0xff, 0xff ))
	self.labelFacebook_:setTextColor(cc.c4b( 0x72, 0xcc, 0xff, 0xff ))
	self.labelZalo_:setTextColor(cc.c4b( 0x72, 0xcc, 0xff, 0xff ))

	self.labelPhone_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelFacebook_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelZalo_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	self.labelPhone_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))
	self.labelFacebook_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))
	self.labelZalo_:setString(LocalLanguage:getLanguageString("L_0def02712114ffca"))

	self.labelPhone_:addTouchEventListener(makeClickHandler(self, self.onOpenPhoneCall))
	self.labelZalo_:addTouchEventListener(makeClickHandler(self, self.onOpenZalo))
	self.labelFacebook_:addTouchEventListener(makeClickHandler(self, self.onOpenFacebook))

	self.linePhone_ = ccui.Helper:seekWidgetByName(root, "Image_PhoneLine")
	self.lineFacebook_ = ccui.Helper:seekWidgetByName(root, "Image_FacebookLine")
	self.lineZalo_ = ccui.Helper:seekWidgetByName(root, "Image_ZaloLine")

	self:refreshLine()

	-- self.listView_height = 0
	-- self:showChatListView()
end

function ui_customer_chat_t:onPopUpComplete()
	gatesvr.sendChatInfo()
	gatesvr.sendGetChatInfo()

	--保持网络链接
	local arr_action = {}
	arr_action[#arr_action +1] = cc.DelayTime:create(10)
	arr_action[#arr_action +1] = cc.CallFunc:create(function()
			gatesvr.sendChatInfo()
		end)
	self:runAction(cc.RepeatForever:create(cc.Sequence:create(arr_action)))		

	self:requestService()
end

function ui_customer_chat_t:requestService()
	LoadingView.showTips()

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "CustomerChat",
			fileUrl = SERVICE_URL,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 200 then
					self.dataPhone_ = string.split(luaTbl.data.Field1, "/")[1]
					self.labelPhone_:setString(self.dataPhone_)

					self.dataFacebook_ = string.split(luaTbl.data.Field3, "/")[1]
					self.labelFacebook_:setString(self.dataFacebook_)

					self.dataZalo_ = string.split(luaTbl.data.Field2, "/")[1]
					self.labelZalo_:setString(self.dataZalo_)

					self:refreshLine()
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

function ui_customer_chat_t:refreshLine()
	local size = self.labelPhone_:getContentSize()
	self.linePhone_:setContentSize(cc.size(size.width + 10, 9))

	size = self.labelFacebook_:getContentSize()
	self.lineFacebook_:setContentSize(cc.size(size.width + 10, 9))

	size = self.labelZalo_:getContentSize()
	self.lineZalo_:setContentSize(cc.size(size.width + 10, 9))
end

function ui_customer_chat_t:onOpenPhoneCall()
	if not self.dataPhone_ then return end

	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.dataPhone_})
		cc.Application:getInstance():openURL(string.format("tel:%s", self.dataPhone_))
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openPhoneCall", {content = self.dataPhone_})
	end
end

function ui_customer_chat_t:onOpenZalo()
	if not self.dataZalo_ then return end

	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.dataZalo_})
		calljavaMethodV("openAppWithUrl", {"com.zing.zalo", "https://zalo.me/"})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openZaloApp", {content = self.dataZalo_})
	end
end

function ui_customer_chat_t:onOpenFacebook()
	if not self.dataFacebook_ then return end

	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.dataFacebook_})
		calljavaMethodV("openAppWithUrl", {"com.facebook.katana", "http://m.facebook.com/"})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "openFacebookApp", {content = self.dataFacebook_})
	end
end

function ui_customer_chat_t:showChatListView()
	-- local chatInfo = global.g_mainPlayer:getChatInfo()
	-- print("#chatInfo =====", #chatInfo)
	-- for i = 1, #chatInfo do
	-- 	self:updateChatListView(i, chatInfo[i], i == #chatInfo)
	-- end
end

function ui_customer_chat_t:updateChatListView(refresh)
	-- if self.items[newChat.chatID] then return end
	-- local item = ui_customer_item_t.new(newChat)
	-- self.items[newChat.chatID] = 1
	-- self.listView_:pushBackCustomItem(item.node_)
	-- if refresh then
	-- 	local arr_action = {}
	-- 	arr_action[#arr_action +1] = cc.DelayTime:create(0.2)
	--    	arr_action[#arr_action +1] = cc.CallFunc:create(function()
	-- 		self.listView_:jumpToPercentVertical(100)
	--    	end)
	-- 	self.listView_:runAction(cc.Sequence:create(arr_action))
	-- end
	----------------------------
	local chatInfo = global.g_mainPlayer:getChatInfo()
	for i=1,#chatInfo do
		if self.items[chatInfo[i].chatID]~=1 then
			self.items[chatInfo[i].chatID] = 1
			local item = ui_customer_item_t.new(chatInfo[i])
			self.listView_:pushBackCustomItem(item.node_)
		end
	end
	if refresh then
		local arr_action = {}
		arr_action[#arr_action +1] = cc.DelayTime:create(0.2)
	   	arr_action[#arr_action +1] = cc.CallFunc:create(function()
			self.listView_:jumpToPercentVertical(100)
	   	end)
		self.listView_:runAction(cc.Sequence:create(arr_action))
		global.g_mainPlayer:setMaxChatID()
	end
	----------------------------
end

function ui_customer_chat_t:onSendHandler()
	local strSend = string.trim(self.lblSend:getText())
	if string.len(strSend) <= 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_7ffeaa6b67640071"),
					style = WarnTips.STYLE_Y
				}
			)
		return 
	end

	if not global.g_mainPlayer:isAllowChat() then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_d5ec57d2701823ec"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	gatesvr.sendChatSend(strSend)
	global.g_mainPlayer:markLastChatTime()
	self.lblSend:setText("")
end

function ui_customer_chat_t:onUploadHandler()
    if cc.PLATFORM_OS_ANDROID == PLATFROM then
    	LoadingView.showTips()
    	calljavaMethodV("openImageUpload", {uploadUrl, MAX_UPLOAD_FILE_SIZE, LIMIT_WIDTH, LIMIT_HEIGHT})
    elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
    	LoadingView.showTips()
    	luaoc.callStaticMethod("AppController", "openImageUpload", {uploadUrl = uploadUrl, limitSize = MAX_UPLOAD_FILE_SIZE, limitWidth = LIMIT_WIDTH, limitHeight = LIMIT_HEIGHT})
    elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_26b697b196b11282"),
					style = WarnTips.STYLE_Y
				}
			)
    end
end

function ui_customer_chat_t:onCloseHandler()
	self:close()
end

function ui_customer_chat_t:onUploadImageSuccess(param)
	LoadingView.closeTips()
	
	local luaTbl = json.decode(param)
	if luaTbl.code == 200 then
		local content = string.format("%s,%s,%s", luaTbl.data, luaTbl.width, luaTbl.height)
		gatesvr.sendChatSend(content)
		global.g_mainPlayer:markLastChatTime()
	else
		WarnTips.showTips(
				{
					text = luaTbl.msg,
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function ui_customer_chat_t:onUploadImageFailed()
	LoadingView.closeTips()

	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_48302bf3e52961ab"),
				style = WarnTips.STYLE_Y
			}
		)
end

function ui_customer_chat_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_UPDATE_CHAT, self, self.updateChatListView)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_UPLOAD_IMAGE_SUCCESS, self, self.onUploadImageSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_UPLOAD_IMAGE_FAILED, self, self.onUploadImageFailed)
end

function ui_customer_chat_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("CustomerChat")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_UPDATE_CHAT, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_UPLOAD_IMAGE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_UPLOAD_IMAGE_FAILED, self)
end

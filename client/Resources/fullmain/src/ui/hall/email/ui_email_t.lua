ui_email_t = class("ui_email_t", PopUpView)

local MAX_PAGE_SIZE = 10

function ui_email_t:ctor()
	ui_email_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_email.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.listView_ = ccui.Helper:seekWidgetByName(root, "ListView_3")
	self.listView_:addScrollViewEventListener(handler(self, self.onListViewHandler))

	self.emptyImage_ = ccui.Helper:seekWidgetByName(root, "Image_5")
	self.emptyImage_:setVisible(false)

	self.pageIndex_ = 1
	self.empty_ = false
end

function ui_email_t:onPopUpComplete()
	self:requirePageEmail(self.pageIndex_, MAX_PAGE_SIZE)
end

function ui_email_t:onPopBackComplete()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_EMAIL_UNREAD_UPDATE)
end

function ui_email_t:onListViewHandler(sender, eventType)
	if eventType == 6 then
		self:nextPage()
	end
end

function ui_email_t:requirePageEmail(pageIndex, pageSize)
	LoadingView.showTips()

	local time = os.time()
	local playerId = global.g_mainPlayer:getPlayerId()
	local str = string.format("keyD60807C36977BD71D4B9375D3DD73815userId%dtimestamp%d", playerId, time)
	local sign = string.upper(cc.utils:getDataMD5Hash(str))
	local url = string.format(mailUrl, playerId, time, self.pageIndex_, MAX_PAGE_SIZE, 2, sign)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "PageEmail",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local mails = json.decode(params)
				self:appendEmail(mails)

				if self.pageIndex_ == 1 then
					handlerDelayed(function() self.listView_:jumpToTop() end, 0)
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

function ui_email_t:appendEmail(mails)
	if mails.data.data and #mails.data.data > 0 then
		self.empty_ = mails.data.pageCount <= self.pageIndex_

		for i = 1, #mails.data.data do
			local mailData = mails.data.data[i]
			local item = ui_email_item_t.new(mailData)
			self.listView_:pushBackCustomItem(item.node_)
		end
	else
		self.emptyImage_:setVisible(true)
	end
end

function ui_email_t:nextPage()
	if self.empty_ then return end

	self.pageIndex_ = self.pageIndex_ + 1
	self:requirePageEmail(self.pageIndex_, MAX_PAGE_SIZE)
end

function ui_email_t:onCloseHandler()
	self:close()
end

function ui_email_t:initMsgHandler()

end

function ui_email_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("PageEmail")
end
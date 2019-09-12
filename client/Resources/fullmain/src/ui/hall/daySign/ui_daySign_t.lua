ui_daySign_t = class("ui_daySign_t", PopUpView)

local CONSUME_REBATE_URL = "http://23.91.108.8:81/WS/NativeWeb.ashx?action=drawconsume&userId=%d"

function ui_daySign_t:ctor()
	ui_daySign_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_daySign.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.cbShare_ = ccui.Helper:seekWidgetByName(root, "CheckBox_Share")
	self.cbShare_:addEventListener(handler(self, self.onSelectedChange))

	self.cbDaySign_ = ccui.Helper:seekWidgetByName(root, "CheckBox_DaySign")
	self.cbDaySign_:addEventListener(handler(self, self.onSelectedChange))

	self.cbRebate_ = ccui.Helper:seekWidgetByName(root, "CheckBox_Rebate")
	self.cbRebate_:addEventListener(handler(self, self.onSelectedChange))

	self.panelShare_ = ccui.Helper:seekWidgetByName(root, "Panel_Share")
	self.panelDaySign_ = ccui.Helper:seekWidgetByName(root, "Panel_DaySign")
	self.panelRebate_ = ccui.Helper:seekWidgetByName(root, "Panel_Rebate")

	local panelQR = ccui.Helper:seekWidgetByName(root, "Panel_QRShare") 
	local qr = util:createQRSprite(share_content, 194, 10)
	qr:setPosition(-105, -109)
	panelQR:addChild(qr)

	local btnShare = ccui.Helper:seekWidgetByName(root, "Button_Share")
	btnShare:setPressedActionEnabled(true)
	btnShare:addTouchEventListener(makeClickHandler(self, self.onShare))

	self.btnSign_ = ccui.Helper:seekWidgetByName(root, "Button_8")
	self.btnSign_:setPressedActionEnabled(true)
	self.btnSign_:addTouchEventListener(makeClickHandler(self, self.onSignHandler))

	self.labelContinue_ = ccui.Helper:seekWidgetByName(root, "Label_18")

	self.daySigns_ = {}
	for i = 1, 7 do
		local item = ccui.Helper:seekWidgetByName(root, "DaySign_" .. i)
		item:setCascadeColorEnabled(true)

		item.labelReward = ccui.Helper:seekWidgetByName(item, "Label_1")

		item.iconGou = ccui.Helper:seekWidgetByName(item, "Image_Sign")

		self.daySigns_[i] = item
	end

	local btnRebate = ccui.Helper:seekWidgetByName(root, "Button_38")
	btnRebate:setPressedActionEnabled(true)
	btnRebate:addTouchEventListener(makeClickHandler(self, self.onRebate))

	self.fanli = global.g_mainPlayer:getFanLiInfo()
	local labelCondition = ccui.Helper:seekWidgetByName(root, "Label_38")
	labelCondition:setString(string.format(LocalLanguage:getLanguageString("L_9ee02c712dc843cd"), self.fanli[5]))

	local labelTake = ccui.Helper:seekWidgetByName(root, "Label_37")
	labelTake:setString(string.format(LocalLanguage:getLanguageString("L_38f328bb2b968c22"), self.fanli[5], self.fanli[2], self.fanli[6], self.fanli[3], self.fanli[7], self.fanli[4]))

	self:defaultView()
end

function ui_daySign_t:defaultView()
	if cc.PLATFORM_OS_WINDOWS == PLATFROM then
		self.cbDaySign_:setEnabled(false)
		self.cbDaySign_:setBright(false)
	end

	local rebateToday = global.g_mainPlayer:getRebateToday()
	if rebateToday > 0 then
		self.selectedBox_ = self.cbRebate_
		self.selectedBox_:setSelected(true)

		self.panelShare_:setVisible(false)
		self.panelDaySign_:setVisible(false)
		self.panelRebate_:setVisible(true)
	else
		self.selectedBox_ = self.cbShare_
		self.selectedBox_:setSelected(true)

		self.panelShare_:setVisible(true)
		self.panelDaySign_:setVisible(false)
		self.panelRebate_:setVisible(false)
	end
end

function ui_daySign_t:onPopUpComplete()
	LoadingView.showTips()

	gatesvr.sendCheckInQuery()
end

function ui_daySign_t:onShare()
	PopUpView.showPopUpView(ShareView, SHARE_CONST)
end

function ui_daySign_t:refreshData(series, todaySign, rewards)
	self.series_ = series
	self.todaySign_ = todaySign

	self.labelContinue_:setString(string.format(LocalLanguage:getLanguageString("L_88f637a892653ac5"), self.series_))

	for i = 1, 7 do
		local item = self.daySigns_[i]
		item.labelReward:setString("X"..rewards[i])

		if i > series then
			item:setColor(COLOR_DIM)
			item.iconGou:setVisible(false)
		else
			item:setColor(COLOR_WHITE)
			item.iconGou:setVisible(true)
		end
	end

	if self.todaySign_ == 0 then
		local item = self.daySigns_[series+1]
		item:setColor(COLOR_WHITE)
		item:setLocalZOrder(10)
		item.iconGou:setVisible(false)

		local action = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5, 1.2),cc.ScaleTo:create(0.5, 1)))
		item:runAction(action)

		self.btnSign_:setEnabled(true)
	else
		self.btnSign_:setEnabled(false)
	end
end

function ui_daySign_t:onCloseHandler()
	self:close()
end

function ui_daySign_t:onSignHandler()
	gatesvr.sendCheckInDone()
end

function ui_daySign_t:onRebate()
	if self.fanli[1] == 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_5fb91406433364bf"),
					style = WarnTips.STYLE_Y
				}
			)
	else
		LoadingView.showTips()

		local url = string.format(CONSUME_REBATE_URL, global.g_mainPlayer:getPlayerId())

		MultipleDownloader:createDataDownLoad(
			{
				identifier = "ConsumeRebate",
				fileUrl = url,
				onDataTaskSuccess = function(dataTask, params)
					LoadingView.closeTips()

					local luaTbl = json.decode(params)
					if luaTbl.code == "200" then
						global.g_gameDispatcher:sendMessage(GAME_MESSAGE_CHECK_REBATE)
					end

					WarnTips.showTips(
							{
								text = luaTbl.msg,
								style = WarnTips.STYLE_Y
							}
						)
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

function ui_daySign_t:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedBox_ ~= sender then
			self.selectedBox_:setSelected(false)
			self.selectedBox_ = sender

			if self.selectedBox_ == self.cbShare_ then
				self.panelShare_:setVisible(true)
				self.panelDaySign_:setVisible(false)
				self.panelRebate_:setVisible(false)
			elseif self.selectedBox_ == self.cbDaySign_ then
				self.panelShare_:setVisible(false)
				self.panelDaySign_:setVisible(true)
				self.panelRebate_:setVisible(false)
			elseif self.selectedBox_ == self.cbRebate_ then
				self.panelShare_:setVisible(false)
				self.panelDaySign_:setVisible(false)
				self.panelRebate_:setVisible(true)
			end
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function ui_daySign_t:onDaySignSuccess()
	self.todaySign_ = 1
	local item = self.daySigns[self.series_+1]
	item:stopAllActions()
	item:setColor(COLOR_WHITE)
	local iconGou = ccui.Helper:seekWidgetByName(item, "Image_Sign")
	iconGou:setVisible(true)
	local action = cc.ScaleTo:create(0.5, 1)
	item:runAction(action)
	self.btnSign_:setEnabled(false)

	self.series_ = self.series_ + 1
	self.labelContinue_:setString(string.format(LocalLanguage:getLanguageString("L_1edabfedd4cd883b"), self.series_))
end

function ui_daySign_t:onCheckInfoSuccess(series, todaySign, rewards)
	self:refreshData(series, todaySign, rewards)
end

function ui_daySign_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_CHECK_INFO, self, self.onCheckInfoSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DAYSIGN_SUCCESS, self, self.onDaySignSuccess)
end

function ui_daySign_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("ConsumeRebate")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_CHECK_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DAYSIGN_SUCCESS, self)
end
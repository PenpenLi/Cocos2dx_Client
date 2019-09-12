ui_recharge_momo_t = class("ui_recharge_momo_t", PopUpView)

local SCROLL_DIRECTION = {
	UP = 1, --向上滚动
	DOWN = 2, --向下滚动
}

local SCROLL_SPEED = { --pixel/sec
	[SCROLL_DIRECTION.UP] = -50,
	[SCROLL_DIRECTION.DOWN] = 50,
}

local check_momo_url = "http://23.91.108.8:81/HttpHander/MoMoPay/GetOrderResult.ashx?orderid=%s"

function ui_recharge_momo_t:ctor(momopay, amount, orderid)
	PopUpView.ctor(self, true)

	self.momopay_ = momopay
	self.amount_ = amount
	self.orderid_ = orderid

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_recharge_momo.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_Confirm")
	btnConfirm:setPressedActionEnabled(true)
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	self.scrollGuide_ = ccui.Helper:seekWidgetByName(root, "ScrollView_Guide")
	self.scrollGuide_:addEventListener(handler(self, self.onScrollGuideHandler))

	self.lastOperateTime_ = 0
	self.guideContainer_ = self.scrollGuide_:getInnerContainer()

	local labelAccountFont = ccui.Helper:seekWidgetByName(root, "Label_AccountFont")
	labelAccountFont:disableEffect()
	labelAccountFont:setTextColor(cc.c4b(71, 51, 122, 255))

	local labelAccount = ccui.Helper:seekWidgetByName(root, "Label_Account")
	labelAccount:disableEffect()
	labelAccount:setTextColor(cc.c4b(71, 51, 122, 255))
	labelAccount:setString(self.momopay_)

	local labelCostFont = ccui.Helper:seekWidgetByName(root, "Label_CostFont")
	labelCostFont:disableEffect()
	labelCostFont:setTextColor(cc.c4b(71, 51, 122, 255))

	local labelCost = ccui.Helper:seekWidgetByName(root, "Label_Cost")
	labelCost:disableEffect()
	labelCost:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelCost:setTextColor(cc.c4b(255, 255, 0, 255))
	labelCost:setString(string.format(LocalLanguage:getLanguageString("L_4188540d11955987"), number_format(self.amount_ * ZALOPAY_RATE)))

	local btnCopy = ccui.Helper:seekWidgetByName(root, "Button_Copy")
	btnCopy:setPressedActionEnabled(true)
	btnCopy:addTouchEventListener(makeClickHandler(self, self.onCopy))

	local labelTips = ccui.Helper:seekWidgetByName(root, "Label_Tips")
	labelTips:disableEffect()
	labelTips:setTextColor(cc.c4b(71, 51, 122, 255))
	labelTips:setString(LocalLanguage:getLanguageString("L_8542fb117e1670b1"))

	self.labelDelayTime_ = ccui.Helper:seekWidgetByName(root, "Label_DelayTime")
	self.labelDelayTime_:disableEffect()
	self.labelDelayTime_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
end

function ui_recharge_momo_t:onConfirm()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.momopay_})
		calljavaMethodV("openAppWithUrl", {"com.mservice.momotransfer", "https://momo.vn/"})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "copy2Clipboard", {content = self.momopay_})
		cc.Application:getInstance():openURL("momo://")
	end

	self.labelDelayTime_:setString("")
	self:stopAutoStep()
end

function ui_recharge_momo_t:onCloseHandler()
	self:close()
end

function ui_recharge_momo_t:onCopy()
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		calljavaMethodV("copy2Clipboard", {self.momopay_})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		luaoc.callStaticMethod("AppController", "copy2Clipboard", {content = self.momopay_})
	end
end

function ui_recharge_momo_t:checkMoMoOrder(depth)
	LoadingView.showTips()

	self.checking_ = true

	local url = string.format(check_momo_url, self.orderid_)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "checkMoMoOrder",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 100 then
					if luaTbl.OrderState == 0 then
						if depth > 0 then
							LoadingView.showTips()

							handlerDelayed(function()
								self:checkMoMoOrder(depth - 1)
							end, 5)
						else
							WarnTips.showTips(
									{
										text = luaTbl.msg,
										style = WarnTips.STYLE_Y,
										confirm = function() self.checking_ = nil end,
										cancel = function() self.checking_ = nil end,
									}
								)
						end
					elseif luaTbl.OrderState == 2 then
						self.checking_ = nil

						WarnTips.showTips(
								{
									text = luaTbl.msg,
									style = WarnTips.STYLE_Y
								}
							)
						gatesvr.sendInsureInfoQuery(true)

						self:close()
					end
				else
					WarnTips.showTips(
							{
								text = luaTbl.msg,
								style = WarnTips.STYLE_Y,
								confirm = function() self.checking_ = nil end,
								cancel = function() self.checking_ = nil end,
							}
						)
				end
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				LoadingView.closeTips()

				WarnTips.showTips(
					{
						text = errorMsg,
						style = WarnTips.STYLE_Y,
						confirm = function() self.checking_ = nil end,
						cancel = function() self.checking_ = nil end,
					}
				)
			end,
		}
	)
end

function ui_recharge_momo_t:onPopUpComplete()
	self.scrollDirection_ = SCROLL_DIRECTION.DOWN
	self.lastOperateTime_ = 0
	self:startAutoScrollGuide()

	self:startAutoStep()
end

function ui_recharge_momo_t:stopAutoStep()
	if self.tickStep_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickStep_)
		self.tickStep_ = nil
	end
end

function ui_recharge_momo_t:startAutoStep()
	self:stopAutoStep()

	self.remainStep_ = 60
	self.labelDelayTime_:setString(string.format("(%ds)", self.remainStep_))
	self.tickStep_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onAutoStep), 1, false)
end

function ui_recharge_momo_t:onAutoStep()
	self.remainStep_ = self.remainStep_ - 1
	self.labelDelayTime_:setString(string.format("(%ds)", self.remainStep_))

	if self.remainStep_ < 1 then
		self.labelDelayTime_:setString("")
		self:stopAutoStep()
		self:onConfirm()
	end
end

function ui_recharge_momo_t:startAutoScrollGuide()
	self:stopAutoScrollGuide()

	self.tickScrollGuide_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.onAutoScrollGuide), 0, false)
end

function ui_recharge_momo_t:onAutoScrollGuide(dt)
	local nowTime = os.time()
	local deltaTime = nowTime - self.lastOperateTime_
	if deltaTime < 3 then return end

	local speed = SCROLL_SPEED[self.scrollDirection_]
	local px, py = self.guideContainer_:getPosition()
	local ny = py + speed * dt

	if self.scrollDirection_ == SCROLL_DIRECTION.DOWN then
		ny = math.min(ny, 0)

		if ny == 0 then
			self.scrollDirection_ = SCROLL_DIRECTION.UP
		end
		self.guideContainer_:setPosition(cc.p(px, ny))
	elseif self.scrollDirection_ == SCROLL_DIRECTION.UP then
		self.scrollGuide_:jumpToTop()
		self.scrollDirection_ = SCROLL_DIRECTION.DOWN
	end
end

function ui_recharge_momo_t:stopAutoScrollGuide()
	if self.tickScrollGuide_ then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickScrollGuide_)
		self.tickScrollGuide_ = nil
	end
end

function ui_recharge_momo_t:onScrollGuideHandler(sender, eventType)
	self.lastOperateTime_ = os.time()
end

function ui_recharge_momo_t:onEnterforeground()
	if self.checking_ then return end

	self:checkMoMoOrder(1)
end

function ui_recharge_momo_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self, self.onEnterforeground)
end

function ui_recharge_momo_t:removeMsgHandler()
	MultipleDownloader:removeFileDownload("checkMoMoOrder")
	self:stopAutoScrollGuide()
	self:stopAutoStep()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self)
end
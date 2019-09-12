RechargeScene = class("RechargeScene", LayerBase)

local create_zalopay_url = "http://23.91.108.8:81/HttpHander/ZaloPay/AddOrderHandler.ashx?userID=%d&orderAmount=%d"
local create_momo_url = "http://23.91.108.8:81/HttpHander/MoMoPay/RequestOrder.ashx?userID=%d&orderScore=%d"

local MOMO_PAY_DEFAULT = {
	GIFT = 0,
	GIFT_LEVEL = {
		500,
		1000,
		5000,
		10000,
	},
	MIN = 100,
	MAX = 200000,
}

local ZALO_PAY_DEFAULT = {
	GIFT = 0,
	GIFT_LEVEL = {
		500,
		1000,
		5000,
		10000,
	},
	MIN = 100,
	MAX = 2000000,
}

function RechargeScene:ctor()
	RechargeScene.super.ctor(self)
	
	local pathJson = getLayoutJson("main/res/json/ui_main_recharge.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_11")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "Label_4")
	self.labelScore_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelScore_:setString(number_format(score))

	self.cbShop_ = ccui.Helper:seekWidgetByName(root, "CheckBox_8")
	self.cbShop_:addEventListener(handler(self, self.onSelectedChange))

	self.cbMoMo_ = ccui.Helper:seekWidgetByName(root, "CheckBox_MoMo")
	self.cbMoMo_:addEventListener(handler(self, self.onSelectedChange))
	self.cbMoMo_:setVisible(global.g_mainPlayer:isLoginEnough())

	self.cbZalopay_ = ccui.Helper:seekWidgetByName(root, "CheckBox_Zalo")
	self.cbZalopay_:addEventListener(handler(self, self.onSelectedChange))
	self.cbZalopay_:setVisible(global.g_mainPlayer:isLoginEnough())

	self.scrollShop_ = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	self.panelShop_ = ccui.Helper:seekWidgetByName(root, "Panel_Shop")
	self.panelMoMo_ = ccui.Helper:seekWidgetByName(root, "Panel_MoMo")
	self.panelZalopay_ = ccui.Helper:seekWidgetByName(root, "Panel_Zalopay")

	---momo充值
	local panelMoMoSong = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Panel_MoMoSong")
	panelMoMoSong:setVisible(MOMO_PAY_DEFAULT.GIFT > 0)

	local labelMoMoRate = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Label_MoMoRate")
	labelMoMoRate:disableEffect()
	labelMoMoRate:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelMoMoRate:setString(string.format(LocalLanguage:getLanguageString("L_e8b6fc79797d8efe"), ZALOPAY_RATE))

	self.labelMoMoBuy_ = ccui.Helper:seekWidgetByName(self.panelMoMo_, "AtlasLabel_MoMoBuy")
	self.labelMoMoSong_ = ccui.Helper:seekWidgetByName(self.panelMoMo_, "AtlasLabel_MoMoSong")
	self.iconMoMoGold_ = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Image_MoMoGold")

	local labelMoMoPriceFont = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Label_MoMoPriceFont")
	labelMoMoPriceFont:disableEffect()
	labelMoMoPriceFont:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local labelMoMoRange = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Label_MoMoRange")
	labelMoMoRange:disableEffect()
	labelMoMoRange:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelMoMoRange:setTextColor(cc.c4b(255, 255, 0, 255))
	labelMoMoRange:setString(string.format(LocalLanguage:getLanguageString("L_7d491a1fbe115c39"), MOMO_PAY_DEFAULT.MIN, MOMO_PAY_DEFAULT.MAX))

	self.labelMoMoPrice_ = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Label_MoMoPrice")
	self.labelMoMoPrice_:disableEffect()
	self.labelMoMoPrice_:setTextColor(cc.c4b(255, 255, 0, 255))
	self.labelMoMoPrice_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	for i = 0, 9 do
		local btnKey = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Button_MoMoKey" .. i)
		btnKey:setPressedActionEnabled(true)
		btnKey:setTag(i)
		btnKey:addTouchEventListener(makeClickHandler(self, self.onMoMoKeyHandler))
	end

	local btnMoMoCancel = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Button_MoMoCancel")
	btnMoMoCancel:setPressedActionEnabled(true)
	btnMoMoCancel:addTouchEventListener(makeClickHandler(self, self.onMoMoCancelHandler))

	local btnMoMoConfirm = ccui.Helper:seekWidgetByName(self.panelMoMo_, "Button_MoMoConfirm")
	btnMoMoConfirm:setPressedActionEnabled(true)
	btnMoMoConfirm:addTouchEventListener(makeClickHandler(self, self.onMoMoConfirmHandler))

	--zalopay充值
	local logoZaloSong = ccui.Helper:seekWidgetByName(root, "Image_ZaloSong")
	logoZaloSong:setVisible(false)
	
	local panelZaloSong = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Panel_ZaloSong")
	panelZaloSong:setVisible(ZALO_PAY_DEFAULT.GIFT > 0)

	local labelZaloRate = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Label_ZaloRate")
	labelZaloRate:disableEffect()
	labelZaloRate:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelZaloRate:setString(string.format(LocalLanguage:getLanguageString("L_e8b6fc79797d8efe"), ZALOPAY_RATE))

	self.iconZaloGold_ = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Image_ZaloGold")
	self.labelZaloSong_ = ccui.Helper:seekWidgetByName(self.panelZalopay_, "AtlasLabel_ZaloSong")
	self.labelZaloBuy_ = ccui.Helper:seekWidgetByName(self.panelZalopay_, "AtlasLabel_ZaloBuy")

	local labelZaloPriceFont = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Label_ZaloPriceFont")
	labelZaloPriceFont:disableEffect()
	labelZaloPriceFont:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local labelZaloRange = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Label_ZaloRange")
	labelZaloRange:disableEffect()
	labelZaloRange:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelZaloRange:setTextColor(cc.c4b(255, 255, 0, 255))
	labelZaloRange:setString(string.format(LocalLanguage:getLanguageString("L_7d491a1fbe115c39"), ZALO_PAY_DEFAULT.MIN, ZALO_PAY_DEFAULT.MAX))

	self.labelZaloPrice_ = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Label_ZaloPrice")
	self.labelZaloPrice_:disableEffect()
	self.labelZaloPrice_:setTextColor(cc.c4b(255, 255, 0, 255))
	self.labelZaloPrice_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	for i = 0, 9 do
		local btnKey = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Button_ZaloKey" .. i)
		btnKey:setPressedActionEnabled(true)
		btnKey:setTag(i)
		btnKey:addTouchEventListener(makeClickHandler(self, self.onZaloKeyHandler))
	end

	local btnZaloCancel = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Button_ZaloCancel")
	btnZaloCancel:setPressedActionEnabled(true)
	btnZaloCancel:addTouchEventListener(makeClickHandler(self, self.onZaloCancelHandler))

	local btnZaloConfirm = ccui.Helper:seekWidgetByName(self.panelZalopay_, "Button_ZaloConfirm")
	btnZaloConfirm:setPressedActionEnabled(true)
	btnZaloConfirm:addTouchEventListener(makeClickHandler(self, self.onZaloConfirmHandler))

	self:defaultView()
end

function RechargeScene:defaultView()
	if global.g_mainPlayer:isLoginEnough() then
		self.cbMoMo_:setSelected(true)
		self.selectedBox_ = self.cbMoMo_

		self.panelShop_:setVisible(false)
		self.panelMoMo_:setVisible(true)
		self.panelZalopay_:setVisible(false)
	else
		self.cbShop_:setSelected(true)
		self.selectedBox_ = self.cbShop_

		self.panelShop_:setVisible(true)
		self.panelMoMo_:setVisible(false)
		self.panelZalopay_:setVisible(false)
	end
end

function RechargeScene:checkLostOrder()
	local isEmpty = global.g_mainPlayer:isTransactionsEmpty()
	if not isEmpty then
		PopUpView.showPopUpView(TransactionVerifyView)
	end
end

function RechargeScene:requireStoreItems()
	local jsonStr = json.encode(STORE_ITEMS_PRODUCTID)
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		LoadingView.showTips()
		
		calljavaMethodV("getStoreItems", {jsonStr})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		LoadingView.showTips()

		luaoc.callStaticMethod("AppController", "getStoreItems", {content = jsonStr})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_3c837dcd06193a7d"),
					style = WarnTips.STYLE_Y,
					confirm = function()
							self:checkLostOrder()
						end
				}
			)
	end
end

function RechargeScene:onMoMoKeyHandler(sender)
	AudioEngine.playEffect("main/res/sounds/click.mp3")

	local key = sender:getTag()
	local countStr = tostring(self.momocount_) .. key
	self.momocount_ = tonumber(countStr) or MOMO_PAY_DEFAULT.MIN
	self.momocount_ = math.min(self.momocount_, MOMO_PAY_DEFAULT.MAX)
	self:refreshMoMoPay()
end

function RechargeScene:onMoMoCancelHandler()
	AudioEngine.playEffect("main/res/sounds/click.mp3")

	self.momocount_ = 0
	self:refreshMoMoPay()
end

function RechargeScene:onMoMoConfirmHandler()
	AudioEngine.playEffect("main/res/sounds/click.mp3")
	
	if self.momocount_ <= 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8bd1c1f89e6f861e"),
					style = WarnTips.STYLE_Y
				}
			)
	elseif self.momocount_ < MOMO_PAY_DEFAULT.MIN then
		WarnTips.showTips(
				{
					text = string.format(LocalLanguage:getLanguageString("L_7ad3b1d8deff75cd"), MOMO_PAY_DEFAULT.MIN),
					style = WarnTips.STYLE_Y
				}
			)

		self.momocount_ = MOMO_PAY_DEFAULT.MIN
		self:refreshMoMoPay()
	else
		self:requestMoMoOrderId(self.momocount_)
	end
end

function RechargeScene:initMoMoPay()
	self.momocount_ = 0
	self:refreshMoMoPay()
end

function RechargeScene:getMoMoGiftLevel(count)
	for i = 1, #MOMO_PAY_DEFAULT.GIFT_LEVEL do
		local v = MOMO_PAY_DEFAULT.GIFT_LEVEL[i]
		if count < v then
			return i
		end
	end

	return #MOMO_PAY_DEFAULT.GIFT_LEVEL + 1
end

function RechargeScene:refreshMoMoPay()
	self.labelMoMoBuy_:setString(number_format(self.momocount_, ":"))
	self.labelMoMoPrice_:setString(string.format(LocalLanguage:getLanguageString("L_4188540d11955987"), number_format(self.momocount_ * ZALOPAY_RATE)))

	local level = self:getMoMoGiftLevel(self.momocount_)
	self.iconMoMoGold_:loadTexture(string.format("main/res/recharge/common/img_jb_%02d.png", level))
end

function RechargeScene:onZaloKeyHandler(sender)
	AudioEngine.playEffect("main/res/sounds/click.mp3")

	local key = sender:getTag()
	local countStr = tostring(self.zalocount_) .. key
	self.zalocount_ = tonumber(countStr) or ZALO_PAY_DEFAULT.MIN
	self.zalocount_ = math.min(self.zalocount_, ZALO_PAY_DEFAULT.MAX)
	self:refreshZaloPay()
end

function RechargeScene:onZaloCancelHandler()
	AudioEngine.playEffect("main/res/sounds/click.mp3")

	self.zalocount_ = 0
	self:refreshZaloPay()
end

function RechargeScene:onZaloConfirmHandler()
	AudioEngine.playEffect("main/res/sounds/click.mp3")

	if self.zalocount_ <= 0 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8bd1c1f89e6f861e"),
					style = WarnTips.STYLE_Y
				}
			)
	elseif self.zalocount_ < ZALO_PAY_DEFAULT.MIN then
		WarnTips.showTips(
				{
					text = string.format(LocalLanguage:getLanguageString("L_7ad3b1d8deff75cd"), ZALO_PAY_DEFAULT.MIN),
					style = WarnTips.STYLE_Y
				}
			)

		self.zalocount_ = ZALO_PAY_DEFAULT.MIN
		self:refreshZaloPay()
	else
		self:requestZalopayOrderId(self.zalocount_)
	end
end

function RechargeScene:initZaloPay()
	self.zalocount_ = 0
	self:refreshZaloPay()
end

function RechargeScene:getZaloGiftLevel(count)
	for i = 1, #ZALO_PAY_DEFAULT.GIFT_LEVEL do
		local v = ZALO_PAY_DEFAULT.GIFT_LEVEL[i]
		if count < v then
			return i
		end
	end

	return #ZALO_PAY_DEFAULT.GIFT_LEVEL + 1
end

function RechargeScene:refreshZaloPay()
	self.labelZaloBuy_:setString(number_format(self.zalocount_, ":"))
	self.labelZaloPrice_:setString(string.format(LocalLanguage:getLanguageString("L_4188540d11955987"), number_format(self.zalocount_ * ZALOPAY_RATE)))

	local zaloSong = math.floor(self.zalocount_ * ZALO_PAY_DEFAULT.GIFT)
	self.labelZaloSong_:setString(string.format(";%s", number_format(zaloSong, ":")))

	local level = self:getZaloGiftLevel(self.zalocount_)
	self.iconZaloGold_:loadTexture(string.format("main/res/recharge/common/img_jb_%02d.png", level))
end

function RechargeScene:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedBox_ ~= sender then
			self.selectedBox_:setSelected(false)
			self.selectedBox_ = sender

			if self.selectedBox_ == self.cbShop_ then
				self.panelShop_:setVisible(true)
				self.panelMoMo_:setVisible(false)
				self.panelZalopay_:setVisible(false)
			elseif self.selectedBox_ == self.cbMoMo_ then
				self.panelShop_:setVisible(false)
				self.panelMoMo_:setVisible(true)
				self.panelZalopay_:setVisible(false)
			elseif self.selectedBox_ == self.cbZalopay_ then
				self.panelShop_:setVisible(false)
				self.panelMoMo_:setVisible(false)
				self.panelZalopay_:setVisible(true)
			end
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function RechargeScene:requestMoMoOrderId(orderAmount)
	LoadingView.showTips()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(create_momo_url, playerId, orderAmount)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "RequestMoMoOrderId",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.state then
					PopUpView.showPopUpView(ui_recharge_momo_t, luaTbl.MomoPay, orderAmount, luaTbl.orderid)
				else
					WarnTips.showTips(
							{
								text = luaTbl.info,
								style = WarnTips.STYLE_Y
							}
						)
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

function RechargeScene:requestZalopayOrderId(orderAmount)
	LoadingView.showTips()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(create_zalopay_url, playerId, orderAmount)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "RequestZalopayOrderId",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.state then
					PopUpView.showPopUpView(ui_recharge_zalopay_t, luaTbl.zaloPayer, orderAmount, luaTbl.orderid)
				else
					WarnTips.showTips(
							{
								text = luaTbl.info,
								style = WarnTips.STYLE_Y
							}
						)
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

function RechargeScene:onCloseHandler()
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function RechargeScene:onStoreItemsSuccess(param)
	LoadingView.closeTips()

	table.sort(param, function(a, b)
			local sa = string.split(a.name, " ")[1]
			local sb = string.split(b.name, " ")[1]
			local na = tonumber(sa)
			local nb = tonumber(sb)
			if na < nb then
				return true
			else
				return false
			end
		end)

	local GAP = 36
	local maxRow = math.ceil(#param / 2)
	local maxHeight = maxRow * (232 + GAP) - GAP

	for i = 1, #param do
		local data = param[i]
		local item = ui_store_item_t.new(data)

		local row = math.floor((i-1)/2)
		local col = (i-1)%2
		item.node_:setPosition(cc.p(col*(400+GAP), (maxRow-row-1)*(232+GAP)))

		self.scrollShop_:addChild(item.node_)
	end
	self.scrollShop_:setInnerContainerSize(cc.size(845, maxHeight))

	self:checkLostOrder()
end

function RechargeScene:onStoreItemsFailed()
	LoadingView.closeTips()

	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_082a21a4fccfc584"),
				style = WarnTips.STYLE_Y
			}
		)
end

function RechargeScene:onStoreBuySuccess()
	LoadingView.closeTips()
	
	local isEmpty = global.g_mainPlayer:isTransactionsEmpty()
	if not isEmpty then
		PopUpView.showPopUpView(TransactionVerifyView)
	end
end

function RechargeScene:onStoreBuyFailed()
	LoadingView.closeTips()

	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_ac0dfaf89bbb0a40"),
				style = WarnTips.STYLE_Y
			}
		)
end

function RechargeScene:onHallScoreChangeHandler()
	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_:setString(number_format(score))
end

function RechargeScene:onEndEnterTransition()
	self:requireStoreItems()
	
	if global.g_mainPlayer:isLoginEnough() then
		self:initMoMoPay()
		self:initZaloPay()
	end

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_ITEMS_SUCCESS, self, self.onStoreItemsSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_ITEMS_FAILED, self, self.onStoreItemsFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_BUY_SUCCESS, self, self.onStoreBuySuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_STORE_BUY_FAILED, self, self.onStoreBuyFailed)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onHallScoreChangeHandler)
end

function RechargeScene:onStartExitTransition()
	MultipleDownloader:removeFileDownload("RequestMoMoOrderId")
	MultipleDownloader:removeFileDownload("RequestZalopayOrderId")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_ITEMS_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_ITEMS_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_BUY_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_STORE_BUY_FAILED, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
end

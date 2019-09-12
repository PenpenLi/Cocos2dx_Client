ShopScene = class("ShopScene", LayerBase)

local pathPayQR = cc.FileUtils:getInstance():getWritablePath() .. "PayQRCode.png"

local exchangeGetUrl = "http://23.91.108.8:85/WS/InvokeAPI.ashx?action=getitem"
local exchangeBagGetUrl = "http://23.91.108.8:85/WS/InvokeAPI.ashx?action=getorder&userId=%d&timestamp=%d&pageSize=%d&pageIndex=%d&status=%d&sign=%s"

function ShopScene:ctor()
	ShopScene.super.ctor(self)

	local pathJson = getLayoutJson("fullmain/res/json/ui_main_shop.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	self.bg = ccui.Helper:seekWidgetByName(root, "Image_37")

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_11")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "Label_4")
	self.labelScore_:setString(number_format(score))
	self.labelScore_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	-- local insure = global.g_mainPlayer:getInsureMoney()
	-- self.labelInsure_ = ccui.Helper:seekWidgetByName(root, "Label_44")
	-- self.labelInsure_:setString(number_format(insure))

	-- self.iconPayCode_ = ccui.Helper:seekWidgetByName(root, "Image_17")

	self.scrollShop_ = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

	self.scrollBag_ = ccui.Helper:seekWidgetByName(root, "ScrollView_shop")


	-- self.scrollExshop_ = ccui.Helper:seekWidgetByName(root, "ScrollView_1_0")


	self.scrollExbag_ = ccui.Helper:seekWidgetByName(root, "ScrollView_exchange")

	self.cbPersonal_ = ccui.Helper:seekWidgetByName(root, "CheckBox_Personal")
	self.cbPersonal_:addEventListener(handler(self, self.onSelectedChange))

	self.cbShop_ = ccui.Helper:seekWidgetByName(root, "CheckBox_Shop")
	self.cbShop_:addEventListener(handler(self, self.onSelectedChange))

	-- self.cbPaycode_ = ccui.Helper:seekWidgetByName(root, "CheckBox_5")
	-- self.cbPaycode_:addEventListener(handler(self, self.onSelectedChange))

	-- self.cbExchange_ = ccui.Helper:seekWidgetByName(root, "CheckBox_9")
	-- self.cbExchange_:addEventListener(handler(self, self.onSelectedChange))

	self.cbBag = ccui.Helper:seekWidgetByName(root, "CheckBox_Bag")
	self.cbBag:addEventListener(handler(self, self.onSelectedChange))

	self.panelPersonal_ = ccui.Helper:seekWidgetByName(root, "Panel_Personal")
	self.panelShop_ = ccui.Helper:seekWidgetByName(root, "Panel_Shop")
	-- self.panelCode_ = ccui.Helper:seekWidgetByName(root, "Panel_Paycode")
	-- self.panelExchange_ = ccui.Helper:seekWidgetByName(root, "Panel_Exchange")
	self.panelBag_ = ccui.Helper:seekWidgetByName(root, "Panel_Bag")

	self.cbShopBag = ccui.Helper:seekWidgetByName(root, "CheckBox_43")
	self.cbShopBag:addEventListener(handler(self, self.onSelectedBagChange))

	self.cbExchangeBag = ccui.Helper:seekWidgetByName(root, "CheckBox_43_0")
	self.cbExchangeBag:addEventListener(handler(self, self.onSelectedBagChange))

	--个人信息
	self.inputName_ = createCursorTextField(self.panelPersonal_, "TextField_Name")
	self.inputName_:setFontColor(cc.c3b(0, 0, 0))

	self.inputMobi_ = createCursorTextField(self.panelPersonal_, "TextField_Mobi", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputMobi_:setFontColor(cc.c3b(0, 0, 0))

	self.inputZaloPay_ = createCursorTextField(self.panelPersonal_, "TextField_ZaloPay", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputZaloPay_:setFontColor(cc.c3b(0, 0, 0))

	self.btnUpdate_ = ccui.Helper:seekWidgetByName(self.panelPersonal_, "Button_Update")
	self.btnUpdate_:addTouchEventListener(makeClickHandler(self, self.onUpdatePersonal))

	self:defaultView()
end

function ShopScene:defaultView()
	-- if not global.g_mainPlayer:isBindMoMo() then
	-- 	self.selectedMainBox_ = self.cbPersonal_
	-- 	self.selectedMainBox_:setSelected(true)
	-- 	self.bg:loadTexture("fullmain/res/shop/bg_diban01.png")

	-- 	self.panelShop_:setVisible(false)
	-- 	-- self.panelCode_:setVisible(false)
	-- 	self.panelBag_:setVisible(false)
	-- 	self.panelPersonal_:setVisible(true)
	-- 	-- self.panelExchange_:setVisible(false)

	-- 	self.selectedBox_ = self.cbShopBag
	-- 	self.selectedBox_:setSelected(true)
	-- 	self.scrollBag_:setVisible(true)
	-- 	self.scrollExbag_:setVisible(false)
	-- else
	-- 	self.selectedMainBox_ = self.cbPersonal_
	-- 	self.selectedMainBox_:setSelected(true)

	-- 	self.cbPersonal_:setVisible(false)
	-- 	self.cbShop_:setPositionY(580)
	-- 	self.cbBag:setPositionY(480)

	-- 	self.selectedBox_ = self.cbShopBag
	-- 	self.selectedBox_:setSelected(true)
	-- 	self.scrollBag_:setVisible(true)
	-- 	self.scrollExbag_:setVisible(false)

	-- 	self.cbShop_:setSelected(true)
	-- 	self:onSelectedChange(self.cbShop_, ccui.CheckBoxEventType.selected)
	-- end

	self.selectedMainBox_ = self.cbShop_
	self.selectedMainBox_:setSelected(true)
	self.bg:loadTexture("fullmain/res/shop/bg_diban02.png")

	self.panelShop_:setVisible(true)
	self.panelBag_:setVisible(false)
	self.panelPersonal_:setVisible(false)

	self.selectedBox_ = self.cbShopBag
	self.selectedBox_:setSelected(true)
	self.scrollBag_:setVisible(true)
	self.scrollExbag_:setVisible(false)
end

-- function ShopScene:onNodeEnterTransitionFinish()
-- 	local scheduleId
-- 	local function onComplete()
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

-- 		self:onPopUpComplete()
-- 	end
-- 	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 0.1, false)
-- end


function ShopScene:initShopItems()
	self.scrollShop_:removeAllChildren()

	local GAP = 36
	local maxRow = math.ceil(#self.shopItems_ / 2)
	local maxHeight = maxRow * (224 + GAP) - GAP

	for i = 1, #self.shopItems_ do
		local data = self.shopItems_[i]
		local item = ui_shop_item_t.new(data)

		local row = math.floor((i-1)/2)
		local col = (i-1)%2
		item.node_:setPosition(cc.p(col*(400+GAP), (maxRow-row-1)*(224+GAP)))

		self.scrollShop_:addChild(item.node_)
	end
	self.scrollShop_:setInnerContainerSize(cc.size(845, maxHeight))

	local guide = global.g_mainPlayer:getCurrentGuide()
	if not guide then return end

	if guide == GAME_GUIDES.GUIDE_SHOP_BUY then
		self.guideFinger_ = GuideFinger.new()

		self.guideFinger_:setPosition(cc.p(195, (maxRow - 1)*(224 + GAP) + 35))
		self.scrollShop_:addChild(self.guideFinger_)
	end
end

function ShopScene:initBagItems()
	self.scrollBag_:removeAllChildren()
	self.bagPlaces_ = {}
	local GAP = 37
	local maxRow = math.ceil(#self.bagItems_/2)
	for i = 1, #self.bagItems_ do
		local data = self.bagItems_[i]
		local item = nil
		if data.index > 5 then
			item = ui_medal_item_t.new(data)
		else
			item = ui_bag_item_t.new(data)
		end

		local row = math.floor((i-1)/2)
		local col = (i-1)%2
		item.node_:setPosition(cc.p(col*(429+GAP), (maxRow-row-1)*(224+GAP)))
		if #self.bagItems_ <= 2 then
			item.node_:setPosition(cc.p(col*(429+GAP), self.scrollBag_:getContentSize().height - 224 - GAP))
		end
 		self.scrollBag_:addChild(item.node_)

		table.insert(self.bagPlaces_, item)
	end

	local maxHeight = maxRow * (224+GAP)-GAP
	self.scrollBag_:setInnerContainerSize(cc.size(854, maxHeight))
end

function ShopScene:initExshopItems()
	-- local GAP = 37
	-- local size = self.scrollExshop_:getContentSize()
	-- local maxRow = math.ceil(#self.exshopItems_/2)
	-- local maxHeight = maxRow * (224+GAP)-GAP
	-- local baseY = 0
	-- if maxHeight < size.height then
	-- 	baseY = size.height - maxHeight
	-- end

	-- for i = 1, #self.exshopItems_ do
	-- 	local data = self.exshopItems_[i]
	-- 	local item = ui_exshop_item_t.new(data)

	-- 	local row = math.floor((i-1)/2)
	-- 	local col = (i-1)%2
	-- 	item.node_:setPosition(cc.p(col*(400+GAP), (maxRow-row-1)*(224+GAP)+baseY))

	-- 	self.scrollExshop_:addChild(item.node_)
	-- end
	
	-- self.scrollExshop_:setInnerContainerSize(cc.size(845, maxHeight))
end

function ShopScene:initExshopBagItems()
	self.scrollExbag_:removeAllChildren()
	self.exBagPlaces_ = {}
	local GAP = 37
	local BAG_PLACE = #self.exshopBagItems_
	local maxRow = math.ceil(BAG_PLACE/2)
	for i = 1, BAG_PLACE do
		local data = self.exshopBagItems_[i]
		local item = ui_exbag_item_t.new(data)

		local row = math.floor((i-1)/2)
		local col = (i-1)%2
		item.node_:setPosition(cc.p(col*(429+GAP), (maxRow-row-1)*(224+GAP)))
		if BAG_PLACE <= 2 then
			item.node_:setPosition(cc.p(col*(429+GAP), self.scrollExbag_:getContentSize().height - 224 - GAP))
		end
		self.scrollExbag_:addChild(item.node_)

		table.insert(self.exBagPlaces_, item)
	end

	local maxHeight = maxRow * (224+GAP)-GAP
	self.scrollExbag_:setInnerContainerSize(cc.size(854, maxHeight))
end

function ShopScene:requireExchangeItem()
	MultipleDownloader:createDataDownLoad(
		{
			identifier = "requireExchangeItem",
			fileUrl = exchangeGetUrl,
			onDataTaskSuccess = function(dataTask, params)
				self.exshopItems_ = json.decode(params)
				self:initExshopItems()
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
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

function ShopScene:requireExchangeBag()
	local playerId = global.g_mainPlayer:getPlayerId()
	local nowTime = os.time()
	local sign = cc.utils:getDataMD5Hash(string.format("userId=%d&timestamp=%d&pageSize=%d&pageIndex=%d&status=%d&key=HVQSJSL8MCO65SQ3ZVV1S4Q9M9ECNADP", playerId, nowTime, 100, 1, 0))
	local url = string.format(exchangeBagGetUrl, playerId, nowTime, 100, 1, 0, string.upper(sign))
	
	MultipleDownloader:createDataDownLoad(
		{
			identifier = "requireExchangeBag",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local output = json.decode(params)
				if output.code == 200 then
					self.exshopBagItems_ = output.data.Items
					self:initExshopBagItems()
				end
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
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

function ShopScene:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedMainBox_ ~= sender then
			self.cbBag:setSelected(false)
			self.bg:loadTexture("fullmain/res/shop/bg_diban02.png")
			self.selectedMainBox_:setSelected(false)
			self.selectedMainBox_ = sender

			if self.selectedMainBox_ == self.cbShop_ then
				self.panelShop_:setVisible(true)
				-- self.panelCode_:setVisible(false)
				-- self.panelExchange_:setVisible(false)
				self.panelBag_:setVisible(false)
				self.panelPersonal_:setVisible(false)
			-- elseif self.selectedMainBox_ == self.cbPaycode_ then
			-- 	self.panelShop_:setVisible(false)
			-- 	self.panelCode_:setVisible(true)
			-- 	self.panelExchange_:setVisible(false)
			-- 	self.panelBag_:setVisible(false)
			-- 	self.panelPersonal_:setVisible(false)
			-- elseif self.selectedMainBox_ == self.cbExchange_ then
			-- 	self.panelShop_:setVisible(false)
			-- 	self.panelCode_:setVisible(false)
			-- 	self.panelExchange_:setVisible(true)
			-- 	self.panelBag_:setVisible(false)
			-- 	self.panelPersonal_:setVisible(false)
			elseif self.selectedMainBox_ == self.cbBag then
				self.cbBag:setSelected(true)
				-- self.cbShopBag:setSelected(true)
				self.panelShop_:setVisible(false)
				-- self.panelCode_:setVisible(false)
				-- self.panelExchange_:setVisible(false)
				self.panelBag_:setVisible(true)
				-- self.scrollExbag_:setVisible(false)
				self.panelPersonal_:setVisible(false)
				self.bg:loadTexture("fullmain/res/shop/bg_diban01.png")
			elseif self.selectedMainBox_ == self.cbPersonal_ then
				self.panelShop_:setVisible(false)
				-- self.panelCode_:setVisible(false)
				-- self.panelExchange_:setVisible(false)
				self.panelBag_:setVisible(false)
				self.panelPersonal_:setVisible(true)
				self.bg:loadTexture("fullmain/res/shop/bg_diban01.png")
			end
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function ShopScene:onSelectedBagChange(sender, eventType)
	self.bg:loadTexture("fullmain/res/shop/bg_diban01.png")
	if eventType == ccui.CheckBoxEventType.selected then
		if self.selectedBox_ ~= sender then
			self.selectedBox_:setSelected(false)
			self.selectedBox_ = sender

			if self.selectedBox_ == self.cbShopBag then
				-- self.cbBag:setSelected(true)
				self.cbShopBag:setSelected(true)
				self.cbExchangeBag:setSelected(false)
				self.scrollBag_:setVisible(true)
				self.scrollExbag_:setVisible(false)
			elseif self.selectedBox_ == self.cbExchangeBag then
				-- self.cbBag:setSelected(true)
				self.scrollBag_:setVisible(false)
				self.cbExchangeBag:setSelected(true)
				self.scrollExbag_:setVisible(true)
				self.cbShopBag:setSelected(false)
			end
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function ShopScene:requestShopData()
	gatesvr.sendPropertyInfoQuery()
	self:requireExchangeBag()
	self:requestPersonalInfo()
end

function ShopScene:requestPersonalInfo()
	if global.g_mainPlayer:isBind3rdPay() then
		self.cbPersonal_:setVisible(false)
		self.cbShop_:setPositionY(580)
		self.cbBag:setPositionY(480)

		local realname = global.g_mainPlayer:getRealname()
		local momo = global.g_mainPlayer:getViMomo()
		local zalopay = global.g_mainPlayer:getZaloPay()

		self.inputName_:setText(realname)
		self.inputMobi_:setText(momo)
		self.inputZaloPay_:setText(zalopay)
		self.btnUpdate_:setVisible(false)

		self.cbShop_:setSelected(true)
		self:onSelectedChange(self.cbShop_, ccui.CheckBoxEventType.selected)
	else
		LoadingView.showTips()

		-- gatesvr.requireUserInfo()
		gatesvr.sendGetUserInfoNew()
	end
end

function ShopScene:onUpdatePersonal()
	local realname = string.trim(self.inputName_:getText())
	local anyNum = string.find(realname, "%d")
	local anyPunctuation = string.find(realname, "%p")
	if realname == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_92d4fd49f891cbf4"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	elseif anyNum or anyPunctuation then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_99c4046ba9ecbebf"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local spreader = global.g_mainPlayer:getSpreaderId()
	local zalopay = string.trim(self.inputZaloPay_:getText())
	local mobi = string.trim(self.inputMobi_:getText())
	local rmomo = string.find(mobi, "^0%d%d%d%d%d%d%d%d%d%d?$")
	if not rmomo then
		mobi = ""
	end

	local rzalopay = string.find(zalopay, "^0%d%d%d%d%d%d%d%d%d%d?$")
	if not rzalopay then
		zalopay = ""
	end

	if rmomo or rzalopay then
		LoadingView.showTips()

		gatesvr.sendUserInfoUpdateNew(spreader, realname, mobi, zalopay, "", "", "")
	else
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_6345b2ec3788f4b4"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function ShopScene:onCloseHandler()
	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)

	global.g_mainPlayer:popGuide()
end

function ShopScene:onBuySuccessHandler(itemData, targetId)
	local guide = global.g_mainPlayer:getCurrentGuide()
	if guide and guide == GAME_GUIDES.GUIDE_SHOP_BUY then
		self.guideFinger_:close()
		global.g_mainPlayer:nextGuideStep()
	end

	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_:setString(number_format(score))

	if targetId == global.g_mainPlayer:getGameId() then
		gatesvr.sendInsureInfoQuery(true)
		self:mergeBagItem(itemData)
		self:refreshBagItem()
	end

	if itemData.index == 1 then
		gatesvr.sendPropertyInfoQuery()
	end
end

function ShopScene:mergeBagItem(itemData)
	for _, v in pairs(self.bagItems_) do
		if v.index == itemData.index then
			v.count = v.count + itemData.count
			return
		end
	end
	table.insert(self.bagItems_, itemData)
end

function ShopScene:removeBagItem(itemId, itemCount)
	for i = 1, #self.bagItems_ do
		local data = self.bagItems_[i]
		if data.index == itemId then
			data.count = data.count - itemCount
			if data.count <= 0 then
				table.remove(self.bagItems_, i)
			end
			return
		end
	end
end

function ShopScene:getBagItem(itemId)
	for i = 1, #self.bagItems_ do
		local data = self.bagItems_[i]
		if data.index == itemId then
			return data
		end
	end
	return nil
end

function ShopScene:refreshBagItem()
	self:initBagItems()
	-- for i = 1, #self.bagPlaces_ do
	-- 	local item = self.bagPlaces_[i]
	-- 	local data = self.bagItems_[i]
	-- 	item:setItemData(data)
	-- end
end

function ShopScene:refreshExshopBagItems()
	self:initExshopBagItems()
	-- for i = 1, #self.exBagPlaces_ do
	-- 	local item = self.exBagPlaces_[i]
	-- 	local data = self.exshopBagItems_[i]
	-- 	item:setItemData(data)
	-- end
end

function ShopScene:onSellSuccessHandler(itemId, itemCount)
	if itemId > 5 then
		local itemData = self:getBagItem(itemId)
		PopUpView.showPopUpView(ui_shop_adorn_medal_t, itemData)
	end

	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_:setString(number_format(score))
	gatesvr.sendInsureInfoQuery(true)
	self:removeBagItem(itemId, itemCount)
	self:refreshBagItem()
end

function ShopScene:onGiveSuccessHandler(itemId, itemCount)
	gatesvr.sendInsureInfoQuery(true)
	self:removeBagItem(itemId, itemCount)
	self:refreshBagItem()
end

function ShopScene:onGitItemSuccessHandler(itemId, itemCount)
	gatesvr.sendInsureInfoQuery(true)
	self:removeBagItem(itemId, itemCount)
	self:refreshBagItem()
end

function ShopScene:onShopInfoHandler(shopItems, bagItems)
	self.shopItems_ = shopItems
	self.bagItems_ = bagItems

	self:initShopItems()
	self:initBagItems()
end

function ShopScene:onExchangeSuccessHandler()
	local playerId = global.g_mainPlayer:getPlayerId()
	local nowTime = os.time()
	local sign = cc.utils:getDataMD5Hash(string.format("userId=%d&timestamp=%d&pageSize=%d&pageIndex=%d&status=%d&key=HVQSJSL8MCO65SQ3ZVV1S4Q9M9ECNADP", playerId, nowTime, 100, 1, 0))
	local url = string.format(exchangeBagGetUrl, playerId, nowTime, 100, 1, 0, string.upper(sign))

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "onExchangeSuccessHandler",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local output = json.decode(params)
				if output.code == 200 then
					self.exshopBagItems_ = output.data.Items
					self:refreshExshopBagItems()
				end
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
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

function ShopScene:onInsureInfoHandler()
	local score = global.g_mainPlayer:getPlayerScore()
	self.labelScore_:setString(number_format(score))

	-- local insure = global.g_mainPlayer:getInsureMoney()
	-- self.labelInsure_:setString(number_format(insure))
end

function ShopScene:onGetPayCodeSuccessHandler(paycode)
	local content = string.format("%s%d", paycode, global.g_mainPlayer:getPlayerId())
	if util:saveQRImageFile(content, 250, pathPayQR) and cc.Director:getInstance():getTextureCache():reloadTexture(pathPayQR) then
		self.iconPayCode_:loadTexture(pathPayQR)
	end
end

function ShopScene:onPutawaySuccess()
	gatesvr.sendPropertyInfoQuery()

	local guide = global.g_mainPlayer:getCurrentGuide()
	if not guide then return end

	if guide == GAME_GUIDES.GUIDE_SHOP_AUCTION then
		global.g_mainPlayer:popGuide()
	end
end

function ShopScene:onGetDataBindSuccess()
	if global.g_mainPlayer:isBind3rdPay() then
		self.cbPersonal_:setVisible(false)
		self.cbShop_:setPositionY(580)
		self.cbBag:setPositionY(480)

		local realname = global.g_mainPlayer:getRealname()
		local momo = global.g_mainPlayer:getViMomo()
		local zalopay = global.g_mainPlayer:getZaloPay()

		self.inputName_:setText(realname)
		self.inputMobi_:setText(momo)
		self.inputZaloPay_:setText(zalopay)
		self.btnUpdate_:setVisible(false)

		self.cbShop_:setSelected(true)
		self:onSelectedChange(self.cbShop_, ccui.CheckBoxEventType.selected)
	end
end

function ShopScene:onModifyDataBindSuccess()
	self.cbPersonal_:setVisible(false)
	self.cbShop_:setPositionY(580)
	self.cbBag:setPositionY(480)

	local realname = global.g_mainPlayer:getRealname()
	local momo = global.g_mainPlayer:getViMomo()
	local zalopay = global.g_mainPlayer:getZaloPay()

	self.inputName_:setText(realname)
	self.inputMobi_:setText(momo)
	self.inputZaloPay_:setText(zalopay)
	self.btnUpdate_:setVisible(false)

	self.cbShop_:setSelected(true)
	self:onSelectedChange(self.cbShop_, ccui.CheckBoxEventType.selected)
end

function ShopScene:onCompleteMoMoHandler()
	self.cbPersonal_:setSelected(true)
	self:onSelectedChange(self.cbPersonal_, ccui.CheckBoxEventType.selected)
end

function ShopScene:onEndEnterTransition()
	self:requestShopData()

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self, self.onInsureInfoHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_INFO, self, self.onShopInfoHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self, self.onBuySuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self, self.onSellSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_GIVE_SUCCESS, self, self.onGiveSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS, self, self.onGitItemSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS, self, self.onExchangeSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS, self, self.onGetPayCodeSuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self, self.onPutawaySuccess)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_REQUEST_USER_INFO, self, self.onRequestUserInfo)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MODIFY_USER_INFO, self, self.onModifyUserInfo)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_MOMO, self, self.onCompleteMoMoHandler)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self, self.onGetDataBindSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self, self.onModifyDataBindSuccess)
end

function ShopScene:onStartExitTransition()
	MultipleDownloader:removeFileDownload("requireExchangeItem")
	MultipleDownloader:removeFileDownload("requireExchangeBag")
	MultipleDownloader:removeFileDownload("onExchangeSuccessHandler")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_HALL_SCORE_CHANGE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_GIVE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_ITEM_GIVE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_GET_PAYCODE_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_REQUEST_USER_INFO, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MODIFY_USER_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_MOMO, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self)
end
ui_shop_item_t = class("ui_shop_item_t")

function ui_shop_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shopItem.json")
	local function onNodeEvent(event)
		if event == "exit" then
			self:removeMsgHandler()
		end
	end
	self.node_:registerScriptHandler(onNodeEvent)

	self:initMsgHandler()

	local cfg = shop_config[self.itemData_.index]

	self.panelIcon_ = ccui.Helper:seekWidgetByName(self.node_, "Panel_Icon")

	local pathIcon = string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index)
	local imageLocal = ui_image_local_t.new(pathIcon)
	self.panelIcon_:addChild(imageLocal)

	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_3")
	labelname:setString(cfg.name)

	local labelBuyPrice1 = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	labelBuyPrice1:setString(self.itemData_.propertyGold)

	local score = global.g_mainPlayer:getPlayerScore()
	self.labelCount_ = ccui.Helper:seekWidgetByName(self.node_, "Label_6")
	local count = math.floor(score/self.itemData_.propertyGold)
	if self.itemData_.index == 1 then
		count = math.min(count, 1)
		self.labelCount_:setString(count)
	else
		self.labelCount_:setString(count)
	end
	local btn_operate = ccui.Helper:seekWidgetByName(self.node_, "Button_11")
	btn_operate:setPressedActionEnabled(true)
	btn_operate:addTouchEventListener(makeClickHandler(self, self.onTouchItem))
end

function ui_shop_item_t:onTouchItem()
	PopUpView.showPopUpView(ui_shop_buy_t, self.itemData_)
end

function ui_shop_item_t:onBuySuccessHandler()
	local score = global.g_mainPlayer:getPlayerScore()
	local count = math.floor(score/self.itemData_.propertyGold)
	if self.itemData_.index == 1 then
		count = math.min(count, 1)
		self.labelCount_:setString(count)
	else
		self.labelCount_:setString(count)
	end
end

function ui_shop_item_t:OnSellSuccessHandler()
	local score = global.g_mainPlayer:getPlayerScore()
	local count = math.floor(score/self.itemData_.propertyGold)
	if self.itemData_.index == 1 then
		count = math.min(count, 1)
		self.labelCount_:setString(count)
	else
		self.labelCount_:setString(count)
	end
end

function ui_shop_item_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self, self.onBuySuccessHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self, self.OnSellSuccessHandler)
end

function ui_shop_item_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_SELL_SUCCESS, self)
end
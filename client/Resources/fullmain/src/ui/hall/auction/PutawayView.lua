PutawayView = class("PutawayView", PopUpView)

function PutawayView:ctor(itemId)
	PutawayView.super.ctor(self, true)

	self.itemId_ = itemId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_putaway.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.listGoods_ = ccui.Helper:seekWidgetByName(root, "ListView_Goods")
	self.listGoods_:addEventListener(handler(self, self.onSelectedChange))

	self.labelPrice_ = ccui.Helper:seekWidgetByName(root, "Label_Price")
	self.labelPrice_:setTextColor(cc.c4b(0, 255, 0, 255))

	self.labelCount_ = ccui.Helper:seekWidgetByName(root, "Label_Count")

	local btnSub = ccui.Helper:seekWidgetByName(root, "Button_Sub")
	btnSub:addTouchEventListener(makeClickHandler(self, self.onSub))

	local btnAdd = ccui.Helper:seekWidgetByName(root, "Button_Add")
	btnAdd:addTouchEventListener(makeClickHandler(self, self.onAdd))

	self.btnPutaway_ = ccui.Helper:seekWidgetByName(root, "Button_Putaway")
	self.btnPutaway_:addTouchEventListener(makeClickHandler(self, self.onPutaway))
end

function PutawayView:onPopUpComplete()
	LoadingView.showTips()

	self.count_ = 1
	gatesvr.sendPropertyInfoQuery()

	local guide = global.g_mainPlayer:getCurrentGuide()
	if not guide then return end

	if guide == GAME_GUIDES.GUIDE_SHOP_AUCTION then
		self.guideFinger_ = GuideFinger.new()

		self.guideFinger_:setPosition(cc.p(133, 18))
		self.btnPutaway_:addChild(self.guideFinger_)
	end
end

function PutawayView:defaultPrice()
	if self.selectedNode_ then
		local index = self.selectedNode_:getTag()
		local itemData = self.items_[index]

		self.count_ = itemData.count

		self.labelPrice_:setString(string.format("%d", self.count_ * itemData.propertyGold * SELL_RATE))
		self.labelCount_:setString(self.count_)
	else
		self.labelPrice_:setString("0")
		self.labelCount_:setString("0")
	end
end

function PutawayView:onSub()
	if not self.selectedNode_ then return end

	local index = self.selectedNode_:getTag()
	local itemData = self.items_[index]
	self.count_ = math.max(1, self.count_ - 1)

	self.labelPrice_:setString(string.format("%d", self.count_ * itemData.propertyGold * SELL_RATE))
	self.labelCount_:setString(self.count_)
end

function PutawayView:onAdd()
	if not self.selectedNode_ then return end

	local index = self.selectedNode_:getTag()
	local itemData = self.items_[index]
	self.count_ = math.min(itemData.count, self.count_ + 1)

	self.labelPrice_:setString(string.format("%d", self.count_ * itemData.propertyGold * SELL_RATE))
	self.labelCount_:setString(self.count_)
end

function PutawayView:onSelectedChange(sender, eventType)
	if eventType == ccui.ListViewEventType.ONSELECTEDITEM_END then
		local index = self.listGoods_:getCurSelectedIndex()
		local itemNode = self.listGoods_:getItem(index)
		if itemNode ~= self.selectedNode_ then
			if self.selectedNode_ then
				self.selectedNode_.checkBox_:setSelected(false)
			end

			itemNode.checkBox_:setSelected(true)
			self.selectedNode_ = itemNode

			self:defaultPrice()
		end
	end
end

function PutawayView:onCloseHandler()
	self:close()
end

function PutawayView:onShopInfoHandler(shopItems, bagItems)
	LoadingView.closeTips()

	self.items_ = bagItems
	if self.itemId_ then
		table.sort(self.items_, function(a, b)
				if a.index == self.itemId_ then
					return true
				elseif b.index == self.itemId_ then
					return false
				elseif a.index < b.index then
					return true
				elseif a.index > b.index then
					return false
				else
					return false
				end
			end)
	end

	for i = 1, #self.items_ do
		local itemData = self.items_[i]
		local itemNode = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_putaway_item.json")
		itemNode:setTag(i)

		itemNode.itemIcon_ = ccui.Helper:seekWidgetByName(itemNode, "Image_Goods")
		itemNode.itemIcon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", itemData.index))

		itemNode.itemCount_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Count")
		itemNode.itemCount_:setTextColor(cc.c4b(0, 255, 0, 255))
		itemNode.itemCount_:enableOutline(cc.c4b(0, 0, 0, 255), 2)
		itemNode.itemCount_:setString(string.format("x%d", itemData.count))

		itemNode.checkBox_ = ccui.Helper:seekWidgetByName(itemNode, "CheckBox_Goods")

		if itemData.index == self.itemId_ then
			self.selectedNode_ = itemNode
			itemNode.checkBox_:setSelected(true)
		else
			itemNode.checkBox_:setSelected(false)
		end

		self.listGoods_:pushBackCustomItem(itemNode)
	end

	handlerDelayed(function() self.listGoods_:jumpToLeft() end)

	self:defaultPrice()
end

function PutawayView:onPutaway()
	if not self.selectedNode_ then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_de957f31d52eb049"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local index = self.selectedNode_:getTag()
	local itemData = self.items_[index]

	LoadingView.showTips()

	gatesvr.sendPutaway(itemData.index, self.count_)
end

function PutawayView:onPutawaySuccess()
	self:close()
end

function PutawayView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_INFO, self, self.onShopInfoHandler)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self, self.onPutawaySuccess)
end

function PutawayView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self)
end
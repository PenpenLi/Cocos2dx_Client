AuctionScene = class("AuctionScene", LayerBase)

AUCTION_LIST_URL = "http://23.91.108.8:81/WS/AuctionHouse.ashx?action=getpibystate&pageIndex=%d&pageSize=5"
RACKING_LIST_URL = "http://23.91.108.8:81/WS/AuctionHouse.ashx?action=getpibyuserid&pageIndex=%d&pageSize=5&userId=%d"
BUY_LIST_URL = "http://23.91.108.8:81/WS/AuctionHouse.ashx?action=getpoibyuserid&pageIndex=%d&pageSize=5&buyuserId=%d"

STRING_RACKING_STATE = {
	[0] = LocalLanguage:getLanguageString("L_816e543856f1f618"), --上架中
	[1] = LocalLanguage:getLanguageString("L_ffef6a9a31a13b4c"), --下单待付款
	[2] = LocalLanguage:getLanguageString("L_568d7fc304a41332"), --已付款
	[3] = LocalLanguage:getLanguageString("L_fb1ad4d669d79ac9"), --订单结束
	[5] = LocalLanguage:getLanguageString("L_9703899c406202e1"), --下架
	[6] = LocalLanguage:getLanguageString("L_b14d2f3023b9afb4"), --未完善信息
}

STRING_BUY_STATE = {
	[1] = LocalLanguage:getLanguageString("L_ffef6a9a31a13b4c"), --下单待付款
	[2] = LocalLanguage:getLanguageString("L_568d7fc304a41332"), --已付款
	[3] = LocalLanguage:getLanguageString("L_fb1ad4d669d79ac9"), --订单结束
	[5] = LocalLanguage:getLanguageString("L_1c7b22ba5e898146"), --超时取消
}

STATUS_CODE = {
	CHECK_CODE = 1, --检查状态
	NORMAL_CODE = 2, --正常状态
}

SWITCH_CODE = {
	AUCTION_LIST = 1, --拍卖列表
	PERSONAL_INFO = 2, --个人信息
	RACKING_LIST = 3, --上架列表
	BUY_LIST = 4, --购买列表
}

function AuctionScene:ctor(switchCode)
	AuctionScene.super.ctor(self)

	self.switchCode_ = switchCode or SWITCH_CODE.AUCTION_LIST

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_auction.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	self.labelGold_ = ccui.Helper:seekWidgetByName(root, "Label_Gold")
	self.labelGold_:setString(global.g_mainPlayer:getPlayerScore())
	self.labelGold_:enableOutline(cc.c4b(0, 0, 0, 255), 1)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.btnBindMoMo_ = ccui.Helper:seekWidgetByName(root, "Button_MoMo")
	self.btnBindMoMo_:setPressedActionEnabled(true)
	self.btnBindMoMo_:addTouchEventListener(makeClickHandler(self, self.onBindMoMoHandler))
	self.btnBindMoMo_:setVisible(false)

	self.btnAuctionGuide_ = ccui.Helper:seekWidgetByName(root, "Button_AuctionGuide")
	self.btnAuctionGuide_:setPressedActionEnabled(true)
	self.btnAuctionGuide_:addTouchEventListener(makeClickHandler(self, self.onAuctionGuideHandler))

	self.cbAuctionList_ = ccui.Helper:seekWidgetByName(root, "CheckBox_AuctionList")
	self.cbPersonalInfo_ = ccui.Helper:seekWidgetByName(root, "CheckBox_PersonalInfo")
	self.cbRackingList_ = ccui.Helper:seekWidgetByName(root, "CheckBox_RackingList")
	self.cbBuyList_ = ccui.Helper:seekWidgetByName(root, "CheckBox_BuyList")

	self.cbAuctionList_:setTag(SWITCH_CODE.AUCTION_LIST)
	self.cbPersonalInfo_:setTag(SWITCH_CODE.PERSONAL_INFO)
	self.cbRackingList_:setTag(SWITCH_CODE.RACKING_LIST)
	self.cbBuyList_:setTag(SWITCH_CODE.BUY_LIST)

	self.cbAuctionList_:addEventListener(handler(self, self.onSelectedChange))
	self.cbPersonalInfo_:addEventListener(handler(self, self.onSelectedChange))
	self.cbRackingList_:addEventListener(handler(self, self.onSelectedChange))
	self.cbBuyList_:addEventListener(handler(self, self.onSelectedChange))

	self.panelAuctionList_ = ccui.Helper:seekWidgetByName(root, "Panel_AuctionList")
	self.panelPersonalInfo_ = ccui.Helper:seekWidgetByName(root, "Panel_PersonalInfo")
	self.panelRackingList_ = ccui.Helper:seekWidgetByName(root, "Panel_RackingList")
	self.panelBuyList_ = ccui.Helper:seekWidgetByName(root, "Panel_BuyList")

	--拍卖列表
	self.listAuction_ = ccui.Helper:seekWidgetByName(self.panelAuctionList_, "ListView_Auction")
	self.labelPageAuction_ = ccui.Helper:seekWidgetByName(self.panelAuctionList_, "Label_AuctionPage")

	local btnUpAuction = ccui.Helper:seekWidgetByName(self.panelAuctionList_, "Button_UpAuction")
	btnUpAuction:addTouchEventListener(makeClickHandler(self, self.onUpAuction))

	local btnDownAuction = ccui.Helper:seekWidgetByName(self.panelAuctionList_, "Button_DownAuction")
	btnDownAuction:addTouchEventListener(makeClickHandler(self, self.onDownAuction))

	--个人信息
	self.inputName_ = createCursorTextField(self.panelPersonalInfo_, "TextField_Name")
	self.inputName_:setFontColor(cc.c3b(0, 0, 0))

	self.inputAccount_ = createCursorTextField(self.panelPersonalInfo_, "TextField_Account")
	self.inputAccount_:setFontColor(cc.c3b(0, 0, 0))

	self.inputBank_ = createCursorTextField(self.panelPersonalInfo_, "TextField_Bank", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputBank_:setFontColor(cc.c3b(0, 0, 0))

	self.inputBankName_ = createCursorTextField(self.panelPersonalInfo_, "TextField_BankName")
	self.inputBankName_:setFontColor(cc.c3b(0, 0, 0))

	self.inputPhone_ = createCursorTextField(self.panelPersonalInfo_, "TextField_Phone", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputPhone_:setFontColor(cc.c3b(0, 0, 0))

	self.inputMobi_ = createCursorTextField(self.panelPersonalInfo_, "TextField_Mobi", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputMobi_:setFontColor(cc.c3b(0, 0, 0))

	local btnUpdate = ccui.Helper:seekWidgetByName(self.panelPersonalInfo_, "Button_Update")
	btnUpdate:addTouchEventListener(makeClickHandler(self, self.onUpdatePersonalInfo))

	--上架列表
	self.listRacking_ = ccui.Helper:seekWidgetByName(self.panelRackingList_, "ListView_Racking")
	self.labelPageRacking_ = ccui.Helper:seekWidgetByName(self.panelRackingList_, "Label_RackingPage")

	local btnUpRacking = ccui.Helper:seekWidgetByName(self.panelRackingList_, "Button_UpRacking")
	btnUpRacking:addTouchEventListener(makeClickHandler(self, self.onUpRacking))

	local btnDownRacking = ccui.Helper:seekWidgetByName(self.panelRackingList_, "Button_DownRacking")
	btnDownRacking:addTouchEventListener(makeClickHandler(self, self.onDownRacking))

	local btnAuction = ccui.Helper:seekWidgetByName(self.panelRackingList_, "Button_Auction")
	btnAuction:addTouchEventListener(makeClickHandler(self, self.onAuction))

	--购买列表
	self.listBuy_ = ccui.Helper:seekWidgetByName(self.panelBuyList_, "ListView_Buy")
	self.labelPageBuy_ = ccui.Helper:seekWidgetByName(self.panelBuyList_, "Label_BuyPage")

	local btnUpBuy = ccui.Helper:seekWidgetByName(self.panelBuyList_, "Button_UpBuy")
	btnUpBuy:addTouchEventListener(makeClickHandler(self, self.onUpBuy))

	local btnDownBuy = ccui.Helper:seekWidgetByName(self.panelBuyList_, "Button_DownBuy")
	btnDownBuy:addTouchEventListener(makeClickHandler(self, self.onDownBuy))

	self.dataSwitchs_ = {
		[SWITCH_CODE.AUCTION_LIST] = {box = self.cbAuctionList_, view = self.panelAuctionList_},
		[SWITCH_CODE.PERSONAL_INFO] = {box = self.cbPersonalInfo_, view = self.panelPersonalInfo_},
		[SWITCH_CODE.RACKING_LIST] = {box = self.cbRackingList_, view = self.panelRackingList_},
		[SWITCH_CODE.BUY_LIST] = {box = self.cbBuyList_, view = self.panelBuyList_},
	}

	self:defaultView()
end

function AuctionScene:defaultView()
	local dataSwitch = self.dataSwitchs_[self.switchCode_]
	dataSwitch.box:setSelected(true)
	dataSwitch.view:setVisible(true)

	self.currentAuction_ = 1
	self.totalAuction_ = 1

	self.currentRacking_ = 1
	self.totalRacking_ = 1

	self.currentBuy_ = 1
	self.totalBuy_ = 1
end

function AuctionScene:onBindMoMoHandler()
	PopUpView.showPopUpView(ui_complete_spreader_t)
end

function AuctionScene:onAuctionGuideHandler()
	global.g_mainPlayer:pushGuide({GAME_GUIDES.GUIDE_SHOP_BUY, GAME_GUIDES.GUIDE_SHOP_AUCTION})

	replaceScene(ShopScene, TRANS_CONST.TRANS_SCALE)
end

function AuctionScene:requestPageData()
	if self.switchCode_ == SWITCH_CODE.AUCTION_LIST then
		self.currentAuction_ = 1
		self.totalAuction_ = 1
		self:requestAuctionList()
	elseif self.switchCode_ == SWITCH_CODE.PERSONAL_INFO then
		self:requestPersonalInfo()
	elseif self.switchCode_ == SWITCH_CODE.RACKING_LIST then
		self.currentRacking_ = 1
		self.totalRacking_ = 1
		self:requestRackingList()
	elseif self.switchCode_ == SWITCH_CODE.BUY_LIST then
		self.currentBuy_ = 1
		self.totalBuy_ = 1
		self:requestBuyList()
	end
end

function AuctionScene:requestAuctionList()
	self.listAuction_:removeAllItems()

	LoadingView.showTips()

	local url = string.format(AUCTION_LIST_URL, self.currentAuction_)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "AuctionList",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 100 then
					self.currentAuction_ = luaTbl.data.pageIndex
					self.totalAuction_ = luaTbl.data.pageCount
					self.labelPageAuction_:setString(string.format("%d/%d", self.currentAuction_, self.totalAuction_))

					self.dataAuctions_ = {}
					for i = 1, #luaTbl.data.data do
						local itemAuction = luaTbl.data.data[i]
						local itemNode = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_auction_item.json")
						itemNode.itemIcon_ = ccui.Helper:seekWidgetByName(itemNode, "Image_Item")
						itemNode.itemIcon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", itemAuction.PropID))

						itemNode.labelName_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Name")
						itemNode.labelName_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelName_:setString(itemAuction.PropName)

						itemNode.labelCount_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Count")
						itemNode.labelCount_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelCount_:setString(itemAuction.PropCount)

						itemNode.labelPrice_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Price")
						itemNode.labelPrice_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelPrice_:setString(string.format("%d", itemAuction.AllPrice))

						itemNode.labelSeller_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Seller")
						itemNode.labelSeller_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelSeller_:setString(itemAuction.UserID)

						local btnBuy = ccui.Helper:seekWidgetByName(itemNode, "Button_Buy")
						btnBuy:setTag(itemAuction.ID)
						btnBuy:addTouchEventListener(makeClickHandler(self, self.onAuctionBuy))

						self.dataAuctions_[itemAuction.ID] = itemAuction

						self.listAuction_:pushBackCustomItem(itemNode)
					end

					handlerDelayed(function() self.listAuction_:jumpToTop() end)
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

function AuctionScene:onUpAuction()
	if self.currentAuction_ > 1 then
		self.currentAuction_ = self.currentAuction_ - 1
		self:requestAuctionList()
	end
end

function AuctionScene:onDownAuction()
	if self.currentAuction_ < self.totalAuction_ then
		self.currentAuction_ = self.currentAuction_ + 1
		self:requestAuctionList()
	end
end

function AuctionScene:onAuctionBuy(sender)
	if not global.g_mainPlayer:isBind3rdPay() then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_e368a61b336c7ede"),
					style = WarnTips.STYLE_YN,
					confirm = function()
							PopUpView.showPopUpView(ui_complete_spreader_t)
						end
				}
			)
		return
	end

	local auctionId = sender:getTag()
	local auctionData = self.dataAuctions_[auctionId]

	WarnTips.showTips(
			{
				text = string.format(LocalLanguage:getLanguageString("L_ac4ad82fc75febfd"), auctionData.AllPrice, auctionData.PropName),
				style = WarnTips.STYLE_YN,
				confirm = function()
						LoadingView.showTips()

						gatesvr.buyCommodity(auctionData.ID)
					end
			}
		)
end

function AuctionScene:requestPersonalInfo()
	LoadingView.showTips()

	gatesvr.requireUserInfo()
end

function AuctionScene:onUpdatePersonalInfo()
	local realname = string.trim(self.inputName_:getText())
	if realname == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_92d4fd49f891cbf4"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local account = string.trim(self.inputAccount_:getText())
	if account == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_60409c86ceabc538"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local phone = string.trim(self.inputPhone_:getText())
	if phone == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_89aea92c4ea04757"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local mobi = string.trim(self.inputMobi_:getText())
	local bank = string.trim(self.inputBank_:getText())
	local bankName = string.trim(self.inputBankName_:getText())

	if mobi == "" and bank == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_8e551a30fad0255f"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	elseif bank ~= "" and bankName == "" then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_0ae1440ddbca0715"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	LoadingView.showTips()

	gatesvr.updateUserInfo(realname, account, bank, phone, bankName, mobi, "")
end

function AuctionScene:requestRackingList()
	self.listRacking_:removeAllItems()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(RACKING_LIST_URL, self.currentRacking_, playerId)

	LoadingView.showTips()

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "RackingList",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 100 then
					self.currentRacking_ = luaTbl.data.pageIndex
					self.totalRacking_ = luaTbl.data.pageCount
					self.labelPageRacking_:setString(string.format("%d/%d", self.currentRacking_, self.totalRacking_))

					self.dataRackings_ = {}
					for i = 1, #luaTbl.data.data do
						local itemRacking = luaTbl.data.data[i]
						local itemNode = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_racking_item.json")
						itemNode.itemIcon_ = ccui.Helper:seekWidgetByName(itemNode, "Image_Item")
						itemNode.itemIcon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", itemRacking.PropID))

						itemNode.labelName_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Name")
						itemNode.labelName_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelName_:setString(itemRacking.PropName)

						itemNode.labelCount_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Count")
						itemNode.labelCount_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelCount_:setString(itemRacking.PropCount)

						itemNode.labelPrice_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Price")
						itemNode.labelPrice_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelPrice_:setString(string.format("%d", itemRacking.AllPrice))

						itemNode.labelDate_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Date")
						itemNode.labelDate_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelDate_:setString(itemRacking.insertTime)

						itemNode.labelSeller = ccui.Helper:seekWidgetByName(itemNode, "Label_Seller")
						itemNode.labelSeller:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelSeller:setString(itemRacking.UserID)

						itemNode.labelState_ = ccui.Helper:seekWidgetByName(itemNode, "Label_State")
						itemNode.labelState_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelState_:setString(STRING_RACKING_STATE[itemRacking.ItemStatus])

						self.dataRackings_[itemRacking.ID] = itemRacking

						self.listRacking_:pushBackCustomItem(itemNode)
					end

					handlerDelayed(function() self.listRacking_:jumpToTop() end)
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

function AuctionScene:onUpRacking()
	if self.currentRacking_ > 1 then
		self.currentRacking_ = self.currentRacking_ - 1
		self:requestRackingList()
	end
end

function AuctionScene:onDownRacking()
	if self.currentRacking_ < self.totalRacking_ then
		self.currentRacking_ = self.currentRacking_ + 1
		self:requestRackingList()
	end
end

function AuctionScene:onAuction()
	-- if not global.g_mainPlayer:isBind3rdPay() then
	-- 	WarnTips.showTips(
	-- 			{
	-- 				text = LocalLanguage:getLanguageString("L_4b8dad4c56f121a9"),
	-- 				style = WarnTips.STYLE_YN,
	-- 				confirm = function()
	-- 						PopUpView.showPopUpView(ui_complete_spreader_t)
	-- 					end
	-- 			}
	-- 		)
	-- 	return
	-- end

	PopUpView.showPopUpView(PutawayView)
end

function AuctionScene:requestBuyList()
	self.listBuy_:removeAllItems()

	LoadingView.showTips()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(BUY_LIST_URL, self.currentBuy_, playerId)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "BuyList",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 100 then
					self.currentBuy_ = luaTbl.data.pageIndex
					self.totalBuy_ = luaTbl.data.pageCount
					self.labelPageBuy_:setString(string.format("%d/%d", self.currentBuy_, self.totalBuy_))

					self.dataBuys_ = {}
					for i = 1, #luaTbl.data.data do
						local itemBuy = luaTbl.data.data[i]
						local itemNode = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_buy_item.json")
						itemNode.itemIcon_ = ccui.Helper:seekWidgetByName(itemNode, "Image_Item")
						itemNode.itemIcon_:loadTexture(string.format("fullmain/res/shop/items/item%d.png", itemBuy.PropID))

						itemNode.labelName_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Name")
						itemNode.labelName_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelName_:setString(itemBuy.PropName)

						itemNode.labelCount_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Count")
						itemNode.labelCount_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelCount_:setString(itemBuy.PropCount)

						itemNode.labelPrice_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Price")
						itemNode.labelPrice_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelPrice_:setString(string.format("%d", itemBuy.AllPrice))

						itemNode.labelDate_ = ccui.Helper:seekWidgetByName(itemNode, "Label_Date")
						itemNode.labelDate_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelDate_:setString(itemBuy.ApplyTime)

						itemNode.labelState_ = ccui.Helper:seekWidgetByName(itemNode, "Label_State")
						itemNode.labelState_:setTextColor(cc.c4b(74, 59, 114, 255))
						itemNode.labelState_:setString(STRING_BUY_STATE[itemBuy.ItemStatus])

						self.dataBuys_[itemBuy.ID] = itemBuy

						self.listBuy_:pushBackCustomItem(itemNode)
					end

					handlerDelayed(function() self.listBuy_:jumpToTop() end)
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

function AuctionScene:onUpBuy()
	if self.currentBuy_ > 1 then
		self.currentBuy_ = self.currentBuy_ - 1
		self:requestBuyList()
	end
end

function AuctionScene:onDownBuy()
	if self.currentBuy_ < self.totalBuy_ then
		self.currentBuy_ = self.currentBuy_ + 1
		self:requestBuyList()
	end
end

function AuctionScene:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		local switchCode = sender:getTag()
		if self.switchCode_ ~= switchCode then
			local oSwitch = self.dataSwitchs_[self.switchCode_]
			oSwitch.box:setSelected(false)
			oSwitch.view:setVisible(false)

			local nSwitch = self.dataSwitchs_[switchCode]
			nSwitch.box:setSelected(true)
			nSwitch.view:setVisible(true)

			self.switchCode_ = switchCode

			self:requestPageData()
		end
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

-- function AuctionScene:onEnterTransitionFinish()
-- 	local scheduleId
-- 	local function onComplete()
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)

-- 		-- self.status_ = STATUS_CODE.CHECK_CODE
-- 		-- self:requestPersonalInfo()
-- 		self.status_ = STATUS_CODE.NORMAL_CODE
-- 		self:requestPageData()
-- 	end
-- 	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onComplete, 0.1, false)
-- end

function AuctionScene:initView()
		-- self.status_ = STATUS_CODE.NORMAL_CODE
		-- self:requestPageData()
	if global.g_mainPlayer:isBind3rdPay() then
		self.status_ = STATUS_CODE.NORMAL_CODE
		self:requestPageData()
	else
		self:checkRackingEmpty()
	end

	local guide = global.g_mainPlayer:getCurrentGuide()
	if guide and guide == GAME_GUIDES.GUIDE_AUCTION_WANT_PUTAWAY then
		self.guideWantFinger_ = GuideFinger.new()
		self.guideWantFinger_:setPosition(cc.p(117, 24))
		self.btnAuctionGuide_:addChild(self.guideWantFinger_)
	end
end

function AuctionScene:checkRackingEmpty()
	LoadingView.showTips()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(RACKING_LIST_URL, self.currentRacking_, playerId)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "RackingEmpty",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.code == 100 and #luaTbl.data.data > 0 then
					self.guideBindFinger_ = GuideFinger.new()
					self.guideBindFinger_:setPosition(cc.p(50, 25))
					self.btnBindMoMo_:addChild(self.guideBindFinger_)
					self.btnBindMoMo_:setVisible(true)
				end

				self.status_ = STATUS_CODE.NORMAL_CODE
				self:requestPageData()
			end,
			onTaskError = function(dataTask, errorCode, errorCodeInternal, errorMsg)
				LoadingView.closeTips()

				self.status_ = STATUS_CODE.NORMAL_CODE
				self:requestPageData()
			end,
		}
	)
end


function AuctionScene:onCloseHandler()
	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function AuctionScene:onRequestUserInfo(i1, i2, i3, i4, i5, i6)
	if self.status_ == STATUS_CODE.CHECK_CODE then
		self.status_ = STATUS_CODE.NORMAL_CODE

		if i1 == "" and i2 == "" and i4 == "" then
			self:onSelectedChange(self.cbPersonalInfo_, ccui.CheckBoxEventType.selected)
		else
			self.inputName_:setText(i1)
			self.inputAccount_:setText(i2)
			self.inputBank_:setText(i3)
			self.inputPhone_:setText(i4)
			self.inputBankName_:setText(i5)
			self.inputMobi_:setText(i6)

			self:requestPageData()
		end
	elseif self.status_ == STATUS_CODE.NORMAL_CODE then
		self.inputName_:setText(i1)
		self.inputAccount_:setText(i2)
		self.inputBank_:setText(i3)
		self.inputPhone_:setText(i4)
		self.inputBankName_:setText(i5)
		self.inputMobi_:setText(i6)
	end
end

function AuctionScene:onModifyUserInfo(i1, i2, i3, i4, i5, i6)
	self.inputName_:setText(i1)
	self.inputAccount_:setText(i2)
	self.inputBank_:setText(i3)
	self.inputPhone_:setText(i4)
	self.inputBankName_:setText(i5)
	self.inputMobi_:setText(i6)
end

function AuctionScene:onPutawaySuccess()
	self:requestRackingList()
end

function AuctionScene:onBuySuccess()
	self:requestAuctionList()
end

function AuctionScene:onCompleteSpreaderSuccess()
	local isBind = global.g_mainPlayer:isBind3rdPay()
	self.btnBindMoMo_:setVisible(not isBind)

	if not isBind then
		self.guideBindFinger_:removeFromParent()
	end
end

function AuctionScene:onCompleteSpreaderPasswordSuccess()
	local isBind = global.g_mainPlayer:isBindMoMo()
	self.btnBindMoMo_:setVisible(not isBind)

	if not isBind then
		self.guideBindFinger_:removeFromParent()
	end
end

function AuctionScene:onEndEnterTransition()
	self:initView()

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self, self.onCompleteSpreaderSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self, self.onCompleteSpreaderPasswordSuccess)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_REQUEST_USER_INFO, self, self.onRequestUserInfo)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MODIFY_USER_INFO, self, self.onModifyUserInfo)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self, self.onPutawaySuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUY_SUCCESS, self, self.onBuySuccess)
end

function AuctionScene:onStartExitTransition()
	MultipleDownloader:removeFileDownload("AuctionList")
	MultipleDownloader:removeFileDownload("RackingList")
	MultipleDownloader:removeFileDownload("BuyList")
	MultipleDownloader:removeFileDownload("RackingEmpty")

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_PASSWORD_SUCCESS, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_REQUEST_USER_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MODIFY_USER_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_PUTAWAY_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUY_SUCCESS, self)
end
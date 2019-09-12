ui_exshop_item_t = class("ui_exshop_item_t")

local exchangeUrl = "http://23.91.108.8:85/WS/InvokeAPI.ashx?action=buy&id=%d&userId=%d&timestamp=%d&sign=%s"

function ui_exshop_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shopItem.json")

	local function onNodeEvent(event)
		if event == "enter" then
			
		elseif event == "exit" then
			MultipleDownloader:removeFileDownload("ExchangeItem")
		end
	end
	self.node_:registerScriptHandler(onNodeEvent)

	self.panelIcon_ = ccui.Helper:seekWidgetByName(self.node_, "Panel_Icon")

	local imageRemote = ui_image_remote_t.new(self.itemData_.ItemImg, cc.size(98, 98))
	self.panelIcon_:addChild(imageRemote)

	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_3")
	labelname:setString(self.itemData_.ItemName)

	local labelBuyPrice1 = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	labelBuyPrice1:setString(string.format("%s", moneyFormat(self.itemData_.ItemPrice)))

	local insure = global.g_mainPlayer:getInsureMoney()
	self.labelCount_ = ccui.Helper:seekWidgetByName(self.node_, "Label_6")
	self.labelCount_:setString(string.format("%d", math.floor(insure/self.itemData_.ItemPrice)))

	local tip = ccui.Helper:seekWidgetByName(self.node_, "Image_10")
	tip:loadTexture("fullmain/res/shop/img_kdhsl.png")

	local btn_operate = ccui.Helper:seekWidgetByName(self.node_, "Button_11")
	btn_operate:loadTextures("fullmain/res/shop/btn_dh.png", "fullmain/res/shop/btn_dh.png", "fullmain/res/shop/btn_dh.png")
	btn_operate:setPressedActionEnabled(true)
	btn_operate:addTouchEventListener(makeClickHandler(self, self.onTouchItem))
end

function ui_exshop_item_t:onConfirm()
	local playerId = global.g_mainPlayer:getPlayerId()
	local nowTime = os.time()
	local sign = string.upper(cc.utils:getDataMD5Hash(string.format("id=%d&userId=%d&timestamp=%d&key=HVQSJSL8MC265SQ3ZVV1S4Q9M9ECNADP", self.itemData_.ID, playerId, nowTime)))
	local url = string.format(exchangeUrl, self.itemData_.ID, playerId, nowTime, sign)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "ExchangeItem",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				local output = json.decode(params)
				WarnTips.showTips(
						{
							text = output.msg,
							style = WarnTips.STYLE_Y
						}
					)

				if output.code == 200 then
					gatesvr.sendInsureInfoQuery(true)
					global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHOP_EXCHANGE_SUCCESS)
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

function ui_exshop_item_t:onTouchItem()
	WarnTips.showTips(
			{
				text = string.format(LocalLanguage:getLanguageString("L_78e160973d439b16"), moneyFormat(self.itemData_.ItemPrice), self.itemData_.ItemName),
				style = WarnTips.STYLE_YN,
				confirm = handler(self, self.onConfirm)
			}
		)
end
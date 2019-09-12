ui_store_item_t = class("ui_store_item_t")

function ui_store_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_store_item.json")

	local function onNodeEvent(event)
		if event == "enter" then
			
		elseif event == "exit" then
			MultipleDownloader:removeFileDownload("CREATE_STORE_ORDER")
		end
	end
	self.node_:registerScriptHandler(onNodeEvent)

	local name = string.gsub(self.itemData_.name, LocalLanguage:getLanguageString("L_96b75f87d065bcfb"), "")
	local labelname = ccui.Helper:seekWidgetByName(self.node_, "Label_3")
	labelname:setString(name)

	local panelSong = ccui.Helper:seekWidgetByName(self.node_, "Image_Song")
	local labelSong = ccui.Helper:seekWidgetByName(panelSong, "Label_Song")
	labelSong:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	
	local count = STORE_ITEMS_SONG[self.itemData_.productId] or 0
	if count > 0 then
		labelSong:setString(string.format("+%d", count))
		panelSong:setVisible(true)
	else
		panelSong:setVisible(false)
	end

	local labelPrice = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	labelPrice:setString(self.itemData_.price)

	local btn_operate = ccui.Helper:seekWidgetByName(self.node_, "Button_11")
	btn_operate:setPressedActionEnabled(true)
	btn_operate:addTouchEventListener(makeClickHandler(self, self.onTouchItem))
end

function ui_store_item_t:onTouchItem()
	LoadingView.showTips()

	local playerId = global.g_mainPlayer:getPlayerId()
	local url = string.format(CREATE_STORE_ORDER, PLATFROM, playerId, self.itemData_.productId, 1)

	MultipleDownloader:createDataDownLoad(
		{
			identifier = "CREATE_STORE_ORDER",
			fileUrl = url,
			onDataTaskSuccess = function(dataTask, params)
				LoadingView.closeTips()

				local luaTbl = json.decode(params)
				if luaTbl.data then
					self:openPay(luaTbl.data)
				else
					WarnTips.showTips(
							{
								text = luaTbl.msg,
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

function ui_store_item_t:openPay(data)
	if cc.PLATFORM_OS_ANDROID == PLATFROM then
		LoadingView.showTips()
		calljavaMethodV("buyStoreItem", {data.ShopId, data.OrderId})
	elseif cc.PLATFORM_OS_IPHONE == PLATFROM or cc.PLATFORM_OS_IPAD == PLATFROM then
		LoadingView.showTips()
		luaoc.callStaticMethod("AppController", "buyStoreItem", {productId = data.ShopId, extra = data.OrderId})
	elseif cc.PLATFORM_OS_WINDOWS == PLATFROM then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_73e00c897e0f97ff"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end
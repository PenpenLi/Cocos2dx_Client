ui_shop_buy_t = class("ui_shop_buy_t", PopUpView)

function ui_shop_buy_t:ctor(itemData)
	ui_shop_buy_t.super.ctor(self, true)

	self.itemData_ = itemData

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_shop_buy.json")
	self.nodeUI_:addChild(root)

	local cfg = shop_config[self.itemData_.index]

	local icon = ccui.Helper:seekWidgetByName(root, "Image_5")
	icon:loadTexture(string.format("fullmain/res/shop/items/item%d.png", self.itemData_.index))

	local labelname = ccui.Helper:seekWidgetByName(root, "Label_6")
	labelname:setString(string.format("%s", cfg.name))

	local labelBuyPrice = ccui.Helper:seekWidgetByName(root, "Label_7")
	labelBuyPrice:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold)))

	local labelRecoveryPrice = ccui.Helper:seekWidgetByName(root, "Label_8")
	labelRecoveryPrice:setString(string.format("%s", moneyFormat(self.itemData_.propertyGold*self.itemData_.discount/100)))

	self.btnConfirm_ = ccui.Helper:seekWidgetByName(root, "Button_3")
	self.btnConfirm_:setPressedActionEnabled(true)
	self.btnConfirm_:addTouchEventListener(makeClickHandler(self, self.onConfirmHandler))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_4")
	btnCancel:setPressedActionEnabled(true)
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancelHandler))

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.inputUserId_ = createCursorTextField(root, "TextField_User", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputUserId_:setFontColor(cc.c3b(0, 0, 0))

	local score = global.g_mainPlayer:getPlayerScore()
	self.inputCount_ = createCursorTextField(root, "TextField_Count", cc.EDITBOX_INPUT_MODE_NUMERIC)
	self.inputCount_:setPlaceHolder(string.format(LocalLanguage:getLanguageString("L_377b08dd2706f6dd"), math.floor(score/self.itemData_.propertyGold)))
	self.inputCount_:setFontColor(cc.c3b(0, 0, 0))

	self.inputPassword_ = createCursorTextField(root, "TextField_Password")
	self.inputPassword_:setVisible(false)
	self.inputPassword_:setFontColor(cc.c3b(0, 0, 0))
end

function ui_shop_buy_t:onPopUpComplete()
	local guide = global.g_mainPlayer:getCurrentGuide()
	if guide and guide == GAME_GUIDES.GUIDE_SHOP_BUY then
		self.guideFinger_ = GuideFinger.new()

		self.guideFinger_:setPosition(cc.p(130, 24))
		self.btnConfirm_:addChild(self.guideFinger_)

		local score = global.g_mainPlayer:getPlayerScore()
		local strUserId = tostring(global.g_mainPlayer:getGameId())
		local strCount = math.max(1, math.floor(score/self.itemData_.propertyGold))
		self.inputUserId_:setText(strUserId)
		self.inputCount_:setText(strCount)
	end

	if self.itemData_.index == 1 then
		self.inputCount_:setText(1)
		self.inputCount_:setEnabled(false)
	end
end

function ui_shop_buy_t:onConfirmHandler()
	local strUserId = string.trim(self.inputUserId_:getText())
	local strCount = string.trim(self.inputCount_:getText())
	len = utf8.len(strCount)
	if len < 1 then
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_93a13989bac825d5"),
					style = WarnTips.STYLE_Y
				}
			)
		return
	end

	local password = ""--string.trim(self.inputPassword_:getText())
	-- len = utf8.len(password)
	-- if len < 1 then
	-- 	WarnTips.showTips(
	-- 			{
	-- 				text = LocalLanguage:getLanguageString("L_d0fd6ce55c8329a3"),
	-- 				style = WarnTips.STYLE_Y
	-- 			}
	-- 		)
	-- 	return
	-- end

	local userId = utf8.len(strUserId) > 0 and tonumber(strUserId) or global.g_mainPlayer:getGameId()
	local count = tonumber(strCount)

	local needMoney = count * self.itemData_.propertyGold
	if needMoney > global.g_mainPlayer:getPlayerScore() then
		-- if PLATFROM == cc.PLATFORM_OS_WINDOWS then
		-- 	WarnTips.showTips(
		-- 	{
		-- 		text=LocalLanguage:getLanguageString("L_02146f169f4ec808"),
		-- 		style=WarnTips.STYLE_Y
		-- 	})
		-- else
		-- 	-- PopUpView.showPopUpView(ui_recharge_t)
		-- 	replaceScene(RechargeScene, TRANS_CONST.TRANS_SCALE)
		-- end
		-- -- PopUpView.showPopUpView(ui_recharge_t)
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_02146f169f4ec808"),
					style = WarnTips.STYLE_Y,
					confirm = function()
							self:close()
							
							replaceScene(RechargeScene, TRANS_CONST.TRANS_SCALE)
						end
				}
			)
	else
		-- if not global.g_mainPlayer:isBindMoMo() then
		-- 	WarnTips.showTips(
		-- 			{
		-- 				text = LocalLanguage:getLanguageString("L_4b8dad4c56f121a9"),
		-- 				style = WarnTips.STYLE_YN,
		-- 				confirm = function()
		-- 						global.g_gameDispatcher:sendMessage(GAME_MESSAGE_COMPLETE_MOMO)
								
		-- 						self:close()
		-- 					end
		-- 			}
		-- 		)
		-- 	return
		-- end
		
		gatesvr.buyPropertyItem(self.itemData_.index, count, userId, password)
	end
end

function ui_shop_buy_t:onCancelHandler()
	self:close()
end

function ui_shop_buy_t:onCloseHandler()
	self:close()
end

function ui_shop_buy_t:onBuySuccessHandler()
	self:close()
end

function ui_shop_buy_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self, self.onBuySuccessHandler)
end

function ui_shop_buy_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHOP_BUY_SUCCESS, self)
end
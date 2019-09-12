PersonalScene = class("PersonalScene", LayerBase)

local MEDAL_POSITIONS = {
	[1] = {{0, 0}},
	[2] = {{-65, 0}, {65, 0}},
	[3] = {{-125, 0}, {0, 0}, {125, 0}}
}

function PersonalScene:ctor()
	PersonalScene.super.ctor(self)

	local pathJson = getLayoutJson("fullmain/res/json/ui_main_personal.json")
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(pathJson)
	root:setClippingEnabled(true)
	self:addChild(root)

	local playerId = global.g_mainPlayer:getPlayerId()
	local playerLevel = global.g_mainPlayer:getPlayerLevel()
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local nodeHead = HeadLargeView.new(playerId, playerLevel)
	panelHead:addChild(nodeHead)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	local btnSetting = ccui.Helper:seekWidgetByName(root, "Button_Setting")
	btnSetting:setPressedActionEnabled(true)
	btnSetting:addTouchEventListener(makeClickHandler(self, self.onSetting))

	local labelId = ccui.Helper:seekWidgetByName(root, "Label_Id")
	labelId:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelId:setString(global.g_mainPlayer:getGameId())

	local momo = global.g_mainPlayer:getViMomo()
	self.labelViMoMo_ = ccui.Helper:seekWidgetByName(root, "Label_ViMoMo")
	self.labelViMoMo_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelViMoMo_:setString(momo)

	local spreaderId = global.g_mainPlayer:getSpreaderId()
	self.labelSpreader_ = ccui.Helper:seekWidgetByName(root, "Label_Spreader")
	self.labelSpreader_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelSpreader_:setString(spreaderId)

	local zalopay = global.g_mainPlayer:getZaloPay()
	self.labelZaloPay_ = ccui.Helper:seekWidgetByName(root, "Label_ZaloPay")
	self.labelZaloPay_:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	self.labelZaloPay_:setString(zalopay)

	local playerVipLevel = global.g_mainPlayer:getPlayerVipLevel()
	local vipName = VIP_LEVEL_NAMES[playerVipLevel] or VIP_LEVEL_NAMES[0]
	local labelVip = ccui.Helper:seekWidgetByName(root, "Label_Vip")
	labelVip:enableOutline(cc.c4b(131, 62, 0, 255), 1)
	labelVip:setString(vipName)

	local nodeMedals = {}
	for i = 1, 3 do
			local nodeMedal = ccui.Helper:seekWidgetByName(root, "Image_Medal_" .. i)
			nodeMedal:setVisible(false)
			nodeMedals[i] = nodeMedal
	end

	local medals = global.g_mainPlayer:getPlayerMedals()

	local count = #medals
	local positions = MEDAL_POSITIONS[count]
	for i = 1, count do
		local medal = medals[i]
		local p = positions[i]
		local nodeMedal = nodeMedals[i]
		nodeMedal:setVisible(true)
		nodeMedal:setPosition(cc.p(p[1], p[2]))
		nodeMedal:loadTexture(string.format("fullmain/res/medals/%d.png", medal))
	end

	self.btnCompleteSpreader_ = ccui.Helper:seekWidgetByName(root, "Button_Complete")
	self.btnCompleteSpreader_:setPressedActionEnabled(true)
	self.btnCompleteSpreader_:addTouchEventListener(makeClickHandler(self, self.onCompleteSpreader))

	local isBindSpreader = global.g_mainPlayer:isBindSpreader()
	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()
	local complete = isBindSpreader and isBindMoMo and isBindZaloPay

	self.btnCompleteSpreader_:setEnabled(not complete)
	self.btnCompleteSpreader_:setBright(not complete)
end

function PersonalScene:onCompleteSpreader()
	PopUpView.showPopUpView(ui_complete_spreader_t)
end

function PersonalScene:onSetting()
	PopUpView.showPopUpView(ui_setting_t)
end

function PersonalScene:onClose()
	-- local layer = createObj(hall_scene_t)
	-- replaceScene(layer:getCCScene(),layer)
	replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
end

function PersonalScene:onCompleteSpreaderSuccess()
	local momo = global.g_mainPlayer:getViMomo()
	self.labelViMoMo_:setString(momo)

	local spreader = global.g_mainPlayer:getSpreaderId()
	self.labelSpreader_:setString(spreader)

	local zalopay = global.g_mainPlayer:getZaloPay()
	self.labelZaloPay_:setString(zalopay)

	local isBindSpreader = global.g_mainPlayer:isBindSpreader()
	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()
	local complete = isBindSpreader and (isBindMoMo or isBindZaloPay)

	self.btnCompleteSpreader_:setEnabled(not complete)
	self.btnCompleteSpreader_:setBright(not complete)
end

function PersonalScene:onRequestDataBindSuccess()
	local momo = global.g_mainPlayer:getViMomo()
	self.labelViMoMo_:setString(momo)

	local spreader = global.g_mainPlayer:getSpreaderId()
	self.labelSpreader_:setString(spreader)

	local zalopay = global.g_mainPlayer:getZaloPay()
	self.labelZaloPay_:setString(zalopay)

	local isBindSpreader = global.g_mainPlayer:isBindSpreader()
	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()
	local complete = isBindSpreader and (isBindMoMo or isBindZaloPay)

	self.btnCompleteSpreader_:setEnabled(not complete)
	self.btnCompleteSpreader_:setBright(not complete)
end

function PersonalScene:onModifyDataBindSuccess()
	local momo = global.g_mainPlayer:getViMomo()
	self.labelViMoMo_:setString(momo)

	local spreader = global.g_mainPlayer:getSpreaderId()
	self.labelSpreader_:setString(spreader)

	local zalopay = global.g_mainPlayer:getZaloPay()
	self.labelZaloPay_:setString(zalopay)

	local isBindSpreader = global.g_mainPlayer:isBindSpreader()
	local isBindMoMo = global.g_mainPlayer:isBindMoMo()
	local isBindZaloPay = global.g_mainPlayer:isBindZaloPay()
	local complete = isBindSpreader and (isBindMoMo or isBindZaloPay)

	self.btnCompleteSpreader_:setEnabled(not complete)
	self.btnCompleteSpreader_:setBright(not complete)
end

function PersonalScene:onEndEnterTransition()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self, self.onCompleteSpreaderSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self, self.onRequestDataBindSuccess)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self, self.onModifyDataBindSuccess)
end

function PersonalScene:onStartExitTransition()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_COMPLETE_SPREADER_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_DATA_BIND_SUCCESS, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MODIFY_DATA_BIND_SUCCESS, self)
end
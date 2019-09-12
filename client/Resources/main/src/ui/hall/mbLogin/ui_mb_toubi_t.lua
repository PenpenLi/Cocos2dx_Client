ui_mb_toubi_t = class("ui_mb_toubi_t", PopUpView)

local closeTick = nil

local TOUBI_RATE = 1

local TOUBI_COUNTS = {
	[1] = 1,
	[2] = 2,
	[3] = 5,
	[4] = 10,
	[5] = 20,
	[6] = 50,
}

function ui_mb_toubi_t:ctor()
	ui_mb_toubi_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_toubi.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	local btnConfirm = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnConfirm:addTouchEventListener(makeClickHandler(self, self.onConfirm))

	local btnAdd = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnAdd:addTouchEventListener(makeClickHandler(self, self.onAdd))

	local btnSub = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnSub:addTouchEventListener(makeClickHandler(self, self.onSub))

	local deviceData = global.g_mainPlayer:getDeviceLoginData()
	self.labelRemain_ = ccui.Helper:seekWidgetByName(root, "Label_8")
	self.labelRemain_:setTextColor(cc.c4b(255, 255, 0, 255))
	self.labelRemain_:setString(string.format(LocalLanguage:getLanguageString("L_1ec61febbe08d446"), deviceData.score))

	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "Label_5")
	self.labelScore_:setTextColor(cc.c4b(255, 255, 0, 255))

	self.cbCoins_ = {}
	for i = 1, 6 do
		local base = TOUBI_COUNTS[i]
		local overSkin = string.format("main/res/score/%d/%d_0.png", TOUBI_RATE, base)
		local selectedSkin = string.format("main/res/score/%d/%d_1.png", TOUBI_RATE, base)
		local checkbox = ccui.Helper:seekWidgetByName(root, "CheckBox_" .. i)
		checkbox:loadTextures(overSkin, selectedSkin, selectedSkin, overSkin, overSkin)
		checkbox:setTag(base)
		self.cbCoins_[i] = checkbox

		checkbox:addEventListener(handler(self, self.onSelectedChange))
	end

	self:defaultView()
end

function ui_mb_toubi_t:defaultView()
	self.selected_ = TOUBI_COUNTS[2]
	self.currentScore_ = 0
	self:refreshSelected()
end

function ui_mb_toubi_t:onPopUpComplete()
	gatesvr.sendCoinMBInfo()
end

-- function ui_mb_toubi_t:startAutoClose()
-- 	closeTick = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
-- 			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(closeTick)
-- 			self:close()
-- 		end, 60, false)
-- end

-- function ui_mb_toubi_t:stopAutoClose()
-- 	if closeTick then
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(closeTick)
-- 		closeTick = nil
-- 	end
-- end

function ui_mb_toubi_t:refreshSelected()
	for i = 1, #self.cbCoins_ do
		local checkbox = self.cbCoins_[i]
		local tag = checkbox:getTag()
		checkbox:setSelected(tag == self.selected_)
	end
end

function ui_mb_toubi_t:refreshToubi()
	self.labelScore_:setString(self.currentScore_)
end

function ui_mb_toubi_t:onSelectedChange(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		self.selected_ = sender:getTag()
		self:refreshSelected()
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end

	local deviceData = global.g_mainPlayer:getDeviceLoginData()
	self.currentScore_ = math.min(deviceData.score, self.currentScore_ + self.selected_ * TOUBI_RATE)
	self:refreshToubi()
end

function ui_mb_toubi_t:onAdd()
	local deviceData = global.g_mainPlayer:getDeviceLoginData()
	self.currentScore_ = math.min(deviceData.score, self.currentScore_ + self.selected_ * TOUBI_RATE)
	self:refreshToubi()
end

function ui_mb_toubi_t:onSub()
	self.currentScore_ = math.max(0, self.currentScore_ - self.selected_ * TOUBI_RATE)
	self:refreshToubi()
end

function ui_mb_toubi_t:onConfirm()
	if self.currentScore_ > 0 then
		gatesvr.sendCoinMBUpScore(self.currentScore_)
	end
end

function ui_mb_toubi_t:onClose()
	self:close()
end

function ui_mb_toubi_t:refreshScore()
	local deviceData = global.g_mainPlayer:getDeviceLoginData()
	self.labelRemain_:setString(string.format(LocalLanguage:getLanguageString("L_1ec61febbe08d446"), deviceData.score))
end

-- function ui_mb_toubi_t:addHeartbeatHandler()
-- 	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = {
-- 			[pt_gate.SUB_KN_DETECT_SOCKET] = gatesvr.onHeartbeat
-- 		}
-- end

-- function ui_mb_toubi_t:removeHeartbeatHandler()
-- 	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = nil
-- end

function ui_mb_toubi_t:onDeviceInfo()
	self:refreshScore()
end

function ui_mb_toubi_t:onDeviceUpScore(result)
	self.currentScore_ = 0
	self:refreshToubi()
	
	self:refreshScore()
	--self:close()
	
	--global.g_mainPlayer:cleanDeviceLogin()
	gatesvr.sendInsureInfoQuery(true)

	if result == 0 then
		self:close()
	end
end

function ui_mb_toubi_t:onDeviceDownScore()
	self:close()

	gatesvr.sendInsureInfoQuery(true)
end

function ui_mb_toubi_t:onDeviceLost()
	self:close()

	gatesvr.sendInsureInfoQuery(true)
end

function ui_mb_toubi_t:initMsgHandler()
	-- self:startAutoClose()
	-- self:addHeartbeatHandler()

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_INFO, self, self.onDeviceInfo)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_UPSCORE, self, self.onDeviceUpScore)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_DOWNSCORE, self, self.onDeviceDownScore)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_LOST, self, self.onDeviceLost)
end

function ui_mb_toubi_t:removeMsgHandler()
	-- self:stopAutoClose()
	-- self:removeHeartbeatHandler()
	-- global.g_mainPlayer:cleanDeviceLogin()
	
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_UPSCORE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_DOWNSCORE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_LOST, self)
end
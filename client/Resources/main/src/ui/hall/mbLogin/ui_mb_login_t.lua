ui_mb_login_t = class("ui_mb_login_t", SwallowView)

function ui_mb_login_t:ctor()
	ui_mb_login_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_mblogin.json")
	self:addChild(root)

	local btnToubi = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnToubi:addTouchEventListener(makeClickHandler(self, self.onToubiHandler))

	local btnXF = ccui.Helper:seekWidgetByName(root, "Button_9")
	btnXF:addTouchEventListener(makeClickHandler(self, self.onXiaFenHandler))

	local btnRefresh = ccui.Helper:seekWidgetByName(root, "Button_15")
	btnRefresh:addTouchEventListener(makeClickHandler(self, self.onRefreshHandler))

	local labelLocate = ccui.Helper:seekWidgetByName(root, "Label_10")
	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "Label_11")
	self.labelSF_ = ccui.Helper:seekWidgetByName(root, "Label_12")

	self:refreshScore()
end

function ui_mb_login_t:refreshScore()
	local deviceData = global.g_mainPlayer:getDeviceLoginData()
	self.labelScore_:setString(deviceData.score)
	self.labelSF_:setString(deviceData.devScore)
end

function ui_mb_login_t:onToubiHandler()
	PopUpView.showPopUpView(ui_mb_toubi_t)
end

function ui_mb_login_t:onRefreshHandler()
	gatesvr.sendCoinMBInfo()
end

function ui_mb_login_t:onXiaFenHandler()
	WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_2e3ac28718413542"),
				style = WarnTips.STYLE_YN,
				confirm = function()
						LoadingView.showTips()

						gatesvr.sendCoinMBDownScore()
					end
			}
		)
end

function ui_mb_login_t:addHeartbeatHandler()
	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = {
			[pt_gate.SUB_KN_DETECT_SOCKET] = gatesvr.onHeartbeat
		}
end

function ui_mb_login_t:removeHeartbeatHandler()
	gatesvr.gtNetHandler[pt_gate.MDM_KN_COMMAND] = nil
end

function ui_mb_login_t:onDeviceInfo()
	self:refreshScore()
end

function ui_mb_login_t:onDeviceUpScore()
	self:refreshScore()
end

function ui_mb_login_t:onDeviceDownScore()
	self:close()

	gatesvr.sendInsureInfoQuery(true)
end

function ui_mb_login_t:onDeviceLost()
	self:close()

	gatesvr.sendInsureInfoQuery(true)
end

function ui_mb_login_t:initMsgHandler()
	self:addHeartbeatHandler()

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_INFO, self, self.onDeviceInfo)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_UPSCORE, self, self.onDeviceUpScore)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_DOWNSCORE, self, self.onDeviceDownScore)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_DEVICE_LOST, self, self.onDeviceLost)
end

function ui_mb_login_t:removeMsgHandler()
	self:removeHeartbeatHandler()
	
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_INFO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_UPSCORE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_DOWNSCORE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_DEVICE_LOST, self)
end
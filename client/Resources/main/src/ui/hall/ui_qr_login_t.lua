ui_qr_login_t = class("ui_qr_login_t", SwallowView)

function ui_qr_login_t:ctor(gameType, serverId, serverName, tableId, chairId)
	ui_qr_login_t.super.ctor(self, true)

	self.gameType_ = gameType
	self.serverId_ = serverId
	self.serverName_ = serverName
	self.tableId_ = tableId
	self.chairId_ = chairId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_qrlogin.json")
	self:addChild(root)

	local labelServer = ccui.Helper:seekWidgetByName(root, "Label_6")
	labelServer:setString(self.serverName_)

	self.labelScore_ = ccui.Helper:seekWidgetByName(root, "Label_7")
	self.labelScore_:setString("")

	local infoBg = ccui.Helper:seekWidgetByName(root, "Image_2")
	if self.gameType_ == APP_GAME_TYPE_GATHER then
		infoBg:loadTexture("main/res/qrLogin/box_info.png")
		self.labelScore_:setVisible(false)
	elseif self.gameType_ == APP_GAME_TYPE_ARCADE then
		infoBg:loadTexture("main/res/qrLogin/machine_info.png")
		self.labelScore_:setVisible(true)
	end

	self.labelCoin_ = ccui.Helper:seekWidgetByName(root, "Label_8")
	self.labelCoin_:setString("")
	self.labelCoin_:setVisible(false)

	local btnBack = ccui.Helper:seekWidgetByName(root, "Button_3")
	btnBack:addTouchEventListener(makeClickHandler(self, self.onBackHandler))

	self:startAutoClose()
end

function ui_qr_login_t:startAutoClose()
	local action = cc.Sequence:create(
			{
				cc.DelayTime:create(3),
				cc.CallFunc:create(handler(self, self.close))
			}
		)
	self:runAction(action)
end

function ui_qr_login_t:onBackHandler()
	-- WarnTips.showTips(
	-- 		{
	-- 			text = "是否退出房间?",
	-- 			style = WarnTips.STYLE_YN,
	-- 			confirm = function()
	-- 					if self.gameType_ == APP_GAME_TYPE_GATHER then
	-- 						gatesvr.sendAppStandUp()
	-- 					elseif self.gameType_ == APP_GAME_TYPE_ARCADE then
	-- 						gamesvr.sendAppUserStandUp(self.serverId_, self.tableId_, self.chairId_)
	-- 					end
	-- 					gatesvr.sendInsureInfoQuery(true)
	-- 					self:close()
	-- 				end
	-- 		}
	-- 	)
	gatesvr.sendInsureInfoQuery(true)
	
	self:close()
end

function ui_qr_login_t:onAppInfoUpdate(param)
	self.labelScore_:setString(param.score)
	self.labelCoin_:setString(param.coin - param.coinExchangeNum)
end

function ui_qr_login_t:onAppServerKickOut()
	self:close()
end

function ui_qr_login_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APP_INFO_UPDATE, self, self.onAppInfoUpdate)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_APP_SERVER_KICKOUT, self, self.onAppServerKickOut)
end

function ui_qr_login_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APP_INFO_UPDATE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_APP_SERVER_KICKOUT, self)
end
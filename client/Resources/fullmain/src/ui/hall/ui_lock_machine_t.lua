ui_lock_machine_t = class("ui_lock_machine_t", PopUpView)

function ui_lock_machine_t:ctor()
	ui_lock_machine_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_lock_machine.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_11")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	local btnCancel = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnCancel:addTouchEventListener(makeClickHandler(self, self.onCancelHandler))

	self.btnLock_ = ccui.Helper:seekWidgetByName(root, "Button_5")
	self.btnLock_:addTouchEventListener(makeClickHandler(self, self.onLockHandler))

	self.btnUnlock_ = ccui.Helper:seekWidgetByName(root, "Button_10")
	self.btnUnlock_:addTouchEventListener(makeClickHandler(self, self.onUnlockHandler))

	self.inputPassword_ = ccui.EditBox:create(cc.size(294, 40), ccui.Scale9Sprite:create("main/res/common/alpha_4x4.png"))
	self.inputPassword_:setPlaceHolder(LocalLanguage:getLanguageString("L_9502edeb00ae8832"))
	self.inputPassword_:setInputFlag(cc.EDITBOX_INPUT_FLAG_PASSWORD)
	self.inputPassword_:setPosition(cc.p(-60, 39))
	self.inputPassword_:setAnchorPoint(cc.p(0, 0.5))
	root:addChild(self.inputPassword_)

	self:refreshView()
end

function ui_lock_machine_t:refreshView()
	local lock = global.g_mainPlayer:isMachineLock()
	self.btnLock_:setVisible(not lock)
	self.btnUnlock_:setVisible(lock)
end

function ui_lock_machine_t:onLockHandler()
	local password = string.trim(self.inputPassword_:getText())
	len = utf8.len(password)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_9502edeb00ae8832"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	gatesvr.sendBindingMachine(1, password)
end

function ui_lock_machine_t:onUnlockHandler()
	local password = string.trim(self.inputPassword_:getText())
	len = utf8.len(password)
	if len < 1 then
		WarnTips.showTips(
			{
				text = LocalLanguage:getLanguageString("L_9502edeb00ae8832"),
				style = WarnTips.STYLE_Y
			}
		)
		return
	end

	gatesvr.sendBindingMachine(0, password)
end

function ui_lock_machine_t:onCancelHandler()
	self:close()
end

function ui_lock_machine_t:onCloseHandler()
	self:close()
end

function ui_lock_machine_t:onLockMachineSuccess()
	-- self:refreshView()

	self:close()
end

function ui_lock_machine_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_LOCK_MACHINE_SUCCESS, self, self.onLockMachineSuccess)
end

function ui_lock_machine_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_LOCK_MACHINE_SUCCESS, self)
end
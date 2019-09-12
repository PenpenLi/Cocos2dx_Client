ExitView = class("ExitView", PopUpView)

function ExitView:ctor()
	ExitView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(JSON_EXIT_ROOT[HORV])
	self.nodeUI_:addChild(root)

	local confirmBtn = ccui.Helper:seekWidgetByName(root, "confirmBtn")
	confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmBtnClick))

	local backBtn = ccui.Helper:seekWidgetByName(root, "backBtn")
	backBtn:addTouchEventListener(handler(self, self.onBackBtnClick))
end

function ExitView:onConfirmBtnClick()
	print('ExitView:onConfirmBtnClick')
    global.g_gameDispatcher:sendMessage(GAME_WCB_GAME_EXIT) 
    self:close()
end

function ExitView:onBackBtnClick()
	print('ExitView:onBackBtnClick')
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_START_COUNTTIME)  -- 开始计时
	self:close()
end
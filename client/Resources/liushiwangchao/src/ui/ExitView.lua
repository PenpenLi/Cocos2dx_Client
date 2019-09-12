ExitView = class("ExitView", PopUpView)

function ExitView:ctor()
	ExitView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("liushiwangchao/res/json/SWExit.json")
	root:setAnchorPoint(0.5, 0.5)
	self.nodeUI_:addChild(root)

	local confirmBtn = ccui.Helper:seekWidgetByName(root, "confirmBtn")
	confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmBtnClick))

	local backBtn = ccui.Helper:seekWidgetByName(root, "backBtn")
	backBtn:addTouchEventListener(handler(self, self.onBackBtnClick))
end

function ExitView:onConfirmBtnClick()
	print('ExitView:onConfirmBtnClick')
    self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
	exit_liushiwangchao()
end


function ExitView:onBackBtnClick()
	print('ExitView:onBackBtnClick')
     self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
	--self:close()
end
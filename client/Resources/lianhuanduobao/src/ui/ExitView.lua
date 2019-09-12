ExitView = class("ExitView", PopUpView)

function ExitView:ctor()
	ExitView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/exitpanel.json")
	self.nodeUI_:addChild(root)

	local confirmBtn = ccui.Helper:seekWidgetByName(root, "confirmBtn")
	confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmBtnClick))

	local backBtn = ccui.Helper:seekWidgetByName(root, "backBtn")
	backBtn:addTouchEventListener(handler(self, self.onBackBtnClick))
end

function ExitView:onConfirmBtnClick()
	print('ExitView:onConfirmBtnClick')

	local buff = sendBuff:new()
	buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_EXIT)
	buff:writeChar(0)
	netmng.sendGsData(buff)

	self:close()
end


function ExitView:onBackBtnClick()
	print('ExitView:onBackBtnClick')
	self:close()
end
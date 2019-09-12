HelpView = class("HelpView", PopUpView)

function HelpView:ctor()
	HelpView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/helppanel.json")
	self.nodeUI_:addChild(root)

	-- local confirmBtn = ccui.Helper:seekWidgetByName(root, "confirmBtn")
	-- confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmBtnClick))
	-- local bg = ccui.Helper:seekWidgetByName(root, "bg")
	-- bg:addTouchEventListener(makeClickHandler(self, self.onTouch))


	 root:addTouchEventListener(function(sender, eventType)

       print("CCSSample2Scenescroll")
       self:close()
    end)
end


function HelpView:onTouch()
	self:close()
end
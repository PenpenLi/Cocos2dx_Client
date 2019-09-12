--
-- Author: Yang
-- Date: 2016-11-07 18:05:29
--
HelpView = class("HelpView",PopUpView)

function HelpView:ctor()
	HelpView.super.ctor(self, true)

	self.help_root   = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_help.json")
	self.help_view   = ccui.Helper:seekWidgetByName(self.help_root,"help_view")
	self.help_close  = ccui.Helper:seekWidgetByName(self.help_root,"help_close")
	self.nodeUI_:addChild(self.help_root)

	self.help_close:addTouchEventListener(makeClickHandler(self,self.onClose))

	local img_bg = cc.Sprite:create("bairenniuniu/res/score/help_text.png")
	img_bg:setAnchorPoint(cc.p(0,0))
	img_bg:setPosition(cc.p(10,0))
	self.help_view:addChild(img_bg)
end
function HelpView:onClose()
	self:close()
end
ui_help = class("ui_help", PopUpView)

function ui_help:ctor()
	ui_help.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("shuiguoshijie/res/json/ui_help.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_Close")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))
end

function ui_help:onClose()
	global.g_mainPlayer:setEffectVolume(self.effectVolume_)
	global.g_mainPlayer:setMusicVolume(self.musicVolume_)
	
	self:close()
end
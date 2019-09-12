LoadingView = class("LoadingView", PopUpView)

local _instance = nil

function LoadingView.showTips(options)
	if _instance then
		return
	end
	global.g_loading_ = true
	_instance = PopUpView.showPopUpView(LoadingView, options)
end

function LoadingView.closeTips()
	if _instance then
		_instance:close()
		global.g_loading_ = nil
		_instance = nil
	end
end

function LoadingView:ctor(options)
	LoadingView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_loading.json")
	self.nodeUI_:addChild(root)

	local content = LocalLanguage:getLanguageString("L_0ef3cc99a0ff7fee")
	if type(options) == "string" then
		content = options
	elseif type(options) == "table" then
		content = options.text or ""
	end

	local labelContent = ccui.Helper:seekWidgetByName(root, "Label_2")
	labelContent:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelContent:setString(content)

	local iconLoad = ccui.Helper:seekWidgetByName(root, "Image_1")
	iconLoad:setScale(0.6)
	local action = cc.RepeatForever:create(cc.RotateBy:create(5, 359))
	iconLoad:runAction(action)
end

function LoadingView:onExit()
	_instance = nil
end

function LoadingView:close()
	self:removeFromParent()
end
SettingView = class("SettingView", PopUpView)

local volumeMusic = nil
local volumeEffect = nil

function SettingView:ctor()
	SettingView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("liushiwangchao/res/json/SWSetting.json")
	root:setAnchorPoint(0.5, 0.5)
	self.nodeUI_:addChild(root)

	local confirmBtn = ccui.Helper:seekWidgetByName(root, "Button_confirm")
	confirmBtn:addTouchEventListener(makeClickHandler(self, self.onConfirmBtnClick))

	local bOpen=false
	self.check1 = ccui.Helper:seekWidgetByName(root, "CheckBox1")
	self.check1:addTouchEventListener(makeClickHandler(self, self.onCheck1))
	bOpen = global.g_mainPlayer:getLocalData("CheckBox1", false)
	self.check1:setSelected(bOpen)

	self.check2 = ccui.Helper:seekWidgetByName(root, "CheckBox2")
	self.check2:addTouchEventListener(makeClickHandler(self, self.onCheck2))
	bOpen = global.g_mainPlayer:getLocalData("CheckBox2", false)
	self.check2:setSelected(bOpen)

	self.check3 = ccui.Helper:seekWidgetByName(root, "CheckBox3")
	self.check3:addTouchEventListener(makeClickHandler(self, self.onCheck3))
	bOpen = global.g_mainPlayer:getLocalData("CheckBox3", false)
	self.check3:setSelected(bOpen)

	self.check4 = ccui.Helper:seekWidgetByName(root, "CheckBox4")
	self.check4:addTouchEventListener(makeClickHandler(self, self.onCheck4))
	bOpen = global.g_mainPlayer:getLocalData("CheckBox4", false)
	self.check4:setSelected(bOpen)

	self.check5 = ccui.Helper:seekWidgetByName(root, "CheckBox5")
	self.check5:addTouchEventListener(makeClickHandler(self, self.onCheck5))
	bOpen = global.g_mainPlayer:getLocalData("CheckBox5", false)
	self.check5:setSelected(bOpen)

	if not volumeMusic then
		volumeMusic = global.g_mainPlayer:getMusicVolume()
		volumeEffect = global.g_mainPlayer:getEffectVolume()
	end
end


function SettingView:onConfirmBtnClick()
	print('SettingView:onConfirmBtnClick')
	local bOpen = self.check1:isSelected()
	global.g_mainPlayer:setLocalData("CheckBox1", bOpen)
	bOpen = self.check2:isSelected()
	global.g_mainPlayer:setLocalData("CheckBox2", bOpen)
	bOpen = self.check3:isSelected()
	global.g_mainPlayer:setLocalData("CheckBox3", bOpen)
	bOpen = self.check4:isSelected()
	global.g_mainPlayer:setLocalData("CheckBox4", bOpen)
	bOpen = self.check5:isSelected()
	global.g_mainPlayer:setLocalData("CheckBox5", bOpen)
	self:close()
end

function SettingView:onCheck1()
	print('SettingView:onCheck1')
	local bOpen = self.check1:isSelected()
	AudioEngine.setMusicVolume(bOpen and volumeMusic or 0)
end

function SettingView:onCheck2()
	print('SettingView:onCheck2')
	local bOpen = self.check2:isSelected()
	AudioEngine.setEffectsVolume(bOpen and volumeEffect or 0)
end

function SettingView:onCheck3()
	print('SettingView:onCheck3')
end

function SettingView:onCheck4()
	print('SettingView:onCheck4')
end

function SettingView:onCheck5()
	print('SettingView:onCheck5')
end


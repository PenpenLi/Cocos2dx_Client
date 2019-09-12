ui_setting_t = class("ui_setting_t", PopUpView)

function ui_setting_t:ctor()
	ui_setting_t.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_setting.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	self.sliderEffect_ = ccui.Helper:seekWidgetByName(root, "Slider_3")
	self.sliderEffect_:addEventListener(handler(self, self.onEffectVolume))

	self.sliderSound_ = ccui.Helper:seekWidgetByName(root, "Slider_4")
	self.sliderSound_:addEventListener(handler(self, self.onSoundVolume))

	local volumeMusic = global.g_mainPlayer:getMusicVolume()
	self.sliderSound_:setPercent(volumeMusic * 100)
	self.musicVolume_ = volumeMusic

	local volumeEffect = global.g_mainPlayer:getEffectVolume()
	self.sliderEffect_:setPercent(volumeEffect * 100)
	self.effectVolume_ = volumeEffect

	local btnEffectSub = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnEffectSub:setPressedActionEnabled(true)
	btnEffectSub:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeSub))

	local btnEffectAdd = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnEffectAdd:setPressedActionEnabled(true)
	btnEffectAdd:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeAdd))

	local btnMusicSub = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnMusicSub:setPressedActionEnabled(true)
	btnMusicSub:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeSub))

	local btnMusicAdd = ccui.Helper:seekWidgetByName(root, "Button_9")
	btnMusicAdd:setPressedActionEnabled(true)
	btnMusicAdd:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeAdd))
end

function ui_setting_t:onEffectVolumeSub()
	self.effectVolume_ = math.max(0, self.effectVolume_ - 0.1)
	self.sliderEffect_:setPercent(self.effectVolume_ * 100)
	AudioEngine.setEffectsVolume(self.effectVolume_)
end

function ui_setting_t:onEffectVolumeAdd()
	self.effectVolume_ = math.min(1, self.effectVolume_ + 0.1)
	self.sliderEffect_:setPercent(self.effectVolume_ * 100)
	AudioEngine.setEffectsVolume(self.effectVolume_)
end

function ui_setting_t:onMusicVolumeSub()
	self.musicVolume_ = math.max(0, self.musicVolume_ - 0.1)
	self.sliderSound_:setPercent(self.musicVolume_ * 100)
	AudioEngine.setMusicVolume(self.musicVolume_)
end

function ui_setting_t:onMusicVolumeAdd()
	self.musicVolume_ = math.min(1, self.musicVolume_ + 0.1)
	self.sliderSound_:setPercent(self.musicVolume_ * 100)
	AudioEngine.setMusicVolume(self.musicVolume_)
end

function ui_setting_t:onEffectVolume()
	self.effectVolume_ = self.sliderEffect_:getPercent() / 100
	AudioEngine.setEffectsVolume(self.effectVolume_)
end

function ui_setting_t:onSoundVolume()
	self.musicVolume_ = self.sliderSound_:getPercent() / 100
	AudioEngine.setMusicVolume(self.musicVolume_)
end

function ui_setting_t:onClose()
	global.g_mainPlayer:setEffectVolume(self.effectVolume_)
	global.g_mainPlayer:setMusicVolume(self.musicVolume_)
	
	self:close()
end
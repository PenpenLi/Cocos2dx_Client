--
-- Author: Yang
-- Date: 2016-10-28 09:33:54
--
SettingView = class("SettingView",PopUpView)

function SettingView:ctor()
	SettingView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_setting.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:addTouchEventListener(makeClickHandler(self, self.onClose))

	self.sliderEffect_ = ccui.Helper:seekWidgetByName(root, "Slider_3")
	self.sliderEffect_:addEventListener(handler(self, self.onEffectVolume))

	self.sliderSound_  = ccui.Helper:seekWidgetByName(root, "Slider_4")
	self.sliderSound_:addEventListener(handler(self, self.onSoundVolume))

	local volumeMusic  = global.g_mainPlayer:getLocalData("bairenniuniu_music", 100)
	self.sliderSound_:setPercent(volumeMusic)

	local volumeEffect = global.g_mainPlayer:getLocalData("bairenniuniu_effect", 100)
	self.sliderEffect_:setPercent(volumeEffect)

	local btnEffectSub = ccui.Helper:seekWidgetByName(root, "Button_6")
	btnEffectSub:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeSub))

	local btnEffectAdd = ccui.Helper:seekWidgetByName(root, "Button_7")
	btnEffectAdd:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeAdd))

	local btnMusicSub  = ccui.Helper:seekWidgetByName(root, "Button_8")
	btnMusicSub:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeSub))

	local btnMusicAdd  = ccui.Helper:seekWidgetByName(root, "Button_9")
	btnMusicAdd:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeAdd))
end

function SettingView:onEffectVolumeSub()
	local volume = self.sliderEffect_:getPercent()
	volume = math.max(0, volume - 10)
	self.sliderEffect_:setPercent(volume)
	AudioEngine.setEffectsVolume(volume / 100)
end

function SettingView:onEffectVolumeAdd()
	local volume = self.sliderEffect_:getPercent()
	volume = math.min(100, volume + 10)
	self.sliderEffect_:setPercent(volume)
	AudioEngine.setEffectsVolume(volume / 100)
end

function SettingView:onMusicVolumeSub()
	local volume = self.sliderSound_:getPercent()
	volume = math.max(0, volume - 10)
	self.sliderSound_:setPercent(volume)
	AudioEngine.setMusicVolume(volume / 100)
end

function SettingView:onMusicVolumeAdd()
	local volume = self.sliderSound_:getPercent()
	volume = math.min(100, volume + 10)
	self.sliderSound_:setPercent(volume)
	AudioEngine.setMusicVolume(volume / 100)
end

function SettingView:onEffectVolume()
	local volume = self.sliderEffect_:getPercent() / 100
	AudioEngine.setEffectsVolume(volume)
end

function SettingView:onSoundVolume()
	local volume = self.sliderSound_:getPercent() / 100
	AudioEngine.setMusicVolume(volume)
end

function SettingView:onClose()
	local volumeEffect = self.sliderEffect_:getPercent()
	local volumeMusic  = self.sliderSound_:getPercent()
	global.g_mainPlayer:setLocalData("bairenniuniu_effect", volumeEffect)
	global.g_mainPlayer:setLocalData("bairenniuniu_music", volumeMusic)

	self:close()
end
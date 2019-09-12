local SoundSetting = class("SoundSetting", PopUpView)

function SoundSetting:ctor()
  SoundSetting.super.ctor(self, true)
  self:enableNodeEvents(true)

  self.ui_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_setting.json")
  self.nodeUI_:addChild(self.ui_)

  self.btn_close_ =  ccui.Helper:seekWidgetByName(self.ui_,"Button_2")
  local function onClose(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      keyF4Pressed = false
      self:close()
    end
  end
  self.btn_close_:addTouchEventListener(onClose)

  self.slider_effect_ =  ccui.Helper:seekWidgetByName(self.ui_,"Slider_3")
  local function effectChangedEvent(sender,eventType)
        if eventType == 0 then
            local percent = self.slider_effect_:getPercent()
            self.effect_percent_ = percent
            AudioEngine.setEffectsVolume(percent/100)
        end
    end
  self.slider_effect_:addEventListenerSlider(effectChangedEvent)

  self.slider_music_ =  ccui.Helper:seekWidgetByName(self.ui_,"Slider_4")
  local function musicChangedEvent(sender,eventType)
        if eventType == 0 then
            local percent = self.slider_music_:getPercent()
            self.music_percent_ = percent
            AudioEngine.setMusicVolume(percent/100)
        end
    end
  self.slider_music_:addEventListenerSlider(musicChangedEvent)

  local btnEffectSub = ccui.Helper:seekWidgetByName(self.ui_, "Button_6")
  btnEffectSub:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeSub))

  local btnEffectAdd = ccui.Helper:seekWidgetByName(self.ui_, "Button_7")
  btnEffectAdd:addTouchEventListener(makeClickHandler(self, self.onEffectVolumeAdd))

  local btnMusicSub = ccui.Helper:seekWidgetByName(self.ui_, "Button_8")
  btnMusicSub:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeSub))

  local btnMusicAdd = ccui.Helper:seekWidgetByName(self.ui_, "Button_9")
  btnMusicAdd:addTouchEventListener(makeClickHandler(self, self.onMusicVolumeAdd))


  self:init()
  -- local function onTouch1(sender, eventType)
  --   local  pDirector = cc.Director:getInstance()
  --   local running_scene = pDirector:getRunningScene()
  --   if eventType == ccui.TouchEventType.ended then
  --     if self.hobao == 0 then
  --       self.hobao = 1
  --       self.Coinopbtn:loadTextureNormal("buyu2/res/bgd2.png")
  --       --running_scene.bolhobao = false
  --       running_scene.hobaotext:setVisible(false)
  --     else
  --       self.hobao = 0
  --       self.Coinopbtn:loadTextureNormal("buyu2/res/bgd1.png")
  --       --running_scene.bolhobao = true
  --       running_scene.hobaotext:setVisible(true)
  --     end
  --   end
  -- end
  -- self.Coinopbtn = nil
  -- if self.hobao == 0 then
  --   self.Coinopbtn = ccui.Button:create("buyu2/res/bgd1.png","buyu2/res/bgd2.png")
  -- else
  --   self.Coinopbtn = ccui.Button:create("buyu2/res/bgd2.png","buyu2/res/bgd1.png")
  -- end
  -- self.Coinopbtn:addTouchEventListener(onTouch1)
  -- self.ui_:addChild(self.Coinopbtn,111)
  -- self.Coinopbtn:setPosition(-20,-110)

  -- local spti = cc.Sprite:create("buyu2/res/hdij.png")
  -- spti:setPosition(100,-110)
  -- self.ui_:addChild(spti,111)
end

function SoundSetting:init()
    self.effect_percent_ = global.g_mainPlayer:getLocalData("buyu2_effect", 100)
    self.music_percent_ = global.g_mainPlayer:getLocalData("buyu2_music", 100)
    self.slider_effect_:setPercent(self.effect_percent_)
    self.slider_music_:setPercent(self.music_percent_)
    --self.hobao = global.g_mainPlayer:getLocalData("buyu2_hobao", 0)
end

function SoundSetting:onExit()
    global.g_mainPlayer:setLocalData("buyu2_effect", self.effect_percent_)
    global.g_mainPlayer:setLocalData("buyu2_music", self.music_percent_)
    --global.g_mainPlayer:setLocalData("buyu2_hobao", self.hobao)
end
function SoundSetting:onEffectVolumeSub()
  self.effect_percent_ = math.max(0,self.effect_percent_ - 10)
  self.slider_effect_:setPercent(self.effect_percent_)
  AudioEngine.setEffectsVolume(self.effect_percent_/100)
end

function SoundSetting:onEffectVolumeAdd()
  self.effect_percent_ = math.min(100, self.effect_percent_ + 10)
  self.slider_effect_:setPercent(self.effect_percent_ )
  AudioEngine.setEffectsVolume(self.effect_percent_/100)
end

function SoundSetting:onMusicVolumeSub()
  self.music_percent_ = math.max(0, self.music_percent_ - 10)
  self.slider_music_:setPercent(self.music_percent_)
  AudioEngine.setMusicVolume(self.music_percent_/100)
end

function SoundSetting:onMusicVolumeAdd()
  self.music_percent_ = math.min(100, self.music_percent_ + 10)
  self.slider_music_:setPercent(self.music_percent_)
  AudioEngine.setMusicVolume(self.music_percent_/100)
end
return SoundSetting
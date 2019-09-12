-- @Author: Marte
-- @Date:   2017-11-24 16:18:28
-- @Last Modified by:   Marte
-- @Last Modified time: 2017-11-28 10:46:15
local GameSetting = class("GameSetting", PopUpView)

function GameSetting:ctor()
  SoundSetting.super.ctor(self, true)
  self:enableNodeEvents(true)

  self.effectPercent = global.g_mainPlayer:getLocalData("buyu1_effect", 100)
  self.musicPercent = global.g_mainPlayer:getLocalData("buyu1_music", 100)

  self.bg = cc.Sprite:create("buyu1/res/setting/setting_bg.png")
  self:addChild(self.bg)
  self.bg:setPosition(cc.p(640,360))


  self.CloseBtn = ccui.Button:create("buyu1/res/setting/close1.png","buyu1/res/setting/close2.png")
  self.bg:addChild(self.CloseBtn)
  self.CloseBtn:setScale(0.6)
  self.CloseBtn:setVisible(true)
  local function onClose(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        keyF4Pressed = false
        self:close()
    end
  end
  self.CloseBtn:addTouchEventListener(onClose)
  self.CloseBtn:setPosition(cc.p(890+130,470+85))
--[[
  self.musicSlider = ccui.Slider:create("buyu1/res/fishui/Silder_SoundBg.png")
  self.bg:addChild(self.musicSlider)]]

  self.musicSlider = ccui.Slider:create()
  self.musicSlider:setTouchEnabled(true)
  self.musicSlider:loadBarTexture("buyu1/res/setting/silder_bg.png")
  self.musicSlider:loadSlidBallTextures("buyu1/res/setting/Silder_Thumb.png", "buyu1/res/setting/Silder_Thumb.png", "")
  self.musicSlider:loadProgressBarTexture("buyu1/res/setting/silder_bar.png")
  local function musicChangedEvent(sender,eventType)
        if eventType == 0 then
            local percent = self.musicSlider:getPercent()
            self.musicPercent = percent
            AudioEngine.setMusicVolume(percent/100)
        end
    end
  self.musicSlider:addEventListener(musicChangedEvent)
  self.bg:addChild(self.musicSlider)
  self.musicSlider:setPercent(self.musicPercent)
  self.musicSlider:setPosition(cc.p(900,390))
  self.musicSlider:setScale(0.8)

  self.effectSlider = ccui.Slider:create()
  self.effectSlider:setTouchEnabled(true)
  self.effectSlider:loadBarTexture("buyu1/res/setting/silder_bg.png")
  self.effectSlider:loadSlidBallTextures("buyu1/res/setting/Silder_Thumb.png", "buyu1/res/setting/Silder_Thumb.png", "")
  self.effectSlider:loadProgressBarTexture("buyu1/res/setting/silder_bar.png")
  local function effectChangedEvent(sender,eventType)
        if eventType == 0 then
            local percent = self.effectSlider:getPercent()
            self.effectPercent = percent
            AudioEngine.setEffectsVolume(percent/100)
        end
    end
  self.effectSlider:addEventListener(effectChangedEvent)
  self.bg:addChild(self.effectSlider)
  self.effectSlider:setPercent(self.effectPercent)
  self.effectSlider:setPosition(cc.p(900,280))
  self.effectSlider:setScale(0.8)

  -- local isSilence = global.g_mainPlayer:isSilence()
  -- self.silenceCBox = ccui.CheckBox:create()
  -- self.silenceCBox:setTouchEnabled(true)
  -- self.silenceCBox:loadTextures("buyu1/res/setting/open0.png",
  --                              "buyu1/res/setting/open0.png",
  --                              "buyu1/res/setting/open1.png",
  --                              "buyu1/res/setting/open0.png",
  --                              "buyu1/res/setting/open0.png")

  -- self.silenceCBox:addEventListener(handler(self, self.onSilenceHandler))
  -- self.bg:addChild(self.silenceCBox)
  -- self.silenceCBox:setSelected(isSilence)
  -- self.silenceCBox:setPosition(cc.p(710+240,60+160))


  self.ExitBtn = ccui.Button:create("buyu1/res/setting/exit_btn_1.png","buyu1/res/setting/exit_btn_2.png")
  self.bg:addChild(self.ExitBtn)
  self.ExitBtn:setVisible(true)
  local function onExitGame(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
        if global.g_mainPlayer:isInMatchRoom() == false then
              global.g_mainPlayer:setPlayerScore(math.floor(g_score[num] * g_protion))
            end
          WarnTips.showTips({
              text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
              confirm = function()
                  keyF4Pressed = false
                  self:close()
                  
                  exit_buyu1()
                end,
            })
    end
  end
  self.ExitBtn:addTouchEventListener(onExitGame)
  self.ExitBtn:setPosition(cc.p(890,85))


end

function GameSetting:onSilenceHandler(sender, eventType)
    if eventType == ccui.CheckBoxEventType.selected then
      global.g_mainPlayer:setSilence(true)
      AudioEngine.setEffectsVolume(0)
      AudioEngine.setMusicVolume(0)
    elseif eventType == ccui.CheckBoxEventType.unselected then
      global.g_mainPlayer:setSilence(false)
      AudioEngine.setEffectsVolume(self.musicPercent/100)
      AudioEngine.setMusicVolume(self.musicPercent/100)
    end
end

function GameSetting:onExit()
    global.g_mainPlayer:setLocalData("buyu1_effect", self.effectPercent)
    global.g_mainPlayer:setLocalData("buyu1_music", self.musicPercent)
end

function GameSetting:touchEnded(cx, cy, px, py)
    if not cc.rectContainsPoint(self.bg:getBoundingBox(), cc.p(cx, cy)) then
        keyF4Pressed = false
        self:close()
    end 
end

return GameSetting
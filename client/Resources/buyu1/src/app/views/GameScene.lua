GameScene = class("GameScene", LayerBase)

--[[
6人版本，进入房间看到的顺序是
  1 2
6     3
 5   4
 实际是
 1 2
5   6
 4 3

 8人
  1 2 3
8      4
  7 6 5
实际是
  1 7 2
5       6
  4 8 3

]]
function GameScene:ctor()
  GameScene.super.ctor(self)
  --self.winSize = cc.Director:getInstance():getWinSize()
  cc.exports.winwidth = display.width  --屏幕固定宽度
  cc.exports.winheight = display.height  --初始化全局变量屏幕高度
  cc.exports.SeatNum = global.g_mainPlayer:getCurrentGameNum()
  --根据不同的玩家数进入不同的房间，加载不同的json文件
  self.ui = ccs.GUIReader:getInstance():widgetFromJsonFile(UiJsonTable[SeatNum])
  self.ui:setClippingEnabled(true)
  self:addChild(self.ui,5)

  self.playnum = -1
  self.bolFire = true     -- 是否允许开炮
  self.bollMO = false   --是否自动需找鱼
  self.mathchFishScore = {0,0,0,0} --初始化比赛积分

  self.labletext = cc.Label:createWithTTF("就爱上大号是功夫就哈个房间按格式发嘎嘎说法", "fullmain/res/fonts/FZY4JW.ttf", 25, cc.size(900, 0))
  self.labletext:setPosition(cc.p(winwidth/2,winheight/2))
  self:addChild(self.labletext,100)

  self.labletext:setVisible(false)

  self.bsckome = cc.Sprite:create("buyu1/res/bacckds.png")
  self.bsckome:setPosition(cc.p(winwidth/2,winheight/2))
  self:addChild(self.bsckome,90)
  self.bsckome:setOpacity(100)
  self.bsckome:setScaleX(1280/90)
  -- self.bsckome:setScaleY(34/90)

  self.bsckome:setVisible(false)

  self.hobaotext = cc.Label:createWithTTF(LocalLanguage:getLanguageString("L_d8b0d7f710433b94"), "fullmain/res/fonts/FZY4JW.ttf", 40)
  self.hobaotext:setPosition(cc.p(winwidth/2,winheight/2 + 40))
  self:addChild(self.hobaotext,100)
  --self.hobaotext:setString(LocalLanguage:getLanguageString("L_d8b0d7f710433b94"))
  self.hobaotext:setColor(cc.c3b(255,0,0))
  self.hobaotext:setOpacity(160)
  self.hobaotext:setVisible(false)

  self.bolhobao = true

  --cc.exports.isCreateFish21 = true


  cc.exports.g_score = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0,
  }
  cc.exports.g_gold = {
    [0] = 0,
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
    [5] = 0,
    [6] = 0,
    [7] = 0,
  }
  cc.exports.soundManager = SoundManager.new()
  self.actime = 0
  self.gold = 0  --玩家金币
  self:number()  --初始化各数值
  self:Ground()
  self:CreaUi()
  self:button()
  self:water()
  --self:Mask()
  self:GameSetting()
  self:layer()  -- 空闲弹出框
  self:enableNodeEvents(true)

  -- self:initMsgHandler()


  self.factory_ = FishFactory:getInstance()
  local function onCreateFish(fishkind, fishid, trace)
    BoJFish:creaFish(fishid, fishkind, trace,1)
  end

  self.factory_:setLuaFunc(onCreateFish)
  self.factory_:Start()

  local contactListener = cc.EventListenerPhysicsContact:create()
  contactListener:registerScriptHandler(handler(self, self.onContactBegin) , cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
  local eventDispatcher = self:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)

  soundManager:PlayBackMusic()

  if global.g_mainPlayer:isSilence() then
    AudioEngine.setMusicVolume(0)
    AudioEngine.setEffectsVolume(0)
  else
    local music_percent = global.g_mainPlayer:getLocalData("buyu1_music", 100)
    AudioEngine.setMusicVolume(music_percent/100)
    local effect_percent = global.g_mainPlayer:getLocalData("buyu1_effect", 100)
    AudioEngine.setEffectsVolume(effect_percent/100)
  end
  --震屏
  self.offset_ = cc.p(0, 0)
  self.since_last_frame_ = 0
  self.current_shake_frame_ = 0
  self.shake_screen_ = false

  --初始化返回键
  self:initBackKey()
  self:initKeyPressed()
--[[
  local b = cc.Sprite:createWithSpriteFrameName(BulletSet[0][0])
  local anim = animateCache:getAnimation(BulletAnimSet[0][0])
  local action1 = cc.Animate:create(anim)
  b:runAction(cc.RepeatForever:create(action1))
  self:addChild(b,100)
  b:setPosition(100,100)]]

  cc.exports.winScoreIndex = 1
  self.winScoreID = 0
  self.winScoreTimer = 0
  self.winScoreVec = {}

  -- cc.Director:getInstance():getTextureCache():dumpCachedTextureInfo()
end

function GameScene:initBackKey( )
    self.back_release_ = true
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self, self.keyboardReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameScene:initKeyPressed()
  self.keyLeftPressed = false
  self.keyRightPressed = false
  self.keyPressDT = 0

  self.keyFirePressed = false
  self.keyFireDT = 0

  self.keyUpPressed = false
  self.keyUpDT = 0
  self.keyDownPressed = false
  self.keyDownDT = 0

  self.keySPressed = false
  self.keySDT = 0

  cc.exports.keyF4Pressed = false

  self.isShowBL = true --刚进来会显示，所以true

  local listener = cc.EventListenerKeyboard:create()
  listener:registerScriptHandler(handler(self, self.keyboardPressed), cc.Handler.EVENT_KEYBOARD_PRESSED)
  local eventDispatcher = self:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


function GameScene:keyboardPressed(keyCode, event)
  --print(keyCode)
  if keyCode == 26 then
    self:keySetRota(1)
    self.keyLeftPressed = true --按下状态取消
    self.keyPressDT = 0
  elseif keyCode == 27 then
    self:keySetRota(2)
    self.keyRightPressed = true
    self.keyPressDT = 0
  elseif keyCode == 28 then
    self.keyUpPressed = true
    self.keyUpDT = 0
    self:addUnitBet()
  elseif keyCode == 29 then
    self:decUnitBet()
    self.keyDownPressed = true
    self.keyDownDT = 0
  elseif keyCode == 59 then
    if g_bolsuo == false and actor == false then
      self:Auto_emission()
      self.keyFirePressed = true
      self.keyFireDT = 0
    end
  elseif keyCode == 142 then --锁
    if not table.empty(fishMap) then
      Tesdis:AcSuoFish()
    end
    self.keySPressed = true
    self.keySDT = 0
  elseif keyCode == 140 then --取消锁鱼
    if not table.empty(fishMap) then
      self.bollMO = Tesdis:ConSuoFish()
      g_bolsuo = false
    end
  elseif keyCode == 129 then --自动发炮
    if actor == false then
      actor = true
      self.actime = 0
      self.Autobtn:setOpacity(125)
    elseif actor == true then
      actor = false
      self.Autobtn:setOpacity(255)
    end
  elseif keyCode == 50 then  --打开设置
    if keyF4Pressed == false then
      PopUpView.showPopUpView(GameSetting)
      keyF4Pressed = true
    end
  elseif keyCode == 51 then  --倍率
    self.isShowBL = not self.isShowBL
    GameScene.Rate:setVisible(self.isShowBL)
  end
end

function GameScene:keyboardReleased(keycode, event)
    if keycode == 6 then --返回键
      if self.back_release_ then
        self.back_release_ = false
        local function onCancel()
          self.back_release_ = true
        end
        global.g_mainPlayer:setPlayerScore(math.floor(g_score[num] * g_protion))
        WarnTips.showTips({
              text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
              confirm = exit_buyu1,
              cancel = onCancel
            })
      end
    elseif keycode == 59 then
      self.keyFirePressed = false
    elseif keycode == 29 then
      self.keyDownPressed = false
      self.keyDownDT = 0
    elseif keycode == 28 then
      self.keyUpPressed = false
      self.keyUpDT = 0

    elseif keycode == 26 then
      --self:keySetRota(1)
      self.keyLeftPressed = false --按下状态取消
    elseif keycode == 27 then
      --self:keySetRota(2)
      self.keyRightPressed = false
    elseif keycode == 142 then
        self.keySPressed = false
        self.keySDT = 0
    end
end

function GameScene:ShakeScreen()
  self.offset_.x = 0
  self.offset_.y = 0
  self.since_last_frame_ = -1
  self.current_shake_frame_ = 0
  self.shake_screen_ = true
end

function GameScene:UpdateShakeScreen( delta_time )
  if not self.shake_screen_ then return end

  if self.since_last_frame_ == -1 then
    self.since_last_frame_ = 0
  else
    self.since_last_frame_ = self.since_last_frame_ + delta_time
  end

  local kSpeed = 1/30
  while(self.since_last_frame_ >= kSpeed)
  do
    self.since_last_frame_ = self.since_last_frame_ - kSpeed
    if self.current_shake_frame_ + 1 == 20 then
      self.shake_screen_ = false
      self.offset_.x = 0
      self.offset_.y = 0
      break
    else
      self.current_shake_frame_ = self.current_shake_frame_ + 1
      self.offset_.x = (math.random(0, 65535)%2 == 0) and (10 + math.random(0, 65535)%5) or (-10-math.random(0,65535)%5)
      self.offset_.y = (math.random(0, 65535)%2 == 1) and (10 + math.random(0, 65535)%5) or (-10-math.random(0,65535)%5)
    end
  end
  self.bg:setPosition(self.offset_)
end

function GameScene:decUnitBet()
  if self.goma > 1 and self.goma <= 10 and self.goma > self.min_bullet_multiple then
    self.goma = self.goma - 1
  elseif self.goma >10 and self.goma <= 100 and self.goma > self.min_bullet_multiple then
    self.goma = self.goma - 10
  elseif self.goma > 100 and self.goma <= 1000 then
    self.goma = self.goma - 100
  elseif self.goma > 1000 then
    self.goma = self.goma - 1000
  elseif self.goma == self.min_bullet_multiple then
    self.goma = self.max_bullet_multiple
  end

  if self.goma >= 1000 and self.goma <= 9900 then
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(7)
    else
      self.paotable[self.playnum+1]:SwitchFrame(3)
    end
    self.buttnum = 2
  elseif self.goma >= 100 and self.goma < 1000 then
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(6)
    else
      self.paotable[self.playnum+1]:SwitchFrame(2)
    end
    self.buttnum = 1
  else
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(5)
    else
      self.paotable[self.playnum+1]:SwitchFrame(1)
    end
    self.buttnum = 0
  end
  self.paotable[self.playnum+1]:setRateNumber(self.goma)
  soundManager:PlayGameEffect(0)
end

function GameScene:addUnitBet()
  if self.goma >= 1 and self.goma < 10 then
    self.goma = self.goma + 1
  elseif self.goma >= 10 and self.goma < 100 then
    self.goma = self.goma + 10
  elseif self.goma >= 100 and self.goma < 1000 then
    self.goma = self.goma + 100
  elseif self.goma >= 1000 and self.goma < 9000 then
    self.goma = self.goma + 1000
  elseif self.goma == 9000 then
    self.goma = self.max_bullet_multiple
  elseif self.goma == self.max_bullet_multiple then
    self.goma = self.min_bullet_multiple
  end

  if self.goma >= 1000 and self.goma <= 9900 then
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(7)
    else
      self.paotable[self.playnum+1]:SwitchFrame(3)
    end
    self.buttnum = 2
  elseif self.goma >= 100 and self.goma < 1000 then
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(6)
    else
      self.paotable[self.playnum+1]:SwitchFrame(2)
    end
    self.buttnum = 1
  else
    if bovder[self.playnum] == true then
      self.paotable[self.playnum+1]:SwitchFrame(5)
    else
      self.paotable[self.playnum+1]:SwitchFrame(1)
    end
    self.buttnum = 0
  end
  self.paotable[self.playnum+1]:setRateNumber(self.goma)
  soundManager:PlayGameEffect(0)
end

function GameScene:onUserFireSpeed(param) -- 发炮间隔,param.player_fire_speed是毫秒
  self.DiTimer = param.player_fire_speed / 1000.0
end

function GameScene:initSurface()
  local tableId = global.g_mainPlayer:getCurrentTableId()
  local tableUser = global.g_mainPlayer:getTableUser(tableId)
  for k, v in pairs(tableUser) do
    local pd = global.g_mainPlayer:getRoomPlayer(v)
    if pd.playerId == global.g_mainPlayer:getPlayerId() then
      self.goma = self.min_bullet_multiple
      self.playnum = k --玩家编号
      cc.exports.num = self.playnum  --初始化全局变量玩家编号
      self.paoPoint = cc.p(self.paotable[self.playnum+1]:getPositionX(),self.paotable[self.playnum+1]:getPositionY())
      cc.exports.paoPoint = self.paoPoint  --初始化全局变量炮的位置
      if self.goma >= 1000 and self.goma <= 9900 then
        if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(7)
        else
            self.paotable[self.playnum+1]:SwitchFrame(3)
        end
        self.buttnum = 2
      elseif self.goma >= 100 and self.goma < 1000 then
        if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(6)
        else
            self.paotable[self.playnum+1]:SwitchFrame(2)
        end
        self.buttnum = 1
      else
        if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(5)
        else
            self.paotable[self.playnum+1]:SwitchFrame(1)
        end
        self.buttnum = 0
      end

      self.paotable[self.playnum+1]:setRateNumber(self.goma)
      self:touche() --触摸
      self:Timer()
      local function onTouch1(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
          if self.goma > 1 and self.goma <= 10 and self.goma > self.min_bullet_multiple then
            self.goma = self.goma - 1
          elseif self.goma >10 and self.goma <= 100 and self.goma > self.min_bullet_multiple then
            self.goma = self.goma - 10
          elseif self.goma > 100 and self.goma <= 1000 then
            self.goma = self.goma - 100
          elseif self.goma > 1000 then
            self.goma = self.goma - 1000
          elseif self.goma == self.min_bullet_multiple then
            self.goma = self.max_bullet_multiple
          end

          if self.goma < self.min_bullet_multiple then
            self.goma = self.max_bullet_multiple
          end

          if self.goma >= 1000 and self.goma <= 9900 then
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(7)
            else
              self.paotable[self.playnum+1]:SwitchFrame(3)
            end
            self.buttnum = 2
          elseif self.goma >= 100 and self.goma < 1000 then
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(6)
            else
              self.paotable[self.playnum+1]:SwitchFrame(2)
            end
            self.buttnum = 1
          else
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(5)
            else
              self.paotable[self.playnum+1]:SwitchFrame(1)
            end
            self.buttnum = 0
          end
          self.paotable[self.playnum+1]:setRateNumber(self.goma)
          soundManager:PlayGameEffect(0)
        end
      end
      self.RedubtnTable[self.playnum+1]:addTouchEventListener(onTouch1)

      local function onTouch2(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
          if self.goma >= 1 and self.goma < 10 then
            self.goma = self.goma + 1
          elseif self.goma >= 10 and self.goma < 100 then
            self.goma = self.goma + 10
          elseif self.goma >= 100 and self.goma < 1000 then
            self.goma = self.goma + 100
          elseif self.goma >= 1000 and self.goma < 9000 then
            self.goma = self.goma + 1000
          elseif self.goma == 9000 then
            self.goma = self.max_bullet_multiple
          elseif self.goma == self.max_bullet_multiple then
            self.goma = self.min_bullet_multiple
          end

          if self.goma > self.max_bullet_multiple then
            self.goma = self.min_bullet_multiple
          end

          if self.goma >= 1000 and self.goma <= 9900 then
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(7)
            else
              self.paotable[self.playnum+1]:SwitchFrame(3)
            end
            self.buttnum = 2
          elseif self.goma >= 100 and self.goma < 1000 then
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(6)
            else
              self.paotable[self.playnum+1]:SwitchFrame(2)
            end
            self.buttnum = 1
          else
            if bovder[self.playnum] == true then
              self.paotable[self.playnum+1]:SwitchFrame(5)
            else
              self.paotable[self.playnum+1]:SwitchFrame(1)
            end
            self.buttnum = 0
          end
          self.paotable[self.playnum+1]:setRateNumber(self.goma)
          soundManager:PlayGameEffect(0)
        end
      end
      self.PlusbtnTable[self.playnum+1]:addTouchEventListener(onTouch2)


      --[[三个按钮重写，在这里设置位置，左右两侧的要区别处理]]
      local btnY = 0
      local btnX = 0
      if self.playnum ~= 4 and self.playnum ~= 5 then
        if self.playnum == 0 or self.playnum == 1 or self.playnum == 6 then
          btnY = -70
          btnX = self.paopointTable[self.playnum].x
        elseif self.playnum == 2 or self.playnum == 3 or self.playnum == 7 then
          btnY = 70
          btnX = self.paopointTable[self.playnum].x
        end
        self.Autobtn:setPosition(btnX - 210,self.paopointTable[self.playnum].y + btnY)
        self.Relievebtn:setPosition(btnX - 70,self.paopointTable[self.playnum].y + btnY)
        self.Aimbtn:setPosition(btnX - 140,self.paopointTable[self.playnum].y + btnY)
      elseif self.playnum == 5 then
        btnX = self.paopointTable[self.playnum].x -70
        btnY = self.paopointTable[self.playnum].y
        self.Autobtn:setPosition(btnX,btnY+210)
        self.Aimbtn:setPosition(btnX,btnY+140)
        self.Relievebtn:setPosition(btnX,btnY+70)
      elseif self.playnum == 4 then
        btnX = self.paopointTable[self.playnum].x + 70
        btnY = self.paopointTable[self.playnum].y
        self.Autobtn:setPosition(btnX,btnY+210)
        self.Aimbtn:setPosition(btnX,btnY+140)
        self.Relievebtn:setPosition(btnX,btnY+70)
      end

    end
    self.paotable[k+1]:setVisible(true)
    self.baseTable[k+1]:setVisible(true)
    self.PlayNameTable[k+1]:setString(pd.name)
    self.RedubtnTable[k+1]:setVisible(true)
    self.PlusbtnTable[k+1]:setVisible(true)
    self.PTTable[k+1]:setVisible(true)



  end

  if global.g_mainPlayer:isInMatchRoom() == true then
    self.rankroot:setVisible(true)
    self.scorebase[self.playnum+1]:setVisible(true)
  end

  self:startGuideCheck()
--[[
  if self.playnum ~= 5 then
    self.Mask:setPosition(winwidth-50,winheight-150)
  else
    self.Mask:setPosition(50,winheight-150)
  end
  self.Mask:setVisible(true)]]
end

function GameScene:startGuideCheck()
  local isItem1Buyed = global.g_mainPlayer:isItem1Buyed()
  local isOpenEarnings = global.g_mainPlayer:isOpenEarnings()
  local serverId = global.g_mainPlayer:getCurrentRoom()
  local roomType = global.g_mainPlayer:getRoomType(serverId)
  self.isNeedGuide_ = (not isItem1Buyed and not isOpenEarnings and roomType and roomType ~= ROOM_TYPE_TIYAN and not global.g_mainPlayer:isInMatchRoom())
end

function GameScene:checkGuide(chairIdCatch)
  if not self.isNeedGuide_ then return end

  local chairId = global.g_mainPlayer:getCurrentChairId()
  if chairIdCatch ~= chairId then return end

  local rate = global.g_mainPlayer:getCurrentRoomBeilv()
  local score = math.floor(g_score[chairId] / rate)

  if score > ITEM1_COST then
    actor = false
    self.Autobtn:setOpacity(255)
    self:stopGuideCheck()

    PopUpView.showPopUpView(AuctionTipsView)
  end
end

function GameScene:stopGuideCheck()
  self.isNeedGuide_ = false
end

function GameScene:onContactBegin(contact)
  local bodyA = contact:getShapeA():getBody()
  local bodyB = contact:getShapeB():getBody()

  self:onContactSolve(bodyA, bodyB)

  return false
end

function GameScene:onContactSolve(bodyA, bodyB)
  local groupA = bodyA:getGroup()
  local groupB = bodyB:getGroup()

  local bullet = nil
  local fish = nil
  if groupA == -1 then
    bullet = bodyA:getNode()
    fish = bodyB:getNode()
  elseif groupB == -1 then
    fish = bodyA:getNode()
    bullet = bodyB:getNode()
  end

  if not bullet or not fish then return end

  if not fish.boolfire then
    return
  end

  if bullet.FishSuId ~= 0 and fish.fishID ~= bullet.FishSuId then
    return
  end

  local point = cc.p(bullet:getPositionX(),bullet:getPositionY())
  local point2 = cc.p(fish:getPositionX(),fish:getPositionY())
  --cclog("bullet.fishnet = %d",bullet.fishnet)
  local fishnet = Fishnet.new(bullet.fishnet)
  fishnet:setRotation(bullet.rotaion)
  fishnet:setPosition(point)
  verylayer:addChild(fishnet,2)
  soundManager:PlayGameEffect(1)
  if bullet.playID == self.playnum or bullet:getandroid()==self.playnum then
    local param = 0
    if fish.fishKind == 22 or fish.fishKind == 23 or (fish.fishKind >= 30 and fish.fishKind<= 39) then
        if fish.fishKind == 22 then
            param = Calculation:reFusBB(fish,point2,400,400)
        elseif fish.fishKind == 23 then
            param = Calculation:reFusBom(fish)
        elseif fish.fishKind >= 30 and fish.fishKind<= 39 then
            param = Calculation:reFusBomFis(fish,fish.fishKind)
        end
        gamesvr.sendCatchFish(bullet.playID,bullet.VeryId,bullet.butype,fish.fishID,bullet.bullet_multiple,param)
    else
        gamesvr.sendCatchFish(bullet.playID,bullet.VeryId,bullet.butype,fish.fishID,bullet.bullet_multiple,param)
    end
  end
  bulletMap[bullet.VeryId] = nil
  bullet:removeFromParent()
end

function GameScene:onRoomUserLeave(playerId, tableId, chairId, status)
  --有人离开
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then
    --我桌子上有人离开
    self.paotable[chairId+1]:setVisible(false)
    self.PTTable[chairId+1]:setVisible(false)
    self.baseTable[chairId+1]:setVisible(false)
    self.RedubtnTable[chairId+1]:setVisible(false)
    self.PlusbtnTable[chairId+1]:setVisible(false)
    lineTable[chairId]:setVisible(false)
    suodinTable[chairId]:setVisible(false)
    SuoFishTable[chairId]:setVisible(false)
    self.doubTable[chairId]:setVisible(false)
    g_score[chairId] = 0
    self.bolmaTable[chairId] = false
    self.blamaTable[chairId]:stopAllActions()
    self.blamaTable[chairId]:setVisible(false)
    g_gold[chairId] = 0
  end
end

function GameScene:onRoomUserFree(playerId, tableId, chairId, status)
  --有人离开

  if global.g_mainPlayer:isInMatchRoom() == true and playerId==global.g_mainPlayer:getPlayerId() then
    if self.schedulerID then
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end
    exit_buyu1()
  end

  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then
    --我桌子上有人离开
    self.paotable[chairId+1]:setVisible(false)
    self.PTTable[chairId+1]:setVisible(false)
    self.baseTable[chairId+1]:setVisible(false)
    self.RedubtnTable[chairId+1]:setVisible(false)
    self.PlusbtnTable[chairId+1]:setVisible(false)
    lineTable[chairId]:setVisible(false)
    suodinTable[chairId]:setVisible(false)
    SuoFishTable[chairId]:setVisible(false)
    self.doubTable[chairId]:setVisible(false)
    g_score[chairId] = 0
    g_gold[chairId] = 0
    self.bolmaTable[chairId] = false
    self.blamaTable[chairId]:stopAllActions()
    self.blamaTable[chairId]:setVisible(false)
  end
end

function GameScene:onRoomUserPlay(playerId, tableId, chairId, status)
  --有人进来玩
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  print("我的桌子id:", currentTableId, "新人的桌子id:", tableId)
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then
    --我桌子上有人来玩
    local pd = global.g_mainPlayer:getRoomPlayer(playerId)
    self.paotable[chairId+1]:setVisible(true)
    self.PTTable[chairId+1]:setVisible(true)
    self.baseTable[chairId+1]:setVisible(true)
    self.PlayNameTable[chairId+1]:setString(pd.name)
    self.RedubtnTable[chairId+1]:setVisible(true)
    self.PlusbtnTable[chairId+1]:setVisible(true)
    self.scoretexTab[chairId+1]:setString(tostring(0))
    self.GoldTexTable[chairId+1]:setString(tostring(0))
  end

end

function GameScene:onAutoExitHandler()
  exit_buyu1(GAME_GUIDES.GUIDE_HALL)
end

function GameScene:onEndEnterTransition()
  -- 后台返回前台
  cc.Director:getInstance():getRunningScene():openPhysicsWorld()

  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self, self.onEnterForeGround)
  --捕鱼
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_GAME_CONFIG, self, self.onGameConfig)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FISH_TRACE, self, self.onFishTrace)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, self, self.onExchangeFishscore)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_USER_FIRE, self, self.onUserFire)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CATCH_FISH, self, self.onCatchFish)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, self, self.onBulletIonTimeout)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_HIT_FISH_LK, self, self.onHitFishLK)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_SWITCH_SCENE, self, self.onSwitchScene)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_GF_SCENE, self, self.onGFScene)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_LOCK_TIMEOUT, self, self.onLockTimeout)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self, self.onGameServerConnectLost)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_MATCH_TOP, self, self.onMatchTop)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GF_MESSAGE, self, self.onMessage)

  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self, self.onRedEnvelopeFlag)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self, self.onRedEnvelopeSend)

  --用户状态变更
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self, self.onRoomUserLeave)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserFree)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)

  --震屏
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self, self.ShakeScreen)

  --子弹速度
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_USER_FIRE_SPEED, self, self.onUserFireSpeed)

  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FISH_LINE, self, self.onFishLine)
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_AUTO_EXIT, self, self.onAutoExitHandler)
end

function GameScene:onStartExitTransition()
  -- 后台返回前台
  self:onExitHandler()
  cc.Director:getInstance():getRunningScene():closePhysicsWorld()

  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self)
  --捕鱼
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_GAME_CONFIG, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_FISH_TRACE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_USER_FIRE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_CATCH_FISH, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_HIT_FISH_LK, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_SWITCH_SCENE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_GF_SCENE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_LOCK_TIMEOUT, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_MATCH_TOP, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GF_MESSAGE, self)

  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self)

  --用户状态变更
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)

  --震屏
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self)

  --子弹速度
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_USER_FIRE_SPEED, self)

  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_FISH_LINE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_AUTO_EXIT, self)
end

function GameScene:onRedEnvelopeFlag(param)
  self.hobao = global.g_mainPlayer:getLocalData("buyu1_hobao", 0)
  local timh = param.nextTime_h
  local timm = param.nextTime_m
  local tims = param.nextTime_s
  local timl = param.nextTime_l
  if (timl > 0 or timm > 0 or tims > 0 or timh > 0 ) then
    self.hobaotext:setVisible(true)
  end
  if self.hobao == 0 then
    self.hobaotext:setVisible(true)
  else
    self.hobaotext:setVisible(false)
  end
  --print("=============",param.nextTime_h,param.nextTime_m,param.nextTime_s,param.nextTime_l)
  local strd = LocalLanguage:getLanguageString("L_d8b0d7f710433b94")..timh..":"..timm..":"..tims..LocalLanguage:getLanguageString("L_47586623a766074f")..timl
  --local strd123 = "距离下一"
  --print(strd,"======================")
  self.hobaotext:setString(strd)
end

function GameScene:onRedEnvelopeSend(param)
  --print("=============asdg12")
  --print("safhakhf=============asdg12")
  local sckd = param.chairID
  local hoscored = param.score
  self.hoscortab[sckd]:setS(tostring(hoscored))
  self:AcCion(sckd)
end

function GameScene:onGameServerConnectLost()
  actor = false
  cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
end

function GameScene:onMatchTop(param)

  self.My_LTime = param.My_LTime
  for mnd = 1,param.TopNum do
    if param.Top_ScoreList[mnd] > 0 then
      self.TextField[mnd]:setVisible(true)
      self.rankname[mnd]:setString(param.Top_NameList[mnd])
      self.rankscore[mnd]:setString(tostring(param.Top_ScoreList[mnd]))
    end
  end
  self.ranktext:setString(tostring(param.My_Order+1))
  self.maxscoretrxt:setString(tostring(param.My_TopNum))
  self.lastnum:setString(tostring(self.My_LTime))

  if self.playnum >= 0 then
    self.dicscore[self.playnum+1]:setString(tostring(self.mathchFishScore[self.playnum+1]))
  end
end

function GameScene:onEnterForeGround( )
  self:CloseScene()
  self.bolFire = true
end

--配置信息的接入
function GameScene:onGameConfig(param)
  self.fishSpeed = {}
  self.min_bullet_multiple = param.min_bullet_multiple
  self.max_bullet_multiple = param.max_bullet_multiple
  cc.exports.g_protion = 1 / param.fish_score_rate_num
  for i = 0,#param.fish_speed do
    -- 除以2，降低鱼的速度，同时fish.lua的update间隔也减半，这样鱼update的时候就不会太冲，从30fps变到60
    self.fishSpeed[i] = param.fish_speed[i]*0.7*winwidth/kRESOLUTIONWIDTH/2
  end
  self.bom_width = param.bomb_range_width --小炸弹爆炸宽度
  self.bom_height = param.bomb_range_height --小炸弹爆炸高度
  cc.exports.fish_multiple = param.fish_multiple --鱼的倍率定值鱼
  cc.exports.fish_width = {}
  cc.exports.fish_height = {}
  for i = 0,#param.fish_bounding_box_width do
    fish_width[i] = param.fish_bounding_box_width[i]*1/2 --鱼的碰撞宽度
    fish_height[i] = param.fish_bounding_box_height[i]*1/2 --鱼的碰撞高度
  end
  for i = 0,#param.bullet_speed do
    param.bullet_speed[i] = param.bullet_speed[i]*winwidth/kRESOLUTIONWIDTH
  end
  cc.exports.bullet_speed = param.bullet_speed
  --cclog("bullet_speed = %d",param.bullet_speed)
  self:initSurface()
  --print(self.fish_width[18],self.fish_height[18],"====================")
  -- for i = 0,#param.bullet_speed do
  --   --print(param.bullet_speed[i],"=================")
  -- end
--[[
  for i=1,210 do
    BoJFish:creaFishLine(i, 0, scene_kind_1_trace_.speed, scene_kind_1_trace_[i], 0, self.fish_multiple)
  end

  for i=1,200 do
    local config = scene_kind_2_trace_[i]
    BoJFish:creaFishBehaviour(i, 0, {Fish.createLinearBehavior(config[1], config[2], scene_kind_2_trace_.speed),
      Fish.createDelayBehavior(scene_kind_2_trace_.small_middle_delay), Fish.createLinearBehavior(config[2], config[3], scene_kind_2_trace_.speed)}, self.fish_multiple)
  end
  for i=201,214 do
    local config = scene_kind_2_trace_[i]
    BoJFish:creaFishBehaviour(i, 5, {
      Fish.createDelayBehavior(scene_kind_2_trace_.big_begin_delay), Fish.createLinearBehavior(config[1], config[2], scene_kind_2_trace_.speed)}, self.fish_multiple)
  end


 for i=1,234 do
   local config = scene_kind_5_trace_[i]
    BoJFish:creaFishBehaviour(i, 0, {Fish.createCircleBehavior(config.first.centerPoint, config.first.startAngle, config.first.endAngle, config.first.radius, config.first.speedSec),
      Fish.createLinearBehavior(config.second[1], config.second[2], scene_kind_2_trace_.speed)}, self.fish_multiple)
 end
 for i=235,236 do
  local config = scene_kind_5_trace_[i]
    BoJFish:creaFishBehaviour(i, 0, {Fish.createAngleBehavior(config.first.startAngle, config.first.endAngle, config.first.speedSec),
      Fish.createLinearBehavior(config.second[1], config.second[2], scene_kind_2_trace_.speed)}, self.fish_multiple, config.first.centerPoint)
 end
]]

    -- for i=0,213-1 do
    --   local trace = FishFactory:get_scene_fish_trace(1, i)
    --   local fish = BoJFish:creaFish(i, 0, trace)
    --   if i < 200 then
    --     local stop_index, stop_count = FishFactory:get_scene2_small_fish_stop(i)
    --     fish:SetFishStop(stop_index, stop_count)
    --   else
    --     local stop_index, stop_count = FishFactory:get_scene2_big_fish_stop()
    --     fish:SetFishStop(stop_index, stop_count)
    --   end
    -- end
end

function GameScene:onFishLine(param)
  for i = 1,#param do
    local config = param[i]
    self.factory_:createFish(config.fish_kind, config.fish_id, self.fishSpeed[config.fish_kind], config.init_pos[1].x, config.init_pos[2].x, config.init_pos[3].x,
      config.init_pos[1].y, config.init_pos[2].y, config.init_pos[3].y, config.init_count, config.trace_type)
  end
end

--服务器穿的鱼的创建
function GameScene:onFishTrace(param)
  for i = 1,#param do

    local config = param[i]
    self.factory_:createFish(config.fish_kind, config.fish_id, self.fishSpeed[config.fish_kind], config.init_pos[1].x, config.init_pos[2].x, config.init_pos[3].x,
      config.init_pos[1].y, config.init_pos[2].y, config.init_pos[3].y, config.init_count, config.trace_type)

  end
end

--显示其他场打的鱼的分数
function GameScene:onMessage(param)
  local str = param.message
  if true then--string.find(str,"西游") then
    local dt = 1
    if self.schedul1 ~= nil then
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul1)
    end
    local schedul = cc.Director:getInstance():getScheduler()
    self.schedul1 = schedul:scheduleScriptFunc(function ()
      dt = dt + 1
      if dt % 300 == 0 then
        self.labletext:setVisible(false)
        self.bsckome:setVisible(false)
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul1)
      end
    end, 0, false)
    self.labletext:setVisible(true)
    self.bsckome:setVisible(true)
    self.labletext:setString(str)
  end
end

--服务器游戏分数接入
function GameScene:onExchangeFishscore(param)
  --print(param.sw_fish_score,"=====================")
  -- if param.increase == 1 then
  g_score[param.chair_id] = g_score[param.chair_id] + param.sw_fish_score
  -- elseif param.increase == 0 then
  --   g_score[param.chair_id] = g_score[param.chair_id] - param.sw_fish_score
  -- end
  self.GoldTexTable[param.chair_id+1]:setString(tostring(g_score[param.chair_id]))
  --g_gold[param.chair_id] = param.l_coin_score
  --self.scoretexTab[param.chair_id+1]:setString(tostring(g_gold[param.chair_id]))
end

--同步其他玩家分数
function GameScene:onGFScene(param)
  g_score[0] = param.fish_score[1] + g_score[0]
  self.GoldTexTable[1]:setString(tostring(g_score[0]))
  g_score[1] = param.fish_score[2] + g_score[1]
  self.GoldTexTable[2]:setString(tostring(g_score[1]))

  g_score[2] = param.fish_score[3] + g_score[2]
  self.GoldTexTable[3]:setString(tostring(g_score[2]))
  g_score[3] = param.fish_score[4] + g_score[3]
  self.GoldTexTable[4]:setString(tostring(g_score[3]))

  if SeatNum >= 6 then
    g_score[4] = param.fish_score[5] + g_score[4]
    self.GoldTexTable[5]:setString(tostring(g_score[4]))
    g_score[5] = param.fish_score[6] + g_score[5]
    self.GoldTexTable[6]:setString(tostring(g_score[5]))
  end

  if SeatNum == 8 then
    g_score[6] = param.fish_score[7] + g_score[6]
    self.GoldTexTable[7]:setString(tostring(g_score[6]))
    g_score[7] = param.fish_score[8] + g_score[7]
    self.GoldTexTable[8]:setString(tostring(g_score[7]))
  end
end

--背景创建
function GameScene:Ground()
  self.bg = cc.Sprite:create("buyu1/res/images/Scene/bg1.png")
  --local scalx = winwidth/self.bg:getContentSize().width
  --local scaly = winheight/self.bg:getContentSize().height
  self.bg:setAnchorPoint(cc.p(0,0))
  --self.bg:setPosition(winwidth/2,winheight/2)
  --self.bg:setScaleX(scalx)
  --self.bg:setScaleY(scaly)
  self:addChild(self.bg,-1)

--隐藏倍率表
  GameScene.Rate =  ccui.Helper:seekWidgetByName(self.ui,"Rate")
  GameScene.Rate:setVisible(false)

  cc.exports.verylayer = cc.Layer:create()
  self:addChild(verylayer,2)

  cc.exports.fishlayer = cc.Layer:create()
  self:addChild(fishlayer,1)

  cc.exports.lablayer = cc.Layer:create()
  self:addChild(lablayer,3)

  self.paoLayer = cc.Layer:create()
  self:addChild(self.paoLayer,6)
end

--其他人子弹的处理
function GameScene:onUserFire(param)
  local playID = param.chair_id
  if playID == self.playnum then
    Vebull:LabSet(self.GoldTexTable[self.playnum+1],param.bullet_multiple,self.playnum)
  else
    local point = cc.p(self.paotable[playID+1]:getPositionX(),self.paotable[playID+1]:getPositionY())
    local pao = self.paotable[playID+1]
    local bullet_multiple = param.bullet_multiple
    local veryType = param.bullet_kind

    local deg = param.angle
    local ScoreTex = self.GoldTexTable[playID+1]
    local veryID = param.bullet_id
    local bllock_fishid = param.lock_fishid

    local android_id=param.android_chairid
    Vebull:onUserVery(point,pao,playID,bullet_multiple,veryType,deg,ScoreTex,veryID,bllock_fishid,android_id)
    --Vebull:onUserVery(point,pao,playID,bullet_multiple,veryType,deg,ScoreTex,veryID,bllock_fishid)
    if self.playsuoidTable[playID] ~= bllock_fishid and bllock_fishid ~= 0 then
      if self.bolsuoTable[playID] == true then
        self.playsuoidTable[playID] = 0
        self.bolsuoTable[playID] = false
        local fish = fishMap[self.playsuoidTable[playID]]
        if  fish ~= nil then
          lineTable[playID]:setVisible(false)
          suodinTable[playID]:setVisible(false)
          SuoFishTable[playID]:setVisible(false)
        end
      elseif  self.bolsuoTable[playID] == false then
        local fish = fishMap[bllock_fishid]
        if fish ~= nil then
          self.playsuoidTable[playID] = bllock_fishid
          lineTable[playID]:setVisible(true)
          suodinTable[playID]:setVisible(true)
          SuoFishTable[playID]:setVisible(true)
          SuoFishTable[playID]:lodTex(fish.fishKind)
          self.bolsuoTable[playID] = true
        end
      end
    end
  end
end

function GameScene:OnUserSuo()
  for i = 0,SeatNum - 1 do
    if self.bolsuoTable[i] == true then
      local fish = fishMap[self.playsuoidTable[i]]
      if fish ~= nil then
        local point = cc.p(fish:getPositionX(),fish:getPositionY())
        if point.x >= winwidth or point.x <= 0 or point.y >= winheight or point.y <= 0 then
          lineTable[i]:setVisible(false)
          suodinTable[i]:setVisible(false)
          SuoFishTable[i]:setVisible(false)
          self.playsuoidTable[i] = 0
          self.bolsuoTable[i] = false
        else
          lineTable[i]:setHig(point)
          suodinTable[i]:setPosition(point)
        end
      else
        self.playsuoidTable[i] = 0
        self.bolsuoTable[i] = false
        lineTable[i]:setVisible(false)
        suodinTable[i]:setVisible(false)
        SuoFishTable[i]:setVisible(false)
      end
    end
  end
end

function GameScene:onCatchFish(param)
  local fish_score = param.fish_score
  if param.fish_kind ~= 20 and param.fish_kind ~= 23 then
    soundManager:PlayGameEffect(2)
    soundManager:PlayFishEffect(param.fish_kind)
  end

  if (param.fish_kind >= 17 and param.fish_kind <= 20) or param.fish_kind >= 24 or param.fish_kind == 22 or param.fish_kind == 23 or param.fish_kind == 21 then
    soundManager:PlayGameEffect(4)
  end

  local playerid = param.chair_id
  local fish_id = param.fish_id
  local fish_kind = param.fish_kind
  if fish_kind == 21 then
    boodr = false

  elseif fish_kind == 23 or fish_kind == 22 or (fish_kind >= 30 and fish_kind <= 39) then
    local bingo = Bingo.new(fish_score)
    lablayer:addChild(bingo,200)
    if playerid == 0 or playerid == 1 or playerid == 6 then
      bingo:setPosition(self.paopointTable[playerid].x,self.paopointTable[playerid].y-150)
    elseif playerid == 2 or playerid == 3 or playerid == 7 then
      bingo:setPosition(self.paopointTable[playerid].x,self.paopointTable[playerid].y+150)
    elseif playerid == 4 then
      bingo:setPosition(self.paopointTable[playerid].x + 150,self.paopointTable[playerid].y)
      bingo:setRotation(90)
    elseif playerid == 5 then
      bingo:setPosition(self.paopointTable[playerid].x - 150,self.paopointTable[playerid].y)
      bingo:setRotation(-90)
    end
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_SHAKE_SCREEN)
  end

  local bullet_ion = param.bullet_ion
  if not global.g_mainPlayer:isInMatchRoom() then
    Vebull:LabSet(self.GoldTexTable[playerid+1],0,playerid,fish_score)
  else
    if fish_score and self.playnum > 0 then
      self.mathchFishScore[playerid+1] = fish_score + self.mathchFishScore[playerid+1]
      self.dicscore[playerid+1]:setString(tostring(self.mathchFishScore[playerid+1]))
    end
  end
  local point = cc.p(self.paotable[playerid+1]:getPositionX(),self.paotable[playerid+1]:getPositionY())
  if bullet_ion == 1 then
    bovder[playerid] = true  --双倍子弹
    self.doubTable[playerid]:setVisible(true)
    self.doubTable[playerid]:setTexter(1)
    self.paotable[playerid+1]:SetToSuperBarrel() --变成粒子炮
  elseif bullet_ion == 3 then
    if not global.g_mainPlayer:isInMatchRoom() then--比赛场不计免费子弹，要改成计算的去掉此判断即可
      freeve[playerid] = true  --免费子弹
      self.doubTable[playerid]:setVisible(true)
      self.doubTable[playerid]:setTexter(3)
    end
  end

  local fish = fishMap[fish_id]
  if not fish then
    return
  end

  --新增测试fish21的倍率是否一致
  if fish_kind == 20 then
    cclog("fish_score = %d,fish_rate = %d",fish_score,fish.rate)
  end

  local fx,fy = fish:getPosition()

  --处理自己的锁鱼
  local suofish = fishMap[lock_fishid]
  if suofish ~= nil then
    if fish_id == lock_fishid then
      lock_fishid = 0
      g_bolsuo = false
      lineTable[num]:setVisible(false)
      suodinTable[num]:setVisible(false)
      SuoFishTable[num]:setVisible(false)
      if actor == true then
        self.bolacser = true
      else
        self.bolacser = false
      end
    end
  end
  --处理别人的锁鱼
  for i = 0,SeatNum - 1 do
    if fish_id == self.playsuoidTable[i] then
      self.playsuoidTable[i] = 0
      self.bolsuoTable[i] = false
      lineTable[i]:setVisible(false)
      suodinTable[i]:setVisible(false)
      SuoFishTable[i]:setVisible(false)
    end
  end
  local point = cc.p(fish:getPositionX(),fish:getPositionY())
  for _, v in pairs(bulletMap) do
    if v.FishSuId == fish.fishID then
      v.FishSuId = 0
    end
  end
  local extra_rate = 0
  if fish_kind == 23  then
    self:CreateExlop(1,cc.p(fx,fy))
    extra_rate = Calculation:reFusBom(fish)
    for i = 1, #fish.bomfish do
      local fid = fish.bomfish[i]
      local bf = fishMap[fid]
      if bf.fishKind <= 23 then
        local x,y = bf:getPosition()
        self:GetDieFish(bf.fishKind + 1,x,y,bf:getRotation())
        ActionEx:createFlyCoins(bf.rate,cc.p(x,y),self.paopointTable[playerid],self.paotable[playerid+1].rotate)
      end

      bf:removeFromParent()
      fishMap[fid] = nil
    end
  elseif fish_kind == 22 then
    self:CreateExlop(0,cc.p(fx,fy))
    extra_rate = Calculation:reFusBB(fish,point,400,400)
    for i = 1, #fish.bomfish do
      local fid = fish.bomfish[i]
      local bf = fishMap[fid]
      if bf.fishKind <= 23 then
        local x,y = bf:getPosition()
        self:GetDieFish(bf.fishKind + 1,x,y,bf:getRotation())
        ActionEx:createFlyCoins(bf.rate,cc.p(x,y),self.paopointTable[playerid],self.paotable[playerid+1].rotate)
      end

      bf:removeFromParent()
      fishMap[fid] = nil
    end
  elseif fish_kind >= 30 and fish_kind <= 39 then
    extra_rate = Calculation:reFusBomFis(fish,fish.fishKind)
    self:GetDieFish(fish_kind - 30 + 1,fx,fy,fish:getRotation())
    for i = 1, #fish.bomfish do
      local fid = fish.bomfish[i]
      local bf = fishMap[fid]
      local x,y = bf:getPosition()
      self:GetDieFish(fish_kind - 30 + 1,x,y,bf:getRotation())
      local sd = ActionEx:createThunder(cc.p(x,y),cc.p(fx,fy),1)
      self:addChild(sd)
      bf:removeFromParent()
      fishMap[fid] = nil
    end
  elseif fish_kind == 21 then
    --self:CreateExlop(2,cc.p(fx,fy))
    Action:crDing(cc.p(fx,fy))
  else
    ActionEx:createFlyCoins(fish.rate,point,self.paopointTable[playerid],self.paotable[playerid+1].rotate)
  end
  --Action:SCo(point,fish_score)
  ActionEx:createDieFishScore(point,fish_score)

  if fish_kind <= 23 then
    self:GetDieFish(fish_kind+1,fx,fy,fish:getRotation())
  elseif fish_kind >= 24 and fish_kind <= 26 then
   -- cclog("fish.gTpye = %d",fish.gType)
    self:GetDieGroupFish(3,fish.gType+1,fx,fy,fish:getRotation())
  elseif fish_kind >= 27 and fish_kind <= 29 then
    self:GetDieGroupFish(4,fish.gType+1,fx,fy,fish:getRotation())
  end

  if playerid == self.playnum then
    self:CreateWinScoreItem(fish_score,fish.rate + extra_rate)
  end
  fishMap[fish_id] = nil
  --if fish.fishKind == 20 then isCreateFish21 = true end
  fish:removeFromParent()
  --fish:playac()
  --fish.boolfire = false
  self:checkGuide(param.chair_id)
end

function GameScene:CreateWinScoreItem(score,fishRate)
  if winScoreIndex >= 10 then return end
  local num = 3 + fishRate / 3
  if num > 20 then num = 20 end
  local color = winScoreIndex % 2
  local winItem = winCoinItem.new(score,num,color,winScoreIndex,self.winScoreID)

  if self.playnum ~= 4 and self.playnum ~= 5 then
    local y = -25
    if self.playnum == 0 or self.playnum == 1 or self.playnum == 6 then
      winItem:setRotation(180)
      y = 25
    end

    local pos = cc.p(80+winScoreIndex*25,y)
    pos.x = pos.x + self.paopointTable[self.playnum].x
    pos.y = pos.y + self.paopointTable[self.playnum].y
    winItem:setPosition(pos)
  elseif self.playnum == 4 then
    winItem:setRotation(90)
    local x = -25
    local pos = cc.p(x,winScoreIndex*25-150)
    pos.x = pos.x + self.paopointTable[self.playnum].x
    pos.y = pos.y + self.paopointTable[self.playnum].y
    winItem:setPosition(pos)
  elseif self.playnum == 5 then
    winItem:setRotation(-90)
    local x = 25
    local pos = cc.p(x,winScoreIndex*25-120)
    pos.x = pos.x + self.paopointTable[self.playnum].x
    pos.y = pos.y + self.paopointTable[self.playnum].y
    winItem:setPosition(pos)
  end

  self:addChild(winItem,5)
  winScoreIndex = winScoreIndex + 1
  self.winScoreVec[self.winScoreID] = winItem
  self.winScoreID = self.winScoreID + 1
  if self.winScoreID >= 10 then self.winScoreID = 0 end
end

function GameScene:winScoreItemUpdate(dt)
  if winScoreIndex == 1 then
    return
  end
  self.winScoreTimer = self.winScoreTimer + dt
  if self.winScoreTimer >= 0.8 then
    self.winScoreTimer = 0
    for k,v in pairs(self.winScoreVec) do
      v.index = v.index - 1
      if v.index == 0 then
        winScoreIndex = winScoreIndex - 1
      end
      local move
      if self.playnum ~= 4 and self.playnum ~= 5 then
        move = cc.MoveBy:create(0.1,cc.p(-25,0))
      elseif self.playnum ==4 or self.playnum == 5 then
        move = cc.MoveBy:create(0.1,cc.p(0,25))
      end
      local function endCall()
        if v.index == 0 then
          self.winScoreVec[v.id] = nil
          v:removeFromParent()
        end
      end
      local fun = cc.CallFunc:create(endCall)
      v:runAction(cc.Sequence:create(move,fun))
    end
  end
end

function GameScene:CreateExlop(exType,pos)
  local bomb = ActionEx:createBomb(bombFrameSet[exType],bombAnimSet[exType],pos)
  self:addChild(bomb,5)
  bomb:setScale(2.0)
end

function GameScene:GetDieGroupFish(num,gft,x,y,rot)
  local dFish = dieGroupFish.new(num,gft)
  dFish:setPosition(cc.p(x,y))
  dFish:setRotation(rot)
  self:addChild(dFish, 2)
  local function Endcallback()
    dFish:removeFromParent()
  end
  dFish:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(Endcallback)))
end

function GameScene:GetDieFish(ft,x,y,rot)
  local dFish = cc.Sprite:createWithSpriteFrameName(dfishFrameSet[ft])
  dFish:setRotation(rot)
  dFish:setPosition(cc.p(x,y))
  dFish:setScale(1.0)
  local anim = animateCache:getAnimation(d_fishAnimSet[ft].name)
  local animation = cc.Animate:create(anim)
  dFish:runAction(cc.RepeatForever:create(animation))
  local function Endcallback()
    dFish:removeFromParent()
  end
  local delaytime = ActionEx:getDieFishAnimRemainTime(ft)
  if delaytime < 1 then delaytime = 1 end
  dFish:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime),cc.CallFunc:create(Endcallback)))
  self:addChild(dFish,2)
end

function GameScene:onBulletIonTimeout(param)
  self.doubTable[param]:setVisible(false)
  if bovder[param] == true then
      self.paotable[param+1]:SetToNolmalBarrel()
  end
  bovder[param] = false  --双倍子弹判断
  freeve[param] = false  --免费子弹
end

function GameScene:onLockTimeout()
  boodr = true
end

--更改鱼的倍率
function GameScene:onHitFishLK(param)
  for k, v in pairs(fishMap) do
    if v.fishID == param.fish_id then
      v.rate = param.fish_multiple
    end
    if v.fishKind == 20 then
      v.rate = param.fish_multiple
      v.rateTex:setNumber(tostring(v.rate))
    end
  end
end

function GameScene:onSwitchScene(param)
  self:switch_scene(param)
end

function GameScene:switch_scene(param)
  self.bolFire = false
  self.scene_style_ = self.scene_style_ or 0
  self.scene_style_ = (self.scene_style_ + 1)%3
  local bg = cc.Sprite:create("buyu1/res/images/Scene/bg" .. (self.scene_style_ + 1) .. ".png")
  --local scalx = winwidth/bg:getContentSize().width
  --local scaly = winheight/bg:getContentSize().height
  bg:setAnchorPoint(cc.p(0,0))
  bg:setPosition(winwidth,0)
  --bg:setScaleX(scalx)
  --bg:setScaleY(scaly)
  self:addChild(bg, 4)

  local file = "buyu1/res/images/Scene/wave.png"
  local textur = cc.Director:getInstance():getTextureCache():addImage(tostring(file))
  local actab = {cc.rect(0,0,textur:getContentSize().width/2,textur:getContentSize().height),cc.rect(textur:getContentSize().width/2,0,textur:getContentSize().width/2,textur:getContentSize().height)}
  local spp = Action:creatsp(file,actab,0.28)
  spp:setAnchorPoint(cc.p(0.2,0))
  bg:addChild(spp)

  local function Endcallback()
      self:CloseScene()
      self:create_fish_matrix(param)
      bg:removeFromParent(true)
      self.bg:setTexture("buyu1/res/images/Scene/bg" .. (self.scene_style_ + 1) .. ".png")
      self.bolFire = true
      soundManager:PlayBackMusic()
  end
  local action = cc.MoveTo:create(6,cc.p(0,0))
  local funcall = cc.CallFunc:create(Endcallback)
  local seq = cc.Sequence:create(action,funcall)
  bg:runAction(seq)

  soundManager:StopBackMusic()
  soundManager:PlayGameEffect(6)
end

function GameScene:create_fish_matrix(param)

  if param.scene_kind == 0 then
    for i=0,param.fish_count-1 do
      local trace = FishFactory:get_scene_fish_trace(0, i)
      BoJFish:creaFish(param.fish_id[i+1], param.fish_kind[i+1], trace,2)
    end
  elseif param.scene_kind == 1 then
    for i=0,param.fish_count-1 do
      local trace = FishFactory:get_scene_fish_trace(1, i)
      local fish = BoJFish:creaFish(param.fish_id[i+1], param.fish_kind[i+1], trace,2)
      if i < 200 then
        local stop_index, stop_count = FishFactory:get_scene2_small_fish_stop(i)
        fish:SetFishStop(stop_index, stop_count)
      else
        local stop_index, stop_count = FishFactory:get_scene2_big_fish_stop()
        fish:SetFishStop(stop_index, stop_count)
      end
    end
  elseif param.scene_kind == 2 then
    for i=0,param.fish_count-1 do
      local trace = FishFactory:get_scene_fish_trace(2, i)
      BoJFish:creaFish(param.fish_id[i+1], param.fish_kind[i+1], trace,2)
    end
  elseif param.scene_kind == 3 then
    for i=0,param.fish_count-1 do
      local trace = FishFactory:get_scene_fish_trace(3, i)
      BoJFish:creaFish(param.fish_id[i+1], param.fish_kind[i+1], trace,2)
    end
  elseif param.scene_kind == 4 then
    for i=0,param.fish_count-1 do
      local trace = FishFactory:get_scene_fish_trace(4, i)
      BoJFish:creaFish(param.fish_id[i+1], param.fish_kind[i+1], trace,2)
    end
  end
end
--[[
function GameScene:Mask()
  self.Mask = Mask.new()

  self:addChild(self.Mask,5)
  self.Mask:setScale(0.5)
  self.Mask:fadeMask()
  self.Mask:setVisible(false)
end]]

function GameScene:GameSetting()
  self.Setupbtn = ccui.Button:create("buyu1/res/fishui/Setupbtn.png","buyu1/res/fishui/Setupbtn2.png")

  local function TouchSetup(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
            PopUpView.showPopUpView(GameSetting)
      end
  end
  self:addChild(self.Setupbtn,10)
  self.Setupbtn:setScale(0.6)
  self.Setupbtn:addTouchEventListener(TouchSetup)
  self.Setupbtn:setPosition(cc.p(1250,650))
end

function GameScene:number()
  self.goma = 10 --金钱倍率
  self.bopo = false   --  用于判断金币是否能够发射子弹
  cc.exports.actor = false  --  用于执行自动发射子弹
  self.bolfd = true --时间计算器
  self.DiTimer = 0.2 --定的时间设置
  self.buttnum = 0  --子弹样式
  cc.exports.frebool = false  --判断是否自动
  self.bolacser = false --是否自动查找锁鱼
  self.sertimer = 0  --时间间隔
  self.bolac = false --处理不停查找
  cc.exports.bullnum = 0
  cc.exports.g_bolsuo = false
  self.currTimer = os.time()
  cc.exports.g_bolchex = false

  cc.exports.bovder = { --双倍子弹判断
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
  }
  cc.exports.freeve = {--免费子弹
    [0] = false,
    [1] = false,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = false,
    [6] = false,
    [7] = false,
  }

  self.playsuoidTable = {
    [0] = 0,--0号玩家锁鱼ID
    [1] = 0,--1号玩家锁鱼ID
    [2] = 0,--2号玩家锁鱼ID
    [3] = 0,--3号玩家锁鱼ID
    [4] = 0,--0号玩家锁鱼ID
    [5] = 0,--1号玩家锁鱼ID
    [6] = 0,--2号玩家锁鱼ID
    [7] = 0,--3号玩家锁鱼ID
  }

  self.bolsuoTable = {
    [0] = false,--0号玩家是否锁鱼
    [1] = false,--1号玩家是否锁鱼
    [2] = false,--2号玩家是否锁鱼
    [3] = false,--3号玩家是否锁鱼
    [4] = false,--0号玩家是否锁鱼
    [5] = false,--1号玩家是否锁鱼
    [6] = false,--2号玩家是否锁鱼
    [7] = false,--3号玩家是否锁鱼
  }
end

--各类按钮创建函数
function GameScene:button()
  --减倍率
  local btnX1 = 0
  local btnX2 = 25
  if SeatNum == 8 then
    btnX1 = 50
    btnX2 = 175
  end
  local btid = self.playnum + 1
  local Redubtn1 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
  Redubtn1:setPosition(225-btnX1,winheight-21)
  self:addChild(Redubtn1,7)
  Redubtn1:setVisible(false)
  --加倍率
  local Plusbtn1 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
  Plusbtn1:setPosition(378-btnX1,winheight-21)
  self:addChild(Plusbtn1,7)
  Plusbtn1:setVisible(false)
  --减
  local Redubtn2 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
  Redubtn2:setPosition(879+btnX2,winheight-21)
  self:addChild(Redubtn2,7)
  Redubtn2:setVisible(false)
  --加
  local Plusbtn2 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
  Plusbtn2:setPosition(1033+btnX2,winheight-21)
  self:addChild(Plusbtn2,7)
  Plusbtn2:setVisible(false)

  --减
  local Redubtn3 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
  Redubtn3:setPosition(879+btnX2,21)
  self:addChild(Redubtn3,7)
  Redubtn3:setVisible(false)
  --加
  local Plusbtn3 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
  Plusbtn3:setPosition(1033+btnX2,21)
  self:addChild(Plusbtn3,7)
  Plusbtn3:setVisible(false)
  --减
  local Redubtn4 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
  Redubtn4:setPosition(225-btnX1,21)
  self:addChild(Redubtn4,7)
  Redubtn4:setVisible(false)
  --加
  local Plusbtn4 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
  Plusbtn4:setPosition(378-btnX1,21)
  self:addChild(Plusbtn4,7)
  Plusbtn4:setVisible(false)

  self.RedubtnTable = {}
  self.PlusbtnTable = {}
  table.insert(self.RedubtnTable,Redubtn1)
  table.insert(self.RedubtnTable,Redubtn2)
  table.insert(self.RedubtnTable,Redubtn3)
  table.insert(self.RedubtnTable,Redubtn4)
  table.insert(self.PlusbtnTable,Plusbtn1)
  table.insert(self.PlusbtnTable,Plusbtn2)
  table.insert(self.PlusbtnTable,Plusbtn3)
  table.insert(self.PlusbtnTable,Plusbtn4)

  if SeatNum >= 6 then
    local Redubtn5 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
    Redubtn5:setPosition(25,430)
    self:addChild(Redubtn5,7)
    Redubtn5:setRotation(90)
    Redubtn5:setVisible(false)
    --加倍率
    local Plusbtn5 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
    Plusbtn5:setPosition(25,280)
    self:addChild(Plusbtn5,7)
    Plusbtn5:setVisible(false)

    local Redubtn6 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
    Redubtn6:setPosition(1280-25,300)
    self:addChild(Redubtn6,7)
    Redubtn6:setVisible(false)
    Redubtn6:setRotation(90)
    --加
    local Plusbtn6 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
    Plusbtn6:setPosition(1280-25,420)
    self:addChild(Plusbtn6,7)
    Plusbtn6:setVisible(false)

    table.insert(self.RedubtnTable,Redubtn5)
    table.insert(self.RedubtnTable,Redubtn6)
    table.insert(self.PlusbtnTable,Plusbtn5)
    table.insert(self.PlusbtnTable,Plusbtn6)
  end

  if SeatNum == 8 then
    --减
    local Redubtn7 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
    Redubtn7:setPosition(640,winheight-21)
    self:addChild(Redubtn7,7)
    Redubtn7:setVisible(false)
    --加
    local Plusbtn7 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
    Plusbtn7:setPosition(758,winheight-21)
    self:addChild(Plusbtn7,7)
    Plusbtn7:setVisible(false)

    --减
    local Redubtn8 = ccui.Button:create("buyu1/res/fishui/Redu.png","buyu1/res/fishui/Redu2.png")
    Redubtn8:setPosition(250+390,21)
    self:addChild(Redubtn8,7)
    Redubtn8:setVisible(false)
    --加
    local Plusbtn8 = ccui.Button:create("buyu1/res/fishui/Plus.png","buyu1/res/fishui/Plus2.png")
    Plusbtn8:setPosition(353+415,21)
    self:addChild(Plusbtn8,7)
    Plusbtn8:setVisible(false)

    table.insert(self.RedubtnTable,Redubtn7)
    table.insert(self.RedubtnTable,Redubtn8)
    table.insert(self.PlusbtnTable,Plusbtn7)
    table.insert(self.PlusbtnTable,Plusbtn8)
  end
  ------

  for i=1,SeatNum do
    self.RedubtnTable[i]:setScale(0.7)
    self.PlusbtnTable[i]:setScale(0.7)
  end


  local dbtn = ccui.Helper:seekWidgetByName(self.ui,"Disabtn")
  local function onTouch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      GameScene.Rate:setVisible(false)
    end
  end
  dbtn:addTouchEventListener(onTouch)

  self.Autobtn = ccui.Button:create("buyu1/res/fishui/Auto.png","buyu1/res/fishui/Auto2.png")
  self:addChild(self.Autobtn,7)
  self.Autobtn:setScale(0.6)
  self.Autobtn:setVisible(true)
  local function onTouch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      if actor == false then
        actor = true
        self.actime = 0
        self.Autobtn:setOpacity(125)
      elseif actor == true then
        actor = false
        self.Autobtn:setOpacity(255)
      end
    end
  end
  self.Autobtn:addTouchEventListener(onTouch)

  self.Aimbtn = ccui.Button:create("buyu1/res/fishui/Aim.png","buyu1/res/fishui/Aim2.png")

  self:addChild(self.Aimbtn,7)
  self.Aimbtn:setScale(0.6)
  self.Aimbtn:setVisible(true)
  local function onTouch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      if not table.empty(fishMap) then
        Tesdis:AcSuoFish()
      end
    end
  end
  self.Aimbtn:addTouchEventListener(onTouch)

  self.Relievebtn = ccui.Button:create("buyu1/res/fishui/Relieve.png","buyu1/res/fishui/Relieve2.png")

  self:addChild(self.Relievebtn,7)
  self.Relievebtn:setScale(0.6)
  self.Relievebtn:setVisible(true)
  local function onTouch(sender, eventType)
    if eventType == ccui.TouchEventType.ended then
      if not table.empty(fishMap) then
        self.bollMO = Tesdis:ConSuoFish()
        g_bolsuo = false
      end
    end
  end
  self.Relievebtn:addTouchEventListener(onTouch)



  if self.billMO == true then
    self.bollMO = Tesdis:ConSuoFish()
  end
end

--触摸函数
function GameScene:touche()
  --触摸层
  self.layer  =  cc.LayerColor:create(cc.c4f(0,0,0,0))
  self:addChild(self.layer,3)
  local function onTouchBegin(touch,event)
    if g_score[self.playnum] > self.min_bullet_multiple then
      self.freetimernum = 0
    end
    self.is_touch_ = true
    self.last_touch_pos_ = touch:getLocation()
    --判断触摸锁定
    Tesdis:touSuo(self.last_touch_pos_,self.paoPoint)
    return true   ---触摸  发射
  end

  local function onTouchMoved(touch,event)
    if self.is_touch_ then
      if g_score[self.playnum] > self.min_bullet_multiple then
        self.freetimernum = 0
      end
    end
    self.last_touch_pos_ = touch:getLocation()
  end

  local function onTouchEnd( touch,event )
    self.last_touch_pos_ = touch:getLocation()
    self.is_touch_ = false
  end

  local  listener  =  cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(onTouchBegin,cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
  listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
  self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self.layer)
end

function GameScene:keySetRota(keyDir)  --1=l,2=r
  local rot = self.paotable[self.playnum+1]:getPaoRot()
  if rot >= 360 then rot = rot % 360 end
  --print(rot)
  local newrot = 0
  if self.playnum <= 1 then
    if keyDir == 1 then
      newrot = rot + 5
      if newrot > 270 then
        newrot = 270
      end
    else
      newrot = rot - 5
      if newrot < 90 then
        newrot = 90
      end
    end
  else
    if keyDir == 1 then
      newrot = rot - 5
      --if newrot < 0 then newrot  = newrot + 360 end
     -- print(newrot)
      if newrot < -90 then
        newrot = -90
      end
    else
      newrot = rot + 5
      --if newrot > 0 then newrot = newrot - 360 end
      if newrot > 90 then
        newrot = 90
      end
    end
  end
  --print(rot,newrot)

  self.paotable[self.playnum+1]:Rotation(newrot)
end

function GameScene:touchShoot( )
    if self.is_touch_ then
      if g_score[self.playnum] > self.min_bullet_multiple then
        self.currTimer = os.time()
      end
      -- if g_score[self.playnum] < self.goma and g_bolchex == false then
      --   g_bolchex = true
      --   local sett = Settle.new(g_protion)
      --   sett:setAnchorPoint(cc.p(0.5,0.5))
      --   sett:setPosition(winwidth/2,winheight/2)
      --   self:addChild(sett,100)
      --   return
      -- end
      if self.last_touch_pos_.y < winheight - 35 and self.last_touch_pos_.y > 35 then
        local deg = Tesdis:getRota(paoPoint,self.last_touch_pos_)
        local rota = deg * 180 / math.pi
        self.paotable[self.playnum+1]:Rotation(rota)
        --print(rota)
      else
        return
      end
    end
    if actor then return end
    --金币判断
    if bullnum >= 30 or g_score[self.playnum] >= 960000006 then
      return
    end
    if self.bolfd == true and self.is_touch_ then
      if g_score[self.playnum] == 0 then-- < self.goma then
        self.bopo = false
      elseif g_score[self.playnum] < self.goma then
        print("3=============")
        print("3============="..g_score[self.playnum])
        self.goma=g_score[self.playnum]
        self.bopo = true
        if self.goma >= 1000 and self.goma <= 9900 then
          if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(7)
          else
            self.paotable[self.playnum+1]:SwitchFrame(3)
          end
          self.buttnum = 2
        elseif self.goma >= 100 and self.goma < 1000 then
          if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(6)
          else
            self.paotable[self.playnum+1]:SwitchFrame(2)
          end
          self.buttnum = 1
        else
          if bovder[self.playnum] == true then
            self.paotable[self.playnum+1]:SwitchFrame(5)
          else
            self.paotable[self.playnum+1]:SwitchFrame(1)
          end
          self.buttnum = 0
        end
        self.paotable[self.playnum+1]:setRateNumber(self.goma)
        soundManager:PlayGameEffect(0) 
      else
        self.bopo = true
      end
      if self.bopo == true and self.bolFire == true and self.keyFirePressed == false then
        Vebull:CrBul(self.last_touch_pos_,self.paotable[self.playnum+1],self.buttnum,self.goma,self.playnum)
        self.bolfd = false
        self.ofiTime = 0
        --Vebull:LabSet(self.GoldTexTable[self.playnum+1],self.goma,self.playnum)
        self.paotable[self.playnum+1]:stop()
        self.paotable[self.playnum+1]:play()
        self.paotable[self.playnum+1]:addBlast()
      end
    end
end

function GameScene:KeyUpdate(dt)
  --炮管左转
  if self.keyLeftPressed == true then
      self.keyPressDT = self.keyPressDT + dt
      if self.keyPressDT >= 0.1 then
        self.keyPressDT = 0
        self:keySetRota(1)
      end
    end
  -- 炮管右转
  if self.keyRightPressed == true then
    self.keyPressDT = self.keyPressDT + dt
    if self.keyPressDT >= 0.1 then
      self.keyPressDT = 0
      self:keySetRota(2)
    end
  end

  --发炮
  if self.keyFirePressed == true then
    self.keyFireDT = self.keyFireDT + dt
    if self.keyFireDT >= self.DiTimer then
      self.keyFireDT = 0
      self:Auto_emission()
    end
  end

  --加分
  if self.keyUpPressed == true then
    self.keyUpDT = self.keyUpDT + dt
    if self.keyUpDT >= 0.1 then
      self.keyUpDT = 0
      self:addUnitBet()
    end
  end

  --减分
  if self.keyDownPressed == true then
    self.keyDownDT = self.keyDownDT + dt
    if self.keyDownDT >= 0.1 then
      self.keyDownDT = 0
      self:decUnitBet()
    end
  end

  --锁鱼
  if self.keySPressed == true then
    self.keySDT = self.keySDT + dt
    if self.keySDT >= 0.5 then
      self.keySDT = 0
      if not table.empty(fishMap) then
        Tesdis:AcSuoFish()
      end
    end
  end

end

--时间函数
function GameScene:Timer()
  local FirCs = FishMag.FirCs
  --local bulltRfish= Calculation.bulltRfish
  local pao = self.paotable[self.playnum+1]
  local backtime = 0


  self.schedulerID = scheduler:scheduleScriptFunc(function (dt)
    --震屏
    self:UpdateShakeScreen(dt)

    self:winScoreItemUpdate(dt)

    self:KeyUpdate(dt)

    self.actime = self.actime + dt
    if self.ofiTime ~= nil then
      self.ofiTime = self.ofiTime + dt
      if self.ofiTime >= 0.2 then
        self.bolfd = true
        self.ofiTime = nil
      end
    end
    local segment_fish = {{}, {}, {}, {},{}, {}, {}, {}}

    if (self.My_LTime and self.My_LTime == 0) and global.g_mainPlayer:isInMatchRoom() == true then
      self.Image_36:setVisible(true)
      backtime = backtime + dt
      self.endtime:setString(tostring(math.floor(18 - backtime)))
      if backtime >= 18 then
        if self.schedulerID then
          cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        end
        exit_buyu1()
      end
    elseif (self.My_LTime and self.My_LTime > 0) and global.g_mainPlayer:isInMatchRoom() == true then
      if g_score[self.playnum] <= 0 then
        backtime = backtime + dt
        if backtime >= 2 then
          self.Image_36:setVisible(true)
          self.endtime:setString(tostring(math.floor(20 - backtime)))
          if backtime >= 20 then
            if self.schedulerID then
              cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            end
            exit_buyu1()
          end
        end
      else
        backtime = 0
      end
    end

    if fishMap[lock_fishid] ~= nil then
      local suofish = fishMap[lock_fishid]
      local point = cc.p(suofish:getPositionX(),suofish:getPositionY())
      lineTable[num]:setHig(point)
      suodinTable[num]:setPosition(point)
      local deng = Tesdis:getRota(paoPoint,point)
      local rota = deng * 180 / math.pi
      pao:Rotation(rota)
      if point.x >= winwidth or point.x <= 0 or point.y >= winheight or point.y <= 0 then
        suofish.fishwidow = false
        g_bolsuo = false
        lineTable[num]:setVisible(false)
        suodinTable[num]:setVisible(false)
        SuoFishTable[num]:setVisible(false)
        for _, v in pairs(bulletMap) do
          if v.FishSuId == lock_fishid then
            v.FishSuId = 0
          end
        end
        lock_fishid = 0
        if actor == true then
          self.bolacser = true
        else
          self.bolacser = false
        end
      end
    else
      lineTable[num]:setVisible(false)
      suodinTable[num]:setVisible(false)
      SuoFishTable[num]:setVisible(false)
    end

    if self.bolacser == true then
      self.sertimer = self.sertimer + 1
      if self.sertimer >= 10 then
        self.sertimer = 0
        self.bolac = Tesdis:AcSuoFish()
        if self.bolac == true then
          self.bolacser = false
        end
      end
    end

    self:OnUserSuo()

    --鱼的管理
    for k in pairs(fishMap) do
      FirCs(FishMag, k,nil,nil,pao,dt, segment_fish)
    end
--[[
    --子弹管理操作
    for k, v in pairs(bulletMap) do
      bulltRfish(Calculation, dt,k,self.bom_width,self.bom_height, segment_fish)
    end]]

    --金币判断
    if g_score[self.playnum] <= 0 then--< self.goma then
      -- print("1=============")
      self.bopo = false
    elseif g_score[self.playnum] < self.goma then
      print("1==================")
      print("1=="..g_score[self.playnum])
      self.bopo = true
      self.goma=g_score[self.playnum]
      if self.goma >= 1000 and self.goma <= 9900 then
        if bovder[self.playnum] == true then
          self.paotable[self.playnum+1]:SwitchFrame(7)
        else
          self.paotable[self.playnum+1]:SwitchFrame(3)
        end
        self.buttnum = 2
      elseif self.goma >= 100 and self.goma < 1000 then
        if bovder[self.playnum] == true then
          self.paotable[self.playnum+1]:SwitchFrame(6)
        else
          self.paotable[self.playnum+1]:SwitchFrame(2)
        end
        self.buttnum = 1
      else
        if bovder[self.playnum] == true then
          self.paotable[self.playnum+1]:SwitchFrame(5)
        else
          self.paotable[self.playnum+1]:SwitchFrame(1)
        end
        self.buttnum = 0
      end
      self.paotable[self.playnum+1]:setRateNumber(self.goma)
      soundManager:PlayGameEffect(0)   
    else     
      self.bopo = true
    end


    --子弹射击
    self:touchShoot()

    self.freetimernum = self.freetimernum + dt
    if self.freetimernum >= 60 then
      self.freetimer:setString(tostring(self.rectime))
      self.freelayer:setVisible(true)
      self.rectime = 60 - math.floor(self.freetimernum - 60)
    else
      self.freelayer:setVisible(false)
    end
    if self.rectime <= 0 then
      if global.g_mainPlayer:isInMatchRoom() == false then
        global.g_mainPlayer:setPlayerScore(math.floor(g_score[num] * g_protion))
      end
      exit_buyu1()
    end

--[[
    if self.Mask.btimer == 1 then
      self.Mask.btimer = 0
      local move = cc.MoveBy:create(2,cc.p(10,0))
      local moveRev = move:reverse()
      self.Mask:runAction(cc.RepeatForever:create(cc.Sequence:create(move,moveRev)))
    elseif self.Mask.btimer == 2 then
      self.Mask:stopAllActions()
      if self.playnum == 5 then
        self.Mask:setPosition(50,winheight-150)
      else
        self.Mask:setPosition(winwidth-50,winheight-150)
      end
      self.Mask:setScale(0.5)
    end]]

    for i = 0,SeatNum - 1 do
      if g_score[i] >= 960000006 and self.bolmaTable[i] == false then
        self.blamaTable[i]:setVisible(true)
        local action = cc.Blink:create(3,10)
        self.blamaTable[i]:runAction(cc.RepeatForever:create(action))
        self.bolmaTable[i] = true
      elseif g_score[i] < 960000006 and self.bolmaTable[i] == true then
        self.blamaTable[i]:stopAllActions()
        self.blamaTable[i]:setVisible(false)
        self.bolmaTable[i] = false
      end
    end

    local nowTime = os.time()
    if nowTime - self.currTimer >= 121 then
      if global.g_mainPlayer:isInMatchRoom() == false then
        global.g_mainPlayer:setPlayerScore(math.floor(g_score[num] * g_protion))
      end
      WarnTips.showTips(
        {
          text = "游戏超时,请重新进入游戏!",
          style = WarnTips.STYLE_Y,
          confirm = function()
              exit_buyu1()
              netmng.gsClose()
              -- local layer = createObj(hall_scene_t)
              -- replaceScene(layer:getCCScene(),layer)
              replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
            end
        }
      )
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    end

    --自动子弹
    if self.actime >= self.DiTimer and self.bopo == true and self.bolFire == true and bullnum <= 30
      and g_score[self.playnum] < 960000006 and self.keyFirePressed == false then
      -- if g_bolsuo == true then
      --   self:Auto_emission()
      --   return
      -- end
      if actor == true then
        self:Auto_emission()
      end
    end

  end, 0, false)
end

function GameScene:onExitHandler()

  if self.spawn_scheduler_id_ then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.spawn_scheduler_id_)
    self.spawn_scheduler_id_ = nil
  end
  if self.schedul1 ~= nil then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul1)
    self.schedul1 = nil
  end

  if self.schedul2 then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul2)
    self.schedul2 = nil
  end

  if self.schedulerID then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
    self.schedulerID = nil
  end

  -- self:removeMsgHandler()
  self.factory_:Stop()
  lock_fishid = 0

  for k, v in pairs(bulletMap) do
    v:removeFromParent()

    bulletMap[k] = nil
  end

  for k, v in pairs(fishMap) do
    v:removeFromParent()

    fishMap[k] = nil
  end

  if self.ui then
    self.ui:removeFromParent()
    self.ui = nil
  end
  bovder = false
  freeve = false
  boodr = true

  g_score = {}
  lineTable = {}
  suodinTable = {}
  SuoFishTable = {}
  g_gold = {}
  g_bolsuo = false
  g_protion = nil
  g_bolchex = false
end

--UI创建函数
function GameScene:CreaUi()
  local ptX1 = 299
  local ptX2 = 299

  local ptScale = 1.2

  if SeatNum == 8 then
    ptX1 = 249
    ptX2 = 149
    ptScale = 1
  end
  self.pao1 = Pao.new()
  self.pao1:setRsc()
  self.pao1:Rotation(180)
  self.paoLayer:addChild(self.pao1,4)
  self.pao1:setPosition(cc.p(ptX1,winheight-30))
  self.pao1:setPoint(cc.p(ptX1,winheight-30))
  self.pao1:setVisible(false)  --隐藏
  self.PT1 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
  self.paoLayer:addChild(self.PT1,3)
  self.PT1:setPosition(cc.p(ptX1,winheight-40))
  self.PT1:setScale(ptScale,-ptScale)
  self.PT1:setVisible(false)
  local pRound1 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
  self.PT1:addChild(pRound1,2)
  pRound1:setPosition(cc.p(85,15))


  self.pao2 = Pao.new()
  self.pao2:setRsc()
  self.pao2:Rotation(180)
  self.paoLayer:addChild(self.pao2,4)
  self.pao2:setPosition(cc.p(winwidth-ptX2,winheight-30))
  self.pao2:setPoint(cc.p(winwidth-ptX2,winheight-30))
  self.pao2:setVisible(false)  --隐藏
  self.PT2 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
  self.paoLayer:addChild(self.PT2,3)
  self.PT2:setPosition(cc.p(winwidth-ptX2,winheight-40))
  self.PT2:setScale(ptScale,-ptScale)
  self.PT2:setVisible(false)
  local pRound2 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
  self.PT2:addChild(pRound2,2)
  pRound2:setPosition(cc.p(85,15))


  self.pao3 = Pao.new()
  self.paoLayer:addChild(self.pao3,4)
  self.pao3:setPosition(cc.p(winwidth-ptX2,30))
  self.pao3:setPoint(cc.p(winwidth-ptX2,30))
  self.pao3:setVisible(false)  --隐藏
  self.PT3 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
  self.paoLayer:addChild(self.PT3,3)
  self.PT3:setPosition(cc.p(winwidth-ptX2,40))
  self.PT3:setVisible(false)
  local pRound3 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
  self.PT3:addChild(pRound3,2)
  self.PT3:setScale(ptScale,ptScale)
  pRound3:setPosition(cc.p(85,15))

  self.pao4 = Pao.new()
  self.paoLayer:addChild(self.pao4,4)
  self.pao4:setPosition(cc.p(ptX1,30))
  self.pao4:setPoint(cc.p(ptX1,30))
  self.pao4:setVisible(false)  --隐藏
  self.PT4 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
  self.paoLayer:addChild(self.PT4,3)
  self.PT4:setPosition(cc.p(ptX1,40))
  self.PT4:setVisible(false)
  local pRound4 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
  self.PT4:addChild(pRound4,2)
  self.PT4:setScale(ptScale,ptScale)
  pRound4:setPosition(cc.p(85,15))

  if SeatNum >= 6 then
    --5
    self.pao5 = Pao.new()
    self.paoLayer:addChild(self.pao5,4)
    self.pao5:setPosition(cc.p(30,360))
    self.pao5:setPoint(cc.p(30,360))
    self.pao5:setVisible(false)  --隐藏
    self.pao5:setRateNumRot(90,-20,20)
    self.PT5 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
    self.paoLayer:addChild(self.PT5,3)
    self.PT5:setPosition(cc.p(40,360))
    self.PT5:setRotation(90)
    self.PT5:setVisible(false)
    local pRound5 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
    self.PT5:addChild(pRound5,2)
    self.PT5:setScale(ptScale,ptScale)
    pRound5:setPosition(cc.p(85,15))

  --6
    self.pao6 = Pao.new()
    self.pao5:Rotation(-90)
    self.paoLayer:addChild(self.pao6,4)
    self.pao6:setPosition(cc.p(1250,360))
    self.pao6:setPoint(cc.p(1250,360))
    self.pao6:setVisible(false)  --隐藏
    self.pao6:setRateNumRot(-90,25,20)
    self.PT6 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
    self.paoLayer:addChild(self.PT6,3)
    self.PT6:setPosition(cc.p(1250,360))
    self.PT6:setRotation(-90)
    self.PT6:setVisible(false)
    local pRound6 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
    self.PT6:addChild(pRound6,2)
    self.PT6:setScale(ptScale,ptScale)
    pRound6:setPosition(cc.p(85,15))
  end

  if SeatNum  == 8 then
  --7
    self.pao7 = Pao.new()
    self.pao7:setRsc()
    self.pao7:Rotation(180)
    self.paoLayer:addChild(self.pao7,4)
    self.pao7:setPosition(cc.p(699,winheight-30))
    self.pao7:setPoint(cc.p(699,winheight-30))
    self.pao7:setVisible(false)  --隐藏


    self.PT7 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
    self.paoLayer:addChild(self.PT7,3)
    self.PT7:setPosition(cc.p(699,winheight-40))
    self.PT7:setScale(ptScale,-ptScale)
    self.PT7:setVisible(false)

    local pRound7 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
    self.PT7:addChild(pRound7,2)
    pRound7:setPosition(cc.p(85,15))

  --8
    self.pao8 = Pao.new()
    self.paoLayer:addChild(self.pao8,4)
    self.pao8:setPosition(cc.p(699,30))
    self.pao8:setPoint(cc.p(699,30))
    self.pao8:setVisible(false)  --隐藏


    self.PT8 = cc.Sprite:createWithSpriteFrameName("XY_Base_00.png")
    self.paoLayer:addChild(self.PT8,3)
    self.PT8:setPosition(cc.p(699,40))
    self.PT8:setScale(ptScale,ptScale)
    self.PT8:setVisible(false)

    local pRound8 = cc.Sprite:createWithSpriteFrameName("XY_pRound.png")
    self.PT8:addChild(pRound8,2)
    pRound8:setPosition(cc.p(85,15))
  end


  self.paotable = {}
  self.PTTable = {}
  table.insert(self.paotable,self.pao1)
  table.insert(self.paotable,self.pao2)
  table.insert(self.paotable,self.pao3)
  table.insert(self.paotable,self.pao4)
  table.insert(self.PTTable,self.PT1)
  table.insert(self.PTTable,self.PT2)
  table.insert(self.PTTable,self.PT3)
  table.insert(self.PTTable,self.PT4)

  if SeatNum >= 6 then
    table.insert(self.paotable,self.pao5)
    table.insert(self.paotable,self.pao6)
    table.insert(self.PTTable,self.PT5)
    table.insert(self.PTTable,self.PT6)
  end

  if SeatNum == 8 then
    table.insert(self.paotable,self.pao7)
    table.insert(self.paotable,self.pao8)
    table.insert(self.PTTable,self.PT7)
    table.insert(self.PTTable,self.PT8)
  end

  for i=1,SeatNum do
    self.paotable[i]:setScale(ptScale)
    self.paotable[i]:ResetRateNumerPosition(i)
  end


  self.GoldTexTable = {}
  self.scoretexTab = {}
  self.PlayNameTable = {}
  self.baseTable = {}
  self.paopointTable = {}
  self.GoldTex1 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex1")
  self.GoldTex2 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex2")
  self.GoldTex3 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex3")
  self.GoldTex4 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex4")

  self.ScoreTex1 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex1")
  self.ScoreTex2 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex2")
  self.ScoreTex3 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex3")
  self.ScoreTex4 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex4")
  table.insert(self.GoldTexTable,self.GoldTex1)
  table.insert(self.GoldTexTable,self.GoldTex2)
  table.insert(self.GoldTexTable,self.GoldTex3)
  table.insert(self.GoldTexTable,self.GoldTex4)

  table.insert(self.scoretexTab,self.ScoreTex1)
  table.insert(self.scoretexTab,self.ScoreTex2)
  table.insert(self.scoretexTab,self.ScoreTex3)
  table.insert(self.scoretexTab,self.ScoreTex4)

  local Botfr6 = ccui.Helper:seekWidgetByName(self.ui,"Botfr6")
  Botfr6:setVisible(false)
  local Botfr4 = ccui.Helper:seekWidgetByName(self.ui,"Botfr4")
  Botfr4:setVisible(false)
  local Botfr2 = ccui.Helper:seekWidgetByName(self.ui,"Botfr2")
  Botfr2:setVisible(false)
  local Botfr8 = ccui.Helper:seekWidgetByName(self.ui,"Botfr8")
  Botfr8:setVisible(false)

  self.PlayName1 = ccui.Helper:seekWidgetByName(self.ui,"PlayName1")
  self.PlayName2 = ccui.Helper:seekWidgetByName(self.ui,"PlayName2")
  self.PlayName3 = ccui.Helper:seekWidgetByName(self.ui,"PlayName3")
  self.PlayName4 = ccui.Helper:seekWidgetByName(self.ui,"PlayName4")
  table.insert(self.PlayNameTable,self.PlayName1)
  table.insert(self.PlayNameTable,self.PlayName2)
  table.insert(self.PlayNameTable,self.PlayName3)
  table.insert(self.PlayNameTable,self.PlayName4)

  local Battery1 = ccui.Helper:seekWidgetByName(self.ui,"Battery1")
  Battery1:setVisible(false)  --隐藏
  local Battery2 = ccui.Helper:seekWidgetByName(self.ui,"Battery2")
  Battery2:setVisible(false)  --隐藏
  local Battery3 = ccui.Helper:seekWidgetByName(self.ui,"Battery3")
  Battery3:setVisible(false)  --隐藏
  local Battery4 = ccui.Helper:seekWidgetByName(self.ui,"Battery4")
  Battery4:setVisible(false)  --隐藏
  table.insert(self.baseTable,Battery1)
  table.insert(self.baseTable,Battery2)
  table.insert(self.baseTable,Battery3)
  table.insert(self.baseTable,Battery4)

  table.insert(self.paopointTable,0,cc.p(self.paotable[1]:getPositionX(),self.paotable[1]:getPositionY()))
  table.insert(self.paopointTable,1,cc.p(self.paotable[2]:getPositionX(),self.paotable[2]:getPositionY()))
  table.insert(self.paopointTable,2,cc.p(self.paotable[3]:getPositionX(),self.paotable[3]:getPositionY()))
  table.insert(self.paopointTable,3,cc.p(self.paotable[4]:getPositionX(),self.paotable[4]:getPositionY()))

  self.lockline1 = LockLine.new(self.paopointTable[0])
  lablayer:addChild(self.lockline1,2)
  self.lockline1:setVisible(false)  --隐藏

  self.lockline2 = LockLine.new(self.paopointTable[1])
  lablayer:addChild(self.lockline2,2)
  self.lockline2:setVisible(false)  --隐藏

  self.lockline3 = LockLine.new(self.paopointTable[2])
  lablayer:addChild(self.lockline3,2)
  self.lockline3:setVisible(false)  --隐藏

  self.lockline4 = LockLine.new(self.paopointTable[3])
  lablayer:addChild(self.lockline4,2)
  self.lockline4:setVisible(false)  --隐藏

  cc.exports.lineTable = {}
  table.insert(lineTable,0,self.lockline1)
  table.insert(lineTable,1,self.lockline2)
  table.insert(lineTable,2,self.lockline3)
  table.insert(lineTable,3,self.lockline4)

  self.suodin1 = SuDin.new(0)
  lablayer:addChild(self.suodin1,0)
  self.suodin1:setVisible(false)
  self.suodin2 = SuDin.new(1)
  lablayer:addChild(self.suodin2,0)
  self.suodin2:setVisible(false)
  self.suodin3 = SuDin.new(2)
  lablayer:addChild(self.suodin3,0)
  self.suodin3:setVisible(false)
  self.suodin4 = SuDin.new(3)
  lablayer:addChild(self.suodin4,0)
  self.suodin4:setVisible(false)
  cc.exports.suodinTable = {}
  table.insert(suodinTable,0,self.suodin1)
  table.insert(suodinTable,1,self.suodin2)
  table.insert(suodinTable,2,self.suodin3)
  table.insert(suodinTable,3,self.suodin4)
  self.suoFish1 = SuoFish.new()
  lablayer:addChild(self.suoFish1,1)
  self.suoFish1:setPosition(self.paopointTable[0].x-100,self.paopointTable[0].y-150)
  self.suoFish1:setVisible(false)
  self.honbo1 = cc.Sprite:create("buyu1/res/hobo.png")
  self.honbo1:setPosition(self.paopointTable[0].x-100,self.paopointTable[0].y-150)
  self.honbo1:setScale(0.8)
  self.honbo1:setScaleY(-0.8)
  self:addChild(self.honbo1,20)
  self.hoscor1 = ScoreLab.new()
  self.hoscor1:setS(tostring(50000))
  self.hoscor1:setPosition(self.paopointTable[0].x-100,self.paopointTable[0].y-180)
  self:addChild(self.hoscor1,21)
  self.suoFish2 = SuoFish.new()
  lablayer:addChild(self.suoFish2,1)
  self.suoFish2:setPosition(self.paopointTable[1].x-100,self.paopointTable[1].y-150)
  self.suoFish2:setVisible(false)
  self.honbo2 = cc.Sprite:create("buyu1/res/hobo.png")
  self.honbo2:setPosition(self.paopointTable[1].x-100,self.paopointTable[1].y-150)
  self.honbo2:setScale(0.8)
  self.honbo2:setScaleY(-0.8)
  self:addChild(self.honbo2,20)
  self.hoscor2 = ScoreLab.new()
  self.hoscor2:setS(tostring(50000))
  self.hoscor2:setPosition(self.paopointTable[1].x-100,self.paopointTable[1].y-180)
  self:addChild(self.hoscor2,21)
  self.suoFish3 = SuoFish.new()
  lablayer:addChild(self.suoFish3,1)
  self.suoFish3:setPosition(self.paopointTable[2].x-100,self.paopointTable[2].y+150)
  self.suoFish3:setVisible(false)
  self.honbo3 = cc.Sprite:create("buyu1/res/hobo.png")
  self.honbo3:setPosition(self.paopointTable[2].x-100,self.paopointTable[2].y+150)
  self.honbo3:setScale(0.8)
  self:addChild(self.honbo3,20)
  self.hoscor3 = ScoreLab.new()
  self.hoscor3:setS(tostring(50000))
  self.hoscor3:setPosition(self.paopointTable[2].x-100,self.paopointTable[2].y+180)
  self:addChild(self.hoscor3,21)
  self.suoFish4 = SuoFish.new()
  lablayer:addChild(self.suoFish4,1)
  self.suoFish4:setPosition(self.paopointTable[3].x-100,self.paopointTable[3].y+150)
  self.suoFish4:setVisible(false)
  self.honbo4 = cc.Sprite:create("buyu1/res/hobo.png")
  self.honbo4:setPosition(self.paopointTable[3].x-100,self.paopointTable[3].y+150)
  self.honbo4:setScale(0.8)
  self:addChild(self.honbo4,20)
  self.hoscor4 = ScoreLab.new()
  self.hoscor4:setS(tostring(50000))
  self.hoscor4:setPosition(self.paopointTable[3].x-100,self.paopointTable[3].y+180)
  self:addChild(self.hoscor4,21)

  cc.exports.SuoFishTable = {}
  table.insert(SuoFishTable,0,self.suoFish1)
  table.insert(SuoFishTable,1,self.suoFish2)
  table.insert(SuoFishTable,2,self.suoFish3)
  table.insert(SuoFishTable,3,self.suoFish4)

  self.honbotab = {}
  table.insert(self.honbotab,0,self.honbo1)
  table.insert(self.honbotab,1,self.honbo2)
  table.insert(self.honbotab,2,self.honbo3)
  table.insert(self.honbotab,3,self.honbo4)
  self.hoscortab = {}
  table.insert(self.hoscortab,0,self.hoscor1)
  table.insert(self.hoscortab,1,self.hoscor2)
  table.insert(self.hoscortab,2,self.hoscor3)
  table.insert(self.hoscortab,3,self.hoscor4)

  self.doub1 = Douvery.new()
  lablayer:addChild(self.doub1,1)
  self.doub1:setPosition(self.paopointTable[0].x+100,self.paopointTable[0].y-150)
  self.doub1:setVisible(false)
  self.doub2 = Douvery.new()
  lablayer:addChild(self.doub2,1)
  self.doub2:setPosition(self.paopointTable[1].x+100,self.paopointTable[1].y-150)
  self.doub2:setVisible(false)
  self.doub3 = Douvery.new()
  lablayer:addChild(self.doub3,1)
  self.doub3:setPosition(self.paopointTable[2].x+100,self.paopointTable[2].y+150)
  self.doub3:setVisible(false)
  self.doub4 = Douvery.new()
  lablayer:addChild(self.doub4,1)
  self.doub4:setPosition(self.paopointTable[3].x+100,self.paopointTable[3].y+150)
  self.doub4:setVisible(false)
  self.doubTable = {}
  table.insert(self.doubTable,0,self.doub1)
  table.insert(self.doubTable,1,self.doub2)
  table.insert(self.doubTable,2,self.doub3)
  table.insert(self.doubTable,3,self.doub4)

  self.blama1 = cc.Sprite:create("buyu1/res/Blama.png")
  self.blama1:setPosition(self.paopointTable[0].x+170,self.paopointTable[0].y-60)
  lablayer:addChild(self.blama1,200)
  self.blama2 = cc.Sprite:create("buyu1/res/Blama.png")
  self.blama2:setPosition(self.paopointTable[1].x+170,self.paopointTable[1].y-60)
  lablayer:addChild(self.blama2,200)
  self.blama3 = cc.Sprite:create("buyu1/res/Blama.png")
  self.blama3:setPosition(self.paopointTable[2].x+170,self.paopointTable[2].y+60)
  lablayer:addChild(self.blama3,200)
  self.blama4 = cc.Sprite:create("buyu1/res/Blama.png")
  self.blama4:setPosition(self.paopointTable[3].x+170,self.paopointTable[3].y+60)
  lablayer:addChild(self.blama4,200)
  self.blamaTable = {}
  table.insert(self.blamaTable,0,self.blama1)
  table.insert(self.blamaTable,1,self.blama2)
  table.insert(self.blamaTable,2,self.blama3)
  table.insert(self.blamaTable,3,self.blama4)
  self.bolmaTable = {}
  table.insert(self.bolmaTable,0,false)
  table.insert(self.bolmaTable,1,false)
  table.insert(self.bolmaTable,2,false)
  table.insert(self.bolmaTable,3,false)

  if SeatNum >= 6 then
    self.GoldTex5 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex5")
    self.GoldTex6 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex6")
    table.insert(self.GoldTexTable,self.GoldTex5)
    table.insert(self.GoldTexTable,self.GoldTex6)

    self.ScoreTex5 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex5")
    self.ScoreTex6 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex6")
    table.insert(self.scoretexTab,self.ScoreTex5)
    table.insert(self.scoretexTab,self.ScoreTex6)

    local Botfr10 = ccui.Helper:seekWidgetByName(self.ui,"Botfr10")
    Botfr10:setVisible(false)
    local Botfr12 = ccui.Helper:seekWidgetByName(self.ui,"Botfr12")
    Botfr12:setVisible(false)

    self.PlayName5 = ccui.Helper:seekWidgetByName(self.ui,"PlayName5")
    self.PlayName6 = ccui.Helper:seekWidgetByName(self.ui,"PlayName6")
    table.insert(self.PlayNameTable,self.PlayName5)
    table.insert(self.PlayNameTable,self.PlayName6)

    local Battery5 = ccui.Helper:seekWidgetByName(self.ui,"Battery5")
    Battery5:setVisible(false)  --隐藏
    local Battery6 = ccui.Helper:seekWidgetByName(self.ui,"Battery6")
    Battery6:setVisible(false)  --隐藏
    table.insert(self.baseTable,Battery5)
    table.insert(self.baseTable,Battery6)

    table.insert(self.paopointTable,4,cc.p(self.paotable[5]:getPositionX(),self.paotable[5]:getPositionY()))
    table.insert(self.paopointTable,5,cc.p(self.paotable[6]:getPositionX(),self.paotable[6]:getPositionY()))

    self.lockline5 = LockLine.new(self.paopointTable[4])
    lablayer:addChild(self.lockline5,2)
    self.lockline5:setVisible(false)  --隐藏
    self.lockline6 = LockLine.new(self.paopointTable[5])
    lablayer:addChild(self.lockline6,2)
    self.lockline6:setVisible(false)  --隐藏
    table.insert(lineTable,4,self.lockline5)
    table.insert(lineTable,5,self.lockline6)

    self.suodin5 = SuDin.new(4)
    lablayer:addChild(self.suodin5,0)
    self.suodin5:setVisible(false)
    self.suodin6 = SuDin.new(5)
    lablayer:addChild(self.suodin6,0)
    self.suodin6:setVisible(false)
    table.insert(suodinTable,4,self.suodin5)
    table.insert(suodinTable,5,self.suodin6)
    ---------------------
    self.suoFish5 = SuoFish.new()
    lablayer:addChild(self.suoFish5,1)
    self.suoFish5:setPosition(self.paopointTable[4].x+100,self.paopointTable[4].y+150)
    self.suoFish5:setVisible(false)
    self.suoFish5:setRotation(90)
    self.honbo5 = cc.Sprite:create("buyu1/res/hobo.png")
    self.honbo5:setPosition(self.paopointTable[4].x-100,self.paopointTable[4].y-150)
    self.honbo5:setScale(0.8)
    self.honbo5:setScaleY(-0.8)
    self:addChild(self.honbo5,20)
    self.hoscor5 = ScoreLab.new()
    self.hoscor5:setS(tostring(50000))
    self.hoscor5:setPosition(self.paopointTable[4].x-100,self.paopointTable[4].y-180)
    self:addChild(self.hoscor5,21)
  ------------------
    self.suoFish6 = SuoFish.new()
    lablayer:addChild(self.suoFish6,1)
    self.suoFish6:setPosition(self.paopointTable[5].x-100,self.paopointTable[5].y+150)
    self.suoFish6:setVisible(false)
    self.suoFish6:setRotation(-90)
    self.honbo6 = cc.Sprite:create("buyu1/res/hobo.png")
    self.honbo6:setPosition(self.paopointTable[5].x-100,self.paopointTable[5].y-150)
    self.honbo6:setScale(0.8)
    self.honbo6:setScaleY(-0.8)
    self:addChild(self.honbo6,20)
    self.hoscor6 = ScoreLab.new()
    self.hoscor6:setS(tostring(50000))
    self.hoscor6:setPosition(self.paopointTable[5].x-100,self.paopointTable[5].y-180)
    self:addChild(self.hoscor6,21)
    table.insert(SuoFishTable,4,self.suoFish5)
    table.insert(SuoFishTable,5,self.suoFish6)
    table.insert(self.honbotab,4,self.honbo5)
    table.insert(self.honbotab,5,self.honbo6)
    table.insert(self.hoscortab,4,self.hoscor5)
    table.insert(self.hoscortab,5,self.hoscor6)

    self.doub5 = Douvery.new()
    lablayer:addChild(self.doub5,1)
    self.doub5:setPosition(self.paopointTable[4].x+100,self.paopointTable[4].y-150)
    self.doub5:setVisible(false)
    self.doub5:setRotation(90)
    self.doub6 = Douvery.new()
    lablayer:addChild(self.doub6,1)
    self.doub6:setPosition(self.paopointTable[5].x-100,self.paopointTable[5].y-150)
    self.doub6:setVisible(false)
    self.doub6:setRotation(-90)
    table.insert(self.doubTable,4,self.doub5)
    table.insert(self.doubTable,5,self.doub6)

    self.blama5 = cc.Sprite:create("buyu1/res/Blama.png")
    self.blama5:setPosition(self.paopointTable[4].x+170,self.paopointTable[4].y-60)
    lablayer:addChild(self.blama5,200)
    self.blama6 = cc.Sprite:create("buyu1/res/Blama.png")
    self.blama6:setPosition(self.paopointTable[5].x+170,self.paopointTable[5].y-60)
    lablayer:addChild(self.blama6,200)
    table.insert(self.blamaTable,4,self.blama5)
    table.insert(self.blamaTable,5,self.blama6)
    table.insert(self.bolmaTable,4,false)
    table.insert(self.bolmaTable,5,false)
  end
  if SeatNum == 8 then
    self.GoldTex7 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex7")
    self.GoldTex8 = ccui.Helper:seekWidgetByName(self.ui,"GoldTex8")
    table.insert(self.GoldTexTable,self.GoldTex7)
    table.insert(self.GoldTexTable,self.GoldTex8)

    self.ScoreTex7 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex7")
    self.ScoreTex8 = ccui.Helper:seekWidgetByName(self.ui,"ScoreTex8")
    table.insert(self.scoretexTab,self.ScoreTex7)
    table.insert(self.scoretexTab,self.ScoreTex8)

    local Botfr14 = ccui.Helper:seekWidgetByName(self.ui,"Botfr14")
    Botfr14:setVisible(false)
    local Botfr16 = ccui.Helper:seekWidgetByName(self.ui,"Botfr16")
    Botfr16:setVisible(false)

    self.PlayName7 = ccui.Helper:seekWidgetByName(self.ui,"PlayName7")
    self.PlayName8 = ccui.Helper:seekWidgetByName(self.ui,"PlayName8")
    table.insert(self.PlayNameTable,self.PlayName7)
    table.insert(self.PlayNameTable,self.PlayName8)

    local Battery7 = ccui.Helper:seekWidgetByName(self.ui,"Battery7")
    Battery7:setVisible(false)  --隐藏
    local Battery8 = ccui.Helper:seekWidgetByName(self.ui,"Battery8")
    Battery8:setVisible(false)  --隐藏
    table.insert(self.baseTable,Battery7)
    table.insert(self.baseTable,Battery8)

    table.insert(self.paopointTable,6,cc.p(self.paotable[7]:getPositionX(),self.paotable[7]:getPositionY()))
    table.insert(self.paopointTable,7,cc.p(self.paotable[8]:getPositionX(),self.paotable[8]:getPositionY()))

    self.lockline7 = LockLine.new(self.paopointTable[6])
    lablayer:addChild(self.lockline7,2)
    self.lockline7:setVisible(false)  --隐藏
    self.lockline8 = LockLine.new(self.paopointTable[7])
    lablayer:addChild(self.lockline8,2)
    self.lockline8:setVisible(false)  --隐藏
    table.insert(lineTable,6,self.lockline7)
    table.insert(lineTable,7,self.lockline8)

    self.suodin7 = SuDin.new(6)
    lablayer:addChild(self.suodin7,0)
    self.suodin7:setVisible(false)
    self.suodin8 = SuDin.new(7)
    lablayer:addChild(self.suodin8,0)
    self.suodin8:setVisible(false)
    table.insert(suodinTable,6,self.suodin7)
    table.insert(suodinTable,7,self.suodin8)
    self.suoFish7 = SuoFish.new()
    lablayer:addChild(self.suoFish7,1)
    self.suoFish7:setPosition(self.paopointTable[6].x-100,self.paopointTable[6].y+150)
    self.suoFish7:setVisible(false)
    self.honbo7 = cc.Sprite:create("buyu1/res/hobo.png")
    self.honbo7:setPosition(self.paopointTable[6].x-100,self.paopointTable[6].y+150)
    self.honbo7:setScale(0.8)
    self:addChild(self.honbo7,20)
    self.hoscor7 = ScoreLab.new()
    self.hoscor7:setS(tostring(50000))
    self.hoscor7:setPosition(self.paopointTable[6].x-100,self.paopointTable[6].y+180)
    self:addChild(self.hoscor7,21)
  ---------------------------
    self.suoFish8 = SuoFish.new()
    lablayer:addChild(self.suoFish8,1)
    self.suoFish8:setPosition(self.paopointTable[7].x-100,self.paopointTable[7].y+150)
    self.suoFish8:setVisible(false)
    self.honbo8 = cc.Sprite:create("buyu1/res/hobo.png")
    self.honbo8:setPosition(self.paopointTable[7].x-100,self.paopointTable[7].y+150)
    self.honbo8:setScale(0.8)
    self:addChild(self.honbo8,20)
    self.hoscor8 = ScoreLab.new()
    self.hoscor8:setS(tostring(50000))
    self.hoscor8:setPosition(self.paopointTable[7].x-100,self.paopointTable[7].y+180)
    self:addChild(self.hoscor8,21)
    table.insert(SuoFishTable,6,self.suoFish7)
    table.insert(SuoFishTable,7,self.suoFish8)
    table.insert(self.honbotab,6,self.honbo7)
    table.insert(self.honbotab,7,self.honbo8)
    table.insert(self.hoscortab,6,self.hoscor7)
    table.insert(self.hoscortab,7,self.hoscor8)

    self.doub7 = Douvery.new()
    lablayer:addChild(self.doub7,1)
    self.doub7:setPosition(self.paopointTable[6].x+100,self.paopointTable[6].y+150)
    self.doub7:setVisible(false)
    self.doub8 = Douvery.new()
    lablayer:addChild(self.doub8,1)
    self.doub8:setPosition(self.paopointTable[7].x+100,self.paopointTable[7].y+150)
    self.doub8:setVisible(false)
    table.insert(self.doubTable,6,self.doub7)
    table.insert(self.doubTable,7,self.doub8)

    self.blama7 = cc.Sprite:create("buyu1/res/Blama.png")
    self.blama7:setPosition(self.paopointTable[6].x+170,self.paopointTable[6].y+60)
    lablayer:addChild(self.blama7,200)
    self.blama8 = cc.Sprite:create("buyu1/res/Blama.png")
    self.blama8:setPosition(self.paopointTable[7].x+170,self.paopointTable[7].y+60)
    lablayer:addChild(self.blama8,200)
    table.insert(self.blamaTable,6,self.blama7)
    table.insert(self.blamaTable,7,self.blama8)
    table.insert(self.bolmaTable,6,false)
    table.insert(self.bolmaTable,7,false)
  end

  for dtt = 0,SeatNum-1 do
      self.honbotab[dtt]:setVisible(false)
      self.hoscortab[dtt]:setVisible(false)
      self.blamaTable[dtt]:setVisible(false)
  end


  self.rankroot = ccs.GUIReader:getInstance():widgetFromJsonFile("buyu1/res/Json/FishUI_9.json")
  self:addChild(self.rankroot,100)
  self.rankroot:setVisible(false)

  self.rankname = {}
  for kl = 1,10 do
    local nemac = "playnametex"..kl
    local scixd = ccui.Helper:seekWidgetByName(self.rankroot,nemac)
    table.insert(self.rankname,scixd)
  end

  self.rankscore = {}
  self.TextField = {}
  for mlc = 1,10 do
    local nicd = "winscoretext"..mlc
    local dicd = ccui.Helper:seekWidgetByName(self.rankroot,nicd)
    table.insert(self.rankscore,dicd)
    local nmd = "TextField"..mlc
    local fhcj = ccui.Helper:seekWidgetByName(self.rankroot,nmd)
    table.insert(self.TextField,fhcj)
    self.TextField[mlc]:setVisible(false)
  end

  self.ranktext = ccui.Helper:seekWidgetByName(self.rankroot,"ranktext")
  self.maxscoretrxt = ccui.Helper:seekWidgetByName(self.rankroot,"maxscoretrxt")
  self.lastnum = ccui.Helper:seekWidgetByName(self.rankroot,"lastnum")
  self.Image_36 = ccui.Helper:seekWidgetByName(self.rankroot,"Image_36")
  self.Image_36:setVisible(false)
  self.endtime = ccui.Helper:seekWidgetByName(self.rankroot,"endtime")

  self.scorebase = {}
  self.dicscore = {}
  for mcv = 1,4 do
    local mnb = "scorebase"..mcv
    local mklj = ccui.Helper:seekWidgetByName(self.rankroot,mnb)
    table.insert(self.scorebase,mklj)
    self.scorebase[mcv]:setVisible(false)
    local mknb = "dicscore"..mcv
    local dnmki = ccui.Helper:seekWidgetByName(self.rankroot,mknb)
    table.insert(self.dicscore,dnmki)
  end
end

--水波形成函数
function GameScene:water()
  for i=0,5 do
    local wave = cc.Sprite:createWithSpriteFrameName("XY_shui_00.png")
    wave:setScaleX(480.9/256.0)
    wave:setScaleY(450.8/256.0)
    wave:setPosition(cc.p(240+480*(i%3),225+450*(math.floor(i/3))))--向下取整，lua除法没有整数和浮点数之分
    wave:setOpacity(180)
    self.bg:getParent():addChild(wave,2)
    local anim = ActionEx:createGameObjectAnimationRep("ShuiWen")
    wave:runAction(cc.RepeatForever:create(anim))
    local x,y = wave:getPosition()
  end
  --[[
  self.cache = cc.SpriteFrameCache:getInstance()
  self.cache:addSpriteFrames("buyu1/res/MainScene/Water.plist")
  local animation =cc.Animation:create()
  for i=1,15 do
    local frameName =string.format("water%d.png",i)
    local spriteFrame = self.cache:getSpriteFrame(frameName)
    animation:addSpriteFrame(spriteFrame)
  end
  animation:setDelayPerUnit(0.13)          --设置两个帧播放时间
  --animation:setRestoreOriginalFrame(true)    --动画执行后还原初始状态
  local action =cc.Animate:create(animation)
  self.water = cc.Sprite:createWithSpriteFrameName("water1.png")
  self.water:setAnchorPoint(cc.p(0.5,0.5))
  local sidd = self.water:getContentSize()
  local scax1 = winwidth/sidd.width
  local scay1 = winheight/sidd.height
  self.water:setScaleX(scax1)
  self.water:setScaleY(scay1)
  self.water:setPosition(self.winSize.width/2,self.winSize.height/2)
  self.water:runAction(cc.RepeatForever:create(action))
  self.bg:getParent():addChild(self.water,2)]]
end

function GameScene:CloseScene()
  self.bolFire = false
  g_bolsuo = false
  for i = 0,SeatNum - 1 do
    lineTable[i]:setVisible(false)
    suodinTable[i]:setVisible(false)
    SuoFishTable[i]:setVisible(false)
  end
  lock_fishid = 0
  for k, v in pairs(fishMap) do
    v:removeFromParent()

    fishMap[k] = nil
  end

  for k, v in pairs(bulletMap) do
    v:removeFromParent()

    bulletMap[k] = nil
  end
end

function GameScene:layer()
  self.freelayer  =  cc.Sprite:create("buyu1/res/free.png")
  self.freelayer:setPosition(winwidth/2,winheight/2)
  self:addChild(self.freelayer,100)
  self.freelayer:setVisible(false)
  self.freetimer = cc.LabelAtlas:_create("60", "buyu1/res/timer.png",16,32,48)
  self.freetimer:setPosition(643,10)
  self.freelayer:addChild(self.freetimer)
  self.freetimernum = 0
  self.rectime = 60
end

function GameScene:Auto_emission()
  self.actime = 0
  if g_score[self.playnum] > self.min_bullet_multiple then
    self.freetimernum = 0
    self.currTimer = os.time()
  end
  Vebull:VeryCr(self.paotable[self.playnum+1].rotate,self.buttnum,self.goma,self.playnum)
  --Vebull:LabSet(self.GoldTexTable[self.playnum+1],self.goma,self.playnum)
  self.paotable[self.playnum+1]:stop()
  self.paotable[self.playnum+1]:play()
  self.paotable[self.playnum+1]:addBlast()
end

function GameScene:AcCion(scd)
  if self.schedul2 then
    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul2)
  end
  local dt = 1
  local point = cc.p(self.hoscortab[scd]:getPositionX(),self.hoscortab[scd]:getPositionY())
  local schedul = cc.Director:getInstance():getScheduler()
  self.honbotab[scd]:setVisible(true)   --
  self.hoscortab[scd]:setVisible(true)  -- 钱数
  self.schedul2 = schedul:scheduleScriptFunc(function ()
    dt = dt + 1
    if dt % 6 == 0 then
      local x = math.random(-15,15)
      local coin = Coin.new()
      coin:setPosition(point.x+x,point.y)
      local moveto1 = nil
      coin:setScale(0.5)
      self:addChild(coin,22)
      if scd == 0 or scd == 1 then
        moveto1 = cc.MoveTo:create(1,cc.p(point.x+x,point.y+120))
      else
        moveto1 = cc.MoveTo:create(1,cc.p(point.x+x,point.y-120))
      end
      local function Endcallback()
          coin:removeFromParent()
      end
      local funcall = cc.CallFunc:create(Endcallback)
      local seq = cc.Sequence:create(moveto1,funcall)
      coin:runAction(seq)
    end
    if dt % 180 == 0 then
      self.honbotab[scd]:setVisible(false)
      self.hoscortab[scd]:setVisible(false)
      cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedul2)
    end
  end, 0, false)

end

return GameScene
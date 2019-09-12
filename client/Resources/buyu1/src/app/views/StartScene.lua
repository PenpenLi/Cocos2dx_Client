require_ex ("buyu1.src.util.fishConfig")

StartScene = class("StartScene", LayerBase)

function StartScene:ctor()
  StartScene.super.ctor(self)

	local winSize =  cc.Director:getInstance():getWinSize()

  --进度条
  self.right = cc.ProgressTimer:create(cc.Sprite:create("buyu1/res/images/loading_bar.png"))
  self.right:setType(cc.PROGRESS_TIMER_TYPE_BAR)
  self.right:setMidpoint(cc.p(0,0))
  self.right:setPosition(cc.p(winSize.width/2, winSize.height/2-210))
  self.right:setBarChangeRate(cc.p(1, 0))
  self:addChild(self.right,2)

  --进度条背景
  self.babg = cc.Sprite:create("buyu1/res/images/loading_bk.png")
  self.babg:setPosition(winSize.width/2, winSize.height/2-210)
  self:addChild(self.babg,1)

  local version = cc.LabelTTF:create("version:2", "arial", 24)
  version:setAnchorPoint(cc.p(1, 0.5))
  version:setPosition(1250, 50)
  self:addChild(version, 1)

  self.bg = cc.Sprite:create("buyu1/res/images/logo.png")
  self.bg:setPosition(winSize.width/2,winSize.height/2)
  self.bg:setAnchorPoint(cc.p(0.5,0.5))
  self:addChild(self.bg)
  self:enableNodeEvents(true)
  self:test()

  self.fishAnimCount = table.getn(fishAnimSet)
  self.gameObjCount = table.getn(GameObjAnimSet)

  self.loadTimes = 0
  self.loadStep = 0
  self.loadIndex = 1
  self.resCount = table.getn(ResourceFormat)

  local function LoadResourcesCallBack()
    cc.Texture2D:setDefaultAlphaPixelFormat(ResourceFormat[self.loadIndex])
    if self.loadIndex == 1 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_UI0.plist","buyu1/res/PVR/XY_UI0.png")
    elseif self.loadIndex == 2 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_Wave.plist","buyu1/res/PVR/XY_Wave.png")
    elseif self.loadIndex == 3 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_Bomb0.plist","buyu1/res/PVR/XY_Bomb0.png")
    elseif self.loadIndex == 4 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_Fish0.plist","buyu1/res/PVR/XY_Fish0.png")
    elseif self.loadIndex == 5 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_Fish1.plist","buyu1/res/PVR/XY_Fish1.png")
    elseif self.loadIndex == 6 then
      frameCache:addSpriteFrames("buyu1/res/PVR/XY_Fish2.plist","buyu1/res/PVR/XY_Fish2.png")
    end

    self.right:setPercentage(self.loadIndex * 1)
    self.loadTimes = 0
    self.loadIndex = self.loadIndex + 1
    if self.loadIndex > self.resCount then
      cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_AUTO)
      self.loadIndex = 1
      self.loadStep = self.loadStep + 1
    end
  end

  --预加载鱼的动画到animcache
  local function CreateAnimCallBack()
    CreateFishAnimate(fishAnimSet[self.loadIndex].name,fishAnimSet[self.loadIndex].form,0,
      fishAnimSet[self.loadIndex].sleepTime,true)

    CreateDFishAnimate(d_fishAnimSet[self.loadIndex].name,d_fishAnimSet[self.loadIndex].form,0,
      d_fishAnimSet[self.loadIndex].sleepTime,true)

    self.right:setPercentage(self.resCount + self.loadIndex * 1)
    self.loadTimes = 0
    self.loadIndex = self.loadIndex + 1
    if self.loadIndex > self.fishAnimCount then
      self.loadIndex = 1
      self.loadStep = self.loadStep + 1
    end
  end

--预加载其他的动画到animcache
  local function CreateGameObjAnimCallBack()
    CreateAnimate(GameObjAnimSet[self.loadIndex].name,GameObjAnimSet[self.loadIndex].form,0,
      GameObjAnimSet[self.loadIndex].sleepTime,true)

    self.right:setPercentage(self.resCount + self.fishAnimCount + self.loadIndex * 0.5)
    self.loadTimes = 0
    self.loadIndex = self.loadIndex + 1
    if self.loadIndex > self.gameObjCount then
      self.loadIndex = 1
      self.loadStep = self.loadStep + 1
    end
  end

  local function update( dt )
    -- body
    if self.loadStep > 3 then return end


    self.loadTimes = self.loadTimes + 1
    --print("loadStep = "..self.loadStep)

    if self.loadStep == 0 then
      if self.loadTimes >= 2 and self.loadIndex <= self.resCount then
      LoadResourcesCallBack()
      end

    elseif self.loadStep == 1 then
      if self.loadTimes >= 2 and self.loadIndex <= self.fishAnimCount then
        CreateAnimCallBack()
      end
    elseif self.loadStep == 2 then
      if self.loadTimes >= 2 and self.loadIndex <= self.gameObjCount then
        CreateGameObjAnimCallBack()
      end
    elseif self.loadStep == 3 then
      --GotoGameScene()
      --print("goto loadmag")
      self:loadmag()
    end
    --]]
  end

  self:scheduleUpdateWithPriorityLua(update,0)
end

function StartScene:onEnter()
  --self:loadmag()
end

--资源加载
function StartScene:loadmag()
  self.loadStep = self.loadStep + 1   --防止重复加载

	local function callback()
	  -- local secondScene = TestScene.new()
   --  local tranceAnima = cc.TransitionFlipX:create(0.5,secondScene)
   --  cc.Director:getInstance():replaceScene(secondScene)
   replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

    --[[
    for i = 1,23 do
      local filename = "buyu1/res/xfish/fish"..i..".png"
      cc.Director:getInstance():getTextureCache():addImage(filename)
      if i == 9 or i == 22 or i == 23 then

      else
        local filename1 = "buyu1/res/xfish/fish"..i.."_d.png"
        cc.Director:getInstance():getTextureCache():addImage(filename1)
      end
    end]]


    --发送用户准备好消息
    gamesvr.sendUserReady()
    --发送加载完成消息
    gamesvr.sendLoadFinish()
    --发送自动换币消息
    --gamesvr.sendExchangeFishScore()
  end
  local funcall = cc.CallFunc:create(callback)
	self.right:runAction(cc.Sequence:create(cc.ProgressTo:create(0.5,100),funcall))

end
function StartScene:onExit()
  if self.right then
    self.right:removeFromParent()
    self.right = nil
  end
  if self.bg then
    self.bg:removeFromParent()
    self.bg = nil
  end
  if self.babg then
    self.babg:removeFromParent()
    self.babg = nil
  end
end
function StartScene:test()

end

return StartScene
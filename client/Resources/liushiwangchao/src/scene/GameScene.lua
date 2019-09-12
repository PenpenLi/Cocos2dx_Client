GameScene = class("GameScene", LayerBase)

-- GameScene = class("GameScene", SceneBase)
local module_pre = "liushiwangchao.src"
--local GameModel = require_ex(module_pre.."GameModel")
local ccCMD=require_ex(module_pre .. ".models.cmd_game");
local ExternalFun = require_ex(module_pre..".ExternalFun")
local ccClipText = require_ex(module_pre..".ClipText")
local GameGunNum = require(module_pre..".GameGunNum")
local scheduler = cc.Director:getInstance():getScheduler();
--local GameLayer = class("GameLayer",GameModel)--function() return cc.Scene:create() end)
-- 游戏下注状态
local LSWC_BS_IDLE = 0  -- 闲置状态，比如刚进入时
local LSWC_BS_BET = 1  -- 下注阶段
-- 游戏进行状态
local LSWC_GS_WAITING = 10  -- 刚进入房间，等待中
local LSWC_GS_BEGIN = 11  -- 开始阶段，可以下注
local LSWC_GS_END = 12  -- 结束阶段，播放转动动画
local LSWC_GS_FREE = 13  -- 开奖阶段，显示结果
GameScene.TopZorder = 30
GameScene.ViewZorder = 20
yl={};
yl.INVALID_CHAIR=-1;
yl.INVALID_ITEM=-1;
yl.WIDTH=1280;
yl.HEIGHT=720;
yl.MAX_INT=100

-------------定义颜色-------------------------
COLOR_RED = cc.c3b(255, 0, 0)
COLOR_GREEN = cc.c3b(0, 255, 0)
COLOR_YELLOW = cc.c3b(255, 255, 0)
COLOR_GOLD = cc.c3b(255,194,0)
COLOR_PURGE_YELLOW = cc.c3b(245,129,20)
--节点索引
GameScene.Tag = 
{   
     clock_num        =1,
     btn_userlist     =2,
     btn_bankerlist   =3,
     btn_bank         =4,
     btn_sound        =5,
     btn_backRoom     =6,
     btn_help         =7,
     Tag_GunNum       = 200
}
--动作Tag
GameScene.AnimalTag = 
{
  Tag_Animal = 1
}
local Tag = GameScene.Tag

function GameScene:ctor()
    cclog("function GameScene:ctor()...........................................");
	GameScene.super.ctor(self)
    self._animOdds = nil              -- 动物赔率表
	self._enjoyOdds = nil             -- 闲和赔率表
	self._SceneSize = cc.size(1280, 720)
    self._animal_select_flag={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    self._color_select_flag={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	self._winSize = cc.Director:getInstance():getWinSize()
    self.currentTableId = global.g_mainPlayer:getCurrentTableId()
    self.currentPlayerID=global.g_mainPlayer:getPlayerId();
    self.currentPlayerInfo=global.g_mainPlayer:getRoomPlayer(self.currentPlayerID);    
    self.currentChairId = self.currentPlayerInfo.chairId;
   local glview = cc.Director:getInstance():getOpenGLView();
    local frame_size = glview:getFrameSize();
    local winsize= glview:getDesignResolutionSize();
    yl.WIDTH=self._winSize.width;
    yl.HEIGHT=self._winSize.height;
    -------------------new-----------------------------------
    self.last_private_mode=0;
    self._end_mov_Animal=nil;
    self._end_mov_flag=0;
    self._end_mov_Y=0;
    self._end_mov_X=0;
    self._end_mov_Z=0;
    self._end_mov_Y_speed=0;
    self._end_mov_X_speed=0;
    self._end_mov_Z_speed=0;
    self._end_mov_Step=0;
    self._drawIndex =0;
    self._end_mov_timer=0;
    self._end_mov_length=0;
    self._end_mov_angle=0;
    self._end_mov_angle_rot_speed=0;
    self._drawData={}; --开奖结果
    self._bMenu = false
    self._bSound = true
    self._bMusic = true
    self.m_scheduleUpdate=nil;
    self.bContinueRecord = false  
    self._bAnimalAction=false;
    self._bCaijinStatus=true;
    self._curJettonIndex=-1;
    self.cbTimeLeave=99;
    self._clockType=0;          --时间类型
    self.nAnimalRotateAngle=0;  --动物转盘角度
    self.nPointerRatateAngle=0; --指针转盘角度
    self._gameStatus=0;        --游戏状态
    self.game_running_state=0; --游戏状态
    self.exchangerate=1;       --分数退换比例
    self._drawIndex=0;
    self.Last_Draw_end_time=0;  --记录最近的结束时间 避免设置更新不比配
    self.ZhiZhengRottime=0;
	self.AnimalRottime=0;
    self._waiForGame_flag=1;
    self._userList = {}
    self._colorList = {}  
    self.cbColorLightIndexList={0,1,0,1,0,1,1,0,2,0,2,0,2,0,1,0,0,1,0,2,0,2,0,1,2};
    self._caijinStatus=1;
    self.lPayOutTotalCount=0;
    self._selfBetItemScore={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};--玩家压分
    self.lBetTotalCount={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};   --玩家总压分
    self.m_lContinueRecord = {0,0,0,0,0,0,0,0,0,0,0,0}
    self.lUserItemBetTopLimit=100000;                        --压分上限
    self.dwRouteListData={};
     --动画初始化
    self._bAnimalAction = false
    self._rotateSpeed = ccCMD.RotateMin;
    self._rotateStatus= ccCMD.Speed;
    self._rotateTime  = 0    
	self:gameDataInit();--数据初始化 设置搜索路径
    self:initConstValue();--初始化游戏时间和筹码==
   -- self:initAnimal();
    self:loadRes();       --载入资源 
    self._gamevision_text=cc.Label:createWithTTF("version:6", "fullmain/res/fonts/FZY4JW.ttf", 30);
    self:addChild(self._gamevision_text,100000);
    self._gamevision_text:setPosition(cc.p(10,20));
    self._gamevision_text:setAnchorPoint(cc.p(0,0.5));
end

function GameScene:readOnly(t)
    local _table = {}
    local mt = {
        __index = t,
        __newindex = function()
            error(" the table is read only ")
        end
    }
    setmetatable(_table, mt)
    return _table
end
function GameScene:initConstValue()
  --设置const数组
   local value = {13,13,14,13} --动物正常动画时间
   self._animalTimeFree = self:readOnly(value) 

   value = {5.5,4,4,3}  --动物胜利动画时间
   self._animalTimeWin = self:readOnly(value)

   --value = {100,1000,10000,100000,1000000,10000000} --下注筹码
   --value = {100,500,1000,2000,5000,10000} --下注筹码
   self._jettonArray={100,500,1000,2000,5000,10000} --= self:readOnly(value)
end
function GameScene:gameDataInit()
    self._bMusic = true
    AudioEngine.stopMusic()
    AudioEngine.setMusicVolume(100)
    AudioEngine.setEffectsVolume(100)
    --搜索路径
    self.search_path_ex=("liushiwangchao/res");  
    self._searchPath =cc.FileUtils:getInstance():getWritablePath() .."liushiwangchao/res"--.."/";  
    self._searchPath2 =cc.FileUtils:getInstance():getWritablePath().."Resources/liushiwangchao/res"--.."/"; 
    cc.FileUtils:getInstance():addSearchPath(self.search_path_ex);--.."/"
    cc.FileUtils:getInstance():addSearchPath(self._searchPath);
    cc.FileUtils:getInstance():addSearchPath(self._searchPath2);
    cclog("function GameScene:gameDataInit( ) self.search_path_ex=%s ",self.search_path_ex);
    cclog("function GameScene:gameDataInit( ) self._searchPath=%s ",self._searchPath);
    cclog("function GameScene:gameDataInit( ) self._searchPath2=%s ",self._searchPath2);
end
function GameScene:removeAnimations()
     cc.AnimationCache:getInstance():removeAnimation("CJAnim")
     cc.AnimationCache:getInstance():removeAnimation("SDAnim")
     cc.AnimationCache:getInstance():removeAnimation("SXAnim")
     cc.AnimationCache:getInstance():removeAnimation("SYAnim")
end

function GameScene:unLoadRes()
  cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("game_res/game.plist")
  cc.Director:getInstance():getTextureCache():removeTextureForKey("game_res/game.png")
  --[[
  cc.Sprite3DCache:getInstance():removeAllSprite3DData();
  cc.Sprite3DCache:destroyInstance();
  --]]
end
-- function GameScene:onExit()
--   self:gameDataReset()
--   self:unSchedule()
--   self:unScheduleMain();
--   self:KillGameClock();
--   self:removeMsgHandler();
--   --self:removeAnimations()
-- end
function GameScene:gameDataReset()
  local radio=global.g_mainPlayer:getCurrentRoomBeilv()
  global.g_mainPlayer:setPlayerScore(math.floor(self.lscore / radio))
  --播放大厅背景音乐
  self.m_bMusic = false
  AudioEngine.stopMusic()
  self:unLoadRes()
  --重置搜索路径
  local oldPaths = cc.FileUtils:getInstance():getSearchPaths();
  local newPaths = {};
  for k,v in pairs(oldPaths) do
    if tostring(v) ~= tostring(self._searchPath) then
      table.insert(newPaths, v);
    end
  end
  cc.FileUtils:getInstance():setSearchPaths(newPaths);
end
--启动游戏定时器
function GameScene:createSchedule()
    local function update(dt)
      --print("GameScene:createSchedule update(dt)00");
      --动物移动
      self:runMovEndAction(dt);  
      -- print("GameScene:createSchedule update(dt)11");
      if true == self._bCaijinStatus then
        if math.mod(self._timeSkip,10) == 0 then
          self:updateCaijin()
        end
      end
      -- print("GameScene:createSchedule update(dt)12");
      self._timeSkip = self._timeSkip + 1
    end

   --游戏定时器
    if nil == self.m_scheduleUpdate then
        self._timeSkip = 0
        self.m_scheduleUpdate = scheduler:scheduleScriptFunc(update, 0.02, false)
    end
end
function GameScene:unScheduleMain()

--游戏定时器
    if nil ~= self.m_scheduleUpdate then
        scheduler:unscheduleScriptEntry(self.m_scheduleUpdate)
        self.m_scheduleUpdate = nil
    end
end
--彩池
function GameScene:updateCaijin()
 if not self._caijinTTF  then
   self._caijinTTF = cc.LabelAtlas:_create(timeStr,"game_res/shuzi1.png",18,25,string.byte("0"))
   self._caijinTTF:setAnchorPoint(cc.p(0.5,0.5))
   self._caijinTTF:setPosition(cc.p(380,710))
   self._rootNode:addChild(self._caijinTTF)
 end

 if self._caijinStatus == 1 then
    local count = math.random(1,3) + 4
    local value = 1
    for i=1,count do
      value = value + math.random(1,10)*math.pow(10, i)
    end
    self._caijinTTF:setString(string.format("%d", value))
 elseif self._caijinStatus == 0 then
    local lPayOutTotalCount = 0
    if nil ~= self._drawData then
      lPayOutTotalCount = self.lPayOutTotalCount
    end
    self._caijinTTF:setString(string.format("%d", lPayOutTotalCount)) 
 end
end

function GameScene:loadRes( )
 -- self._scene:dismissPopWait();--等待提示  应该是框架公共提示框
  self:loading();              --加载层 载入动画
  self._resLoadFinish = false   
  --2d资源
  self._2dResCount = 0
  self._2dResTotal = 4
  cc.Director:getInstance():getTextureCache():addImageAsync("game_res/game.png", handler(self, self.load2DModelCallBack))
  cc.Director:getInstance():getTextureCache():addImageAsync("game_res/anim_sd.png", handler(self, self.load2DModelCallBack))
  cc.Director:getInstance():getTextureCache():addImageAsync("game_res/anim_sx.png", handler(self, self.load2DModelCallBack))
  cc.Director:getInstance():getTextureCache():addImageAsync("game_res/anim_sy.png", handler(self, self.load2DModelCallBack))
  --3D资源
  local modelFiles = {}
  table.insert(modelFiles, "3d_res/model_0/wujian.c3b")
  table.insert(modelFiles, "3d_res/model_1/wujian02.c3b")
  table.insert(modelFiles, "3d_res/model_2/wujian04.c3b")
  table.insert(modelFiles, "3d_res/model_3/wujian03.c3b")
  table.insert(modelFiles, "3d_res/model_4/wujian07.c3b")
  table.insert(modelFiles, "3d_res/model_5/wujian07.c3b")
  table.insert(modelFiles, "3d_res/model_6/wujian08.c3b")
  table.insert(modelFiles, "3d_res/model_7/wujian11.c3b")
  table.insert(modelFiles, "3d_res/model_8/wujian10.c3b")
  table.insert(modelFiles, "3d_res/model_bottom/dibu.c3b")
  table.insert(modelFiles, "3d_res/model_bottom1/dibu2.c3b")
  table.insert(modelFiles, "3d_res/model_monkey/monkey.c3b")
  table.insert(modelFiles, "3d_res/model_lion/lion.c3b")
  table.insert(modelFiles, "3d_res/model_panda/panda.c3b")
  table.insert(modelFiles, "3d_res/model_rabbit/rabbit.c3b")
  table.insert(modelFiles, "3d_res/model_seat/di.c3b")

  self._3dResCount = #modelFiles
  self._3dIndex =self._3dResCount;
  --[[
  self._3dIndex = 0 
  for i,v in ipairs(modelFiles) do
    local file = v
    cc.Sprite3D:createAsync(file,handler(self, self.load3DModelCallBack))
  end
  --]]
end
--加载画面层
function GameScene:loading()
  --self._scene:dismissPopWait()
  if self._loadLayer then
    self._loadLayer:removeFromParent()
  end
 
  cclog("GameScene:loading() yl.WIDTH=%f,yl.HEIGHT=%f,width=%f,height=%f",yl.WIDTH,yl.HEIGHT, self._winSize.width, self._winSize.height);
 -- local scale_x=yl.WIDTH/1280.0;
 -- local scale_y=yl.HEIGHT/720.0;  
  self._loadLayer = cc.Layer:create()
  --self._loadLayer:setScale(scale_x,scale_y);
  self._loadLayer:setAnchorPoint(cc.p(0.5,0.5))
  self._loadLayer:setPosition(cc.p(yl.WIDTH/2,yl.HEIGHT/2))
  self:addChild(self._loadLayer,GameScene.TopZorder)
  --加载背景
  local xx_path="load_res/im_loadbg_0.png";
  cclog(" GameScene:loading() xx_path=%s",xx_path);
  local bg = cc.Sprite:create("load_res/im_loadbg_0.png")
  bg:setAnchorPoint(cc.p(0.5,0.5))
  bg:setPosition(cc.p(0,0))
  self._loadLayer:addChild(bg)
  --title
  local title = cc.Sprite:create("load_res/im_title_0.png")
  title:setAnchorPoint(cc.p(0.5,0.5))
  title:setPosition(cc.p(0,0))
  self._loadLayer:addChild(title)
  local frames = {}
  for j=1,2 do
    local frame = cc.SpriteFrame:create("load_res/"..string.format("im_loadbg_%d.png", j-1),cc.rect(0,0,1334,750))
    table.insert(frames, frame)
  end
  local animation =cc.Animation:createWithSpriteFrames(frames,0.5)
  local animate = cc.Animate:create(animation)
  bg:runAction(cc.RepeatForever:create(animate))

  frames = {}
  for j=1,2 do
    local frame = cc.SpriteFrame:create("load_res/"..string.format("im_title_%d.png", j-1),cc.rect(0,0,782,375))
    table.insert(frames, frame)
  end
  animation =cc.Animation:createWithSpriteFrames(frames,0.5)
  animate = cc.Animate:create(animation)
  title:runAction(cc.RepeatForever:create(animate))
end


function GameScene:load2DModelCallBack( texture )
  
  self._2dResCount = self._2dResCount + 1
  --加载完毕
  if self._3dIndex == self._3dResCount and self._2dResCount == self._2dResTotal and not self._resLoadFinish then
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/game.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/anim_sd.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/anim_sx.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("game_res/anim_sy.plist")

    --创建动画
    local function readAnimation(file, key, num, time)
        local frames = {}
        local actionTime = time
        for i=1,num do
            local frameName = string.format(file.."_%d.png", i-1)
            local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName) 
            if(frame~=nil) then
               table.insert(frames, frame)         
             end
        end
        local  animation =cc.Animation:createWithSpriteFrames(frames,actionTime)
        cc.AnimationCache:getInstance():addAnimation(animation, key)
    end
    --2d动画特效
    readAnimation("cj","CJAnim",15,0.07);--彩金
    readAnimation("sd","SDAnim",15,0.07);--闪电
    readAnimation("sx","SXAnim",15,0.07);--大四喜
    readAnimation("sy","SYAnim",15,0.07);--大三元
    --场景搭建   
    self:init3DModel();  
    
    --添加动物站台
    self:initAnimal();
    --self:initAnimalTest();--test
    --载入面板
    self:initCsbRes()
    --
    self._resLoadFinish = true
    self._bCaijinStatus = true
    self._animLayer:setRotation3D(cc.vec3(0,360-self.nAnimalRotateAngle*15,0))
    self._arrow:setRotation3D(cc.vec3(0,self.nPointerRatateAngle*15+180,0))
    self._gameStatus=ccCMD.IDI_GAME_FREE;
    self._waiForGame_flag=1;
    self._waitForGameSpr=cc.Sprite:create("dengdai.png");
    self:showRouteRecord();
    self:playMusic("Wait.mp3");
    if(self._waitForGameSpr~=nil) then 
       self:addChild(self._waitForGameSpr,9999);   
       self._waitForGameSpr:setPosition(cc.p(640,360));
    end
    --if self._gameStatus <=ccCMD.IDI_GAME_BET then --空闲或下注状态
    
      self._loadLayer:removeFromParent()
      self._loadLayer = nil     
      self:updateColor()
      self:popPlaceJettonLayer()
      self:setGameStatus(self._gameStatus)  
      self:createSchedule();     --激活定时器   
    --给服务器发送准备命令
     gamesvr.sendLoginGame()
	 gamesvr.sendUserReady()	
  end   -- if self._3dIndex == self._3dResCount and self._2dResCount == self._2dResTotal and not self._resLoadFinish then
end


function GameScene:updateControl()

  --下注筹码
  local btns = {}
  local jettonCount = 6
  for i=1,jettonCount do
    local btn = self._PlaceJettonLayer.rootNode:getChildByName(string.format("btn_%d", i))
    btn:setEnabled(false)
    table.insert(btns, btn)
  end
  if(self.lscore==nil) then self.lscore=0; end
  local myScore = self.lscore
  for i=1,#btns do
    local btn = btns[i]
    local value = self._jettonArray[i]
    if (value > myScore) then
       btn:setEnabled(false)
       if i == 1 then
        self:setJettonIndex(-1)
       end
    else
      btn:setEnabled(true)  
    end
  end

  --如果当前筹码不符合条件,切换成第一个筹码
  if (self._curJettonIndex ==-1) then -- and ( not btns[self._curJettonIndex]:isEnabled() ) then 
       self:setJettonIndex(-1)
  end

 --续压
  local btn = self._PlaceJettonLayer.rootNode:getChildByName("btn_continue")
  if self.bContinueRecord then 
      btn:setEnabled(false)     
  else
      btn:setEnabled(true) 
     
  end
  if(self._cancel_button~=nil) then self._cancel_button:setEnabled(true); end
end


function GameScene:popPlaceJettonLayer(pos)
    if pos == ccCMD.NormalPos or not pos then    --弹出
      self._PlaceJettonLayer:setVisible(true)
      self._PlaceJettonLayer:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2,yl.HEIGHT/2 - 60)))
      self._posStyle = ccCMD.NormalPos
    elseif pos == ccCMD.bottomHidden then --弹到底部
      self._PlaceJettonLayer:setVisible(true)
      self._PlaceJettonLayer:runAction(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2,-250)))
      self._posStyle = ccCMD.bottomHidden
    elseif pos == ccCMD.hidden then       --全部隐藏
      self._PlaceJettonLayer:runAction(
        cc.Sequence:create(cc.MoveTo:create(0.2,cc.p(yl.WIDTH/2, -yl.HEIGHT)),
        cc.CallFunc:create(function()
              self._PlaceJettonLayer:setVisible(false)
              self._posStyle = ccCMD.hidden
          end))
        )
    end
end

--重置游戏
function GameScene:resetGame()
  cclog("GameScene:resetGame()");
  self._end_mov_flag=0;  
  self._bAnimalAction = false;
  if self._loadLayer then
    self._loadLayer:removeFromParent()
    self._loadLayer = nil
  end
  self:resetAnimal()
  self._seat:stopAllActions()
  self._rewardLayer:setVisible(false)
end

function GameScene:getAnimIMG(animIndex)
   local res = "3d_res/model_lion/tex.jpg"
  if animIndex == 1 then
      res = "3d_res/model_panda/tex.jpg"
  elseif animIndex == 2 then
      res = "3d_res/model_monkey/tex.jpg"
  elseif animIndex == 3 then
      res = "3d_res/model_rabbit/tex.jpg"
  end
  return res
end

function GameScene:resetAnimal()
    cclog("GameScene:resetAnimal()0000");
    for i=1,#self._animals do
      local animal = self._animals[i]
      local index = animal:getTag()
      local animIndex = math.mod(index-1,4)
      local modelFile = self:getAnimRes(animIndex)
      local texture = self:getAnimIMG(animIndex)
      local angle = (i-1)*15
      animal:setScale(1);
      animal:setColor(cc.c3b(255,255,255));
      animal:setPosition3D(cc.vec3(19*math.sin(math.rad(angle)), 0, -19*math.cos(math.rad(angle))))
      animal:setRotation3D(cc.vec3(0, 360-angle, 0))
      animal:setTexture(texture)
      --cclog("GameScene:resetAnimal()0000");
      --if index == self._drawIndex then
      animal:stopActionByTag(GameScene.AnimalTag.Tag_Animal)
      animal:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
          local fTime = math.random(0,1)*5
          local animtion = cc.Animation3D:create(modelFile)
          local delay = cc.DelayTime:create(fTime)
          local action =  cc.Animate3D:create(animtion, 0, self._animalTimeFree[animIndex+1])
          local rep = cc.RepeatForever:create(action)
          rep:setTag(GameScene.AnimalTag.Tag_Animal)
          animal:runAction(rep)
      end)))
     -- end
    end
    local normal = "3d_res/model_5/tex.jpg"
    self._seat:setTexture(normal)
    self._drawIndex = 0
    self._camera:runAction(cc.MoveTo:create(0.5,ccCMD.Camera_Normal_Vec3))
end

function GameScene:updateAreaMultiple()

end
function GameScene:setGameStatus(status)
  self._gameStatus = status
  self._clockType= self._gameStatus;
  self:updateClockType(self._clockType);
end

--计时器更新
function GameScene:OnClockUpdata()
--[[
    if  self._ClockID ~= yl.INVALID_ITEM then
        self._ClockTime = self._ClockTime - 1
        local result = self:OnEventGameClockInfo(self._ClockChair,self._ClockTime,self._ClockID)
        if result == true   or self._ClockTime < 1 then
            self:KillGameClock()
        end
    end
    --]]
    self:OnUpdataClockView()
end
--设置倒计时
function GameScene:setClockView(chair,id,time)
  if 0 ~= time then
    self.cbTimeLeave = time
     local timeNode = self._rootNode:getChildByName("node_time")

     --时间
     local timeStr = string.format("%d", time)
     local timeNum = self._rootNode:getChildByTag(Tag.clock_num)
     if not timeNum then 
       timeNum = cc.LabelAtlas:_create(timeStr,"game_res/shuzi4.png",27,38,string.byte("0"))
       timeNum:setTag(Tag.clock_num)
       timeNum:setAnchorPoint(cc.p(0.5,0.5))
       timeNum:setPosition(cc.p(timeNode:getPositionX(),timeNode:getPositionY()))
       self._rootNode:addChild(timeNum)
     else
       local timestr = string.format("%d",time)
       if time < 10 then
         timestr = "0"..timestr
       end
       timeNum:setString(timestr)
     end
  end
end
function GameScene:OnUpdataClockView()

   if(self.cbTimeLeave>0) then 
      self.cbTimeLeave=self.cbTimeLeave-1; 
   end
  local timeNode =self._rootNode:getChildByName("node_time")
  local timeNum = self._rootNode:getChildByTag(Tag.clock_num)
  local timestr = string.format("%d",self.cbTimeLeave)
   if not timeNum then 
       timeNum = cc.LabelAtlas:_create(timeStr,"game_res/shuzi4.png",27,38,string.byte("0"))
       timeNum:setTag(Tag.clock_num)
       timeNum:setAnchorPoint(cc.p(0.5,0.5))
       timeNum:setPosition(cc.p(timeNode:getPositionX(),timeNode:getPositionY()))
       self._rootNode:addChild(timeNum)
  end
  if self.cbTimeLeave < 10 then
     timestr = "0"..timestr
  end
  if(timestr~=nil) then timeNum:setString(timestr) end
  if cbTimeLeave == 0 then
      self:LogicTimeZero()   
  end
 end

 --倒计时结束处理

function GameScene:LogicTimeZero()

end

-- 设置计时器
function GameScene:SetGameClock(chair,id,time)
    if not self._ClockFun then
        local this = self
        self._ClockFun = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function()
                self:OnClockUpdata()
            end, 1, false)
    end
    self:OnUpdataClockView()
end

-- 关闭计时器
function GameScene:KillGameClock(notView)
    print("KillGameClock")
    if self._ClockFun then
        --注销时钟
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._ClockFun) 
        self._ClockFun = nil
    end
    if not notView then
        self:OnUpdataClockView()
    end
end

--刷新时间类型
function GameScene:updateClockType(clockType)
  if not self._rootNode then
     return
  end
  local clockTypeIMG = self._rootNode:getChildByName("time_type")
  self:SetGameClock(0,0,self.cbTimeLeave)
  if ccCMD.IDI_GAME_FREE == self._gameStatus then   
    clockTypeIMG:loadTexture("biaoti7.png",1)
  elseif ccCMD.IDI_GAME_BET== self._gameStatus then
    clockTypeIMG:loadTexture("biaoti6.png",1)
  elseif ccCMD.IDI_GAME_DRAW== self._gameStatus then
    clockTypeIMG:loadTexture("biaoti5.png",1)
  elseif ccCMD.IDI_GAME_DRAW_RESULT == clockType then
    clockTypeIMG:loadTexture("biaoti4.png",1)
  else 
     clockTypeIMG:loadTexture("biaoti7.png",1)
  end
end

--刷新彩灯
function GameScene:updateColor()
   if not ( self._resLoadFinish) then--self._gameModel._bScene and
     return
   end
   local colorList = self.cbColorLightIndexList;--[1]
   local color_length=#colorList;
   if(color_length>24) then color_length=24; end
   for i=1,color_length do
     local color = colorList[i] 
     local file = "3d_res/model_8/hong.jpg"
     if color == 1 then
       file ="3d_res/model_8/lv.jpg"
     elseif color == 2 then
       file = "3d_res/model_8/huang.jpg"
     end
     local mess =  self._colorList[i]   
     local function callBackWithArgs(param)
       local ret 
       ret = function()
         mess:setTexture(param)
       end
       return ret 
     end 
     self._colorList[i]:runAction(cc.Sequence:create(cc.DelayTime:create(0.03*(i-1)),cc.CallFunc:create(callBackWithArgs(file))))
   end
end
function GameScene:init3DModel()

  --3d场景层
  self.m_3dLayer = cc.Layer:create()
  self:addChild(self.m_3dLayer)
  --摄像头
  self._camera = cc.Camera:createPerspective(60,yl.WIDTH/yl.HEIGHT,1,1000)
  self._camera:setPosition3D(ccCMD.Camera_Normal_Vec3);
  self._camera:lookAt(cc.vec3(0, 0, 0),cc.vec3(0,1,0));
  self._camera:setCameraFlag(cc.CameraFlag.USER1);
  self.m_3dLayer:addChild(self._camera);
  --底盘
  local sprite = cc.Sprite3D:create("3d_res/model_bottom/dibu.c3b")
  sprite:setScale(1.0)
  sprite:setPosition3D(cc.vec3(0, -1.5, 0))
  sprite:setCameraMask(cc.CameraFlag.USER1)
  self.m_3dLayer:addChild(sprite)
  --墙壁
  sprite = cc.Sprite3D:create("3d_res/model_bottom1/dibu2.c3b")
  sprite:setScale(1.0)
  sprite:setPosition3D(cc.vec3(0, -1.5, 0))
  sprite:setRotation3D(cc.vec3(0, 60, 0))
  sprite:setCameraMask(cc.CameraFlag.USER1)
  self.m_3dLayer:addChild(sprite)
  
  for i=1,6 do
    --墙壁物件
    local wujian1 = cc.Sprite3D:create("3d_res/model_0/wujian.c3b")
    wujian1:setScale(1.0)
    wujian1:setPosition3D(cc.vec3(0, -0.1, 0))
    wujian1:setRotation3D(cc.vec3(0, 60*(i-1)+30, 0))
    wujian1:setGlobalZOrder(1)
    wujian1:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(wujian1)
    
    --墙壁物件
    local wujian2 = cc.Sprite3D:create("3d_res/model_1/wujian02.c3b")
    wujian2:setScale(1.0)
    wujian2:setPosition3D(cc.vec3(0, -0.1, 0))
    wujian2:setRotation3D(cc.vec3(0, 60*(i-1)+30, 0))
    wujian2:setGlobalZOrder(1)
    wujian2:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(wujian2)
    --红绿黄物件
    local wujian3 = cc.Sprite3D:create("3d_res/model_3/wujian03.c3b")
    wujian3:setScale(1.0)
    wujian3:setPosition3D(cc.vec3(0, -0.1, 0))
    wujian3:setRotation3D(cc.vec3(0, 60*(i-1)+30, 0))
    wujian3:setGlobalZOrder(1)
    wujian3:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(wujian3)
    --灯
    local wujian4 = cc.Sprite3D:create("3d_res/model_2/wujian04.c3b")
    wujian4:setScale(1.0)
    wujian4:setPosition3D(cc.vec3(0, -0.1, 0))
    wujian4:setRotation3D(cc.vec3(0, 60*(i-1), 0))
    wujian4:setGlobalZOrder(1)
    wujian4:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(wujian4)
  end
  --]]
end

--csb初始化
function GameScene:initCsbRes()
    --菜单层 银行 用户列表 声音设置等 最上层
    local rootLayer, csbNode = ExternalFun.loadRootCSB("game_res/Top.csb",self)
    rootLayer:setClippingEnabled(true)
    self._rootNode = csbNode
   -- local scale_x=yl.WIDTH/1280.0;
    --local scale_y=yl.HEIGHT/720.0;  
   -- self._rootNode:setScale(scale_x,scale_y);
     self._rootNode:setPosition(0,yl.HEIGHT-720);
    --下注层
    self:initPlaceJettonLayer()
    --派彩层
    self:initRewardLayer()
    --按键响应
    self:initButtonEvent()
    self:setClockView(0,0,self.cbTimeLeave);
    --添加玩家分数框到顶部 避免空空
    local coin_spr=cc.Sprite:createWithSpriteFrameName("tubiao39.png");
    local coin_bg=cc.Sprite:createWithSpriteFrameName("dikuang16.png");
    --
    if(coin_bg) then
       self._rootNode:addChild(coin_bg); 
       coin_bg:setPosition(cc.p(750,713));
    end
    if(coin_spr) then
       self._rootNode:addChild(coin_spr); 
       coin_spr:setPosition(cc.p(620,713));
    end
    --
    self._game_score_spr = cc.LabelAtlas:_create("0","game_res/shuzi4.png",27,38,string.byte("0"));
    if(self._game_score_spr) then
       self._rootNode:addChild(self._game_score_spr,11); 
       self._game_score_spr:setColor(cc.c3b(255,194,0));
       self._game_score_spr:setScale(0.8);
       self._game_score_spr:setAnchorPoint(cc.p(1,0.5));
       self._game_score_spr:setPosition(cc.p(900,713));
    end
    --
end

function GameScene:getAnimRes(animIndex)
  local res = "3d_res/model_lion/lion.c3b"
  if animIndex == 1 then
      res = "3d_res/model_panda/panda.c3b"
  elseif animIndex == 2 then
      res = "3d_res/model_monkey/monkey.c3b"
  elseif animIndex == 3 then
      res = "3d_res/model_rabbit/rabbit.c3b"
  end
  return res
end

function GameScene:initButtonEvent()
  --玩家列表
  local btn = self._rootNode:getChildByName("btn_userlist")
  btn:setTag(Tag.btn_userlist)
 -- btn:addTouchEventListener(handler(self, self.onEvent))
  btn:setVisible(false);
  btn = self._rootNode:getChildByName("btn_bankerlist")
  btn:setTag(Tag.btn_bankerlist)
  btn:setVisible(false);
  --btn:addTouchEventListener(handler(self, self.onEvent))
  btn = self._rootNode:getChildByName("btn_bank")
  btn:setTag(Tag.btn_bank)
  btn:setVisible(false);
  --btn:addTouchEventListener(handler(self, self.onEvent))
  btn = self._rootNode:getChildByName("btn_sound")
  btn:setTag(Tag.btn_sound);
  btn:loadTextureNormal("anniu7.png",1)
  local x,y=btn:getPosition();
  x=x+50;
  cclog("GameScene:initButtonEvent x=%f,y=%f",x,y);
  btn:setPosition(cc.p(980,y));
  btn:addTouchEventListener(handler(self, self.onEvent))
 
  btn = self._rootNode:getChildByName("btn_backRoom")
  btn:setTag(Tag.btn_backRoom)
  btn:addTouchEventListener(handler(self, self.onEvent))

  btn = self._rootNode:getChildByName("btn_help")
  btn:setTag(Tag.btn_help)
  btn:setVisible(false);
 -- btn:addTouchEventListener(handler(self, self.onEvent))

end



--下注响应
function GameScene:PlaceJettonEvent(tag)
  if not self._resLoadFinish then return end    
  if(self._waiForGame_flag>0) then return end    
  if self._curJettonIndex <=0  then 
     self._curJettonIndex=1;
     self:setJettonIndex(1)
  end
  local itemScore = self._selfBetItemScore[tag]
  local topLimit = self.lUserItemBetTopLimit;
  if itemScore >= topLimit then
     return
  end
  local bet_index=tag-1;
  local anim=bet_index/3;
  local color=bet_index%3;-- math.mod(bet_index,3)--tag%3;clearBet
  local enjoy=0;
  local iType=0;
  cclog("function GameScene:PlaceJettonEvent(tag) tag=%d,_curJettonIndex=%d,_jettonArray=%d"
  ,tag,self._curJettonIndex,self._jettonArray[self._curJettonIndex]);
  gamesvr.sendBet(self._jettonArray[self._curJettonIndex],anim,color,enjoy,iType);
  self:playEffect("BetItem.wav")
end

--取消压分
function GameScene:cancel_input_event()
        if not self._resLoadFinish then return end    
        if(self._waiForGame_flag>0) then return end   
          gamesvr.clearBet();
end
--续押事件响应
function GameScene:continueEvent(index)
   if not self._resLoadFinish then return end    
   if(self._waiForGame_flag>0) then return end   
   local bet_index=index-1;
   local anim=bet_index/3;
   local color=bet_index%3;-- math.mod(bet_index,3)--tag%3;
   local enjoy=0;
   local iType=0;
   gamesvr.sendBet(self.m_lContinueRecord[index],anim,color,enjoy,iType);
end


--返回
function GameScene:backRoom()
     cclog("GameScene:backRoom()");
     self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
    exit_liushiwangchao();
    --self:onExitTable()
end



--顶部按键响应
function GameScene:onEvent(sender,eventType)

  local tag = sender:getTag()

  if eventType == ccui.TouchEventType.ended  then
    if tag == Tag.btn_userlist then
    --[[
      if self._UserView == nil then
        self._UserView = UserList:create(self._gameModel,self._scene)
        self:addChild(self._UserView,30)
        self._UserView:reloadData()
      else
        self._UserView:setVisible(true)
        self._UserView:popLayer()
        self._UserView:reloadData()
      end
      --]]
    elseif tag == Tag.btn_bankerlist then
    --[[
       if self._bankerView == nil then
        self._bankerView = BankerList:create(self._gameModel,self._scene)
        self:addChild(self._bankerView,30)
        self._bankerView:reloadData()
      else
        self._bankerView:setVisible(true)
        self._bankerView:popLayer()
        self._bankerView:reloadData()   
      end  --]]
    elseif tag == Tag.btn_bank then
    --[[
        if self._bankView == nil then
        self._bankView = Bank:create(self._scene._gameModel,self._scene)
        self:addChild(self._bankView,30)
      else
        self._bankView:setVisible(true)
        self._bankView:popLayer()
    
      end    
       --]]
    elseif tag == Tag.btn_sound then
         self._bSound = not self._bSound
         self._bMusic = not self._bMusic
     -- GlobalUserItem.bSoundAble = not GlobalUserItem.bSoundAble
     -- GlobalUserItem.bVoiceAble = GlobalUserItem.bSoundAble
      if self._bSound then
        AudioEngine.setEffectsVolume(1);
        AudioEngine.setMusicVolume(1);
        sender:loadTextureNormal("anniu7.png",1)    
      else
        AudioEngine.setEffectsVolume(0);
        AudioEngine.setMusicVolume(0);
        --AudioEngine.stopAllEffects();
        --AudioEngine.stopMusic();
        sender:loadTextureNormal("anniu8.png",1)
      end

     -- GlobalUserItem.setVoiceAble( GlobalUserItem.bVoiceAble)
     -- GlobalUserItem.setSoundAble(GlobalUserItem.bSoundAble)
    elseif tag == Tag.btn_help then 
     --  self._scene._scene:popHelpLayer2(ccCMD.KIND_ID, 0, yl.ZORDER.Z_HELP_WEBVIEW)
    elseif tag == Tag.btn_backRoom then
        self:backRoom();
       -- self._scene:onQueryExitGame()
    end
  end
  --]]
end



function GameScene:initRewardLayer()
   --加载CSB
  local csbnode = cc.CSLoader:createNode("game_res/GameEnd.csb");
  csbnode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
  --local scale_x=yl.WIDTH/1280.0;
 -- local scale_y=yl.HEIGHT/720.0;  
  self._rewardLayer = csbnode
  --self._rewardLayer:setScale(scale_x,scale_y);
  self:addChild(csbnode,GameScene.TopZorder)
  self._rewardLayer:setVisible(false)
end

function GameScene:blinkEffect(isAction,index)
  local circles = {}
  for i=1,6 do
    local circle = self._PlaceJettonLayer.rootNode:getChildByName(string.format("circle_%d", i))
    table.insert(circles, circle)
    circle:setVisible(false)
    circle:stopAllActions()
  end

  if true == isAction then
    local circle = circles[index]
    circle:setVisible(true)
    circle:runAction(cc.RepeatForever:create(cc.Blink:create(1, 2)))
  end
end

function GameScene:setJettonIndex( index )
  if index == -1 then
    self:blinkEffect(false)
    return
  end

  self._curJettonIndex = index
  self:blinkEffect(true,index)
end

function GameScene:initPlaceJettonLayer()
  cclog("GameScene:initPlaceJettonLayer()");
  self._posStyle = ccCMD.NormalPos
  self._PlaceJettonLayer =  ccui.ImageView:create()
  self._PlaceJettonLayer:setContentSize(cc.size(yl.WIDTH, yl.HEIGHT))
  self._PlaceJettonLayer:setScale9Enabled(true)
  self._PlaceJettonLayer:setAnchorPoint(cc.p(0.5,0.5))
  self._PlaceJettonLayer:setPosition(yl.WIDTH/2, -yl.HEIGHT)
  self._PlaceJettonLayer:setTouchEnabled(true)
  self:addChild(self._PlaceJettonLayer,GameScene.TopZorder)
  --
  self._PlaceJettonLayer:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
          self:popPlaceJettonLayer(ccCMD.bottomHidden)
        end
      end)
  -- 
  --加载CSB 苹果手机iPhone分辨率为1335*750
  local csbnode = cc.CSLoader:createNode("game_res/PlaceJetton.csb");
  csbnode:setPosition(yl.WIDTH/2, yl.HEIGHT/2)
 -- csbnode:setScale(0.5,0.5);--yl.WIDTH/1335);
  self._PlaceJettonLayer:addChild(csbnode);
  self._PlaceJettonLayer.rootNode = csbnode;
 
  local jettonBg = csbnode:getChildByName("Image_1");
  jettonBg:addTouchEventListener(function(sender,eventType)
        if eventType == ccui.TouchEventType.ended then
          self:popPlaceJettonLayer(ccCMD.NormalPos)
        end
      end)
  --初始化按钮事件
  local btns = {}
  for i=1,6 do
    local btn = csbnode:getChildByName(string.format("btn_%d", i))
    btn:setTag(i)
    btn:addTouchEventListener(function(sender,eventType)
       if eventType == ccui.TouchEventType.ended then
          self:setJettonIndex(sender:getTag())
       end
    end)
  end
  --下注区域
  for i=1,ccCMD.BET_ITEM_COUNT do
    local bet = self._PlaceJettonLayer.rootNode:getChildByName(string.format("btn_bet_%d", i))
    bet:setTag(i)
    assert(bet)
    bet:addTouchEventListener(function(sender,eventType)
       if eventType == ccui.TouchEventType.ended then
          self:PlaceJettonEvent(sender:getTag())
       end
    end)
  end   
  --续压
  local btn = self._PlaceJettonLayer.rootNode:getChildByName("btn_continue")
  btn:addTouchEventListener(function(sender,eventType)
    if eventType == ccui.TouchEventType.ended then
        sender:setEnabled(false)
        self.bContinueRecord = true --一局只能续压一次
        for i=1,#self.m_lContinueRecord do  
          if self.m_lContinueRecord[i] > 0 then
            --发送加注 i是逻辑索引
            self:continueEvent(i)
          end
        end
    end
  end)
  --添加续押按键
  self._cancel_button=ccui.Button:create("game_res/cancel_bt0.png","game_res/cancel_bt1.png");
  if(self._cancel_button) then 
      self._cancel_button:setEnabled(false);
      self._PlaceJettonLayer:addChild(self._cancel_button);
      self._cancel_button:setPosition(cc.p(845,96+(yl.HEIGHT-720)/2));
      self._cancel_button:addTouchEventListener(function(sender,eventType)
            if eventType == ccui.TouchEventType.ended then 
                self:cancel_input_event();
            end
      end)
  end
end

function GameScene:initAnimal()
  self._animLayer = cc.Sprite3D:create()
  -- self._animLayer = cc.Sprite3D:create("cc")
  --self._animLayer = cc.Sprite3D:create("3d_res/model_bottom/dibu.c3b");
  self._animLayer:setPosition3D(cc.vec3(0, 0,0))
  self.m_3dLayer:addChild(self._animLayer)
  local file1 ="3d_res/model_8/wujian10.c3b";--红绿黄物件
  local file2 ="3d_res/model_seat/di.c3b"---底座
  self._animals = {}
  math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6))) 

  -- 24个灯
  for i=1,24 do
    local angle = 15*(i-1)
    local sprite = cc.Sprite3D:create(file1)
    sprite:setScale(1.0)
    sprite:setPosition3D(cc.vec3(13*math.sin(math.rad(angle)), -0.1, -13*math.cos(math.rad(angle))))
    sprite:setRotation3D(cc.vec3(0, 360-angle, 0))
    sprite:setGlobalZOrder(2)
    sprite:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(sprite)

    table.insert(self._colorList, sprite)

    --底座
    local dizuo = cc.Sprite3D:create(file2)
    dizuo:setScale(1.0)
    dizuo:setPosition3D(cc.vec3(19*math.sin(math.rad(angle)), -0.1, -19*math.cos(math.rad(angle))))
    dizuo:setRotation3D(cc.vec3(-90, 360-angle, 0))
    dizuo:setGlobalZOrder(2)
    dizuo:setCameraMask(cc.CameraFlag.USER1)
    self._animLayer:addChild(dizuo)
    
    --动物
    local animIndex = math.mod(i-1,4)
    local modelFile = self:getAnimRes(animIndex)
    local animal = cc.Sprite3D:create(modelFile)
    animal:setScale(1.0)
    animal:setPosition3D(cc.vec3(19*math.sin(math.rad(angle)), 0, -19*math.cos(math.rad(angle))))
    animal:setRotation3D(cc.vec3(0, 360-angle, 0))
    animal:setGlobalZOrder(2)
    animal:setTag(i)
    animal:setCameraMask(cc.CameraFlag.USER1)
    self._animLayer:addChild(animal)
    table.insert(self._animals, animal)
    --[[
      --设置const数组
     local value = {13,13,14,13} --动物正常动画时间
     self._animalTimeFree = self:readOnly(value) 
     value = {5.5,4,4,3}  --动物胜利动画时间
     self._animalTimeWin = self:readOnly(value)
     local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1]);
    --]]
    animal:runAction(cc.Sequence:create(delay,cc.CallFunc:create(function()
        local fTime = math.random(0,1)*5
        local animtion = cc.Animation3D:create(modelFile)
        local delay = cc.DelayTime:create(fTime)
        local action =  cc.Animate3D:create(animtion, 0, self._animalTimeFree[animIndex+1])
        local rep = cc.RepeatForever:create(action)
        rep:setTag(GameScene.AnimalTag.Tag_Animal)
        animal:runAction(rep)
    end)))
  end
  --------
  --透明转动层
    self._alphaSprite = cc.Sprite3D:create("3d_res/model_6/wujian08.c3b")
    self._alphaSprite:setScale(1.0)
    self._alphaSprite:setPosition3D(cc.vec3(0, -9, 1))
    self._alphaSprite:setGlobalZOrder(1)
    self._alphaSprite:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(self._alphaSprite)
    --底座
    local dizuo = cc.Sprite3D:create("3d_res/model_4/dizuo.c3b")
    dizuo:setScale(1.0)
    dizuo:setPosition3D(cc.vec3(0, 0, 0))
    dizuo:setGlobalZOrder(2)
    dizuo:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(dizuo)
    --红绿黄 底座
    self._seat = cc.Sprite3D:create("3d_res/model_5/wujian07.c3b")
    self._seat:setScale(1.0)
    self._seat:setPosition3D(cc.vec3(0, 0, -0.5))
    self._seat:setGlobalZOrder(1)
    self._seat:setCameraMask(cc.CameraFlag.USER1)
    dizuo:addChild(self._seat)
    --指针
    self._arrow = cc.Sprite3D:create("3d_res/model_7/wujian11.c3b")
    print("self._arrow = cc.Sprite3D:create(3d_res/model_7/wujian11.c3b)");
    self._arrow:setScale(0.91)
    self._arrow:setPosition3D(cc.vec3(0,0,0))
    self._arrow:setGlobalZOrder(2)
    self._arrow:setCameraMask(cc.CameraFlag.USER1)
    self.m_3dLayer:addChild(self._arrow)

end



function GameScene:checkAutoScale(index, spr, result)
	if result == nil then
		if index <= 8 or index > 17 then
			spr:setScale(0.55)
		else
			-- spr:setScale(0.65)
			spr:setScale(0.55)
		end
	else
		if result then
			-- self:runScaleTo(spr, 0.65)
			self:runScaleTo(spr, 0.55)
		else
			self:runScaleTo(spr, 0.55)
		end
	end
end


function GameScene:runScaleTo(spr, scale)
	local action = cc.Sequence:create(cc.ScaleTo:create(0.5, scale))
	spr:runAction(action)
end

function GameScene:rateTheDial(times, callback, targetIndex, list)
	if not self.imgDial then return end
	if list and self.saveStructureList then
		local cIndex = list["eColor"] + 1
		local data = self.saveStructureList[cIndex]
		local index = math.random(1, #data)
		targetIndex = data[index]
		self._targetIndex = targetIndex
	elseif not targetIndex then
		targetIndex = math.random(1, 24)
		self._targetIndex = targetIndex
	end

	local _timer = nil
	local function compelete()
		if _timer then
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(_timer)
		end

		local realReturn = function ()
			if callback then
				callback()
			end
		end

		if times == 1 then
			--local itemImage = self.pedestalList[targetIndex]
			local itemImage = self.lightlist[targetIndex]
			local a1 = cc.ScaleBy:create(0.12, 1.4)
			local a2 = a1:reverse()
			local a3 = cc.CallFunc:create(realReturn)
			local a4 = cc.Sequence:create(a1,a2,a3)
			itemImage:runAction(a4)
		else
			realReturn()
		end
	end

	local function calcTargetAngel()
		-- local posOrgX, posOrgY = self.imgDial:getPosition()
		-- local posDestX, posDestY = self.pedestalList[targetIndex]:getPosition()
		-- local rad = math.atan2((posDestY - posOrgY), (posDestX - posOrgX))
		-- local angle = 360 - math.deg(rad) 				--正常来说逆时针是正方向,COCOS顺时针是正方向
		-- local destAngel = (angle + 3)					--因为图上的指针要转3度才会转到正常角度
		local angles = 360 - 360 / 24 * (targetIndex - 1)
		local destAngel = (360 - angles - 90)
		return destAngel
	end


	if times == 1 then
		local rataSpeed = math.floor( 900 / (1 / cc.Director:getInstance():getAnimationInterval()) )
		local curAngel = self.imgDial:getRotation() % 360
		local speedSubValue = 0.1 -- 0.18 = (rataSpeed(原始) - 6) / ((2-0.5) * 60(FPS))
		local destAngel = calcTargetAngel()
		local resultAngel = destAngel % 360
		-- print("destAngel:::::::::", destAngel, resultAngel)
		self.imgDial:setRotation(curAngel)
		local isAjustAngel = false
		local timeCount = 0
		local function _timerCallback(dt)
			timeCount = timeCount + dt
			if timeCount > 5 then
				rataSpeed = rataSpeed - speedSubValue
				-- if rataSpeed < 6 then
				-- 	rataSpeed = 6
				-- end
				if rataSpeed < 0 then
					rataSpeed = 0
					-- compelete()
					return
				end
			end
			curAngel = curAngel + rataSpeed
			if timeCount > 7 and not isAjustAngel then
				-- if not isAjustAngel then
					-- --纠正角度和速度
					-- isAjustAngel = true
					-- curAngel = curAngel % 360
					-- destAngel = destAngel % 360
					-- if curAngel - destAngel > 0 then
						-- destAngel = destAngel + 360
					-- end
					-- -- 位移(destAngel - curAngel), 时间1 * 60(FPS), 初速度rataSpeed,末速度0 求加速度
					-- -- a = (vt^2 - v0^2) / 2*s
					-- speedSubValue = - (0 - rataSpeed * rataSpeed) / (2 * (destAngel - curAngel))
					
				-- end
				isAjustAngel = true
				local action1 = cc.RotateTo:create(2, resultAngel + 720)
				local action2 = cc.CallFunc:create(compelete)
				local action3 = cc.Sequence:create(action1, action2)
				self.imgDial:runAction(action3)
				-- if curAngel >= destAngel then
					-- curAngel = destAngel
					-- compelete()
				-- end
				-- self.imgDial:setRotation(curAngel)
			elseif not isAjustAngel then
				self.imgDial:setRotation(curAngel)
			end
		end

		_timer = cc.Director:getInstance():getScheduler():scheduleScriptFunc(_timerCallback, 0, false)
	else
		local action1 = cc.RotateBy:create(1, 2160)
		local action2 = cc.CallFunc:create(compelete)
		local action3 = cc.Sequence:create(action1, action2)
		self.imgDial:runAction(action3)
	end
end

-------------------------- Sound --------------------------
function GameScene:playResultSound(cIndex, aIndex, userScore)

	local basePath = "liushiwangchao/res/sound/"
        local baseName = "Normal_%s_%s"
        local colorList = {"Red", "Green", "Yellow"}
        local animalList = {"lion", "Panda", "Monkey", "Rabbit"}

	-- 获奖
	if userScore ~= 0 then
		baseName = "Lucky_%s_%s"
	end       
	local soundName = basePath .. string.format(baseName, colorList[cIndex + 1], animalList[aIndex + 1]) .. ".mp3"
	AudioEngine.playEffect(soundName)
	AudioEngine.playMusic(MUSIC_FREE, true)
end

function GameScene:playMusic( file )

  --if(self._bSound==false) then return; end 
  AudioEngine.stopMusic();
  file = "sound_res/"..file
  print("GameScene:playMusic( %s )",file);
  AudioEngine.playMusic(file,true)
  --]]
end
function GameScene:playEffect( file )
--  if not GlobalUserItem.bSoundAble then
  --  return
 -- end
  --if(self._bSound==false) then return; end
  file = "sound_res/"..file
  AudioEngine.playEffect(file)
end
--游戏清除
function GameScene:gameClean()
  self._selfBetItemScore = {0,0,0,0,0,0,0,0,0,0,0,0} 
  self.lBetTotalCount = {0,0,0,0,0,0,0,0,0,0,0,0}
  self:popPlaceJettonLayer(ccCMD.hidden)
  self:updateScoreItem()
end

function GameScene:initJettonIndex()

--[[
  local useritem = self._scene:GetMeUserItem()
  local minScore = useritem.lScore
  print("minScore is ===================="..minScore)
  print("the array count is ==================="..#self._jettonArray)
  local bfirstInvalid = true
  for i=1,6 do
    local value = self._jettonArray[i]
    print("value is ======================>"..value)
    if value > minScore then
      if 1 == i then
        bfirstInvalid = false
        break
      end
    end
  end
   
  --默认第一个筹码 
  if true == bfirstInvalid then
    self:setJettonIndex(1)
  else
    self:setJettonIndex(-1)
  end
  --]]
 -- 默认第2个筹码 
  self:setJettonIndex(2)
end

--显示路单记录
function GameScene:showRouteRecord(record)
  if not record then
    record = self.dwRouteListData;
  end
  local resultTotal = #record
  local t_show_num=5;
  if(resultTotal<5) then t_show_num=resultTotal; end
  local offSet = 0
  for i=1,5 do
        local winColor = self._rootNode:getChildByName(string.format("recordbg_%d", i))  --中奖颜色
        winColor:setVisible(false);
        if(i<=t_show_num) then    
          local oneRecord = record[resultTotal-offSet]
          if not oneRecord then  return  end     
          cclog("GameScene:showRouteRecord");
          winColor:setVisible(true);
          self:getResultInfo(oneRecord,winColor)
          offSet = offSet + 1
       end
  end 
end
-------------------------------------------------------------------------------------------------------------------
-- 广播事件处理 
-------------------------------------------------------------------------------------------------------------------

function GameScene:onEndEnterTransition()
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GAME_START, self, self.onGameStart)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GAME_FREE, self, self.onGameFree)	
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_PLACE_JETTON, self, self.onPlaceJetton)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GAME_END, self, self.onGameEnd)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_CLEAR_JETTON, self, self.onClearJetton)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GS_PLACE_JETTON, self, self.onGSPlaceJetton)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GAME_SHOWRESULT, self, self.onSubShowResult)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_GS_GAME_SCENE, self, self.onGFScene)
    global.g_gameDispatcher:addMessageListener(GAME_LSWC_SEND_RECORD, self, self.onSunRecord)


      --用户状态变更
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self, self.onRoomUserLeave)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserFree)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self, self.onGameServerConnectLost)
end

function GameScene:onStartExitTransition()
  self:gameDataReset()
  self:unSchedule()
  self:unScheduleMain();
  self:KillGameClock();
  
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GAME_START, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GAME_FREE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_PLACE_JETTON, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GAME_END, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_CLEAR_JETTON, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GS_PLACE_JETTON, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GAME_SHOWRESULT, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_GS_GAME_SCENE, self)
  global.g_gameDispatcher:removeMessageListener(GAME_LSWC_SEND_RECORD, self)

  --用户状态变更
 global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self)
 global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
 global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)
 global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self)
end
function GameScene:onGameServerConnectLost()
    self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
    exit_liushiwangchao();
end
function GameScene:onRoomUserLeave(playerId, tableId, chairId, status)
  if(playerId==self.currentPlayerID) then 
    self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
    exit_liushiwangchao();
  end
  --有人离开
end
function GameScene:onRoomUserFree(playerId, tableId, chairId, status)
if(playerId==self.currentPlayerID) then 
    self:gameDataReset()
    self:unSchedule()
    self:unScheduleMain();
    self:KillGameClock();
    exit_liushiwangchao();
  end
  --有人离开
end
function GameScene:onRoomUserPlay(playerId, tableId, chairId, status)
  --有人进来玩
end
function GameScene:onSunRecord( param )--出奖记录
   self:insertRecord(param);               --插入记录
end
function GameScene:onSubShowResult( param )
  cclog("GameScene:onSubShowResult( param )");
  if not self._resLoadFinish then return  end
  if nil ~= self._loadLayer then return end
  self.cbTimeLeave=param.DrawResultCount;
  --if(self._waiForGame_flag>0) then  return ;  end
  self._drawData.lGameScore=param.lGameScore;
  self._drawData.iUserScore=param.lWinScore;
  self._drawData.lInScore=param.lInScore;
  

  self:setGameStatus(ccCMD.IDI_GAME_DRAW_RESULT);                               
  self.m_bPlaceRecord = false;
  if nil ~= self._loadLayer then
         self:insertRecord(self._drawData);
        return
  end
  --self:playEffect("ANIMAL_MOVE.wav");  
  self:setGameStatus(ccCMD.IDI_GAME_DRAW_RESULT);  --游戏状态  
  self._rewardLayer:setVisible(true);              --结算层
  self:showDrawResult(self._drawData);             --显示结果
  self:insertRecord(self._drawData);               --插入记录
  self:resetData();        
  self.score_ = param.lGameScore;                       --玩家分数
  self.lscore=param.lGameScore;                       --玩家分数
  self:updateScoreItem(); 
end
--
function GameScene:onGameFree(param)
	cclog("********GameScene onGameFree");
     if not self._resLoadFinish then return  end
    self.cbTimeLeave=param.cbTimeLeave; 
    self:playMusic("Wait.mp3");
    self:setGameStatus(ccCMD.IDI_GAME_FREE);  
    self:resetGame();--重置游戏
    self:updateColor();  --更新颜色
    self:updateBetItemRatio(); --更新赔率
    self:gameClean(); --下注记录清除  
    self:showRouteRecord();--路单记录
    self._caijinStatus=1;  --
   
    self._bAnimalAction=false;
    self.score_ = param.iUserScore;                       --玩家分数
    self.lscore=param.iUserScore;                       --玩家分数
    self:updateScoreItem();
end

function GameScene:onGameStart( param )
    cclog("GameScene:onGameStart( param )");
    self.cbTimeLeave=param.cbTimeLeave;
    self:playEffect("START_BET.wav")    
    if not self._resLoadFinish then return end    
    if(self._waiForGame_flag>0) then 
       self._waiForGame_flag=0;
       if(self._waitForGameSpr~=nil) then 
          self._waitForGameSpr:removeFromParent();
          self._waitForGameSpr=nil;
       end
    end
   
    self:resetGame();
    
    self:setGameStatus(ccCMD.IDI_GAME_BET)--游戏状态
	self.score_ = param.iUserScore
	self._gameState = param.game_running_state;      
    self:resetAnimal();    --重置游戏
    --
	self._betState = param.game_running_state;
    self._clockType=0;          --时间类型
    self.nAnimalRotateAngle=param.nAnimalRotateAngle;  --动物转盘角度
    self.nPointerRatateAngle=param.nPointerRatateAngle; --指针转盘角度 
    if( self.last_private_mode~=4) then
       self._animLayer:setRotation3D(cc.vec3(0,360-self.nAnimalRotateAngle*15,0))
       self._arrow:setRotation3D(cc.vec3(0,self.nPointerRatateAngle*15+180,0))
    end
    self._animOdds = param.BetItemRatioList;              --动物倍率
	self._enjoyOdds = param.arrSTEnjoyGameAtt;            --彩金倍率
	self.score_ = param.iUserScore;                       --玩家分数
    self.lscore=param.iUserScore; 
    self.lUserItemBetTopLimit=param.AnimalJettonLimit;    --压分上限
    self.cbColorLightIndexList=param.ColorLightIndexList;
    cclog("GameScene:onGameStart( param )self.lUserItemBetTopLimit=%d",self.lUserItemBetTopLimit);
    --
   

    self:UpdateGameScore(self.score_);
    self:updateColor();          --更新颜色
    self:updateBetItemRatio();  --更新倍率  
    self:popPlaceJettonLayer()  --弹出下注层
    self:updateAreaMultiple();  --更新区域倍率      
    self:updateControl();       --更新按钮状态  
    self:initJettonIndex();     --更新筹码 
    self:showRouteRecord();     --显示路单记录
    --[[
    --test 测试自动续押
     self.bContinueRecord = true --一局只能续压一次
     for i=1,#self.m_lContinueRecord do  
          if self.m_lContinueRecord[i] > 0 then
            --发送加注 i是逻辑索引
            self:continueEvent(i)
          end
     end
  ----]]
    cclog("GameScene:onGameStart( param ) end");
end

function GameScene:onClearJetton( param )
	--清空押注   
    --tag=param.stAnimalInfo.eAnimal*3+param.stAnimalInfo.eColor;
     cclog("GameScene:onClearJetton( param ) param.chair_id=%d,self.currentChairId=%d", param.chair_id,self.currentChairId);
    if(param.errCode==0) then 
         if(param.chair_id==self.currentChairId) then 
       self.score_=param.userScore;
       self.lscore=param.userScore;
       self._selfBetItemScore = {0,0,0,0,0,0,0,0,0,0,0,0} 
     end
     local i=0;
     local j=0;    
     for i = 1, 4 do		 
         for j = 1, 3 do
            local t_index=(j-1)*3+i;
            self.lBetTotalCount[t_index]=param.TotalJettonScore[i][j];--动物倍率      
            cclog("GameScene:onClearJetton,lBetTotalCount(%d,%d)=%d",i,j,self.lBetTotalCount[t_index])    
         end
      end
     -- self.lBetTotalCount = {0,0,0,0,0,0,0,0,0,0,0,0}
      self:updateScoreItem();
    end  
end

function GameScene:onPlaceJetton( param )
    cclog("GameScene:onPlaceJetton( param ).........");
    if not self._resLoadFinish then return end   
   
   if GAMBLETYPE_ANIMALGAME == param.eGamble then
      cclog("GameScene:onPlaceJetton( param ) iTotalPlayerJetton=%d,iPlaceJettonScore=%d"
      ,param.iTotalPlayerJetton,param.iPlaceJettonScore);
       local tag=param.stAnimalInfo.eAnimal*3+param.stAnimalInfo.eColor;
       tag=tag+1;
       if(param.wChairID==self.currentChairId) then 
         if not self.m_bPlaceRecord then
            self.m_lContinueRecord = {0,0,0,0,0,0,0,0,0,0,0,0}
            self.m_bPlaceRecord = true
            self.bContinueRecord = true
         end
          self.m_lContinueRecord[tag] =param.iPlaceJettonScore --self.m_lContinueRecord[tag] + self._jettonArray[self._curJettonIndex]
          self.score_=param.iUsreScore;
          self._selfBetItemScore[tag]=param.iPlaceJettonScore;
       end
       self.lBetTotalCount[tag]=param.iTotalPlayerJetton   
   elseif GAMBLETYPE_ENJOYGAME == param.eGamble then

   end  
     self:UpdateGameScore(self.score_); 
end

function GameScene:onGameEnd(param )
   cclog("GameScene:onGameEnd(param )");
   if not self._resLoadFinish then return  end
   if nil ~= self._loadLayer then return end
  self.cbTimeLeave=param.dwTimeLeave;
  --if(self._waiForGame_flag>0) then return end
  self._drawData=param; --要进行运算 求出起始角度和终点角度  
  local  t_Draw_time=param.dwTimeLeave;--2秒用来显示结果 结果考虑在空闲时间显示
  self._drawData.lInScore=0;
  self.nAnimalRotateAngle=param.nCurrAnimalAngle;  --动物转盘角度
  self.nPointerRatateAngle=param.nCurrPointerAngle; --指针转盘角度 
  if( self.last_private_mode~=4) then 
     self._animLayer:setRotation3D(cc.vec3(0,360-self.nAnimalRotateAngle*15,0))
     self._arrow:setRotation3D(cc.vec3(0,self.nPointerRatateAngle*15+180,0))
  end
  self.last_private_mode= param.stWinAnimal.ePrizeMode;
  --动物转盘顺时针  狮子 熊猫 猴子 兔子
  self._drawData.nPointerAngle00=math.mod(param.nPointerAngle0,ccCMD.BET_ITEM_TOTAL_COUNT);
  self._drawData.nAnimalAngle00=math.mod(param.nAnimalAngle0,ccCMD.BET_ITEM_TOTAL_COUNT);
  self._drawData.nAnimalAngle = math.mod(param.nAnimalAngle,ccCMD.BET_ITEM_TOTAL_COUNT);
  self._drawData.nPointerAngle= math.mod(param.nPointerAngle,ccCMD.BET_ITEM_TOTAL_COUNT);
  --self:playEffect("PAYOUT.wav")
  
  self:setGameStatus(ccCMD.IDI_GAME_DRAW)                                --游戏状态
  self:popPlaceJettonLayer(ccCMD.hidden)                                 --隐藏下注层
  self._camera:runAction(cc.MoveTo:create(0.7,ccCMD.Camera_Rotate_Vec3));--滑动摄像机
    --角度复位到360区间
   local _arrow_angle=self._arrow:getRotation3D().y;  
   while(_arrow_angle<0)  do _arrow_angle=_arrow_angle+360; end
   while(_arrow_angle>360)  do _arrow_angle=_arrow_angle-360; end
   self._arrow:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   self._alphaSprite:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   self._seat:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   local _animLayer_angle=self._animLayer:getRotation3D().y;  
   while(_animLayer_angle<0)  do _animLayer_angle=_animLayer_angle+360; end
   while(_animLayer_angle>360)  do _animLayer_angle=_animLayer_angle-360; end
   self._animLayer:setRotation3D(cc.vec3(0,_animLayer_angle,0)); --角度复位为一区间
   ---
  self:arrowRunAction();                                                 --指针转动                                               
  --动画初始化
  self._bAnimalAction = true
  self._rotateSpeed = ccCMD.RotateMin;
  self._rotateStatus= ccCMD.Speed;
  self._rotateTime  = 0;
  self.ZhiZhengRottime=t_Draw_time*0.8;
  self.AnimalRottime=t_Draw_time
  self._animal_select_flag={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  self._color_select_flag={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
  self:AnimalRunAction();               
  --播放中奖动画
  if param.stWinAnimal.ePrizeMode==2 then --大三元
     self:playMusic("DRAW_DSY_BACK.mp3")
     self:showDSYAnim()
  elseif param.stWinAnimal.ePrizeMode==1 then--大四喜
     self:playMusic("DRAW_DSX_BACK.mp3");
     self:showDSXAnim();
  elseif  param.stWinAnimal.ePrizeMode==5 then --闪电
     self:playMusic("DRAW_SD_BACK.mp3");
     self:showSDAnim();  
  elseif param.stWinAnimal.ePrizeMode==3 then--彩金
     self:playMusic("DRAW_MGOLD_BACK.mp3")
     self:sohwCJAnim()
  elseif param.stWinAnimal.ePrizeMode==4 then --送灯
     self:playMusic("DRAW_DQ_BACK.mp3");
     self:showDQAnim();
     if(self.Last_Draw_end_time>0) then  t_Draw_time=self.Last_Draw_end_time;
     else  t_Draw_time=param.dwTimeLeave-(param.stWinAnimal.qwFlag*7);
     end
     if(t_Draw_time<1) then t_Draw_time=1; end
     self.ZhiZhengRottime=t_Draw_time*0.8;
     self.AnimalRottime=t_Draw_time;
  else--普通奖

     self:playMusic("DRAW_NORMAL_BACK.mp3");
     self.Last_Draw_end_time=self.cbTimeLeave;  --记录最近的结束时间 避免设置更新不比配
     self.AnimalRottime=t_Draw_time-0.5;
  end
  cclog("GameScene:onGameEnd(param ) end");
end

function GameScene:onPlaceJettonFail( param )
	-- dump(param)
end

function GameScene:onCloseBetView( )
	if self._betView then
		self._betView = nil
	end
end

function GameScene:onGSPlaceJetton( param )
    if nil ~= self._loadLayer then
       return
    end
	self._betState = LSWC_BS_BET
	self._animOdds = param.arrSTAnimalAtt
	self._enjoyOdds = param.arrSTEnjoyGameAtt
	self.score_ = param.iUserScore
	self:updateTopPanel(param["cbTimeLeave"], param["iUserScore"])
end

function GameScene:onGFScene( param )     
     cclog("GameScene:onGFScene( param )  ");
    --
    self:resetAnimal();
    self._seat:stopAllActions();
    self._rewardLayer:setVisible(false);
    --
	self._betState = param.game_running_state;
    self._clockType=0;          --时间类型
    self.nAnimalRotateAngle=param.nAnimalRotateAngle;  --动物转盘角度
    self.nPointerRatateAngle=param.nPointerRatateAngle; --指针转盘角度
    
    self.cbTimeLeave=param.cbTimeLeave;
    self._animOdds = param.BetItemRatioList;           --动物倍率
	self._enjoyOdds = param.arrSTEnjoyGameAtt;       --彩金倍率
	self.score_ = param.iUserScore;
    self.lUserItemBetTopLimit=param.AnimalJettonLimit;--压分上限
    self.cbColorLightIndexList=param.ColorLightIndexList;
    --
    self:updateColor();
    self:setGameStatus(self._gameStatus);       
    self:updateAreaMultiple(); --更新区域倍率      
    self:updateControl();      --更新按钮状态
   
    self:updateBetItemRatio();--更新倍率
    self:UpdateGameScore(self.score_);
end

-------------------------------------------------------------------------------------------------------------------

function GameScene:onExitClick()
	print('onExitClick')
	PopUpView.showPopUpView(ExitView)
end

function GameScene:onSetting()
	print('onSetting')
	PopUpView.showPopUpView(SettingView)
end

function GameScene:onRecord()
	print('onRecord')
	local view = PopUpView.showPopUpView(RecordView)
	view:setData(self._results)
end

function GameScene:onBet()             
	print('onBet')
	-- if LSWC_BS_BET == self._betState then
	if self._betView==nil and LSWC_GS_BEGIN == self._gameState then
	-- if LSWC_BS_BET == self._betState 
	-- 	and LSWC_GS_BEGIN == self._gameState then
		self._betView = PopUpView.showPopUpView(BetView)
		if self._betView then
			self._betView:setData(self._animOdds, self._enjoyOdds, self.score_, self._gameTimes)
		end
	end
end

function GameScene:onResult()
	print('onResult')
	local view = PopUpView.showPopUpView(ResultView)
	view:setData(self._results)
end


function GameScene:onHelpClick()
	print('onHelpClick')

	PopUpView.showPopUpView(HelpView)
end

function GameScene:onLabaBtnClick()
	print('onHelpClick')
	PopUpView.showPopUpView(ui_setting_t)
end

function GameScene:onVolumeClick( )
	PopUpView.showPopUpView(ui_setting_t)
end
function GameScene:UpdateGameScore(c_score)
   self.lscore=c_score;
   self:updateScoreItem();
end
--更新分数
function GameScene:updateScoreItem()
 --刷新玩家自己分数
 local myScore = self._PlaceJettonLayer.rootNode._myScore
 if(self.lscore==nil) then self.lscore=0; end
 if not myScore then
   local str =  ExternalFun.formatScoreText(self.lscore)
   myScore =ccClipText:createClipText(cc.size(140, 22),str,"fonts/round_body.ttf",20)
   myScore:setTextColor(cc.c4b(255,255, 0, 255))--cc.YELLOW)
   myScore:setAnchorPoint(cc.p(0.0,0.5))
   myScore:setPosition(cc.p(270,261))
   self._PlaceJettonLayer.rootNode:addChild(myScore)
   self._PlaceJettonLayer.rootNode._myScore = myScore
 else
    local str =  ExternalFun.formatScoreText(self.lscore)
    myScore:setString(str)
 end
 if (self._game_score_spr~=nil) then 
    local str =  ExternalFun.formatScoreText(self.lscore)
    self._game_score_spr:setString(str)
 end
  --   self.lBetTotalCount[tag]=param.iTotalPlayerJetton 
  --     self._selfBetItemScore[tag]=param.iPlaceJettonScore
 --刷新下注区域分数
 for i=1,ccCMD.BET_ITEM_COUNT do
   local betPanel = self._PlaceJettonLayer.rootNode:getChildByName(string.format("Panel_%d", i))
   assert(betPanel)
   local totalScore = betPanel:getChildByTag(1) --总注额 
   local userScore = betPanel:getChildByTag(2)  --我的下注
   local totalNum = self.lBetTotalCount[i]
   local userNum = self._selfBetItemScore[i]
   if not totalScore and not userScore then
     local str =  ExternalFun.formatScoreText(totalNum)
     totalScore = ccClipText:createClipText(cc.size(90, 22),str,"fonts/round_body.ttf",18)
     totalScore:setTag(1)
     totalScore:setAnchorPoint(cc.p(0.0,0.5))
     totalScore:setPosition(cc.p(82,21))
     betPanel:addChild(totalScore)

     str = ExternalFun.formatScoreText(userNum)
     userScore =ccClipText:createClipText(cc.size(90, 22),str,"fonts/round_body.ttf",18)
     userScore:setTag(2)
     userScore:setAnchorPoint(cc.p(0.0,0.5))
     userScore:setPosition(cc.p(60,63))
     betPanel:addChild(userScore)
   elseif totalScore and userScore then
      local str =  ExternalFun.formatScoreText(totalNum)
      totalScore:setString(str) 
      str = ExternalFun.formatScoreText(userNum)
      userScore:setString(str)
   end
 end
end

--更新区域赔率
function GameScene:updateBetItemRatio()
  local t_index=1;
  for i = 1, 4 do	
      for j = 1, 3 do       
         local bet = self._PlaceJettonLayer.rootNode:getChildByName(string.format("btn_bet_%d", t_index))
         assert(bet)
         local multiple = self._animOdds[i][j]
         local multipleTTF = bet:getChildByTag(1)
         local t_mul_str=nil;
          if(multiple<10) then t_mul_str=string.format("0%d", multiple);
          else t_mul_str=string.format("%d", multiple); end
         if not multipleTTF then    
           local game_mul_Show_pos=
           {
            cc.p(72,37),cc.p(72,35),cc.p(72,34),cc.p(71,39),cc.p(71,35),cc.p(71,35),cc.p(71,33),cc.p(71,32),cc.p(71,30),cc.p(72,25),cc.p(72,25),cc.p(72,25),
           }
           multipleTTF = cc.LabelAtlas:_create(t_mul_str,"game_res/shuzi2.png",17,26,string.byte("0"))
           --multipleTTF = cc.LabelAtlas:_create(string.format("%d",multiple),"game_res/shuzi2.png",17,26,string.byte("0"))
           multipleTTF:setTag(1)
           multipleTTF:setScale(1335.0/1280.0,750.0/720.0);
           multipleTTF:setAnchorPoint(cc.p(0.5,0.0))
           multipleTTF:setPosition(game_mul_Show_pos[t_index])
           bet:addChild(multipleTTF)
        else
          multipleTTF:setString(t_mul_str)
        end
        t_index=t_index+1;
      end
  end
 
end


--开奖动画
function GameScene:showDSYAnim()--大三元
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sy_0.png")
    local dsy = cc.Sprite:createWithSpriteFrame(frame)
    dsy:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
    self:addChild(dsy)

    local anim = cc.AnimationCache:getInstance():getAnimation("SYAnim")
    local animate = cc.Animate:create(anim)
    local repeat_=cc.Repeat:create(animate,2);
    local action = cc.Sequence:create(repeat_,cc.CallFunc:create(function(  )
        dsy:removeFromParent()
    end))
    dsy:runAction(action)
end

function GameScene:showDSXAnim()--大四喜
    cclog("function GameScene:showDSXAnim()--大四喜");
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sx_0.png")
    local dsx = cc.Sprite:createWithSpriteFrame(frame)
    dsx:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
    self:addChild(dsx)
    local anim = cc.AnimationCache:getInstance():getAnimation("SXAnim")
    local animate = cc.Animate:create(anim)
    local repeat_=cc.Repeat:create(animate,2);
   -- local repeat_ttt=cc.RepeatForever:create(animate);
    local action = cc.Sequence:create(repeat_,cc.CallFunc:create(function(  )
        dsx:removeFromParent()
    end))
    dsx:runAction(action)
end
function GameScene:sohwCJAnim()--彩金
   for i=1,#self._animals do 
      local animal = self._animals[i]
      animal:setTexture("3d_res/im_yellow.png")
   end
   self:runAction(cc.Sequence:create(cc.DelayTime:create(1.05),cc.CallFunc:create(function (  )
      for i=1,#self._animals do 
          local animal = self._animals[i]
          local animIndex = math.mod(i-1,4)
          local modelFile = self:getAnimRes(animIndex)
          local texture = self:getAnimIMG(animIndex)
          animal:setTexture(texture)
      end
   end)))
   local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("cj_0.png")
   local cj = cc.Sprite:createWithSpriteFrame(frame)
   cj:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
   self:addChild(cj)

    local anim = cc.AnimationCache:getInstance():getAnimation("CJAnim")
    local animate = cc.Animate:create(anim)
    local repeat_=cc.Repeat:create(animate,2);
    local action = cc.Sequence:create(repeat_,cc.CallFunc:create(function(  )
        cj:removeFromParent()
    end))

    cj:runAction(action)
end

function GameScene:showSDAnim()--闪电加倍
    local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("sd_0.png")
    local sd = cc.Sprite:createWithSpriteFrame(frame)
    sd:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
    self:addChild(sd)

    local anim = cc.AnimationCache:getInstance():getAnimation("SDAnim")
    local animate = cc.Animate:create(anim)
    local repeat_=cc.Repeat:create(animate,3);
    local action = cc.Sequence:create(repeat_,cc.CallFunc:create(function(  )
        sd:removeFromParent()
    end))

    sd:runAction(action)
    if(self._drawData.stWinAnimal.qwFlag==2  or self._drawData.stWinAnimal.qwFlag==3) then     
         local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("sd_x%d.png",self._drawData.stWinAnimal.qwFlag))   
         if(frame) then 
           local multiple = cc.Sprite:createWithSpriteFrame(frame);
            multiple:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
            multiple:setVisible(false)
            multiple:setScale(0.1)
            self:addChild(multiple)
            local delay0 = cc.DelayTime:create(0.5)
            local callfun0 = cc.CallFunc:create(function() multiple:setVisible(true) end)
            local scaleTo = cc.ScaleTo:create(0.17,1.0)
            local delay2 = cc.DelayTime:create(2.0)
            local callfun1 = cc.CallFunc:create(function() multiple:removeFromParent() end)
            local sequence = cc.Sequence:create(delay0,callfun0,scaleTo,delay2,callfun1)
             multiple:runAction(sequence)
         end   
    end

   
end



--动物移动
function GameScene:runMovEndAction(dt)
   if(self._end_mov_flag>0) then       
      if(self._end_mov_flag==1) then         
         self._end_mov_angle=self._end_mov_angle+10;--self._end_mov_angle_rot_speed;      
         while(self._end_mov_angle>360) do  self._end_mov_angle=self._end_mov_angle-360;end
         if(self._end_mov_Y<4) then 
             self._end_mov_Y=self._end_mov_Y+(self._end_mov_Y_speed);
             if(self._end_mov_Y>4) then         
               self._end_mov_Y=4.0000001;
              end
         end                  
         if( self._end_mov_X>0.00001 or self._end_mov_X<-0.00001) then --0
             self._end_mov_X=self._end_mov_X+(self._end_mov_X_speed);
             if(self._end_mov_X_speed>0 and self._end_mov_X>0.000000001) then self._end_mov_X=0; end
             if(self._end_mov_X_speed<0 and self._end_mov_X<-0.00000001) then self._end_mov_X=0; end
         end
         if( self._end_mov_Z>0.00001 or self._end_mov_Z<-0.00001) then --0
             self._end_mov_Z=self._end_mov_Z+(self._end_mov_Z_speed);
             if(self._end_mov_Z_speed>0 and self._end_mov_Z>0.000000001) then self._end_mov_Z=0; end
             if(self._end_mov_Z_speed<0 and self._end_mov_Z<-0.00000001) then self._end_mov_Z=0; end
         end
         if(self._end_mov_Animal) then  
           self._end_mov_Animal:setRotation3D(cc.vec3(0, self._end_mov_angle, 0))
           self._end_mov_Animal:setPosition3D(cc.vec3( self._end_mov_X,self._end_mov_Y,self._end_mov_Z));
        end 
        if(self._end_mov_Y>3.999999 and self._end_mov_Y<4.00001
            and  self._end_mov_X>-0.00001 and self._end_mov_X<0.00001
            and  self._end_mov_Z>-0.00001 and self._end_mov_Z<0.00001) then          
              self._end_mov_flag=2;      
              local angle=180-self._animLayer:getRotation3D().y;                     
              while(angle<0) do angle=angle+360; end
              while(angle>360)do angle=angle-360; end  
              while(self._end_mov_angle>angle) do self._end_mov_angle=self._end_mov_angle-360; end
           end          
      elseif(self._end_mov_flag==2) then        
            self._end_mov_Y=4;
            self._end_mov_X=0;
            self._end_mov_Z=0;      
            self._end_mov_flag=3;  
           -- self._end_mov_angle=self._end_mov_angle;  
            local angle=180-self._animLayer:getRotation3D().y;                     
            while(angle<0) do angle=angle+360; end
            while(angle>360)do angle=angle-360; end                          
             if(self._end_mov_Animal) then 
                   self._end_mov_Animal:stopAllActions();
                   local function rot_end_func()
                     cclog("GameScene:runMovEndAction rot_end_func");
                      self._end_mov_angle=angle ;
                      self._end_mov_timer=0;
                      self._end_mov_flag=0;  
                  end               
                  local rot_end_funccall=cc.CallFunc:create(rot_end_func);  
                  local rot_action_=cc.RotateTo:create(0.5, cc.vec3(0,angle,0));
                  local t_seq=cc.Sequence:create(rot_action_,rot_end_funccall);
                  self._end_mov_Animal:runAction(t_seq);
                  local index= self._end_mov_Animal:getTag()-1;
                  local resType = math.mod(index,4); 
                  local modelFile = self:getAnimRes(resType)
                  local animtion = cc.Animation3D:create(modelFile)
                  self._end_mov_Animal:stopActionByTag(GameScene.AnimalTag.Tag_Animal)
                  local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1])
                  local action  = cc.RepeatForever:create(animate)
                  action:setTag(GameScene.AnimalTag.Tag_Animal)
                  self._end_mov_Animal:runAction(action)          
        end                     
      end--==1
   end-->0
end
--动物转动 
function GameScene:arrowRunAction()
  local stopAngle=math.mod(self._drawData.nPointerAngle*15+180,360) 
  stopAngle = stopAngle + 360*10
  local action = cc.EaseCircleActionInOut:create(cc.RotateTo:create(12, cc.vec3(0,stopAngle,0)))
  self._arrow:runAction(action)
  self._alphaSprite:runAction(action:clone())
  self._seat:runAction(action:clone())
end
function GameScene:AnimalRunAction()
  self._rotateStatus =ccCMD.Stop;
  self._bAnimalAction = false;
  local stopAngle = math.mod(self._drawData.nAnimalAngle*15,360)
  stopAngle = stopAngle - 360*8
  local rot_action = cc.EaseSineInOut:create(cc.RotateTo:create(15, cc.vec3(0,stopAngle,0)));
  local function Endcallback()
      self._rotateStatus =ccCMD.Stop;
      self._bAnimalAction = false;
      self:rotateEnd();
  end
  local callEnd=cc.CallFunc:create(Endcallback)
  local action=cc.Sequence:create(rot_action,callEnd)
  self._animLayer:runAction(action)
end
--
function GameScene:rotateEnd()

  cclog("function GameScene:rotateEnd()..ePrizeMode=%d",self._drawData.stWinAnimal.ePrizeMode);
  self._caijinStatus = 0 
  if self._gameStatus ~=ccCMD.IDI_GAME_DRAW then
    return ;
  end
  if(self._drawData.stWinAnimal.ePrizeMode==4) then--送灯
    self:gunDeal() --打枪处理
    return
  elseif (self._drawData.stWinAnimal.ePrizeMode==2) then--大三元
    self:showSeatAnim(1)
      --对应的动物跳舞
     for i=1,24 do
          local resType = math.mod(i-1,4)
          if(resType==self._drawData.stWinAnimal.stAnimalInfo.eAnimal and self._animals[i]~=nil) then 
             self._animals[i]:setScale(1.3);         
             local modelFile = self:getAnimRes(resType)
             local animtion = cc.Animation3D:create(modelFile)
             self._animals[i]:stopActionByTag(GameScene.AnimalTag.Tag_Animal)
             local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1])
             local action  = cc.RepeatForever:create(animate)
             action:setTag(GameScene.AnimalTag.Tag_Animal)
             self._animals[i]:runAction(action)   
        end
     end
      --
    return
  elseif (self._drawData.stWinAnimal.ePrizeMode==1) then --大四喜
    cclog("self._drawData.stWinAnimal.ePrizeMode==1 aaaa eAnimal=%d,eColor=%d"
    ,self._drawData.stWinAnimal.stAnimalInfo.eAnimal,self._drawData.stWinAnimal.stAnimalInfo.eColor)
    self:showSeatAnim(0);
    ---所有对应颜色进行跳舞     self.cbColorLightIndexList=param.ColorLightIndexList;
  -- self._drawData.nPointerAngle00=math.mod(param.nPointerAngle0,ccCMD.BET_ITEM_TOTAL_COUNT);
  --self._drawData.nAnimalAngle00=math.mod(param.nAnimalAngle0,ccCMD.BET_ITEM_TOTAL_COUNT);
  --self._drawData.nAnimalAngle = math.mod(param.nAnimalAngle,ccCMD.BET_ITEM_TOTAL_COUNT);
  --self._drawData.nPointerAngle= math.mod(param.nPointerAngle,ccCMD.BET_ITEM_TOTAL_COUNT);
    local animal_index_add=self._drawData.nAnimalAngle;
    --local animal_index_add=self._drawData.stWinAnimal.stAnimalInfo.eAnimal;

    for i=1,24 do
     if(self.cbColorLightIndexList[i]==self._drawData.stWinAnimal.stAnimalInfo.eColor) then   
         cclog("self._drawData.stWinAnimal.ePrizeMode==1 i=%d",i);
        local t_index=animal_index_add+i;
        if(t_index>24) then t_index=t_index-24; end
        if(self._animals[t_index]~=nil) then 
            self._animals[t_index]:setScale(1.3);
             if(self._drawData.stWinAnimal.stAnimalInfo.eColor==0) then  self._animals[t_index]:setColor(COLOR_RED);
             elseif(self._drawData.stWinAnimal.stAnimalInfo.eColor==1) then  self._animals[t_index]:setColor(COLOR_GREEN);
             elseif(self._drawData.stWinAnimal.stAnimalInfo.eColor==2) then  self._animals[t_index]:setColor(COLOR_YELLOW); end
             local resType = math.mod(t_index-1,4)
             local modelFile = self:getAnimRes(resType)
             local animtion = cc.Animation3D:create(modelFile)
             self._animals[t_index]:stopActionByTag(GameScene.AnimalTag.Tag_Animal)
             local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1])
             local action  = cc.RepeatForever:create(animate)
             action:setTag(GameScene.AnimalTag.Tag_Animal)
             self._animals[t_index]:runAction(action)   
        end
     end
    end-- for i=1,24 do  
    return 

  else   --常规中奖
      local index =self._drawData.nAnimalAngle00;
      index = math.mod(index,24);--动物索引
      self._drawIndex = index + 1;
      for i,v in ipairs(self._animals) do
        local animal = v
        if animal:getTag() == self._drawIndex then  
          animal:setScale(1.2);        
          local t_psr_pos=animal:getPosition3D();
          self._end_mov_length=0.5;
          if(self._end_mov_length<1)then self._end_mov_length=1; end
          self._end_mov_flag=1;       
          self._end_mov_Y=t_psr_pos.y;
          self._end_mov_X=t_psr_pos.x;
          self._end_mov_Z=t_psr_pos.z;
          self._end_mov_Y_speed=(4.0-t_psr_pos.y)/(self._end_mov_length*60);
          self._end_mov_X_speed=(0.0-t_psr_pos.x)/(self._end_mov_length*60);
          self._end_mov_Z_speed=(0.0-t_psr_pos.z)/(self._end_mov_length*60);
          self._end_mov_Step=0;
          self._end_mov_timer=0;
          self._end_mov_Animal=animal;   
          self._end_mov_angle=animal:getRotation3D().y;
          self._end_mov_angle_rot_speed=5;
          break;
        end
      end
      self:playEffect(string.format("Animal_%d.wav", math.floor(self._drawData.stWinAnimal.stAnimalInfo.eAnimal*3+self._drawData.stWinAnimal.stAnimalInfo.eColor)));
      if(self._drawData.stWinAnimal.ePrizeMode==3) then--彩金
        self:showSeatAnim(1)
      else
        self:showSeatAnim(0)
      end
      self:playEffect("START_DRAW.wav")
      self._camera:runAction(cc.MoveTo:create(0.5, ccCMD.Camera_Win_Vec3))
  end
end

function GameScene:showSeatAnim(nType)
  --
  cclog("GameScene:showSeatAnim(nType=%d)",nType);
  local redStr = "3d_res/model_5/red.png"
  local greenStr = "3d_res/model_5/green.png"
  local yellowStr = "3d_res/model_5/yellow.png"
  --
  if 0 == nType then
    local color = self._drawData.stWinAnimal.stAnimalInfo.eColor --cbPointerColor
    local file = redStr
    if 1 == color then
      file = greenStr
    elseif 2 == color then
      file = yellowStr  
    end
    local normal = "3d_res/model_5/tex.jpg"
    local action = cc.Sequence:create(
      cc.DelayTime:create(0.37),
      cc.CallFunc:create(function () self._seat:setTexture(file) end),
      cc.DelayTime:create(0.37),
      cc.CallFunc:create(function ()self._seat:setTexture(normal) end)
      )
    self._seat:runAction(cc.RepeatForever:create(action))
  else
      local action =  cc.Sequence:create(
        cc.DelayTime:create(0.37),
        cc.CallFunc:create(function ()  self._seat:setTexture(redStr) end),
        cc.DelayTime:create(0.37),
        cc.CallFunc:create(function () self._seat:setTexture(greenStr) end),
        cc.DelayTime:create(0.37),
        cc.CallFunc:create(function () self._seat:setTexture(yellowStr) end)
        )
      self._seat:runAction(cc.RepeatForever:create(action));
  end

end

function GameScene:showDQAnim()--送灯
  local frame = cc.Sprite:create("game_res/im_gun_frame.png",cc.rect(0,0,188,139))
  frame:setPosition(yl.WIDTH/2,yl.HEIGHT/2)
  frame:setTag(Tag.Tag_GunNum)
  frame:setScale(0.77)
 self:addChild(frame)
  local frames = {}
  local Frame0=cc.SpriteFrame:create("game_res/im_gun_frame.png",cc.rect(0,0,188,139));
  table.insert(frames, Frame0)       
  local Frame1=cc.SpriteFrame:create("game_res/im_gun_frame.png",cc.rect(188,0,188,139));
  table.insert(frames, Frame1)       
  local  animation =cc.Animation:createWithSpriteFrames(frames,0.2)
  local animate = cc.Animate:create(animation)
  frame:runAction(cc.RepeatForever:create(animate));
  --self._drawData.stWinAnimal.qwFlag=1
  self.gamegunNum_spr = GameGunNum:create(self)  --滚动数字
  -- self.gamegunNum_spr:setPosition(0,(yl.HEIGHT-720)/2);
  self.gamegunNum_spr:setPosition(0,(yl.HEIGHT-720)*0.77/4);

  --gamegunNum:setTag(Tag.Tag_GunNum)
  frame:addChild( self.gamegunNum_spr,Tag.Tag_GunNum,Tag.Tag_GunNum);
   self.gamegunNum_spr:setStopIndex(self._drawData.stWinAnimal.qwFlag)
  print("count is =============="..self._drawData.stWinAnimal.qwFlag )

end
function GameScene:unSchedule()   
   cclog(" GameScene:unSchedule()....");
    --游戏定时器
    if nil ~= self._gunScheduleUpdate then
        scheduler:unscheduleScriptEntry(self._gunScheduleUpdate)
        self._gunScheduleUpdate = nil
    end
end


function GameScene:gunDeal()

  self._gunIndex =1
  --动物跳舞
  self:unSchedule() ;
  self._animal_select_flag[self._drawData.nAnimalAngle00+1]=1;
  self._color_select_flag[self._drawData.nPointerAngle00+1]=1;
  local index =self._drawData.nAnimalAngle00;  
  index = math.mod(index,24)
  local animal = self._animals[index+1]
  if(animal~=nil) then 
     if(self._drawData.stWinAnimal.stAnimalInfo.eColor==0) then  animal:setColor(COLOR_RED);
     elseif(self._drawData.stWinAnimal.stAnimalInfo.eColor==1) then  animal:setColor(COLOR_GREEN);
     elseif(self._drawData.stWinAnimal.stAnimalInfo.eColor==2) then  animal:setColor(COLOR_YELLOW); end
     animal:setScale(1.3);
     local resType = math.mod(index,4);
     local modelFile = self:getAnimRes(resType);
     local animtion = cc.Animation3D:create(modelFile);
     animal:stopActionByTag(GameScene.AnimalTag.Tag_Animal);
     local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1]);
     local action  = cc.RepeatForever:create(animate);
     action:setTag(GameScene.AnimalTag.Tag_Animal);
     animal:runAction(action);   
     self:playEffect(string.format("Animal_%d.wav", math.floor(self._drawData.stWinAnimal.stAnimalInfo.eAnimal*3+self._drawData.stWinAnimal.stAnimalInfo.eColor)));
  end 
  --送灯实现
 --游戏定时器
   if nil == self._gunScheduleUpdate then
      local function update(dt)
         self:GunUpdate(dt);
      end 
      self._gunScheduleUpdate = scheduler:scheduleScriptFunc(update,7, false)
   end
end

function GameScene:GunUpdate(dt)
   --------------------------
  -- cclog("GameScene:GunUpdate( dt ) self._gunIndex=%d",self._gunIndex);
   if self._gunIndex >self._drawData.stWinAnimal.qwFlag then
    --  cclog("GameScene:GunUpdate( dt ) self._gunIndex=%d aaaaaaaaaaaa end",self._gunIndex);
      self:unSchedule();
      self:showSeatAnim(1);
      self:removeChildByTag(Tag.Tag_GunNum);
      self.gamegunNum_spr=nil;
      return
   end
   --复位到360区间
   local _arrow_angle=self._arrow:getRotation3D().y;  
   while(_arrow_angle<0)  do _arrow_angle=_arrow_angle+360; end
   while(_arrow_angle>360)  do _arrow_angle=_arrow_angle-360; end
   self._arrow:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   self._alphaSprite:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   self._seat:setRotation3D(cc.vec3(0,_arrow_angle,0)); --角度复位为一区间
   local _animLayer_angle=self._animLayer:getRotation3D().y;  
   while(_animLayer_angle<0)  do _animLayer_angle=_animLayer_angle+360; end
   while(_animLayer_angle>360)  do _animLayer_angle=_animLayer_angle-360; end
   self._animLayer:setRotation3D(cc.vec3(0,_animLayer_angle,0)); --角度复位为一区间
   --指针
  cclog("GameScene:GunUpdate( dt ) _gunIndex=%d,eAnimal=%d,eColor=%d"
  ,self._gunIndex,self._drawData.stWinAnimal.arrstRepeatModePrize[self._gunIndex].eAnimal
  ,self._drawData.stWinAnimal.arrstRepeatModePrize[self._gunIndex].eColor);
  --查找符合条件的
  local t_animal_v=self._drawData.stWinAnimal.arrstRepeatModePrize[self._gunIndex].eAnimal;
  local t_color_v=self._drawData.stWinAnimal.arrstRepeatModePrize[self._gunIndex].eColor;
  local select_color_index=0;
  local select_animal_index=0;
  local i=0;--规则就是从小到大查找来保证一致
  local color_str="";
  for  i=1,24 do 
       if(select_animal_index==0 and self._animal_select_flag[i]==0 and ((i-1)%4)==t_animal_v) then 
          select_animal_index=i-1;
          self._animal_select_flag[i]=1;
       end
   end
   for  i=1,24 do 
       if(self._color_select_flag[i]==0 and select_color_index==0 and self.cbColorLightIndexList[i]==t_color_v) then    
          select_color_index=i-1;
          self._color_select_flag[i]=1;
       end
       color_str=color_str..self.cbColorLightIndexList[i]..",";
   end 
   local t_repeat_pointAngle=24-select_color_index;
   local t_repeat_AnimalAngle=select_color_index-select_animal_index;
   t_repeat_AnimalAngle=24-t_repeat_AnimalAngle;
   --转动指针
   local stopAngle = math.mod((t_repeat_pointAngle*15+180),360);
   stopAngle = stopAngle + 360*2;
   local action =cc.EaseSineInOut:create(cc.RotateTo:create(4, cc.vec3(0,stopAngle,0)));

   self._arrow:stopAllActions();
   self._alphaSprite:stopAllActions();
   self._seat:stopAllActions();
   --
   self._arrow:runAction(action);
   self._alphaSprite:runAction(action:clone());
   self._seat:runAction(action:clone());
   --转动轮盘   
   local animal_stopAngle =t_repeat_AnimalAngle*15;
   animal_stopAngle = animal_stopAngle-360*3;
   --cclog("GameScene:GunUpdate stopAngle=%f,_repeat_AnimalAngle=%f",animal_stopAngle,t_repeat_AnimalAngle);
   local animal_action =cc.EaseSineInOut:create(cc.RotateTo:create(4.5, cc.vec3(0,animal_stopAngle,0)));
   self._animLayer:stopAllActions();
   self._animLayer:runAction(animal_action);
   --出结果
   self:runAction(cc.Sequence:create(cc.DelayTime:create(5),cc.CallFunc:create(function()
       local animal = self._animals[select_animal_index+1];
       if(animal~=nil) then 
           if(t_color_v==0) then  animal:setColor(COLOR_RED);
           elseif(t_color_v==1) then  animal:setColor(COLOR_GREEN);
           elseif(t_color_v==2) then  animal:setColor(COLOR_YELLOW); end
           animal:setScale(1.3);
            self:playEffect(string.format("Animal_%d.wav", math.floor(t_color_v+t_animal_v*3)));
           local resType = math.mod(select_animal_index,4);
           local modelFile = self:getAnimRes(resType);
           local animtion = cc.Animation3D:create(modelFile);
           animal:stopActionByTag(GameScene.AnimalTag.Tag_Animal);
           local animate = cc.Animate3D:create(animtion, self._animalTimeFree[resType+1], self._animalTimeWin[resType+1]);
           local action  = cc.RepeatForever:create(animate);
           action:setTag(GameScene.AnimalTag.Tag_Animal);
           animal:runAction(action);   
       end 
   end)))
   --self:SetGameClock(0,0,self.cbDrawTimeCount);
   self._gunIndex = self._gunIndex + 1
    --转数更新
   if(self._gunIndex<=self._drawData.stWinAnimal.qwFlag) then 
     local frame =self:getChildByTag(Tag.Tag_GunNum);
     if(frame) then 
        --self.gamegunNum =frame:getChildByTag(Tag.Tag_GunNum);
        if( self.gamegunNum_spr) then 
             self.gamegunNum_spr:MovToNext();
       end
     end
   end
end


function GameScene:GetJettonRecord()
  local record = 0
  for i=1,#self.m_lContinueRecord do
    record = record + self.m_lContinueRecord[i]
  end
  return record
end
function GameScene:resetData()
  if self:GetJettonRecord() == 0 then
    self.bContinueRecord = true
  else
    self.bContinueRecord = false
  end
end
--插入路单记录
function GameScene:insertRecord(oneRecord)
   table.insert(self.dwRouteListData, oneRecord)
   if(#self.dwRouteListData>6) then 
      table.remove(self.dwRouteListData, 1)  
   end
   self:showRouteRecord(self.dwRouteListData)
end
--显示开奖结果
function GameScene:showDrawResult( result )
  cclog("GameScene:showDrawResult( result )");
  local winColor =self._rewardLayer:getChildByName("winType");  --中奖颜色result.stWinAnimal.stAnimalInfo.eAnimal--
  --local value = result.stWinAnimal.stAnimalInfo.eAnimal;--bit:_or(result.dwDrawBetItem,result.dwDrawWeaveItem)
  self:getResultInfo(result,winColor); 
  --自己下注
  local allScore = result.lInScore;
  --dump(self._selfBetItemScore, "the add score is =============== >", 5)
  if not self._MeAddScoreTTF then
    self._MeAddScoreTTF = cc.LabelAtlas:_create(string.format("%d",allScore),"game_res/shuzi1.png",18,25,string.byte("0"))
    self._MeAddScoreTTF:setAnchorPoint(cc.p(0.0,0.5))
    self._MeAddScoreTTF:setPosition(cc.p(20,-162))
    self._rewardLayer:addChild(self._MeAddScoreTTF)
  else
    self._MeAddScoreTTF:setString(string.format("%d",allScore))
  end
  --输赢
  local getScore = result.iUserScore
  if not self._getAddScoreTTF then
    local str = string.format("%d",getScore)
    if getScore < 0 then
      str = string.format(";%d",getScore)
    end
    self._getAddScoreTTF = cc.LabelAtlas:_create(str,"game_res/shuzi1.png",18,25,string.byte("0"))
    self._getAddScoreTTF:setAnchorPoint(cc.p(0.0,0.5))
    self._getAddScoreTTF:setPosition(cc.p(50,-258))
    self._rewardLayer:addChild(self._getAddScoreTTF)
  else
    local str = string.format("%d",getScore)
    if getScore < 0 then
      str = string.format(";%d",getScore)
    end
    self._getAddScoreTTF:setString(str)
  end
  --self._scene.m_lMeGrade =  self._scene.m_lMeGrade + getScore
end

function GameScene:getResultInfo(result,target)
  if(result.stWinAnimal==nil)then  return ; end
  local color =result.stWinAnimal.stAnimalInfo.eColor-- bit:_and(routeData,ccCMD.BET_ITEM_TYPE_MASK)
  cclog("function GameScene:getResultInfo(result,target)color=%d",color);
  if  result.stWinAnimal.ePrizeMode==2 then --0 ~= bit:_and(routeData,ccCMD.DRAW_RESULT_DSY) then--大三元
    color = ccCMD.RESULT_DSY
  end
  if color == 0 then
    color = ccCMD.RESULT_RED
  elseif color == 1 then
    color = ccCMD.RESULT_GREEN
  elseif color == 2 then
    color = ccCMD.RESULT_YELLOW
  end
  print("the color is =============="..color)
  target:loadTexture(string.format("tubiao%d.png",color),1) 
  local animalType = {ccCMD.DRAW_RESULT_LION,ccCMD.DRAW_RESULT_PANDER,ccCMD.DRAW_RESULT_MONKEY,ccCMD.DRAW_RESULT_RABBIT}
  local winAnimal = target:getChildByName("win_animal")
  winAnimal:setTag(1)
  winAnimal:setVisible(true)
  for i=2,6 do
     target:removeChildByTag(i)
  end
  --大三元
  if result.stWinAnimal.ePrizeMode==2 then --0 ~= bit:_and(routeData,ccCMD.DRAW_RESULT_DSY) then 
      winAnimal:loadTexture(string.format("tubiao%d.png", 29+result.stWinAnimal.stAnimalInfo.eAnimal),1)
      return  target
  end
   cclog("function GameScene:getResultInfo(result,target)cccolor=%d",color);
  --大四喜
  if result.stWinAnimal.ePrizeMode==1 then -- 0 ~= bit:_and(routeData,ccCMD.DRAW_RESULT_DSX) then
    winAnimal:loadTexture("tubiao33.png",1) 
    return target
  end
  --闪电
  if result.stWinAnimal.ePrizeMode==5 then --0 ~= bit:_and(routeData,ccCMD.DRAW_RESULT_LEVIN) then
     local index = 35
     if result.stWinAnimal.qwFlag>2 then --0 ~=  bit:_and(routeData,ccCMD.LEVIN_RATIO_MULTI3) then
       index = 36
     end
      winAnimal:loadTexture(string.format("tubiao%d.png", 29+result.stWinAnimal.stAnimalInfo.eAnimal),1)
      local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(string.format("tubiao%d.png", index))
      local light = cc.Sprite:createWithSpriteFrame(frame)
      light:setPosition(cc.p(target:getContentSize().width/2,target:getContentSize().height/2))
      light:setTag(2)
      target:addChild(light)
      return  target
  end
  --打枪
  if result.stWinAnimal.ePrizeMode==4 then --0 ~= bit:_and(routeData,ccCMD.DRAW_RESULT_GUN) then
     winAnimal:setVisible(false)
     local shootnum =result.stWinAnimal.qwFlag-- bit:_and(routeData,ccCMD.SHOOT_COUNT_MASK)
     --shootnum =  bit:_rshift(shootnum,8)
     local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("tubiao34.png")
     local gun = cc.Sprite:createWithSpriteFrame(frame)
     gun:setPosition(cc.p(target:getContentSize().width/2,target:getContentSize().height/2))
     gun:setTag(3)
     target:addChild(gun);
     local shootNumTTF = cc.LabelAtlas:_create(string.format("%d",shootnum ),"game_res/shuzi3.png",20,26,string.byte("0"));
     shootNumTTF:setPosition(cc.p(target:getContentSize().width/2+20,target:getContentSize().height/2));
     shootNumTTF:setTag(4);
     target:addChild(shootNumTTF);
     return target;
  end
  --普通奖
  local t_tubiaoStr=string.format("tubiao%d.png", 29+result.stWinAnimal.stAnimalInfo.eAnimal);
  cclog("function GameScene:getResultInfo(result,target)t_tubiaoStr=%s",t_tubiaoStr);
   winAnimal:loadTexture(t_tubiaoStr,1)
   --[[
   if result.iUserScore>0 then --bit:_and(routeData,ccCMD.DRAW_RESULT_GOLD) ~= 0 then 
      local guan = cc.Sprite:create("game_res/im_guan.png")
      guan:setAnchorPoint(cc.p(0.5,-0.8));
      guan:setPosition(cc.p(target:getContentSize().width/2,target:getContentSize().height/2));
      guan:setTag(5);
      target:addChild(guan);
  end
  --]]
  return target
end
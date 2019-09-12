GameScene = class("GameScene", LayerBase)

function GameScene:ctor()
   GameScene.super.ctor(self)
   self.game_run_state=0;
   ActionClass:setParent(self)

	 self:initNnm()
	 self:CreatUI()
	 self:CreatBtn()
	 self:touche()
	 self:Updata()
	 self:enableNodeEvents(true)
	 -- self:initMsgHandler()
     --初始化返回键
  	 self:initBackKey()
     self.winSize = cc.Director:getInstance():getWinSize()
     self.labletext = cc.Label:createWithTTF("就爱上大号是功夫就哈个房间按格式发嘎嘎说法", "fullmain/res/fonts/FZY4JW.ttf", 25, cc.size(900, 0))
     self.labletext:setPosition(cc.p(self.winSize.width/2, self.winSize.height/2+200))
     self:addChild(self.labletext,100)
     self.labletext:setVisible(false)
     --
     self.bsckome = cc.Sprite:create("shuiguoshijie/res/bacckds.png")
     self.bsckome:setPosition(cc.p( self.winSize.width/2, self.winSize.height/2+200))
     self:addChild(self.bsckome,90)
     self.bsckome:setOpacity(100)
     self.bsckome:setScaleX(1280/90)
     -- self.bsckome:setScaleY(40/90)
     self.bsckome:setVisible(false)    
     self.m_game_dis_conn_flag=false;
     self.m_runInbg_flag=false;
end

-- function GameScene:onEnter( )
-- 	AudioEngine.playMusic("shuiguoshijie/res/sound/fruit_bgmuisc_001.mp3", true)
-- end

function GameScene:initBackKey( )
    self.back_release_ = true
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self, self.keyboardReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function GameScene:keyboardReleased(keycode, event)
    if keycode == 6 then --返回键
      if self.back_release_ then
        self.back_release_ = false
        local function onCancel()
          self.back_release_ = true
        end
		global.g_mainPlayer:setPlayerScore(global.g_gold + math.floor(global.g_score/self.protion))
        WarnTips.showTips({
				text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
				scale = 0.8,
				confirm = exit_shuiguoshijie,
				cancel = onCancel
			})
      end
    end
end

function GameScene:onEndEnterTransition()
	AudioEngine.playMusic("shuiguoshijie/res/sound/fruit_bgmuisc_001.mp3", true)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_YAFENRESULT, self, self.onYafenResult)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITXUYA, self, self.onFruitXuya)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITSTART, self, self.onFruitStart)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBIBEI, self, self.onFruitBibei)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBAOJI, self, self.onFruitBaoji)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITQUXIAO, self, self.onFruitCancel_res)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_UPDATESCORE, self, self.onUpdateScore)	
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GF_MESSAGE, self, self.onMessage)
    -- 后台返回前台
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self, self.onEnterForeGround)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERBACKGROUND, self, self.onEntebackGround)

     --断线处理
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self, self.onGameServerConnectLost)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserFree)
end

function GameScene:UpdateAllScore()
    cclog("GameScene:UpdateAllScore(param)");
    if(self.game_run_state==0) then 
     self.winscoretext:setString(tostring(0))
    end
end
function GameScene:onEnterForeGround(param)--返回前台 激活 刷新数据
    cclog("GameScene:onEnterForeGround(param)");
     self.m_runInbg_flag=false;
    self:UpdateAllScore();
end
function GameScene:onEntebackGround(param)--进入后台  暂停 刷新数据
    cclog("GameScene:onEntebackGround(param)");
     self.m_runInbg_flag=true;
     self:UpdateAllScore();
end

function GameScene:onRoomUserFree(playerId, tableId, chairId, status)
  if playerId==global.g_mainPlayer:getPlayerId()then
	global.g_bsendexit=false
    exit_shuiguoshijie()
  end
end

function GameScene:onGameServerConnectLost(param)
    self.m_game_dis_conn_flag=true;
end
function GameScene:onMessage(param)

  local str = param.message
  if true then --string.find(str,"水果") then
    if(self.labletext==nil) then  return; end
    if(self.bsckome==nil) then  return; end
    self.bsckome:stopAllActions();
    local function compelete()
         if(self.labletext==nil) then  return; end
         if(self.bsckome==nil) then  return; end
         self.labletext:setVisible(false)
         self.bsckome:setVisible(false)     
    end
    local t_delay=cc.DelayTime:create(5);
    local t_hide_actin=cc.CallFunc:create(compelete);
    local t_seq=cc.Sequence:create(t_delay,t_hide_actin);
    self.bsckome:runAction(t_seq);
    self.labletext:setVisible(true)
    self.bsckome:setVisible(true)
    self.labletext:setString(str)
  end
end
local map_btn_sound = 
{
	[5] = "shuiguoshijie/res/sound/fruit_music_button_0.mp3",
	[6] = "shuiguoshijie/res/sound/fruit_music_button_1.mp3",
	[7] = "shuiguoshijie/res/sound/fruit_music_button_2.mp3",
	[8] = "shuiguoshijie/res/sound/fruit_music_button_3.mp3",
	[9] = "shuiguoshijie/res/sound/fruit_music_button_4.mp3",
	[10] = "shuiguoshijie/res/sound/fruit_music_button_5.mp3",
	[11] = "shuiguoshijie/res/sound/fruit_music_button_6.mp3",
	[12] = "shuiguoshijie/res/sound/fruit_music_button_7.mp3",
}
function GameScene:onYafenResult( param )
	if param.IsBet == 1 then
		AudioEngine.playEffect(map_btn_sound[param.betId])
		if self["betIDsum" .. param.betId] == 999 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_out_of_maxscore01.mp3")
		end
        self.CurrentScore=param.userScore;
        global.g_score=self.CurrentScore
        self.scoretext:setString(tostring(global.g_score))
        --if (t->betId >= 5 && t->betId <= 12)
        if(param.betId==5) then 
           self.betIDsum5=self.betIDsum5+param.bet_num;
           self.betIDtext5:setString(tostring(self.betIDsum5));	
        elseif(param.betId==6) then 
           self.betIDsum6=self.betIDsum6+param.bet_num;
           self.betIDtext6:setString(tostring(self.betIDsum6));		
        elseif(param.betId==7) then 
           self.betIDsum7=self.betIDsum7+param.bet_num;
           self.betIDtext7:setString(tostring(self.betIDsum7));	
        elseif(param.betId==8) then 
           self.betIDsum8=self.betIDsum8+param.bet_num;
           self.betIDtext8:setString(tostring(self.betIDsum8));	
        elseif(param.betId==9) then 
           self.betIDsum9=self.betIDsum9+param.bet_num;
           self.betIDtext9:setString(tostring(self.betIDsum9));		
        elseif(param.betId==10) then 
           self.betIDsum10=self.betIDsum10+param.bet_num;
           self.betIDtext10:setString(tostring(self.betIDsum10));	
       elseif(param.betId==11) then 
           self.betIDsum11=self.betIDsum11+param.bet_num;
           self.betIDtext11:setString(tostring(self.betIDsum11));	
       elseif(param.betId==12) then 
           self.betIDsum12=self.betIDsum12+param.bet_num;
           self.betIDtext12:setString(tostring(self.betIDsum12));	    	
        end		                 
	end
end
function GameScene:onFruitCancel_res(param)
    --param.chair_id = buffObj:readInt()
    --param.score = buffObj:readInt64()
      self.CurrentScore=param.score;
      global.g_score=self.CurrentScore;
      self.scoretext:setString(tostring(global.g_score))
end
function GameScene:onFruitXuya( param )
	 for i = 1,8 do
        self.xuyatab[i] = param.yafenNum[i]
	 	print(self.xuyatab[i],"=================")
	 end
     self.betIDtext5:setString(tostring(param.yafenNum[1]))
     self.betIDtext6:setString(tostring(param.yafenNum[2]))
  	 self.betIDtext7:setString(tostring(param.yafenNum[3]))
  	 self.betIDtext8:setString(tostring(param.yafenNum[4]))
  	 self.betIDtext9:setString(tostring(param.yafenNum[5]))
   	 self.betIDtext10:setString(tostring(param.yafenNum[6]))
  	 self.betIDtext11:setString(tostring(param.yafenNum[7]))
  	 self.betIDtext12:setString(tostring(param.yafenNum[8]))
     self.CurrentScore=param.userScore;
     global.g_score=self.CurrentScore
     global.userScore=self.CurrentScore
     self.scoretext:setString(tostring(global.g_score))
------------------续押后直接开始
	if self.betIDsum5 > 0 or self.betIDsum6 > 0 or self.betIDsum7 > 0 or self.betIDsum8 > 0 or self.betIDsum9 > 0 or self.betIDsum10 > 0 or self.betIDsum11 > 0 or self.betIDsum12 > 0 then
 		self.betIDnum5 = self.betIDsum5    
		self.betIDnum6 = self.betIDsum6
		self.betIDnum7 = self.betIDsum7
		self.betIDnum8 = self.betIDsum8
		self.betIDnum9 = self.betIDsum9
		self.betIDnum10 = self.betIDsum10
		self.betIDnum11 = self.betIDsum11
		self.betIDnum12 = self.betIDsum12
		self.score = self.betIDnum5+self.betIDnum6+self.betIDnum7+self.betIDnum8+self.betIDnum9+self.betIDnum10+self.betIDnum11+self.betIDnum12	
		self.betIDsum5 = 0     --当前的
		self.betIDsum6 = 0
		self.betIDsum7 = 0
		self.betIDsum8 = 0
		self.betIDsum9 = 0
		self.betIDsum10 = 0
		self.betIDsum11 = 0
		self.betIDsum12 = 0
		global.g_score = global.g_score --- self.score
		self.scoretext:setString(tostring(global.g_score))
		print("===111============2" .. global.g_score)
		self:setbtnfalseEnabled()
		local actionro = cc.RotateBy:create(1,360)
    	self.blinklight:runAction(cc.RepeatForever:create(actionro))
		if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitStart() end
		self.score = 0
		--return
	end	 
	if self.bolmove == true then 
		self:BtnUiMove()
	end 
------------------
end
function GameScene:onFruitStart( param )
	cclog("GameScene:onFruitStart( param )");
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_begin.mp3")
  self.game_run_state=99;
	self.fruitBet = param.fruitBet           --压分
	self:StarSpeceff(param.defen[2])         --第一个跑灯
	self.dmfbnm = param.defen[2]             --第一个跑灯
	self.dicrun = param.defen[2]             --第一个跑灯
	self.defen = param.defen[1]              --类型      
    self.caijinScore = param.caijinScore          --jp彩金数额
    self.player_winScore = param.player_winScore  --玩家赢分
    self.player_gamescore =param.player_gamescore --玩家分数
    self.CurrentScore=param.player_gamescore
    -- cclog("GameScene:onFruitStart defen=%d caijinScore=%d,self.player_winScore=%d,player_gamescore=%d,defen(%d,%d,%d,%d,%d)",
    -- self.defen,self.caijinScore,self.player_winScore,self.player_gamescore,
    -- param.defen[1],param.defen[2] ,param.defen[3] ,param.defen[4] ,param.defen[5] 
    -- );       
	self.indextab = {}
	if #param.defen >= 3 then
	 	for i = 1,#param.defen do
	 		if param.defen[i+2] < 0 then
	 			break
	 		end 
	 		self.indextab[i] = param.defen[i+2]
	 	end 
 	end 
 	self.indextab1=self.indextab
 	for m = 1,#param.defen do
 		if param.defen[m] < 0 then
 			break
 		end 
 	end 
 	self.catCount = param.catCount  
 	self:StarSpeceff(param.defen[2])         --第一个跑灯
end

function GameScene:onUpdateScore(param)
	self.CurrentScore=param.score
end

function GameScene:onFruitBibei(param)	
end

function GameScene:onFruitBaoji(param)
end

function GameScene:onStartExitTransition()
	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
	if self.scheduler1 ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler1)
		self.scheduler1 = nil
	end 
	if self.scheduler2 ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler2)
		self.scheduler2 = nil
	end 
	if self.scheduler3 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler3)
		self.scheduler3 = nil
	end 
	if self.scheduler4 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler4)
		self.scheduler4 = nil
	end 
	if self.scheduler5 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler5)
		self.scheduler5 = nil
	end
	-- 后台返回前台
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERBACKGROUND, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_YAFENRESULT, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITXUYA, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITSTART, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBIBEI, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITBAOJI, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHUIGUOSHIJIE_FRUITQUXIAO, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_UPDATESCORE, self)	
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GF_MESSAGE, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
end

--初始化参数
function GameScene:initNnm()
	self.winscore = 0   --赢得分数
	self.bolrdow = true
	self.bolrup = false
	self.bolldow = true
	self.bollup = false
	self.bolrand = true
	self.hisindex = 0     --纪录上一次中奖的位置
	self.bolmove = true
	self.bolspec = false   -- 特效是否播放完成
	self.bolactor = false  -- 自动
	self.bolstar = false   -- 开始
	self.defen = 0         --判断什么类型的奖
	self.catCount = 0      --小猫变身次数
	self.indextab = {}     --纪录中奖的下标
	self.indextab1 = {}		--修复内圈中奖后self.indextab设为空了，再点开始计分时会报错
	self.indextow = {}     --下标表

	self.frenum = 0        -- 玩转的次数
	self.xuyatab = {}
	self.betIDnum5 = 0     --记录上一次的
	self.betIDnum6 = 0
	self.betIDnum7 = 0
	self.betIDnum8 = 0
	self.betIDnum9 = 0
	self.betIDnum10 = 0
	self.betIDnum11 = 0
	self.betIDnum12 = 0
	self.betIDsum5 = 0     --当前的
	self.betIDsum6 = 0
	self.betIDsum7 = 0
	self.betIDsum8 = 0
	self.betIDsum9 = 0
	self.betIDsum10 = 0
	self.betIDsum11 = 0    
	self.betIDsum12 = 0
	self.rate = 10
	self.score = 0     ---本地分数
	self.protion = global.g_mainPlayer:getCurrentRoomBeilv()    --房间倍率

    self.caijinScore = 0          --jp彩金数额
    self.player_winScore=0  --玩家赢分
    self.player_gamescore=0 --玩家分数
end

function GameScene:touche(...)
	self.touchlayer = cc.LayerColor:create(cc.c4f(0,0,0,0))
  	self:addChild(self.touchlayer,2) 
  	local function onTouchBegin( touch,event )
  		return true 
  	end
  	local function onTouchEnd( touch,event )
		-- if global.g_score < 1 then 		
		-- 	local UpScore = UpScoreNote.new(self.protion,self.scoretext)
		-- 	self:addChild(UpScore,100)

		-- end 
  	end
  	local  listener  =  cc.EventListenerTouchOneByOne:create()
  	listener:registerScriptHandler(onTouchBegin,cc.Handler.EVENT_TOUCH_BEGAN)
  	listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
  	self.touchlayer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self.touchlayer)
end

function GameScene:CreatUI()
	--self.btnroot = ccs.GUIReader:getInstance():widgetFromJsonFile("shuiguoshijie/res/json/FishUI_6.json")
	--self:addChild(self.btnroot,3)
	-- local bbck = cc.Sprite:create("shuiguoshijie/res/new/disbb.png")
	-- bbck:setPosition(cc.p(display.width/2,display.height/2))
	-- self:addChild(bbck,-1)

	-- local bbck = cc.Sprite:create("shuiguoshijie/res/new/disbb.png")
	-- bbck:setPosition(cc.p(display.width/2,display.height/2))
	-- self:addChild(bbck,-1)

	self.root = ccs.GUIReader:getInstance():widgetFromJsonFile("shuiguoshijie/res/json/FishUI_9.json")
	--self.root:setPosition(cc.p((display.width -720)/2,0))
	self:addChild(self.root,1)



	self.baser = ccui.Helper:seekWidgetByName(self.root,"baser")
	self.basel = ccui.Helper:seekWidgetByName(self.root,"basel")

	--分数
	self.scoretext = ccui.Helper:seekWidgetByName(self.root,"scoretext")
	self.centerimag = ccui.Helper:seekWidgetByName(self.root, "centerimag")
	-- local farmtab = {}                                         
	-- for i = 0,1 do
	-- 	local frameName = string.format("shuiguoshijie/res/sprite/left%d.png",i)
	-- 	local mage = cc.Director:getInstance():getTextureCache():addImage(frameName)
	-- 	local frame = cc.SpriteFrame:createWithTexture(mage,cc.rect(0,0,57,520))
	-- 	table.insert(farmtab,frame)                                                                 
	-- end
	
	--local animation = cc.Animation:createWithSpriteFrames(farmtab,1/10)  
	--local animate = cc.Animate:create(animation) 
	-- local animation = cc.Animation:create()  
	-- for i = 0,1 do
	-- 	local frameName = string.format("shuiguoshijie/res/sprite/left%d.png",i)
	--  	animation:addSpriteFrameWithFile(frameName)
	-- end    
 --    animation:setDelayPerUnit(1/10)
 --    animation:setRestoreOriginalFrame(true)
 --    local animate = cc.Animate:create(animation) 
	-- self.liftspi = cc.Sprite:create("shuiguoshijie/res/sprite/left0.png")  
	-- self:addChild(self.liftspi,1) 
	-- self.liftspi:setPosition(20,748)   
	-- self.liftspi:setScaleX(0.62)
	-- self.liftspi:setScaleY(1.24)                                                       
	-- self.liftspi:runAction(cc.RepeatForever:create(animate))  
	local Image_24 = ccui.Helper:seekWidgetByName(self.root,"Image_24")
	local point = cc.p(Image_24:getPositionX(),Image_24:getPositionY())
	self.light = cc.Sprite:create("shuiguoshijie/res/new/back/twin1.png")
	self.light:setPosition(display.width/2,point.y)
	self.root:addChild(self.light,2)
	local animation1 = cc.Animation:create()  
	for i = 1,4 do
		local frameName1 = string.format("shuiguoshijie/res/new/back/twin%d.png",i)
	 	animation1:addSpriteFrameWithFile(frameName1)
	end    
    animation1:setDelayPerUnit(1/10)
    animation1:setRestoreOriginalFrame(true)
    local animate1 = cc.Animate:create(animation1) 
    self.light:runAction(cc.RepeatForever:create(animate1))

    self.blinklight = ccui.Helper:seekWidgetByName(self.root,"blinklight")
    --self.blinklight:setPosition(361,748)
    --self.root:addChild(self.blinklight,0)
    --print(self.centerimag:getPositionX(),self.centerimag:getPositionY(),"======================")
    
 --    self.blinkd = cc.Sprite:create("shuiguoshijie/res/new/back/blink1.png")
 --    self.centerimag:addChild(self.blinkd,10)
 --    local animation = cc.Animation:create()  
	-- for i = 1,4 do
	-- 	local frameName = string.format("shuiguoshijie/res/new/back/blink%d.png",i)
	--  	animation:addSpriteFrameWithFile(frameName)
	-- end    
 --    animation:setDelayPerUnit(3/10)
 --    animation:setRestoreOriginalFrame(true)
 --    local animate = cc.Animate:create(animation) 
 --    self.blinkd:runAction(cc.RepeatForever:create(animate))

	-- local animation1 = cc.Animation:create()  
	-- for i = 0,1 do
	-- 	local frameName1 = string.format("shuiguoshijie/res/sprite/left%d.png",i)
	--  	animation1:addSpriteFrameWithFile(frameName1)
	-- end    
 --    animation1:setDelayPerUnit(1/10)
 --    animation1:setRestoreOriginalFrame(true)
 --    local animate1 = cc.Animate:create(animation1)          
	-- self.rightspi = cc.Sprite:create("shuiguoshijie/res/sprite/left0.png")  
	-- self:addChild(self.rightspi,1) 
	-- self.rightspi:setPosition(697,748)   
	-- self.rightspi:setScaleX(0.65)
	-- self.rightspi:setScaleY(1.24)                                                 
	-- self.rightspi:runAction(cc.RepeatForever:create(animate1)) 

	self.timertext = ccui.Helper:seekWidgetByName(self.root,"timertext")
	self.Image_197 = ccui.Helper:seekWidgetByName(self.root,"Image_197")
	--赢得分
	self.winscoretext = ccui.Helper:seekWidgetByName(self.root,"winscoretext")	
  	self.betIDtext5 = ccui.Helper:seekWidgetByName(self.root, "betIDtext5")
  	self.betIDtext6 = ccui.Helper:seekWidgetByName(self.root, "betIDtext6")
  	self.betIDtext7 = ccui.Helper:seekWidgetByName(self.root, "betIDtext7")
  	self.betIDtext8 = ccui.Helper:seekWidgetByName(self.root, "betIDtext8")
  	self.betIDtext9 = ccui.Helper:seekWidgetByName(self.root, "betIDtext9")
  	self.betIDtext10 = ccui.Helper:seekWidgetByName(self.root, "betIDtext10")
  	self.betIDtext11 = ccui.Helper:seekWidgetByName(self.root, "betIDtext11")
  	self.betIDtext12 = ccui.Helper:seekWidgetByName(self.root, "betIDtext12")
  	global.g_score = math.floor(global.g_gold * self.protion)
  	global.g_gold = 0
  	self.scoretext:setString(tostring(global.g_score))

  	local starfurttabgre = {}
  	for i = 0,23 do
  		local frename = "fruits_"..i..1
  		local fruit_green = ccui.Helper:seekWidgetByName(self.root,frename)
  		table.insert(starfurttabgre,i,fruit_green)
  		starfurttabgre[i]:setVisible(false)
  	end 
  	local starfurttabblu = {}
  	for j = 0,23 do
  		local bulname = "fruits_"..j..2
  		local specbul = ccui.Helper:seekWidgetByName(self.root,bulname)
  		table.insert(starfurttabblu,j,specbul)
  		starfurttabblu[j]:setVisible(false)
  	end 
  	local starfurttabred = {}
  	for m = 0,23 do
  		local grename = "fruits_"..m..3
  		local specgre = ccui.Helper:seekWidgetByName(self.root,grename)
  		table.insert(starfurttabred,m,specgre)
  		starfurttabred[m]:setVisible(false)
  	end
  	self.starfurttab = {
  		[1] = starfurttabgre,
  		[2] = starfurttabblu,
  		[3] = starfurttabred,
 	 }
  	self.speceffredtab = {}
  	for n = 0,23 do
  		local redname = "fruits_"..n..4
  		local specred = ccui.Helper:seekWidgetByName(self.root,redname)
  		table.insert(self.speceffredtab,n,specred)
  		self.speceffredtab[n]:setVisible(false)
  	end
  	self.historyTab = {}
  	self.hisnum = {}
  	for m = 1,6 do
  		local hename = "history"..m
  		local hena = ccui.Helper:seekWidgetByName(self.root,hename)
  		table.insert(self.historyTab,m,hena)
  		self.historyTab[m]:setVisible(false)
  	end 

  	self.runneitab = {}
  	for k = 1,16 do
  		local neiname = "run_nei"..k   
  		local nei = ccui.Helper:seekWidgetByName(self.root,neiname)
  		table.insert(self.runneitab,k,nei)
  		self.runneitab[k]:setVisible(false)
  	end 

  	self.neiimagtab = {}
  	for sdf = 1,18 do
  		if sdf < 17 then
  			local imagna = "nei"..sdf
  			local neim = ccui.Helper:seekWidgetByName(self.root,imagna)
  			table.insert(self.neiimagtab,neim)
		elseif sdf == 17 then
			table.insert(self.neiimagtab,self.timertext)
		elseif sdf == 18 then
			table.insert(self.neiimagtab,self.Image_197)
  		end 
	end     

	self.shblink = cc.Sprite:create("shuiguoshijie/res/new/back/shblink.png")
	local actionbl = cc.Blink:create(1,5)
	local actioncc = cc.RepeatForever:create(actionbl)
	self.shblink:runAction(actioncc)
	self.centerimag:addChild(self.shblink,20)
	self.shblink:setOpacity(0)

	self.blinkd = cc.Sprite:create("shuiguoshijie/res/new/back/blinkl1.png")
 	self.centerimag:addChild(self.blinkd,10)
    local animation = cc.Animation:create()  
	for i = 1,23 do
		local frameName = string.format("shuiguoshijie/res/new/back/blinkl%d.png",i)
	 	animation:addSpriteFrameWithFile(frameName)
	end    
    animation:setDelayPerUnit(1/15)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation) 
    self.blinkd:runAction(cc.RepeatForever:create(animate))
    self.blinkd:setOpacity(0)
end

local map_fruit_sound = 
{
	[0] = "shuiguoshijie/res/sound/fruit_orange.mp3",
	[1] = "shuiguoshijie/res/sound/fruit_bell.mp3",
	[5] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[6] = "shuiguoshijie/res/sound/fruit_lenmon.mp3",
	[7] = "shuiguoshijie/res/sound/fruit_xigua.mp3",
	[8] = "shuiguoshijie/res/sound/fruit_xigua.mp3",
	[9] = "shuiguoshijie/res/sound/fruit_goodluck.mp3",
	[10] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[11] = "shuiguoshijie/res/sound/fruit_orange.mp3",
	[12] = "shuiguoshijie/res/sound/fruit_orange.mp3",
	[13] = "shuiguoshijie/res/sound/fruit_bell.mp3",
	[14] = "shuiguoshijie/res/sound/fruit_77.mp3",
	[15] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[16] = "shuiguoshijie/res/sound/fruit_77.mp3",
	[17] = "shuiguoshijie/res/sound/fruit_lenmon.mp3",
	[18] = "shuiguoshijie/res/sound/fruit_lenmon.mp3",
	[19] = "shuiguoshijie/res/sound/fruit_star.mp3",
	[20] = "shuiguoshijie/res/sound/fruit_star.mp3",
	[21] = "shuiguoshijie/res/sound/fruit_goodluck.mp3",
	[22] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[23] = "shuiguoshijie/res/sound/fruit_bell.mp3",
}

function GameScene:StarSpeceff(index)
	local pdindex = self.hisindex
	local dt = 0
	local drc = 1
	local dcc = 1
	local mcc = 8
	local bolone = true 
	local boltwo = true 
	local bolther = true
	local bolfo = true
	local bolfiv = true
	local rand = math.random(1,3)
	local schedul = cc.Director:getInstance():getScheduler()
    --开始跑灯
	self.scheduler1 = schedul:scheduleScriptFunc(function () 
		dt = dt + 1
		if bolone == true then 
			if dt % 6 == 0 then
				if dt % 12 == 0 then
					drc = drc + 1
				end 
				self:setIndex(pdindex,drc) 
				self:starBlink(rand)
				pdindex = (pdindex+1) % 24
				if drc == 3 then
					bolone = false
					dt = 1
				end 
			end 
		end 

		if bolone == false and boltwo == true then
			if dt % 2 == 0 then 
				pdindex = (pdindex+1) % 24
				self:setIndex(pdindex,drc)
				self:starBlink(rand)
				dcc = dcc + 1 
			end 
			if dcc == 44 then
				boltwo = false
				dt = 1
				
			end 
		end 
		if boltwo == false and bolther == true then
			if dt % 6 == 0 then
				pdindex = (pdindex+1) % 24
				drc = drc - 1
				self:setIndex(pdindex,drc)
				self:starBlink(rand)
			end 
			if drc == 1 then
				bolther = false
				dt = 1	
			end 	
		end 
		if bolther == false and bolfo == true then
			if dt % 6 == 0 then
				pdindex = (pdindex+1) % 24
				self:starBlink1(pdindex,rand)
			end 

			if index == 0 then
				if pdindex == 19 then 
					bolfo = false
					dt = 1	
				end 
			elseif index == 1 then 
				if pdindex == 20 then
					bolfo = false
					dt = 1	
				end 
			elseif index == 2 then
				if pdindex == 21 then
					bolfo = false
					dt = 1	
				end 
		 	elseif index == 3 then
		 		if pdindex == 22 then
		 			bolfo = false
					dt = 1	
				end 
			elseif index == 4 then
				if pdindex == 23 then
					bolfo = false
					dt = 1	
				end 
			else
		    	if pdindex - index == -5 then
		    		bolfo = false
					dt = 1	
				end 	
			end  
		end 
		if bolfiv == true and bolfo == false then
			if dt % mcc == 0 then
				mcc = mcc + 5 
				pdindex = (pdindex + 1) % 24
				self:starBlink1(pdindex,rand)	
				dt = 1
			end 
			if pdindex == index then
				self.starfurttab[rand][index]:setVisible(false)
				if self.defen == 0 then --普通奖	
					self:PDscore(index)
					local sound = map_fruit_sound[index]
					if sound then	AudioEngine.playEffect(sound)	end
				else
					AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
					ActionClass:WinningBlink(self.speceffredtab,index)   --特殊奖 
				end
				self.hisindex = index
				self.bolstar = true
				if self.bolactor == false then 
					self.start_btn_status=true
			 		self.starbtn:setEnabled(true)
			 	end
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler1)
			end
		end 
				
	end, 0, false)
end
	
function GameScene:goodLuck(number)
	AudioEngine.playMusic("shuiguoshijie/res/sound/fruit_winner.mp3")
	local timenum = number - 3                    --number - 3
	self.bolrand = false
	local dnum = 1
	local ac = 1
	local bolone = true
	local schedul = cc.Director:getInstance():getScheduler()
	self.scheduler2 = schedul:scheduleScriptFunc(function (dt) 
		if bolone == true then
			if dnum % 8 == 0 then
				ActionClass:goodlockBlink(self.starfurttab,ac)
				ac = ac + 1
			end 
			if dnum == 360 then
				bolone = false
			end 	
		end 
		if bolone == false then               
			if dnum % 6 == 0 then
				ActionClass:goodlockBlink(self.starfurttab,ac,timenum)
				ac = ac + 1
			end 
		end 
		dnum = dnum + 1 
	end, 0, false)
end

function GameScene:CreatBtn()
	self.helpbtn = ccui.Helper:seekWidgetByName(self.root,"leftbtn")
	local function OnHelp(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			PopUpView.showPopUpView(ui_help)
		end 
	end
	self.helpbtn:addTouchEventListener(OnHelp)

	self.rightbtn = ccui.Helper:seekWidgetByName(self.root,"rightbtn")
	local function OnTouch(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.bolrdow == true then 
				self.bolrdow = false
				self:BtnUirMove()				
			end 
			if self.bolrup == true then
				self.bolrup = false
				self:BtnUirMove1()
			end 
		end 
	end
	self.rightbtn:addTouchEventListener(OnTouch)

	self.upbtnr = ccui.Helper:seekWidgetByName(self.root,"upbtnr")
	local function OnTouchup(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.bolrup == true then 
				self.bolrup = false
				self:BtnUirMove1()
			end 
		end
	end
	self.upbtnr:addTouchEventListener(OnTouchup)
	self.upbtnl = ccui.Helper:seekWidgetByName(self.root,"upbtnl")
	local function OnTouchlup(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			if self.bollup == true then 
				self.bollup = false
				self:BtnUilMove1()
			end 
		end
	end
	self.upbtnl:addTouchEventListener(OnTouchlup)

	local settbtn = ccui.Helper:seekWidgetByName(self.root,"setbtn")
	local function setTouch(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			---声音接口
			PopUpView.showPopUpView(SettingView)
		end 
	end
	settbtn:addTouchEventListener(setTouch)

	self.exitbtn = ccui.Helper:seekWidgetByName(self.root,"colsebtn")
	local function ExitTouch(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			global.g_mainPlayer:setPlayerScore(global.g_gold + math.floor(global.g_score/self.protion))
			WarnTips.showTips({
				text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
				scale = 0.8,
				confirm = exit_shuiguoshijie,
			})
		end 
	end
  	self.exitbtn:addTouchEventListener(ExitTouch)

  	self.betIDtextbtn5 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn5")
  	local function onBTNbet5(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
  			if self.schedu5 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu5 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum5 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum5 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum5 = self.betIDsum5 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum5
							self.betIDsum5 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext5:setString(tostring(self.betIDsum5))		
					end
                    --]]
                    if(self.m_game_dis_conn_flag==false)  then gamesvr.sendFruitGameScore(5,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu5 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu5)
				self.schedu5=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu5 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu5)
				self.schedu5=nil
			end
  		end
  	end
  	self.betIDtextbtn5:addTouchEventListener(onBTNbet5)
	--self.betIDtextbtn5:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn5))

  	self.betIDtextbtn6 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn6")
  	--self.betIDtextbtn6:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn6))
  	local function onBTNbet6(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
  			if self.schedu6 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu6 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum6 < 999 then
                  --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum6 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum6 = self.betIDsum6 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum6
							self.betIDsum6 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext6:setString(tostring(self.betIDsum6))						
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitGameScore(6,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu6 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu6)
				self.schedu6=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu6 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu6)
				self.schedu6=nil
			end
  		end
  	end
  	self.betIDtextbtn6:addTouchEventListener(onBTNbet6)

  	self.betIDtextbtn7 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn7")
  	--self.betIDtextbtn7:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn7))
  	local function onBTNbet7(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
  			if self.schedu7 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu7 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum7 < 999 then
                   --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum7 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum7 = self.betIDsum7 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum7
							self.betIDsum7 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext7:setString(tostring(self.betIDsum7))				
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitGameScore(7,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu7 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu7)
				self.schedu7=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu7 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu7)
				self.schedu7=nil
			end
  		end
  	end
  	self.betIDtextbtn7:addTouchEventListener(onBTNbet7)

  	self.betIDtextbtn8 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn8")
  	--self.betIDtextbtn8:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn8))
  	local function onBTNbet8(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
  			if self.schedu8 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu8 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum8 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum8 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum8 = self.betIDsum8 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum8
							self.betIDsum8 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext8:setString(tostring(self.betIDsum8))				
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitGameScore(8,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu8 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu8)
				self.schedu8=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu8 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu8)
				self.schedu8=nil
			end
  		end
  	end
  	self.betIDtextbtn8:addTouchEventListener(onBTNbet8)

  	self.betIDtextbtn9 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn9")
  	--self.betIDtextbtn9:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn9))
  	local function onBTNbet9(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
  			if self.schedu9 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu9 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum9 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum9 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum9 = self.betIDsum9 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum9
							self.betIDsum9 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
                        self.betIDtext9:setString(tostring(self.betIDsum9))					
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false)  then gamesvr.sendFruitGameScore(9,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu9 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu9)
				self.schedu9=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu9 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu9)
				self.schedu9=nil
			end
  		end
  	end
  	self.betIDtextbtn9:addTouchEventListener(onBTNbet9)

  	self.betIDtextbtn10 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn10")
  	--self.betIDtextbtn10:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn10))
  	local function onBTNbet10(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
    		if self.schedu10 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu10 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum10 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum10 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum10 = self.betIDsum10 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum10
							self.betIDsum10 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext10:setString(tostring(self.betIDsum10))			
					end
                    --]]
                    if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitGameScore(10,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu10 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu10)
				self.schedu10=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu10 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu10)
				self.schedu10=nil
			end
  		end
  	end
  	self.betIDtextbtn10:addTouchEventListener(onBTNbet10)

  	self.betIDtextbtn11 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn11")
  	--self.betIDtextbtn11:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn11))
  	local function onBTNbet11(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
    		if self.schedu11 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu11 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum11 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum11 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum11 = self.betIDsum11 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum11
							self.betIDsum11 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext11:setString(tostring(self.betIDsum11))			
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false)  then gamesvr.sendFruitGameScore(11,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu11 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu11)
				self.schedu11=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu11 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu11)
				self.schedu11=nil
			end
  		end
  	end
  	self.betIDtextbtn11:addTouchEventListener(onBTNbet11)

  	self.betIDtextbtn12 = ccui.Helper:seekWidgetByName(self.root, "betIDtextbtn12")
  	--self.betIDtextbtn12:addTouchEventListener(makeClickHandler(self, self.onbetIDtextbtn12))
  	local function onBTNbet12(sender, eventType)
  		local schedul = cc.Director:getInstance():getScheduler()
		local dt = 0
  		if eventType == ccui.TouchEventType.began then
   			if self.schedu12 then
  				return
  			end
  			if self.bolmove == true then 
				self:BtnUiMove()
			end
  			self.schedu12 = schedul:scheduleScriptFunc(function ()
  				dt = dt + 1
  				if dt % 3 == 0 and self.betIDsum12 < 999 then
                    --[[
  					if global.g_score - self.score >= self.rate then 
						if self.betIDsum12 + self.rate <= 999 then
							self.score = self.score + self.rate
							self.betIDsum12 = self.betIDsum12 + self.rate
						else
							self.score = self.score + 999 - self.betIDsum12
							self.betIDsum12 = 999
						end 
						local loscore = global.g_score - self.score
						self.scoretext:setString(tostring(loscore))
						self.betIDtext12:setString(tostring(self.betIDsum12))						
					end
                    --]]
                   if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitGameScore(12,self.rate) end
  				end
  			end, 0, false)
		elseif eventType == ccui.TouchEventType.ended then
			if self.schedu12 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu12)
				self.schedu12=nil
			end
		elseif eventType == ccui.TouchEventType.canceled then
			if self.schedu12 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedu12)
				self.schedu12=nil
			end
  		end
  	end
  	self.betIDtextbtn12:addTouchEventListener(onBTNbet12)

  	self.starbtn = ccui.Helper:seekWidgetByName(self.root, "starbtn")
  	self.starbtn:addTouchEventListener(makeClickHandler(self, self.onstarbtn))

  	self.againbtn = ccui.Helper:seekWidgetByName(self.root, "againbtn")
  	self.againbtn:addTouchEventListener(makeClickHandler(self, self.onagainbtn))

  	self.ratebtn = ccui.Helper:seekWidgetByName(self.root, "ratebtn")
  	local function Onratebtn(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_switchratio.mp3")
			if self.rate == 10 then 
				self.rate = 100
				if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitBeilv()  end     
				self.ratebtn:loadTextureNormal("shuiguoshijie/res/new/btn/hundbtn1.png")
				self.ratebtn:loadTexturePressed("shuiguoshijie/res/new/btn/hundbtn2.png")
			elseif self.rate == 100 then 
				self.rate = 1
				if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitBeilv() end
				self.ratebtn:loadTextureNormal("shuiguoshijie/res/new/btn/onebtn1.png")
				self.ratebtn:loadTexturePressed("shuiguoshijie/res/new/btn/onebtn2.png")
			elseif self.rate == 1 then 
				self.rate = 10
				if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitBeilv() end
				self.ratebtn:loadTextureNormal("shuiguoshijie/res/new/btn/tenbtn1.png")
				self.ratebtn:loadTexturePressed("shuiguoshijie/res/new/btn/tenbtn2.png")
			end 
		end 
	end
  	self.ratebtn:addTouchEventListener(Onratebtn)

  	self.refusbtn = ccui.Helper:seekWidgetByName(self.root, "refusbtn")
  	self.refusbtn:addTouchEventListener(makeClickHandler(self, self.onrefusbtn))
end

function GameScene:BtnUiMove()
	if self.bolrup == true then
		self.bolrup = false
		local actionmove = cc.MoveTo:create(0.3,cc.p(617,1486))
		local function endback()
			self.bolrdow = true
		end
		local funcall = cc.CallFunc:create(endback)
		local equ = cc.Sequence:create(actionmove,funcall)
		self.baser:runAction(equ)
	end 
	if self.bollup == true then
		self.bollup = false
		local actionmove = cc.MoveTo:create(0.3,cc.p(102,1486))
		local function endback()
			self.bolldow = true
		end
		local funcall = cc.CallFunc:create(endback)
		local equ = cc.Sequence:create(actionmove,funcall)
		self.basel:runAction(equ)
	end 
end

function GameScene:BtnUirMove()
	local actionmove = cc.MoveTo:create(0.3,cc.p(self.rightbtn:getPositionX(),986))
	local function endback()
		self.bolrup = true
		self.rightbtn:loadTextureNormal("shuiguoshijie/res/new/btn/upbtn1.png")
		self.rightbtn:loadTexturePressed("shuiguoshijie/res/new/btn/upbtn2.png")
	end
	local funcall = cc.CallFunc:create(endback)
	local equ = cc.Sequence:create(actionmove,funcall)
	self.baser:runAction(equ)
end

function GameScene:BtnUirMove1()
	local actionmove = cc.MoveTo:create(0.3,cc.p(self.rightbtn:getPositionX(),1486))
	local function endback()
		self.bolrdow = true
		self.rightbtn:loadTextureNormal("shuiguoshijie/res/new/btn/dowbtn1.png")
		self.rightbtn:loadTexturePressed("shuiguoshijie/res/new/btn/dowbtn2.png")
	end
	local funcall = cc.CallFunc:create(endback)
	local equ = cc.Sequence:create(actionmove,funcall)
	self.baser:runAction(equ)
end

function GameScene:BtnUilMove()
	local actionmove = cc.MoveTo:create(0.3,cc.p(102,986))
	local function endback()
		self.bollup = true
	end
	local funcall = cc.CallFunc:create(endback)
	local equ = cc.Sequence:create(actionmove,funcall)
	self.basel:runAction(equ)
end

function GameScene:BtnUilMove1()
	local actionmove = cc.MoveTo:create(0.3,cc.p(102,1486))
	local function endback()
		self.bolldow = true
	end
	local funcall = cc.CallFunc:create(endback)
	local equ = cc.Sequence:create(actionmove,funcall)
	self.basel:runAction(equ)
end

function GameScene:onrefusbtn(...)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_yafencancel.mp3")
   if(self.m_game_dis_conn_flag==false) then
	   gamesvr.sendFruitCancel()
	   gamesvr.sendGuaranteeScore()
    end
	self.betIDsum5 = 0     --当前的
	self.betIDsum6 = 0
	self.betIDsum7 = 0
	self.betIDsum8 = 0
	self.betIDsum9 = 0
	self.betIDsum10 = 0
	self.betIDsum11 = 0
	self.betIDsum12 = 0
	self.betIDtext5:setString(tostring(self.betIDsum5))
	self.betIDtext6:setString(tostring(self.betIDsum6))
	self.betIDtext7:setString(tostring(self.betIDsum7))
	self.betIDtext8:setString(tostring(self.betIDsum8))
	self.betIDtext9:setString(tostring(self.betIDsum9))
	self.betIDtext10:setString(tostring(self.betIDsum10))
	self.betIDtext11:setString(tostring(self.betIDsum11))
	self.betIDtext12:setString(tostring(self.betIDsum12))
	self.scoretext:setString(tostring(global.g_score))
	self.score = 0
	if self.bolmove == true then 
		self:BtnUiMove()
	end 
end

function GameScene:onagainbtn(...)
	if self.bolmove == true then 
		self:BtnUiMove()
	end 
	if self.bolactor == false then
		self.bolactor = true 
		self.againbtn:loadTextureNormal("shuiguoshijie/res/new/btn/manual1.png")
		self.againbtn:loadTexturePressed("shuiguoshijie/res/new/btn/manual2.png")
	elseif self.bolactor == true then
		self.bolactor = false 
		self.againbtn:loadTextureNormal("shuiguoshijie/res/new/btn/againbtn1.png")
		self.againbtn:loadTexturePressed("shuiguoshijie/res/new/btn/againbtn2.png")
	end 
end

function GameScene:onstarbtn(...)
     cclog(" GameScene:onstarbtn...");
     if self.start_btn_status==false then
     	return
     end
     if(self.m_runInbg_flag==true) then return end;
    if(self.m_game_dis_conn_flag==true) then return end;
	if self.bolstar == true then
		self:Closeeffects()
		self.bolstar = false
		return
	end        
  self.game_run_state=0;
  self.winscore = 0
  self.winscoretext:setString(tostring(0))

	if self.betIDsum5 == 0 and self.betIDsum6 == 0 and self.betIDsum7 == 0 and self.betIDsum8 == 0 then
		if self.betIDsum9 == 0 and self.betIDsum10 == 0 and self.betIDsum11 == 0 and self.betIDsum12 == 0 then
			self.score = self.betIDnum5+self.betIDnum6+self.betIDnum7+self.betIDnum8+self.betIDnum9+self.betIDnum10+self.betIDnum11+self.betIDnum12		
			if self.score <= global.g_score then
				if(self.m_game_dis_conn_flag==false) then gamesvr.sendGuaranteeScore() end
				self.betIDtext5:setString(tostring(self.betIDnum5))
				self.betIDtext6:setString(tostring(self.betIDnum6))
				self.betIDtext7:setString(tostring(self.betIDnum7))
				self.betIDtext8:setString(tostring(self.betIDnum8))
				self.betIDtext9:setString(tostring(self.betIDnum9))
				self.betIDtext10:setString(tostring(self.betIDnum10))
				self.betIDtext11:setString(tostring(self.betIDnum11))
				self.betIDtext12:setString(tostring(self.betIDnum12))
				self.betIDsum5 = self.betIDnum5     
				self.betIDsum6 = self.betIDnum6
				self.betIDsum7 = self.betIDnum7
				self.betIDsum8 = self.betIDnum8
				self.betIDsum9 = self.betIDnum9
				self.betIDsum10 = self.betIDnum10
				self.betIDsum11 = self.betIDnum11
				self.betIDsum12 = self.betIDnum12
				self.scoretext:setString(tostring(global.g_score-self.score))
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_xuya.mp3")
				if(self.m_game_dis_conn_flag==false) then 
					gamesvr.sendFruitXuya() 
					return
				end
			end 
		end 
	end 
	if self.betIDsum5 > 0 or self.betIDsum6 > 0 or self.betIDsum7 > 0 or self.betIDsum8 > 0 or self.betIDsum9 > 0 or self.betIDsum10 > 0 or self.betIDsum11 > 0 or self.betIDsum12 > 0 then
 		self.betIDnum5 = self.betIDsum5    
		self.betIDnum6 = self.betIDsum6
		self.betIDnum7 = self.betIDsum7
		self.betIDnum8 = self.betIDsum8
		self.betIDnum9 = self.betIDsum9
		self.betIDnum10 = self.betIDsum10
		self.betIDnum11 = self.betIDsum11
		self.betIDnum12 = self.betIDsum12
		self.score = self.betIDnum5+self.betIDnum6+self.betIDnum7+self.betIDnum8+self.betIDnum9+self.betIDnum10+self.betIDnum11+self.betIDnum12	
		self.betIDsum5 = 0     --当前的
		self.betIDsum6 = 0
		self.betIDsum7 = 0
		self.betIDsum8 = 0
		self.betIDsum9 = 0
		self.betIDsum10 = 0
		self.betIDsum11 = 0
		self.betIDsum12 = 0

		global.g_score = global.g_score --- self.score
		self.scoretext:setString(tostring(global.g_score))
		self:setbtnfalseEnabled()
		local actionro = cc.RotateBy:create(1,360)
    	self.blinklight:runAction(cc.RepeatForever:create(actionro))
		if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitStart() end
		self.score = 0
		--return
	end	 
	if self.bolmove == true then 
		self:BtnUiMove()
	end 
end
function GameScene:Updata()
	local timer = 0
	local schedul = cc.Director:getInstance():getScheduler()
	self.schedulerID = schedul:scheduleScriptFunc(function (dt)
		timer = timer + 1
		if timer == 1 then
			local  pDirector = cc.Director:getInstance()  
    		-- 暂停目标  
    		pDirector:getActionManager():pauseTarget(self.light) 
    		self.light:setTexture("shuiguoshijie/res/new/back/twin1.png")
		end 

		if self.bolrand == true then 
			if timer % 30 == 0 then
				local numrand = math.random(1000,99999)
				self.timertext:setString(tostring(numrand))
			end 
		end 

		if self.bolspec == true then

			if self.winscore > 0 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_trans.mp3")
			end
			for i = 1,18 do
				self.neiimagtab[i]:setVisible(true)
			end 		
			self.shblink:setOpacity(0) 
			self.blinkd:setOpacity(0)

			global.g_score = global.g_score + self.winscore
			if self.CurrentScore~=nil then
				global.g_score=self.CurrentScore
				print("global.g_score2="..global.g_score)
			end
			self.scoretext:setString(tostring(global.g_score))
			print("global.g_score3="..global.g_score)
      self.winscore = 0
			self.winscoretext:setString(tostring(0))

			self.bolspec = false
			self.bolrand = true
			self:Texfre()	

			self.bolstar = false
			self.indextab1 = nil
			if self.bolactor == true then	
				self:Automaticprocess()
			else
				self:setbtntrueEnabled()
				--AudioEngine.stopMusic(true)
				--AudioEngine.playMusic("main/res/music/background.mp3", true)
			end 
		end 

	end, 0, false)	
end

-- function GameScene:onExit()
-- 	cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
-- 	if self.scheduler1 ~= nil then 
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler1)
-- 	end 
-- 	if self.scheduler2 ~= nil then 
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler2)
-- 	end 
-- 	if self.scheduler3 ~= nil then
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler3)
-- 	end 
-- 	if self.scheduler4 ~= nil then
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler4)
-- 	end 
-- 	if self.scheduler5 ~= nil then
-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler5)
-- 	end
-- 	-- self:removeMsgHandler()
-- end
	
--开始后按钮不可点击	  
function GameScene:setbtnfalseEnabled()
	AudioEngine.stopMusic(true)
	self.betIDtextbtn5:setEnabled(false)
	self.betIDtextbtn6:setEnabled(false)
	self.betIDtextbtn7:setEnabled(false)
	self.betIDtextbtn8:setEnabled(false)
	self.betIDtextbtn9:setEnabled(false)
	self.betIDtextbtn10:setEnabled(false)
	self.betIDtextbtn11:setEnabled(false)
	self.betIDtextbtn12:setEnabled(false)
	self.starbtn:setEnabled(false)
  	--self.againbtn:setEnabled(false)
  	self.ratebtn:setEnabled(false)
  	self.refusbtn:setEnabled(false)
  	self.start_btn_status=false--开始按钮false为不可用，true为可用，防止开始多次点击
end

--取消按钮不可点击
function GameScene:setbtntrueEnabled()

	AudioEngine.playMusic("shuiguoshijie/res/sound/fruit_bgmuisc_001.mp3", true)

	if(self.m_game_dis_conn_flag==false) then gamesvr.sendGuaranteeScore() end
   	self.betIDtextbtn5:setEnabled(true)
	self.betIDtextbtn6:setEnabled(true)
	self.betIDtextbtn7:setEnabled(true)
	self.betIDtextbtn8:setEnabled(true)
	self.betIDtextbtn9:setEnabled(true)
	self.betIDtextbtn10:setEnabled(true)
	self.betIDtextbtn11:setEnabled(true)
	self.betIDtextbtn12:setEnabled(true)
	self.start_btn_status=true
	self.starbtn:setEnabled(true)
  	self.againbtn:setEnabled(true)
  	self.ratebtn:setEnabled(true)
  	self.refusbtn:setEnabled(true)
end   

--跑灯
function GameScene:Runninglights()
	if self.defen == 4 then
		ActionClass:king(5)
	elseif self.defen == 8 then
		ActionClass:king(2)
	elseif self.defen == 9 then
		ActionClass:king(4)
	elseif self.defen == 10 then
		ActionClass:king(3)
	elseif self.defen == 5 then
	 	ActionClass:king(6)
 	elseif self.defen == 7 then
 		ActionClass:king(7)
	elseif self.defen == 11 then
		ActionClass:king(8)
	elseif self.defen == 12 then
		ActionClass:king(9)
	end 
	local indextab = self.indextab
	local aa = -1
	local dnum = 1
	local bolmen = true 
	local index = 1
	local bolone = 0
	local num = 1
	local schedul = cc.Director:getInstance():getScheduler()
	self.scheduler3 = schedul:scheduleScriptFunc(function (dt) 
		if dnum % 5 == 0 then
			if bolmen == true and indextab[index] ~= nil then
				aa = aa + 1
				if aa == 24 then
					aa = 0
				end
				ActionClass:RunningClockwise(aa,num) 
				if aa == indextab[index] then
					bolone = bolone + 1
				end 
				if bolone == 2 then
					self.starfurttab[num][aa]:setVisible(false)
					num = math.random(1,3)
					bolmen = false
					local sound = map_fruit_sound[aa]
					if sound then
						AudioEngine.playEffect(sound)
					end
					ActionClass:Blink(aa,indextab[#indextab])
					index = index + 1
					bolone = 0
				end  
			end 
			if bolmen == false and indextab[index] ~= nil then
				ActionClass:RunningAnticlockwise(aa,num)
				if aa == indextab[index] then
					bolone = bolone + 1
				end 
				if bolone == 2 then
					self.starfurttab[num][aa]:setVisible(false)
					num = math.random(1,3)
					local sound = map_fruit_sound[aa]
					if sound then
						AudioEngine.playEffect(sound)
					end
					ActionClass:Blink(aa,indextab[#indextab])
					bolmen = true
					index = index + 1
					bolone = 0
				end
				aa = aa - 1
				if aa == -1 then
					aa = 23
				end  	
			end 
		end
		if indextab[index] == nil then
			self.indextab = nil 
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler3)
		end 
		dnum = dnum + 1
	end, 0, false)
end

function GameScene:Texfre()
	self.betIDtext5:setString(tostring(0))
	self.betIDtext6:setString(tostring(0))
	self.betIDtext7:setString(tostring(0))
	self.betIDtext8:setString(tostring(0))
	self.betIDtext9:setString(tostring(0))
	self.betIDtext10:setString(tostring(0))
	self.betIDtext11:setString(tostring(0))
	self.betIDtext12:setString(tostring(0))
end

--跑内圈
function GameScene:RunNei()
	local bolone = false
	local runtime = 1
	local index = math.random(1,16)
	local acc = index
	local schedul = cc.Director:getInstance():getScheduler()
	self.scheduler4 = schedul:scheduleScriptFunc(function (dt)
		if runtime % 5 == 0 and bolone == false then
			ActionClass:RunNei(index)
			if index - acc == 16 then
				bolone = true
			end    
			index = index + 1
		end 
		if runtime % 8 == 0 and bolone == true then
			ActionClass:RunNei(index)
			local andm = (index % 16 + 1)
			if index - acc > 32 and andm == self.indextab[1] + 1 then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler4)	
				self.runneitab[andm]:setVisible(false)
				self.indextab = nil
				ActionClass:NeiBlink(andm)
				if andm == 1 then
					self.runneitab[16]:setVisible(false)
				else
					self.runneitab[andm-1]:setVisible(false)
				end 
			end 
			index = index + 1
		end 
		runtime = runtime + 1
	end, 0, false)	
end


function GameScene:Automaticprocess()
	if(self.m_game_dis_conn_flag==false) then gamesvr.sendGuaranteeScore() end
  self.game_run_state=0;
  self.winscore = 0
  self.winscoretext:setString(tostring(0))
	self.score = self.betIDnum5+self.betIDnum6+self.betIDnum7+self.betIDnum8+self.betIDnum9+self.betIDnum10+self.betIDnum11+self.betIDnum12
	if self.score <= global.g_score then
		self.betIDtext5:setString(tostring(self.betIDnum5))
		self.betIDtext6:setString(tostring(self.betIDnum6))
		self.betIDtext7:setString(tostring(self.betIDnum7))
		self.betIDtext8:setString(tostring(self.betIDnum8))
		self.betIDtext9:setString(tostring(self.betIDnum9))
		self.betIDtext10:setString(tostring(self.betIDnum10))
		self.betIDtext11:setString(tostring(self.betIDnum11))
		self.betIDtext12:setString(tostring(self.betIDnum12))
		self.betIDsum5 = self.betIDnum5     
		self.betIDsum6 = self.betIDnum6
		self.betIDsum7 = self.betIDnum7
		self.betIDsum8 = self.betIDnum8
		self.betIDsum9 = self.betIDnum9
		self.betIDsum10 = self.betIDnum10
		self.betIDsum11 = self.betIDnum11
		self.betIDsum12 = self.betIDnum12
		self.scoretext:setString(tostring(global.g_score-self.score))
		AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_xuya.mp3")
		if(self.m_game_dis_conn_flag==false) then gamesvr.sendFruitXuya()	end		
	end 

	if self.betIDsum5 > 0 or self.betIDsum6 > 0 or self.betIDsum7 > 0 or self.betIDsum8 > 0 or self.betIDsum9 > 0 or self.betIDsum10 > 0 or self.betIDsum11 > 0 or self.betIDsum12 > 0 then
		self.betIDnum5 = self.betIDsum5    
		self.betIDnum6 = self.betIDsum6
		self.betIDnum7 = self.betIDsum7
		self.betIDnum8 = self.betIDsum8
		self.betIDnum9 = self.betIDsum9
		self.betIDnum10 = self.betIDsum10
		self.betIDnum11 = self.betIDsum11
		self.betIDnum12 = self.betIDsum12
		self.betIDsum5 = 0     --当前的
		self.betIDsum6 = 0
		self.betIDsum7 = 0
		self.betIDsum8 = 0
		self.betIDsum9 = 0
		self.betIDsum10 = 0
		self.betIDsum11 = 0
		self.betIDsum12 = 0		
		global.g_score = global.g_score - self.score
		self.scoretext:setString(tostring(global.g_score))
		local actionro = cc.RotateBy:create(1,360)
		self.blinklight:runAction(cc.RepeatForever:create(actionro))
		if(self.m_game_dis_conn_flag==false) then  gamesvr.sendFruitStart() end
	end 
	self.score = 0
	if self.bolmove == true then 
		self:BtnUiMove()
	end 
end


function GameScene:Closeeffects()
	--AudioEngine.stopMusic(true)
	--AudioEngine.playMusic("main/res/music/background.mp3", true)
	self.speceffredtab[self.dmfbnm]:stopAllActions()
	for m = 1,18 do
		self.neiimagtab[m]:setVisible(true)
	end
	self.blinkd:setOpacity(0)	
	if self.centerimag:getChildByName("100") then
		self.centerimag:getChildByName("100"):removeFromParent()
	end 
	if self.centerimag:getChildByName("200") then
		self.centerimag:getChildByName("200"):removeFromParent()
	end
	if self.centerimag:getChildByName("300") then
		self.centerimag:getChildByName("300"):removeFromParent()
	end
	if self.centerimag:getChildByName("400") then
		self.centerimag:getChildByName("400"):removeFromParent()
	end
    if self.centerimag:getChildByTag(11999) then
       self.centerimag:removeChildByTag(11999);
	end
	if self.scheduler1 ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler1)
	end 
	if self.scheduler2 ~= nil then 
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler2)
	end 
	if self.scheduler3 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler3)
	end 
	if self.scheduler4 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler4)
	end 
	if self.scheduler5 ~= nil then
		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler5)
	end 
	self:Texfre()
	self.winscore = 0 
	if self.defen == 0 then 
		ActionClass:Calculfra(self.dmfbnm)
	elseif self.defen == 13 then 
		ActionClass:CaCatScore()
	elseif self.defen == 6 then
		ActionClass:CaNeiScore(self.indextab1[1]+1)
	else
		ActionClass:Calculfra(self.dmfbnm)
		for j = 1,#self.indextab do
			ActionClass:Calculfra(self.indextab[j])	 
		end
	end 
	if self.winscore > 0 then
		AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_trans.mp3")
	end
	global.g_score = global.g_score + self.winscore
	print("global.g_score4="..global.g_score)
	if self.CurrentScore~=nil then
		global.g_score = self.CurrentScore
		print("global.g_score5="..global.g_score)
	end
	self.scoretext:setString(tostring(global.g_score))
	print("global.g_score6="..global.g_score)
	self.winscoretext:setString(tostring(0))
	self.winscore = 0
	self.bolspec = false
	self.bolrand = true
	for m = 1,3 do
		for n = 0,23 do 
			self.starfurttab[m][n]:setVisible(false)
		end 
	end
	for k = 0,23 do
		self.speceffredtab[k]:setVisible(false)
	end 
	for i=1,16 do
		self.runneitab[i]:setVisible(false)
	end
	local pDirector = cc.Director:getInstance()
	pDirector:getActionManager():pauseTarget(self.light)
	self.light:setTexture("shuiguoshijie/res/new/back/twin1.png")

	self.blinklight:stopAllActions()
	self:setbtntrueEnabled()
end

function GameScene:Shiftpoints()
end

function GameScene:setIndex(index,n)
	self.indextow = {}
	for i = 0,n-1 do
		if index-i < 0 then
			table.insert(self.indextow,index-i+24)
		else
			table.insert(self.indextow,index-i)  
		end  
	end 
end

function GameScene:starBlink(n)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.wav")
	if #self.indextow > 0 then
		for j = 0,23 do
			self.starfurttab[n][j]:setVisible(false)
		end
		for i = 1,#self.indextow do
			self.starfurttab[n][self.indextow[i]]:setVisible(true)
		end 
	end 
end

function GameScene:starBlink1(index,n)
    if(index~=nil and n~=nil)  then 
       	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.wav")
     	for i = 0,23 do
		   self.starfurttab[n][i]:setVisible(false)
    	end
	    self.starfurttab[n][index]:setVisible(true)
    end
end


function GameScene:Runtrain()
	ActionClass:king(5)
	local pdindex = self.dicrun + 1
	local dt = 0
	local acm = 1
	local addc = 1
	local num = #self.indextab
	table.sort(self.indextab)
	local index = self.indextab[1]
	local rand = math.random(1,3)
	local bolone = true
	local boltow = true
	local bolthr = true
	local bolfo = true
	local bolfiv = true
	local mcc = 7
	local acmd = 0
	local schedul = cc.Director:getInstance():getScheduler()
	self.scheduler5 = schedul:scheduleScriptFunc(function ()
		dt = dt + 1
		if bolone == true then 
			if dt % 20 == 0 then
				self:setIndex(pdindex,acm)
				self:starBlink(rand)
				pdindex = (pdindex + 1) % 24
				if acm == num then
					dt = 1
					bolone = false
					acm = acm - 1
				end 
				acm = acm + 1			
			end 			
		end 

		if bolone == false and boltow == true then
			if dt % 3 == 0 then
				pdindex = (pdindex + 1) % 24
				self:setIndex(pdindex,acm)
				self:starBlink(rand)
				addc = addc + 1
			end 
			if addc == 40 then
				dt = 1
				boltow = false
			end 
		end 

		if boltow == false and bolthr == true then
			if dt % 6 == 0 then
				pdindex = (pdindex + 1) % 24
				self:setIndex(pdindex,acm)
				self:starBlink(rand)
			end 
			if index == 0 then
				if pdindex == 19 then 
					bolthr = false
					dt = 1	
				end 
			elseif index == 1 then 
				if pdindex == 20 then
					bolthr = false
					dt = 1	
				end 
			elseif index == 2 then
				if pdindex == 21 then
					bolthr = false
					dt = 1	
				end 
		 	elseif index == 3 then
		 		if pdindex == 22 then
		 			bolthr = false
					dt = 1	
				end 
			elseif index == 4 then
				if pdindex == 23 then
					bolthr = false
					dt = 1	
				end 
			else
		    	if pdindex - index == -5 then
		    		bolthr = false
					dt = 1	
				end 	
			end
		end 

		if bolthr == false and bolfo == true then
			if dt % mcc == 0 then
				mcc = mcc + 5
				pdindex = (pdindex + 1) % 24
				self:setIndex(pdindex,acm)
				self:starBlink(rand)
				dt = 1
			end
			if  pdindex == index - 1 then
				dt = 1
				bolfo = false
			end  
		end

		if bolfo == false and bolfiv == true then
			if dt % 16 == 0 then
				self:coleId(rand,self.indextab[acmd + 1],num)
				acmd = acmd + 1
				local sound = map_fruit_sound[self.indextab[acmd]]
				if sound then
					AudioEngine.playEffect(sound)
				end
				ActionClass:Blink(self.indextab[acmd],self.indextab[num])
			end	
			if acmd == num then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler5)
			end 
		end

	end, 0, false)	
end

function GameScene:coleId(n,index,sum)
	self.starfurttab[n][index - sum]:setVisible(false)
end

function GameScene:Ptspecc(index)
	ActionClass:HistorySpr(index)
	self.blinklight:stopAllActions()
	self.speceffredtab[index]:setVisible(true)
	--self.speceffredtab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_blue.png")
	local action1 = cc.DelayTime:create(0.05)
	local function enkback1()   
		self.speceffredtab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_blue.png")
	end
	local funcall1 = cc.CallFunc:create(enkback1)
	local action2 = cc.DelayTime:create(0.05)
	local function enkback2()
		self.speceffredtab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_green.png")
	end
	local funcall2 = cc.CallFunc:create(enkback2)
	local action3 = cc.DelayTime:create(0.05)
	local function enkback3()
		self.speceffredtab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_red.png")
	end
	local funcall3 = cc.CallFunc:create(enkback3)
    local seq1 = cc.Sequence:create(action1,funcall1,action2,funcall2,action3,funcall3)
    local repeatAction = cc.Repeat:create(seq1,10)
    local function edcab()
    	self.bolspec = true
    	self.speceffredtab[index]:setVisible(false)
    end
    local funca = cc.CallFunc:create(edcab)
 	local seq2 = cc.Sequence:create(repeatAction,funca)
 	self.speceffredtab[index]:runAction(seq2)
end

function GameScene:PDscore(index)
	if index ==  0 or index == 11 or index == 12 then 
		if self.fruitBet[7] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end 
	elseif index == 1 or index == 13 or index == 23 then
		if self.fruitBet[5] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 2 or index == 4 then
		if self.fruitBet[1] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 3 then
		self:Ptspecc(index)
	elseif index == 5 or index == 10 or index == 15 or index == 22 then
		if self.fruitBet[8] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 6 or index == 17 or index == 18 then
		if self.fruitBet[6] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 7 or index == 8 then
		if self.fruitBet[4] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 9 or index == 21 then
		self:Ptspecc(index)
	elseif index == 14 or index == 16 then
		if self.fruitBet[2] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	elseif index == 19 or index == 20 then
		if self.fruitBet[3] > 0 then
			AudioEngine.playEffect("shuiguoshijie/res/sound/openaward2.wav")
			ActionClass:WinningBlink(self.speceffredtab,index)
		else
			self:Ptspecc(index)
		end
	end
end
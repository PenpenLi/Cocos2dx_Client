--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/7
--此文件由[BabeLua]插件自动生成
GameScene = class("GameScene", LayerBase)

--region
function GameScene:LoadGame() --实现资源载入

	local t_game_start=game_start_haiwang.new();
	self:addChild(t_game_start);

    -- self.labletext_debug = cc.Label:createWithTTF("adadad", "haiwang/res/FZY4JW.ttf", 25)
   -- self.labletext_debug = cc.Label:createWithTTF("", "main/res/fonts/FZY4JW.ttf", 25)
   --  self:addChild(self.labletext_debug,10000);
   -- self. labletext_debug:setPosition(cc.p(400,300));
 --   self.men_count_timer=0;
   --  cc.exports.debug_text=self.labletext_debug;
    --  cc.exports.debug_text:setString("");
      --]]
end
function  GameScene:StartGame() --启动游戏
 self.g_scene_fish_trace=scene_fish_trace.new();
 self:addChild(self.g_scene_fish_trace);

 --self.g_scene_fish_trace:BuildSceneKind2Trace();
 --self.g_scene_fish_trace:BuildSceneKind5Trace();

  local ccwinsize=cc.Director:getInstance():getWinSize();
  self.bsckome = cc.Sprite:create("haiwang/res/HW/bacckds.png")
  self.bsckome:setPosition(cc.p(ccwinsize.width/2,ccwinsize.height/2))
  self:addChild(self.bsckome,90)
  self.bsckome:setOpacity(100)
  self.bsckome:setScaleX(1280/90)
  -- self.bsckome:setScaleY(34/90)
  self.bsckome:setVisible(false)

  self.labletext = cc.Label:createWithTTF("", "fullmain/res/fonts/FZY4JW.ttf", 25, cc.size(900, 0))
  if(self.labletext) then
    self.labletext:setPosition(cc.p(ccwinsize.width/2,ccwinsize.height/2))
    self:addChild(self.labletext,100)
    self.labletext:setVisible(false)
  end
  --self.g_scene_fish_trace:BuildSceneKind5Trace();--分开避免断线
   cc.exports.fishlayer = cc.Layer:create()
  self:addChild(cc.exports.fishlayer,1)
--背景
self.m_pGameBack=CGameBack.new();
self:addChild(self.m_pGameBack,-1);
--鱼管理节点
self.g_fish_manager=gamefishmanager.new();
self:addChild(self.g_fish_manager,3);
--红包管理
self.m_red_envelope_Manager=red_envelope_Manager.new();
self:addChild(self.m_red_envelope_Manager,99999);
--锁定管理节点
self.g_lock_fish_manager=lock_fish_manager.new();
self.lock_fish_manager_=self.g_lock_fish_manager;
self:addChild(self.g_lock_fish_manager,GAME_UIORDER_-1);
--炮塔管理节点
self.cannon_manager_=cannonmanager.new();
self:addChild(self.cannon_manager_,GAME_UIORDER_);
--子弹
self.g_Broach_Bullet_Manager=Broach_Bullet_Manager.new();
self:addChild(self.g_Broach_Bullet_Manager,GAME_UIORDER_-5);
self.g_bulletmanager=bulletmanager.new();
self:addChild(self.g_bulletmanager,GAME_UIORDER_-5);
self.g_Dianci_Bullet_Manager=Dianci_Bullet_Manager.new();
self:addChild(self.g_Dianci_Bullet_Manager,GAME_UIORDER_-5);
self.g_Free_Bullet_Manager=Free_Bullet_Manager.new();
self:addChild(self.g_Free_Bullet_Manager,GAME_UIORDER_-5);
self.g_GuidedMissile_Bullet_Manager=GuidedMissile_Bullet_Manager.new();
self:addChild(self.g_GuidedMissile_Bullet_Manager,GAME_UIORDER_-5);
-- 奖励
self.g_BingoManager=BingoManager.new();
self:addChild(self.g_BingoManager,GAME_UIORDER_-1);
--金币
self.g_CoinManager=CoinManager.new();
self:addChild(self.g_CoinManager,1);
--粒子
self.g_My_Particle_manager=My_Particle_manager.new();
self:addChild(self.g_My_Particle_manager,GAME_UIORDER_-1);
--载入游戏按键
self:Load_TouchUI();
--添加波浪
self:AddWavNode();
 self:touchFunc_(); --初始化触摸层
 self:enableNodeEvents(true)
 -- self:initMsgHandler();
 --全局的特效层 在class.Action中使用
   cc.exports.lablayer = cc.Layer:create()
  self:addChild(lablayer,3)

 --self:registerScriptHandler(onNodeEvent)
   --初始化返回键
  self:initBackKey()
  self:initKeyPressed()
  self:getMeChairID();

  local contactListener = cc.EventListenerPhysicsContact:create()
  contactListener:registerScriptHandler(handler(self, self.onContactBegin) , cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
  local eventDispatcher = self:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
  --   cc.Director:getInstance():getRunningScene():getPhysicsWorld():setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)
  --
   local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
   --self:unscheduleUpdate()
   self.bullet_speed_={};

  self.bullet_speed_[0] =800;
  self.bullet_speed_[1] =800;
  self.bullet_speed_[2] =800;
  self.bullet_speed_[3] =800
  self.bullet_speed_[4] =1000;
  self.bullet_speed_[5] =1000;
  self.bullet_speed_[6] = 1000;
  self.bullet_speed_[7] = 1000;
  self.m_MRY_Fire_timer=0;
  self.m_Free_Fire_timer=0;
   ----创建4个边沿碰撞盒
--   local  t_edge_Node=cc.Node:create();


   --第一个参数是Size类型  第二个参数是一个PhysicsMaterial类型的 参数密度，弹性系数和摩擦系数  第三个参数是边框的宽度
   --[[
   local body = cc.PhysicsBody:createEdgeBox(ccwinsize,cc.PhysicsMaterial(0, 1,0),1);
	body:setGroup(-2)
	body:setDynamic(false)
	--body:setGravityEnable(false)
	--body:setContactTestBitmask(1);
	t_edge_Node:setPhysicsBody(body);
    t_edge_Node:setPosition(cc.p(ccwinsize.width/2, ccwinsize.height/2));
    --t_edge_Node:setName("Edge");
  -- t_edge_Node:setTag(99999);
    self:addChild(t_edge_Node,0,99999);
    --]]
    --self.m_init_mem_count=collectgarbage("count");

 --定时回收垃圾

     local function coolect_call_back_()
            cclog("GameScene:EndSceneTra......coolect_call_back_...");
           collectgarbage("collect");
     end
     local t_delay=cc.DelayTime:create(120);
     local t_call_back_=cc.CallFunc:create(coolect_call_back_);
     local t_seq_=cc.Sequence:create(t_delay,t_call_back_,nil);
     local  t_rep=cc.RepeatForever:create(t_seq_);
     self:runAction(t_seq_);

     gamesvr.sendUserReady();
     gamesvr.sendLoadFinish();

     -- cc.Director:getInstance():getTextureCache():dumpCachedTextureInfo()
end

--初始化
function  GameScene:Init()
cc.exports.game_manager_=self;
self.g_Key_Lock_Flag=0;
self.run_in_back_flag=0;
self.m_show_rate_flag=0;
self.g_back_Fore_Delay =0;
self.current_bullet_kind_=0;
self.m_change_sceneLogoFlag=0;
self.m_switchScene_buf={};
self.g_fish_score_rate=1;--
 self.g_me_chair_id=0;
self. g_coin_score_rate=1;--
self.exchange_count_=1000000;--
self.min_bullet_multiple_=1;--
self.max_bullet_multiple_=9900;--
self.m_nFirst_bullet_multiple_=100;--
self.current_bullet_mulriple_=100;--
self.current_bullet_id_=0;--
self.current_bullet_self_count=0;--
self.bomb_range_width_=1000;--
self.bomb_range_height_=700;--
self.m_PlayerFireSpeed=200;--
self.m_IsSwitchingScene=0;--
self.calc_trace_thread_=nil;--
self.calc_trace_event_=nil;--
self.g_hongbao_ttf=nil;
self.m_sound_ui_main_root=nil;--
self.g_switch_Scene=0;--
self.g_switch_SceneTime=0;--
self.exit_game_=false;--
self.allow_fire_=false;--
self.game_active_=1;--
self.lock_=0;--
self.g_start_waitting_timer=0;--
self.m_if_Auto_Fire=0;--
self.g_LockShootstate=0;--
self.g_Key_Lock_Flag=0;--
self.g_exit_flag=false;
self.sound_flag=false;
self.g_bulletmanager=nil;--
self.lock_fish_manager_=nil;--
self.cannon_manager_=nil;--
self.g_ShowRateFlag=0;--       //显示倍率
self.g_init_ok_flag=0;--
self.g_rateShowTimer=8;--
self.m_ion_lock=0;--
self.m_fire_timer=0;
self.m_game_touch_flag=0;--
self.m_touch_begin_flag=0;--
self.m_fire_timer=0;--
self.g_rate_show_spr=nil;--
self.m_ui_main_root=nil;--
self.m_speed_bt_state=0;--    //极速按键状态
self.m_auto_bt_state=0;--      //自动按键状态
self.m_lock_bt_state=0;--       //锁定按键状态
self.m_dle_timer=0;--
self.m_wav_Node=nil;--
self.m_dle_exit_spr_bg =nil;--
self.m_LeftNum_timer= nil;--
self.m_mark_light_spr=nil;--
self.m_mark_light_spr_show=nil;--
self.m_scene_Mark_Flag=0;--
self.m_back_volume_=100;--
self.m_Effect_volume_=100;--
self.m_soundsetting_node=nil;--
self.g_fish_score_={[0]=0,0,0,0,0,0,0,0,0,0,0,0};       --玩家鱼币
self.g_coin_score_={[0]=0,0,0,0,0,0,0,0,0,0,0,0};  --玩家金币
self.g_jieji_player_flag={[0]=0,0};  --街机标记
self.m_game_touch_pos=cc.p(0,0);
self.m_game_touch_flag =0;
self.m_touch_begin_flag =0;
self.auto_lock_timer=0;
self.m_switchScene_buf={};
--回收无用内存
 collectgarbage("collect");
 collectgarbage("collect");
--self.m_init_mem_count=collectgarbage("count");
--]]
end
function GameScene:ctor()
  GameScene.super.ctor(self)

print("GameScene:ctor.....\n");
local winSize = cc.Director:getInstance():getWinSize();
cc.exports.GAME_UIORDER_=20;
self:Init();
 local t_sound_Node=soundManager.new();
 self:addChild(t_sound_Node);
self:LoadGame();
end
--发射更新
 function GameScene:Input_KeyUpdate(dt)

   self.m_MRY_Fire_timer=self.m_MRY_Fire_timer+dt;
   self.m_Free_Fire_timer=  self.m_Free_Fire_timer+dt;
  if( self.g_back_Fore_Delay>0) then
      self.g_back_Fore_Delay= self.g_back_Fore_Delay-dt;
   end
  self.m_fire_timer= self.m_fire_timer+dt;
  if (self.m_game_touch_flag>0 or self.m_auto_bt_state>0) then
      if(self.g_ShowRateFlag==0 and self.keyFirePressed == false ) then
        self:TouchShoot(self.m_game_touch_pos,self.isKeyShoot);
      end
  end
  if(self.m_lock_bt_state>0)    then
     self.auto_lock_timer=self.auto_lock_timer+dt;
     if(self.auto_lock_timer>0.5) then --每0.5秒检测一次锁定
            self.auto_lock_timer=0;
            local t_mechair_id = self:getMeChairID();
            local t_locak_fish_id=self.lock_fish_manager_:GetLockFishID(t_mechair_id);--检测锁定状态
            if (t_locak_fish_id <1) then
              -- cclog("GameScene:Input_KeyUpdate(dt) t_locak_fish_id=%d",t_locak_fish_id);
               self:Lock_fish(t_mechair_id);
            else
                local fish=self.g_fish_manager:GetFish(t_locak_fish_id);
                if(fish==nil) then self:Lock_fish(t_mechair_id);
                elseif(fish:CheckValidForLock()==false)  then self:Lock_fish(t_mechair_id);
                end
             end
      end
  end

 end
 function  GameScene:BOSSTSLOGO( bosskind)--//BOSS出现提示
  -- cclog();
    if (self.m_change_sceneLogoFlag == 0)then
       self.m_change_sceneLogoFlag = 1;

		if (self.m_pGameBack) then self.m_pGameBack:ChangeSceneB(); end
        local t_logo_Sprite = nil;
        --cclog("GameScene:BOSSTSLOGO02");
		if (bosskind == 0) then --//深海之王
			t_logo_Sprite = cc.Sprite:create("haiwang/res/HW/bossLogo/~DengLongSceneLogo_000_000.png");
		elseif (bosskind == 1) then --//远古巨鳄
			t_logo_Sprite = cc.Sprite:create("haiwang/res/HW/bossLogo/~EYuSceneLogo_000_000.png");
		elseif (bosskind == 2) then --//帝王蟹
			t_logo_Sprite = cc.Sprite:create("haiwang/res/HW/bossLogo/~SuperCrabSceneLogo_000_000.png");
		end
        if (t_logo_Sprite) then
			local  t_winSize = cc.Director:getInstance():getWinSize();
			t_logo_Sprite:setPosition(cc.p(t_winSize.width + 1200, t_winSize.height / 2));
			--////右到左进屏幕  中间摇摆  出屏
			local moveTo1 = cc.MoveTo:create(1, cc.p(t_winSize.width / 2, t_winSize.height / 2)); --//进入屏幕
			--//摇摆 放大
            local function call_back_()
                  t_logo_Sprite.removeFromParent();
            end
			local rotateto = cc.RotateBy:create(0.4, 20);
			local scaleto = cc.ScaleTo:create(0.4, 1.5);
			local scaletoR = cc.ScaleTo:create(0.4, 1.0);
			local rotatetoR = cc.RotateBy:create(0.4, -20);
			local rotatetoBack = cc.RotateTo:create(0.4, 0);
			local spawn = cc.Spawn:create(rotateto, scaleto);
			local spawn1 = cc.Spawn:create(rotatetoR, scaletoR);
			local spawn2 = cc.Spawn:create(rotatetoR, scaleto);
			local spawn3 = cc.Spawn:create(rotateto, scaletoR);
			local delaytime = cc.DelayTime:create(0.08);
			local seq = cc.Sequence:create(spawn, spawn1, spawn2, spawn3, nil);
			local t_repeat = cc.Repeat:create(seq, 3);--//重复几次
			local moveTo2 = cc.MoveTo:create(0.3, cc.p(t_winSize.width / 2 + 100, t_winSize.height / 2)); --//假右摆
			local moveTo3 = cc.MoveTo:create(1, cc.p(-1200, t_winSize.height / 2));  --//出屏
			local funcall = cc.CallFunc:create(call_back_);--//自移除
			local seq1 = cc.Sequence:create(moveTo1, t_repeat, rotatetoBack, moveTo2, moveTo3, nil);--//动作汇总
			t_logo_Sprite:runAction(seq1);
			self:addChild(t_logo_Sprite, GAME_UIORDER_-1);
		end-- if (t_logo_Sprite) then
    end -- if (self.m_change_sceneLogoFlag == 0)then
 end
 function GameScene:CalcAngle( x1,  y1,  x2,  y2)

	local disx = x1 - x2;
	local disy = y1 - y2;
     --cclog("x1=%f,  y1=%f,  x2=%f,  y2=%f ,disx=%f,disy=%f",x1,  y1,  x2,  y2,disx,disy);
	if (disy >= -0.0000001 and disy <= 0.0000001)then
		if (disx < 0) then 	return M_PI+M_PI_2;
		else   return M_PI_2; end
	end
	if (disx >= -0.000001 and disx <= 0.000001)then
		if (disy >= 0) then 	return 0;
		else 		return M_PI; end
	end

	return math.atan2(disx,disy);
end
function GameScene:CanFire(me_chair_id, mouse_pos)
 return true;
end

function GameScene:StartMark_Scene()--//开始遮罩场景
   if (self.m_scene_Mark_Flag == 0) then
      self.m_scene_Mark_Flag = 1;
      local t_Mak_Node = cc.Node:create();
      if (t_Mak_Node) then
         	local  visibleSize = cc.Director:getInstance():getWinSize();--::sharedDirector()->getVisibleSize();
			local  t_center_pos = cc.p(visibleSize.width / 2, visibleSize.height / 2);
		   self:addChild(t_Mak_Node, cc.exports.GAME_UIORDER_-3,77581268);
			local clip =cc.ClippingNode:create();--   CCClippingNode::create();
			self.m_mark_light_spr = cc.Sprite:create("haiwang/res/HW/mark_.png");
			self.m_mark_light_spr_show = cc.Sprite:create("haiwang/res/HW/light.png");
			local stencil =  cc.Sprite:create("haiwang/res/HW/mark_.png");
			clip:setStencil(self.m_mark_light_spr);
			clip:setInverted(true);
			clip:setAlphaThreshold(0);
			clip:addChild(stencil);
			t_Mak_Node:addChild(clip, 1111);--//添加裁剪节点
			t_Mak_Node:addChild(self.m_mark_light_spr_show);--//添加裁剪节点
			self.m_mark_light_spr:setPosition(cc.p(-1000,-1000));
			self.m_mark_light_spr_show:setPosition(cc.p(-1000, -1000));
			self.m_mark_light_spr_show:setScale(6);
			self.m_mark_light_spr:setScale(12);
			stencil:setScaleX(visibleSize.width / 256.0);
			stencil:setScaleY(visibleSize.height / 256.0);
			stencil:setPosition(t_center_pos);
      end
   end
end
function  GameScene:Mark_SceneUpdate() --//更新
     if(self.m_scene_Mark_Flag) then
		if (cc.exports.g_pFishGroup) then
			local  t_light_Pos = cc.exports.g_pFishGroup:GetDenglonglight_Pos();
			if (self.m_mark_light_spr_show) then self.m_mark_light_spr_show:setPosition(t_light_Pos);end
			if (self.m_mark_light_spr) then self.m_mark_light_spr:setPosition(t_light_Pos); end
		end
	end
end

function GameScene:EndMark_Scene()--//结束遮罩场景
	if (self.m_scene_Mark_Flag) then
		local t_Mak_Node =self:getChildByTag(77581268);
        if(t_Mak_Node) then 	t_Mak_Node:removeAllChildren(); end
		self.m_mark_light_spr = nil;
		self.m_mark_light_spr_show = nil;
		 self:removeChildByTag(77581268);
	end
	self.m_scene_Mark_Flag = 0;
end


 function GameScene:TouchShoot(touch_pos,isKey)

      if(self.run_in_back_flag>0)then return ; end
      if(self.g_back_Fore_Delay>0) then return; end;
      local tpt=touch_pos;

      local t_Fire_Speed =self.m_PlayerFireSpeed /1000.0;
	  if (self.m_speed_bt_state>0) then t_Fire_Speed = t_Fire_Speed*0.7;end
      if (self.m_fire_timer>t_Fire_Speed) then
			local tpt =cc.Director:getInstance():convertToGL(tpt) ;--     CCDirector::sharedDirector()->convertToGL(tpt);
			local  me_chair_id = self:getMeChairID();
			if (self.allow_fire_==true) then
            -- 锁定相关处理
--region
          --  cclog("GameScene:TouchShoot(%f,%f), g_Key_Lock_Flag=%d",tpt.x,tpt.y,self.g_Key_Lock_Flag);
			if (self.g_Key_Lock_Flag>0) then
				local  t_lock_fish_id = self.lock_fish_manager_:GetLockFishID(me_chair_id);
				if ( self.m_touch_begin_flag>0) then --t_lock_fish_id <= 0  or
						self.m_touch_begin_flag = 0;
						local  t_Fish = self.g_fish_manager:Touch_FishByPosition(tpt.x, tpt.y, 0);
						if (t_Fish and t_lock_fish_id ~= t_Fish:fish_id()) then
							t_lock_fish_id = t_Fish:fish_id();
                          --   cclog("GameScene:TouchShoot(%f,%f), g_Key_Lock_Flag=%d, t_lock_fish_id=%d,,213123123123123123123123123123123",tpt.x,tpt.y,self.g_Key_Lock_Flag,t_lock_fish_id);
							if (t_lock_fish_id > 0) then
								local t_ccp_pos=t_Fish:GetCurPos();
							    self.lock_fish_manager_:SetLockFishID(me_chair_id, t_lock_fish_id);
							   end
						  end
				 end

			 end
--endregion
					local  mouse_pos=tpt;--cc.p(0, 0);
					if (self.lock_fish_manager_:GetLockFishID(me_chair_id) >0) then
						    mouse_pos = self.lock_fish_manager_:LockPos(me_chair_id);
					end
					local cannon_pos = self.cannon_manager_:GetCannonPos(me_chair_id,0);
                    --cclog("mouse_pos(%f,%f),cannon_pos(%f,%f)",mouse_pos.x, mouse_pos.y, cannon_pos.x, cannon_pos.y);
					local can_fire = self:CanFire(me_chair_id, mouse_pos);
					if (can_fire==true) then
					   	  local  angle
                if isKey == false then
                  angle = self:CalcAngle(mouse_pos.x, mouse_pos.y, cannon_pos.x, cannon_pos.y);
                  self.cannon_manager_:SetCurrentAngle(me_chair_id, angle);
                else
                  angle = self.cannon_manager_:GetCurrentAngle(me_chair_id)
                end

							local  me_fish_score =self.cannon_manager_:GetFishScore(me_chair_id);
							if (me_fish_score > 0  and self.current_bullet_mulriple_ > me_fish_score) then
								self.current_bullet_mulriple_ = me_fish_score;
								self.current_bullet_kind_ =self.current_bullet_kind_ %4;
								if (self.m_speed_bt_state>0) then self. current_bullet_kind_ = self.current_bullet_kind_ % 4 + 4; end
								self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
								self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);
						    end
							if (self.current_bullet_mulriple_ < self.min_bullet_multiple_
								or self.current_bullet_mulriple_ > self.max_bullet_multiple_)
							then
								self.current_bullet_mulriple_ = self.min_bullet_multiple_;
								self.current_bullet_kind_ = self.current_bullet_kind_%4;
								if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
								self.cannon_manager_:Switch(me_chair_id, current_bullet_kind_);
								self.cannon_manager_:SetCannonMulriple(me_chair_id, current_bullet_mulriple_);
							end
							if (me_fish_score>=self.current_bullet_mulriple_) then
                                self.m_fire_timer = 0;
								if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
								self:SendUserFire(self.current_bullet_kind_, angle,self.current_bullet_mulriple_, self.lock_fish_manager_:GetLockFishID(me_chair_id));

							end
					end
			end
	end
    --]]
 end
 function  GameScene:AutoExitUpdate(dt)     --空闲离开更新
       if(self.allow_fire_==true) then self.m_dle_timer= self.m_dle_timer+dt; end
       --[[
        cclog("running fisccount=%d,freebulletcount=%d,bulletcount=%d",
        self.g_fish_manager:GetFishTotalNum(),
        self.g_Free_Bullet_Manager:GetBulletTotalNum(),
        self.g_bulletmanager:GetBulletTotalNum());
        --]]
		if (self.m_dle_timer > 60)
		then
			local t_winsize = cc.Director:getInstance():getWinSize();
			if (self.m_dle_exit_spr_bg == nil)
			then
				self.m_dle_exit_spr_bg = cc.Sprite:create("haiwang/res/HW/ExitTimeTip.png");
				if (self.m_dle_exit_spr_bg)
				then
					self:addChild(self.m_dle_exit_spr_bg, 1000);
					self.m_dle_exit_spr_bg:setPosition(cc.p(t_winsize.width / 2, t_winsize.height / 2));
					self.m_LeftNum_timer =cc.LabelAtlas:_create("30","haiwang/res/HW/GuidedMissileNum.png", 35, 44, 47);
					self.m_dle_exit_spr_bg:addChild(self.m_LeftNum_timer, 11);
					self.m_LeftNum_timer:setAnchorPoint(cc.p(0.5, 0.5));
					self.m_LeftNum_timer:setPosition(cc.p(580 , 30));
				end
			end
			if (self.m_LeftNum_timer) then
				local t_leftTimer = math.floor(90 -self.m_dle_timer);
                self.m_LeftNum_timer:setString(t_leftTimer);
				--self.m_LeftNum_timer:setString(t_leftTimer);
				if (t_leftTimer == 0) then self:CloseGameClient(); end
			end
		end
 end
 function GameScene:CloseGameClient()
     cclog("GameScene:CloseGameClient");
     exit_haiwang();
 end
 function GameScene:ResetDleTimer()

	self.m_dle_timer = 0;
	if (self.m_dle_exit_spr_bg)
	then
		self.m_dle_exit_spr_bg:removeAllChildren();
		self:removeChild(self.m_dle_exit_spr_bg);
   end
	self.m_dle_exit_spr_bg = nil;
	self.m_LeftNum_timer = nil;
end
 function  GameScene:SendCatchFish( fish_id,  firer_chair_id,  bullet_id,  bullet_kind,  bullet_mulriple,  nParam)
--         cclog(" GameScene:SendCatchFish fish_id=%d,firer_chair_id=%d,bullet_id=%d,bullet_kind=%d,bullet_mulriple=%d,nParam=%d",
--          fish_id,  firer_chair_id,  bullet_id,  bullet_kind,  bullet_mulriple,  nParam
--         );
        local buff = sendBuff:new();
	    buff:setMainCmd(pt.MDM_GF_GAME);
    	buff:setSubCmd(pt.SUB_C_CATCH_FISH);
	    buff:writeShort(firer_chair_id);
        buff:writeInt(fish_id);
        buff:writeInt(bullet_kind);
        buff:writeInt(bullet_id);
        buff:writeInt(bullet_mulriple);
        buff:writeInt(nParam);
	    netmng.sendGsData(buff)
        --[[
    buff:setMainCmd(pt.MDM_GF_GAME)
	buff:setSubCmd(pt.SUB_C_CATCH_FISH)
	buff:writeShort(chair_id)
	buff:writeInt(fish_id)
	buff:writeInt(bullet_kind)
	buff:writeInt(bullet_id)
	buff:writeInt(bullet_multiple)
	buff:writeInt(param)
	netmng.sendGsData(buff)
        --]]
 end

 function GameScene:SendUserFire(bullet_kind,angle,bullet_mulriple,lock_fishid,chair_id_ex)--最后一个参数针对第三方

    if(self.cannon_manager_==nil) then return false; end
    if(self.m_soundsetting_node~=nil) then return false; end
    if (self.m_IsSwitchingScene>0) then return  false;  end--正在切换场景
    if (self.g_back_Fore_Delay > 0.000001) then return false ; end--从后台返回
    if (self.cannon_manager_ == nil) then return false; end
    local me_chair_id =self:getMeChairID();
    if(chair_id_ex~=nil) then me_chair_id=chair_id_ex; end
    if(me_chair_id < GAME_PLAYER
		and self.g_bulletmanager:GetBulletNum(me_chair_id) < 25
		and self.m_ion_lock <= 0
		) then
          --cclog("GameScene:SendUserFire(bullet_kind,angle,bullet_mulriple,lock_fishid)");

          self:ResetDleTimer();
          if (self.cannon_manager_:GetMRY_State(me_chair_id)>0) then
             if(self.m_MRY_Fire_timer<0.35) then return ; end
              self.m_MRY_Fire_timer=0;
              local _mulriple = self.cannon_manager_:GetMRY_Mul(me_chair_id);
              local buff = sendBuff:new();
               buff:setMainCmd(pt.MDM_GF_GAME);
    	       buff:setSubCmd(pt.SUB_C_MRYTOUCH_CATCH);
			   buff:writeShort(me_chair_id);
               buff:writeInt(_mulriple);
			   netmng.sendGsData(buff)
			return;
        elseif (self.cannon_manager_:DianciDelayCheck(me_chair_id)>0) then  return; end
      	local t_spec_kind_num =self.cannon_manager_:Getspec_KindNum(me_chair_id);
        if(t_spec_kind_num>0)then
           if( self.m_Free_Fire_timer<0.25) then  return;
           else self.m_Free_Fire_timer=0; end
        end
        if (bullet_mulriple < 1) then return ;end
		local  tem_GetCount = 0;
		local  tem_bulletStartNum = me_chair_id * 10000;
		if (self.current_bullet_id_ < tem_bulletStartNum)then self.current_bullet_id_ = tem_bulletStartNum; end
		self.current_bullet_id_=self.current_bullet_id_+1;
		if (self.current_bullet_id_ > (tem_bulletStartNum + 9998)) then self.current_bullet_id_ = tem_bulletStartNum; end
        --int t_spec_kind_num = cannon_manager_->Getspec_KindNum(me_chair_id);

        local bullet_kind_ = bullet_kind;
        local buff = sendBuff:new();
	    buff:setMainCmd(pt.MDM_GF_GAME);
    	buff:setSubCmd(pt.SUB_C_USER_FIRE);
	    buff:writeInt(bullet_kind);
	    buff:writeFloat(angle);
	    buff:writeInt(bullet_mulriple);
	    buff:writeInt(lock_fishid);
	    buff:writeInt(self.current_bullet_id_);
        buff:writeInt(t_spec_kind_num);
	    netmng.sendGsData(buff)
       local param = {}
       param.from_server_flag=0;
	   param.bullet_kind=bullet_kind_ ;
       param.bullet_id=self.current_bullet_id_ ;
       param.bullet_specKindFlag= t_spec_kind_num  ;
       param.chair_id=me_chair_id;
       param.android_chairid=-1;
       param.angle=angle;
       param.bullet_mulriple=bullet_mulriple;
       param.lock_fishid=lock_fishid;
       param.fish_score= -bullet_mulriple;
       self.current_bullet_self_count=self.current_bullet_self_count+1;
       self:OnSubUserFire(param);
     end
 end

 function GameScene:KeyUpdate(dt)
  --炮管左转
  if self.keyLeftPressed == true then
      self.keyPressDT = self.keyPressDT + dt
      if self.keyPressDT >= 0.1 then
        self.keyPressDT = 0
        self:keySetRota(1)
        self.isKeyShoot = true
      end
  end
  -- 炮管右转
  if self.keyRightPressed == true then
    self.keyPressDT = self.keyPressDT + dt
    if self.keyPressDT >= 0.1 then
      self.keyPressDT = 0
      self:keySetRota(2)
      self.isKeyShoot = true
    end
  end

  --加分
  if self.keyUpPressed == true then
    self.keyUpDT = self.keyUpDT + dt
    if self.keyUpDT >= 0.1 then
      self.keyUpDT = 0
      self:Add_bullet_cur_Num()
    end
  end

  --减分
  if self.keyDownPressed == true then
    self.keyDownDT = self.keyDownDT + dt
    if self.keyDownDT >= 0.1 then
      self.keyDownDT = 0
      self:Sub_bullet_cur_Num()
    end
  end

  --锁鱼
  if self.keySPressed == true then
    self.keySDT = self.keySDT + dt
    if self.keySDT >= 0.5 then
      self.keySDT = 0
      self:KeyToLockFish()
    end
  end
end
 function  GameScene:update(delta)
        if(self.g_back_Fore_Delay>-0.000001) then self.g_back_Fore_Delay=self.g_back_Fore_Delay-delta; end
         self:Input_KeyUpdate(delta);
         self:AutoExitUpdate(delta)
         self:Mark_SceneUpdate();--//更新
         self:KeyUpdate(delta)
 end
function  GameScene:getMeChairID()
   self.g_me_chair_id=0;
   local tableId = global.g_mainPlayer:getCurrentTableId()
   local tableUser = global.g_mainPlayer:getTableUser(tableId)
    for k, v in pairs(tableUser) do
        local pd = global.g_mainPlayer:getRoomPlayer(v);
         if pd.playerId == global.g_mainPlayer:getPlayerId()
         then
         --cclog(" GameScene:getMeChairID pd.chairId=%d",pd.chairId)
         if(pd.chairId~=nil) then self.g_me_chair_id=pd.chairId; end
         end
     end
     return  self.g_me_chair_id;
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

  cc.exports.keyF4Pressed = false --控制生成设置popNode的标志

  self.isShowBL = true --刚进来会显示，所以true

  self.isKeyShoot = false

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
    self.isKeyShoot = true
  elseif keyCode == 27 then
    self:keySetRota(2)
    self.keyRightPressed = true
    self.keyPressDT = 0
    self.isKeyShoot = true
  elseif keyCode == 28 then
    self.keyUpPressed = true
    self.keyUpDT = 0
    self:Add_bullet_cur_Num()
  elseif keyCode == 29 then
    self:Sub_bullet_cur_Num()
    self.keyDownPressed = true
    self.keyDownDT = 0
  elseif keyCode == 59 then
    self.m_auto_bt_state = 1
  elseif keyCode == 142 then --锁
    self:KeyToLockFish()
    self.keySPressed = true
    self.keySDT = 0
  elseif keyCode == 140 then --取消锁鱼
    self:KeyToUnLockFish()
  elseif keyCode == 129 then --自动发炮
    self:KeyToAutoFire()
  elseif keyCode == 50 then  --打开设置
    if keyF4Pressed == false then
      self:ShowSoundSetting()
      keyF4Pressed = true
    end
  elseif keyCode == 51 then  --倍率
    self:OpenRateTable()
  elseif keyCode == 52 then --加速
    self:KeyToSpeedUp()
  end
end

function GameScene:keyboardReleased(keycode, event)
    if keycode == 6 then --返回键
      if self.back_release_ then
        self.back_release_ = false
        local  function  onCancel()
            self.g_exit_flag=false;
            self.back_release_ = true
        end
        if(self.g_exit_flag==false) then
            self.g_exit_flag=true;
            cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
             WarnTips.showTips({
                           text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
                           confirm = exit_haiwang,
                           cancel = onCancel
        })
        end
      end
    elseif keycode == 59 then
      self.m_auto_bt_state = 0
    elseif keycode == 29 then
      self.keyDownPressed = false
      self.keyDownDT = 0
    elseif keycode == 28 then
      self.keyUpPressed = false
      self.keyUpDT = 0
    elseif keycode == 26 then
      self.keyLeftPressed = false --按下状态取消
    elseif keycode == 27 then
      self.keyRightPressed = false
    elseif keycode == 142 then
        self.keySPressed = false
        self.keySDT = 0
    end
end

function GameScene:keySetRota(keyDir)  --1=l,2=r
  local myId = self:getMeChairID()
  local ang = self.cannon_manager_:GetCurrentAngle(myId)
  local rot = math.deg(ang)
  if myId <= 1 then

    if keyDir == 1 then
      if rot == 0 then rot = -180
      elseif rot > 0 then rot = rot - 360 end

      rot = rot + 5
      if rot > -90 then rot = -90 end
    else
      if rot == 0 then rot = 180
      elseif rot < 0 then rot = rot + 360 end

      rot = rot - 5
      if rot < 90 then rot = 90
      elseif rot == - 180 then rot = 180
      end
    end
  else
    if keyDir == 1 then
      rot = rot - 5
      if rot < -90 then rot = -90 end
    else
      rot = rot + 5
      if rot > 90 then rot = 90 end
    end
  end
  ang = math.rad(rot)
  self.cannon_manager_:SetCurrentAngle(myId,ang)
end

--载入游戏按键ui
function GameScene:Load_TouchUI()
   --self.touch_ui= ccs.GUIReader:getInstance():widgetFromJsonFile("haiwang/res/HW/Json/haiwang_bt_ui_1.json")
   -- self:addChild(root)
   local t_mechair_id = self:getMeChairID();
    local root =nil;
    if( cc.exports._local_player_num_I==4) then 
       root =ccs.GUIReader:getInstance():widgetFromJsonFile("haiwang/res/HW/Json/haiwang_bt_ui_4.json")
    else 
       root =ccs.GUIReader:getInstance():widgetFromJsonFile("haiwang/res/HW/Json/haiwang_bt_ui_1.json")
    end

    self:addChild(root,966669);
    --返回
     local  function touchEvent_back_bt(sender, eventType)
         if eventType == ccui.TouchEventType.ended then
          --exit_haiwang();
           local  function  onCancel()
            self.g_exit_flag=false;
            end
            if(self.g_exit_flag==false) then
                self.g_exit_flag=true;
                cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_DEFAULT)
                 WarnTips.showTips({
                               text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
                               confirm = exit_haiwang,
                               cancel = onCancel
            })
            end
          end
   end
     local Button_11 = ccui.Helper:seekWidgetByName(root,"Button_11");
      if(Button_11~=nil) then
        Button_11:addTouchEventListener(touchEvent_back_bt);
       end
    --倍率
   local  function touchEvent_rate_bt(sender, eventType)
         if eventType == ccui.TouchEventType.began then
           if(self.m_show_rate_flag==0) then
             self.m_show_rate_flag=1;
             self:show_rate(1);
           else
             self.m_show_rate_flag=0;
             self:show_rate(0);
           end
          end
      --  if eventType == ccui.TouchEventType.ended then   self:show_rate(0);end
   end
      local rate_bt = ccui.Helper:seekWidgetByName(root,"rate_bt");
      --if(rate_bt~=nil) then rate_bt:addTouchEventListener(makeClickHandler(self, self.touchEvent_rate_bt));end
      if(rate_bt~=nil) then rate_bt:addTouchEventListener(touchEvent_rate_bt);end
    --设置
     local  function touchEvent_setting_bt(sender, eventType)
         if eventType == ccui.TouchEventType.ended then
               self:ShowSoundSetting();
           end
     end
      local setting_bt = ccui.Helper:seekWidgetByName(root,"setting_bt");
       if(rate_bt~=nil) then setting_bt:addTouchEventListener(touchEvent_setting_bt); end
    --结算
      local seetlement_bt = ccui.Helper:seekWidgetByName(root,"seetlement_bt");
      if(seetlement_bt~=nil) then
      seetlement_bt:setEnabled(false);
      seetlement_bt:setVisible(false);
      end
     --  if(seetlement_bt~=nil) then seetlement_bt:addTouchEventListener(makeClickHandler(self, self.touchEvent_setting_bt)); end
    --锁定
      lock_bt = ccui.Helper:seekWidgetByName(root,"lock_bt");
      if(lock_bt~=nil)  then
               lock_bt:setString("3");

              self.lock_ring = ccui.Helper:seekWidgetByName(root,"lock_ring");
			  if (self.lock_ring) then
                 local t_rot = cc.RotateBy:create(2, 360);
		          local t_tep = cc.RepeatForever:create(t_rot);
		          self.lock_ring:runAction(t_tep);
                  self.lock_ring:setVisible(false);
              end
              local  function touchEvent_lock_bt(sender, eventType)
                      if eventType == ccui.TouchEventType.ended then
                           if (self.m_lock_bt_state == 0)  then      --锁定按键状态
                              	self.m_lock_bt_state = 1;
                                 lock_bt:setString("2");
                                 if (self.lock_ring) then self.lock_ring:setVisible(true); end
                                 self:Lock_fish(t_mechair_id);
                           else
                              self.m_lock_bt_state = 0;
                              lock_bt:setString("3");
                              if (self.lock_ring) then self.lock_ring:setVisible(false); end
                              self:UnLock_fish(t_mechair_id);
                           end
                         --执行发达缩小动作
                        local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
			            local t_delay = cc.DelayTime:create(0.06);
			            local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
			            local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
			            lock_bt:runAction(t_seq);
                   end
               end
              lock_bt:addTouchEventListener(touchEvent_lock_bt);
       end
     --极速
       self.speed_bt = ccui.Helper:seekWidgetByName(root,"speed_bt");
       if(self.speed_bt~=nil)  then
              self.speed_bt:setString("5");
               self.speed_ring =ccui.Helper:seekWidgetByName(root,"speed_ring");
                if (self.speed_ring) then
                  local t_rot = cc.RotateBy:create(2, 360);
		          local t_tep = cc.RepeatForever:create(t_rot);
		          self.speed_ring:runAction(t_tep);
                  self.speed_ring:setVisible(false);
                 end
                 local function touchEvent_speed_bt(sender, eventType)
                  if eventType == ccui.TouchEventType.ended then
                      --if (self.g_init_ok_flag < 1)return;
                      if (self.m_speed_bt_state == 0) then     --极速按键状态
                           self.m_speed_bt_state = 1;            --打开极速
				            self.speed_bt:setString("4");
                            if (self.speed_ring) then self.speed_ring:setVisible(true); end
                            local  t_bulletKind =  self.current_bullet_kind_;
                            if (t_bulletKind <= 3)  then t_bulletKind = (t_bulletKind%4 + 4); end
			             	 self.current_bullet_kind_ = t_bulletKind;
                            self.cannon_manager_:Switch(t_mechair_id, t_bulletKind);
                      else
                           self.m_speed_bt_state = 0;--关闭极速
				           self.speed_bt:setString("5");
                           if (self.speed_ring) then self.speed_ring:setVisible(false); end
                           local t_bulletKind = self.current_bullet_kind_;
				           if (t_bulletKind >= 4) then t_bulletKind =t_bulletKind%4; end
				           self.current_bullet_kind_ = t_bulletKind;
				           self.cannon_manager_:Switch(t_mechair_id, t_bulletKind);
                      end
                        --执行发达缩小动作
                        local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
			            local t_delay = cc.DelayTime:create(0.06);
			            local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
			            local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
			            self.speed_bt:runAction(t_seq);
                  end
              end
             self.speed_bt:addTouchEventListener(touchEvent_speed_bt);

        end
     --自动
      self.auto_bt = ccui.Helper:seekWidgetByName(root,"auto_bt");
        if(self.auto_bt~=nil)   then
          self.auto_bt:setString("1");
          self.auto_ring =ccui.Helper:seekWidgetByName(root,"auto_ring");
          if (self.auto_ring) then
            local t_rot = cc.RotateBy:create(2, 360);
  		      local t_tep = cc.RepeatForever:create(t_rot);
  		      self.auto_ring:runAction(t_tep);
            self.auto_ring:setVisible(false);
          end
          local function touchEvent_auto_bt(sender, eventType)
          if eventType==ccui.TouchEventType.ended then
            if (self.m_auto_bt_state == 0) then
              self.m_auto_bt_state = 1;
              self.auto_bt:setString("0");
              if (self.auto_ring) then
                self.auto_ring:setVisible(true)
              end
            else
              self.m_auto_bt_state = 0;
              self.auto_bt:setString("1");
              if (self.auto_ring) then
                self.auto_ring:setVisible(false)
              end
            end
               --执行发达缩小动作
            local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
       	    local t_delay = cc.DelayTime:create(0.06);
            local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
            local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
            self.auto_bt:runAction(t_seq);
          end
        end
          self.auto_bt:addTouchEventListener(touchEvent_auto_bt);
      end
      --
end


function GameScene:KeyToSpeedUp()
  if (self.m_speed_bt_state == 0) then     --极速按键状态
    self.m_speed_bt_state = 1;            --打开极速
    self.speed_bt:setString("4");
    if (self.speed_ring) then self.speed_ring:setVisible(true); end
    local  t_bulletKind =  self.current_bullet_kind_;
    if (t_bulletKind <= 3)  then t_bulletKind = (t_bulletKind%4 + 4); end
    self.current_bullet_kind_ = t_bulletKind;
    self.cannon_manager_:Switch(self:getMeChairID(), t_bulletKind);
  else
    self.m_speed_bt_state = 0;--关闭极速
    self.speed_bt:setString("5");
    if (self.speed_ring) then self.speed_ring:setVisible(false); end
    local t_bulletKind = self.current_bullet_kind_;
    if (t_bulletKind >= 4) then t_bulletKind =t_bulletKind%4; end
    self.current_bullet_kind_ = t_bulletKind;
    self.cannon_manager_:Switch(self:getMeChairID(), t_bulletKind);
  end
            --执行发达缩小动作
  local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
  local t_delay = cc.DelayTime:create(0.06);
  local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
  local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
  self.speed_bt:runAction(t_seq);

end

function GameScene:KeyToUnLockFish()
  self.m_lock_bt_state = 0;
  lock_bt:setString("3");
  if (self.lock_ring) then self.lock_ring:setVisible(false); end
  self:UnLock_fish(self:getMeChairID());
  --执行发达缩小动作
  local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
  local t_delay = cc.DelayTime:create(0.06);
  local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
  local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
  lock_bt:runAction(t_seq);
end

function GameScene:OpenRateTable()
  if(self.m_show_rate_flag==0) then
    self.m_show_rate_flag=1;
    self:show_rate(1);
  else
    self.m_show_rate_flag=0;
    self:show_rate(0);
  end
end

function GameScene:KeyToLockFish()
  self.m_lock_bt_state = 1;
  lock_bt:setString("2");
  if (self.lock_ring) then self.lock_ring:setVisible(true); end
  self:Lock_fish(self:getMeChairID());
        --执行发达缩小动作
  local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
  local t_delay = cc.DelayTime:create(0.06);
  local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
  local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
  lock_bt:runAction(t_seq);
end

function GameScene:KeyToAutoFire()
  if (self.m_auto_bt_state == 0) then
    self.m_auto_bt_state = 1;
    self.auto_bt:setString("0");
    if (self.auto_ring) then
      self.auto_ring:setVisible(true)
    end
  else
    self.m_auto_bt_state = 0;
    self.auto_bt:setString("1");
    if (self.auto_ring) then
      self.auto_ring:setVisible(false)
    end
  end
     --执行发达缩小动作
  local t_scale_to = cc.ScaleTo:create(0.06, 1.2);
  local t_delay = cc.DelayTime:create(0.06);
  local  t_scale_to1 = cc.ScaleTo:create(0.06, 1.0);
  local t_seq = cc.Sequence:create(t_scale_to, t_delay, t_scale_to1, nil);
  self.auto_bt:runAction(t_seq);
end

--添加波浪
function GameScene:AddWavNode()
  local winsize =  cc.Director:getInstance():getWinSize() ;
  local t_wav_width = 256;
  local t_wav_height =256;
  local t_wav_scale = 1.0;
  local _num1 = math.ceil(winsize.width / t_wav_width) + 1;
  local  _num2 = math.ceil(winsize.height / t_wav_height) + 1;
  local t_start_pos = cc.p(t_wav_width / 2, t_wav_height / 2);
  local spriteFrame  = cc.SpriteFrameCache:getInstance()
 spriteFrame:addSpriteFrames("haiwang/res/HW/wav_.plist")
  t_wav_width = t_wav_width*t_wav_scale;
  t_wav_height = t_wav_height*t_wav_scale;
  self.m_wav_Node=cc.Node:create();
  self:addChild( self.m_wav_Node,cc.exports.GAME_UIORDER_ - 1);
  --print("GameScene:AddWavNode _num1=%d,_num2=%d \n",_num1,_num2);
  local i,n=0,0;
  for  i = 0, _num1,1 do
       for n = 0,_num2,1 do
           local flip_x = 0;
		   local flip_y = 0;
           local t_showpos = cc.p(t_start_pos.x,t_start_pos.y);
	    	t_showpos.x = t_showpos.x +(i*t_wav_width);
	        t_showpos.y= t_showpos.y+(n*t_wav_height);
           if i % 2 == 1 then flip_x = 1;  end;
		   if n % 2 == 1 then flip_y = 1; end;

            local _sprite = cc.Sprite:createWithSpriteFrameName("~NewWave_000_000.png")
            _sprite:setAnchorPoint( 0.5, 0.5)
            --print("GameScene:AddWavNode i=%d,n=%d  t_showpos(%f,%f)\n",i,n,t_showpos.x,t_showpos.y);
            _sprite:setPosition( t_showpos);
           --_sprite:setFlippedX(flip_x);
           --_sprite:setFlippedY(flip_y);
           self.m_wav_Node:addChild( _sprite );
           local animation = cc.Animation:create()
           for k=0, 40,1 do
                local blinkFrame = spriteFrame:getSpriteFrame( string.format("~NewWave_000_%03d.png", k) )
                if blinkFrame~=nil then animation:addSpriteFrame( blinkFrame )  end;
           end
           animation:setDelayPerUnit(1/24.0);            --设置两个帧播放时间
          -- animation:setRestoreOriginalFrame(true);    --动画执行后还原初始状态
           local action =cc.Animate:create(animation);
            _sprite:runAction(cc.RepeatForever:create(action));
       end
  end
  -- display.addSpriteFramesWithFile("haiwang/res/HW/wav_.plist","haiwang/res/HW/wav_.png");
  --self._sp = display.newSprite("#f1.png")
  --self:addChild(self._sp, 0)
  --local frames = display.newFrames("f%d.png",1, 6)
  --local animate = display.newAnimation(frames, 0.1)
  --self._sp:playAnimationForever(animate, 0.08)
   --cc.SpriteFrameCache:getInstance():addSpriteFrames("iconslotfish.plist")
   --local spr = cc.SpriteFrameCache:getInstance():getSpriteFrame("1.png");
end
--endregion
---------------------------------------------功能函数------------------------------------------------------------------------------------------------------------------
function GameScene:AllowFire(allow)
    self.allow_fire_ = allow;
end
function GameScene:EndSceneTra()--场景切换完成
  --显示垃圾回收
    collectgarbage("collect");
    collectgarbage("collect");
    --cclog("GameScene:EndSceneTra.........");
	self.m_IsSwitchingScene = 0;
    self.m_change_sceneLogoFlag = 0;
    self.allow_fire_ = true;
	cc.exports.g_soundManager:PlayBackMusic();
	if (self.g_switch_Scene>0)then
		--清空当前鱼
        self.g_fish_manager:FreeAllFish();
        self.g_bulletmanager:FreeAllBullet();
        self.g_Free_Bullet_Manager:FreeAllBullet();
        self.g_BingoManager:removeAllChildren();
       self.g_CoinManager:removeAllChildren();
		--if (m_pFishGroup) then self.g_fish_manager:FreeAllFish(); end
		self.lock_fish_manager_:ClearLockTrace(self:getMeChairID());
		self:AllowFire(true);
        local i=0;
		for i = 0, GAME_PLAYERCLIENT,1 do
			self:UnLock_fish(i);
		end
		--生成矩阵
		self:RunSceneSwitch_Trace();
		self.g_switch_Scene = 0;
	end
   ----
end
function GameScene:RunSceneSwitch_Trace()       --切换后再生成矩阵 避免切换时打死的鱼不消失

      collectgarbage("collect");
      collectgarbage("collect");
     local switch_scene=self.m_switchScene_buf;
     --cclog("GameScene:RunSceneSwitch_Trace scene_kind=%d,fish_count=%d",switch_scene.scene_kind,switch_scene.fish_count);
     local  t_scene_mov_speed = 1;
       if switch_scene.scene_kind == 0 then
           if (switch_scene.fish_count ~= 210) then return false; end
           local i=0;
           --local scene_kind_1_trace_=self.g_scene_fish_trace:GetScene1Trace();
           for  i = 0,#cc.exports.scene_kind_1_trace_,1 do
               local s_table=cc.exports.scene_kind_1_trace_[i];--cc.exports.scene_kind_1_trace_[i];
               local start_pos=cc.p(s_table[1][1],s_table[1][2]);
               local t_fish_kind=switch_scene.fish_kind[i];
               local t_fish_id=switch_scene.fish_id[i];
               local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, t_fish_id, self.fish_multiple_[t_fish_kind],
				                                                                 t_scene_mov_speed, self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,0,1);
            if(t_Fish~=nil) then
               local  init_pos={[0]=cc.p(s_table[1][1],s_table[1][2]), cc.p(s_table[2][1],s_table[2][2])};
              --  cclog(" GameScene:RunSceneSwitch_Trace  init_pos(%d,%d)(%d,%d)",init_pos[0].x,init_pos[0].y,init_pos[1].x,init_pos[1].y);
               t_Fish:MovByList(init_pos,2,30, 0);
               t_Fish:setscene_fish_flag();
            end
           end--for i
       elseif switch_scene.scene_kind ==1 then
              if (switch_scene.fish_count ~= 214) then return false; end
              local i=0;
              local scene_kind_2_small_fish_stop_index_=cc.exports.scene_kind_2_small_fish_stop_index_;
              local scene_kind_2_small_fish_stop_count_=cc.exports.scene_kind_2_small_fish_stop_count_;
              local scene_kind_2_big_fish_stop_index_=cc.exports.scene_kind_2_big_fish_stop_index_;
              local scene_kind_2_big_fish_stop_count_=cc.exports.scene_kind_2_big_fish_stop_count_;
              for  i = 0,switch_scene.fish_count-1,1 do
                   --cclog(" GameScene:RunSceneSwitch_Trace1 i=%d,switch_scene.fish_count=%d aa",i,switch_scene.fish_count);
                   local t_table=nil;
                   if(i<100) then
                     t_table=cc.exports.scene_kind_2_trace0[i+1];
                   else
                      t_table=cc.exports.scene_kind_2_trace1[i-97];
                   end;
                   if(t_table) then
                      --cclog(" GameScene:RunSceneSwitch_Trac1e2 i=%d,switch_scene.fish_count=%d bb",i,switch_scene.fish_count);
                      local startpos__=t_table[0];
                       local start_pos=cc.p(startpos__[1],startpos__[2]);
                       local t_fish_kind=switch_scene.fish_kind[i];
                       local t_fish_id=switch_scene.fish_id[i];
                       local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, t_fish_id, self.fish_multiple_[t_fish_kind],
				                                                                 t_scene_mov_speed, self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,0,1);
                       if(t_Fish~=nil) then
                           t_Fish:set_trace_type(0);
                           t_Fish:setFish_mov_trace(t_table);
			          	   if (i < 200) then      t_Fish:SetFishStop(scene_kind_2_small_fish_stop_index_[i], scene_kind_2_small_fish_stop_count_);
				           else                      t_Fish:SetFishStop(scene_kind_2_big_fish_stop_index_, scene_kind_2_big_fish_stop_count_);
                           end
                           t_Fish:set_active(true);
                           t_Fish:setscene_fish_flag();
                      end
                  end
           end--for i
        elseif switch_scene.scene_kind ==2 then
             if (switch_scene.fish_count ~= 242) then return false; end
              local i=0;
              for  i = 0, #cc.exports.scene_kind_3_trace_,1 do
                   local s_table=cc.exports.scene_kind_3_trace_[i];
                   local start_pos=cc.p(s_table[1][1],s_table[1][2]);
                   local t_fish_kind=switch_scene.fish_kind[i];
                   local t_fish_id=switch_scene.fish_id[i];
                   local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, t_fish_id, self.fish_multiple_[t_fish_kind],
				                                                                 t_scene_mov_speed, self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,0,1);
                   if(t_Fish~=nil) then
                          local  init_pos={[0]=cc.p(s_table[1][1],s_table[1][2]),  cc.p(s_table[2][1],s_table[2][2])};
                          t_Fish:MovByList(init_pos,2,30, 0);
                          t_Fish:setscene_fish_flag();
                  end
           end--for i
       elseif switch_scene.scene_kind ==3 then
              if (switch_scene.fish_count ~= 64) then return false; end
              local i=0;
              for  i = 0, #cc.exports.scene_kind_4_trace_,1 do
                   local s_table=cc.exports.scene_kind_4_trace_[i];
                   if(s_table) then
                           local start_pos=cc.p(s_table[1][1],s_table[1][2]);
                           local t_fish_kind=switch_scene.fish_kind[i];
                           local t_fish_id=switch_scene.fish_id[i];
                           local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, t_fish_id, self.fish_multiple_[t_fish_kind],
				                                                                 t_scene_mov_speed, self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,0,1);
                           if(t_Fish~=nil) then
                              local  init_pos={[0]=cc.p(s_table[1][1],s_table[1][2]),  cc.p(s_table[2][1],s_table[2][2])};
                              t_Fish:MovByList(init_pos,2,60, 0);
                              t_Fish:setscene_fish_flag();
                          end
                   end

           end--for i
       elseif switch_scene.scene_kind ==4 then
              if (switch_scene.fish_count ~= 236) then return false; end
              local i=0;
              for  i = 0,switch_scene.fish_count-1,1 do
                  local s_table=nil;
                  local t_index=0;
                  if(i<100) then
                      t_index=i+1;
                       s_table=cc.exports.scene_kind_5_trace0[t_index];
                  elseif(i<150) then
                        t_index=i-99;
                       s_table=cc.exports.scene_kind_5_trace10[t_index];
                  elseif(i<200) then
                        t_index=i-149;
                       s_table=cc.exports.scene_kind_5_trace11[i-149];
                  else
                      t_index=i-197;
                    s_table=cc.exports.scene_kind_5_trace2[i-197];
                  end
                  if(s_table) then
                      local startpos__=s_table[0];
                      local start_pos=cc.p(startpos__[1],startpos__[2]);
                     local t_fish_kind=switch_scene.fish_kind[i];
                     local t_fish_id=switch_scene.fish_id[i];
                     local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, t_fish_id, self.fish_multiple_[t_fish_kind],
				                                                                 t_scene_mov_speed, self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,0,1);
                     if(t_Fish~=nil) then
                         t_Fish:set_trace_type(0);
                         t_Fish:setFish_mov_trace(s_table);
                         t_Fish:set_active(true);
                         t_Fish:setscene_fish_flag();
                     end
                 end
           end--for i-
       end
       --]]
end
function GameScene:Add_bullet_cur_Num()--++切换
     local me_chair_id =self:getMeChairID();
	if (self.allow_fire_ and me_chair_id < GAME_PLAYER) then
		local	 t_last_bulletKind = self.current_bullet_kind_;
		if (self.m_ion_lock == 0)	then
			if (self.current_bullet_mulriple_ >= self.max_bullet_multiple_) then self.current_bullet_mulriple_ = self.min_bullet_multiple_;
		    elseif (self.current_bullet_mulriple_ < 10) then	self.current_bullet_mulriple_=self.current_bullet_mulriple_+1;
			elseif (self.current_bullet_mulriple_ >= 10 and self.current_bullet_mulriple_ < 100) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_+10;
			elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_+100;
			else	self.current_bullet_mulriple_ = self.current_bullet_mulriple_+1000;	end
            if (self.current_bullet_mulriple_ > self.max_bullet_multiple_) then	self.current_bullet_mulriple_ = self.min_bullet_multiple_ ; end
			if (self.current_bullet_mulriple_ < 100) then	self.current_bullet_kind_ = 0;
			elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then self.current_bullet_kind_ = 1;
			elseif (self.current_bullet_mulriple_ >= 1000 and self.current_bullet_mulriple_ < 5000) then self.current_bullet_kind_ = 2;
			else  self.current_bullet_kind_ = 3;	end
			if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
			self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
			self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);
			if (t_last_bulletKind ~= self.current_bullet_kind_) then  cc.exports.g_soundManager:PlayGameEffect("SwitchGunSound");
			else                                                         cc.exports.g_soundManager:PlayGameEffect("AddGunLevelSound"); end
		end
	end
end


function GameScene:Sub_bullet_cur_Num()----切换
     local me_chair_id =self:getMeChairID();
	if (self.allow_fire_ and me_chair_id < GAME_PLAYER) then
		local	 t_last_bulletKind = self.current_bullet_kind_;
		if (self.m_ion_lock == 0)	then
			if (self.current_bullet_mulriple_ <= self.min_bullet_multiple_) then self.current_bullet_mulriple_ = self.max_bullet_multiple_;
		    elseif (self.current_bullet_mulriple_ <= 10) then	self.current_bullet_mulriple_=self.current_bullet_mulriple_-1;
			elseif (self.current_bullet_mulriple_ > 10 and self.current_bullet_mulriple_ <= 100) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-10;
			elseif (self.current_bullet_mulriple_ > 100 and self.current_bullet_mulriple_ <= 1000) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-100;
			else	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-1000;	end
            if (self.current_bullet_mulriple_ < self.min_bullet_multiple_) then	self.current_bullet_mulriple_ = self.max_bullet_multiple_; end
			if (self.current_bullet_mulriple_ < 100) then	self.current_bullet_kind_ = 0;
			elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then self.current_bullet_kind_ = 1;
			elseif (self.current_bullet_mulriple_ >= 1000 and self.current_bullet_mulriple_ < 5000) then self.current_bullet_kind_ = 2;
			else  self.current_bullet_kind_ = 3;	end
			if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
			self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
			self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);
			if (t_last_bulletKind ~= self.current_bullet_kind_) then  cc.exports.g_soundManager:PlayGameEffect("SwitchGunSound"); end
			else                                                         cc.exports.g_soundManager:PlayGameEffect("AddGunLevelSound");
		end
	end
end

function  GameScene:add_fish_score_(chairID,  c_scorenum)--设置玩家鱼币
    --[[ cclog("GameScene:add_fish_score_( chairID=%f,  c_scorenum=%d )self.g_fish_score_[chairID]=%d",chairID,c_scorenum,self.g_fish_score_[chairID]);]]
	cclog("GameScene:add_fish_score_( c_scorenum=%d)",c_scorenum);
    cclog("GameScene:add_fish_score_( chairID=%d)",chairID);
    self.g_fish_score_[chairID]=self.g_fish_score_[chairID]+c_scorenum;
	--if(self.cannon_manager_) then self.cannon_manager_:SetFishScore(chairID, self.g_fish_score_[chairID]);end
    if(self.cannon_manager_) then self.cannon_manager_:SetFishScore(chairID, self.g_fish_score_[chairID]);end
end
function  GameScene:sub_fish_score_(chairID,  c_scorenum)--设置玩家鱼币
   -- cclog("GameScene:sub_fish_score_( chairID=%f,  c_scorenum=%f)",chairID,c_scorenum);
	self.g_fish_score_[chairID]=self.g_fish_score_[chairID] -c_scorenum;
	if(self.cannon_manager_) then self.cannon_manager_:SetFishScore(chairID, self.g_fish_score_[chairID]);end
end
function  GameScene:set_fish_score_( chairID,  c_scorenum)--添加玩家鱼币
   -- cclog("GameScene:set_fish_score_( chairID=%f,  c_scorenum=%f)",chairID,c_scorenum);
	self.g_fish_score_[chairID] = c_scorenum;
	if(self.cannon_manager_) then self.cannon_manager_:SetFishScore(chairID, self.g_fish_score_[chairID]);end
end
function GameScene:Lock_fish( local_chair_id)                                           --锁定鱼
        local  last_lock_fish_kind= self.lock_fish_manager_:GetLockFishKind(local_chair_id);
        local  last_lock_fish_id= self.lock_fish_manager_:GetLockFishID(local_chair_id)
        local lock_fish_id=self.g_fish_manager:LockFish(last_lock_fish_id,last_lock_fish_kind);
       self.lock_fish_manager_:SetLockFishID(local_chair_id, lock_fish_id);
       self.g_Key_Lock_Flag = 1;
       self.g_LockShootstate = 1;
end
function GameScene:UnLock_fish(local_chair_id)
    self.lock_fish_manager_:ClearLockTrace(local_chair_id);
	self.g_LockShootstate = 0;
	self.g_Key_Lock_Flag = 0;
end
function   GameScene:getAutoFire() return self.m_if_Auto_Fire;  end
function   GameScene:getLockShootState() return self.g_LockShootstate;  end
function   GameScene:getKeyLockState() return self.g_Key_Lock_Flag;  end
function   GameScene:getKeyLockBTState() return self.m_lock_bt_state; end

function GameScene:onAutoExitHandler()
  exit_haiwang(GAME_GUIDES.GUIDE_HALL)
end
-------------------------------------------------------------------------消息响应---------------------------------------------------------------------------------
--region
--添加自定义的消息响应
function GameScene:onEndEnterTransition()
  -- 后台返回前台
  cc.Director:getInstance():getRunningScene():openPhysicsWorld()

  if(global.g_gameDispatcher~=nil) then
     --cclog("GameScene:initMsgHandler().......global.g_gameDispatcher~=nil");
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self, self.onEnterForeGround)
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ENTERBACKGROUND, self, self.onEntebackGround)
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_GAME_CONFIG, self, self.OnSubGameConfig);
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_GF_SCENE, self, self.OnEventSceneMessage)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FISH_TRACE, self, self.OnSubFishTrace)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, self, self.OnSubExchangeFishScore)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_USER_FIRE, self, self.OnSubUserFire)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CATCH_FISH, self, self.OnSubCatchFish)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_SWITCH_SCENE, self, self.OnSubSwitchScene)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_SCENE_END, self, self.OnSubSceneEnd)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FISH_QUEUE, self, self.OnSubFishQueue)

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self, self.OnSubHongbaoInfo)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self, self.OnSubHongbaoCatch)


     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, self, self.OnSubUpdateJiejiPlayer)--玩家信息更新

     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_BROACHCATCH_SEND, self, self.OnSubBroach_bulletCatch)--钻头炮
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_DIANCICATCH_SEND, self, self.OnSubDianci_bulletCatch)--电磁炮
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_MISSILECATCH_SEND, self, self.OnSubMissile_bulletCatch)--必杀弹
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_MRYCATCH_SEND, self, self.OnSubMRY_FishCatch)--美人鱼捕获
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_MRY_CARCH_END_SEND, self, self.OnSubMRY_FishCatchEnd)--美人鱼任务结束
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_BAOXANGCATCH_SEND, self, self.OnSubBaoxiangCatch)--宝箱捕获
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_BAOXANGCATCHEND_SEND, self, self.OnSubBaoxiangCatchEnd)--宝箱任务结束
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_FREE_BULLET_END_SEND, self, self.OnSubFreebulletEnd)--免费子弹任务结束

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GF_MESSAGE, self, self.onMessage)
  --用户状态变更
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self, self.onRoomUserLeave)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserFree)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self, self.onGameServerConnectLost)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_AUTO_EXIT, self, self.onAutoExitHandler)
--  --震屏
--  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self, self.ShakeScreen)
  else
 -- cclog("GameScene:initMsgHandler().......global.g_gameDispatcher==nil");
  end
end
--移除自定义的消息响应
function GameScene:onStartExitTransition()
  cc.Director:getInstance():getRunningScene():closePhysicsWorld()
   --cclog("GameScene:removeMsgHandler()");
  -- 后台返回前台
   if(global.g_gameDispatcher~=nil) then
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERFOREGROUND, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ENTERBACKGROUND, self)

   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_GAME_CONFIG, self);
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_GF_SCENE, self);
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_FISH_TRACE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_EXCHANGE_FISHSCORE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_USER_FIRE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_CATCH_FISH, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_SWITCH_SCENE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_SCENE_END, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_FISH_QUEUE, self)


    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self)

    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, self)--钻头炮



    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_BROACHCATCH_SEND, self)--钻头炮
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_DIANCICATCH_SEND, self)--电磁炮
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_MISSILECATCH_SEND, self)--必杀弹
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_MRYCATCH_SEND, self)--美人鱼捕获
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_BAOXANGCATCH_SEND, self)--宝箱捕获
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_BAOXANGCATCHEND_SEND, self)--宝箱任务结束
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_MRY_CARCH_END_SEND, self)--美人鱼任务结束
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_FREE_BULLET_END_SEND, self)--美人鱼任务结束
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GF_MESSAGE, self)
  --用户状态变更
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_AUTO_EXIT, self)
--  --震屏
--  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self)
  end
end


function GameScene:onRoomUserLeave(playerId, tableId, chairId, status)
  cclog("GameScene:onRoomUserLeave......playerId=%d..........tableId=%d...........chairId=%d.........................................................................",playerId, tableId, chairId);
  --有人离开
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
      if (self.cannon_manager_) then

          self.cannon_manager_:ResetFishScore(chairId);
          self.cannon_manager_:SetPlayer_Type(chairId,self.g_jieji_player_flag[i]);
          self.cannon_manager_:SetUserName(chairId, "");--显示昵称
          self.cannon_manager_:setVisible_(chairId,false);
          self.g_fish_score_[chairId]=0;
    end

  end
end
function GameScene:onRoomUserFree(playerId, tableId, chairId, status)
  cclog("GameScene:onRoomUserFree.....playerId=%d..........tableId=%d...........chairId=%d.........................................................................",playerId, tableId, chairId);
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
    if (self.cannon_manager_) then
          self.cannon_manager_:ResetFishScore(chairId);
          self.cannon_manager_:SetUserName(chairId, "");--显示昵称
          self.cannon_manager_:setVisible_(chairId,false);
          self.cannon_manager_:SetPlayer_Type(chairId,self.g_jieji_player_flag[i]);
          self.g_fish_score_[chairId]=0;
    end


  end
end
function GameScene:onRoomUserPlay(playerId, tableId, chairId, status)
  cclog("GameScene:onRoomUserPlay....playerId=%d..........tableId=%d...........chairId=%d..",playerId, tableId, chairId);
  --有人进来玩
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
    --我桌子上有人来玩
     cclog("GameScene:onRoomUserPlay....playerId=%d..........tableId=%d...........chairId=%d..11",playerId, tableId, chairId);
    local pd = global.g_mainPlayer:getRoomPlayer(playerId);
    if (self.cannon_manager_) then
          self.cannon_manager_:SetUserName(chairId, pd.name);--显示昵称
          self.cannon_manager_:setVisible_(chairId,true);
          self.cannon_manager_:SetPlayer_Type(chairId,self.g_jieji_player_flag[i]);
    end
     --[[
   local tableId = global.g_mainPlayer:getCurrentTableId();
  local tableUser = global.g_mainPlayer:getTableUser(tableId);
   for k, v in pairs(tableUser) do
      local pd = global.g_mainPlayer:getRoomPlayer(v);
      if (self.cannon_manager_) then
        local t_chair_id=pd.chairId;
          self.cannon_manager_:SetUserName(k, pd.name);--显示昵称
       end
    end
    --]]
  end
end

function GameScene:onEntebackGround(param)
--[[
  self.run_in_back_flag=1;
  self.g_back_Fore_Delay =5;
  self.g_fish_manager:FreeAllFish();
   self.g_bulletmanager:FreeAllBullet();
   self.g_Free_Bullet_Manager:FreeAllBullet();
   --]]
end
function GameScene:onEnterForeGround(param)
--[[
  self.run_in_back_flag=0;
  self.g_back_Fore_Delay =5;
  netmng.g_gs_sock:reset_recv_queue()
  netmng.g_gs_sock:reset_send_queue()
  --]]

end
function GameScene:onMessage(param)
  local str = param.message
  if true then --string.find(str,LocalLanguage:getLanguageString("L_ad113eb2b6ea0ab9")) then
     if(self.labletext and self.bsckome) then
        local function msg_end_callback()
           self.labletext:setVisible(false);
            self.bsckome:setVisible(false);
         end
         self.labletext:setVisible(true);
         self.bsckome:setVisible(true);
         self.labletext:setString(str);
         local t_delay=cc.DelayTime:create(5);
         local t_call_back=cc.CallFunc:create(msg_end_callback);
         local t_seq=cc.Sequence:create(t_delay,t_call_back,nil);
         self.bsckome:stopAllActions();
         self.bsckome:runAction(t_seq);
    end
  end
end
--场景消息
function GameScene:OnEventSceneMessage(gamestatus)
cclog("GameScene:OnEventSceneMessage场景消息.....\n");
 self:getMeChairID();
 local i=0;
 self.g_fish_score_={};
 self.g_coin_score_={};
 for i = 0, GAME_PLAYERCLIENT-1,1 do
     cclog("GameScene:OnEventSceneMessage场景消息....i=%d.\n",i);
    if ( self.cannon_manager_~=nil) then
        self.cannon_manager_:setVisible_(i,false);
        self.cannon_manager_:SetFishScore(i, gamestatus._fish_score[i]);
        self.g_fish_score_[i] = gamestatus._fish_score[i];
	    self.g_coin_score_[i] = gamestatus._coin_score[i];
   end
end
cclog("GameScene:OnEventSceneMessage场景消息....01.\n");
self.m_nFirst_bullet_multiple_ = gamestatus.nfirst_bullet_multiple;
self.current_bullet_mulriple_ = self.m_nFirst_bullet_multiple_;
  --初始化玩家信息
  local tableId = global.g_mainPlayer:getCurrentTableId();
  local tableUser = global.g_mainPlayer:getTableUser(tableId);
   for k, v in pairs(tableUser) do
      local pd = global.g_mainPlayer:getRoomPlayer(v);
      if (self.cannon_manager_) then
        local t_chair_id=pd.chairId;
          self.cannon_manager_:SetUserName(t_chair_id, pd.name);--显示昵称
          self.cannon_manager_:setVisible_(k,true);
       end
    end
   --gamestatus.scene_kind_=3;
   cclog("GameScene:OnEventSceneMessage场景消息.....  -gamestatus.scene_kind_=%d",-gamestatus.scene_kind_);
    if (self.m_pGameBack)then self.m_pGameBack:SetSwitchSceneStyle(gamestatus.scene_kind_);end
    --self.m_IsSwitchingScene = 1;

end

--配置
function GameScene:OnSubGameConfig(param)
  --cclog("GameScene:OnSubGameConfig(param).......................................");
  cc.exports.g_game_ui_type_= param.game_ui_type
  local t_my_chair_id=self.g_me_chair_id;--self:getMeChairID();
  self.exchange_count_= param.exchange_count;
  self.g_fish_score_rate= param.fish_score_rate_num;
  self.g_coin_score_rate= param.coin_score_rate_num;
  self.min_bullet_multiple_= param.min_bullet_multiple;
  self.max_bullet_multiple_= param.max_bullet_multiple;
  self.m_nFirst_bullet_multiple_= param.nfirst_bullet_multiple;
  self. current_bullet_mulriple_ =self.m_nFirst_bullet_multiple_;
  self.bomb_range_width= param.bomb_range_width;
  self.bomb_range_height= param.bomb_range_height;
  self.current_bullet_kind_=0;

  if (self.current_bullet_mulriple_ < 100)  then self.current_bullet_kind_ =0;
  elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then	 self.current_bullet_kind_ =1;
  elseif(self.current_bullet_mulriple_ >= 1000 and self.current_bullet_mulriple_ < 5000)then self.	current_bullet_kind_ =2;
  else 	 self.current_bullet_kind_ =  3;  end
  --self.m_speed_bt_state=0;
  --self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
  -- cclog("GameScene:OnSubGameConfig(param)...current_bullet_mulriple_=%d....current_bullet_kind_=%d................................",self. current_bullet_mulriple_ );
  if ( self.cannon_manager_) then
		 self.cannon_manager_:SetCannonMulriple(t_my_chair_id, self.current_bullet_mulriple_);
		 self.cannon_manager_:Switch(t_my_chair_id, self.current_bullet_kind_);
  end
    self.bomb_range_width_ ={};
   self.bomb_range_height_={};
   self.fish_multiple_={};
   self.fish_speed_={};
   self.fish_bounding_box_width_={};
   self.fish_bounding_box_height_={};
   self.fish_hit_radius_={};
   self.fish_speed_={};

	self.net_radius_={};
   self.bomb_range_width_ =param.bomb_range_width;
   self.bomb_range_height_=param.bomb_range_height;
  local i=0;
  for  i = 0, FISH_KIND_COUNT-1,1 do
   self.fish_multiple_[i]=param.fish_multiple[i]
   self.fish_speed_[i]=param.fish_speed[i];
   --self.fish_bounding_box_width_[i]=param.fish_bounding_box_width[i];
   --self.fish_bounding_box_height_[i]=param.fish_bounding_box_height[i];
   self.fish_hit_radius_[i]=param.fish_hit_radius[i];
   --self.fish_speed_[i]=param.fish_hit_radius[i];
  end
  self.fish_bounding_box_width_=cc.exports.game_fish_width;--param.fish_bounding_box_width[i];
  self.fish_bounding_box_height_=cc.exports.game_fish_height;--param.fish_bounding_box_height[i];
  for i = 0,BULLET_KIND_COUNT-1,1 do
    self.bullet_speed_=param.bullet_speed;
	self.net_radius_=param.net_radius ;
 end
   self.bullet_speed_={};
  self.bullet_speed_[0] =800;
  self.bullet_speed_[1] =800;
  self.bullet_speed_[2] =800;
  self.bullet_speed_[3] =800
  self.bullet_speed_[4] =1000;
  self.bullet_speed_[5] =1000;
  self.bullet_speed_[6] = 1000;
  self.bullet_speed_[7] = 1000;
   cc.exports.g_protion = 1 / param.fish_score_rate_num
  cc.exports.fish_multiple = param.fish_multiple --鱼的倍率定值鱼
  cc.exports.fish_width =self.fish_bounding_box_width_;
  cc.exports.fish_height =self.fish_bounding_box_height_;
  cc.exports.bullet_speed =self.bullet_speed_;
  if (self.cannon_manager_)  then
  self.cannon_manager_:Switch(t_my_chair_id, self.current_bullet_kind_);
  self. cannon_manager_:ShowMyConButton(t_my_chair_id);
   end

  --self:initSurface()
   self.allow_fire_ = true;

   self:startGuideCheck()
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
  local score = math.floor(self.g_fish_score_[chairId] / rate)

  if score > ITEM1_COST then
    self.m_auto_bt_state = 0;
    self.auto_bt:setString("1");
    if (self.auto_ring) then
      self.auto_ring:setVisible(false)
    end
    self:stopGuideCheck()

    PopUpView.showPopUpView(AuctionTipsView)
  end
end

function GameScene:stopGuideCheck()
  self.isNeedGuide_ = false
end

--生成
function GameScene:OnSubFishTrace(param)
--[[cclog("GameScene:OnSubFishTrace..run_in_back_flag=%d,g_back_Fore_Delay=%d,g_switch_Scene=%d",
self.run_in_back_flag,self.g_back_Fore_Delay,self.g_switch_Scene);]]
if(self.run_in_back_flag>0)then return ;end
 if( self.g_back_Fore_Delay>0) then return ;end
 if(self.g_switch_Scene>0) then return ; end--self.g_switch_Scene = 0;
if(self.g_fish_manager) then
 local fish_trace_count = #param; --数目
--  cclog("GameScene:OnSubFishTrace.. fish_trace_count=%d",fish_trace_count);
 if(fish_trace_count>=0) then
  for i = 0,fish_trace_count,1 do
            local  fish_trace =param[i];
            if(fish_trace) then
               -- cclog("GameScene:OnSubFishTrace...fish_kind=%d fish_trace_count=%d",fish_trace.fish_kind,fish_trace_count);
                 local start_pos=cc.p(fish_trace.init_pos[0].x,fish_trace.init_pos[0].y);
                 local t_Fish=self.g_fish_manager:ActiveFish(fish_trace.fish_kind, fish_trace.fish_id, self.fish_multiple_[fish_trace.fish_kind],
				                                                                 self.fish_speed_[fish_trace.fish_kind], self.fish_bounding_box_width_[fish_trace.fish_kind],
				                                                                 self.fish_bounding_box_height_[fish_trace.fish_kind], self.fish_hit_radius_[fish_trace.fish_kind], start_pos,0,0);
            if(t_Fish~=nil) then
               --cclog("GameScene:OnSubFishTrace..MovByList .fish_kind=%d fish_speed_=%f",fish_trace.fish_kind,self.fish_speed_[fish_trace.fish_kind]);
               t_Fish:MovByList(fish_trace.init_pos, fish_trace.init_count, self.fish_speed_[fish_trace.fish_kind] * 30, self.fish_speed_[fish_trace.fish_kind]*2);
               -- cclog("GameScene:OnSubFishTrace..MovByList .fish_kind=%d fish_speed_=%f aasdasds---------",fish_trace.fish_kind,self.fish_speed_[fish_trace.fish_kind]);
            end
          end
     end
   end
 end
 --]]
end
--兑分
function GameScene:OnSubExchangeFishScore(param)
        local exchange_fishscore=param;
        if(exchange_fishscore) then
           cclog("GameScene:OnSubExchangeFishScore..increase=%d,chair_id=%d,sw_fish_score=%d",exchange_fishscore.increase,exchange_fishscore.chair_id,exchange_fishscore.sw_fish_score);
            if (exchange_fishscore.increase>0) then
                self:add_fish_score_(exchange_fishscore.chair_id, exchange_fishscore.sw_fish_score);--上分数
	        else
                 self:sub_fish_score_(exchange_fishscore.chair_id, exchange_fishscore.sw_fish_score);--下分数
           end
	       self.g_coin_score_[exchange_fishscore.chair_id] = exchange_fishscore.l_coin_score;   --剩余金币数
        end
end
--发射子弹
function GameScene:OnSubUserFire(user_fire)
  -- self:sub_fish_score_(exchange_fishscore.chair_id, exchange_fishscore.sw_fish_score);
    local ifself=user_fire.from_server_flag;
    local me_switch_chair = user_fire.chair_id;
    local me_chair_id =self:getMeChairID();
    --local me_c_chair_id=self:getMeChairID();-- self:getMeChairID();
     -- cclog("GameScene:OnSubUserFire..ifself=%d_chair=%d(%d),bullet_mulriple=%d",ifself,me_switch_chair,me_chair_id,user_fire.bullet_mulriple);
     if(self.cannon_manager_:GetFishScore(me_switch_chair)<1)then return;  end--没分数直接返回
    --本桌
	if (me_switch_chair == me_chair_id)then self.current_bullet_self_count=0;
    	 if (ifself == 1)  then --从后期扣分
			if (user_fire.bullet_specKindFlag == 0) then
		    	--self.cannon_manager_:SubFishScore(me_switch_chair, user_fire.bullet_mulriple);--扣除本地账号分数
                self:sub_fish_score_(me_switch_chair, user_fire.bullet_mulriple);
            end
			return true;
		end
	end
     --   cclog("GameScene:OnSubUserFire( chair_id=%d, bullet_kind=%d)",me_switch_chair,user_fire.bullet_kind);
    --特殊子弹
    if (user_fire.bullet_specKindFlag > 0)then
		self.cannon_manager_:FireSpecBullet(me_switch_chair, user_fire.bullet_specKindFlag, user_fire.bullet_id, user_fire.lock_fishid);
		return true;
	end
    --if (self.m_speed_bt_state>0) then self.current_bullet_kind_ = self.current_bullet_kind_ %4+ 4; end
    self.cannon_manager_:Switch(me_switch_chair, user_fire.bullet_kind);
	self.cannon_manager_:Fire(me_switch_chair, user_fire.bullet_kind);
   -- cclog("GameScene:OnSubUserFire( chair_id=%d, bullet_kind=%d)..........................",me_switch_chair,user_fire.bullet_kind);
    --音效
    if (user_fire.bullet_specKindFlag==0) then  cc.exports.g_soundManager:PlayGameEffect("NormalFireSound");
	elseif (user_fire.bullet_specKindFlag == 1) then  cc.exports.g_soundManager:PlayGameEffect("SuperGunFireSound");
	elseif (user_fire.bullet_specKindFlag == 4) then  cc.exports.g_soundManager:PlayGameEffect("SuperGunFireSound");
	else  cc.exports.g_soundManager:PlayGameEffect("NormalFireSound"); end

    -- cclog("GameScene:OnSubUserFire( chair_id=%d, bullet_kind=%d)....................aa......",me_switch_chair,user_fire.bullet_kind);
    --锁定
    local angle = user_fire.angle;
	local lock_fish_id = user_fire.lock_fishid;
	if (lock_fish_id == -1)
	then
		lock_fish_id = self.lock_fish_manager_:GetLockFishID(user_fire.chair_id);
		if (lock_fish_id == 0) then  lock_fish_id = self.g_fish_manager:LockFish(); end
	end
    self.lock_fish_manager_:SetLockFishID(user_fire.chair_id, lock_fish_id);
    if (lock_fish_id > 0)then
		local fish =self.g_fish_manager:GetFish(lock_fish_id);
		if (fish == NULL) then
			self.lock_fish_manager_:SetLockFishID(user_fire.chair_id, 0);
		else
			if (user_fire.lock_fishid == -1 and lock_fish_id > 0)
			then
				local mouse_pos = self.lock_fish_manager_:LockPos(user_fire.chair_id);
				if (CanFire(user_fire.chair_id, mouse_pos)==false) then 	lock_fish_id = 0;
				else
					local cannon_pos = self.cannon_manager_:GetCannonPos(me_switch_chair,1);
					angle =self:CalcAngle(mouse_pos.x, mouse_pos.y, cannon_pos.x, cannon_pos.y);
				end
			end
		end
	end
    --发射子弹
    self.cannon_manager_:SetCurrentAngle(me_switch_chair, angle);
	if (user_fire.chair_id ~=self:getMeChairID()) then
			self.cannon_manager_:SetCannonMulriple(me_switch_chair, user_fire.bullet_mulriple);
			--self.cannon_manager_:SubFishScore(user_fire.chair_id, user_fire.fish_score);
            self:sub_fish_score_(user_fire.chair_id, user_fire.bullet_mulriple);
	  end
	 local cannon_pos = self.cannon_manager_:GetCannonPos(me_switch_chair,1);
     if(self.g_bulletmanager:GetBulletNum(me_switch_chair) < 25) then 
	     self.g_bulletmanager:Fire(
			cannon_pos.x,
			cannon_pos.y,
			angle,
			user_fire.bullet_kind,
			user_fire.bullet_id,
			user_fire.bullet_mulriple,
			user_fire.chair_id,
			self.bullet_speed_[user_fire.bullet_kind],
			self.net_radius_[user_fire.bullet_kind],
			lock_fish_id);
      end
     -- cclog("GameScene:OnSubUserFire( chair_id=%d, bullet_kind=%d).......................... end",me_switch_chair,user_fire.bullet_kind);
end
--捕获
function GameScene:OnSubCatchFish(catch_fish)
     --cclog("GameScene:OnSubCatchFish-------chair_id=%d,fish_id=%d,fish_kind=%d,bullet_kind=%d,bullet_ion=%d,bullet_mul=%d,fish_mul=%d,fish_score=%d",
--     catch_fish.chair_id ,
--     catch_fish.fish_id ,
--     catch_fish.fish_kind,
--     catch_fish.bullet_kind,
--     catch_fish.bullet_ion,
--     catch_fish.bullet_mul,
--     catch_fish.fish_mul,
--     catch_fish.fish_score)
     local me_switch_chair =catch_fish.chair_id;
     self:add_fish_score_(me_switch_chair, catch_fish.fish_score);
     --self.g_BingoManager:AddBingo(me_switch_chair,catch_fish.fish_score,0);
     --中奖效果
     if (catch_fish.fish_mul>25) then
			--BingoManager::GetInstance()AddBingo(me_switch_chair, catch_fish->fish_score);
            self.g_BingoManager:AddBingo(me_switch_chair,catch_fish.fish_score,0);
		elseif (catch_fish.fish_kind == 33)  then
        self.g_BingoManager:AddBingo(me_switch_chair,catch_fish.fish_score,0);
        end
         --  BingoManager::GetInstance()->AddBingo(me_switch_chair, catch_fish->fish_score); end
      if (catch_fish.bullet_kind ==8) then self.cannon_manager_:Add_FreeBulletCatch(me_switch_chair, catch_fish.fish_score); end
      if (self.g_fish_manager) then
			self.g_fish_manager:CatchFish(catch_fish.chair_id, catch_fish.fish_id, catch_fish.fish_score, catch_fish.bullet_mul, catch_fish.fish_mul,0);
		end

    self:checkGuide(catch_fish.chair_id)
end
--场景切换
function GameScene:OnSubSwitchScene(switch_scene)
  --cclog("GameScene:OnSubSwitchScene.....");
  self.m_pGameBack:SetSwitchSceneStyle(switch_scene.scene_kind%3);
  self.m_switchScene_buf=switch_scene;
   --
   -- local switch_scene=self.m_switchScene_buf;
    --cclog("GameScene:RunSceneSwitch_Trace scene_kind=%d,fish_count=%d",switch_scene.scene_kind,switch_scene.fish_count);
    --
  self.g_switch_Scene = 1;
  self.m_IsSwitchingScene = 1;
  self.g_switch_SceneTime = 70;
  self:AllowFire(false);
 self.m_switchScene_buf=switch_scene;
  for  i=0,8,1 do
		self:UnLock_fish(i);
 end
  self:EndMark_Scene();
  local i=0;



end

--场景结束
function GameScene:OnSubSceneEnd(param)
--cclog("GameScene:OnSubSceneEnd.....\n");
  --显示垃圾回收
    collectgarbage("collect");
end
--鱼阵
function GameScene:OnSubFishQueue(_fish_queue_)
    --cclog("GameScene:OnSubFishQueue.....\n");
    if(self.run_in_back_flag>0)then return ;end
     if( self.g_back_Fore_Delay>0) then return ;end
     if(self.g_switch_Scene>0) then return ; end--self.g_switch_Scene = 0;
    if(_fish_queue_.fish_num > 0) then
        local t_alive_delay= 0;
        local i=0;
        local init_pos={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
        --local init_y_pos={[0]=0};
        for i = 0, _fish_queue_.fish_num-1,1 do
            local start_pos=cc.p(0,0);
			local t_r_x = math.random(0,200) - 100;
			local t_r_y = math.random(0,200) - 100;
            local init_count= _fish_queue_.point_num;
            local j=0;
            for j=0,init_count,1 do
               local t_point = cc.Director:getInstance():convertToGL(cc.p(_fish_queue_.mov_List[j].x, _fish_queue_.mov_List[j].y));
               if (_fish_queue_.queue_kind == 0) then--混乱
					t_point.x =t_point.x + t_r_x;
					t_point.y = t_point.y+ t_r_y;
			    else  t_alive_delay = t_alive_delay+cc.exports.g_fish_queue_delay_ [_fish_queue_.fish_kind[i]];end--线性
             	init_pos[j].x = t_point.x;
				init_pos[j].y = t_point.y;
			end--for j
            start_pos.x = init_pos[0].x;
		    start_pos.y =init_pos[0].y;
            local t_fish_kind = _fish_queue_.fish_kind[i];
            if(t_fish_kind>0 and t_fish_kind<60) then
                local t_Fish=self.g_fish_manager:ActiveFish(t_fish_kind, _fish_queue_.fish_id[i], self.fish_multiple_[t_fish_kind],
				                                                                 self.fish_speed_[t_fish_kind], self.fish_bounding_box_width_[t_fish_kind],
				                                                                 self.fish_bounding_box_height_[t_fish_kind], self.fish_hit_radius_[t_fish_kind], start_pos,t_alive_delay,0);
                if(t_Fish~=nil) then
                    t_Fish:MovByList(init_pos,init_count, self.fish_speed_[t_fish_kind] * 30, self.fish_speed_[t_fish_kind]*2);
                end
            end
        end--for i
    end
    --cclog("GameScene:OnSubFishQueue..... end\n");
end

function GameScene:OnSubUpdateJiejiPlayer(jiejiplayer_data_)--
 -- cclog("  GameScene:OnSubUpdateJiejiPlayer..................................................");
for  i = 0, 7, 1 do
		self.g_jieji_player_flag[i] = jiejiplayer_data_.jieji_player_flag[i];
       if(self.cannon_manager_) then
           self.cannon_manager_:SetPlayer_Type(i,self.g_jieji_player_flag[i]);
       end

end
end

function GameScene:OnSubBroach_bulletCatch(catch_fish)--钻头炮
  -- cclog(" GameScene:OnSubBroach_bulletCatch(param) catch_fish.fish_mul=%d",catch_fish.fish_mul);
   local  me_switch_chair = catch_fish.chairID;
   local  t_bullet_id=catch_fish.bulletid;
   local  t_Broach_Bullet=self.g_Broach_Bullet_Manager:getChildByTag(t_bullet_id);
   if (catch_fish.if_bom>0) then --//引爆
      if (t_Broach_Bullet) then
           -- cclog(" GameScene:OnSubBroach_bulletCatch(param) -------1111--------------------------------------");
			t_Broach_Bullet:Bom(0);
			self.g_fish_manager:Broach_bullet_Bom(t_Broach_Bullet:GetPos(), Broach_Bullet.g_broach_width, me_switch_chair, catch_fish.fish_mul, catch_fish.bullet_mul, t_bullet_id, 1);
	 end
   else
      self.g_fish_manager:CatchFish(catch_fish.chairID, catch_fish.fish_id, catch_fish.fish_score, catch_fish.bullet_mul, catch_fish.fish_mul,1);
   end
   	if (catch_fish.fish_score > 0) then --//添加分数到穿甲弹UI
		if (self.cannon_manager_)	 then
			self:add_fish_score_(me_switch_chair, catch_fish.fish_score);
			self.cannon_manager_:AddBroach_Score(me_switch_chair, catch_fish.fish_score);
		end
	end
end
function GameScene:OnSubDianci_bulletCatch(catch_fish)--电磁炮
  --  cclog(" GameScene:OnSubDianci_bulletCatch(param) fish_score=%d,fish_mul=%d,bullet_mul=%d",catch_fish.fish_score,catch_fish.fish_mul, catch_fish.bullet_mul);
    local  me_switch_chair = catch_fish.chairID;
    local t_Dianci_Bullet_Manager = self.g_Dianci_Bullet_Manager:getChildByTag(catch_fish.bulletid);
    if (t_Dianci_Bullet_Manager) then
		self.g_fish_manager:DianciBom(t_Dianci_Bullet_Manager:GetPos(), t_Dianci_Bullet_Manager:get_dianci_HitR(), me_switch_chair, catch_fish.fish_mul, catch_fish.bullet_mul, catch_fish.bulletid, catch_fish.angle, 1);
	end
    if (catch_fish.fish_score > 0)then --//添加分数
		self.g_BingoManager:AddBingo(me_switch_chair, catch_fish.fish_score);
		self:add_fish_score_(me_switch_chair, catch_fish.fish_score);
	end
end
function GameScene:OnSubMissile_bulletCatch(catch_fish)--必杀弹
  --cclog(" GameScene:OnSubMissile_bulletCatch(param)--------------------------");
  local me_switch_chair = catch_fish.chair_id;
  local t_GuidedMissile = self.g_GuidedMissile_Bullet_Manager:getChildByTag(catch_fish.bulletID);
  if (t_GuidedMissile) then
		self.g_fish_manager:CatchFish(catch_fish.chair_id, catch_fish.fish_id, catch_fish.fish_score, catch_fish.bullet_mul, catch_fish.fish_mul,0);
		self.cannon_manager_:Exit_GuidedMissileBullet(me_switch_chair);
        self:add_fish_score_(me_switch_chair, catch_fish.fish_score);
		self.g_BingoManager:AddBingo(me_switch_chair, catch_fish.fish_score);
  end
end
function GameScene:OnSubMRY_FishCatch(catch_fish)--//捕获美人鱼
  --cclog(" GameScene:OnSubMRY_FishCatch(param)");
  local me_switch_chair = catch_fish.chair_id;
  if (me_switch_chair<8 and catch_fish._mulriple>0) then --//增加分数
     self:add_fish_score_(me_switch_chair, catch_fish._mulriple);
    self. cannon_manager_:Add_MRY_Score(me_switch_chair, catch_fish._mulriple);
  end
end
function GameScene:OnSubMRY_FishCatchEnd(catch_fish)-- //捕获美人鱼任务完成
   --cclog(" GameScene:OnSubMRY_FishCatchEnd(param)");
   local me_switch_chair = catch_fish.chair_id;
   self.cannon_manager_:Catch_MRY_End(me_switch_chair);
end
function GameScene:OnSubBaoxiangCatch(catch_fish)-- //获得宝箱
       --cclog(" GameScene:OnSubBaoxiangCatch(param)");
       local t_pos = cc.p(640, 360);
		--if (m_pFishGroup) then
			local t_fish = self.g_fish_manager:GetFish(catch_fish.fish_id);
			if (t_fish) then t_pos = t_fish:GetFishccpPos(); end
		--end
        self.cannon_manager_:Catch_Baoxiang(catch_fish.chair_id, catch_fish.catchnum, t_pos);
end
function GameScene:OnSubBaoxiangCatchEnd(catch_fish)--//宝箱任务完成
  -- cclog(" GameScene:OnSubBaoxiangCatchEnd(param)");
   self:add_fish_score_(catch_fish.chair_id, catch_fish.scorenum);
   self.cannon_manager_:Catch_BaoxiangEnd(catch_fish.chair_id, catch_fish.scorenum);

end
function GameScene:OnSubFreebulletEnd(catch_fish)--//免费子弹任务结束
 -- cclog(" GameScene:OnSubFreebulletEnd(param)");
  local me_switch_chair = catch_fish.chair_id;
  self.cannon_manager_:Exit_FreeBullet(me_switch_chair);

end
--震屏
function GameScene:ShakeScreen(param)
   if (self.m_pGameBack) then self.m_pGameBack:ShakeScreen(); end
end

function GameScene:OnSubHongbaoInfo(user_s_red_envelope)
   -- cclog(" GameScene:OnSubHongbaoInfo(param).....");
	local m_red_envelope_hour = user_s_red_envelope.nextTime_h; --//小时
	local m_red_envelope_min = user_s_red_envelope.nextTime_m; --//分
	local m_red_envelope_sec = user_s_red_envelope.nextTime_s; --//小时
	local m_red_envelope_num = user_s_red_envelope.nextTime_l; --//剩余数量
    if(self.g_hongbao_ttf==nil) then

      --self.labletext = cc.Label:createWithTTF("adadad", "main/res/fonts/FZY4JW.ttf", 25)
     -- self.labletext:setPosition(cc.p(winwidth/2,winheight/2))
     -- self:addChild(self.labletext,100)
       self.g_hongbao_ttf = cc.Label:createWithTTF(" ", "fullmain/res/fonts/FZY4JW.ttf", 40)
       if (self.g_hongbao_ttf) then
            local twinsize = cc.Director:getInstance():getWinSize()
			self.g_hongbao_ttf:setPosition(cc.p(twinsize.width / 2, twinsize.height / 2));
			self.g_hongbao_ttf:setColor(cc.c3b(255,0,0))
			 self:addChild(self.g_hongbao_ttf, 99999);
		end
    end
    if (self.g_hongbao_ttf) then
        local strd="";
        if(m_red_envelope_num>0) then
           strd=string.format(LocalLanguage:getLanguageString("L_d41ffaca062b0f53"), m_red_envelope_hour, m_red_envelope_min, m_red_envelope_sec, m_red_envelope_num);
         else
            strd=string.format(LocalLanguage:getLanguageString("L_68a6e8429e0aad20"), m_red_envelope_hour, m_red_envelope_min, m_red_envelope_sec);
        end
        -- cclog(" GameScene:OnSubHongbaoInfo(param)..strd=%s",strd);
       self.g_hongbao_ttf:setString(strd);
       self.g_hongbao_ttf:stopAllActions();
       local t_delay=cc.DelayTime:create(3);
       local t_fadeout=cc.FadeOut:create(0.2);
       local t_seq=cc.Sequence:create(t_delay,t_fadeout);
       self.g_hongbao_ttf:runAction(t_seq);
  end
end



function GameScene:OnSubHongbaoCatch(user_s_red_envelope_give)
   --cclog(" GameScene:OnSubHongbaoCatch(param).....");
    --self.m_red_envelope_Manager
    local chairID = user_s_red_envelope_give.chairID;
    if (chairID >= 0 and chairID < GAME_PLAYER)	then
		local fishID = user_s_red_envelope_give.FishID;
		local cannon_pos = self.cannon_manager_:GetCannonPos(chairID,0);
		local fish_pos =self.g_fish_manager:GetFish(fishID):GetFish_NodePos();
    --[[
        cclog("cannon_pos(%f,%f)",cannon_pos.x,cannon_pos.y);
        cclog("fish_pos(%f,%f)",fish_pos.x,fish_pos.y);
        cclog("chairID=%d",chairID);
        cclog("_score=%d",user_s_red_envelope_give.score);]]
                                      --function add(fish_pos, cannon_pos, chair_id, score)
		self.m_red_envelope_Manager:add(fish_pos, cannon_pos, chairID, user_s_red_envelope_give.score);
	end
end



-- function GameScene:onExit()
--     -- self:removeMsgHandler();
-- end
--endregion
-------------------------------------------------------ui事件响应----------------------------------------------------------------------------------------------
--region
--倍率表显示
function GameScene:show_rate(flag_num)
    self.g_ShowRateFlag=flag_num;
     if(flag_num>0) then
          if(self.g_rate_show_spr==nil) then
               local  c_winSize=cc.Director:getInstance():getWinSize();
               self.g_rate_show_spr=cc.Sprite:create("haiwang/res/HW/rate.png");
               if(self.g_rate_show_spr~=nil)  then
                  self.g_rate_show_spr:setPosition(cc.p(c_winSize.width / 2, c_winSize.height/2));
                  self.g_rate_show_spr:setScale(0.9);
                  self:addChild(self.g_rate_show_spr,1999);
              end
           end
      else
     if(self.g_rate_show_spr~=nil)  then
      self.g_rate_show_spr:removeFromParentAndCleanup();
      self.g_rate_show_spr=nil;
      end
   end
end
function   GameScene:GetFish_Mul( kindNum) return  self.fish_multiple_[kindNum]; end
function  GameScene:GetSwitchSceneState()   return self.g_switch_Scene; end
--声音设置
function GameScene:ShowSoundSetting()
       if (self.m_soundsetting_node== nil) then
          local win_size=cc.Director:getInstance():getWinSize();
          self.m_soundsetting_node=cc.Node:create();
          self.m_soundsetting_node:setPosition(cc.p(win_size.width/2,win_size.height/2));
          self:addChild(self.m_soundsetting_node,99999)
          local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_setting.json")
	      self.m_soundsetting_node:addChild(root)
           local function onClose(sender, eventType)
           keyF4Pressed = false
              global.g_mainPlayer:setEffectVolume(self.effectVolume_);
	          global.g_mainPlayer:setMusicVolume(self.musicVolume_);
	         self.m_soundsetting_node:removeFromParent();
             self.m_soundsetting_node=nil;
           end
	      local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	      btnClose:addTouchEventListener(onClose);
          function onEffectVolume(sender, eventType)
	            self.effectVolume_ = self.sliderEffect_:getPercent() / 100
	            AudioEngine.setEffectsVolume(self.effectVolume_)
          end

          function onSoundVolume(sender, eventType)
	           self.musicVolume_ = self.sliderSound_:getPercent() / 100
	            AudioEngine.setMusicVolume(self.musicVolume_)
          end
	      self.sliderEffect_ = ccui.Helper:seekWidgetByName(root, "Slider_3")
	      self.sliderEffect_:addEventListener(onEffectVolume)

	       self.sliderSound_ = ccui.Helper:seekWidgetByName(root, "Slider_4")
	       self.sliderSound_:addEventListener(onSoundVolume)


	       local volumeMusic = global.g_mainPlayer:getMusicVolume()
	       self.sliderSound_:setPercent(volumeMusic * 100)
	       self.musicVolume_ = volumeMusic

	       local volumeEffect = global.g_mainPlayer:getEffectVolume()
	       self.sliderEffect_:setPercent(volumeEffect * 100)
	       self.effectVolume_ = volumeEffect

           local function onEffectVolumeSub(sender, eventType)
               if eventType == ccui.TouchEventType.began then
	              self.effectVolume_ = math.max(0, self.effectVolume_ - 0.1)
	              self.sliderEffect_:setPercent(self.effectVolume_ * 100)
	              AudioEngine.setEffectsVolume(self.effectVolume_)
               end
           end
           function onEffectVolumeAdd(sender, eventType)
              if eventType == ccui.TouchEventType.began then
	              self.effectVolume_ = math.min(1, self.effectVolume_ + 0.1)
	              self.sliderEffect_:setPercent(self.effectVolume_ * 100)
	              AudioEngine.setEffectsVolume(self.effectVolume_)
              end
          end
          function onMusicVolumeSub(sender, eventType)
                if eventType == ccui.TouchEventType.began then
	               self.musicVolume_ = math.max(0, self.musicVolume_ - 0.1)
	               self.sliderSound_:setPercent(self.musicVolume_ * 100)
	               AudioEngine.setMusicVolume(self.musicVolume_)
                end
          end

          function onMusicVolumeAdd(sender, eventType)
             if eventType == ccui.TouchEventType.began then
	               self.musicVolume_ = math.min(1, self.musicVolume_ + 0.1)
	               self.sliderSound_:setPercent(self.musicVolume_ * 100)
	                AudioEngine.setMusicVolume(self.musicVolume_)
             end
           end
           local btnEffectSub = ccui.Helper:seekWidgetByName(root, "Button_6")
	       btnEffectSub:addTouchEventListener(onEffectVolumeSub);

	       local btnEffectAdd = ccui.Helper:seekWidgetByName(root, "Button_7")
	       btnEffectAdd:addTouchEventListener(onEffectVolumeAdd)

	       local btnMusicSub = ccui.Helper:seekWidgetByName(root, "Button_8")
	       btnMusicSub:addTouchEventListener(onMusicVolumeSub)

	        local btnMusicAdd = ccui.Helper:seekWidgetByName(root, "Button_9")
	        btnMusicAdd:addTouchEventListener(onMusicVolumeAdd)
       end
end



--endregion

--触摸函数
function GameScene:touchFunc_()
--触摸层
  self.layer  =  cc.LayerColor:create(cc.c4f(0,0,0,0))
  self:addChild(self.layer,3)
  local function onTouchBegin(pTouch,event)
     --cclog(" onTouchBegin(touch,event) \n");
     self.m_game_touch_flag = 1;
	 self.m_touch_begin_flag = 1;
     self.m_MRY_Fire_timer=1;
     self.isKeyShoot = false
    -- self.last_touch_pos_ = touch:getLocation()
	 self.m_game_touch_pos = pTouch:getLocationInView();
     if(self.m_show_rate_flag>0) then
         self.m_show_rate_flag=0;
          self:show_rate(0);
     end
   return true
  end
  local function onTouchMoved(pTouch,event)
     --cclog(" onTouchMoved(touch,event) \n");
     self.m_game_touch_flag = 1;
     self.isKeyShoot = false
	 self.m_game_touch_pos = pTouch:getLocationInView();
  end
  local function onTouchEnd( pTouch,event )
     -- cclog(" onTouchEnd(touch,event) \n");
      self.m_game_touch_flag = 0;
      self.isKeyShoot = false
	  self.m_game_touch_pos = pTouch:getLocationInView();
  end
   local  listener  =  cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(onTouchBegin,cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
  listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
  self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self.layer)
end
------------------------------------------------------退出---------------------------------------------------------------------------------------------------------

------------物理引擎监听
function GameScene:onContactBegin(contact)

  --cclog("GameScene:onContactBegin...");
  --[[
   if(self.m_show_rate_flag>0) then
           self.m_show_rate_flag=0;
           self:show_rate(0);
           return;
   end
   --]]
  if(self.g_switch_Scene>0) then return ; end--self.g_switch_Scene = 0;
  local bodyA = contact:getShapeA():getBody();
  local bodyB = contact:getShapeB():getBody();
  --self:onContactSolve(bodyA, bodyB)
  local groupA = bodyA:getGroup();
  local groupB = bodyB:getGroup();
  --
  local bullet = nil;
  local fish = nil;
  local bullet_hit_node=nil;
  local fish_body_node_=nil;
  if groupA<0 then
    bullet_hit_node = bodyA:getNode()
    if(groupB>0) then fish_body_node_ = bodyB:getNode() end
  elseif groupB <0 then
    if(groupA>0) then fish_body_node_ = bodyA:getNode() end
    bullet_hit_node = bodyB:getNode()
  end
  
  if(fish_body_node_==nil) or (bullet_hit_node==nil) then return false;end

  ---100
  --[[
  local tag= fish_body_node_:getTag();
  cclog("GameScene:onContactBegin  fish_body_node_  is tag=%d",tag);
   if(tag==99999) then
       cclog("GameScene:onContactBegin  fish_body_node_  is edge");
        return false
   end
   --]]

  fish=fish_body_node_:getParent():getParent();
  bullet=bullet_hit_node:getParent();
  if(bullet and fish) then   bullet:catch_fish_(fish); end

  return false
end

function GameScene:onGameServerConnectLost()
  --actor = false
  --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
  print("掉线")
  self.allow_fire_=false;
  self:unscheduleUpdate()
end


return GameScene;
--endregion

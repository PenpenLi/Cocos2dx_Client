--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/4
--此文件由[BabeLua]插件自动生成
GameScene = class("GameScene", LayerBase)

function GameScene:ctor() 
  GameScene.super.ctor(self)

  print("GameScene:ctor.....\n");
  local winSize = cc.Director:getInstance():getWinSize();
  cc.exports.GAME_UIORDER_=20;
  self:Init();
  --local t_sound_Node=soundManager.new();
  -- self:addChild(t_sound_Node);
  self.g_soundManager=soundManager.new();
  self:addChild(self.g_soundManager,0);
  self:LoadGame();
end

function  GameScene:Init()
  cc.exports.game_manager_=self;
  self.g_Key_Lock_Flag=0;
  self.show_right_bt=1;
  self.show_menu_delay=0;
  self.g_cj_Node=nil;
  self.g_sound_setting_delay=0;
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
  self.effectVolume_=100;
  self.musicVolume_=100;
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
  self.g_CoinManager=nil;
  self.g_ShowRateFlag=0;--       //显示倍率
  self.g_init_ok_flag=0;--
  self.g_rateShowTimer=8;--
 -- self.m_ion_lock=0;--
  self.m_game_touch_flag=0;--
  self.m_touch_begin_flag=0;--
  self.m_fire_timer=0;--
  self.g_rate_show_spr=nil;--
  self.m_ui_main_root=nil;--
  --self.m_speed_bt_state=0;--    //极速按键状态
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
  self.g_fish_score_={[0]=0,0};       --玩家鱼币
  self.g_coin_score_={[0]=0,0};  --玩家金币
  self.g_jieji_player_flag={[0]=0,0,0,0};  --街机标记
  self.m_game_touch_pos=cc.p(0,0);
  self.m_game_touch_flag =0;
  self.m_touch_begin_flag =0;
  self.auto_lock_timer=0;
  self.m_switchScene_buf={};
  self.m_ion_lock={[0]=0,0,0,0,0,0,0,0,0};
  self.m_Ion_bullet_flag={[0]=0,0,0,0,0,0,0,0,0};
  self.m_right_menu_pos={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
  self.m_right_menu_bt_list={};
  --回收无用内存
  collectgarbage("collect");
  collectgarbage("collect");
end


function GameScene:LoadGame() --实现资源载入
	local t_game_start=game_start_qj_animal.new();
	self:addChild(t_game_start);

end

function  GameScene:StartGame() --启动游戏

 local ccwinsize=cc.Director:getInstance():getWinSize();
 --消息背景
  self.bsckome = cc.Sprite:create("qj_animal/res/bacckds.png");
  self.bsckome:setPosition(cc.p(ccwinsize.width/2,ccwinsize.height/2));
  self:addChild(self.bsckome,90);
  self.bsckome:setOpacity(100);
  self.bsckome:setScaleX(1280/90);
  -- self.bsckome:setScaleY(34/90);
  self.bsckome:setVisible(false);
  
  --字体
  self.labletext = cc.Label:createWithTTF("", "fullmain/res/fonts/FZY4JW.ttf", 25, cc.size(900, 0))
  if(self.labletext) then 
    self.labletext:setPosition(cc.p(ccwinsize.width/2,ccwinsize.height/2))
    self:addChild(self.labletext,100) 
    self.labletext:setVisible(false)          
  end

  --鱼的特效层
  cc.exports.fishlayer = cc.Layer:create()
  self:addChild(cc.exports.fishlayer,1)
 
  --背景
  self.m_pGameBack=CGameBack.new(self);
  self:addChild(self.m_pGameBack,-1);
  --金币
  self.g_CoinManager=CoinManager.new();
  self:addChild(self.g_CoinManager,GAME_UIORDER_-4);
  --鱼管理节点
  self.g_fish_manager=gamefishmanager.new(self);
  self:addChild(self.g_fish_manager,3);
  self.m_pFishGroup=self.g_fish_manager;
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
  
  --子弹管理
  self.g_bulletmanager=bulletmanager.new();
  self:addChild(self.g_bulletmanager,GAME_UIORDER_-5);
  --粒子
  self.g_My_Particle_manager=My_Particle_manager.new();
  self:addChild(self.g_My_Particle_manager,GAME_UIORDER_-1);

  --载入游戏按键
  self:Load_TouchUI();
  self:touchFunc_(); --初始化触摸层
  self:enableNodeEvents(true) 
  -- self:initMsgHandler();
  --初始化返回键
  self:initBackKey()
  self:getMeChairID();

  --碰撞引擎
  local contactListener = cc.EventListenerPhysicsContact:create()
  contactListener:registerScriptHandler(handler(self, self.onContactBegin) , cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
  --contactListener:registerScriptHandler(handler(self, self.onContactPreSolve) , cc.Handler.EVENT_PHYSICS_CONTACT_PRESOLVE)
  --
  local eventDispatcher = self:getEventDispatcher()
  eventDispatcher:addEventListenerWithSceneGraphPriority(contactListener, self)
 
  --  cc.Director:getInstance():getRunningScene():getPhysicsWorld():setDebugDrawMask(debug and cc.PhysicsWorld.DEBUGDRAW_ALL or cc.PhysicsWorld.DEBUGDRAW_NONE)

  local function handler(interval)
         self:update(interval);
   end
  self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
  self.bullet_speed_={};
  self.bullet_speed_[0] =900;
  self.bullet_speed_[1] =900;
  self.bullet_speed_[2] =900;
  self.bullet_speed_[3] =900
  self.bullet_speed_[4] =1100;
  self.bullet_speed_[5] =1100;
  self.bullet_speed_[6] = 1100;
  self.bullet_speed_[7] = 1100;
  gamesvr.sendUserReady();
  gamesvr.sendLoadFinish();
  self:UpdateCJNum(200);
 -- self.m_pGameBack:SetSwitchSceneStyle(1);--math.random(0,2));
end

function  GameScene:add_fish_score_(chairID,  c_scorenum)--设置玩家鱼币
     cclog("GameScene:add_fish_score_( chairID=%f,  c_scorenum=%d )self.g_fish_score_[chairID]=%d",chairID,c_scorenum,self.g_fish_score_[chairID]);
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
function GameScene:Lock_fish( local_chair_id)                                           --锁定
         cclog("GameScene:Lock_fish( local_chair_id=%d) ",local_chair_id);
        local  last_lock_fish_kind= self.lock_fish_manager_:GetLockFishKind(local_chair_id);
        local  last_lock_fish_id= self.lock_fish_manager_:GetLockFishID(local_chair_id)
        local lock_fish_id=self.g_fish_manager:LockFish(last_lock_fish_id,last_lock_fish_kind);
       self.lock_fish_manager_:SetLockFishID(local_chair_id, lock_fish_id);
       self.g_Key_Lock_Flag = 1;
       self.g_LockShootstate = 1;
end
--发射更新
 function GameScene:Input_KeyUpdate(dt)
     if(self.show_menu_delay>0) then 
        self.show_menu_delay=self.show_menu_delay-dt;
     end
     if(self.g_sound_setting_delay>0) then 
        self.g_sound_setting_delay=self.g_sound_setting_delay-dt;
     end
     if( self.g_back_Fore_Delay>0) then --后台返回延迟 避免卡鱼
         self.g_back_Fore_Delay= self.g_back_Fore_Delay-dt; 
     end
     --发射延迟
     self.m_fire_timer= self.m_fire_timer+dt;
     if (self.m_game_touch_flag>0 or self.m_auto_bt_state>0)then 
         if(self.g_ShowRateFlag==0) then   self:TouchShoot(self.m_game_touch_pos); end    
     end  
     if(self.m_lock_bt_state>0)    then
        self.auto_lock_timer=self.auto_lock_timer+dt;
         if(self.auto_lock_timer>0.5) then --每0.5秒检测一次锁定
            self.auto_lock_timer=0;
            local t_mechair_id = self:getMeChairID();
            local t_locak_fish_id=self.lock_fish_manager_:GetLockFishID(t_mechair_id);--检测锁定状态
            if (t_locak_fish_id <1) then   self:Lock_fish(t_mechair_id);   
             else 
                local fish=self.g_fish_manager:GetFish(t_locak_fish_id);
                if(fish==nil) then self:Lock_fish(t_mechair_id);   
                elseif(fish:CheckValidForLock()==false)  then self:Lock_fish(t_mechair_id);    end
             end
          end
     end
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
-- 发射
function GameScene:TouchShoot(touch_pos)
      if(self.run_in_back_flag>0)then return ; end
      if(self.g_back_Fore_Delay>0) then return; end;
      local tpt=touch_pos;     
      local t_Fire_Speed =self.m_PlayerFireSpeed /1000.0;
	  --if (self.m_speed_bt_state>0) then t_Fire_Speed = t_Fire_Speed*0.7;end
      if (self.m_fire_timer>t_Fire_Speed) then
			local tpt =cc.Director:getInstance():convertToGL(tpt) ;--     CCDirector::sharedDirector()->convertToGL(tpt);
			local  me_chair_id = self:getMeChairID();	
			if (self.allow_fire_==true) then 	
			    if (self.g_Key_Lock_Flag>0) then 
				    local  t_lock_fish_id = self.lock_fish_manager_:GetLockFishID(me_chair_id);
			    	if (self.m_touch_begin_flag>0) then 
					    self.m_touch_begin_flag = 0;
					    local  t_Fish = self.g_fish_manager:Touch_FishByPosition(tpt.x, tpt.y, 0);
					    if (t_Fish and t_lock_fish_id ~= t_Fish:fish_id()) then 
						    t_lock_fish_id = t_Fish:fish_id();
						    if (t_lock_fish_id > 0) then 
							    local t_ccp_pos=t_Fish:GetCurPos();
							    self.lock_fish_manager_:SetLockFishID(me_chair_id, t_lock_fish_id);
						     end --t_lock_fish_id>0
					    end --~= t_Fish:fish_id()
				     end --m_touch_begin_flag>0
			    end  -- if (self.g_Key_Lock_Flag>0)
			    local  mouse_pos=tpt;--cc.p(0, 0);
          local lf = self.lock_fish_manager_:GetLockFishID(me_chair_id) or 0
			    if (lf >0) then mouse_pos = self.lock_fish_manager_:LockPos(me_chair_id);end		
				local cannon_pos = self.cannon_manager_:GetCannonPos(me_chair_id,0);			
			    local can_fire = self:CanFire(me_chair_id, mouse_pos);
			    if (can_fire==true) then 
				    local  angle = self:CalcAngle(mouse_pos.x, mouse_pos.y, cannon_pos.x, cannon_pos.y);
					self.cannon_manager_:SetCurrentAngle(me_chair_id, angle);
                    self.current_bullet_kind_ =self.cannon_manager_:GetCurrentBulletKind(me_chair_id);
					local  me_fish_score =self.cannon_manager_:GetFishScore(me_chair_id);
					if (me_fish_score > 0  and self.current_bullet_mulriple_ > me_fish_score) then 
						self.current_bullet_mulriple_ = me_fish_score;                       					
						if (self.m_speed_bt_state>0) then self. current_bullet_kind_ = self.current_bullet_kind_ % 4 + 4; end
						self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
						self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);
                        
					end
					if (self.current_bullet_mulriple_ < self.min_bullet_multiple_ or self.current_bullet_mulriple_ > self.max_bullet_multiple_) then 
						self.current_bullet_mulriple_ = self.min_bullet_multiple_;
						self.current_bullet_kind_ = self.current_bullet_kind_%4;
						--if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
						self.cannon_manager_:Switch(me_chair_id, current_bullet_kind_);
						self.cannon_manager_:SetCannonMulriple(me_chair_id, current_bullet_mulriple_);
					end
					if (me_fish_score>=self.current_bullet_mulriple_) then 
						--if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
                        self.m_fire_timer = 0;
						self:SendUserFire(self.current_bullet_kind_, angle,self.current_bullet_mulriple_, self.lock_fish_manager_:GetLockFishID(me_chair_id));--self.lock_fish_manager_:GetLockFishID(me_chair_id));
						
					end
				end-- if (can_fire==true) then 
			end --self.m_fire_timer>t_Fire_Speed
	end -- if (self.m_fire_timer>t_Fire_Speed) then
 end

 function  GameScene:AutoExitUpdate(dt)     --空闲离开更新
       self.m_dle_timer= self.m_dle_timer+dt;
		if (self.m_dle_timer > 60)
		then
			local t_winsize = cc.Director:getInstance():getWinSize();
			if (self.m_dle_exit_spr_bg == nil)
			then
				self.m_dle_exit_spr_bg = cc.Sprite:create("qj_animal/res/game_res/ExitTimeTip.png");
				if (self.m_dle_exit_spr_bg)
				then
					self:addChild(self.m_dle_exit_spr_bg, 1000);		
					self.m_dle_exit_spr_bg:setPosition(cc.p(t_winsize.width / 2, t_winsize.height / 2));			
					self.m_LeftNum_timer =cc.LabelAtlas:_create("30","qj_animal/res/game_res/GuidedMissileNum.png", 35, 44, 47);
					self.m_dle_exit_spr_bg:addChild(self.m_LeftNum_timer, 11);
					self.m_LeftNum_timer:setAnchorPoint(cc.p(0.5, 0.5));
					self.m_LeftNum_timer:setPosition(cc.p(665,22));
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
 function GameScene:UnLock_fish(local_chair_id)
     cclog("GameScene:UnLock_fish( local_chair_id=%d) ",local_chair_id);
    self.lock_fish_manager_:ClearLockTrace(local_chair_id);
	self.g_LockShootstate = 0;
	self.g_Key_Lock_Flag = 0;
end
 function GameScene:CloseGameClient()
     cclog("GameScene:CloseGameClient");
     exit_qj_animal(); 
 end

 function GameScene:ResetDleTimer()
	self.m_dle_timer = 0;
	if (self.m_dle_exit_spr_bg)then
		self.m_dle_exit_spr_bg:removeAllChildren();
		self:removeChild(self.m_dle_exit_spr_bg);
    end
	self.m_dle_exit_spr_bg = nil;
	self.m_LeftNum_timer = nil;
end

 function  GameScene:SendCatchFish( fish_id,  firer_chair_id,  bullet_id,  bullet_kind,  bullet_mulriple,  nParam)
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
 end

  function GameScene:SendUserFire(bullet_kind,angle,bullet_mulriple,lock_fishid)
     --cclog("GameScene:SendUserFire 00 bullet_kind=%d",bullet_kind);
    if(self.m_soundsetting_node~=nil) then return false; end
    if (self.m_IsSwitchingScene>0) then return  false;  end--正在切换场景
    if(self.g_switch_Scene>0) then return ; end--self.g_switch_Scene = 0;	
    -- cclog("GameScene:SendUserFire 00aa");
    if (self.g_back_Fore_Delay > 0.000001) then return false ; end--从后台返回
     --cclog("GameScene:SendUserFire 00bb");
    if (self.cannon_manager_ == nil) then return false; end
     --cclog("GameScene:SendUserFire 00cc");
    local me_chair_id =self:getMeChairID();
     --cclog("GameScene:SendUserFire 00dd");
    if(me_chair_id < GAME_PLAYER
		and self.g_bulletmanager:GetBulletNum(me_chair_id) < 25
		--and self.m_ion_lock[me_chair_id] <= 0
		) then 
        -- cclog("GameScene:SendUserFire 01");
          self:ResetDleTimer();
      	local t_spec_kind_num =0;
        if (bullet_mulriple < 1) then return ;end
		local  tem_GetCount = 0;	
		local  tem_bulletStartNum = me_chair_id * 10000;
		if (self.current_bullet_id_ < tem_bulletStartNum)then self.current_bullet_id_ = tem_bulletStartNum; end
		self.current_bullet_id_=self.current_bullet_id_+1;
		if (self.current_bullet_id_ > (tem_bulletStartNum + 9998)) then self.current_bullet_id_ = tem_bulletStartNum; end
        --int t_spec_kind_num = cannon_manager_->Getspec_KindNum(me_chair_id);	 
        local bullet_kind_ =bullet_kind;  
        -- cclog("GameScene:SendUserFire 02");
        local buff = sendBuff:new();
	    buff:setMainCmd(pt.MDM_GF_GAME);
    	buff:setSubCmd(pt.SUB_C_USER_FIRE);
	    buff:writeInt(bullet_kind);
	    buff:writeFloat(angle);
        buff:writeInt(me_chair_id);
	    buff:writeInt(bullet_mulriple);
	    buff:writeInt(lock_fishid);
	    buff:writeInt(self.current_bullet_id_);
        buff:writeInt(t_spec_kind_num);
	    netmng.sendGsData(buff)
        --]]
        -- cclog("GameScene:SendUserFire 03");
       local param = {}
       param.from_server_flag=0;
       param.chair_id=me_chair_id;
	   param.bullet_kind=bullet_kind_ ;
       param.bullet_id=self.current_bullet_id_ ;
       param.bullet_specKindFlag= t_spec_kind_num  ;
       param.chair_id=me_chair_id;
       param.android_chairid=me_chair_id;
       param.angle=angle;
       param.bullet_mulriple=bullet_mulriple;
       param.lock_fishid=lock_fishid;
       param.fish_score= -bullet_mulriple;
       self.current_bullet_self_count=self.current_bullet_self_count+1;
       self:OnSubUserFire(param);
        --cclog("GameScene:SendUserFire 04");
     end
 end
 function  GameScene:update(delta)
        if(self.g_back_Fore_Delay>-0.000001) then self.g_back_Fore_Delay=self.g_back_Fore_Delay-delta; end
         self:Input_KeyUpdate(delta);
         self:AutoExitUpdate(delta)         
 end

function GameScene:AllowFire(allow)
    self.allow_fire_ = allow;
end
function GameScene:EndSceneTra()--场景切换完成
  --显示垃圾回收
    collectgarbage("collect");
    collectgarbage("collect");
    cclog("GameScene:EndSceneTra.........");
	self.m_IsSwitchingScene = 0;
    self.m_change_sceneLogoFlag = 0;
    self.allow_fire_ = true;
	--cc.exports.g_soundManager:PlayBackMusic();
    if (self.g_switch_Scene>0)then	
        self.g_switch_Scene = 0;
        if(self.g_fish_manager) then  self.g_fish_manager:FreeAllFish();   end
        if(self.g_bulletmanager) then self.g_bulletmanager:FreeAllBullet(); end
        if(self.lock_fish_manager_) then  self.lock_fish_manager_:ClearLockTrace(self:getMeChairID()); end
        if(self.g_CoinManager) then  self.g_CoinManager:removeAllChildren(); end
        if(fishlayer) then fishlayer:removeAllChildren();  end;
		self:AllowFire(true);
        local i=0;
		for i = 0, 4,1 do
			self:UnLock_fish(i);
		end 
			
        local function coolect_call_back_()
            cclog("GameScene:EndSceneTra......coolect_call_back_...");
           collectgarbage("collect");
        end
        local t_delay=cc.DelayTime:create(70);
        local t_call_back_=cc.CallFunc:create(coolect_call_back_);
        local t_seq_=cc.Sequence:create(t_delay,t_call_back_,nil);
        self:runAction(t_seq_);
        self:RunSceneSwitch_Trace();
    end
end

function GameScene:BuildSceneKindQZ(c_scene_style_)
	 --cclog("GameManager::BuildSceneKindQZ(SceneStyle c_scene_style_=%d)\n ", c_scene_style_);
	if (self.m_pGameBack~=nil) then 
		local switch_scene =  self.m_switchScene_buf;
		local t_index = 0;	
		local t_map_count_num = 0;
        local t_map_list={};
        local t_map_index = c_scene_style_% 3;
		if (t_map_index == 0) then t_map_list = g_map0;
        elseif (t_map_index == 1) then t_map_list = g_map1;
		else 	                       t_map_list = g_map2;  	
        end
		t_map_count_num =#t_map_list;
       -- cclog("GameManager::BuildSceneKindQZ(SceneStyle c_scene_style_=%d)t_map_count_num=%d  fish_count=%d\n ", 
       -- c_scene_style_,t_map_count_num, switch_scene.fish_count);
		if (t_map_count_num < 1) then return; end
		local  t_dir_num =0; --math.random(0,2);	
        local t_rand_dir =0;-- math.random(0,2);	
        if (t_map_index == 0) then 
             t_dir_num =1; --math.random(0,2);	
             t_rand_dir =1;-- math.random(0,2);	
        end
		if (t_map_count_num > switch_scene.fish_count) then t_map_count_num = switch_scene.fish_count; end
        local i=0;
		for i = 1,t_map_count_num,1 do
		    if (t_index < switch_scene.fish_count) then 
                local t_fish_mov_list={};--//移动点列表
                local t_Fish_mov_pointNum = 0;--//移动点数量               	
				local end_pos=cc.p(0,0);
				local end_pos1=cc.p(0,0);
				local start_pos = cc.p(t_map_list[i].x,t_map_list[i].y);
                start_pos =cc.Director:getInstance():convertToGL(start_pos);--::sharedDirector()->convertToGL(start_pos);
				start_pos.y =start_pos.y-30;		
				--//只做左右移动
				end_pos.x = start_pos.x;
                end_pos.y = start_pos.y;
                end_pos1.x = start_pos.x;
                end_pos1.y = start_pos.y;					
				if (t_dir_num>0) then end_pos.x=end_pos.x+30;
				else  	              end_pos.x=end_pos.x-30; end;
				end_pos1 = end_pos;
				if (end_pos1.y > 400) then 				
					end_pos1.y = - 200;
                    if (t_map_index == 0) then  end_pos1.x =end_pos1.x+200; 
				    else end_pos1.x =end_pos1.x-200	 end			--( math.random(0,400)-200);
				else				
					if (t_rand_dir == 0) then end_pos1.x = -200;
					else end_pos1.x = 1280 + 200; end
				end		
               -- cclog(" GameScene:BuildSceneKindQZ (%f,%f)(%f,%f)(%f,%f)",start_pos.x,start_pos.y,end_pos.x,end_pos.y,end_pos1.x,end_pos1.y);	
				t_fish_mov_list[0] = start_pos;
				t_fish_mov_list[1] = end_pos;
				t_fish_mov_list[2] = end_pos1;
				t_Fish_mov_pointNum = 3;
				if (t_Fish_mov_pointNum > 0 and t_Fish_mov_pointNum <20) then --//生成移动路径
					if (switch_scene.fish_kind[t_index] < 0)   then switch_scene.fish_kind[t_index] = 0; end
					if (switch_scene.fish_kind[t_index] >= 40) then switch_scene.fish_kind[t_index] = 0; end
					local t_enFishKind =switch_scene.fish_kind[t_index];
                    --
					self.g_fish_manager:ActiveFish(
                         t_enFishKind, 
                         switch_scene.fish_id[t_index], 
                         self.fish_multiple_[t_enFishKind], 
                         self.fish_bounding_box_width_[t_enFishKind],
						 self.fish_bounding_box_height_[t_enFishKind], 
                         t_fish_mov_list, 
                         t_Fish_mov_pointNum, 
                         self.fish_speed_[t_enFishKind], 
                         20);
				end
				t_index=t_index+1;
			end -- if (t_index < switch_scene.fish_count) then 
		end	    --for
	end         --if (self.m_pGameBack) then 
	return;
end

function GameScene:RunSceneSwitch_Trace()       --切换后再生成矩阵 避免切换时打死的鱼不消失
    local switch_scene=self.m_switchScene_buf;
	if(switch_scene.scene_kind==0) then self:BuildSceneKindQZ(0);
	elseif (switch_scene.scene_kind==1) then self:BuildSceneKindQZ(1);
	else self:BuildSceneKindQZ(2); end
end

--触摸函数
function GameScene:touchFunc_()
--触摸层
  self.layer  =  cc.LayerColor:create(cc.c4f(0,0,0,0))
  self:addChild(self.layer,3) 
  local function onTouchBegin(pTouch,event)   
    -- cclog(" onTouchBegin(touch,event)");
     self.m_game_touch_flag = 1;
	 self.m_touch_begin_flag = 1;
     self.m_MRY_Fire_timer=1;
    -- self.last_touch_pos_ = touch:getLocation()
	 self.m_game_touch_pos = pTouch:getLocationInView();

      if(self.m_show_rate_flag>0) then
          self.m_show_rate_flag=0;
           self:show_rate(0); 
      end
   return true   
  end
  local function onTouchMoved(pTouch,event)
    -- cclog(" onTouchMoved(touch,event)");
     self.m_game_touch_flag = 1;
	 self.m_game_touch_pos = pTouch:getLocationInView();
  end
  local function onTouchEnd( pTouch,event )
     -- cclog(" onTouchEnd(touch,event) ");
      self.m_game_touch_flag = 0;
	  self.m_game_touch_pos = pTouch:getLocationInView();
  end
   local  listener  =  cc.EventListenerTouchOneByOne:create()
  listener:registerScriptHandler(onTouchBegin,cc.Handler.EVENT_TOUCH_BEGAN)
  listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
  listener:registerScriptHandler(onTouchEnd,cc.Handler.EVENT_TOUCH_ENDED)
  self.layer:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener,self.layer)
end

function GameScene:initBackKey( )
    self.back_release_ = true
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(handler(self, self.keyboardReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end
function GameScene:Add_bullet_cur_Num()--++切换
     cclog("GameScene:Add_bullet_cur_Num()00");
     local me_chair_id =self:getMeChairID();
	 if ( me_chair_id < GAME_PLAYER and self.m_ion_lock[me_chair_id]==0) then--self.allow_fire_ and
            cclog("GameScene:Add_bullet_cur_Num()01");
		    local	 t_last_bulletKind = self.current_bullet_kind_;
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
			--if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
			self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
			self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);		
			if (t_last_bulletKind ~= self.current_bullet_kind_) then  cc.exports.g_soundManager:PlayGameEffect("effect_cannon_switch"); end
			--else                                                         cc.exports.g_soundManager:PlayGameEffect("AddGunLevelSound"); end
	end
end


function GameScene:Sub_bullet_cur_Num()----切换
     local me_chair_id =self:getMeChairID();
     --&& m_ion_lock[local_chair_id] == 0
	if ( me_chair_id < GAME_PLAYER and self.m_ion_lock[me_chair_id]==0) then--self.allow_fire_ and
		    local	 t_last_bulletKind = self.current_bullet_kind_;
			if (self.current_bullet_mulriple_ <= self.min_bullet_multiple_) then self.current_bullet_mulriple_ = self.max_bullet_multiple_;
		    elseif (self.current_bullet_mulriple_ <= 10) then	self.current_bullet_mulriple_=self.current_bullet_mulriple_-1;
			elseif (self.current_bullet_mulriple_ > 10 and self.current_bullet_mulriple_ <= 100) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-10;
			elseif (self.current_bullet_mulriple_ > 100 and self.current_bullet_mulriple_ <= 1000) then 	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-100;
			else	self.current_bullet_mulriple_ = self.current_bullet_mulriple_-1000;	end
            if (self.current_bullet_mulriple_ < self.min_bullet_multiple_) then	self.current_bullet_mulriple_ = self.max_bullet_multiple_; end
            --
			if (self.current_bullet_mulriple_ < 100) then	self.current_bullet_kind_ = 0;
			elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then self.current_bullet_kind_ = 1;
			elseif (self.current_bullet_mulriple_ >= 1000 and self.current_bullet_mulriple_ < 5000) then self.current_bullet_kind_ = 2;
			else  self.current_bullet_kind_ = 3;	end
			--if (self.m_speed_bt_state>0) then self.current_bullet_kind_ =self.current_bullet_kind_ % 4 + 4; end
			self.cannon_manager_:Switch(me_chair_id, self.current_bullet_kind_);
			self.cannon_manager_:SetCannonMulriple(me_chair_id, self.current_bullet_mulriple_);		
			if (t_last_bulletKind ~= self.current_bullet_kind_) then  cc.exports.g_soundManager:PlayGameEffect("effect_cannon_switch"); end
	end
end

--载入游戏按键ui
function GameScene:Load_TouchUI()
    self:removeChildByTag(966669);
  --  cclog("function GameScene:Load_TouchUI()00-----------");
    local t_mechair_id = self:getMeChairID();
    local root = ccs.GUIReader:getInstance():widgetFromJsonFile("qj_animal/res/game_res/right_menu_1/right_menu_1.json")
    root:setPosition(cc.p(1160,40))
    root:setScale(0.9);
   -- cclog("function GameScene:Load_TouchUI()01---------");
    self:addChild(root,966669);
   -- cclog("function GameScene:Load_TouchUI()02------------");
     --返回
     
     local  function touchEvent_back_bt(sender, eventType)         
         if eventType == ccui.TouchEventType.ended then  
           local  function  onCancel()
            self.g_exit_flag=false;
            end
            if(self.g_exit_flag==false) then 
                self.g_exit_flag=true;
                 WarnTips.showTips({
                               text = LocalLanguage:getLanguageString("L_6ceb2e80d33e115e"),
                               confirm = exit_qj_animal,
                               cancel = onCancel
            })
            end
          end
   end
    cclog("function GameScene:Load_TouchUI()01");
   local back_bt = ccui.Helper:seekWidgetByName(root,"exit_bt");
   if(back_bt~=nil) then 
     back_bt:addTouchEventListener(touchEvent_back_bt);
     local x,y=back_bt:getPosition();
     self.m_right_menu_pos[0]=cc.p(x,y);
     self.m_right_menu_bt_list[0]=back_bt;
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
    cclog("function GameScene:Load_TouchUI()02");
   local rate_bt = ccui.Helper:seekWidgetByName(root,"rate_bt");
   if(rate_bt~=nil) then
    rate_bt:addTouchEventListener(touchEvent_rate_bt);
    local x,y=rate_bt:getPosition();
    self.m_right_menu_pos[1]=cc.p(x,y);
    self.m_right_menu_bt_list[1]=rate_bt;
    end 
   --设置
   local  function touchEvent_setting_bt(sender, eventType)
         if eventType == ccui.TouchEventType.ended then      
               self:ShowSoundSetting();     
           end
   end
   local setting_bt = ccui.Helper:seekWidgetByName(root,"setting_bt");
   if(setting_bt~=nil) then 
     setting_bt:addTouchEventListener(touchEvent_setting_bt);
     local x,y=setting_bt:getPosition();
     self.m_right_menu_pos[2]=cc.p(x,y);
     self.m_right_menu_bt_list[2]=setting_bt;
    end
    --cclog("function GameScene:Load_TouchUI()03");
   --锁定   
   local lock_bt = ccui.Helper:seekWidgetByName(root,"lock_bt");
   if(lock_bt~=nil)  then   
       local x,y=lock_bt:getPosition();
       self.m_right_menu_pos[3]=cc.p(x,y);
       self.m_right_menu_bt_list[3]=lock_bt;               
       local  function touchEvent_lock_bt(sender, eventType)
               if eventType == ccui.TouchEventType.ended then   
                   local lock_ring = ccui.Helper:seekWidgetByName(root,"lock_ring");
                    local px,py=lock_ring:getPosition();
                    self.m_right_menu_pos[7]=cc.p(px,py);
                    self.m_right_menu_bt_list[7]=lock_ring;  
	               if (lock_ring) then 
                       local t_rot = cc.RotateBy:create(2, 360);
		               local t_tep = cc.RepeatForever:create(t_rot);
		               lock_ring:runAction(t_tep);
                       lock_ring:setVisible(true);
                   end
                    self.m_lock_bt_state = 1;
                    self:Lock_fish(t_mechair_id);
               end
        end
        lock_bt:addTouchEventListener(touchEvent_lock_bt);     
    end
   local unlock_bt = ccui.Helper:seekWidgetByName(root,"unlock_bt");
   if(unlock_bt~=nil)  then
       local x,y=unlock_bt:getPosition();
       self.m_right_menu_pos[4]=cc.p(x,y);
       self.m_right_menu_bt_list[4]=unlock_bt;  
       local  function touchEvent_unlock_bt(sender, eventType)
               if eventType == ccui.TouchEventType.ended then 
                    self.m_lock_bt_state = 0;
                    self:UnLock_fish(t_mechair_id);
                     local lock_ring = ccui.Helper:seekWidgetByName(root,"lock_ring");
	                 if (lock_ring) then
                       lock_ring:setVisible(false);
                     end
               end
       end
       unlock_bt:addTouchEventListener(touchEvent_unlock_bt); 
   end
   --自动
   local auto_bt = ccui.Helper:seekWidgetByName(root,"auto_bt");
   if(auto_bt~=nil)   then
        local x,y=auto_bt:getPosition();
       self.m_right_menu_pos[5]=cc.p(x,y);
       self.m_right_menu_bt_list[5]=auto_bt;  
       local function touchEvent_auto_bt(sender, eventType)
                      if eventType==ccui.TouchEventType.ended then
                          local auto_ring =ccui.Helper:seekWidgetByName(root,"auto_ring");
                           if (auto_ring) then 
                                 local px,py=auto_ring:getPosition();
                                self.m_right_menu_pos[6]=cc.p(px,py);
                                self.m_right_menu_bt_list[6]=auto_ring;  
                               local t_rot = cc.RotateBy:create(2, 360);
		                       local t_tep = cc.RepeatForever:create(t_rot);
		                       auto_ring:runAction(t_tep);
                               auto_ring:setVisible(false); 
                           end
                           if (self.m_auto_bt_state == 0) then
                               	self.m_auto_bt_state = 1;		
                                if (auto_ring) then auto_ring:setVisible(true); end
                           else
                                self.m_auto_bt_state = 0;
                                if (auto_ring) then auto_ring:setVisible(false); end
                           end
                           self.auto_ring = auto_ring
                      end
               end
               auto_bt:addTouchEventListener(touchEvent_auto_bt);
     end
     local show_bt = ccui.Helper:seekWidgetByName(root,"show_bt");
     if(show_bt) then 
          show_bt:setString("1"); 
          local function touchEvent_show_bt(sender, eventType)
            if eventType==ccui.TouchEventType.ended then
                 if(self.show_menu_delay<=0) then 
                    self.show_menu_delay=0.5;
                    if(self.show_right_bt and self.show_right_bt>0) then --显示
                       show_bt:setString("1");  
                       self.show_right_bt=0;  
                       self:ShowRightMenu(1);
                    else  --隐藏
                       show_bt:setString("0"); 
                       self.show_right_bt=1; 
                       self:ShowRightMenu(0);
                    end  
                 end    
              end
          end
          show_bt:addTouchEventListener(touchEvent_show_bt);
     end
    -- cclog("function GameScene:Load_TouchUI()05");
      --]]
end
function GameScene:ShowRightMenu(flag__)    
         local i=0;
         for i=0,7,1 do
             --cclog(" GameScene:ShowRightMenu(flag__) 111 i=%d",flag__)
            if(self.m_right_menu_bt_list[i]~=nil) then 
                local end_pos=cc.p(self.m_right_menu_pos[i].x,self.m_right_menu_pos[i].y) ;
                if(flag__==0) then 
                  end_pos.x=end_pos.x+200;
                end
                local t_move_to=cc.MoveTo:create(0.3,end_pos);       
                self.m_right_menu_bt_list[i]:runAction(t_move_to);
            end
         end
end
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
              global.g_mainPlayer:setEffectVolume(self.effectVolume_);
	          global.g_mainPlayer:setMusicVolume(self.musicVolume_);
	         self.m_soundsetting_node:removeFromParent();
             self.m_soundsetting_node=nil;
	         AudioEngine.setEffectsVolume(self.effectVolume_);
             AudioEngine.setMusicVolume(self.effectVolume_)
           end
	      local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	      btnClose:addTouchEventListener(onClose);
          function onEffectVolume(sender, eventType)
	            self.effectVolume_ = self.sliderEffect_:getPercent() / 100
	            --AudioEngine.setEffectsVolume(self.effectVolume_)
                  if( self.g_sound_setting_delay<=0) then
                       self.g_sound_setting_delay=0.1; 
                      AudioEngine.setEffectsVolume(self.effectVolume_)
                  end
          end

          function onSoundVolume(sender, eventType)
	           self.musicVolume_ = self.sliderSound_:getPercent() / 100
	           -- AudioEngine.setMusicVolume(self.musicVolume_)
                 if( self.g_sound_setting_delay<=0) then
                       self.g_sound_setting_delay=0.1; 
                      AudioEngine.setMusicVolume(self.effectVolume_)
                  end
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
                  if( self.g_sound_setting_delay<=0) then
                       self.g_sound_setting_delay=0.1; 
                      AudioEngine.setEffectsVolume(self.effectVolume_)
                  end
	              
               end
           end
           function onEffectVolumeAdd(sender, eventType)
              if eventType == ccui.TouchEventType.began then
	              self.effectVolume_ = math.min(1, self.effectVolume_ + 0.1)
	              self.sliderEffect_:setPercent(self.effectVolume_ * 100)
	             -- AudioEngine.setEffectsVolume(self.effectVolume_)
                  if( self.g_sound_setting_delay<=0) then
                       self.g_sound_setting_delay=0.1; 
                      AudioEngine.setEffectsVolume(self.effectVolume_)
                  end
              end
          end
          function onMusicVolumeSub(sender, eventType)
                if eventType == ccui.TouchEventType.began then
	               self.musicVolume_ = math.max(0, self.musicVolume_ - 0.1)
	               self.sliderSound_:setPercent(self.musicVolume_ * 100)
	              -- AudioEngine.setMusicVolume(self.musicVolume_)
                   if( self.g_sound_setting_delay<=0) then
                       self.g_sound_setting_delay=0.1; 
                      AudioEngine.setMusicVolume(self.effectVolume_)
                  end
                end
          end

          function onMusicVolumeAdd(sender, eventType)
             if eventType == ccui.TouchEventType.began then
	               self.musicVolume_ = math.min(1, self.musicVolume_ + 0.1)
	               self.sliderSound_:setPercent(self.musicVolume_ * 100)
	               -- AudioEngine.setMusicVolume(self.musicVolume_)
                     if( self.g_sound_setting_delay<=0) then
                        self.g_sound_setting_delay=0.1; 
                       AudioEngine.setMusicVolume(self.effectVolume_)
                  end
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
  
--region 
--倍率表显示
function GameScene:show_rate(flag_num)
    self.g_ShowRateFlag=flag_num;
     if(flag_num>0) then
          if(self.g_rate_show_spr==nil) then
               local  c_winSize=cc.Director:getInstance():getWinSize();
               self.g_rate_show_spr=cc.Sprite:create("qj_animal/res/game_res/rate.png");
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
function  GameScene:GetFish_Mul( kindNum) return  self.fish_multiple_[kindNum]; end
function  GameScene:GetSwitchSceneState()   return self.g_switch_Scene; end

function GameScene:onAutoExitHandler()
  exit_qj_animal(GAME_GUIDES.GUIDE_HALL)
end
-------------------------------------------------------------------------消息响应---------------------------------------------------------------------------------
--region 
--添加自定义的消息响应

function GameScene:onEndEnterTransition()
  -- 后台返回前台
  cc.Director:getInstance():getRunningScene():openPhysicsWorld()

  if(global.g_gameDispatcher~=nil) then
     --cclog("GameScene:initMsgHandler().......global.g_gameDispatcher~=nil");
      global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FEILONGPOS, self, self.OnSubFishBOSSUpate)
      global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CJ_NUM_UPDATE, self, self.OnSubCJNumUpate)
      global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CJ_MSG, self, self.OnSubCJmessageUpate)


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
     global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, self, self.OnSubBulletIonTimeout)

    --用户类型
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, self, self.OnSubUpdateJiejiPlayer)
    --global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FISH_QUEUE, self, self.OnSubFishQueue)

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self, self.OnSubHongbaoInfo)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self, self.OnSubHongbaoCatch)

    
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GF_MESSAGE, self, self.onMessage)
  --用户状态变更
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self, self.onRoomUserLeave)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserFree)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self, self.onRoomUserPlay)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_OFFLINE, self, self.onRoomUserOffline)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self, self.onGameServerConnectLost)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_AUTO_EXIT, self, self.onAutoExitHandler)
--  --震屏
  global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self, self.ShakeScreen)
  else 
  cclog("GameScene:initMsgHandler().......global.g_gameDispatcher==nil");
  end
end
--移除自定义的消息响应
function GameScene:onStartExitTransition()
   cclog("GameScene:removeMsgHandler()");
  -- 后台返回前台
  cc.Director:getInstance():getRunningScene():closePhysicsWorld()

      if(self.cannon_manager_) then self.cannon_manager_:removeAllChildren(); end
    if(self.g_fish_manager) then self.g_fish_manager:FreeAllFish(); end
   if(global.g_gameDispatcher~=nil) then

    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_FEILONGPOS, self)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CJ_NUM_UPDATE, self)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_BUYU_CJ_MSG, self)


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
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_BULLET_ION_TIMEOUT, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SUB_S_JIEJI_PLAYER_SEND, self)
   -- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_BUYU_FISH_QUEUE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_FLAG, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RED_ENVELOPE_SEND, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GF_MESSAGE, self)
  --用户状态变更
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_LEAVE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_PLAY, self)

   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_OFFLINE, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_SERVER_CONNECT_LOST, self)
   global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_AUTO_EXIT, self)
--  --震屏
  global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_SHAKE_SCREEN, self)
  end
end



function GameScene:GAME_MESSAGE_ROOM_USER_OFFLINE(param)
    self.allow_fire_=false;
    self:unscheduleUpdate()
end
function GameScene:onGameServerConnectLost(param)
    self.allow_fire_=false;
    self:unscheduleUpdate()
end

function GameScene:ShakeScreen(param)
   
   self.m_pGameBack:Screen_jitter();

end

function GameScene:OnSubCJmessageUpate(param)

   
end
function GameScene:OnSubFishBOSSUpate(t_CMD_S_FishBOSS)
    cclog("GameScene:OnSubFishBOSSUpate(t_CMD_S_FishBOSS)");
    local  pFishInfo = nil;
	 pFishInfo = self.g_fish_manager:GetFish(1);
     if(pFishInfo==nil)  then 
        local  t_fish_mov_list={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)}
        local t_Fish_mov_pointNum=2;
		if (t_CMD_S_FishBOSS.Dir == 0) then 	   
			t_fish_mov_list[0].x = t_CMD_S_FishBOSS.x;
			t_fish_mov_list[0].y =360;
			t_fish_mov_list[1].x = 1280 + 700;
			t_fish_mov_list[1].y =720 / 2;
			t_fish_mov_list[2].x = 1280 + 800;
			t_fish_mov_list[2].y = 720 / 2;	
		else	
			t_fish_mov_list[0].x = t_CMD_S_FishBOSS.x;
			t_fish_mov_list[0].y = 360;
			t_fish_mov_list[1].x = -800;
			t_fish_mov_list[1].y = 360;
			t_fish_mov_list[2].x = -800;
			t_fish_mov_list[2].y = 360;
		end   
          self.g_fish_manager:ActiveFish(
                        15, 
                        1, 
                        self.fish_multiple_[15], 
                        self.fish_bounding_box_width_[15],
				        self.fish_bounding_box_height_[15], 
                        t_fish_mov_list, 
                        t_Fish_mov_pointNum, 
                        self.fish_speed_[15], 0);
		self:UpdateCJNum(t_CMD_S_FishBOSS.num);	
     end  
end
function GameScene:UpdateCJNum(param)
   if (self.g_cj_Node==nil) then   
		  local c_winsize = cc.Director:getInstance():getWinSize();
		  self.g_cj_Node = cc.Node:create();
		  self.g_cj_Node:setPosition(cc.p(c_winsize.width / 2 - 240, c_winsize.height - 320));
		  self:addChild(self.g_cj_Node, 99);
          local root = ccs.GUIReader:getInstance():widgetFromJsonFile("qj_animal/res/game_res/touch_animal_cj_box_1.json")
          self.g_cj_Node:addChild(root,966669);
          self.g_cj_num_Node= ccui.Helper:seekWidgetByName(root,"num");
      end
	  if (self.g_cj_num_Node) then 
		  local tem_numstr= string.format("%d", param);
		  self.g_cj_num_Node:setStringValue(tem_numstr);
      end
end
function GameScene:OnSubCJNumUpate(param)
    self:UpdateCJNum(param.num);
end

function GameScene:OnSubUpdateJiejiPlayer(jiejiplayer_data_)
     local i=0;
  	for  i = 0, 7, 1 do
		self.g_jieji_player_flag[i] = jiejiplayer_data_.jieji_player_flag[i];	
		if (self.cannon_manager_) then self.cannon_manager_:SetPlayer_Type(i, self.g_jieji_player_flag[i]); end
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
--场景消息
function GameScene:OnEventSceneMessage(gamestatus)
 cclog("GameScene:OnEventSceneMessage场景消息.....\n");
 local t_me_chair_id=self:getMeChairID();
 local i=0;
 self.g_fish_score_={};
 self.g_coin_score_={};
 for i = 0,3,1 do
    if ( self.cannon_manager_~=nil) then
       cclog("GameScene:OnEventSceneMessage场景消息.....i=%d\n",i);
      --  self.cannon_manager_:setVisible_(i,false);
        self.cannon_manager_:SetFishScore(i, gamestatus._fish_score[i]);
        self.g_fish_score_[i] = gamestatus._fish_score[i];
	    self.g_coin_score_[i] = gamestatus._coin_score[i];  
   end
    self.cannon_manager_:ShowMyConButton(t_me_chair_id);
end	
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
          --self.cannon_manager_:setVisible_(k,true);
       end
    end
   --gamestatus.scene_kind_=3;
   cclog("GameScene:OnEventSceneMessage场景消息.....  -gamestatus.scene_kind_=%d",-gamestatus.scene_kind_);
    if (self.m_pGameBack)then self.m_pGameBack:SetSwitchSceneStyle(gamestatus.scene_kind_);end
    --self.m_IsSwitchingScene = 1;  
end

--配置
function GameScene:OnSubGameConfig(param)
  cclog("GameScene:OnSubGameConfig......................");
  local t_my_chair_id=self.g_me_chair_id;--self:getMeChairID();
  self.exchange_count_= param.exchange_count;
  self.g_fish_score_rate= param.fish_score_rate_num;
  self.g_coin_score_rate= param.coin_score_rate_num;
  self.min_bullet_multiple_= param.min_bullet_multiple;
  self.max_bullet_multiple_= param.max_bullet_multiple;
  self.m_nFirst_bullet_multiple_= param.nfirst_bullet_multiple;
  self. current_bullet_mulriple_ =self.m_nFirst_bullet_multiple_;
  self.current_bullet_kind_=0;
  if (self.current_bullet_mulriple_ < 100)  then self.current_bullet_kind_ =0; 
  elseif (self.current_bullet_mulriple_ >= 100 and self.current_bullet_mulriple_ < 1000) then self.current_bullet_kind_ =1;
  elseif(self.current_bullet_mulriple_ >= 1000 and self.current_bullet_mulriple_ < 5000)then   self.	current_bullet_kind_ =2;
  else 	 self.current_bullet_kind_ =  3;  end
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
   local i=0;
   for  i = 0, FISH_KIND_COUNT-1,1 do
   self.fish_multiple_[i]=param.fish_multiple[i]
   self.fish_speed_[i]=param.fish_speed[i];
   self.fish_hit_radius_[i]=param.fish_hit_radius[i];
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
  cc.exports.g_protion = 1 / param.fish_score_rate_num;
  cc.exports.fish_multiple = param.fish_multiple; --鱼的倍率定值鱼
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
    self.m_auto_bt_state = 0
    if self.auto_ring then
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
--cclog("GameScene:OnSubFishTrace(param)00");
if(self.run_in_back_flag>0)then return ;end

 if( self.g_back_Fore_Delay>0) then return ;end
 if(self.g_switch_Scene>0) then return ; end--self.g_switch_Scene = 0;	
 --cclog("GameScene:OnSubFishTrace(param)01");
if(self.g_fish_manager) then
 local fish_trace_count = #param; --数目
 if(fish_trace_count>=0) then
    for i = 1,fish_trace_count,1 do   
        local  fish_trace =param[i];
        if(fish_trace) then 
           local t_fish_mov_list={};--//移动点列表
           local t_enFishKind =fish_trace.fish_kind;
           local start_pos=cc.p(fish_trace.init_pos[0].x,fish_trace.init_pos[0].y);
           local t_Fish_mov_pointNum = fish_trace.init_count;
           t_fish_mov_list=fish_trace.init_pos;
           if(t_Fish_mov_pointNum > 0 and t_Fish_mov_pointNum < 5) then --//生成移动路径
              --cclog("GameScene:OnSubFishTrace(param)00");
              self.g_fish_manager:ActiveFish(
                        t_enFishKind, 
                        fish_trace.fish_id, 
                        self.fish_multiple_[t_enFishKind], 
                        self.fish_bounding_box_width_[t_enFishKind],
				        self.fish_bounding_box_height_[t_enFishKind], 
                        t_fish_mov_list, 
                        t_Fish_mov_pointNum, 
                        self.fish_speed_[t_enFishKind], 0);
                  --]]
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
    if(self.m_soundsetting_node~=nil) then return false; end
    if (self.m_IsSwitchingScene>0) then return  false;  end--正在切换场景
    if (self.g_back_Fore_Delay > 0.000001) then return false ; end--从后台返回

    if (self.cannon_manager_ == nil) then return false; end
    local ifself=user_fire.from_server_flag;
    local me_switch_chair = user_fire.chair_id;
    local me_chair_id =self:getMeChairID();
    --local m_android_chair_id=user_fire.android_chairid;
    --local me_c_chair_id=self:getMeChairID();-- self:getMeChairID();
    if(self.cannon_manager_:GetFishScore(me_switch_chair)<1)then return;  end--没分数直接返回
	if (me_switch_chair == me_chair_id)then --本桌
         self.current_bullet_self_count=0; 	
	end  
    if(ifself==1 and me_switch_chair == me_chair_id) then --从后期扣分	        
       if (user_fire.bullet_kind<8) then 	               
            self:sub_fish_score_(me_switch_chair,user_fire.bullet_mulriple);
       else --//更新免费子弹数量
           if (user_fire.bullet_specKindFlag>0) then 			
			   self.cannon_manager_:Ion_Set_Free_BulletNum(user_fire.chair_id, user_fire.bullet_specKindFlag);			
		   else		
				self.cannon_manager_:Ion_free_Stop(user_fire.chair_id);
			end
       end  
       self.cannon_manager_:Switch(me_switch_chair,user_fire.bullet_kind); 
       return true;
    end
    if(self.m_ion_lock[me_switch_chair]>0) then 
        if(user_fire.bullet_kind<4) then 
           self:OnSubBulletIonTimeout(me_switch_chair);
         end
    end
    -- cclog("GameScene:OnSubUserFire( chair_id=%d, bullet_kind=%d)",me_switch_chair,user_fire.bullet_kind);
    --特殊子弹
    self.cannon_manager_:Switch(me_switch_chair, user_fire.bullet_kind);
	self.cannon_manager_:Fire(me_switch_chair, user_fire.bullet_kind); 
    cc.exports.g_soundManager:PlayGameEffect("effect_fire");
    --if (user_fire.bullet_kind<8) then   SoundManager::GetInstance().PlayGameEffect("NormalFireSound");
	--else SoundManager::GetInstance().PlayGameEffect("SuperGunFireSound"); end
    --锁定
    local angle = user_fire.angle;
	local lock_fish_id = user_fire.lock_fishid;
	if (lock_fish_id == -1)then
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
            self:sub_fish_score_(user_fire.chair_id, user_fire.bullet_mulriple);
	  end
	 local cannon_pos = self.cannon_manager_:GetCannonPos(me_switch_chair,1);
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
			lock_fish_id,
            user_fire.android_chairid);
end

--捕获
function GameScene:OnSubCatchFish(catch_fish)
      --cclog("GameScene:OnSubCatchFish(catch_fish)--------------------------------------------------");

      local me_switch_chair =catch_fish.chair_id;
      self:add_fish_score_(me_switch_chair, catch_fish.fish_score);
     --中奖效果
     if(self.g_BingoManager~=nil) then 
         if (catch_fish.fish_mul>25 or catch_fish.fish_kind>30) then 
            self.g_BingoManager:AddBingo(me_switch_chair,catch_fish.fish_score,0);
         end	
      end
      if (self.g_fish_manager) then
		  --self.g_fish_manager:CatchFish(catch_fish.chair_id, catch_fish.fish_id, catch_fish.fish_score, catch_fish.bullet_mul, catch_fish.fish_mul,0);
          self.g_fish_manager:CatchFish(me_switch_chair, catch_fish.fish_id, catch_fish.fish_score, catch_fish.bullet_mul, catch_fish.fish_mul, 0);
	 end
     if(catch_fish.bullet_ion>0) then 
            self.cannon_manager_:SetCannonMulriple(me_switch_chair,catch_fish.bullet_mul); --//强制切换子弹倍数
			local t_pos = cc.p(640, 360);
			if (self.g_fish_manager) then 			
				local t_fish = self.g_fish_manager:GetFish(catch_fish.fish_id);
				if (t_fish) then 
                t_pos = t_fish:GetFishccpPos(); 
                end
			end
			self.m_ion_lock[me_switch_chair] = 1;--//双倍子弹  //特殊子弹禁止切换
			self.m_Ion_bullet_flag[me_switch_chair]=catch_fish.bullet_ion;
			if (catch_fish.bullet_ion == 1)	 then self.cannon_manager_:Ion_Double_Start(me_switch_chair, t_pos,20);			
			elseif(catch_fish.bullet_ion ==3) then self.cannon_manager_:Ion_free_Start(me_switch_chair, t_pos,20);		
             end
     end
     
     self:checkGuide(catch_fish.chair_id)
end
function GameScene:CheckSwitchScene()
   if(self.m_IsSwitchingScene==nil) then  return 0; end
   return self.m_IsSwitchingScene;
end
--场景切换
function GameScene:OnSubSwitchScene(switch_scene)

  self.m_pGameBack:SetSwitchSceneStyle(switch_scene.scene_kind%3);
  self.m_switchScene_buf=switch_scene;
  self.g_switch_Scene = 1;
  self.m_IsSwitchingScene = 1;
  self.g_switch_SceneTime = 70;
  self:AllowFire(false);
  self.m_switchScene_buf=switch_scene;
  for  i=0,8,1 do	
	  self:UnLock_fish(i);
  end
end

--场景结束
function GameScene:OnSubSceneEnd(param)
  cclog("GameScene:OnSubSceneEnd.....\n");
  --显示垃圾回收
    collectgarbage("collect");
end
function GameScene:OnSubBulletIonTimeout(chair_id)--特殊子弹结束
   cclog("GameScene:OnSubBulletIonTimeout(chair_id=%d)vv",chair_id);
   if(chair_id~=nil) then 
      if(chair_id>=0 and chair_id<=4) then 
         cclog("GameScene:OnSubBulletIonTimeout(chair_id=%d) 01dd",chair_id);
         self.m_ion_lock[chair_id]=0;
         if (self.cannon_manager_) then 		
			self.cannon_manager_:Ion_Double_Stop(chair_id);
			self.cannon_manager_:Ion_free_Stop(chair_id);
	    end
      end
   end
end
function GameScene:OnSubHongbaoInfo(user_s_red_envelope)
   -- cclog(" GameScene:OnSubHongbaoInfo(param).....");
	local m_red_envelope_hour = user_s_red_envelope.nextTime_h; --//小时
	local m_red_envelope_min = user_s_red_envelope.nextTime_m; --//分
	local m_red_envelope_sec = user_s_red_envelope.nextTime_s; --//小时
	local m_red_envelope_num = user_s_red_envelope.nextTime_l; --//剩余数量
    if(self.g_hongbao_ttf==nil) then --"fullmain/res/fonts/FZY4JW.ttf", 25)
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
   cclog(" GameScene:OnSubHongbaoCatch(param).....");
    --self.m_red_envelope_Manager
    local chairID = user_s_red_envelope_give.chairID;
    if (chairID >= 0 and chairID < GAME_PLAYER)	then
		local fishID = user_s_red_envelope_give.FishID;
		local cannon_pos = self.cannon_manager_:GetCannonPos(chairID,0);
		local fish_pos =self.g_fish_manager:GetFish(fishID):GetFish_NodePos();
        cclog("cannon_pos(%f,%f)",cannon_pos.x,cannon_pos.y);
        cclog("fish_pos(%f,%f)",fish_pos.x,fish_pos.y);
        cclog("chairID=%d",chairID);
        cclog("_score=%d",user_s_red_envelope_give.score);
                                      --function add(fish_pos, cannon_pos, chair_id, score)
		self.m_red_envelope_Manager:add(fish_pos, cannon_pos, chairID, user_s_red_envelope_give.score);
	end
end

function GameScene:onMessage(param)
--[[
  local str = param.message
  if string.find(str,LocalLanguage:getLanguageString("L_a56b8871aaeb1e5b")) then 
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
  --]]
end


function GameScene:onRoomUserLeave(playerId, tableId, chairId, status) 
  cclog("GameScene:onRoomUserLeave......playerId=%d..........tableId=%d...........chairId=%d.........................................................................",playerId, tableId, chairId);
  --有人离开
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
      if (self.cannon_manager_) then

          self.cannon_manager_:ResetFishScore(chairId);
          self.cannon_manager_:SetPlayer_Type(chairId,4);
          self.cannon_manager_:SetUserName(chairId, "");--显示昵称
          if self.cannon_manager_.setVisible_ then
            self.cannon_manager_:setVisible_(chairId,false);
          end
          self.g_fish_score_[chairId]=0;
    end
    if(playerId==global.g_mainPlayer:getPlayerId())then  exit_qj_animal();end
  end
end
function GameScene:onRoomUserFree(playerId, tableId, chairId, status) 
  cclog("GameScene:onRoomUserFree.....playerId=%d..........tableId=%d...........chairId=%d.........................................................................",playerId, tableId, chairId);
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
    if (self.cannon_manager_) then
          self.cannon_manager_:ResetFishScore(chairId);
          self.cannon_manager_:SetUserName(chairId, "");--显示昵称
          if self.cannon_manager_.setVisible_ then
            self.cannon_manager_:setVisible_(chairId,false);
          end
          self.cannon_manager_:SetPlayer_Type(chairId,4);
          self.g_fish_score_[chairId]=0;
    end
    if(playerId==global.g_mainPlayer:getPlayerId())then  exit_qj_animal();end

  end
end
function GameScene:onRoomUserPlay(playerId, tableId, chairId, status) 
 cclog("GameScene:onRoomUserPlay....playerId=%d..........tableId=%d...........chairId=%d.........................................................................",playerId, tableId, chairId);
  --有人进来玩
  local currentTableId = global.g_mainPlayer:getCurrentTableId()
  if tableId == currentTableId and tableId >= 0 and chairId >= 0 then  --本桌
    --我桌子上有人来玩
    local pd = global.g_mainPlayer:getRoomPlayer(playerId);
    if (self.cannon_manager_) then
          self.cannon_manager_:SetUserName(chairId, pd.name);--显示昵称
          if self.cannon_manager_.setVisible_ then
            self.cannon_manager_:setVisible_(chairId,true);
          end
          self.cannon_manager_:SetPlayer_Type(chairId,self.g_jieji_player_flag[i]);
    end
  end
end
-- function GameScene:onExit()
--     if(self.cannon_manager_) then self.cannon_manager_:removeAllChildren(); end
--     if(self.g_fish_manager) then self.g_fish_manager:FreeAllFish(); end
--     self:removeMsgHandler();
-- end


------------物理引擎监听
function GameScene:onContactBegin(contact)

  if(self.g_switch_Scene>0) then return false; end--self.g_switch_Scene = 0;	
  local bodyA = contact:getShapeA():getBody();
  local bodyB = contact:getShapeB():getBody();
  local groupA = bodyA:getGroup();
  local groupB = bodyB:getGroup();
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
  if(fish_body_node_==nil) or (bullet_hit_node == nil) then return false;end
  fish=fish_body_node_:getParent():getParent();
  bullet=bullet_hit_node:getParent();
  if(bullet and fish) then  
    if(self.m_IsSwitchingScene==0) then 
      if(self.g_fish_manager:NetHit_Bullet(bullet,fish,nil)==true) then 
          --cclog("GameScene:onContactBegin self.g_fish_manager:NetHit_Bullet(bullet,fish)==true");
          return true;
      end
     end
   end
  return false
end

function GameScene:onContactPreSolve(contact)
--[[
  cclog("GameScene:onContactPreSolve 1111111111");
  if(self.g_switch_Scene>0) then return false; end--self.g_switch_Scene = 0;	
  local bodyA = contact:getShapeA():getBody();
  local bodyB = contact:getShapeB():getBody();
  local groupA = bodyA:getGroup();
  local groupB = bodyB:getGroup();
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
  if(fish_body_node_==nil)  then return false;end
  if(bullet_hit_node==nil) then return false;end
  fish=fish_body_node_:getParent():getParent();
  bullet=bullet_hit_node:getParent();
  if(bullet and fish) then  
    if(self.m_IsSwitchingScene==0) then 
      if(self.g_fish_manager:NetHit_Bullet(bullet,fish)==true) then 
          cclog("GameScene:onContactPreSolve self.g_fish_manager:NetHit_Bullet(bullet,fish)==true");
          return true;
      end
     end
   end
  return false
  --]]
end

return GameScene
--endregion

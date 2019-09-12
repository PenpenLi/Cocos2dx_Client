--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成

local FullScreenDragon=class("FullScreenDragon",cc.exports.Fish);
function FullScreenDragon:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        FullScreenDragon.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
       self.m_create_fail_flag=0;
	    self.m_Change_Timer=0;
	    self.m_CatchStep=0; --//死亡进度
	    self.m_catch_timer=0;
        self.alive_limi_time=0;
	    self.m_dra_run_Angle=0;
        self:setLocalZOrder(-1);
		self.m_run_timer = 0;
        self.m_run_index_timer=0;
        self.m_run_index=0;
		self.m_create_fail_flag = 0;
		self.m_Change_Timer = math.random(0,100)%2+1;
		self.valid_ = true;
		self.m_dra_run_Angle = 270;
		self.m_moveKind = 1;
        self.m_run_flag=0;
		self.fis_node:removeChildByTag(7758258);
        self.player_run_timer=0;
        -------------初始化
       if(cc.exports.m_huolong_InitFlag==0) then                
            local  t_ccwinsize = cc.Director:getInstance():getWinSize();
		    local  t_spr_scale_x = t_ccwinsize.width / 480 * 0.5;
		    local  t_spr_scale_y = t_ccwinsize.height / 270 * 0.5;
            local i,j=0,0;
            for  i = 1,17, 1 do	
			  for  j = 1,10,1 do
				if (cc.exports.game_Dragon_HitList_local[i][j][3]>0) then 
					cc.exports.game_Dragon_HitList_local[i][j][2]=540 -cc.exports.game_Dragon_HitList_local[i][j][2];
					cc.exports.game_Dragon_HitList_local[i][j][1] =cc.exports.game_Dragon_HitList_local[i][j][1]-480;
					cc.exports.game_Dragon_HitList_local[i][j][2] =cc.exports.game_Dragon_HitList_local[i][j][2]-270;
				end	
				cc.exports.game_Dragon_HitList_local[i][j][1]=cc.exports.game_Dragon_HitList_local[i][j][1]* t_spr_scale_x;
				cc.exports.game_Dragon_HitList_local[i][j][2] =cc.exports.game_Dragon_HitList_local[i][j][2]*t_spr_scale_y;
				cc.exports.game_Dragon_HitList_local[i][j][3] = cc.exports.game_Dragon_HitList_local[i][j][3]*t_spr_scale_x;
			end --for j
		 end --for i
         cc.exports.m_huolong_InitFlag=1;
       end --  if(cc.exports.m_huolong_InitFlag==0) then 
end
function  FullScreenDragon:CheckValid()return true; end
function FullScreenDragon:GetFishccpPos() --获得可锁定位置
        local x,y=-10000,-10000;
        local t_index= self.m_run_index%17;
        t_index=t_index+1;
        --local t_add_tad_index=11186;
        for  j =1,10,1 do
             -- local t_node= self.fis_node:getChildByTag(t_add_tad_index);
              local hit_table=cc.exports.game_Dragon_HitList_local[t_index];
              local hit_pec_table=hit_table[j];
              local x=hit_pec_table[1];
              local y=hit_pec_table[2];
              local r=hit_pec_table[3];
		      if (r>0) then 
                  return self.fis_node:convertToWorldSpace(cc.p(x,y));
              end
        end
end
function  FullScreenDragon:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
    cclog(" FullScreenDragon:CatchFish");
    cc.exports.g_soundManager:PlayGameEffect("HitDragon");
     local t_add_tad_index=11186;
     for i=0,10,1  do self.fis_node:removeChildByTag(t_add_tad_index+i); end
     self.alive_limi_time=0;
	 self.m_mov_timer = 0;
	 self.m_catch_chairID = chair_id;
	 self.m_catch_score = score;
	 self.fish_multiple_ = fish_mul;
	 self.fish_status_ = 2;
     local t_catch_pos=self:GetFishccpPos();
      if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(t_catch_pos,self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(t_catch_pos, self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	  end
	if (bomFlag>0) then 
		self.m_catch_timer = 2;
		self.m_fish_die_action_EndFlag = 1;
		return;
	end --if (bomFlag>0) then 
    --//播放特效
	cc.exports.g_My_Particle_manager:PlayParticle(0, t_catch_pos);
	cc.exports.game_manager_:ShakeScreen();
   self:setLocalZOrder(100);
	local t_check_point_num = 0;
	self.m_CatchStep = 1;
	self.m_catch_timer = 0;
	--cc.exports.g_CoinManager:BuildCoin(self.fis_node:getPosition(), chair_id, score, fish_mul);
	local t_aliveSpr = self.fis_node:getChildByTag(10086);
	if (t_aliveSpr) then
		t_aliveSpr:stopAllActions();   
		t_aliveSpr:runAction(cc.FadeOut:create(0.2));
	end
    local t_check_point_num=0;
    local n=0;
 
   t_check_point_num = t_check_point_num / 2;
   --local t_start_pos =t_catch_pos;-- cc.p(game_Dragon_HitList_local[t_frame_Index][t_check_point_num].x, game_Dragon_HitList_local[t_frame_Index][t_check_point_num].y);
   --local t_Player_pos = cc.p(_local_info_array_[chair_id].x, _local_info_array_[chair_id].y);
   --local effect_pos=self.fis_node:convertToNodeSpace(t_catch_pos);
   local file_name ="";
   local _sprite = nil;
   local readIndex = 0;
   local animation = cc.Animation:create();
   local i=0;
   for  i = 0,42, 1 do
				file_name=string.format("~FullScreenFishAppearEff_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
						local offset_name=string.format("FullScreenFishAppearEff_000_%03d.png", i);
						local t_offset_ = cc.p(0, 0);
                        local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                        local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
                        local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                        local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                        local t_offeset_pos=cc.p(0,0);
                        local t_offset_0 = frame:getOffsetInPixels();
                        t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	            t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                        frame:setOffsetInPixels(t_offset_);
					    if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					    readIndex=readIndex+1;    
                        animation:addSpriteFrame(frame);
				end
	  end--for 
      if (readIndex > 0)	then 
      local function _call_back00()
               _sprite:removeFromParent()
      end
      animation:setDelayPerUnit(1/12.0);
     local action =cc.Animate:create(animation);   
     local t_CCRepeat = cc.Repeat:create(action, 1);
	  local t_func_ = cc.CallFunc:create(_call_back00);
	   local  seq = cc.Sequence:create(t_CCRepeat, t_func_, nil);
	   _sprite:runAction(seq);
       _sprite:setPosition(t_catch_pos);     
       self:addChild(_sprite, 12);
       cc.exports.g_cannon_manager:Catch_FullScreenDragon(chair_id,t_catch_pos, score, fish_mul); 
        --cc.exports.g_offsetmap_InitFlag[24]=1;
		--animation:setDelayPerUnit(1/24.0);
		-- local action =cc.Animate:create(animation);   
		--_sprite:runAction(cc.RepeatForever:create(action));
        --self.fis_node:addChild(_sprite, 0, 10086);
  end
end 

function  FullScreenDragon:Change()
  if (self.fis_node) then 
      local  t_ccwinsize = cc.Director:getInstance():getWinSize();
      self.m_run_timer = 0;
      self.m_run_index=0;
      self.m_run_index_timer=0;
	  self.m_dra_run_Angle =  self.m_dra_run_Angle +75;
      self.fis_node:setPosition(cc.p(t_ccwinsize.width / 2, t_ccwinsize.height / 2));
	 self.fis_node:setVisible(true);
	 self.fis_node:setRotation(self.m_dra_run_Angle);	
	 self.fis_node:setScale(1.0);
	 self.fis_node:removeChildByTag(10086);
     self.baseAngle = math.rad(90);
     self.player_run_timer=0;
  
     local file_name ="";
	 local _sprite = nil;
	 local readIndex = 0;
	 local animation = cc.Animation:create();
     local i=0;
	for  i = 0,185, 1 do
         file_name=string.format("FullDrago (%d).png", i);
		local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		if (frame) then						
			if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
			readIndex=readIndex+1;    
            animation:addSpriteFrame(frame);
		end
     end--for
      if (readIndex > 0)	then       
		 animation:setDelayPerUnit(1/16.0);
         local function ac_call_back_()
                self.player_run_timer=0;
                self.m_run_flag=0;
                self.m_run_index_timer=0;
                self.fis_node:removeAllChildren();

                --self.fis_node:removeChildByTag(10086);
        end
		 local action =cc.Animate:create(animation);  
         local  t_rep_action=cc.Repeat:create(action,1);
         local  t_action_end_call_back=cc.CallFunc:create(ac_call_back_);
         local  t_seq=cc.Sequence:create(t_rep_action,t_action_end_call_back,nil);
         self.m_run_flag=1;
		_sprite:runAction(t_seq);
         _sprite:setAnchorPoint(cc.p(0.5, 0.5));
		_sprite:setScaleX(t_ccwinsize.width / 480);
		_sprite:setScaleY(t_ccwinsize.height / 270);		
        self.fis_node:addChild(_sprite, 0, 10086);
	end
  end
end
function   FullScreenDragon:update_hit_array(index)
           local t_index= index%17;
           local t_add_tad_index=11186;
           t_index=t_index+1;
          -- cclog("FullScreenDragon:update_hit_array  index=%d----------------------------------------",index);
         --更新碰撞球
             for  j =1,9,1 do
                self.fis_node:removeChildByTag(t_add_tad_index);
                if(self.m_run_flag>0) then 
                   local hit_table=cc.exports.game_Dragon_HitList_local[t_index];
                   local hit_pec_table=hit_table[j];
                   local x=hit_pec_table[1];
                   local y=hit_pec_table[2];
                   local r=hit_pec_table[3];
				   if (r>0) then 
                       local fish_body_node_=cc.Node:create();
                       local body = cc.PhysicsBody:createCircle(r);
                       body:setGroup(2);
                       body:setDynamic(false);
                       body:setGravityEnable(false);
                       body:setContactTestBitmask(1);
                       fish_body_node_:setPhysicsBody(body);
                       self.fis_node:addChild(fish_body_node_,0,t_add_tad_index);
                       local pos=cc.p(x,y);     
                       --cc.Node:setPosition  
                       fish_body_node_:setPosition(pos);        
				   end	--if(self.m_run_flag>0) then 
                end
                t_add_tad_index=t_add_tad_index+1;
			end --for j
end
function  FullScreenDragon:OnFrame( delta_time)
    --if(delta_time>0.04) then delta_time=0.04; end;
   if (self.active_==0) then return false;end
	if (self.fish_status_== 0)then 
		self.fish_status_ = 1;
		self:Change();
        self:update_hit_array(0);
		return false;
	end
    if (self.fish_status_ == 1)then 
		self.m_run_timer=self.m_run_timer+delta_time; 
        self.m_run_index_timer=self.m_run_index_timer+delta_time;
       if(self.m_run_index_timer>0.41667) then --1/24 --没10帧变换一次
                     self.m_run_index=self.m_run_index+1;
                     self.m_run_index_timer= self.m_run_index_timer-0.41667;
                    self:update_hit_array(self.m_run_index);
        end       
		if(self.m_run_timer >10)then 
			self.m_run_timer = 0;
			self:Change();
			self.m_Change_Timer=self.m_Change_Timer-1;
		end
		if (self.m_Change_Timer<0) then return true; end
    elseif (self.fish_status_ == 2) then 
        --self.alive_limi_time=self.alive_limi_time+delta_time;
       -- if(self.alive_limi_time>20)then return true; end
		self.valid_ = false;
		self.m_CatchStep = 1;
		self.m_catch_timer =self.m_catch_timer+delta_time;
		if (self.m_catch_timer > 2) then 			return true;	end
	end
end
function  FullScreenDragon:GetFame_Index()
	local t_index = 0;
     t_index= self.m_run_index;--math.floor(self.m_run_timer*24.0);
	return  t_index;
end
function FullScreenDragon:Catch_ActionCallBack() end
function FullScreenDragon:BulletHitTest( bullet)

	if (self.active_==false)  then return false; end
	if (self.valid_==false)  then return false; end
	if (self.m_no_catch_flag>0) then return false; end--//无法捕捉
	if (self.fish_status_ ~= 1) then  return false; end
    local local_fish_id=bullet:lock_fishid();
	if (local_fish_id > 0 and local_fish_id ~= self.fish_id_) then return false; end
	local point = bullet:get_mov_pos();
	return self:Hit_Check(point, 10);
end
function  FullScreenDragon:NetHitTest( bullet) return self:BulletHitTest(bullet);  end
function  FullScreenDragon: Hit_Check( i_pos,  disr)
  if (self.fis_node) then 
  	local t_sswinsize = cc.Director:getInstance():getWinSize();--:sharedDirector()->getWinSize();
	local t_frame_Index =self:GetFame_Index();
	t_frame_Index = t_frame_Index / 10;
	if (t_frame_Index < 0) then t_frame_Index = 0; end
	if (t_frame_Index > 16) then t_frame_Index = 16; end
    --检测碰撞
    --[[
    local i=0;
	for i = 0,9,1 do
		if (cc.exports.game_Dragon_HitList_local[t_frame_Index][i][3]>0) then 	
                local x=cc.exports.game_Dragon_HitList_local[t_frame_Index][i][1];
                local y=cc.exports.game_Dragon_HitList_local[t_frame_Index][i][2];
			    local Check_pos = self.fis_node:convertToWorldSpace(cc.p(x, y));
			    if (Check_pos.x > 0 and Check_pos.x < t_sswinsize.width and Check_pos.y>0 and Check_pos.y < t_sswinsize.height) then 
                    local t_Hit_r = cc.exports.game_Dragon_HitList_local[t_frame_Index][i][3] + disr;		
                    local dx=Check_pos.x-i_pos.x;
                    local dy=Check_pos.y-i_pos.y;
                    local dis=dx*dx+dy*dy;
                    t_Hit_r = t_Hit_r*t_Hit_r;
					if ( dis< t_Hit_r) then 		return true;	end
			 end
		end	 --if (game_Dragon_HitList_local[t_frame_Index][i].r>0) then 
	end--for--]]
  end  -- if (self.fis_node) then
end

function  FullScreenDragon:TouchHitTest( x,  y)  
	return self:Hit_Check(cc.p(x,y), 10);
end
function  FullScreenDragon:touch_Catch_fish_test( touch_pos,  touch_r,  lock_fishid)
    if (self.active_==false) then  return false; end
	if (self.valid_==false)  then return false; end
	if (self.m_no_catch_flag>0) then return false; end--//无法捕捉
	if (self.fish_status_ ~= 1)then return false; end
    if (lock_fishid > 0 and lock_fishid ~= fish_id_) then  return false; end
	return self:Hit_Check(touch_pos, touch_r);
end
function FullScreenDragon:touch_Catch_fish_( _chair_id,  local_chair_id,  bullet_ID,  bullet_Kind,  mul_num,  touch_pos,  touch_r,  lock_fishid)
	if (self.touch_Catch_fish_test(touch_pos, touch_r, lock_fishid))then 	return true;end
	return false;
end
return FullScreenDragon;

--endregion

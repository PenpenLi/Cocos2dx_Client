--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--穿甲弹管理类
local Broach_Bullet = class("Broach_Bullet",
 function()
	return cc.Node:create()
end
)
function  Broach_Bullet:mm_getAngle_by_xy_( x, y)
	local  len_y =y;
	local len_x = x;
	if (len_y >= -0.001 and len_y <= 0.001)
	then
		if (len_x < 0) then 	return 270;
		elseif (len_x > 0) then return 90; end
	end

	if (len_x >= -0.001  and len_x <= 0.001)
	then 
		if (len_y >= 0) then return 0;
		elseif (len_y < 0) then return 180; end
	end
	return   math.atan2(len_x, len_y) * 57.29577951;
end
function Broach_Bullet:ctor(bullet_id,bullet_mulriple, arm_mul,arm_score,  chair_id, StartPos,angle)
        --cclog("Broach_Bullet:ctor(bullet_id=%d,bullet_mulriple=%d, arm_mul,arm_score=%d,  chair_id=%d, StartPos=(%f,%f),angle=%d)",
        --bullet_id,bullet_mulriple, arm_mul,arm_score,  chair_id, StartPos.x,StartPos.y,angle);
        self:Init();
        if (angle >= 360) then angle = angle-360; end
		if (angle < 0) then angle= angle+360; end
		self.m_bullet_id = bullet_id;
        self.m_hit_check_timer=0;
        self._ReboundBulletTime=0;
		self.m_bullet_mul = bullet_mulriple;
		self.m_arm_mul = arm_mul;
		self.m_Left_mul = arm_mul;
        self.m_mov_speed=1000;
		self.m_arm_score = arm_score;
		self.m_chairid = chair_id;
		self.m_run_angle = angle;
		self.m_mov_position = cc.p(StartPos.x,StartPos.y);
		self.m_start_position = cc.p(StartPos.x,StartPos.y);
		self:PlayUsualAction();
		--添加尾巴
		self.m_run_trail_spr = cc.Sprite:create("haiwang/res/HW/BroachCannonCrab/BroachTail_000_000Ex.png");
		self.m_run_trail_spr:setAnchorPoint(cc.p(1, 0.5));
		self.m_run_trail_spr:setTextureRect(cc.p(self.m_run_start_Length, 0, self.m_run_disLength - self.m_run_start_Length, 105));		
		self:addChild(self.m_run_trail_spr, 10);
		self.m_run_trail_spr:setRotation(self.m_run_angle+90+180);
		--this->scheduleUpdate();                     --激活定时器
		local t_ac_angle =math.rad(self.m_run_angle);
		self.m_run_trail_spr:setPosition(StartPos);
		self.m_mov_spx = self.m_mov_speed* math.sin(t_ac_angle);
		self.m_mov_spy = self.m_mov_speed* math.cos(t_ac_angle);
         local function handler(interval)
             self:update(interval);
        end
        self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
end
function Broach_Bullet:Init()
	self.m_start_position=cc.p(0,0); --起始位置
	self.m_mov_position=cc.p(0,0); --移动位置
	self.m_text_size=cc.rect(0,0,0,0)--最近拖尾纹理大小
	self.m_run_trail_spr=nil; --最近拖尾
	self.m_run_bullet_spr=nil;--子弹精灵
	self.m_run_disLength=0;--拖尾长度
	self.m_run_start_Length=0;--起始长度
	self.m_mov_speed=1000;
     self.g_broach_width=500;
	self.m_mov_spx=0;
	self.m_mov_spy=0;
	self.m_bom_delay_timer=0;
	self.m_bullet_id=0;
	self.m_bullet_mul=0;
	self.m_arm_mu=0;
	self.m_arm_score=0;
	self.m_chairid=0;
	self.m_run_angle=0;
	self.m_rebound_delay=0;
	self.m_rebound_Num=0;
	self.m_bom_flag=0;
	self.m_Left_mul=0;  --移
end
function Broach_Bullet:Bom( force)              --爆破
    if (self.m_bom_flag>0) then return end;
	if (self.m_run_bullet_spr~=nil) then 
     local x,y=self.m_run_bullet_spr:getPosition();
      self.m_mov_position =cc.p(x,y);
    end
	self:removeAllChildren();  
   -- cclog("Broach_Bullet:Bom......self.g_broach_width=%d....self.m_Left_mul=%d............",self.g_broach_width,self.m_Left_mul)
	---通知服务器
	if (cc.exports.g_pFishGroup)then 
      
		cc.exports.g_pFishGroup:Broach_bullet_Bom(self.m_mov_position, self.g_broach_width, self.m_chairid,self.m_Left_mul, self.m_bullet_mul, self.m_bullet_id, 0);
	end
	self.m_bom_flag = 1;
    local file_name ="";
	local _sprite = nil;
	local readIndex = 0;
	local animation = cc.Animation:create();
    local i=0;
    for  i = 0,60, 1 do
    	file_name=string.format("~BroachCannonExplode_000_%03d.png", i);
		local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		if (frame) then						
						    local offset_name=string.format("BroachCannonExplode_000_%03d.png", i);
	                        local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x/2;--
		 	                t_offset_.y = -t_y/2;--
                            frame:setOffsetInPixels(t_offset_);
				            if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					         readIndex=readIndex+1;    
                             animation:addSpriteFrame(frame);
              end --frame
		  end --for
			if (readIndex > 0) then 
                local function action_call_back()
                     self:Bom_End();
                end
			    animation:setDelayPerUnit(1/24.0);
				local action =cc.Animate:create(animation);   
				local t_CCRepeat = cc.Repeat:create(action, 1);
				local  funcall = cc.CallFunc:create(action_call_back);
				local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
				_sprite:runAction(seq);
				_sprite:setScale(3.0);
	      end
		  if (_sprite)then
			_sprite:setPosition(self.m_mov_position);
			self:addChild(_sprite, 10, 1022);
		end
end
function Broach_Bullet:GetPos() return self.m_mov_position; end
function Broach_Bullet:ReboundBullet()--反弹管理

      self._ReboundBulletTime=self._ReboundBulletTime+1;
      if(self._ReboundBulletTime>10) then self:Bom(1); end
     self.m_rebound_Num= self.m_rebound_Num+1;
     --cclog("Broach_Bullet:ReboundBullet  self.m_rebound_Num=%d", self.m_rebound_Num);
	if (self.m_rebound_Num == 4)then 
        -- cclog("Broach_Bullet:ReboundBullet  self.m_rebound_Num=%d  00", self.m_rebound_Num);
		--拖尾向前移动 出屏
		  local t_add_pos = self.m_mov_position;
--			t_add_pos.x = t_add_pos.x+self.m_mov_spx*0.6;
--			t_add_pos.y = t_add_pos.y+self.m_mov_spy*0.6;
--			self.m_run_trail_spr:setTextureRect(cc.rect(self.m_run_start_Length, 0, self.m_run_disLength + (self.m_mov_speed*0.1) - self.m_run_start_Length, 105));--向前延迟
--			self.m_run_trail_spr:setPosition(t_add_pos);
	    	self.m_bom_delay_timer = 0;
	    	if (self.m_run_bullet_spr)then
		          	local t_ccwinsize = cc.Director:getInstance():getWinSize();
		          	local t_CCRotateBy = cc.RotateBy:create(1, 360);
			        local t_CCMoveTo=cc.MoveTo:create(0.5,cc.p(t_ccwinsize.width / 2, t_ccwinsize.height / 2));		
                    local t_ccswap=cc.Spawn:create(t_CCRotateBy,t_CCMoveTo)
			        self.m_run_bullet_spr:runAction(t_ccswap);--cc.Spawn:create(t_CCRotateBy, t_CCMoveTo, nil));
	    	end
        
       -- cclog("Broach_Bullet:ReboundBullet  self.m_rebound_Num=%d  01", self.m_rebound_Num);
	 elseif(self.m_rebound_Num< 4) then --f (m_rebound_Num == 4)
		if (self.m_run_bullet_spr)then 
			self.m_run_bullet_spr:setPosition(self.m_mov_position);
			self.m_run_bullet_spr:setRotation(self.m_run_angle - 90);
		end
		self.m_run_start_Length = self.m_run_disLength;
		--添加新的拖尾
		--添加尾巴
		self.m_run_trail_spr = cc.Sprite:create("haiwang/res/HW/BroachCannonCrab/BroachTail_000_000Ex.png");
		self.m_run_trail_spr:setAnchorPoint(cc.p(1, 0.5));
		self.m_run_trail_spr:setTextureRect(cc.rect(self.m_run_start_Length, 0, self.m_run_disLength - self.m_run_start_Length, 105));
		self:addChild(self.m_run_trail_spr, 10 - self.m_rebound_Num);
		self.m_run_trail_spr:setRotation(self.m_run_angle + 90 + 180);
		self.m_start_position = self.m_mov_position;
	end --elseif(m_rebound_Num< 4)

   
end
function  Broach_Bullet:PlayHitAction()          --碰撞状态
	------------------变色
	--------------------------
		self:removeChildByTag(998);
		local file_name ="";
		local readIndex = 0;
		local animation = cc.Animation:create();
        local i=0;
		for  i = 0,36, 1 do
	    	file_name=string.format("bullet/~BroachCannonAttNode_001_%03d.png", i);
			local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			if (frame) then					
					local offset_name=string.format("BroachCannonAttNode_001_%03d.png", i);
					local t_offset_ = cc.p(0, 0);
                    local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                    local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                    local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                    local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                    local t_offeset_pos=cc.p(0,0);
                    local t_offset_0 = frame:getOffsetInPixels();
                    t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	        t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                    frame:setOffsetInPixels(t_offset_);
				   if (readIndex == 0)then 	self.m_run_bullet_spr=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
		    end --if (frame) then	
        end --end for		
		if (readIndex > 0) then 
            local function actioc_callback()
                  self:PlayUsualAction();
             end
            animation:setDelayPerUnit(1/24);
            local action_=cc.Animate:create(animation);   
			local t_CCRepeat = cc.Repeat:create(action_,3);
			local funcall = cc.CallFunc:create(actioc_callback);
			local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
			self.m_run_bullet_spr:runAction(seq);
		end
		self.m_run_bullet_spr:setRotation(self.m_run_angle-90);
		self:addChild(self.m_run_bullet_spr, 111, 998);
	-------------------
    --播放爆炸特效
	-----------------------------
		local effect_spr = nil;
        local effect_name ="";
		local readIndex = 0;
		local effect_animation = cc.Animation:create();
		for  i = 0,15, 1 do
			effect_name=string.format("BroachHitEff/~BroachHitEff_000_%03d.png", i);
			local  frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			if (frame) then 
                   local offset_name=string.format("BroachHitEff_000_%03d.png", i);
					local t_offset_ = cc.p(0, 0);
                    local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                    local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                    local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                    local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                    local t_offeset_pos=cc.p(0,0);
                    local t_offset_0 = frame:getOffsetInPixels();
                    t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	        t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                    frame:setOffsetInPixels(t_offset_);
				   if (readIndex == 0)then 	effect_spr=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   effect_animation:addSpriteFrame(frame);
			end --if (frame) end
		end --for end
		if (readIndex > 0) then 
            local function call_back_func(args)
               effect_spr:removeFromParent();
            end
             effect_animation:setDelayPerUnit(1/24);
              local action_=cc.Animate:create(animation);   		
			  local t_CCRepeat = cc.Repeat:create(action_, 3);
		  	  local funcall = cc.CallFunc:create(call_back_func);
			  local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
			 effect_spr:runAction(seq);
		end
		effect_spr:setRotation(self.m_run_angle-90);
		self:addChild(effect_spr, 1113);
	--------------------------]]
end
function  Broach_Bullet:PlayUsualAction()   --正常状态
	----------------BG
		self:removeChildByTag(998);
			local file_name ="";
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,36, 1 do
                 file_name=string.format("bullet/~BroachCannonAttNode_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			    if (frame) then				
                            local offset_name=string.format("BroachCannonAttNode_000_%03d.png", i);
				        	local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	               t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                           frame:setOffsetInPixels(t_offset_);
					       if (readIndex == 0)then 	self.m_run_bullet_spr=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					       readIndex=readIndex+1;    
                           animation:addSpriteFrame(frame);
		      end
		  end  -- end for
		if (readIndex > 0) then 
			   animation:setDelayPerUnit(1/24.0);
              	local action =cc.Animate:create(animation);   
			    self.m_run_bullet_spr:runAction(cc.RepeatForever:create(action));
		 end
		self.m_run_bullet_spr:setRotation(self.m_run_angle - 90);
		self.m_run_bullet_spr:setPosition(self.m_mov_position);
		self:addChild(self.m_run_bullet_spr, 111, 998);
	---------------
end
function Broach_Bullet:update(dt)
	if (self.m_bom_flag == 0) then 
         if(dt>0.04) then dt=0.04; end;
		if (self.m_rebound_Num < 4)	then 
			self.m_mov_position.x = self.m_mov_position.x+(self.m_mov_spx*dt);
			self.m_mov_position.y = self.m_mov_position.y +(self.m_mov_spy*dt);
			self:check_edge();         --边沿检测
			self.m_run_disLength = self.m_run_disLength+(self.m_mov_speed*dt);
			if (self.m_run_trail_spr~=nil)	then 
				self.m_run_trail_spr:setTextureRect(cc.rect(self.m_run_start_Length, 0, self.m_run_disLength - self.m_run_start_Length, 105));
				self.m_run_trail_spr:setPosition(self.m_mov_position);
			end
			if (self.m_run_bullet_spr) then self.m_run_bullet_spr:setPosition(self.m_mov_position);end
			if (self.m_rebound_delay > 0) then self.m_rebound_delay = 0; end
            self.m_hit_check_timer=self.m_hit_check_timer+dt;
            if(self.m_hit_check_timer>0.06) then --碰撞检测速度
                  self.m_hit_check_timer=0;
			      if (self.m_Left_mul>0)then
				      if (cc.exports.g_pFishGroup) then 	-------
                           self.m_Left_mul =cc.exports.g_pFishGroup:HitCheck_Broach_Bullet(
                           self.m_mov_position, 30, self.m_chairid, self.m_Left_mul, 
                           self.m_bullet_mul, self.m_bullet_id, self.m_run_angle);
				       end
			     end	
            end -- if(self.m_hit_check_timer>0.06) then 
		else	--	if (self.m_rebound_Num < 4)
			self.m_bom_delay_timer = self.m_bom_delay_timer+dt;
            local x,y= self.m_run_bullet_spr:getPosition();
			self.m_mov_position =cc.p(x,y);
			if (self.m_bom_delay_timer > 0.42)	then	--播放特效
					cc.exports.game_manager_:ShakeScreen();
				    self:Bom(0);             -- //爆破
			end
		end
	end
end
function Broach_Bullet:check_edge( )--         //边沿检测
   
     local t_check_pos=cc.p(self.m_mov_position.x,self.m_mov_position.y);
    local   t_winsize = cc.Director:getInstance():getWinSize();
	if (t_check_pos.x > 0 
    and t_check_pos.x < t_winsize.width
    and t_check_pos.y>0 
    and  t_check_pos.y < t_winsize.height)
	then self.m_rebound_delay = 0;return;--在屏幕范围
	elseif (self.m_rebound_delay == 0) then --逆向查找最近屏外点
        --cclog("Bullet:check_edge 00");
        local t_rot_time=0;
		self.m_mov_spx = self.m_mov_spx / self.m_mov_speed;
		self.m_mov_spy = self.m_mov_spy / self.m_mov_speed;
		while (
        (
          self.m_mov_position.x < 0 
          or self.m_mov_position.y <0
          or self.m_mov_position.x > t_winsize.width
          or self.m_mov_position.y >t_winsize.height)
           and t_rot_time<6)
		 do
            t_rot_time=t_rot_time+1;
			self.m_mov_position.x=self.m_mov_position.x-(5 * self.m_mov_spx);
			self.m_mov_position.y=self.m_mov_position.y-(5 * self.m_mov_spy);
		 end
         --]]
		--位置关系
		local  t_start_v = cc.p(0,0);
         t_start_v.x=t_check_pos.x- self.m_start_position.x;
         t_start_v.y=t_check_pos.y- self.m_start_position.y;
        --  cclog(" Bullet:check_edge x=%f,y=%f", t_start_v.x,t_start_v.y);
		self.m_rebound_delay = 1;
		if (self.m_run_angle == 45 or self.m_run_angle == 135	or self.m_run_angle == 225	or self.m_run_angle == 315)then 	self.m_run_angle = self.m_run_angle+180;
		elseif (self.m_run_angle == 270) then self.m_run_angle = 90; 
		elseif (self.m_run_angle == 90) then self.m_run_angle = 270;
		elseif (self.m_run_angle == 0)then self.m_run_angle = 180;
		elseif (self.m_run_angle == 180)then self.m_run_angle = 0;
		elseif ((t_check_pos.x < 0 and t_check_pos.y< 0)
			or (t_check_pos.x>t_winsize.width and t_check_pos.y< 0)
			or (t_check_pos.x<0 and t_check_pos.y>t_winsize.height)
			or (t_check_pos.x > t_winsize.width and t_check_pos.y > t_winsize.height)
			)
		then self.m_run_angle = self.m_run_angle+180;
		elseif (t_check_pos.x < 0) then --左边出界 x对称
			t_start_v.x = 0-t_start_v.x;
			self.m_run_angle = self:mm_getAngle_by_xy_(t_start_v.x, t_start_v.y);
		elseif (t_check_pos.x > t_winsize.width) then 
			t_start_v.x = 0-t_start_v.x;
			self.m_run_angle = self:mm_getAngle_by_xy_(t_start_v.x, t_start_v.y);
		elseif (t_check_pos.y < 0)		then--Y对称
			t_start_v.y = 0-t_start_v.y;
			self.m_run_angle = self:mm_getAngle_by_xy_(t_start_v.x, t_start_v.y);
		elseif (t_check_pos.y > t_winsize.height) then 
			t_start_v.y = 0-t_start_v.y;
			self.m_run_angle = self:mm_getAngle_by_xy_(t_start_v.x, t_start_v.y);
	    end
		--while (self.m_run_angle >= 360) do self.m_run_angle = self.m_run_angle-360; end
		--while (self.m_run_angle < 0) do self.m_run_angle = self.m_run_angle+360; end
		local  t_ac_angle = math.rad(self.m_run_angle);
		self.m_mov_spx = self.m_mov_speed*math.sin(t_ac_angle);
		self.m_mov_spy = self.m_mov_speed*math.cos(t_ac_angle);
        -- cclog("Bullet:check_edge m_mov_position(%f,%f) m_start_position(%f,%f) m_mov_spx=%f,m_mov_spy=%f,m_run_angle=%f",
         --self.m_mov_position.x,self.m_mov_position.y,self.m_start_position.x,self.m_start_position.y,self.m_mov_spx,self.m_mov_spy,self.m_run_angle);
		self:ReboundBullet();      
    end
end
function Broach_Bullet:Bom_End()        --
  --  cclog(" Broach_Bullet:Bom_End self.m_chairid=%d--------------------------------------------------------------------------",self.m_chairid);
	cc.exports.g_cannon_manager:Exit_Broach(self.m_chairid);
     self:removeFromParent();
end
return Broach_Bullet;
--endregion

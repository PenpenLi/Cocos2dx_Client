--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/22
--此文件由[BabeLua]插件自动生成


local Free_Bullet = class("Free_Bullet",
 function()
	return cc.Node:create()
end
)
function Free_Bullet:ctor(bullet_id, bullet_mulriple,  arm_mul,  arm_score,   chair_id,  StartPos,  angle, locak_id)
   -- cclog("Free_Bullet:ctor 00");
     net_radius=15;
     self._ReboundBulletTime=0;
     self:Init();
     self.bullet_kind_=8;
     self.m_bulletID = bullet_id;
	 self. m_bullet_Mul = bullet_mulriple;
	 self.m_chair_id = chair_id;
	 self.m_run_angle = angle;
	 self.m_lock_id = locak_id;

	 self. m_bom_delay_timer=0;
 	 self.m_rebound_delay=0;
     self.m_mov_speed=1000;
	 self.m_bom_flag = 0;
	 self.m_start_position = cc.p(StartPos.x,StartPos.y); --起始位置
	 self.m_mov_position = cc.p(StartPos.x,StartPos.y); --移动位置
     --------------
	local file_name = "";
    local _sprite = nil;
    local readIndex = 0;
    local animation = cc.Animation:create();
    local i = 0;
    for i = 0, 11, 1 do
       file_name = string.format("~FreeBullet_000_%03d.png", i);
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
        if (frame) then
            local offset_name = string.format("FreeBullet_000_%03d.png", i);
		    local t_offset_ = cc.p(0, 0);
            local t_offect_str = cc.exports.OffsetPointMap[offset_name].Offset;
            local t_s_sub_x, t_s_sub_y = string.find(t_offect_str, ",");
            local t_x = string.sub(t_offect_str, 0, t_s_sub_x - 1);
            local t_y = string.sub(t_offect_str, t_s_sub_y + 1, #t_offect_str);
            local t_offeset_pos = cc.p(0, 0);
            local t_offset_0 = frame:getOffsetInPixels();
            t_offset_.x = t_x / 2;
            t_offset_.y = - t_y / 2;
            frame:setOffsetInPixels(t_offset_);
            if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
            readIndex = readIndex + 1;
            animation:addSpriteFrame(frame);
			 if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
             readIndex = readIndex + 1;
            animation:addSpriteFrame(frame);
      end -- if (frame)
   end --for
	if (readIndex > 0) then 
				  animation:setDelayPerUnit(1 / 30.0);
                  local action = cc.Animate:create(animation);
				_sprite:runAction(cc.RepeatForever:create(action));
	end
			if (_sprite) then  self:addChild(_sprite); end
			self:setPosition(StartPos);
			self:setRotation(self.m_run_angle-90);
			local  t_ac_angle = math.rad(self.m_run_angle);
			self.m_mov_spx = self.m_mov_speed* math.sin(t_ac_angle);
			self.m_mov_spy = self.m_mov_speed* math.cos(t_ac_angle);



      local bullet_hit_node=cc.Node:create();
      local body = cc.PhysicsBody:createCircle(net_radius);
      body:setGroup(-1);
      body:setGravityEnable(false);
      body:setContactTestBitmask(1);
     bullet_hit_node:setPhysicsBody(body);
     self:addChild(bullet_hit_node,0,7758258);
	-----------------------
    local function handler(interval)
        self:update(interval);
    end
    self:scheduleUpdateWithPriorityLua(handler, 0);
   --  cclog("Free_Bullet:ctor 01");
end
function	Free_Bullet:Init()
     self.m_bom_flag=0;
     self._check_hit_timer=0;
	 self.m_bulletID=0;
	 self.m_bullet_Mul=0;
	 self.m_chair_id=0;
	 self.m_mov_speed=1000;
	 self.m_mov_spx=0;
	 self.m_mov_spy=0;
	 self.m_bom_delay_timer=0;
	 self. m_run_angle=0;
	 self.m_lock_id=0;
	 self.m_rebound_delay=0;
	 self.m_start_position=cc.p(0,0); --起始位置
	 self.m_mov_position=cc.p(0,0);--移动位置
end
function	Free_Bullet:update( delta) 
	if (self.m_bom_flag == 0)then
         if(delta>0.04) then delta=0.04; end;
		 self.m_mov_position.x =  self.m_mov_position.x + self.m_mov_spx*delta;
		 self.m_mov_position.y =  self.m_mov_position.y + self.m_mov_spy*delta;
		 self:check_edge();         --边沿检测
		 self:setPosition(self.m_mov_position);
		 if ( self.m_rebound_delay > 0) then  self.m_rebound_delay = 0; end
         if(self.m_lock_id>0) then 
            self._check_hit_timer=self._check_hit_timer+delta;
            if(self._check_hit_timer>0.05)  then --碰撞检测速度
               self._check_hit_timer=0;
               local fish=cc.exports.g_pFishGroup:GetFish(self.m_lock_id);
               if(fish)then 
                   if(fish:IfCanCatchQuick_Ex()==true) then 
                        local t_pos=fish:GetFishPos();
                        local dx=t_pos.x-self.m_mov_position.x;
                        local dy=t_pos.y-self.m_mov_position.y;
                        self.m_run_angle = self:mm_getAngle_by_xy_(dx, dy);
                        self:setRotation(self.m_run_angle - 90);
                        local  t_ac_angle = math.rad(self.m_run_angle);
		                self.m_mov_spx = self.m_mov_speed*math.sin(t_ac_angle);
		                self.m_mov_spy = self.m_mov_speed*math.cos(t_ac_angle);
                    else  self.m_lock_id=-1; end
                else  self.m_lock_id=-1; end
             end
        end
    else
      self.m_bom_delay_timer=self.m_bom_delay_timer+delta;
      if(self.m_bom_delay_timer>10) then 
         self.m_bom_delay_timer=0;
         self:removeAllChildren();
         self:removeFromParent();
      end
	end
end
function Free_Bullet:catch_fish_(fish)
         if (self.m_bom_flag == 0) then 
            if(self.m_lock_id>0 and fish:fish_id()~=self.m_lock_id) then return ;end;
            if( cc.exports.g_pFishGroup:freebullet_catchfish(self,fish)==true) then 
               self:removeChildByTag(7758258);
               self:Bom();
              --self:CastingNet();
          end      
    end
end
function Free_Bullet:getbom_flag()
   return self.m_bom_flag;
end
function	Free_Bullet:ReboundBullet()--反弹管理
    self._ReboundBulletTime=self._ReboundBulletTime+1;
    
    self.m_lock_id = -1;
	self:setPosition(self.m_mov_position);
	self:setRotation(self.m_run_angle - 90);
	self.m_start_position = cc.p(self.m_mov_position.x,self.m_mov_position.y);
    if(self._ReboundBulletTime>100) then self:Bom(); end
end

function	Free_Bullet:check_edge( )        --边沿检测
   --cclog("Free_Bullet:check_edge 00");
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

function	Free_Bullet:Bom()             --爆破	
    if(self.m_bom_flag>0) then return ;end;
    self:removeAllChildren();
    self.m_bom_flag =1;
	--BG
	local file_name = "";
    local _sprite = nil;
    local readIndex = 0;
    local animation = cc.Animation:create();
    local i = 0;
    for i = 0, 41, 1 do
	  file_name = string.format("~FreeNet_000_%03d.png", i);
      local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
       if (frame) then	
		    local offset_name = string.format("FreeNet_000_%03d.png", i);
            local t_offset_ = cc.p(0, 0);
            local t_offect_str = cc.exports.OffsetPointMap[offset_name].Offset;
            local t_s_sub_x, t_s_sub_y = string.find(t_offect_str, ",");
            local t_x = string.sub(t_offect_str, 0, t_s_sub_x - 1);
            local t_y = string.sub(t_offect_str, t_s_sub_y + 1, #t_offect_str);
            local t_offeset_pos = cc.p(0, 0);
            local t_offset_0 = frame:getOffsetInPixels();
            t_offset_.x = t_x / 2;
            -- t_offset_.x * 10/ 20;
            t_offset_.y = - t_y / 2;
            -- t_offset_.y * 10/ 20;
            frame:setOffsetInPixels(t_offset_);
            if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
            readIndex = readIndex + 1;
            animation:addSpriteFrame(frame);
        end
	end
	if (readIndex > 0) then
            local function  call_back_()
               self:removeFromParent();
            end
			animation:setDelayPerUnit(1 / 24.0);
            local action = cc.Animate:create(animation);
			local t_CCRepeat=cc.Repeat:create(action, 1);
			local t_callfunc = cc.CallFunc:create(call_back_);
			local t_seq=cc.Sequence:create(t_CCRepeat, t_callfunc, nil);
			_sprite:runAction(t_seq);
	end
	if (_sprite)then  self:addChild(_sprite);		
	else self:removeFromParent(); end
end

function Free_Bullet:firer_chair_id()  return self.m_chair_id;  end
function Free_Bullet:bullet_id()  return self.m_bulletID;     end
function Free_Bullet:bullet_kind() return self.bullet_kind_; end
function Free_Bullet:bullet_mulriple()  return self.m_bullet_Mul; end
function Free_Bullet:net_radius()  return self.net_radius_;  end
function Free_Bullet:set_lock_fishid( fish_id)  self.m_lock_id = fish_id; end
function Free_Bullet:lock_fishid()  return self.m_lock_id;  end
function  Free_Bullet:getChair_id()return self.m_chair_id;  end
function  Free_Bullet:get_mov_pos()
      return cc.p(self.m_mov_position.x,self.m_mov_position.y);
end

function	Free_Bullet:mm_getAngle_by_xy_( x,  y)
   --cclog(" Bullet:mm_getAngle_by_xy_ x=%f,y=%f",x,y);
     local  len_y = y;
	 local len_x = x;
	if (len_y >= -0.00001 and len_y <= 0.00001)then
		if (len_x < 0)then 	return 270;
		else   return 90;  end
	end
	if (len_x >= -0.00001 and len_x <= 0.00001)then 
		if (len_y >= 0)then return 0; 
		else return 180; end
	end
	return  math.atan2(len_x, len_y) *57.29577951;
end
return Free_Bullet;

--endregion
--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/18
--此文件由[BabeLua]插件自动生成
local Bullet = class("Bullet",
 function()
	return cc.Node:create()
end
)
function Bullet:ctor( bullet_kind,  bullet_id,  bullet_mulriple,  firer_chair_id,  net_radius, pos, speed, angle, LockID)
     net_radius=15;
    self.bullet_kind_ = 0;
	 self.net_radius_ = 1;
	 self.m_rebound_delay = 0;
     self._ReboundBulletTime=0;
	 self.m_bom_flag = 0;
	 self.m_bulletID = 0;
	 self.m_bullet_Mul = 0;
	 self.m_chair_id = 0;
	 self.m_mov_speed = 0;
	 self.m_mov_speed = 800;
	 self.m_mov_spx = 0;
	 self.m_mov_spy = 0;
     self.m_alive_timer=0;
	 self.m_bom_delay_timer = 0;
	 self.m_run_angle = 0;
	 self.m_lock_id = LockID;
     self._check_hit_timer=0;
     self._ReboundBulletTime=0;
     self.m_mov_position=cc.p(0,0);
    -- cclog("Bullet:ctor  bullet_kind=%d,  bullet_id=%d,  bullet_mulriple=%d,  firer_chair_id=%d,  net_radius=%f, pos(%f,%f), speed=%d, angle=%f, LockID=%d",
     --bullet_kind,  bullet_id,  bullet_mulriple,  firer_chair_id,  net_radius, pos.x,pos.y, speed, angle, LockID);
     self:Init(bullet_kind, bullet_id, bullet_mulriple, firer_chair_id, net_radius, pos, speed, angle,LockID)
      local bullet_hit_node=cc.Node:create();
      local body = cc.PhysicsBody:createCircle(net_radius);
      body:setGroup(-1);
      body:setGravityEnable(false);
      body:setContactTestBitmask(1);
      bullet_hit_node:setPhysicsBody(body);
      self:addChild(bullet_hit_node,0,7758258);
    
end
function Bullet:Init(bullet_kind,  bullet_id,  bullet_mulriple,  firer_chair_id,  net_radius,  pos,  speed,  angle,  LockID) 
	    self.bullet_kind_=bullet_kind;
		self.m_bulletID = bullet_id;
		self.m_bullet_Mul = bullet_mulriple;
		self.m_chair_id = firer_chair_id;
		self.m_run_angle =math.deg(angle);
		self.m_lock_id = LockID;
		self.m_bom_delay_timer = 0;
		self.m_rebound_delay = 0;
		self.m_bom_flag = 0;
		self.m_start_position =cc.p(pos.x,pos.y); --起始位置
		self.m_mov_position = cc.p(pos.x,pos.y); --移动位置
		self.m_mov_speed = speed;
         if(self.m_chair_id>=0 and self.m_chair_id<10)  then
           cc.exports.g_game_player_bullet_num_list[self.m_chair_id]= cc.exports.g_game_player_bullet_num_list[self.m_chair_id]+1;
        end
        --添加精灵 双倍弹改为急速弹
        local t_kind = bullet_kind;
        local file_name="";
		if (t_kind == 0) then t_kind = 1; end
		if (t_kind == 4) then t_kind = 5; end
        if (t_kind<4)	 then file_name=string.format("~Bullet%d_000_000.png", t_kind);
		else              file_name=string.format("~Bullet%d_000_000.png", t_kind + 1); end
        local  _sprite = cc.Sprite:createWithSpriteFrameName(file_name);
        if (_sprite~=nil) then self:addChild(_sprite);
        else --使用默认子弹
        	_sprite =cc.Sprite:createWithSpriteFrameName("~Bullet1_000_000.png");			
			if (_sprite) then  self:addChild(_sprite);end
        end
        --if (self.bullet_kind_ < 4) then _sprite:setScale(0.7); end
        _sprite:setScale(1.2);
        --
       self:setPosition(pos);
		self:setRotation(self.m_run_angle - 90);
		local t_ac_angle = math.rad(self.m_run_angle);
		self.m_mov_spx = self.m_mov_speed*math.sin(t_ac_angle);
		self.m_mov_spy = self.m_mov_speed*math.cos(t_ac_angle);
        --
        local function handler(interval)
            self:update(interval);
       end
      self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
end
function Bullet:bullet_id()  return self.m_bulletID;     end
function Bullet:bullet_kind() return self.bullet_kind_; end
function Bullet:bullet_mulriple()  return self.m_bullet_Mul; end
function Bullet:firer_chair_id()  return self.m_chair_id;  end
function Bullet:net_radius()  return self.net_radius_;  end
function Bullet:set_lock_fishid( fish_id)  self.m_lock_id = fish_id; end
function Bullet:lock_fishid()  return self.m_lock_id;  end
function  Bullet:getChair_id()return self.m_chair_id;  end
function  Bullet:get_mov_pos()
      return cc.p(self.m_mov_position.x,self.m_mov_position.y);
end
function Bullet:getbom_flag()
   return self.m_bom_flag;
end
function Bullet:getAliveTimer()
   return self.m_alive_timer;
end
function Bullet:update(delta)
    if(delta>0.04) then delta=0.04; end;
    self.m_alive_timer=self.m_alive_timer+delta;
   
	if (self.m_bom_flag == 0)then
        if(delta>0.04) then delta=0.04; end;
		self.m_mov_position.x = self.m_mov_position.x+(self.m_mov_spx*delta);
		self.m_mov_position.y= self.m_mov_position.y+ (self.m_mov_spy*delta);
		self:check_edge();         --边沿检测
		self:setPosition(self.m_mov_position);
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
           if(self.m_chair_id>=0 and self.m_chair_id<10 and cc.exports.g_game_player_bullet_num_list[self.m_chair_id]>0)  then
               cc.exports.g_game_player_bullet_num_list[self.m_chair_id]= cc.exports.g_game_player_bullet_num_list[self.m_chair_id]-1;
            end
          self:removeFromParent();
      end
	end
     if(self.m_alive_timer>120) then --2分钟空闲强制爆炸
        if (self.m_bom_flag == 0) then      
            self:CastingNet();
         else 
            if(self.m_chair_id>=0 and self.m_chair_id<10 and cc.exports.g_game_player_bullet_num_list[self.m_chair_id]>0)  then
               cc.exports.g_game_player_bullet_num_list[self.m_chair_id]= cc.exports.g_game_player_bullet_num_list[self.m_chair_id]-1;
            end
            self:removeFromParent();
        end
    end
end
function Bullet:catch_fish_(fish)
     if(fish) then 
       if (self.m_bom_flag == 0) then 
          if(self.m_lock_id>0 and fish:fish_id()~=self.m_lock_id) then return ;end;
          if( cc.exports.g_pFishGroup:bullet_catchfish(self,fish)==true) then 
              -- cclog("Bullet:catch_fish_  self.m_alive_timer>120");
              self:removeChildByTag(7758258);
              self:CastingNet();
          end      
       end
    end
    
end
function Bullet:GetTargetPoint(firer_chair_id,  src_x_pos,  src_y_pos,  angle, target_x_pos, target_y_pos)end
function Bullet:IsValid()end
function Bullet:ReboundBullet()--反弹管理
   -- cclog(" Bullet:ReboundBullet ");
    self._ReboundBulletTime=self._ReboundBulletTime+1;   
    self.m_lock_id = -1;
	self:setPosition(self.m_mov_position);
	self:setRotation(self.m_run_angle - 90);
	self.m_start_position = cc.p(self.m_mov_position.x,self.m_mov_position.y)
    if(self._ReboundBulletTime>100) then self:CastingNet(); end
end
function  Bullet:check_edge( )        --边沿检测
    local t_check_pos=cc.p(self.m_mov_position.x,self.m_mov_position.y);
    local   t_winsize = cc.Director:getInstance():getWinSize();
	if (t_check_pos.x > 0 
    and t_check_pos.x < t_winsize.width
    and t_check_pos.y>0 
    and  t_check_pos.y < t_winsize.height)
	then self.m_rebound_delay = 0;return;--在屏幕范围
	elseif (self.m_rebound_delay == 0) then --逆向查找最近屏外点    
        --cclog("Bullet:check_edge 00");      
        local t_search_time=0;
		self.m_mov_spx = self.m_mov_spx / self.m_mov_speed;
		self.m_mov_spy = self.m_mov_spy / self.m_mov_speed;
		while ((self.m_mov_position.x < 0 or self.m_mov_position.y <0 or self.m_mov_position.x > t_winsize.width or self.m_mov_position.y >t_winsize.height)
               and t_search_time<4
          )
		 do
            t_search_time=t_search_time+1;
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
function Bullet:mm_getAngle_by_xy_( x,  y)
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

function Bullet:CastingNet()
    --cclog("Bullet:CastingNet00000000000");
    if(self.m_bom_flag>0) then return;  end;
    self.m_bom_delay_timer = 0;
	self.m_bom_flag =1;
	self:removeAllChildren();
   
   --BG   
	local readIndex = 0;
	local _sprite=nil;
    local animation = cc.Animation:create();
    local i=0;
    local spriteFrame  = cc.SpriteFrameCache:getInstance();  
    local t_net_color=self.m_chair_id%4;
	for  i = 0,12,1 do
            local path_str="";
			if (self.bullet_kind_<4) then 	path_str=string.format("Net%d/~Net03_000_%03d.png", t_net_color ,i);
			else 	path_str=string.format("NetA%d/~NetA_000_%03d.png", t_net_color ,i); end;
            local blinkFrame = spriteFrame:getSpriteFrame(path_str) ;
            if(blinkFrame) then				
				local  offset_name="";
				if (self.bullet_kind_ < 4) then 	offset_name=string.format("Net03_000_%03d.png", i);
				else 	offset_name=string.format("NetA_000_%03d.png", i); end
				--if (cc.exports.g_offsetBullet_InitFlag[self.bullet_kind_]<0.111)	then 
                   --     cc.exports.g_offsetBullet_InitFlag[self.bullet_kind_]=1;
						local t_offset_ = cc.p(0, 0);
                        local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                        local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                        local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                        local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                       -- local t_offeset_pos=cc.p(0,0);
                       -- local t_offset_0 = blinkFrame:getOffsetInPixels();
                        t_offset_.x =t_x;--t_offset_.x * 10/ 20;
		 	            t_offset_.y = -t_y;--t_offset_.y * 10/ 20;   
                        blinkFrame:setOffsetInPixels(t_offset_);
				--end		
			    if(readIndex) then _sprite=cc.Sprite:createWithSpriteFrameName(path_str) ;end
                readIndex=readIndex+1;    
                animation:addSpriteFrame(blinkFrame);
			end
	end
    local function Endcallback()   
             if(self.m_chair_id>=0 and self.m_chair_id<10 and cc.exports.g_game_player_bullet_num_list[self.m_chair_id]>0)  then
               cc.exports.g_game_player_bullet_num_list[self.m_chair_id]= cc.exports.g_game_player_bullet_num_list[self.m_chair_id]-1;
            end  
            self:removeFromParent();   
     end;
     --cclog("Bullet:CastingNet111111");
     if (readIndex > 0)then 
            animation:setDelayPerUnit(1 / 24.0);
			local action =cc.Animate:create(animation);         
			local  t_CCRepeat = cc.Repeat:create(action,2);
			local  t_CCFadeOut=cc.FadeOut:create(0.3);
			local  t_callfunc = cc.CallFunc:create(Endcallback);
			local  t_seq = cc.Sequence:create(t_CCRepeat, t_CCFadeOut, t_callfunc, nil);
            -- cclog("Bullet:CastingNet222222222");
			_sprite:runAction(t_seq);
	  end
		local tem_kind_ = self.bullet_kind_ % 4;
		local t_scale = 0.5;
		if (tem_kind_ == 0)  then t_scale=0.5; end
		if (tem_kind_ == 1) then t_scale=0.6; end
		if (tem_kind_ == 2) then t_scale=0.7; end
		if (tem_kind_ == 3) then t_scale=0.8; end
		if (_sprite)	then
           if(self.bullet_kind_>4)then _sprite:setScale(t_scale*1.3);
			else _sprite:setScale(t_scale); end
			self:addChild(_sprite);
			--添加爆炸光环		
			   local t_path = "haiwang/res/HW/Particle/ring3.png";
				t_sprframe =spriteFrame:getSpriteFrame(t_path);
				if (t_sprframe==nil) then
					t_sprframe =cc.SpriteFrame:create(t_path, cc.rect(0, 0, 512, 512));
					spriteFrame:addSpriteFrame(t_sprframe, t_path);
				end
				local t_ring =cc.Sprite:createWithSpriteFrame(t_sprframe);
				if(t_ring~=nil) then 
					t_ring:setScale(0.0);
					local t_scaleto = cc.ScaleTo:create(0.4, t_scale*0.85);
					local t_fadeout = cc.FadeOut:create(0.15);
                    local t_delay=cc.DelayTime:create(0.2);
					local t_seq = cc.Sequence:create(t_delay, t_fadeout, nil);
					t_ring:setAnchorPoint(cc.p(0.5, 0.5));
                    t_ring:runAction(t_scaleto);
					t_ring:runAction(t_seq);
                    self:addChild(t_ring, -1);
				end
		end
        --音效
	    cc.exports.g_soundManager:PlayGameEffect("bulletbaozha");
end


return Bullet;
--endregion

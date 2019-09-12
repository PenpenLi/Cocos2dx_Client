--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/7
--此文件由[BabeLua]插件自动生成
  Bird = class("Bird",cc.exports.Fish)
  function Bird:ctor(fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay)
     self.m_rot_flag=0;
     Bird.super.ctor(self,fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay);
  end
  function Bird:PlayWalkAction( tag )--//播放走路动作
    local t_fish_kind = self.fish_kind_;
	if (self.fish_kind_ >= 30 and self.fish_kind_ <= 39) then 
		t_fish_kind = self.fish_kind_-30;
	end
    local file_name ="";
    local readIndex = 0;
	local animFrames = cc.Animation:create();
    local animFrames_stopf = cc.Animation:create();
    local fish_spr=nil;
    local i=0;
	for  i = 0,40, 1 do
        file_name=string.format("animal%d_%d0_%02d.png", t_fish_kind, 0, i);
		local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		if(frame) then		
            if(readIndex == 0)then 
             	fish_spr=cc.Sprite:createWithSpriteFrame(frame);
                animFrames_stopf:addSpriteFrame(frame);
                animFrames_stopf:addSpriteFrame(frame);
             end
			 readIndex=readIndex+1;    
             animFrames:addSpriteFrame(frame);
        end
     end --for i
      if(readIndex > 0) then 		
        self.baseAngle = 0;
		local t_frame_speed = game_fish_frame_Speed[t_fish_kind];
        animFrames:setDelayPerUnit(t_frame_speed);
        animFrames_stopf:setDelayPerUnit(2+ math.random()%3);
		local animation = cc.Animate:create(animFrames);
        local animation_stop = cc.Animate:create(animFrames_stopf);
		local t_repeat_1 =cc.Repeat:create(animation,1);
        local t_repeat_2 =cc.Repeat:create(animation_stop,1);
        local t_seq = cc.Sequence:create(t_repeat_1,t_repeat_2,nil);
        local t_repeat = cc.RepeatForever:create(t_seq)
        fish_spr:runAction(t_repeat);	
		self.fis_node:addChild(fish_spr, 0, tag);	
       end	--	if (readIndex > 0) then		
       self:AddKind_Effect();	
  end
  function Bird:OnFrame( delta_time,  lock)
     if(delta_time>0.04) then delta_time=0.04; end;
	if(self.fish_status_== 0) then 	
		self.m_nFishDieCount = 0;
		self.fish_status_ = 1;
		self.fis_node:setPosition(cc.p(self.m_mov_list[0].x, self.m_mov_list[0].y));
		if (self.fis_node:isVisible()==false) then self.fis_node:setVisible(true); end
		self:CheckValid();
		return false;
	end
	if (self.fish_status_ == 1) then
		if (self.m_no_catch_flag>0) then 	
			self.m_king_catch_delay=self.m_king_catch_delay+delta_time;
			if (self.m_king_catch_delay > 10) then 		
				self:CatchFish(self.m_king_catch_chair_id, self.m_king_catch_score, 0, 0);
			end
			return false;
		end
		local t_winSize = cc.Director:getInstance():getWinSize();
        local px,py=self.fis_node:getPosition();
		local  t_pos =cc.p(px,py); 
		self:CheckValid();--//和屏幕碰撞半段	
		if (self.m_Alive_Step == 0) then  --//只能一次进入屏幕	
			if (self.valid_==true) then m_Alive_Step = 1; end
			if (t_pos.x<-1000 or t_pos.x>(t_winSize.width + 1000) or t_pos.y<-1000 or t_pos.y>(t_winSize.height + 1000)) then
               self:exit_self();
               return true;
              end
		else
			if (t_pos.x<-300 or t_pos.x>(t_winSize.width + 300) or t_pos.y<-300 or t_pos.y>(t_winSize.height + 300)) then 
                self:exit_self();
                return true; 
            end	
		end
		if (self.m_mov_delay > 0.0001) then 
			self.m_mov_delay = self.m_mov_delay-delta_time;
		else--//移动
			if (self.m_rot_flag>0) then 		
				self.m_rot_angle =self.m_rot_angle+self.m_rot_speed;
				if (self.m_rot_speed > 0 and self.m_rot_angle > self.m_rot_to_angle) then 				
					self.m_rot_flag = 0;			
				elseif (self.m_rot_speed < 0 and self.m_rot_angle < self.m_rot_to_angle) then 
					self.m_rot_flag = 0;
				end
				self.fis_node:setRotation(self.m_rot_angle);
				self.m_mov_sin_f =self.m_mov_Speed * 30 * math.sin(self.m_rot_angle*0.01745329);
				self.m_mov_cos_f =self.m_mov_Speed * 30 * math.cos(self.m_rot_angle*0.01745329);			
			end			
			local t_mov_dis = self.m_mov_Speed * 30 * delta_time;
			self.m_mov_dis =self.m_mov_dis+ t_mov_dis;
			if (self.m_mov_dis > self.m_mov_dis_max) then 		
				if (self:MovTo_Next() < 0)	then
                 self:exit_self();
                 return true; 
                 end
			else
				self.m_mov_pos_.x =self.m_mov_pos_.x+self.m_mov_sin_f* delta_time;
				self.m_mov_pos_.y =self.m_mov_pos_.y+ self.m_mov_cos_f* delta_time;
				if (self.fis_node) then 				
					self.fis_node:setPosition(self.m_mov_pos_);
				end
			end
	  end
      --]]
	else --//死亡	
       -- cclog("Bird:OnFrame dd self.m_mov_timer =%f self.m_nFishDieCount=%f",self.m_mov_timer,self.m_nFishDieCount);
		self.m_mov_timer = self.m_mov_timer+delta_time;
		if (self.m_mov_timer > 0.0333334)then 
			self.m_mov_timer =self.m_mov_timer-  0.0333334;
			self.m_nFishDieCount=self.m_nFishDieCount+1;
			if (self.m_nFishDieCount >= 50) then
                 -- cclog("Bird:OnFrame dd self.m_mov_timer =%f self.m_nFishDieCount=%f kkkk",self.m_mov_timer,self.m_nFishDieCount);
                  self:exit_self();			
				return true;
			end
		end
	end
	return false;
end

function Bird:MovTo_Next()
	self.m_mov_index=self.m_mov_index+1;
	if (self.m_mov_index<self.m_mov_point_num) then	
         local px,py= self.fis_node:getPosition();	
	    self.m_mov_start_pos=cc.p(px,py);
		local t_dis_x = self.m_mov_list[self.m_mov_index].x - self.m_mov_start_pos.x;
		local t_dis_y = self.m_mov_list[self.m_mov_index].y - self.m_mov_start_pos.y;
		local temp_angle = math.atan2(t_dis_x,t_dis_y);
		self.m_mov_sin_f = self.m_mov_Speed * 30 * math.sin(temp_angle);
		self.m_mov_cos_f = self.m_mov_Speed * 30 * math.cos(temp_angle);
		self.m_mov_pos_ = self.m_mov_start_pos;
		self.m_mov_dis = 0;
		self.m_mov_dis_max = math.sqrt((t_dis_x*t_dis_x) + (t_dis_y*t_dis_y));
		if (self.fis_node) then 		
			local t_run_angle = self.fis_node:getRotation();
			local t_new_angle =temp_angle*180/3.1415926;-- MySriteCache::GetAngleForRadian(temp_angle);	
			self.fis_node:setPosition(self.m_mov_pos_);		
			if(t_run_angle < 0) then t_run_angle =t_run_angle+360; end
			if (t_new_angle < 0) then t_new_angle =t_new_angle+360; end
			local t_dis_angle = t_new_angle - t_run_angle;	
			if (self.m_mov_index>1 and(t_dis_angle > 1.000001 or t_dis_angle<-1.0)) then 
				if (t_dis_angle < -180) then t_new_angle =t_new_angle+ 360; 
				elseif(t_dis_angle >180) then t_new_angle = t_new_angle-360; end
				 t_dis_angle = t_new_angle - t_run_angle;
				 self.m_rot_flag=1;    --//转弯标记
				 self.m_rot_angle = t_run_angle;-- //当前进度
				 self.m_rot_to_angle = t_new_angle;--//目标进度
				 if (t_dis_angle>0) then self.m_rot_speed =1;   -- //旋转速度
				 else self.m_rot_speed = -1;   end-- //旋转速度			
			else 
			self.fis_node:setRotation(t_new_angle);
            end
		end
		return 1;
	else	
		local temp_angle = self.fis_node:getRotation()*3.1415926 / 180.0;
		self.m_mov_sin_f = self.m_mov_Speed * 30 * math.sin(temp_angle);
		self.m_mov_cos_f = self.m_mov_Speed * 30 * math.cos(temp_angle);
		self.m_mov_pos_ = self.m_mov_start_pos;
		self.m_mov_dis = 0;
        local px,py=self.fis_node:getPosition();
		self.m_mov_start_pos =cc.p(px,py); --//一直向前走
		self.m_mov_pos_ = self.m_mov_start_pos;
		self.m_mov_dis = 0;
		self.m_mov_dis_max = 2000;
		return 1;
	end
end
function Bird:CatchFish(chair_id,score,bulet_mul,fish_mul,bomFlag)
     cclog(" Bird:CatchFish(chair_id=%d,score=%d,bulet_mul=%d,fish_mul=%d,bomFlag)",chair_id,score,bulet_mul,fish_mul);
     cc.exports.g_soundManager:PlayGameEffect("effect_catch");
	self.fis_node:removeChildByTag(7758258);
	self.fis_node:removeChildByTag(7758258);
	self.fis_node:removeChildByTag(8888);
	self.fis_node:removeChildByTag(775825);
    self.catch_mul=fish_mul;
	self.fish_status_ = 2;
	if (self.fis_node)then
		self.fis_node:removeAllChildren();
		self:PlayDieAction(10086);
	end
   local cannon_pos =  cc.exports.g_cannon_manager:GetCannonPos(chair_id,0);
	self:AddWin_Effect(chair_id, score,cannon_pos);	
end

 return Bird;
--endregion

--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成
--//<!--霸王蟹-->
 fishSuperCrab = class("fishSuperCrab",cc.exports.Fish)
function fishSuperCrab:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        bounding_box_width=420;
        bounding_box_height=380;
        fishSuperCrab.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
        self.m_change_flag=0;
        self. m_changeTimer=1;
        self.m_alive_timer__=0;
        self.alive_limi_time=0;
        self.baseAngle = math.rad(180);
        if (self.fis_node) then 
            local t_cc_mov_Node = cc.Node:create();
			self.fis_node:addChild(t_cc_mov_Node, 0, 998);
             self.fis_node:setScale(2.0);	
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,60, 1 do
                file_name=string.format("~fishSuperCrab_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
					
						if (cc.exports.g_offsetmap_InitFlag[28]<1) then
                        	local offset_name=string.format("fishSuperCrab_000_%03d.png", i);
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
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
            end --for
            if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[28]=1;
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
			end

		end --  if (self.fis_node) then 
 end
 function  fishSuperCrab:ChangeMovSpeed( dt)--//变换移动速度

	if (self.m_moveKind > 1 and self.m_start_in_win_flag>0) then 
		self.m_changeTimer=self.m_changeTimer -dt;
		if (self.m_changeTimer<0.00) then 				
			if (self.m_change_flag == 0) then 
				self.m_changeTimer =3+ math.random(0,100)%2;
				self.m_mov_speed_ex = self.m_mov_speed_ex / 5;
				self.m_change_flag = 1;			
			else	
				self.m_changeTimer = 2 + math.random(0,100) % 2;
				self.m_mov_speed_ex = self.m_mov_speed_ex *5;
				self.m_change_flag = 0;
			end
		end
	end --if (m_moveKind > 1 && m_start_in_win_flag>0) then 
end
function fishSuperCrab:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
     cclog(" fishSuperCrab:CatchFish");
     self.fis_node:removeChildByTag(7758258);
     self.m_mov_timer = 0;
	 self.m_catch_chairID = chair_id;
	 self.m_catch_score = score;
	 self.fish_multiple_ = fish_mul;
	 self.fish_status_ = 2;
	 self.m_mov_timer = 0;
     self.alive_limi_time=0;
	 cc.exports.g_soundManager:PlayGameEffect("HitBOSS");
     if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	 end
     if (bomFlag>0) then 
		  self.m_fish_die_action_EndFlag = 1;
		  return;
	 end
      cclog(" fishSuperCrab:CatchFish1");
     	--//播放特效
		--My_Particle_manager::GetInstance()->PlayParticle(2, fis_node->getPosition());
        cc.exports.g_My_Particle_manager:PlayParticle(2, self:GetFishccpPos());
		 cc.exports.game_manager_:ShakeScreen();
        --local x,y=self.fis_node:getPosition();
         --cc.exports.g_CoinManager:BuildCoin(cc.p(x,y), chair_id, score, fish_mul);
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
        if (readIndex > 0) then 	
                local function _call_back00()
                   _sprite:removeFromParent()
                end
				animation:setDelayPerUnit(1/12.0);
                 local action =cc.Animate:create(animation);   
				local t_CCRepeat = cc.Repeat:create(action, 1);
				local t_func_ = cc.CallFunc:create(_call_back00);
				local  seq = cc.Sequence:create(t_CCRepeat, t_func_, nil);
				_sprite:runAction(seq);
                self.fis_node:addChild(_sprite, 12);
				_sprite:setScale(2.0);
	  end
      --//添加图标到炮塔
      local x,y=self.fis_node:getPosition();
	  cc.exports.g_cannon_manager:Catch_fishSuperCrab(chair_id, cc.p(x,y), score, fish_mul);
end
function fishSuperCrab:MovByList(mov_list,pointNum,mov_speed_, _rot_speed) 
	   local  winsize = cc.Director:getInstance():getWinSize();--   sharedDirector()->getWinSize();
        self.m_rot_speed_ = _rot_speed;
		self.m_mov_speed_ex = 50;--// 300;//
		self.m_change_flag = 1;
		self.m_changeTimer =1;
		self.m_start_in_win_flag = 1;
		self.m_moveKind = 2;
		self.m_fish_mov_point_index = 0;
		self.m_fish_mov_by_actionFlag = 0;
		pointNum = 7;
        local t_mov_direct = math.random(0,100) % 2;
		local t_start_index = 0;
		--if (mov_list[0].x < winsize.width / 2 and mov_list[0].y  >winsize.height / 2) then t_start_index = 0; 
		--else
       if (mov_list[0].x  < winsize.width / 2 and mov_list[0].y < winsize.height / 2) then t_start_index = 2;
		elseif (mov_list[0].x > winsize.width / 2 and mov_list[0].y< winsize.height / 2) then t_start_index = 4;
		else  t_start_index = 6;end
		self.m_fish_by_configList ={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
		self.m_fish_mov_point_total = 7;
    
        local i=0;
		for i=0,7,1 do	
			self.m_fish_by_configList[i] =cc.exports.g_fishSuperCrab_mov_pos[t_start_index];
			if (t_mov_direct==0) then t_start_index=t_start_index+1; 
			else t_start_index=t_start_index-1; end
			if (t_start_index < 0) then t_start_index = 7; end
			if (t_start_index >7) then t_start_index = 0; end
		end--for
        self.m_mov_position = self.m_fish_by_configList[0];
		self.fis_node:setPosition(self.m_mov_position);
		local t_spr =self.fis_node:getChildByTag(10086);
		if (t_spr) then 		
			t_spr:setOpacity(0);
			if (self.fis_node:isVisible()==false) then  self.fis_node:setVisible(true); end
			local t_fade_action = cc.FadeIn:create(0.4);
			t_spr:runAction(t_fade_action);
		end
		self:MovToNextIndex();
		self:set_active(true);
    end
function fishSuperCrab:MovToNextIndex()
    cclog("fishSuperCrab:MovToNextIndex m_fish_mov_point_index=%d,m_fish_mov_point_total=%d",self.m_fish_mov_point_index,self.m_fish_mov_point_total);
   if (self.m_fish_mov_point_index < (self.m_fish_mov_point_total-1)) then 
          cclog("fishSuperCrab:MovToNextIndex m_fish_mov_point_index=%d,m_fish_mov_point_total=%d",self.m_fish_mov_point_index,self.m_fish_mov_point_total);
        local  t_angle_ = self:mm_getAngle(self.m_mov_position, self.m_fish_by_configList[self.m_fish_mov_point_index + 1]);
		local  t_angle_a = math.deg(t_angle_);
        self.m_speed_x = self.m_mov_speed_ex* math.sin(t_angle_a);
		self.m_speed_y = self.m_mov_speed_ex* math.cos(t_angle_a);
        self.show_angle = t_angle_a - self.baseAngle;
		self.m_fish_Check_Angle = t_angle_a;
		local t_cc_mov_Node = self.fis_node:getChildByTag(998);
		if (self.m_fish_mov_point_index == 0)
		then 	t_cc_mov_Node:setRotation(t_angle_);
       else
                local function  rot_end()
                 self.m_rot_flag = 0;
                end
				if (self.m_rot_speed_ < 1) then m_rot_speed_ = 1; end
				local t_rot_timer = t_angle_ / self.m_rot_speed_;
				if (t_rot_timer < 0) then t_rot_timer = -t_rot_timer; end
				local t_rotto = cc.RotateTo:create(t_rot_timer, t_angle_);
				local t_rot_end = cc.CallFunc:create(rot_end);
				t_cc_mov_Node:runAction(cc.Sequence:create(t_rotto, t_rot_end, nil));
				self.m_rot_flag = 1;
		end   
        self.m_fish_mov_point_index=self.m_fish_mov_point_index+1;
        if (self.m_fish_mov_point_index >= (self.m_fish_mov_point_total-1)) then self.m_fish_mov_point_index = 0; end
            cclog("fishSuperCrab:MovToNextIndex m_fish_mov_point_index=%d,m_fish_mov_point_total=%d",self.m_fish_mov_point_index,self.m_fish_mov_point_total);
    end

end
function  fishSuperCrab:OnFrame(delta_time)
   --cclog(" Fish:OnFrame dt=%f",dt);
   --if(delta_time>0.04) then delta_time=0.04; end;
   if (self.active_==0) then return false;end
   if (self.fish_status_ == 0) then
   	    self.trace_index_ = 0;
	    self.m_nFishDieCount=0;
		self.fish_status_ = 1;
        if (self.m_moveKind == 0) then 
           local fish_trace = self.trace_vector_[self.trace_index_];
           self.m_mov_position=cc.p(fish_trace.x, fish_trace.y);
           self.fis_node:setPosition(cc.p(fish_trace.x, fish_trace.y));		
        end
        --self.fis_node:setVisible(t);
   end
   if (self.fish_status_ == 1)  then
     -- self.alive_limi_time= self.alive_limi_time+delta_time;
      if(self.m_alive_timer__>180) then return true; end;
       if (self.m_mov_delay_timer > 0.0001) then 
			self.m_mov_delay_timer=self.m_mov_delay_timer-delta_time;
			return false;
		end
         self:ChainLindFishUpdate(delta_time);
         if (self.m_connect_Stop_Flag == 0) then 
             --按原路径移动
                          if (self.m_moveKind < 2) then 
              self.check_timer=self.check_timer+delta_time;
              if(  self.check_timer>0.15) then 
                 self.check_timer=0;
				  self:CheckValid();    
                end                   
                 self.m_mov_timer= self.m_mov_timer+delta_time;-- end
                 if ( self.m_mov_timer > 0.0333) then 
                     local  Mov_Step =1
                     self.m_mov_timer = self.m_mov_timer -0.0333
                      if (self.m_mov_timer > 0.0333) then
                           self.m_mov_timer = 0;		
                      end
                     if (self.stop_count_ > 0 and  self.trace_index_ == self.stop_index_ and self.current_stop_count_ < self.stop_count_) then
						      self.current_stop_count_ = self.current_stop_count_+Mov_Step;
						     if (self.current_stop_count_ >= self.stop_count_) then self:SetFishStop(0, 0);end
                       elseif (self.m_fish_mov_by_actionFlag == 0) then 			
                            self.trace_index_ = self.trace_index_ +Mov_Step;
							--if (self.m_moveKind == 0)  then self.trace_index_ = self.trace_index_ +Mov_Step;
							--else			               self.trace_index_ = self.trace_index_ +(self.fish_speed_*Mov_Step);	end
						    if (self.trace_index_ >= #self.trace_vector_-2)  then return true;
                            else
							    local  fish_trace = self.trace_vector_[self.trace_index_];
							    self.show_angle = fish_trace[3] - self.baseAngle;
						    	self.m_fish_Check_Angle = self.show_angle;
						     	if (self.fis_node) then 
							        	local rotation = self.show_angle*57.29577951308
					                   self.fis_node:setRotation(rotation)
					                   self.fis_node:setPosition(cc.p(fish_trace[1], fish_trace[2]))
                                       self.m_mov_position=cc.p(fish_trace[1], fish_trace[2]);
								       --if (self.fis_node:isVisible()==false) then self.fis_node:setVisible(true); end
							end--if (self.fis_node) then 
						  end--if (self.trace_index_ >= #self.trace_vector_)  then return true;
					    end --   elseif (self.m_fish_mov_by_actionFlag == 0) then 			
					end  -- if ( self.m_mov_timer > 0.0333) then 
              else   -- if (self.m_moveKind >2) then   --新的移动路径
                  --self.alive_limi_time=self.alive_limi_time+delta_time;
                 --if(self.alive_limi_time>20)then return true; end
                 self.valid_ = true;
                 self.m_mov_timer =  self.m_mov_timer+delta_time;
                 local winsize = cc.Director:getInstance():getWinSize();--::sharedDirector()->getWinSize();
				 local t_angle_ = self:mm_getAngle(self.m_mov_position, self.m_fish_by_configList[self.m_fish_mov_point_index]);
				local t_angle_a = math.rad(t_angle_);
				self.m_speed_x = self.m_mov_speed_ex* math.sin(t_angle_a);
				self.m_speed_y = self.m_mov_speed_ex* math.cos(t_angle_a);
				self.m_mov_position.x =self.m_mov_position.x+ self.m_speed_x*delta_time;
			    self.m_mov_position.y =self.m_mov_position.y+ self.m_speed_y*delta_time;
			    self.fis_node:setPosition(self.m_mov_position);
                --总是对中心转动
                local t_angle_arm = self:mm_getAngle(self.m_mov_position, cc.p(winsize.width / 2, winsize.height/2));
				local t_angle_arm_a = math.rad(t_angle_arm);
				self.show_angle = t_angle_arm_a-self.baseAngle;
				self.m_fish_Check_Angle = self.show_angle;
				self.fis_node:setRotation(t_angle_arm-180);
                local dx=self.m_mov_position.x-self.m_fish_by_configList[self.m_fish_mov_point_index].x;
                local dy=self.m_mov_position.y-self.m_fish_by_configList[self.m_fish_mov_point_index].y;
                local dis_to_arm =  math.sqrt(dx*dx+dy*dy) ;--;//self.m_mov_position.getDistance(self.m_fish_by_configList[self.m_fish_mov_point_index]);
				local t t_min_dis_ = self.m_mov_speed_ex*delta_time+10;
                if (dis_to_arm<t_min_dis_) then 	self:MovToNextIndex(); end
                if (self.m_start_in_win_flag) then 
                	local t_check_width = 500;
						if (self.m_mov_position.x<-t_check_width 
                          or self.m_mov_position.x>(winsize.width + t_check_width)
                          or self.m_mov_position.y<-t_check_width
                          or self.m_mov_position.y>(winsize.height + t_check_width))				
							 then return true;	 end	
                else 
                	if (self.m_mov_position.x>0 
                    and self.m_mov_position.x < winsize.width 
                    and self.m_mov_position.y < 0 
                    and self.m_mov_position.y < winsize.height)
					then 	self.m_start_in_win_flag = 1; end			
                end					
              end
         end
   else 
       if (self.m_fish_die_action_EndFlag>0) then return true; end
		self.m_mov_timer=self.m_mov_timer+delta_time;
		if(self.m_mov_timer>0.033) then --30fps
			self.m_mov_timer=self.m_mov_timer-0.033;
			self.m_nFishDieCount=self.m_nFishDieCount+1;
			if(self.m_nFishDieCount>180) then return true; end
		end
   end
   return false;
end



return fishSuperCrab;
--endregion

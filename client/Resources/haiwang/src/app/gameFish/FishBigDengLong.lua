--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成 大灯笼鱼
local FishBigDengLong = class("FishBigDengLong",cc.exports.Fish)
function FishBigDengLong:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
           bounding_box_width=400;
           bounding_box_height=400;
           fishSuperCrab.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
            cc.exports.game_manager_:StartMark_Scene();
            self.fis_node:setScale(2.0);
            self.alive_limi_time=0;
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,60, 1 do
                file_name=string.format("~FishBigDengLong_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
            end --for
            if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[28]=1;
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
			end
 end
  function  FishBigDengLong:Getlight_Pos()

	 if (self.fish_status_ == 1) then 
		 if (self.fis_node)	 then 
			 local  t_pos = self.fis_node:convertToWorldSpace(cc.p(50, 0));
			 return t_pos;
		 end
	 end
	 return cc.p(-1000, -1000);
 end

  function   FishBigDengLong:GetLiht_Angle()  
	 if (self.fish_status_ == 1) then 
		 if (self.fis_node) then return fis_node:getRotation() end
	 end
	 return 0;
 end

 function FishBigDengLong:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
     --cclog("FishBigDengLong:CatchFish00");
     self.fis_node:removeChildByTag(7758258);
     self.m_mov_timer = 0;
	 self.m_catch_chairID = chair_id;
	 self.m_catch_score = score;
	 self.fish_multiple_ = fish_mul;
	 self.fish_status_ = 2;
	 self.m_mov_timer = 0;
     self.alive_limi_time=0;
     --cclog("FishBigDengLong:CatchFish01");
      if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	 end
     --cclog("FishBigDengLong:CatchFish02");
	  cc.exports.g_soundManager:PlayGameEffect("HitBOSS");
     if (bomFlag>0) then 
		  self.m_fish_die_action_EndFlag = 1;
		  return;
	 end
    -- cclog("FishBigDengLong:CatchFish03");
     --播放特效
	--	My_Particle_manager::GetInstance()->PlayParticle(2, fis_node->getPosition());
    cc.exports.g_My_Particle_manager:PlayParticle(2, self:GetFishccpPos());
	 cc.exports.game_manager_:ShakeScreen();
    -- cclog("FishBigDengLong:CatchFish04");
     --//播放死亡特效
	 --//图标生成特效
         --cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), chair_id, score, fish_mul);
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
         --  cclog("FishBigDengLong:CatchFish0400");
        if (readIndex > 0) then 	
                local function _call_back00()
                   _sprite:removeFromParent()
                end
				animation:setDelayPerUnit(1/12.0);
                 local action =cc.Animate:create(animation);   
				local t_CCRepeat = cc.Repeat:create(action, 1);
				local t_func_ = cc.CallFunc:create(_call_back00);
				local  seq = cc.Sequence:create(t_CCRepeat, t_func_, nil);
                 --cclog("FishBigDengLong:CatchFish0401");
				_sprite:runAction(seq);
                self.fis_node:addChild(_sprite, 12);
				_sprite:setScale(2.0);
                 --cclog("FishBigDengLong:CatchFish0402");
	  end
     -- cclog("FishBigDengLong:CatchFish05");
     cc.exports.g_cannon_manager:Catch_FishBigDengLong(chair_id, self:GetFishccpPos(), score, fish_mul);
     --cclog("FishBigDengLong:CatchFish06");
end
function  FishBigDengLong:MovByList(mov_list,pointNum,mov_speed_, _rot_speed)  --路径和点数
   	if (pointNum > 1)then
        local winsizi=cc.Director:getInstance():getWinSize();
        if (pointNum > 10) then pointNum = 10; end
		self.m_moveKind = 2;
		self.m_fish_mov_point_index = 0;
		self.m_fish_mov_by_actionFlag = 0;
		self.m_rot_speed_ = _rot_speed;
		self.m_mov_speed_ex = mov_speed_;
        if (mov_list[0].x<0 and mov_list[0].x>-500) then mov_list[0].x = -500; end
		if (mov_list[0].x>winsizi.width and mov_list[0].x<(winsizi.width + 500)) then mov_list[0].x = winsizi.width + 500; end
		if (mov_list[0].y<0 and mov_list[0].y>-500) then mov_list[0].y = -500; end
		if (mov_list[0].y > winsizi.height and mov_list[0].y < (winsizi.height + 500)) then mov_list[0].y = winsizi.height + 500; end

		if (self.m_mov_speed_ex < 10) then  self.m_mov_speed_ex = 10; end
		self.m_mov_position = cc.p(mov_list[0].x, mov_list[0].y);
		self.fis_node:setPosition(self.m_mov_position);
		self.m_fish_by_configList ={[0]=cc.p(0,0)};-- new CCPoint[pointNum];
        local i=0;
		for i = 0, pointNum-1,1 do
			local  s_pos = cc.p(mov_list[i].x, mov_list[i].y);
			local  e_pos = cc.p(mov_list[i+1].x, mov_list[i+1].y);
			local t_dis_num = cc.pGetDistance(s_pos,e_pos);
			local  t_angle_ = self:mm_getAngle(s_pos, e_pos);
            --cclog("i=%d,s_pos (%f,%f),e_pos(%f,%f)t_angle_=%f",i,s_pos.x,s_pos.y,e_pos.x,e_pos.y,t_angle_);
            self.m_fish_by_configList[i]=cc.p(t_angle_,t_dis_num / (self.m_mov_speed_ex));
			--self.m_fish_by_configList[i].x = t_angle_;                                  --角度
			--self.m_fish_by_configList[i].y = t_dis_num / (self.m_mov_speed_ex);--时间
		end
		self.m_fish_by_configList[pointNum - 1] = self.m_fish_by_configList[pointNum - 2];
		self.m_fish_mov_point_total = pointNum;
		self:MovToNextIndex();
		if (self.fis_node:isVisible()==false)  then self.fis_node:setVisible(true); end
		self:set_active(true);
	end
end

function  FishBigDengLong:OnFrame(delta_time)
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
       self.alive_limi_time= self.alive_limi_time+delta_time;
       if(self.alive_limi_time>70) then return  true ;end 
       if (self.m_mov_delay_timer > 0.0001) then 
			self.m_mov_delay_timer=self.m_mov_delay_timer-delta_time;
			return false;
		end
         --self:ChainLindFishUpdate(delta_time);
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
              else   -- if (self.m_moveKind >2) then 
               -- if(self.scene_fish_flag==0) then 
                --  if(self.alive_limi_time>40) then return  true end;
              -- else 
                if(self.alive_limi_time>60) then return  true end;
              -- end
               if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动

              end
         end
   else 
      --self.alive_limi_time=self.alive_limi_time+delta_time;
     -- if(self.alive_limi_time>20)then return true; end
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

 return FishBigDengLong;
--endregion

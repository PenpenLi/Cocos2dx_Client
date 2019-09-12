--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成 大水母
local JellyFish = class("JellyFish",cc.exports.Fish)
function JellyFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
             bounding_box_width=700;
             bounding_box_height=550;

            JellyFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
            self.alive_limi_time=0;
            if (self.fis_node) then 
               self.fis_node:setScale(2.0);
               local file_name ="";
			   local _sprite = nil;
			   local readIndex = 0;
			   local animation = cc.Animation:create();
               local i=0;
			   for  i = 0,100, 1 do
                   file_name=string.format("~JellyFish_000_%03d.png", i);
				   local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then									
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
             end --for
             if (readIndex > 0)	then 
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
                 _sprite:setAnchorPoint(cc.p(0.36,0.5));
		 	end
		end --  if (self.fis_node) then 
end

 function JellyFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
    self.fis_node:removeChildByTag(7758258);
     self.m_mov_timer = 0;
	 self.m_catch_chairID = chair_id;
	 self.m_catch_score = score;
	 self.fish_multiple_ = fish_mul;
	 self.fish_status_ = 2;
	 self.m_mov_timer = 0;
     self.alive_limi_time=0;
	  cc.exports.g_soundManager:PlayGameEffect("HitBOSS");
     if (bomFlag>0) then 
		  if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	      end
		  self.m_fish_die_action_EndFlag = 1;
          self.m_mov_timer = 15;
		  return;
	 end
     ---//播放特效
	cc.exports.g_My_Particle_manager:PlayParticle(0, self:GetFishccpPos());
	cc.exports.game_manager_:ShakeScreen();
    --//播放死亡动画
    if (self.fis_node) then 
               self.fis_node:removeAllChildren();
               --cc.exports.g_JellyAlive_Flag = 1;
               local file_name ="";
			   local _sprite = nil;
			   local readIndex = 0;
			   local animation = cc.Animation:create();
               local i=0;
			   for  i = 0,100, 1 do
                     file_name=string.format("~JellyFish_000_%03d.png", i);        
				   local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then									
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
             end --for
             if (readIndex > 0)	then 
                  local function call_back__()
                    self:Fish_Die_ActionCallback();
                  end
                 local function call_back__1()
                    self:CatchScore_callback();
                  end
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
                  local t_CCRepeat = cc.Repeat:create(action, 2);
				  local t_CCFadeOut=cc.FadeOut:create(0.4);
				  local t_callfunc = cc.CallFunc:create(call_back__);
                  local t_callfunc1 = cc.CallFunc:create(call_back__1);
				  local t_CCSequence = cc.Sequence:create(t_CCRepeat, t_callfunc1,t_CCFadeOut, t_callfunc, nil);
				 _sprite:runAction(t_CCSequence);
                 _sprite:setAnchorPoint(cc.p(0.51, 0.5));
                 -- _sprite:setAnchorPoint(cc.p(0.36,0.5));
                  self.fis_node:addChild(_sprite, 0, 10086);

		 	end

    end
end

function  JellyFish:OnFrame(delta_time)
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
              else   -- if (self.m_moveKind >2) then 
               if(self.alive_limi_time>60) then return  true ;end 
               if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动

              end
         end
   else 
       --self.alive_limi_time=self.alive_limi_time+delta_time;
       --if(self.alive_limi_time>20)then return true; end
       if (self.m_fish_die_action_EndFlag>0) then return true; end
--		self.m_mov_timer=self.m_mov_timer+delta_time;
--		if(self.m_mov_timer>0.033) then --30fps
--			self.m_mov_timer=self.m_mov_timer-0.033;
--			self.m_nFishDieCount=self.m_nFishDieCount+1;
--			if(self.m_nFishDieCount>180) then return true; end
--		end
   end
   return false;
end

function  JellyFish:Fish_Die_ActionCallback()	
	self.m_fish_die_action_EndFlag = 1;
	self.fis_node:removeAllChildren();
end
return JellyFish;
--endregion

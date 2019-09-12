--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成
--<!--钻头炮-->
local DcBroachCannonFish = class("DcJuDcBroachCannonFishmpScoreFish",cc.exports.Fish)
function DcBroachCannonFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
           	fish_multiple = 50;
             DcBroachCannonFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);         
             self.m_BroachWinChairId=0;
	         self.m_BroachCannonBullet_mul=0;  --//子弹倍数
	         self.m_BroachWinFish_mul=0;        -- //中奖倍数
	         self.m_BroachWin_Score=0;          --  //子弹分数
	         self.m_BroachCannon_step=0;       --//生成进度
	         self.m_BroachCannon_Timer=0;   --//定时器
             self.alive_limi_time=0;
             self.m_End_Flag=0;
            if (self.fis_node) then 
                self:setLocalZOrder(-1);
                self.baseAngle = math.rad(90);
                local file_name ="";
			    local _sprite = nil;
		    	local readIndex = 0;
		     	local animation = cc.Animation:create();
                local i=0;
			   for  i = 0,32, 1 do
                   file_name=string.format("~BroachCannonCrab_000_%03d.png", i);
				   local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then						
						local offset_name=string.format("BroachCannonCrab_000_%03d.png", i);
						if (cc.exports.g_offsetmap_InitFlag[24]<1) then
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
                           cc.exports.g_offsetCoin_InitFlag[i]=1;
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				 end
              end --for
              if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[24]=1;
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
			  end
            end
end
function DcBroachCannonFish:GetFish_Catch_Mul()--//获取游戏中鱼的倍数
	    local mul =cc.exports.g_pFishGroup:getTotalFish_mul();
		mul= mul+self:get_fish_mulriple();
		return mul;
end
function DcBroachCannonFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
    self.m_no_catch_flag = 1;
	self.m_mov_timer = 0;
    self.alive_limi_time=0;
	self.m_catch_chairID = chair_id;
	self.m_catch_mul = fish_mul;
	self.m_catch_bullet_mul = bulet_mul;
	self.m_catch_score = score;
	self.fish_status_ = 2;
     if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	end
     if (bomFlag>0) then  
		  self.m_fish_die_action_EndFlag = 1;
           self.m_End_Flag=1;
		  return;
	  end
        cc.exports.g_soundManager:PlayGameEffect("DianCiPaoAppear");
	   cc.exports.g_soundManager:PlayGameEffect("SuperGunShowSound");
	   self.m_BroachWinChairId = chair_id;
	   self.m_BroachCannon_step = 1;
	   self.m_BroachCannon_Timer = 0;
	   self.m_BroachCannonBullet_mul = bulet_mul; -- //子弹倍数
	   self.m_BroachWinFish_mul = fish_mul;          -- //中奖倍数
	   self.m_BroachWin_Score = score;                -- //子弹分数
      self:setLocalZOrder(15);
       --播放光圈特效
	   if (self.fis_node) then 
             local t_spr =    cc.Sprite:create("haiwang/res/HW/BroachCannonCrab/~BombCrabCircle2_000_000.png");--//循环3次
		     local t_spr1 =  cc.Sprite:create("haiwang/res/HW/BroachCannonCrab/~BombCrabCircle2_000_000.png");--//循环3次
		     local t_spr2 =  cc.Sprite:create("haiwang/res/HW/BroachCannonCrab/~BombCrabCircle1_000_000.png");--// 循环一次
              if (t_spr) then 	   
			   t_spr:setScale(0.0);
			  local fadeout = cc.FadeOut:create(0.2);
			  local  scaleto = cc.ScaleTo:create(0.8, 5);
			  local  seq = cc.Sequence:create(scaleto, fadeout, nil);
			   t_spr:runAction(seq);
			   self.fis_node:addChild(t_spr, 11);
		   end
		   if (t_spr1) then 
			   t_spr1:setScale(0.0);
			   local  t_delay = cc.DelayTime:create(1);
			   local  fadeout = cc.FadeOut:create(0.2);
			   local  scaleto = cc.ScaleTo:create(0.8, 5);
			   local  seq = cc.Sequence:create(t_delay,scaleto, fadeout, nil);
			   t_spr1:runAction(seq);
			   self.fis_node:addChild(t_spr1, 11);
		   end
		   if (t_spr2) then 
			   t_spr2:setScale(0.0);
			   local fadeout = cc.FadeOut:create(0.2);
			   local scaleto = cc.ScaleTo:create(1.6, 5);
			   local seq = cc.Sequence:create(scaleto, fadeout, nil);
			   t_spr2:runAction(seq);
			   self.fis_node:addChild(t_spr2, 11);
		   end
       end  -- if (self.fis_node) then 


end
function  DcBroachCannonFish:OnFrame(delta_time)
   --cclog(" Fish:OnFrame dt=%f",dt);
   -- if(delta_time>0.04) then delta_time=0.04; end;
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
                 if(self.check_timer>0.15) then 
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
               --if(self.scene_fish_flag==0) then 
                --  if(self.alive_limi_time>40) then return  true end;
              -- else 
                if(self.alive_limi_time>60) then return  true end;
               --end
                if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动
              end
         end
   else 
       self.m_BroachCannon_Timer =self.m_BroachCannon_Timer+ delta_time;
       if (self.m_fish_die_action_EndFlag>0) then return true; end
       if (self.m_End_Flag>0) then return true; end
       if (self.m_BroachCannon_step == 1)  then --//刚刚生成
			if (self.m_BroachCannon_Timer > 1.9)	then 
				self.fis_node:removeChildByTag(10086);
				self.m_BroachCannon_step = 2;
				self.m_BroachCannon_Timer = 0;
                local x,y=self.fis_node:getPosition();
                local _catch_pos=self:convertToWorldSpace(cc.p(x,y));
				cc.exports.g_cannon_manager:Catch_Broach_Card(
					_catch_pos,
					self.fis_node:getRotation()+180, 
					self.m_BroachWinChairId, 
					self.m_BroachCannonBullet_mul, 
					self.m_BroachWinFish_mul, 
					self.m_BroachWin_Score);
			end
       elseif (self.m_BroachCannon_step == 2)  then 
           if (self.m_BroachCannon_Timer > 0.2) then return true; end
       end
       
   end
   return false;
end

return DcBroachCannonFish;
--endregion

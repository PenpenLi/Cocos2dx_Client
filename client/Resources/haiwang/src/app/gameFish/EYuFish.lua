--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成

 EYuFish = class("EYuFish",cc.exports.Fish)
function EYuFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        bounding_box_width=960;
        bounding_box_height=280;
        EYuFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
        cclog(" EYuFish:ctor(  bounding_box_width=%d,  bounding_box_height=%d,  hit_radius=%d)", bounding_box_width,  bounding_box_height,  hit_radius);
       self.m_EyuCutDelay=0;
       self.m_cunChair_id=0;
      self.alive_limi_time=0;
       if (fis_node) then 
			self.baseAngle = math.rad(90);
			self.fis_node:setVisible(true);
			self.fis_node:setScale(1.0);
			self:playActionAlive();
		end
end
function  EYuFish:OnFrame(delta_time)
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
       self.alive_limi_time=self.alive_limi_time+delta_time;
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
               if(self:Mov_by_List(delta_time)==true) then return  true ;
               else 
               if (self.m_EyuCutDelay > 0.00001) then 	
			 	  self.m_EyuCutDelay=self.m_EyuCutDelay - delta_time;
                end
			      	--和炮塔的碰撞检测
				   --正前方
			    	local  t_ccwinsize = cc.Director:getInstance():getWinSize();--   ::sharedDirector()->getWinSize();
				     local  t_chePoint = self.fis_node:convertToWorldSpace(cc.p(470,0));		
				if (t_chePoint.x > 0 and t_chePoint.y > 0 and t_chePoint.x < t_ccwinsize.width and t_chePoint.y < t_ccwinsize.height) then 
                    local i=0;
					for i=0,3,1 do			
                        if(self.m_EyuCutDelay<0.1)		 then 
						   local t__local_info_type = _local_info_array_[i];
                           local dx=t__local_info_type.x-t_chePoint.x;
                          local dy=t__local_info_type.y-t_chePoint.y;                      
						  if ((dx*dx+dy*dy) < 20000)	then 
							self:playerActionJump();	
							self.m_cunChair_id = i;
							self.m_EyuCutDelay = 5;
							break;
						  end
                        end
					end
				end
               end  --新的路径移动
              end
         end
   else 
--        if(self.scene_fish_flag==0) then 
--              if(self.alive_limi_time>30) then return  true end;
--            else 
              if(self.alive_limi_time>60) then return  true end;
--         end
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
--鳄鱼路径 对着玩家炮塔
function EYuFish:MovByList(mov_list,pointNum,mov_speed_, _rot_speed) 
	local  winsize = cc.Director:getInstance():getWinSize();--   sharedDirector()->getWinSize();
     local g_eyuMov_List =
{
	[0]={ [0]=cc.p(1580, -500), cc.p(340, cc.exports.kTopHeight) },
	[1]={ [0]=cc.p(-500, -500), cc.p(960, cc.exports.kTopHeight) },
	[2]={ [0]=cc.p(-500, 1200), cc.p(940, cc.exports.kBottomHeight) },
	[3]={ [0]=cc.p(1580, 1200), cc.p(320, cc.exports.kBottomHeight) },
};
	local t_start_index = 0;
	pointNum = 2;
	if (mov_list[0].x < winsize.width / 2 and mov_list[0].y  >winsize.height / 2) then t_start_index = 0;
	elseif (mov_list[0].x < winsize.width / 2 and mov_list[0].y < winsize.height / 2) then t_start_index = 1;
	elseif (mov_list[0].x > winsize.width / 2 and mov_list[0].y < winsize.height / 2) then t_start_index = 2;
	else  t_start_index = 3; end;
   -- t_start_index=t_start_index+1;
	self.m_moveKind = 2;
	self.m_fish_mov_point_index = 0;
	self.m_fish_mov_by_actionFlag = 0;
	self.m_rot_speed_ = _rot_speed;
	self.m_mov_speed_ex = 60;
	if (self.m_mov_speed_ex < 10) then self.m_mov_speed_ex = 10; end
	if (pointNum > 10) then pointNum = 10; end
	self.m_fish_mov_point_total = pointNum;
	self.m_mov_position =cc.p(g_eyuMov_List[t_start_index][0].x,g_eyuMov_List[t_start_index][0].y);
	self.fis_node:setPosition(self.m_mov_position);
	self.m_fish_mov_point_total = 2;
	--//转化为进度和时间
	self.m_fish_by_configList={[0]=cc.p(0,0),cc.p(0,0)};
    	--//转化为进度和时间
    local i=0;
	local s_pos = g_eyuMov_List[t_start_index][i];
	local e_pos = g_eyuMov_List[t_start_index][i+1];
    local dx=s_pos.x-e_pos.x;
    local dy=s_pos.y-e_pos.y;
	local t_dis_num = math.sqrt(dx*dx+dy*dy) --s_pos.getDistance(e_pos);
	local  t_angle_ = self:mm_getAngle(s_pos, e_pos);
	self.m_fish_by_configList[i].x = t_angle_;                                  --//角度
	self.m_fish_by_configList[i].y = t_dis_num / (self.m_mov_speed_ex);--//时间

	self.m_fish_by_configList[pointNum - 1] =self. m_fish_by_configList[pointNum - 2];
	self.m_fish_mov_point_total = pointNum;
	self:MovToNextIndex();
	if (self.fis_node:isVisible()==false) then  self.fis_node:setVisible(true); end;
	self:set_active(true);
    
end
function EYuFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
   -- cclog("EYuFish:CatchFish chair_id=%d,score=%d,bulet_mul=%d,fish_mul=%d,bomFlag=%d",chair_id,  score,  bulet_mul,  fish_mul,  bomFlag);
    self.fis_node:removeChildByTag(7758258);
    cc.exports.g_soundManager:PlayGameEffect("HitEYu");
    self.m_mov_timer = 0;
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
		  return;
	  end
    self:setZOrder(100);
    --local x,y=self.fis_node:getPosition();
	--cc.exports.g_CoinManager:BuildCoin(cc.p(x,y), chair_id, score, fish_mul);
	if (self.fis_node:getChildByTag(10086)) then 	
		self.fis_node:getChildByTag(10086):runAction(cc.FadeOut:create(0.2));
	end
    --播放特效
	--My_Particle_manager::GetInstance()->PlayParticle(2, fis_node->getPosition());
    cc.exports.g_My_Particle_manager:PlayParticle(2, self:GetFishccpPos());
     -- cclog("EYuFish:CatchFish chair_id=%d,score=%d,bulet_mul=%d,fish_mul=%d,bomFlag=%d aa",chair_id,  score,  bulet_mul,  fish_mul,  bomFlag);
	   cc.exports.game_manager_:ShakeScreen();
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
      local x,y=self.fis_node:getPosition();
       cc.exports.g_cannon_manager:Catch_EYuFish(chair_id,cc.p(x,y) , score, fish_mul); 
     --  cclog("EYuFish:CatchFish chair_id=%d,score=%d,bulet_mul=%d,fish_mul=%d,bomFlag=%d bb",chair_id,  score,  bulet_mul,  fish_mul,  bomFlag);
end

function  EYuFish:playActionAlive()--             //激活
   if (self.fis_node) then 
       self.m_mov_speed_ex = 60;
       	self.fis_node:removeChildByTag(10086);
        	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,50, 1 do
				file_name=string.format("EYuFish_0_ (%d).png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then							
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end
			  if (readIndex > 0)	then 
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
			  end
   end -- if (self.fis_node) then 
end

function  EYuFish:playerActionJump()        --//跃起动作
   if (self.fis_node) then 
       self.m_mov_speed_ex = 100;
       	self.fis_node:removeChildByTag(10086);
        	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,41, 1 do
				file_name=string.format ("EYuFish_1_ (%d).png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then							
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end
			  if (readIndex > 0)	then 
                  local function call_back__()
                      self:playerActionJumpEnd();
                  end
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
                  local funcall = cc.CallFunc:create(call_back__);
			      local t_CCRepeat = cc.Repeat:create(action, 1);
			      local  seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
				  _sprite:runAction(seq);
                  self.fis_node:addChild(_sprite, 0, 10086);
			  end
   end -- if (self.fis_node) then 
end
function EYuFish:playerActionJumpEnd() --//返回水面

cc.exports.g_cannon_manager:PlayerCannonCut(self.m_cunChair_id);
 if (self.fis_node) then 
       self.m_mov_speed_ex = 300;
       	self.fis_node:removeChildByTag(10086);
        
        	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,22, 1 do
				file_name=string.format("EYuFish_2_ (%d).png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then							
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end
			  if (readIndex > 0)	then 
                  local function call_back__()
                      self:playActionAlive();
                  end
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
                  local funcall = cc.CallFunc:create(call_back__);
			      local t_CCRepeat = cc.Repeat:create(action, 1);
			      local  seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
				  _sprite:runAction(seq);
                  self.fis_node:addChild(_sprite, 0, 10086);
			  end
   end -- if (self.fis_node) then 
end
--]]
return EYuFish;

--endregion

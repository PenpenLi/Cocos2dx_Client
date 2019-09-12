--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成 
-- //<!--连环炸弹蟹-->//全屏炸弹
local InterlinkBombCrab = class("InterlinkBombCrab",cc.exports.Fish)
function InterlinkBombCrab:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        InterlinkBombCrab.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
        self.m_catch_step = 0;
        self.m_catch_timer_=0;
         self.m_catch_bullet_mul=0;
		 self.m_bom_mul=0;
		 self.m_catch_chairID = 0;
		 self. m_bom_score=0;
         self.alive_limi_time=0;
		 self. m_catch_step=0;--//捕获进度
          self. m_catch_Mul_step={};
		  self. m_catch_Mul_step[0] = 0;--//3个阶段的分数
		  self.m_catch_Mul_step[1] = 0;--/3个阶段的分数
		  self.m_catch_Mul_step[2] = 0;--//3个阶段的分数
         self:setLocalZOrder(-1);
         if (self.fis_node) then 
                self.baseAngle = math.rad(90);
                local file_name ="";
			    local _sprite = nil;
		    	local readIndex = 0;
		     	local animation = cc.Animation:create();
                local i=0;
			    for  i = 0,35, 1 do
                   file_name=string.format("~InterlinkBombCrab_000_%03d.png", i);
				   local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then						
						local offset_name=string.format("InterlinkBombCrab_000_%03d.png", i);
						if (cc.exports.g_offsetmap_InitFlag[26]<1) then
							local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x*0.68;--t_offset_.x * 10/ 20;
		 	               t_offset_.y = -t_y*0.68;--t_offset_.y * 10/ 20;   
                           frame:setOffsetInPixels(t_offset_);
                           cc.exports.g_offsetCoin_InitFlag[i]=1;
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				 end
              end --for
              if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[26]=1;
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:addChild(_sprite, 0, 10086);
			  end
         end --  if (self.fis_node) then 
end
function InterlinkBombCrab:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
    cclog(" InterlinkBombCrab:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)----------");
    self.fis_node:removeChildByTag(7758258);
    self.m_no_catch_flag = 1;
	self.m_mov_timer = 0;
    self.alive_limi_time=0;
     --self.m_catch_timer_=0;
	self.m_catch_chairID = chair_id;
	self.m_catch_mul = fish_mul;
	self.m_catch_bullet_mul = bulet_mul;
	self.m_catch_score = score;
	self.fish_status_ = 2;
    self.m_fish_die_action_EndFlag = 0;
     if (bomFlag>0) then 
		  if (self.m_catch_score > 0) then 
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	      end
		  self.m_fish_die_action_EndFlag = 1;
		  return;
	  end
    self.m_catch_step = 0;
	self.m_catch_chairID = chair_id;
	self.fish_status_ = 2;
	self.m_catch_bullet_mul = bulet_mul;
	self.m_bom_mul = fish_mul;
	self.m_bom_score = score;
	self.m_catch_Mul_step[0] = fish_mul / 3;                       -- //3个阶段的分数
	self.m_catch_Mul_step[1] = fish_mul / 3;                       --//3个阶段的分数
	self.m_catch_Mul_step[2] = fish_mul / 3 + fish_mul % 3;---//3个阶段的分数
	self:setLocalZOrder(12);
     --播放光圈特效
	  if (self.fis_node) then 
            cclog(" InterlinkBombCrab:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)--------00--");
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
       --//添加炸弹
        if (self.fis_node) then 
            local t_cc_spr = cc.Sprite:create("haiwang/res/HW/InterlinkBombCrab/InterlinkBombCrabEff_000_000.png");
			if (t_cc_spr)
			then
				self.fis_node:addChild(t_cc_spr, 0, 10088);
				t_cc_spr:setScale(0.8);
				t_cc_spr:setAnchorPoint(cc.p(0.5,0.2));
				--//执行放大
				local fadein = cc.FadeIn:create(0.2);
				local scaleby = cc.ScaleTo:create(2, 1.8);
				local seq = cc.Sequence:create(fadein, scaleby, nil);
				t_cc_spr:runAction(seq);			
			end
			--//执行旋转		
            local function _ex_callback()
                self:Bom_Explor();
            end
			  local rotateto = cc.RotateBy:create(3, 360);
			  local funcall = cc.CallFunc:create(_ex_callback);
			  local seq = cc.Sequence:create(rotateto, funcall, nil);
			 self. fis_node:runAction(seq);		
        end --    if (self.fis_node) then 
       -- cclog(" InterlinkBombCrab:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)--------01--");
       	--通知炮塔生成图标chair_id, SCORE score, int bulet_mul, int fish_mul)
		cc.exports.g_cannon_manager:Catch_InterlinkBomb_(chair_id, 0, bulet_mul);
end
function  InterlinkBombCrab:Bom_Explor()--//引爆回调
    cc.exports.game_manager_:ShakeScreen();
	local t_effect_pos_ = cc.p(0, 0);	
    local node=self.fis_node:getChildByTag(10088);
	if (node) then
         local x,y=node:getPosition(); 
        t_effect_pos_ =cc.p(x,y);
     end
	 cc.exports.g_soundManager:PlayGameEffect("ScopeBombSound");
    local file_name ="";
	local _sprite = nil;
	local readIndex = 0;
	local animation = cc.Animation:create();
    local i=0;
    for  i = 0,40, 1 do
          file_name=string.format("~BroachCannonExplode_000_%03d.png", i);
		 local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		 if (frame) then						
			local offset_name=string.format("BroachCannonExplode_000_%03d.png", i);
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
            cc.exports.g_offsetCoin_InitFlag[i]=1;
			if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
			readIndex=readIndex+1;    
            animation:addSpriteFrame(frame);
	     end
     end --for
     if (readIndex > 0)	then 
         cc.exports.g_offsetmap_InitFlag[24]=1;
	    animation:setDelayPerUnit(1/24.0);
        local function call_back_()
           _sprite:removeFromParent();
        end
		local action =cc.Animate:create(animation);   
		local t_CCRepeat = cc.Repeat:create(action,1);
		local funcall = cc.CallFunc:create(call_back_);
		local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
		_sprite:runAction(seq);
		_sprite:setPosition(t_effect_pos_);
        self.fis_node:addChild(_sprite, 100);
		--_sprite:setScale(2.0);
	end
    self.fis_node:removeChildByTag(10086);
	self.fis_node:removeChildByTag(10088);
	self.fis_node:setRotation(0);
    if (self.m_catch_step<3) then
         --引爆
       	   local t_catch_mul =cc.exports.g_pFishGroup:InterlinkBombCrab_Bom(
                     self.fis_node:convertToWorldSpace(t_effect_pos_), 400, 
                     self.m_catch_chairID, self.m_catch_Mul_step[self.m_catch_step], self.m_catch_bullet_mul);
		   local tem_left_mul = self.m_catch_Mul_step[self.m_catch_step] - t_catch_mul;
		   if (self.m_catch_step < 2) then 
					self.m_catch_Mul_step[self.m_catch_step + 1] =self.m_catch_Mul_step[self.m_catch_step + 1]+ tem_left_mul;
					--更新UI分数
					cc.exports.g_cannon_manager:Add_InterlinkBomb_Score(self.m_catch_chairID, t_catch_mul*self.m_catch_bullet_mul);
	        else
					t_catch_mul = t_catch_mul+tem_left_mul;
                    local x,y=self.fis_node:getPosition();
					cc.exports.g_CoinManager:BuildCoin(cc.p(x,y), self.m_catch_chairID, tem_left_mul*self.m_catch_bullet_mul, tem_left_mul);
					cc.exports.g_cannon_manager:Set_InterlinkBomb_Score(self.m_catch_chairID, self.m_bom_score);
	     end
         if (self.m_catch_step<2) then 
            local t_effect_node = cc.Node:create();
			if (t_effect_node) then 
                self.fis_node:removeChildByTag(10088);
				self.fis_node:addChild(t_effect_node, 0, 10088);
				t_effect_node:setPosition(t_effect_pos_);
				local t_cc_spr0 = cc.Sprite:create("haiwang/res/HW/InterlinkBombCrab/InterlinkBombCrabEff_000_000.png");
                 if (t_cc_spr0) then 
                    t_effect_node:addChild(t_cc_spr0);
                    local rotateto = cc.RotateTo:create(0.8, 360);
					local t_repforever = cc.RepeatForever:create(rotateto);
					 t_cc_spr0:runAction(t_repforever);
                     -- //移动
                     local  t_winsize = cc.Director:getInstance():getWinSize();--::sharedDirector()->getWinSize();
					local t_arm_pos = cc.p(0, 0);
					if (self.m_catch_step == 0) then --//左边
							t_arm_pos = cc.p(300, t_winsize.height / 2);
					elseif (self.m_catch_step == 1) then --//右边
							t_arm_pos = cc.p((t_winsize.width - 300), t_winsize.height / 2);
                    end
                    local function call_back0()
                         self:Bom_Explor();
                    end
					t_arm_pos = self.fis_node:convertToNodeSpace(t_arm_pos);
					local moveBy = cc.MoveTo:create(0.8, t_arm_pos);
					local scaleto = cc.ScaleTo:create(0.8, 0.7);
					local funcall = cc.CallFunc:create(call_back0);
					local seq = cc.Sequence:create(moveBy, funcall, nil);
					--local t_spaw = cc.Spawn:create(seq, scaleto,nil);
					t_effect_node:runAction(seq);
                 end  --   if (t_cc_spr0) then 
            end --if (t_effect_node) then 
         end
    end-- if (self.m_catch_step<3) then
    self.m_catch_step= self.m_catch_step+1;
	if (self.m_catch_step >= 3) then cc.exports.g_cannon_manager:Exit_InterlinkBomb(self.m_catch_chairID); end
end
function  InterlinkBombCrab:OnFrame(delta_time)
   --cclog(" Fish:OnFrame dt=%f",dt);
  --  if(delta_time>0.04) then delta_time=0.04; end;
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
       -- if(self.alive_limi_time>20)then return true; end
      	if (self.m_fish_die_action_EndFlag>0) then return true; end
		self.m_mov_timer =self.m_mov_timer + delta_time;
		if (self.m_mov_timer > 15) then return true; end
   end
   return false;
end



function   InterlinkBombCrab:GetFish_Catch_Mul()--//获取游戏中鱼的倍数
		local mul =cc.exports.g_pFishGroup:getTotalFish_mul();
		mul = mul+self:get_fish_mulriple();
		return mul;
end
return InterlinkBombCrab;

--endregion

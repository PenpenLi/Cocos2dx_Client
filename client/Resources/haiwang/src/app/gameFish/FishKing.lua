-- region NewFile_1.lua
-- Author : Administrator
-- Date   : 2017/4/24
--  旋风鱼 同类炸弹

local FishKing = class("FishKing",cc.exports.Fish
--  function(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay)
--	return cc.exports.Fish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay)
--    end
)

function FishKing:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        FishKing.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
        self.m_kk_catch_flag = 0;
	    self. m_catch_fish_list={[0]=0,0,0,0,0,0,0,0,0,0};
        --self.m_catch_num=0;
        self.m_End_Flag = 0;
        self.m_catch_index=0;
        self.alive_limi_time=0;
		self.m_catch_timer = 0;
        self.m_run_Mul_Left=0;
		self.m_xuanfengCatch_step = 0;
		self.m_kk_catch_flag = 0;
		self.m_connect_Stop_Flag = 0;
		self.m_catch_bullet_mul = 0;
		self.m_catch_chairID=0;
		self.m_catch_mul=0;
		self.m_catch_score=0;
        self.fish_kind_ = fish_kind;
		self.m_catch_kind = fish_kind - 50;
		if (self.m_catch_kind < 0) then self.m_catch_kind = 0; end
		if (self.fis_node~=nil) then
			local tem_kind = self.fish_kind_ - 50		
			local  runtimer = 4.0;
            self:CreateSmall_fish(tem_kind,0,0,0);
			local back_spr = cc.Sprite:createWithSpriteFrameName("FishSameCircle_.png");      
			local rotateto = cc.RotateBy:create(runtimer, -360);
			local  ac = cc.RepeatForever:create(rotateto);
			back_spr:runAction(ac);
			self.fis_node:addChild(back_spr, -2, 10088);		
            self.bg_scale= cc.exports.game_fish_width[tem_kind]*0.68 / 160;
			back_spr:setScale(self.bg_scale);		
            --cclog("FishKing:ctor fish_kind_ =%d,tem_kind=%d,game_fish_width=%d",self.fish_kind_ ,tem_kind,cc.exports.game_fish_width[tem_kind])
	end
    --更换碰撞盒为圆型
     self.fis_node:removeChildByTag(7758258);
     local fish_body_node_=cc.Node:create();
     local body = cc.PhysicsBody:createCircle(100*self.bg_scale);
     body:setGroup(2);
     body:setDynamic(false);
     body:setGravityEnable(false);
     body:setContactTestBitmask(1);
     fish_body_node_:setPhysicsBody(body);
    self.fis_node:addChild(fish_body_node_,0,7758258);
end
function  FishKing:GetFish_Catch_Mul()--获取游戏中鱼的倍数	
	local mul = cc.exports.g_pFishGroup:getFish_mul_by_kind(self.m_catch_kind);
	      --if(mul==0) then  mul= mul+self:get_fish_mulriple(); end
          mul= mul+self:get_fish_mulriple();
	return mul;
end

function  FishKing:OnFrame(delta_time)
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
   end
   if (self.fish_status_ == 1)  then
        self.alive_limi_time= self.alive_limi_time+delta_time;
        if(self.alive_limi_time>70) then return  true ;end 
        if (self.m_mov_delay_timer > 0.0001) then 
			self.m_mov_delay_timer=self.m_mov_delay_timer-delta_time;
			return false;
		end
         if (self.m_kk_catch_flag == 0) then   --按原路径移动
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
                 --if(self.scene_fish_flag==0) then 
                  --  if(self.alive_limi_time>40) then return  true end;
                 --else 
                  if(self.alive_limi_time>60) then return  true end;
                 --end
                 if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动
              end
         end
   else 

   -----------------
    --self.alive_limi_time=self.alive_limi_time+delta_time;
    --if(self.alive_limi_time>20)then return true; end
    if (self.m_xuanfengCatch_step==1) then 
           self.m_catch_timer = self.m_catch_timer+delta_time;
           -- cclog("self.m_catch_timer=%f m_xuanfengCatch_step=%d",self.m_catch_timer,self.m_xuanfengCatch_step);
           	if (self.m_catch_timer <6) 	then          
                --cclog("self.m_catch_timer=%f m_xuanfengCatch_step=%d self.m_run_Mul_Left=%d  aaa",
                --self.m_catch_timer,self.m_xuanfengCatch_step,self.m_run_Mul_Left);   
				if (self.m_run_Mul_Left > 0) then 
					local t_fish = cc.exports.g_pFishGroup:GetFishByKind(self.m_catch_kind);
					if (t_fish~=nil) then 
                       
                       -- local t_index=self.m_catch_index;--#self.m_catch_fish_list;
                        --cclog("self.m_catch_timer=%f m_xuanfengCatch_step=%d,t_index=%d self.m_run_Mul_Left=%d",self.m_catch_timer,self.m_xuanfengCatch_step,t_index,self.m_run_Mul_Left);
						self.m_catch_fish_list[self.m_catch_index]=t_fish:fish_id();
                        self.m_catch_index=self.m_catch_index+1;
						self.m_run_Mul_Left = self.m_run_Mul_Left-t_fish:get_fish_mulriple();
						local  t_end_pos = cc.p(self.m_xuanfeng_pos_.x,self.m_xuanfeng_pos_.y);
						t_end_pos.x = t_end_pos.x+ math.random(0,100)%20 -10;
						t_end_pos.y = t_end_pos.y+ math.random(0,100)% 20 - 10;
						t_fish:xuanfengCatch(t_end_pos, self.m_catch_chairID, self.m_catch_bullet_mul);
					end
				else        
					self.m_xuanfengCatch_step = 2;
					self.m_catch_timer = 0;
				end
			elseif (self.m_catch_timer >10) then 
				self.m_xuanfengCatch_step = 2;
				self.m_catch_timer = 0;
		   end
    elseif (self.m_xuanfengCatch_step ==2)  then  --通知结束
             self.m_catch_timer = self.m_catch_timer +delta_time;
            -- cclog("self.m_catch_timer=%f m_xuanfengCatch_step=%d",self.m_catch_timer,self.m_xuanfengCatch_step);
			if (self.m_catch_timer > 2)	then
				if (self.m_catch_index> 0) then 
					local  t_catch_score = self.m_catch_bullet_mul*self.fish_multiple_;
                    local i=0;
                   --  if(self.m_catch_index>#self.m_catch_fish_list) then self.m_catch_index=#self.m_catch_fish_list; end
					for i = 0, self.m_catch_index-1,1 do	
                        local t_fish_id=self.m_catch_fish_list[i];
						local t_fish =cc.exports.g_pFishGroup:GetFish(t_fish_id); --self.m_catch_fish_list[i];
						if(t_fish) then t_fish:CatchFish(self.m_catch_chairID, t_catch_score, self.m_catch_bullet_mul, 0, 1); end
					end                
				end 
                 self.fis_node:removeAllChildren();
                 --cclog("self.m_xuanfengCatch_step=%d",self.m_xuanfengCatch_step);
				cc.exports.g_cannon_manager:catch_king_card_End(self.m_catch_chairID, self.m_catch_score, self.m_catch_bullet_mul);
				self.m_xuanfengCatch_step = 3;
				self.m_catch_timer = 0;
		end
    elseif (self.m_xuanfengCatch_step == 3)  then 
            self.m_xuanfengCatch_step = 4;
			local t_xuanwo =self:getChildByTag(125988);	--结束
             local function call_back()
                self:PlayXuanfengEffectCallBack();
             end
			if (t_xuanwo) then 
				local scaleto1 = cc.ScaleTo:create(0.5, 0.0);
				local t_delay = cc.DelayTime:create(1);
				local callfunc = cc.CallFunc:create(call_back);
				local t_seq = cc.Sequence:create(t_delay,scaleto1, callfunc, nil);
				t_xuanwo:runAction(t_seq);			
			else self.m_End_Flag = 1; end
    end
   end
    if (self.m_End_Flag>0) then return true; end
   return false;
end

function   FishKing:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
    --cclog("  FishKing:CatchFish( chair_id=%d,  score=%d,  bulet_mul=%d,  fish_mul=%d,  bomFlag=%d)",chair_id,  score,  bulet_mul,  fish_mul,  bomFlag);
    self.fis_node:removeChildByTag(7758258);
	self.m_End_Flag = 0;
    self.m_catch_index=0;
	self.m_catch_chairID = chair_id;
	self.m_catch_mul = fish_mul;
	self.m_catch_bullet_mul = bulet_mul;
	self.m_catch_score = score;
    self.fish_status_ = 2;
    self.alive_limi_time=0;
    self.m_run_Mul_Left=fish_mul-self:get_fish_mulriple();
	if (bomFlag>0) then 
		if (self.m_catch_score > 0) then 
			local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
            cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		    cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
		end	
		self.m_mov_timer = 0;
		self.m_End_Flag = 1;
		return;
	end
    self:setLocalZOrder(-1);
   -- cclog("  FishKing:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag) 111111111111111111");
     cc.exports.g_soundManager:PlayFishEffect(self.fish_kind_);
    --播放特效
	--My_Particle_manager::GetInstance()->PlayParticle(1, fis_node->getPosition());
    cc.exports.g_My_Particle_manager:PlayParticle(1, self:GetFishccpPos());
	cc.exports.game_manager_:ShakeScreen();
    if(self.fis_node) then
		self.fis_node:removeChildByTag(10088);
		self.fis_node:removeChildByTag(10086);	
		local fish_spr = self:CreateSmall_fishDead(self.fish_kind_ - 50);
		self.fis_node:addChild(fish_spr,1,10);
		fish_spr:setRotation(-90);
        local t_rotac=cc.RotateBy:create(2,360);
        fish_spr:runAction(t_rotac);
	end  
	self:PlayXuanfengEffect(chair_id, score, fish_mul, 1);                                 --在玩家前面生成旋涡
	cc.exports.g_cannon_manager:catch_king_card_(chair_id, score, bulet_mul);--通知ui
end
function  FishKing:Fish_Die_ActionCallback()
     	--self.m_fish_die_action_EndFlag = 1;
		--self.fis_node:removeAllChildren();
end
function FishKing:xuanfengCatch( catch_pos,  chair_id,  mul)--//被旋风鱼王捕获
   --cclog(" FishKing:xuanfengCatch( catch_pos,  chair_id,  mul)-----------------------------------------------------------");
	if (self.m_no_catch_flag == 0) then	
		self:setLocalZOrder(100);
        --[[
        self.m_End_Flag = 0;
	    self.m_catch_chairID = chair_id;
    	self.m_catch_mul = fish_multiple_;
   	    self.m_catch_bullet_mul = mul*fish_multiple_;
	    self.m_catch_score = score;
        self.fish_status_ = 2;
        --]]
		self.m_no_catch_flag = 1;
		self.m_kk_catch_flag = 1;
		self.m_fish_mov_by_actionFlag = 1;
		self.m_moveKind = 1;
		self.m_xuanfeng_catch_score = mul*self.fish_multiple_;
		self.m_xuanfeng_catch_chair_id = chair_id;
		--移动=旋转 缩小 ：(捕获 (针对旋风鱼王) 移除)
         if(self.fis_node) then
		    self.fis_node:removeChildByTag(10088);
	    	self.fis_node:removeChildByTag(10086);	
		    local fish_spr = self:CreateSmall_fishDead(self.fish_kind_ - 50);
		    self.fis_node:addChild(fish_spr,1,10);
		    fish_spr:setRotation(-90);
            local t_rotac=cc.RotateBy:create(2,360);
            fish_spr:runAction(t_rotac);
	    end  
		if (self.fis_node)	then 
           local function  call_back__()
              self:xuanfengActionEndCallBack();
            end
			local t_movto = cc.MoveTo:create(0.5, catch_pos);
			local t_Catch_End = cc.CallFunc:create(call_back__);
			local t_seq = cc.Sequence:create(t_movto, t_Catch_End, nil);
			self.fis_node:runAction(t_seq);
		end
	end
end
function  FishKing:xuanfengActionEndCallBack()      --//动作结束回调
     cc.exports.g_soundManager:PlayGameEffect("SameKindBombSound");
--	 local t__local_info_type = cc.exports._local_info_array_[self.m_chair_num];
--	local  t_angle = math.rad(t__local_info_type.default_angle);
--	local t_xuanfeng_pos = cc.p(t__local_info_type.x, t__local_info_type.y);--可以是座位前方 其他要视频确认
--	t_xuanfeng_pos.x= t_xuanfeng_pos.x+280 * math.sin(t_angle);
--	t_xuanfeng_pos.y= t_xuanfeng_pos.y+280 * math.cos(t_angle);
	self.fish_status_ = 2;
	self.m_End_Flag = 1;
end
function FishKing:PlayXuanfengEffect( chair_id,  score, mul, if_bg)--播放旋风if_bg标记是否显示旋风 用于区分KIND  KIND
    --cclog(" FishKing:PlayXuanfengEffect( chair_id,  score, mul, if_bg)......................................");
     cc.exports.g_soundManager:PlayGameEffect("SameKindBombSound");--//在玩家前面显示UI
    local t__local_info_type = cc.exports._local_info_array_[self.m_catch_chairID];
	local  t_angle = math.rad(t__local_info_type.default_angle);
	self.m_xuanfeng_pos_ = cc.p(t__local_info_type.x, t__local_info_type.y)
	self.m_xuanfeng_pos_.x= self.m_xuanfeng_pos_.x+280 * math.sin(t_angle);
	self.m_xuanfeng_pos_.y = self.m_xuanfeng_pos_.y+280 * math.cos(t_angle);
	self.m_catch_chairID = chair_id;
	self.m_catch_mul = mul;
	self.m_catch_timer = 0;
	self.m_catch_score = score;
	--self.m_run_Mul_Left = self.m_catch_mul;
	self.m_xuanfengCatch_step = 1;
	self:setLocalZOrder(-1);
    --自移动到旋风
    local t_move_to=cc.MoveTo:create(0.5,cc.p(self.m_xuanfeng_pos_.x,self.m_xuanfeng_pos_.y));
    self.fis_node:runAction(t_move_to);
    --
    if (if_bg) then
        local spriteFrame=cc.SpriteFrameCache:getInstance();
		local tem_bg_scale = 1.3;
		local _sprite = nil;
		local file_name="";
		local  readIndex = 0;
		local animation = cc.Animation:create();
		for i=0, 70,1 do  
           file_name = string.format("~xuanfeng_000_%03d.png", i);
           local blinkFrame = spriteFrame:getSpriteFrame(file_name);
           if (blinkFrame) then
                     local offset_name = string.format("xuanfeng_000_%03d.png", i);
                     if (cc.exports.g_offsetmap_kindxuanfnegnFlag == 0) then
                        local t_offset_ = cc.p(0, 0);
                        local t_offect_str = cc.exports.OffsetPointMap[offset_name].Offset;
                        local t_s_sub_x, t_s_sub_y = string.find(t_offect_str, ",");
                        local t_x = string.sub(t_offect_str, 0, t_s_sub_x - 1);
                        local t_y = string.sub(t_offect_str, t_s_sub_y + 1, #t_offect_str);
                        local t_offeset_pos = cc.p(0, 0);
                        local t_offset_0 = blinkFrame:getOffsetInPixels();
                        t_offset_.x = t_x/2;
                        t_offset_.y = - t_y/2;
                        blinkFrame:setOffsetInPixels(t_offset_);
                    end
                   if (_sprite == nil) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
                   readIndex = readIndex + 1;
                   animation:addSpriteFrame(blinkFrame);
            end --if blinkFrame
		end --for
		if (_sprite) then	
           cc.exports.g_offsetmap_kindxuanfnegnFlag=1;
			if (readIndex > 0)then 
                 animation:setDelayPerUnit(1/12.0);
                 local action =cc.Animate:create(animation);   
				_sprite:runAction(cc.RepeatForever:create(action));
			end
			local t_xuanfnegNode = cc.Node:create();		
			t_xuanfnegNode:setScale(0.0001);
		    local t_scale_to = cc.ScaleTo:create(0.5, 1.5);
			t_xuanfnegNode:runAction(t_scale_to);
			t_xuanfnegNode:addChild(_sprite);
			self:addChild(t_xuanfnegNode, -1, 125988);
			t_xuanfnegNode:setPosition(self.m_xuanfeng_pos_);
	  end
	end
end
function  FishKing:PlayXuanfengEffectCallBackAddScore()--//加分回调
   self.m_xuanfengCatch_step = 2;
--[[
    local  t__local_info_type = cc.exports._local_info_array_[self.m_catch_chairID];
	local  t_angle = math.rad(t__local_info_type.default_angle);
	local  t_xuanfeng_pos = cc.p(t__local_info_type.x, t__local_info_type.y);
	t_xuanfeng_pos.x= t_xuanfeng_pos.x+280 * sinf(t_angle);
	t_xuanfeng_pos.y= t_xuanfeng_pos.y+280 * cosf(t_angle);
	if (self.m_catch_score > 0)then
         local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
         cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		 cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	end
    --]]
end
function  FishKing:PlayXuanfengEffectCallBack()--//结束回调
          self.m_End_Flag = 1;
end
return FishKing;

--endregion

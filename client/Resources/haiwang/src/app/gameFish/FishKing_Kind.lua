--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成
local FishKing_Kind = class("FishKing_Kind",cc.exports.Fish)
function FishKing_Kind:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        FishKing_Kind.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
         self.m_catch_chairID=0;
		 self.m_catch_mul=0;
		 self.m_End_Flag = 0;
         self.m_catch_index=0;
		 self.m_catch_score=0;
         self.alive_limi_time=0;
		 self.m_xuanfengCatch_step = 0;
		 self.m_catch_bullet_mul = 0;
         self.m_xuanfengCatch_step=0; --捕获进度
	     self.m_catch_timer=0;
	     self.m_xuanfeng_pos_=cc.p(0,0);
     	 self.m_run_Mul_Left=0;
	     self.m_End_Flag=0;
         self.m_catch_index=0;
	     self.m_catch_score=0;
	      self.m_catch_fish_list={};
	      self.m_catch_fish_kindlist={};
         if (self.fis_node) then
            self.fish_kind_ = fish_kind;
			local runtimer = 4.0;
			local back_spr = nil;
			local fish_spr = nil;
			local rotateto = cc.RotateBy:create(runtimer, -360);
			local ac = cc.RepeatForever:create(rotateto);
			back_spr = cc.Sprite:createWithSpriteFrameName("SameKindKingRing.png");
			back_spr:runAction(ac);
			self.fis_node:addChild(back_spr, 0, 10088);
			local tem_kind = self.fish_kind_ - 40;
            self.m_catch_kind=tem_kind;
            self.bg_scale= cc.exports.game_fish_width[tem_kind]*0.68  / 160;
            --local tem_bg_scale=game_fish_width[tem_kind] * game_fish_frame_Scale[tem_kind] / 160.0;
			back_spr:setScale( self.bg_scale);
			self:CreateSmall_fish(tem_kind,0,0,0);
			--self.fis_node:addChild(fish_spr, 1, 10086);
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
function FishKing_Kind:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
     
      -- cclog("FishKing_Kind:CatchFish( chair_id=%d,  score=%d,  bulet_mul=%d,  fish_mul=%d,  bomFlag=%d)",chair_id,  score,  bulet_mul,  fish_mul,  bomFlag);
      self.fis_node:removeChildByTag(7758258);
      self.m_catch_chairID = chair_id;
	  self.m_catch_mul = fish_mul;
	  self.m_catch_bullet_mul = bulet_mul;
	  self.m_run_Mul_Left = fish_mul-self:get_fish_mulriple();
	  self.m_catch_score = score;
	  self.m_catch_timer = 0;
      self.alive_limi_time=0;
      self.m_catch_index=0;
	 self.m_mov_timer = 0;
	 self.fish_status_ = FISH_DIED;
	 self.m_xuanfengCatch_step = 1;
     if (bomFlag>0) then
		if (self.m_catch_score > 0)	then
			  local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
		end
		self.m_End_Flag = 1;
		return;
	end
    cc.exports.g_soundManager:PlayGameEffect("SameKindKingDone");
	cc.exports.g_soundManager:PlayGameEffect("SameKindBombSound");
	self:setLocalZOrder(-1);
    cc.exports.game_manager_:ShakeScreen();
    if (self.fis_node)then
		self.fis_node:removeChildByTag(10088);
		self.fis_node:removeChildByTag(10086);		
        self.fis_node:removeChildByTag(10088);
		self.fis_node:removeChildByTag(10086);	
        --self.m_catch_kind
		local fish_spr = self:CreateSmall_fishDead(self.m_catch_kind);
		self.fis_node:addChild(fish_spr,1,10);
		fish_spr:setRotation(-90);
        local t_rotac=cc.RotateBy:create(2,360);
        fish_spr:runAction(t_rotac);
	    --播放特效
		--	My_Particle_manager::GetInstance()->PlayParticle(1, fis_node->getPosition());
        cc.exports.g_My_Particle_manager:PlayParticle(1, self:GetFishccpPos());
	end
    --生成旋涡
	self:PlayXuanfengEffect(chair_id, score, fish_mul, 1);
    cc.exports.g_cannon_manager:catch_king_king_card_(self.m_catch_chairID, self.m_catch_score, self.m_catch_bullet_mul);

end
function  FishKing_Kind:OnFrame(delta_time)
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
                 --if(self.scene_fish_flag==0) then 
                 --   if(self.alive_limi_time>30) then return  true end;
                -- else 
                    if(self.alive_limi_time>60) then return  true end;
                 --end
                if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动
              end
         end
   else 
      --self.alive_limi_time=self.alive_limi_time+delta_time;
      --if(self.alive_limi_time>20)then return true; end
      if (self.m_xuanfengCatch_step == 1) then --//吸收旋风鱼
           if (#self.m_catch_fish_kindlist> 1) then 
				self.m_catch_timer = self.m_catch_timer +delta_time;
				if (self.m_catch_timer > 1)then
					self.m_catch_timer = 0;
					self.m_xuanfengCatch_step = 2;
				end
			else
				self.m_catch_timer = 0;
				self.m_xuanfengCatch_step = 2;
			end
      elseif (self.m_xuanfengCatch_step == 2) then --//吸收鱼
      	       self.m_catch_timer =self.m_catch_timer+delta_time;
               if(self.m_catch_timer >4) then 
                 self.m_catch_timer=0;
                 self.m_xuanfengCatch_step = 3;
               end
                if (self.m_run_Mul_Left > 0) then --吸收
			       local i=0;
				   for  i = 0,#self.m_catch_fish_kindlist,1  do
					    local t_fish =cc.exports.g_pFishGroup:GetFishByKind(self.m_catch_fish_kindlist[i]);
					    if (t_fish) then 
						   if(self.m_run_Mul_Left>t_fish:get_fish_mulriple()) then 
						         self.m_run_Mul_Left =self.m_run_Mul_Left- t_fish:get_fish_mulriple();
                                 self.m_catch_fish_list[self.m_catch_index]=t_fish:fish_id();
                                 --self.m_catch_fish_list[self.m_catch_index]=t_fish;
                                 self.m_catch_index=self.m_catch_index+1;
						         local  t_end_pos =cc.p(self.m_xuanfeng_pos_.x,self.m_xuanfeng_pos_.y);
						         t_end_pos.x =t_end_pos.x+ math.random(0,100) % 20 -10;
						         t_end_pos.y =t_end_pos.y+ math.random(0,100) % 20 -10;
						         t_fish:xuanfengCatch(t_end_pos, self.m_catch_chairID, self.m_catch_bullet_mul);
                            end
					    end
				end
			else
				self.m_xuanfengCatch_step = 3;
				self.m_catch_timer = 0;
			end
      elseif (self.m_xuanfengCatch_step == 3) then --//吸收完毕
            self.m_catch_timer = self.m_catch_timer+delta_time;
			if (self.m_catch_timer > 2) then 
				if (self.m_catch_index>0) then 
					local t_catch_score = self.m_catch_bullet_mul*self.fish_multiple_;
                    local i=0;
					for i = 0, self.m_catch_index-1, 1 do
						--local t_fish = self.m_catch_fish_list[i];
                        local t_fish_id=self.m_catch_fish_list[i];
						local t_fish =cc.exports.g_pFishGroup:GetFish(t_fish_id); --self.m_catch_fish_list[i];
						if(t_fish) then t_fish:CatchFish(self.m_catch_chairID, t_catch_score, self.m_catch_bullet_mul, 0, 1);end
					end
				end
				cc.exports.g_cannon_manager:catch_king__king_card_End(self.m_catch_chairID, self.m_catch_score, self.m_catch_bullet_mul);
				self.m_xuanfengCatch_step = 4;
				self.m_catch_timer = 0;
			end
      elseif (self.m_xuanfengCatch_step == 4) then --//吸收鱼
             local function call_back()
                self:PlayXuanfengEffectCallBack();
           end
            self.m_xuanfengCatch_step = 5;
			local t_xuanwo = self:getChildByTag(125988);	--结束
			if (t_xuanwo)	then
				local  scaleto1 = cc.ScaleTo:create(0.5, 0.0);
				local t_delay = cc.DelayTime:create(1);
				local callfunc = cc.CallFunc:create(call_back);
				local t_seq = cc.Sequence:create(t_delay,scaleto1, callfunc, nil);
				t_xuanwo:runAction(t_seq);
			else m_End_Flag = 1; end
      end
   end
     if (self.m_End_Flag>0) then return true; end
   return false;
end
function  FishKing_Kind:PlayXuanfengEffect(chair_id,  score,  mul,  if_bg)--播放旋
      if (self.m_no_catch_flag >0) then return; end;
     --cclog("FishKing_Kind:PlayXuanfengEffect(chair_id=%d,  score=%d,  mul=%d,  if_bg=%d)000000000000000000",chair_id,score,mul,if_bg);
    cc.exports.g_soundManager:PlayGameEffect("SameKindBombSound");--在玩家前面显示UI
	local t__local_info_type =cc.exports._local_info_array_[chair_id];
	local  t_angle = math.rad(t__local_info_type.default_angle);
	self.m_xuanfeng_pos_ = cc.p(t__local_info_type.x, t__local_info_type.y);--可以是座位前方 其他要视频确认
	self.m_xuanfeng_pos_.x = self.m_xuanfeng_pos_.x+280 * math.sin(t_angle);
	self.m_xuanfeng_pos_.y =self.m_xuanfeng_pos_.y+ 280 * math.cos(t_angle);
	self.m_catch_chairID = chair_id;
	self.m_catch_mul = mul;
	self.m_catch_timer = 0;
    self.m_End_Flag =0;
	self.m_catch_score = score;
	--self.m_run_Mul_Left = self.m_catch_mul;
	self.m_xuanfengCatch_step = 1;
	self:setLocalZOrder(-1);
      --自移动到旋风
    local t_move_to=cc.MoveTo:create(0.5,cc.p(self.m_xuanfeng_pos_.x,self.m_xuanfeng_pos_.y));
    self.fis_node:runAction(t_move_to);
    --
   -- cclog("FishKing_Kind:PlayXuanfengEffect(chair_id=%d,  score=%d,  mul=%d,  if_bg=%d)aaaaaaaaaaaaaaaaaaaaaaaaa",chair_id,score,mul,if_bg);
    if (if_bg>0) then
		local tem_bg_scale = 1.3;
		local _sprite = nil;
		local  file_name="";
		local  readIndex = 0;
	    local animation = cc.Animation:create();
        local spriteFrame=cc.SpriteFrameCache:getInstance();
		for i=0, 70,1 do  
			file_name= string.format("~FWindCircleD_000_%03d.png", i);
			local blinkFrame = spriteFrame:getSpriteFrame(file_name);
			if (blinkFrame) then	
                    --  <key>~FWindCircleD_000_000.png</key>
		        	local offset_name = string.format("FWindCircleD_000_%03d.png", i);
                    --cc.exports.g_offsetmap_KKxuanfnegnFlag=0;
                     if (cc.exports.g_offsetmap_KKxuanfnegnFlag == 0) then
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
                   if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
                   readIndex = readIndex + 1;
                   animation:addSpriteFrame(blinkFrame);
			end --if
		end --end for
       -- 
        --cclog("FishKing_Kind:PlayXuanfengEffect(chair_id=%d,  score=%d,  mul=%d,  if_bg=%d)222222222222",chair_id,score,mul,if_bg);
        --cclog("FishKing_Kind:PlayXuanfengEffect   readIndex=%d",readIndex);
        if (_sprite~=nil) then	
            --cclog("FishKing_Kind:PlayXuanfengEffect(chair_id=%d,  score=%d,  mul=%d,  if_bg=%d)m_xuanfeng_pos_(%f,%f)",chair_id,score,mul,if_bg,self.m_xuanfeng_pos_.x,self.m_xuanfeng_pos_.y);
           cc.exports.g_offsetmap_KKxuanfnegnFlag=1;                               
            animation:setDelayPerUnit(1/12.0);
             local action =cc.Animate:create(animation);   
		   _sprite:runAction(cc.RepeatForever:create(action));
			local t_xuanfnegNode = cc.Node:create();		
			--t_xuanfnegNode:setScale(0.0001);
		    local t_scale_to = cc.ScaleTo:create(0.5, 1.5);
			t_xuanfnegNode:runAction(t_scale_to);
			t_xuanfnegNode:addChild(_sprite);
			self:addChild(t_xuanfnegNode, -1, 125988);
			t_xuanfnegNode:setPosition(self.m_xuanfeng_pos_);
	  end
      --查找所有的同类鱼王
		self.m_catch_fish_kindlist[0]=self.m_catch_kind;--自身
        local  t_index=1;
        local i=0;
		for  i = 50,59,1 do
        --  cclog("FishKing_Kind:PlayXuanfengEffect(chair_id=%d,  score=%d,  mul=%d,  GetFishByKind=%d)aaaaaaaaaaaaaaaaaaaaaaaaa",chair_id,score,mul,i);
			local t_fish =cc.exports.g_pFishGroup:GetFishByKind(i);

			if (t_fish) then
				t_fish:xuanfengCatch(self.m_xuanfeng_pos_, self.m_catch_chairID, self.m_catch_bullet_mul);
				self.m_catch_fish_kindlist[t_index]=(i - 50);
                t_index=t_index+1;
            end
        end
	end
end
function     FishKing_Kind:GetFish_Catch_Mul()--获取游戏中鱼的倍数
	    local  mul =cc.exports.g_pFishGroup:getFish_mul_by_kind((self.fish_kind_ - 40));
 		--if(mul==0) then mul = mul+self:get_fish_mulriple(); end
        mul = mul+self:get_fish_mulriple();
        local i=0;
		for i = 50,59, 1 do
			local t_fish = cc.exports.g_pFishGroup:GetFishByKind(i);
			if (t_fish) then 
				mul = mul+cc.exports.g_pFishGroup:getFish_mul_by_kind(i - 50);
			end
	   end
	return mul;
end
function  FishKing_Kind:PlayXuanfengEffectCallBackAddScore()--加分回调
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
end
function  FishKing_Kind:PlayXuanfengEffectCallBack()
                   self.m_End_Flag = 1;
end
return  FishKing_Kind;
--endregion

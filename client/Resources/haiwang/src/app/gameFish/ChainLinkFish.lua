--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成
local ChainLinkFish = class("ChainLinkFish",cc.exports.Fish)
function ChainLinkFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
        ChainLinkFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
        self.m_start_timer=0;
        self.m_ChainLinkCatch_flag = 0;
        self.m_fish_die_action_EndFlag =0;
        self.m_End_Flag=0;
         self.alive_limi_time=0;
	    self.m_Last_fish_ID = 0;
	    self.m_Mul_ListSize = 0;                                       --捕获数量
	    self.m_Mul_Total_ = 0;                                         --捕获总倍数
	    self.m_catch_score=0;
	    self.m_catch_timer = 0;
	    self.m_search_Next_flag = 0;
	    self.m_catch_bullet_mul=0;
        self.m_ChainLink_KindList={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        self.m_ChainLink_IDList={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        self.m_chainLink_FinishList={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
        self.m_ChainLink_Position={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
        if (self.fis_node) then 
            self.fish_kind_ = fish_kind;
			local runtimer = 4.0;
			local _sprite = nil;
			local fish_spr = nil;
			local tem_kind = self.fish_kind_-30;
			local tem_bg_scale = game_fish_width[tem_kind]*0.68/80.0;
            local readIndex = 0;
            local animation = cc.Animation:create();
            local file_name="";
            local i=0;
			for  i = 0,25, 1 do
                file_name=string.format("~ChainShell_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then								
						if (cc.exports.g_offsetmap_CL_RingFlag<1) then
                            local offset_name=string.format("ChainShell_000_%03d.png", i);
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
				end  --if (frame) then				
            end   --end for
            if (readIndex > 0)	then 
			       animation:setDelayPerUnit(1/12.0);
				   local action =cc.Animate:create(animation);   
			    	_sprite:runAction(cc.RepeatForever:create(action));
                   _sprite:setScale(tem_bg_scale);
                   self.fis_node:addChild(_sprite,10, 1022);
			end  --
            self:CreateSmall_fish(tem_kind,0,0,0);
                  --更换碰撞盒为圆型
             self.fis_node:removeChildByTag(7758258);
              local fish_body_node_=cc.Node:create();
              local body = cc.PhysicsBody:createCircle(60*tem_bg_scale);
               body:setGroup(2);
               body:setDynamic(false);
               body:setGravityEnable(false);
              body:setContactTestBitmask(1);
              fish_body_node_:setPhysicsBody(body);
             self.fis_node:addChild(fish_body_node_,0,7758258);
        end  --end if (self.fis_node) 
end

 function ChainLinkFish:OnFrame( delta_time,  lock)
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
   end
   if (self.fish_status_ == 1)  then
        self.alive_limi_time= self.alive_limi_time+delta_time;
        if(self.alive_limi_time>70) then return  true ;end 
        if (self.m_mov_delay_timer > 0.0001) then 
			self.m_mov_delay_timer=self.m_mov_delay_timer-delta_time;
			return false;
		end
         self:ChainLindFishUpdate(delta_time);
         if (self.m_ChainLinkCatch_flag == 0) then 
             --按原路径移动
            if (self.m_moveKind < 2) then 
                 --self.check_timer=self.check_timer+delta_time;
                 --if(self.alive_limi_time>70) then return  true ;end 
                 if(self.check_timer>0.15) then 
                   self.check_timer=0;
				   self:CheckValid();    
                 end                   
                 self.m_mov_timer= delta_time;-- end
                 if ( self.m_mov_timer > 0.0333) then 
                     local  Mov_Step =1
                     self.m_mov_timer = self.m_mov_timer -0.0333;
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
                  if(self.alive_limi_time>60) then return  true end;
               if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动
        end--<if (self.m_moveKind < 2)
        elseif(self.m_ChainLinkCatch_flag > 0) then
            --cclog("elseif(self.m_ChainLinkCatch_flag=%d > 0) then",self.m_ChainLinkCatch_flag);
            self.m_start_timer = self.m_start_timer+delta_time;
            --if(self.alive_limi_time>20) then self:End(); end 
            if ( self.m_ChainLinkCatch_flag == 1) then              
               if (self.m_start_timer > 10) then 	
					self:End();
					self.m_start_timer = 5;
				end
				if (self.m_search_Next_flag>0) then--寻找下一个	
					local t_next_id = self:LinkToNext();
					if (t_next_id>=0)	then
						self.m_search_Next_flag = 0;	--通知最近的ID			
						local t_fish = cc.exports.g_pFishGroup:GetFish(self.m_Last_fish_ID);
						if (t_fish)	then
							t_fish:ChainLinkFishCatchToNext(self:fish_id(),t_next_id);
						end
					end
			end
            elseif( self.m_ChainLinkCatch_flag == 2) then
                 --cclog("elseif(self.m_ChainLinkCatch_flag=%d > 0) then aa",self.m_ChainLinkCatch_flag);
                 self.m_catch_timer =self.m_catch_timer+ delta_time;
				if (self.m_catch_timer > 5) then 
                      cclog("elseif(self.m_ChainLinkCatch_flag=%d > 0)m_Mul_ListSize=%d ", self.m_ChainLinkCatch_flag,self.m_Mul_ListSize);
                      local i=0;
                      if(self.m_Mul_ListSize>#self.m_ChainLink_IDList) then self.m_Mul_ListSize=#self.m_ChainLink_IDList; end
                      local tem_kind = self.fish_kind_ - 30;
				      if (self.fis_node) then 
                             local x,y=self.fis_node:getPosition();
                             self.m_mov_position.x=x;
                             self.m_mov_position.y=y;
							self.fis_node:removeChildByTag(10086);
							local t_spr=self:CreateSmall_fishDead(tem_kind);
							if (t_spr) then self.fis_node:addChild(t_spr, 0, 10086); end
							local t_self_score = self.fish_multiple_*self:get_fish_mulriple();
							if (t_self_score > 0)
							then 
                              local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, t_self_score);
                              cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		                       cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, t_self_score, self.m_Mul_Total_);
							end
					end
                    
                     for  i = 0,self.m_Mul_ListSize-1,1 do		                   		
						local t_fish = cc.exports.g_pFishGroup:GetFish(self.m_ChainLink_IDList[i]);
						if (t_fish) then 
                           cclog("elseif(self.m_ChainLinkCatch_flag=%d > 0)ChainLindFishExplor=%d ", self.m_ChainLinkCatch_flag,self.m_ChainLink_IDList[i]);
							t_fish:ChainLindFishExplor(0, self.m_catch_chairID, self.m_catch_bullet_mul, 0);	--要保证倍率一致
						end
					end--for
                    --self.fish_status_ = 2;
                    cc.exports.g_cannon_manager:Catch_ChainShell_End(self.m_catch_chairID, self.m_catch_score, self.m_catch_bullet_mul);
                    self.m_End_Flag=1;
                    self.m_fish_die_action_EndFlag=1;
                end--f (self.m_catch_timer > 5)
            end--if( self.m_ChainLinkCatch_flag == 2)       
        else  --if (self.fish_status_ == 1)        	
        end
   end
    if (self.m_fish_die_action_EndFlag>0) then return true; end
    if (self.m_End_Flag>0) then return true; end
   return false;
 end;
function ChainLinkFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
     cclog("ChainLinkFish:CatchFish bomFlag=%d",bomFlag);
     self.m_catch_chairID = chair_id;
	 self.m_catch_mul = fish_mul;
	 self.m_catch_bullet_mul = bulet_mul;
	 self.m_catch_timer = 0;
     self.alive_limi_time=0;
	 self.m_start_timer = 0;
	 self.m_mov_timer = 0;
	 self.m_catch_score = score;
	if (bomFlag>0)then
		if (self.m_catch_score > 0)then 
               local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
              cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		      cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
		end
		self.fish_status_ = 2;
		self.m_fish_die_action_EndFlag = 1;
         --cclog("ChainLinkFish:CatchFish bomFlag=%d bb",bomFlag);
		return;
	end--if (bomFlag>0)
    self:ChainLinkFish_lock();
    self.m_Mul_Total_ = fish_mul;
	self:setLocalZOrder(30);
	self:StartChainLink(fish_mul, chair_id);
    cc.exports.g_cannon_manager:Catch_ChainShell_(chair_id, score, bulet_mul);
end
--[[
function ChainLinkFish:ChainLinkStartCallBack()
       self.m_chainLink_FinishList={[0]=0,0,0,0,0,0,0,0,0,0,0,0};
       if (self.m_ChainLinkCatch_flag == 0) then 
                self.m_Mul_Total_ = mul;
                self:getChainLinkMulEx(mul);
                self.m_ChainLinkCatch_flag = 1;
	           	self.m_Mul_ListSize = 0;
                local i=0;
                for  i = 0, 9,1 do
			        if (self.m_ChainLink_KindList[i] >= 0) then 
				        self.m_Mul_ListSize=self.m_Mul_ListSize+1; 
			       end
		    end --for
             --第一个位置 跟玩家位置相关
			local t__local_info_type = _local_info_array_[chair_id];
			local t_angle_num = math.rad(t__local_info_type.default_angle);
			local t_pos = cc.p(t__local_info_type.x, t__local_info_type.y);
			t_pos.x = t_pos.x+200 * math.sin(t_angle_num);
			t_pos.y = t_pos.y+200 * math.cos(t_angle_num);
			self.m_ChainLink_Position[0] = t_pos;
			self.m_chainLink_FinishList[0] = 1;	
			self.fis_node:removeChildByTag(1022);--更换光罩
            --cclog("ChainLinkFish:ChainLinkStartCallBack ChainLinkFishCatch");
			self:ChainLinkFishCatch(self:fish_id(), t_pos, mul, 0);		
            --cclog("ChainLinkFish:ChainLinkStartCallBack ChainLinkFishCatch  end");
       end --if (self.m_ChainLinkCatch_flag == 0)
end
--]]
function   ChainLinkFish:GetFish_Catch_Mul() return self:getChainLinkMul(); end;--//获取游戏中鱼的倍数


function ChainLinkFish:StartChainLink( mul, chair_id)--//激活闪电链 根据倍数来算出闪电内容 还是在运行过程动态管理闪电内容
       cclog(" ChainLinkFish:StartChainLink mul=%d,chair_id=%d",mul, chair_id);
       self.m_chainLink_FinishList={[0]=0,0,0,0,0,0,0,0,0,0,0,0};
       if (self.m_ChainLinkCatch_flag == 0) then 
                self.m_Mul_Total_ = mul;
                self:getChainLinkMulEx(mul);
                self.m_ChainLinkCatch_flag = 1;
	           	self.m_Mul_ListSize = 0;
                local i=0;
                for  i = 0, 9,1 do
			        if (self.m_ChainLink_KindList[i] >= 0) then 
				        self.m_Mul_ListSize=self.m_Mul_ListSize+1; 
			       end
		    end --for
             --第一个位置 跟玩家位置相关
			local t__local_info_type = _local_info_array_[chair_id];
			local t_angle_num = math.rad(t__local_info_type.default_angle);
			local t_pos = cc.p(t__local_info_type.x, t__local_info_type.y);
			t_pos.x = t_pos.x+200 * math.sin(t_angle_num);
			t_pos.y = t_pos.y+200 * math.cos(t_angle_num);
			self.m_ChainLink_Position[0] = t_pos;
			self.m_chainLink_FinishList[0] = 1;	
			self.fis_node:removeChildByTag(1022);--更换光罩
             cclog(" ChainLinkFish:StartChainLink mul=%d,chair_id=%d  self.m_Mul_ListSize=%d",mul, chair_id,self.m_Mul_ListSize);
			self:ChainLinkFishCatch(self:fish_id(), t_pos, mul, 0);		         
       end --if (self.m_ChainLinkCatch_flag == 0)
end
function   ChainLinkFish:getChainLinkMul()                        --//获取闪电链倍数 从大到小
  if (self.m_ChainLinkCatch_flag > 0) then return self.m_Mul_Total_; end
	self.m_Mul_ListSize = 0;                                       --//捕获数量
	self.m_Mul_Total_ = 0;                                        -- //捕获总倍数
	self.m_ChainLink_KindList[0] = self:fish_kind();
	local tem_kind = self.fish_kind_ - 35 + 5;
	local t_mul =cc.exports.game_manager_:GetFish_Mul(tem_kind);
	self.m_Mul_Total_ = cc.exports.g_pFishGroup:getChainLinkMul(t_mul);
	return self.m_Mul_Total_;
end
function  ChainLinkFish:getChainLinkMulEx( mul_Num)-- //根据倍数算出列表//从大到小

	local tem_kind = self.fish_kind_ - 35 + 5;
	local mul =cc.exports.game_manager_:GetFish_Mul(tem_kind);
    self.m_ChainLink_KindList={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
	self.m_ChainLink_KindList[0] = tem_kind;
    self.m_ChainLink_Position={[0]=cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000),cc.p(10000,10000)};
	self.m_ChainLink_KindList=cc.exports.g_pFishGroup:getChainLinkMuExl(mul_Num, mul, self.m_ChainLink_KindList);
	return 1;
end
function ChainLinkFish:End()  
    cclog("ChainLinkFish:End...................");
	self.m_ChainLinkCatch_flag = 2;
	self.m_catch_timer = 0;
end
function  ChainLinkFish:LinkToNext()                                  -- //取下一个 
     --cclog("ChainLinkFish:LinkToNext.....................");
    local t_left_num = 0;
    local i=0;
	for  i = 1,9,1 do--统计
		if (self.m_ChainLink_KindList[i] >= 0 and self.m_chainLink_FinishList[i] == 0) then 	
			t_left_num=t_left_num+1;
			local t_Fish =cc.exports.g_pFishGroup:GetFishByKind(self.m_ChainLink_KindList[i]);--//找到 则返回给请求
			if (t_Fish)then 		
				self.m_ChainLink_IDList[i] = t_Fish:fish_id();
				self.m_chainLink_FinishList[i] = 1;--标记锁定
				t_Fish:ChainLinkFish_lock(); --锁定 确保不会死亡或消失 避免过程找不到
				t_Fish:ChainLinkFish_lockStop();
                 --cclog("ChainLinkFish:LinkToNext........i=%d.............",i);
				return i;--返回索引给请求
			end
		end --if m_ChainLink_KindList
	end  --for
	if (t_left_num == 0) then--结束
		self:End();
	end
	return -1;
end
function ChainLinkFish:Goto_Next( last_fishid)               -- //请求下一个
    self.m_Last_fish_ID = last_fishid;
	self.m_search_Next_flag = 1;
end
function  ChainLinkFish:GetFishId( index)                        --  //获取下一个ID
   if (index < self.m_Mul_ListSize)
	then 
		return self.m_ChainLink_IDList[index];
	end
	return -1;
end
function	  ChainLinkFish:GetNextPosition( Index, endpos,  startpos,  fishkind_e,  fish_kind_s)              --  //获取下一个节点的终点坐标
    cclog("ChainLinkFish:GetNextPosition Index=%d,endpos(%f,%f)startpos(%f,%f)",Index, endpos.x,endpos.y,  startpos.x,startpos.y)
    cclog("ChainLinkFish:GetNextPosition fishkind_e=%d,fish_kind_s=%d",fishkind_e,  fish_kind_s)
	local t_CCPoint =cc.p(endpos.x,endpos.y);
	if (fishkind_e >= 35) then fishkind_e = fishkind_e - 35 + 5; end
	if (fish_kind_s >= 35)then  fish_kind_s =fish_kind_s - 35 + 5; end
	local tem_hit_r0 = (game_fish_width[fishkind_e] )/ 2;
	local tem_hit_r1 = (game_fish_width[fish_kind_s])  / 2;
    
    if(tem_hit_r0>100) then tem_hit_r0=100; end;
    if(tem_hit_r1>100) then tem_hit_r1=100; end;
	local dir_r = tem_hit_r0 + tem_hit_r1;
	--dir_r = dir_r*dir_r + 1;
    dir_r=dir_r-30;
	if(dir_r <20) then dir_r = 20; end
    -- dir_r= math.sqrt(dir_r);
    --cclog("ChainLinkFish:GetNextPosition tem_hit_r0=%d,tem_hit_r1=%d dir_r=%d",tem_hit_r0,  tem_hit_r1,dir_r);
	t_CCPoint = cc.p(startpos.x,startpos.y);
	--local t_dis_pos = cc.p(endpos.x,endpos.y);
    local dx0=endpos.x- t_CCPoint.x;
    local dy0=endpos.y- t_CCPoint.y; 
	local t_length = math.sqrt(dx0*dx0+dy0*dy0); --t_dis_pos.getLengthSq();
    -- cclog("ChainLinkFish:GetNextPosition dx0=%d,tem_hit_r1=%d t_length=%d",dx0,  dy0,t_length);
    if(t_length==0) then t_length=1; end
    dx0=dir_r*dx0 / t_length;
    dy0=dir_r*dy0 / t_length;
    t_CCPoint.x= t_CCPoint.x+dx0;
	t_CCPoint.y= t_CCPoint.y+dy0;
     --cclog("ChainLinkFish:GetNextPosition x=%d,y=%d ",t_CCPoint.x,t_CCPoint.y);
	return t_CCPoint;
end
 return ChainLinkFish;
--endregion

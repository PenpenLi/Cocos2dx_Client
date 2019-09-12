--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/24
--此文件由[BabeLua]插件自动生成
local TurnTableFish = class("TurnTableFish",cc.exports.Fish)
function TurnTableFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
           --cclog(" TurnTableFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)");
        	self.m_catch_step = 0;
	        self.m_WinMul_num=0;
	        self.m_WinScore=0;
	        self.m_WinChair_ID=0;
	        self.m_catch_timer = 0;
	        self.m_test_timer = 0;
             self.alive_limi_time=0;
            self.m_fish_die_action_EndFlag=0;
            TurnTableFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
            if (self.fis_node) then 
                 self.baseAngle =math.rad(90);
                 local file_name ="";
			    local _sprite = NULL;
			    local readIndex = 0;
		    	local animation = cc.Animation:create();
                local i=0;
			    for  i = 0,25, 1 do
                   file_name=string.format("~TurnTableFish_000_%03d.png", i);
			   	  local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				  if (frame) then						
						local offset_name=string.format("TurnTableFish_000_%03d.png", i);
						if (cc.exports.g_offsetmap_InitFlag[22]<1) then
							local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x*0.68;--t_offset_.x * 10/ 20; 
		 	               t_offset_.y = -t_y*0.68;--t_offset_.y * 10/ 20;   
                           frame:setOffsetInPixels(t_offset_);
					  end
					  if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					  readIndex=readIndex+1;    
                      animation:addSpriteFrame(frame);
				end
               end --for
               if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[22]=1;
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  _sprite:setScale(0.65);
			end
			-- if (_sprite) then self:addChild(_sprite); end	
             self.fis_node:addChild(_sprite, 0, 10086);
         end--fishnode
 end
function  TurnTableFish:OnFrame(delta_time)
  -- cclog(" Fish:OnFrame dt=%f",delta_time);
   if(delta_time>0.04) then delta_time=0.04; end;
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
      -- self.alive_limi_time=self.alive_limi_time+delta_time;
      -- if(self.alive_limi_time>20)then return true; end
       if (self.m_fish_die_action_EndFlag>0) then return true; end
       self.m_catch_timer = self.m_catch_timer +delta_time;
       if( self.m_catch_timer>10) then return true; end
       if (self.m_catch_step == 1) then --//显示轮班
			if (self.m_catch_timer > 0.5) then 
				self.m_catch_timer = 0;
				self.m_catch_step = 2;
				self:RunTable();                    --//转动轮盘
			end
       elseif (self.m_catch_step ==2) then --//转动轮盘
			if (self.m_catch_timer > (3.5+0.2))
			then 
				self.m_catch_timer = 0;
				self.m_catch_step = 3;
				self:StopTableByMul();
			end
       elseif (self.m_catch_step == 3)then  --//停止显示倍数
                 self.m_catch_timer = 0;
                 self.m_catch_step = 4;
                 local tem_char=string.format( "%d:", self.m_WinScore);
                 local t_strlength = #tem_char;
				 t_strlength = t_strlength+2;
                 local t_start_x = 68 - (t_strlength / 2) * 34;
                 local t_winscore_ui = cc.Node:create();
				local t_get_title = cc.Sprite:create("haiwang/res/HW/turntable/table_get_ui.png");--//获得
				local t_get_bg = cc.Sprite:create("haiwang/res/HW/turntable/~TurnTableWin_001_000.png");--//背景
				local t_win_score_spr = cc.LabelAtlas:_create(tem_char, "haiwang/res/HW/turntable/table_num.png", 34, 45, 48); 
				if (t_get_title) then t_get_title:setAnchorPoint(cc.p(1, 0.5)); end
				if (t_win_score_spr) then t_win_score_spr:setAnchorPoint(cc.p(0, 0.5)); end
				if (t_get_title) then t_winscore_ui:addChild(t_get_title); end
				if (t_win_score_spr) then t_winscore_ui:addChild(t_win_score_spr); end
				self.fis_node:addChild(t_winscore_ui,111);
				t_winscore_ui:setPosition(cc.p(t_start_x, -50));
				if (t_get_bg) then 
					t_get_bg:setScaleX(t_strlength*34/90.0);
					t_get_bg:setAnchorPoint(cc.p(0.4, 0.5));
					t_winscore_ui:addChild(t_get_bg, -1);
				end
       elseif (self.m_catch_step == 4)then --//显示倍数中分
          
			if (self.m_catch_timer > 2.5) then 
				self.m_catch_step = 0.5;
				self.m_catch_step = 5;
			end
       elseif (self.m_catch_step == 5)then --//隐藏提醒玩家中分
                 local  fadeout = cc.FadeOut:create(0.5);
				self.fis_node:runAction(fadeout);
				self.m_catch_step = 6;
       elseif (self.m_catch_step ==6) then 
			if (self.m_catch_timer > 0.5)then
				return true;
			end
       end
       --]]
   end
   return false;
end
function TurnTableFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
      --cclog("TurnTableFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)------------------------------------------------------------------------");
   
    -- fish_mul=500;--g_table_mul_List[ math.floor(math.random()%11)];
--     score=fish_mul*bulet_mul;
    self.alive_limi_time=0;
    if(bomFlag==0) then
        local g_table_mul_List= {100,120,170,200,230,260,290,320,340,400,500};
        local intable_check=0;
        local i=0;
        for i=1,#g_table_mul_List,1 do 
              if(fish_mul==g_table_mul_List[i]) then  intable_check=1; end
        end
        if(intable_check==0) then bomFlag=1; end
     end
    
   
    self.fis_node:removeChildByTag(7758258);
     self.m_mov_timer = 0;
     self.m_catch_score=score;
     self.m_catch_chairID=chair_id;
     self.fish_multiple_=fish_mul;
      self.fish_status_ = 2;
     self.m_WinMul_num = fish_mul;
	 self.m_catch_step = 0;
	 self.m_WinScore = score;
	 self.m_WinChair_ID = chair_id;
	 if (bomFlag>0) then 
		 if (m_catch_score > 0) then 
             local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
		 end
		 self.m_catch_step = 6;
         self.m_fish_die_action_EndFlag=1;
		 return;
	 end
    cc.exports.g_soundManager:PlayGameEffect("HitScore");
    cc.exports.g_soundManager:PlayGameEffect("HitTurn");
	self:setLocalZOrder(300);
	self:setRotation(0);
    if (self.fis_node) then 
       --cclog("TurnTableFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)---------------------------11---------------------------------------------");
       self.fis_node:removeChildByTag(10086);	
       local file_name ="";
		local _sprite = NULL;
		local readIndex = 0;
		local animation = cc.Animation:create();
        local i=0;
	    for  i = 0,25, 1 do
             	file_name=string.format("~TurnTableFishItem_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then			  
			    	if (cc.exports.g_offsetmap_InitFlag_D[22]<1) then
                            local offset_name=string.format("TurnTableFishItem_000_%03d.png", i);
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
					end			
                    if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
                end--if frame
        end  --for
       --cclog("TurnTableFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)-------------------------readIndex=%d------------------------------------------",readIndex);
        if (readIndex > 0)	then 
               cc.exports.g_offsetmap_InitFlag_D[22]=1;
			    animation:setDelayPerUnit(1/24.0);
				local action =cc.Animate:create(animation);   
				_sprite:runAction(cc.Repeat:create(action,1));
                self.fis_node:addChild(_sprite, 0, 10086);
                _sprite:setScale(0.65);
			end			 
             local function  _call_bakc_()
                  self:FishActionEndCallBack();
             end
             
		     local t_end_pos = cc.p(_local_info_array_[chair_id].x, _local_info_array_[chair_id].y);--//测试 后期移动到玩家座位上方
			 local  t_player_chair_Angle = 0;  --//街机版需要和玩家方向一致
		     t_end_pos.y =  t_end_pos.y +250 * math.cos( math.rad(_local_info_array_[chair_id].default_angle));
			 local rotateto = cc.RotateTo:create(0.5, t_player_chair_Angle); --//旋转回正角度
			 local moveBy = cc.MoveTo:create(0.8, t_end_pos);
			 local funcall = cc.CallFunc:create(_call_bakc_);
			 local seq = cc.Sequence:create(rotateto, moveBy, funcall, nil);	 
			 self.fis_node:runAction(seq);
             
    end -- if (self.fis_node) then 
end
function TurnTableFish:RunTable()--                    //转动轮盘

     cc.exports.g_soundManager:PlayGameEffect("Turning");
	local t_table_r_Node = self.fis_node:getChildByTag(10088);
    if (t_table_r_Node) then 
        local t_angle_res= { [0]=0,[1]=0,[2]=0 };
		self.fis_node:setRotation(0);
		t_table_r_Node:setRotation(0);
        if (self.m_WinMul_num < 230)then --//1环
			if (self.m_WinMul_num == 100) then t_angle_res[0] = 0; 
			elseif (self.m_WinMul_num == 200) then t_angle_res[0] = 270; 
			elseif (self.m_WinMul_num == 120) then t_angle_res[0] = 180; 
			elseif (self.m_WinMul_num == 170) then t_angle_res[0] = 90;  end
			local t_tableangle1 = { [0]=0, -60, -120, -180, -240, -300 };
			local  t_tableangle2 = { [0]=0, 120, 240 };
			t_angle_res[1] = t_tableangle1[ math.random(6) % 6];
			t_angle_res[2] = t_tableangle2[ math.random(6) % 3];
		elseif (self.m_WinMul_num < 340) then --//2环 
            local t_tableangle0 = {  [0]=45, 135, 225, 315 };
			local  t_tableangle2 = {  [0]=0, 120, 240 };
			if (self.m_WinMul_num == 230) then t_angle_res[1] = 300;
			elseif (self.m_WinMul_num == 290)then t_angle_res[1] = 240;
			elseif (self.m_WinMul_num == 260)then t_angle_res[1] = 120;
			elseif (self.m_WinMul_num == 320)then t_angle_res[1] = 60; end
			t_angle_res[0] = t_tableangle0[ math.random(4) % 4];
			t_angle_res[2] = t_tableangle2[ math.random(3) % 3];
        elseif (self.m_WinMul_num < 500) then --//3环
            local  t_tableangle0 = { [0]=45, 135, 225, 315 };
			local  t_tableangle1= {[0]=0, 180 };
			if (self.m_WinMul_num == 340) then  t_angle_res[2] = 240;
			elseif (self.m_WinMul_num == 400) then t_angle_res[2] = 120; end
			t_angle_res[0] = t_tableangle0[ math.random(4) % 4];
			t_angle_res[1] = t_tableangle1[math.random(2) % 2];
        else --//内环 500倍
        	local t_tableangle0= { [0]=45, 135, 225, 315 };
			local t_tableangle1 = { [0]=0, 180 };
			t_angle_res[0] = t_tableangle0[  math.random(4) % 4];
			t_angle_res[1] = t_tableangle1[ math.random(2) % 2];
			t_angle_res[2] = 0;
        end
        --轮盘1
        local rotateto1 = cc.RotateTo:create(3.5, t_angle_res[0] + 4 * 360);
		local easeSineInOut1 =cc.EaseSineInOut:create(rotateto1);
		local t_front_bg1 =t_table_r_Node:getChildByTag(1);
		t_front_bg1:runAction(easeSineInOut1);
        --轮盘2
        local rotateto2 =  cc.RotateTo:create(3.5, t_angle_res[1] - 4 * 360);
		local easeSineInOut2=cc.EaseSineInOut:create(rotateto2);
		local t_front_bg2 =t_table_r_Node:getChildByTag(2);
		t_front_bg2:setRotation(0);
		t_front_bg2:runAction(easeSineInOut2);
        --轮盘3
        local rotateto3 =  cc.RotateTo:create(3.5, t_angle_res[2] + 4 * 360);
		local easeSineInOut3 = cc.EaseSineInOut:create(rotateto3);
		local t_front_bg3 =t_table_r_Node:getChildByTag(3);
		t_front_bg3:setRotation(0);
		t_front_bg3:runAction(easeSineInOut3);
  
    end --if (t_table_r_Node) then 
end
function TurnTableFish:StopTableByMul()--//根据倍数停止轮盘
    --显示倍数
	if (self.m_WinMul_num == 500)then 
		local t_max_Mul_bg = cc.Sprite:create("haiwang/res/HW/turntable/TurnTableMaxScore.png");
		if (t_max_Mul_bg) then 
			self.fis_node:addChild(t_max_Mul_bg, 11111);
		end
	end
    local x,y=self.fis_node:getPosition();
	cc.exports.g_CoinManager:BuildCoin(cc.p(x,y), self.m_WinChair_ID, self.m_WinScore, self.m_WinMul_num);
end
function  TurnTableFish:FishActionEndCallBack()--          //死亡动作结束回调
   local g_table_mul_List= {[0]=100,120,170,200,230,260,290,320,340,400,500};
    self.m_catch_step = 1;
	self.m_catch_timer = 0;
    local t_spr = self.fis_node:getChildByTag(10086);
	if (t_spr) then 
			local fadeout = cc.FadeOut:create(0.5);
			t_spr:runAction(fadeout);
	end
    --检测倍数 如果符合轮盘分数显示轮盘 否则直接退出
	local t_check_flag = 0;
    local i=0;
    for i = 0,11,1 do
			if (self.m_WinMul_num == g_table_mul_List[i]) then t_check_flag = 1; end
  end
  if (self.m_WinMul_num <100) then t_check_flag = 0; end
  if (t_check_flag) then 
        --//显示轮盘
		local t_table_Node = cc.Node:create();
		if (t_table_Node) then 
             self.fis_node:addChild(t_table_Node, -1, 10088);
              --//前景
              local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame("~TurnTableOutCircle_000_000.png");
			  local t_front_bg = cc.Sprite:createWithSpriteFrame(frame);
              if(t_front_bg) then
                   local t_offset_ = cc.p(0, 0);
                   local t_offect_str=cc.exports.OffsetPointMap["TurnTableOutCircle_000_000.png"].Offset;
                   local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                   local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                   local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                   local t_offeset_pos=cc.p(0,0);
                   local t_offset_0 = frame:getOffsetInPixels();
                   t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		           t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                   frame:setOffsetInPixels(t_offset_);
                end
				t_front_bg:setPosition(cc.p(2, -2));
				t_table_Node:addChild(t_front_bg, 111);
               -- //转盘1
               local  frame1 = cc.SpriteFrameCache:getInstance():getSpriteFrame("~TurnTable_000_000.png");
			   local t_front_1 = cc.Sprite:createWithSpriteFrame(frame1);
               if(frame1) then
                   local t_offset_ = cc.p(0, 0);
                   local t_offect_str=cc.exports.OffsetPointMap["TurnTable_000_000.png"].Offset;
                   local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                   local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                   local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                   local t_offeset_pos=cc.p(0,0);
                   local t_offset_0 = frame:getOffsetInPixels();
                   t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		           t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                   frame1:setOffsetInPixels(t_offset_);
                end
				t_table_Node:addChild(t_front_1,  -1, 1);
                -- //转盘2
               local frame2 = cc.SpriteFrameCache:getInstance():getSpriteFrame("~TurnTable2_000_000.png");
			   local t_front_2 =cc.Sprite:createWithSpriteFrame(frame2);
                if(frame2) then
                   local t_offset_ = cc.p(0, 0);
                   local t_offect_str=cc.exports.OffsetPointMap["TurnTable2_000_000.png"].Offset;
                   local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                   local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                   local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                   local t_offeset_pos=cc.p(0,0);
                   local t_offset_0 = frame:getOffsetInPixels();
                   t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		           t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                   frame2:setOffsetInPixels(t_offset_);
                end
                t_table_Node:addChild(t_front_2, 2, 2);
                --//转盘3
                local frame3 = cc.SpriteFrameCache:getInstance():getSpriteFrame("~TurnTable3_000_000.png");
			   local t_front_3 =cc.Sprite:createWithSpriteFrame(frame3);
                if(frame3) then
                   local t_offset_ = cc.p(0, 0);
                   local t_offect_str=cc.exports.OffsetPointMap["TurnTable3_000_000.png"].Offset;
                   local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                   local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                   local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                   local t_offeset_pos=cc.p(0,0);
                   local t_offset_0 = frame:getOffsetInPixels();
                   t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		           t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                   frame3:setOffsetInPixels(t_offset_);
                end
                t_table_Node:addChild(t_front_3,5, 3);
                --//转盘4
                local frame4 = cc.SpriteFrameCache:getInstance():getSpriteFrame("~TurnTable4_000_000.png");
			   local t_front_4 =cc.Sprite:createWithSpriteFrame(frame4);
                if(frame4) then
                   local t_offset_ = cc.p(0, 0);
                   local t_offect_str=cc.exports.OffsetPointMap["TurnTable4_000_000.png"].Offset;
                   local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
                   local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                   local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                   local t_offeset_pos=cc.p(0,0);
                   local t_offset_0 = frame:getOffsetInPixels();
                   t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		           t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;   
                   frame4:setOffsetInPixels(t_offset_);
                end
                t_table_Node:addChild(t_front_4, 14, 4);
               local t_front_5 = cc.Sprite:createWithSpriteFrameName("~TurnTableNextTableArrow_000_000.png");
			   t_table_Node:addChild(t_front_5, 5, 5);
			    t_front_5:setPosition(cc.p(0, 100));
        end
  end
end
 return TurnTableFish;

--endregion

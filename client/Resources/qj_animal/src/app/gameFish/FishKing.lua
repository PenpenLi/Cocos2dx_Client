--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/7
--此文件由[BabeLua]插件自动生成
  local FishKing = class("FishKing",cc.exports.Fish
--  function(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay)
--	return cc.exports.Fish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay)
--    end
)
 function FishKing:ctor(fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay)
     FishKing.super.ctor(self,fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay);
     self.m_catch_mul_num=0; 
	 self.m_catch_chair_id=0;
	 self.m_catch_bullet_mul=0;
	 self.m_catch_kind=0;
	 self.m_catch_score=0;
	 self.m_catch_get_mul=0;
	 self.m_catch_timer=0;
	 self.m_catch_delay=0;
	 self.m_search_timer=0;
	 self.m_get_catch_pos=cc.p(0,0);
	 self.m_get_catch_Endpos=cc.p(0,0);
	 self.m_catch_fish_list={[0]=0,0,0,0,0,0,0,0,0,0,0};
     self.m_catch_index=0;
  end
function FishKing:OnFrame( delta_time,  lock)
	if (self.fish_status_ == 0) then 
		self.m_nFishDieCount = 0;
		self.fish_status_ = 1;
		self.fis_node:setPosition(cc.p(self.m_mov_list[0].x, self.m_mov_list[0].y));
		if (self.fis_node:isVisible()==false) then self.fis_node:setVisible(true) end;
		self:CheckValid();
		return false;
	end
	if (self.fish_status_ == 1) then 
		local t_winSize = cc.Director:getInstance():getWinSize();

        local x,y=self.fis_node:getPosition();
		local  t_pos =cc.p(x,y);
		self:CheckValid();--//和屏幕碰撞半段	
		if (self.m_Alive_Step == 0)then  --//只能一次进入屏幕	
			if (self.valid_==true) then m_Alive_Step = 1; end
            if (t_pos.x>-300 and t_pos.x>(t_winSize.width + 300) and t_pos.y<-300 and t_pos.y>(t_winSize.height + 300))
               then m_Alive_Step = 1; 
             end
			if (t_pos.x<-1000 or t_pos.x>(t_winSize.width + 1000) or t_pos.y<-1000 or t_pos.y>(t_winSize.height + 1000)) then
             self:exit_self();
             return true;	 end
		else	
			if (t_pos.x<-300 or t_pos.x>(t_winSize.width + 300) or t_pos.y<-300 or t_pos.y>(t_winSize.height + 300)) then 	
             self:exit_self();
             return true; end
		end
		if (self.m_miss_state>0) then 
			self.m_miss_timer = self.m_miss_timer+delta_time;
			if (self.m_miss_timer>self.m_miss_Data) then 		
				if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
				self.m_miss_state = 0;	
			else		
				if (self.m_miss_timer < self.m_miss_timeLength) then 			
					if (self.m_miss_kind == 0) then --//晕眩				
						delta_time = 0;
						self.m_mov_timer = 0;				
					else--//逃脱					
						delta_time = delta_time*5;
					end
				
				elseif (m_miss_state < 99) then --//恢复走路状态										
						m_miss_state = 99;
                end				
			 end
		end
		if (self.m_mov_delay > 0.0001) then 	
			self.m_mov_delay = self.m_mov_delay-delta_time;	
		else --//移动	
			local t_mov_dis = self.m_mov_Speed * 30 * delta_time;
			self.m_mov_dis = self.m_mov_dis+t_mov_dis;
			if (self.m_mov_dis>self.m_mov_dis_max) then 		
				if (self:MovTo_Next() < 0) then 			
					 self:exit_self();
                     return true;
				end	
			else		
				self.m_mov_pos_.x = self.m_mov_pos_.x+t_mov_dis*self.m_mov_sin_f;
				self.m_mov_pos_.y = self.m_mov_pos_.y+t_mov_dis*self.m_mov_cos_f;
				if (self.fis_node) then 		
					self.fis_node:setPosition(self.m_mov_pos_);
                     local x,y=self.fis_node:getPosition();
					 local t_last_ZNum =144 - y / 5;
					 if (t_last_ZNum ~= m_last_ZNum) then 				
						self.fis_node:setLocalZOrder(t_last_ZNum);
						self.m_last_ZNum = t_last_ZNum;
					end
				end
			end
		end
	else --//死亡	
		self.m_catch_timer = self.m_catch_timer+delta_time;
		self.m_search_timer = self.m_search_timer+delta_time;--//搜索延迟
		if (self.m_catch_timer > 10 or self.m_search_timer>3) then 		
			--//通知锁定对象全部死亡
			if ( self.m_catch_index> 0) then 
			    local i=0;
				for i =0, self.m_catch_index,1 do	
                    local t_id_num=self.m_catch_fish_list[i];
                    if(t_id_num>0) then 
				   	   local t_Fish = cc.exports.g_pFishGroup:GetFish(t_id_num);
					   if (t_Fish) then t_Fish:KingCatchFish();	end
                    end
				end			
			end
			local t_fish_mul = cc.exports.game_manager_:GetFish_Mul(self.m_catch_kind);
		    local cannon_pos = cc.exports.g_cannon_manager:GetCannonPos(self.m_catch_chair_id,0);
			self:AddWin_Effect(self.m_catch_chair_id, self.m_catch_bullet_mul*t_fish_mul,cannon_pos);	
			self:exit_self();
            return true;
		end
		if (self.m_catch_delay< 0 )	then 	
			if (self.m_catch_get_mul < self.m_catch_mul_num) then 		
				if (cc.exports.g_pFishGroup) then 	
					local t_Fish = cc.exports.g_pFishGroup:GetFishByKind(self.m_catch_kind,1);
					if (t_Fish) then 			
                         local t_fish_mul = cc.exports.game_manager_:GetFish_Mul(self.m_catch_kind);
						self.m_search_timer = 0;				
						self.m_catch_get_mul = self.m_catch_get_mul+t_fish_mul;
						self.m_get_catch_Endpos = t_Fish:King_catch(self.m_catch_chair_id, self.m_catch_bullet_mul*t_fish_mul);
						--self.m_get_catch_Endpos = self.m_get_catch_Endpos + kind_effect_pos[self.m_catch_kind];
                        local t_add_pos=cc.exports.kind_effect_pos[self.m_catch_kind];
                        self.m_get_catch_Endpos.x=self.m_get_catch_Endpos.x+ t_add_pos.x;
                        self.m_get_catch_Endpos.y=self.m_get_catch_Endpos.y+ t_add_pos.y;
						--self.m_catch_fish_list.push_back(t_Fish:fish_id());
                        self.m_catch_fish_list[self.m_catch_index]=t_Fish:fish_id();
                        self.m_catch_index=self.m_catch_index+1;
						local t_dis_length =cc.pGetDistance(self.m_get_catch_Endpos,self.m_get_catch_pos);-- self.m_get_catch_Endpos.getDistance(m_get_catch_pos);
						local t_angle = self:mm_getAngle(self.m_get_catch_pos, self.m_get_catch_Endpos) + 90;
						local t_catch_line =cc.Sprite:create("qj_animal/res/game_res/Animal/BroachTail_000_000Ex.png");              
						if (t_catch_line~=nil)  then 						
							t_catch_line:setPosition(self.m_get_catch_pos);
							t_catch_line:setRotation(t_angle);
							t_catch_line:setAnchorPoint(cc.p(1, 0.5));
							t_catch_line:setTextureRect(cc.rect(0, 0, t_dis_length, 105));
							t_catch_line:setOpacity(0);
							local t_fadeIn = cc.FadeIn:create(0.2);
							t_catch_line:runAction(t_fadeIn);
							self:addChild(t_catch_line, -2);
							self.m_catch_delay = 0.5;
							self.m_get_catch_pos = self.m_get_catch_Endpos;
						end
					end
				end
			end	
		else 		
			self.m_catch_delay = self.m_catch_delay-delta_time;
		end
	end
	return false;
end

function   FishKing:GetFish_Catch_Mul()--//获取游戏中鱼的倍数

	local t_catch_kind = self.fish_kind_ - 30;
	local t_fish_mul = 0;
	if (t_catch_kind >= 0) then 	
		t_fish_mul = cc.exports.game_manager_:GetFish_Mul(t_catch_kind);
		if ( cc.exports.g_pFishGroup) then 		
			t_fish_mul =t_fish_mul+ (t_fish_mul*cc.exports.g_pFishGroup:GetFishKindCount(t_catch_kind,1));
         end		
	end
	return t_fish_mul;
end

function FishKing:CatchFish( chair_id, score,bulet_mul,fish_mul,bomFlag)
    cclog("FishKing:CatchFish( chair_id, score,bulet_mul,fish_mul,bomFlag)");
     self.catch_mul=fish_mul;
	 self.fis_node:removeChildByTag(7758258);
	 self.fis_node:removeChildByTag(8888);
	 self.fis_node:removeChildByTag(775825);
	 self.fish_status_ = 2;
	 self.m_catch_kind = self.fish_kind_ - 30;
	 local t_fish_mul = cc.exports.game_manager_:GetFish_Mul(self.m_catch_kind);
	 self.m_catch_mul_num = fish_mul - t_fish_mul; 
	 self.m_catch_get_mul = 0;
	 self.m_catch_chair_id = chair_id;
	 self.m_catch_kind =self.fish_kind_ - 30;
	 self.m_catch_score = score;
	 self.m_catch_bullet_mul = bulet_mul;
	 self.m_catch_timer=0;
	 self.m_catch_delay=0;
    -- cclog("FishKing:CatchFish( chair_id, score,bulet_mul,fish_mul,bomFlag)11 self.m_catch_kind=%d",self.m_catch_kind);
     local x,y=self.fis_node:getPosition();
     cc.exports.Action:crFishBoom(cc.p(x,y));
	 self.m_get_catch_pos = cc.p(x,y);
     local t_add_pos=cc.exports.kind_effect_pos[self.m_catch_kind];
     self.m_get_catch_pos.x=self.m_get_catch_pos.x+ t_add_pos.x;
     self.m_get_catch_pos.y=self.m_get_catch_pos.y+ t_add_pos.y;
     --cclog("FishKing:CatchFish( chair_id, score,bulet_mul,fish_mul,bomFlag)12");
	 self.m_get_catch_Endpos = self.m_get_catch_pos;
     --cclog("FishKing:CatchFish( chair_id, score,bulet_mul,fish_mul,bomFlag)13");
     -------播放BO
     --self:AddKind_Effect(1);
     --+闪电
     local k=0;
     for k=0,3,1 do
          -------使用闪电特效
         local file_name ="";
		 local readIndex = 0;
		 local animFrames = cc.Animation:create();
         local i=0;
	     for  i = 0,16, 1 do
             file_name=string.format("newlink_effect_%02d.png", i);
             local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			 if(frame) then
                if(readIndex == 0)then 	t_catch_line=cc.Sprite:createWithSpriteFrame(frame) ;end
				readIndex=readIndex+1; 
               animFrames:addSpriteFrame(frame);
             end		
        end
        if(readIndex > 0) then 		
            animFrames:setDelayPerUnit(1/24);
		    local animation = cc.Animate:create(animFrames);
		    local t_CCRepeat =cc.RepeatForever:create(animation);
            t_catch_line:runAction(t_CCRepeat);	
            t_catch_line:setAnchorPoint(cc.p(-0.018,0.5));
            t_catch_line:setRotation(90*k);	
            local t_effect_pos=cc.p(x,y);
            t_effect_pos.x=t_effect_pos.x+kind_effect_pos_catch[self.m_catch_kind].x;
            t_effect_pos.y=t_effect_pos.y+kind_effect_pos_catch[self.m_catch_kind].y;
            t_catch_line:setPosition(t_effect_pos);     
            self:addChild(t_catch_line,-1);          
         end	--	if (readIndex > 0) then	                   	
     end
end


return FishKing;
--endregion

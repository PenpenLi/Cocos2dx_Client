--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/27
--此文件由[BabeLua]插件自动生成 宝箱
local BaoxiangFish = class("BaoxiangFish",cc.exports.Fish)
function BaoxiangFish:ctor( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay)
            BaoxiangFish.super.ctor(self,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startPos,  delay);
            self.alive_limi_time=0;
            if (self.fis_node) then 
                local file_name ="";
			    local _sprite = nil;
			    local readIndex = 0;
			    local animation = cc.Animation:create();
                local i=0;
			    for  i = 0,51, 1 do
                file_name=string.format("~ActiveIcon_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then									
						if (cc.exports.g_offsetmap_InitFlag[34]<1) then
                        	local offset_name=string.format("ActiveIcon_000_%03d.png", i);
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
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
             end --for
             if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag[34]=1;
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  _sprite:setScale(0.8);
                  self.fis_node:addChild(_sprite, 0, 10086);
		 	end
		end --  if (self.fis_node) then 
end
function BaoxiangFish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
	  self.m_mov_timer = 0;
     self.alive_limi_time=0;
	 self.m_catch_chairID = chair_id;
	 self.m_catch_score = score;
	 self.fish_multiple_ = fish_mul;
	 self.fish_status_ = 2;
	 self.m_mov_timer = 0;
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
    cc.exports.g_soundManager:PlayGameEffect("TaskUI");
     --//播放特效
	--	 My_Particle_manager::GetInstance()->PlayParticle(0, fis_node->getPosition());
    cc.exports.g_My_Particle_manager:PlayParticle(0, self:GetFishccpPos());
	 cc.exports.game_manager_:ShakeScreen();
    --cc.exports.g_CoinManager:BuildCoin(self.fis_node:getPosition(), chair_id, score, fish_mul);
	self:setLocalZOrder(15);
    if (self.fis_node) then 
                local file_name ="";
			    local _sprite = nil;
			    local readIndex = 0;
			    local animation = cc.Animation:create();
                local i=0;
			    for  i = 0,71, 1 do
                file_name=string.format("~ActiveIcon_001_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then									
						if (cc.exports.g_offsetmap_InitFlag_D[34]<1) then
                        	local offset_name=string.format("ActiveIcon_001_%03d.png", i);
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
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
             end --for
             if (readIndex > 0)	then 
                  cc.exports.g_offsetmap_InitFlag_D[34]=1;
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);   
                  local t_CCRepeat=cc.Repeat:create(action,1);
                  local t_CCFadeOut=cc.FadeOut:create(0.1);
                     local function call_back__()
                    self:Fish_Die_ActionCallback();
                  end
                       local function call_back__1()
                    self:CatchScore_callback();
                  end
                   local t_callfunc = cc.CallFunc:create(call_back__);
                  local t_callfunc1 = cc.CallFunc:create(call_back__1);
                   local t_CCSequence = cc.Sequence:create(t_CCRepeat, t_callfunc1,t_CCFadeOut, t_callfunc, nil);
				 _sprite:runAction(t_CCSequence);
                 _sprite:setScale(0.8);
				 -- _sprite:runAction(cc.RepeatForever:create(action));
                  self.fis_node:removeChildByTag(10086);
                  self.fis_node:addChild(_sprite, 0, 10086);
		 	end
		end --  if (self.fis_node) then 
end
return BaoxiangFish;
--endregion

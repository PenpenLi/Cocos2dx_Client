--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/21
--此文件由[BabeLua]插件自动生成


local Coin = class("Coin",
 function()
	return cc.Node:create()
end
)
function Coin:ctor( fish_pos,chair_id,score,delay)
          -- cclog("Coin:ctor( fish_pos(%f,%f),chair_id=%d,score=%d,delay=%f)",fish_pos.x,fish_pos.y,chair_id,score,delay);
           self.alive_timer=0;
           self.m_chair_id = chair_id;
		   self.m_score = score;
           self:setPosition(cc.p(fish_pos.x,fish_pos.y));
			local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,16, 1 do
				file_name=string.format("~CoinEff_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
						local offset_name=string.format("CoinEff_000_%03d.png", i);
						if (cc.exports.g_offsetCoin_InitFlag[i]<1) then
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
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end --for
		   if (readIndex > 0)	then 
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  self:addChild(_sprite, 0, 10086);
		   end
       
           local  t__local_info_type = _local_info_array_[chair_id];
		   local cannon_pos=cc.p(t__local_info_type.x,t__local_info_type.y)
			local t_playerAngle = math.rad(t__local_info_type.default_angle);
            local dis_x=fish_pos.x-cannon_pos.x;
            local dis_y=fish_pos.y-cannon_pos.y;
			local t_mov_timer =(dis_x*dis_x)+(dis_y*dis_y);
			t_mov_timer = t_mov_timer / 250000.0;
			if (t_mov_timer < 0.2) then t_mov_timer = 0.2; end
			if (t_mov_timer > 1) then t_mov_timer = 1;  end
			local  t_rand_e_pos=cc.p(math.random(0,100) % 30,math.random(0,100) % 30)
            local function callback__()
               self:FinishActionCallback();
           end
			local t_delayAppa=cc.DelayTime:create(delay+0.1);
			local jumpby = cc.JumpBy:create(0.5, t_rand_e_pos, 50 * math.cos(t_playerAngle), 1);
			local t_delay=cc.DelayTime:create(0.3);
			local t_movto=cc.MoveTo:create(t_mov_timer, cannon_pos);
			local t_callfunc = cc.CallFunc:create(callback__);
			local t_seq = cc.Sequence:create(t_delayAppa,jumpby, t_delay, t_movto, t_callfunc, nil);
			self:runAction(t_seq);
            --
            local function handler(interval)
               self:update(interval);
             end
            self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
            self.alive_timer=0;
end
 function  Coin:update(dt)
     self.alive_timer=self.alive_timer+dt;
     if(self.alive_timer>10) then  self:removeFromParent(); end ;
 end
function Coin:FinishActionCallback()--动作完成回调  给玩家上分 看需求
	 self:removeAllChildren();
	 self:removeFromParent();
end
return Coin;
--endregion

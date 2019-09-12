--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/21
--此文件由[BabeLua]插件自动生成

local Bingo = class("Bingo",
 function()
	return cc.Node:create()
end
)

function Bingo:ctor(chair_id, fish_score,style)
    
       local t__local_info_type = _local_info_array_[chair_id];
		local t_pos = cc.p(t__local_info_type.x, t__local_info_type.y);
		t_pos.x = t_pos.x+150 * math.sin(t__local_info_type.default_angle);
		t_pos.y = t_pos.y+150 * math.cos(t__local_info_type.default_angle);
        --cclog(" Bingo:ctor t_pos.x=%d,t_pos.y=%d,t__local_info_type.default_angle=%f",t_pos.x,t_pos.y,t__local_info_type.default_angle);
        self:setPosition(t_pos);
        local file_name ="";
		local _sprite = nil;
		local readIndex = 0;
		local animation = cc.Animation:create();
        local i=0;
	    for  i = 0,25, 1 do
				file_name=string.format("~JumpScoreBG_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then				
                     if (cc.exports.JumpScoreBG_<1) then	
						   local offset_name=string.format("JumpScoreBG_000_%03d.png", i);
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
					end
					 if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end
		 	if (readIndex > 0)	then 
                cc.exports.JumpScoreBG_=1;
			    animation:setDelayPerUnit(1/24.0);
				--_sprite:setOpacity(0);
				local action =cc.Animate:create(animation);   		 
				_sprite:runAction(cc.RepeatForever:create(action));
			end
			if (_sprite) then self:addChild(_sprite); end	
           if (_sprite) then
			local t_Win_score_spr = cc.LabelAtlas:_create(fish_score, "haiwang/res/HW/fishnum.png", 28, 38, 48);
			if (t_Win_score_spr) then 
				t_Win_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
				self:addChild(t_Win_score_spr);
			 end
		  end
          --自消失
		if (_sprite)then
            local function call_back_()
                self:removeFromParent();           
            end
			local t_delay = cc.DelayTime:create(3);
			local t_fadeout =cc.FadeOut:create(0.5);
			local t_callfunc = cc.CallFunc:create(call_back_);
			local t_seq = cc.Sequence:create(t_delay, t_fadeout, t_callfunc,nil);
			_sprite:runAction(t_seq);
		end
        --
        local function handler(interval)
               self:update(interval);
       end
       self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
       self.alive_timer=0;
end
 function  Bingo:update(dt)
     self.alive_timer=self.alive_timer+dt;
     if(self.alive_timer>5) then self:removeFromParent();  end
 end
return Bingo;

--endregion

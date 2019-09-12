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
			for  i = 0,20, 1 do
				file_name=string.format("juzi 1_%05d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end --for
		   if (readIndex > 0)	then 
			      animation:setDelayPerUnit(1/40.0);
				  local action =cc.Animate:create(animation);   
				  _sprite:runAction(cc.RepeatForever:create(action));
                  _sprite:setScale(0.5);
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
            local  t_dis_dis=math.random(10,200);
            local  t_dis_dis2=math.random(10,100);
            local  t_dis_dis3=math.random(10,40);
            local  t_dir__1=math.random(0,1);
            local  t_dir__2=math.random(0,1);
            if(t_dir__1==1) then t_dis_dis=-t_dis_dis;  end;
            if(t_dir__2==1) then
                t_dis_dis2=-t_dis_dis2; 
                t_dis_dis3=t_dis_dis3-t_dis_dis2;
            else 
                t_dis_dis3=t_dis_dis2+t_dis_dis3;
             end;
			local  t_rand_e_pos=cc.p(t_dis_dis,t_dis_dis2)
            local function callback__()
               self:FinishActionCallback();
           end
			local t_delayAppa=cc.DelayTime:create(delay+0.1);
			local jumpby = cc.JumpBy:create(0.5, t_rand_e_pos, t_dis_dis3, 1);

			local t_delay=cc.DelayTime:create(0.3);
			local t_movto=cc.MoveTo:create(t_mov_timer, cannon_pos);
			local t_callfunc = cc.CallFunc:create(callback__);
			local t_seq = cc.Sequence:create(t_delayAppa,jumpby, t_delay, t_movto, t_callfunc, nil);
			self:runAction(t_seq);
             _sprite:setScale(0.5);
            local t_scale_to=cc.ScaleTo:create(0.4,0.5);
            _sprite:runAction(t_scale_to);
            local function handler()
                self:update(1);
            end
            self.alive_timer=0;

            local t_delay11=cc.DelayTime:create(1);
            local t_call_f=cc.CallFunc:create(handler);
            local t_seq111=cc.Sequence:create(t_delay11,t_call_f,nil);
            local t_rep=cc.RepeatForever:create(t_seq111);
            self:runAction(t_rep);


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

--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/6/7
--此文件由[BabeLua]插件自动生成

local red_coin = class("red_coin",
 function()
	return cc.Node:create()
end
)
function red_coin:ctor(start, g_num_c, delay)
--           cclog("red_coin:ctor(  start, g_num_c, delay)");
--           cclog("red_coin:ctor(  start,  delay=%f)",delay);
--           cclog("red_coin:ctor(  start,  g_num_c=%f)",g_num_c);  
            self:setPosition(start);
            self.rx = 25 - math.random(0,50);
		    self.ry = 0;
            self.change_z_flag=0;
		    self.m_delay = delay;
	    	self.g_num = g_num_c;
            self.speedx = 10+ math.random(0,50);
            local t_rand_num= math.random(0,30000)%2;
	    	if (t_rand_num> 0)  then self.speedx = - self.speedx; end
		    self.speedy = 120 +  math.random(0,120);
            local file_name ="";
			self._sprite = nil;
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
					if (readIndex == 0)then 	self._sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;    
                   animation:addSpriteFrame(frame);
				end
			end --for
		   if (readIndex > 0)	then 
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);   
				  self._sprite:runAction(cc.RepeatForever:create(action));
                  self:addChild(self._sprite, 0, 10086);
		   end         
         local function handler(interval)
         self:update(interval);
       end
       self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
end
 function  red_coin:update(delta_time)
  --cclog("red_coin:update(delta_time=%f)rx=%f, ry=%f ,speedy=%f, m_delay=%f,",delta_time,self.rx, self.ry,self.speedy,self.m_delay);
 if(self._sprite) then 
             --  cclog("red_coin:update(delta_time=%f)self.rx=%f, self.ry=%f self.speedy=%f  aasda",delta_time,self.rx, self.ry,self.speedy);
               if (self.m_delay > 0) then self.m_delay =self.m_delay- delta_time; 
               else
                       self.rx = self.rx+self.speedx*delta_time;
                       self.ry = self.ry+self.speedy*delta_time;
                      
                       self.speedy =self.speedy- self.g_num*delta_time;
                       if (self.speedy < 0) then  
                          if(self.change_z_flag==0) then
                             self.change_z_flag=1;
                           self:setLocalZOrder(200); 
                        end 
                       end
                       self._sprite:setPosition(cc.p( self.rx, self.ry));
                       if ( self.ry < -300) then 
                             local function remov_self()
                                 self:removeFromParent();
                            end
				            local t_fade_out = cc.FadeOut:create(0.3);
				            local  t_remov = cc.CallFunc:create(remov_self);
				            local t_seq = cc.Sequence:create(t_fade_out, t_remov);
			            	self._sprite:runAction(t_seq);
			            end
             end
    else   self:removeFromParent();
    end
 end
return red_coin;

--endregion

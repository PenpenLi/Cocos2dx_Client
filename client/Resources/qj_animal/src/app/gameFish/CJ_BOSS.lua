--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/14
--此文件由[BabeLua]插件自动生成
  CJ_BOSS = class("CJ_BOSS",cc.exports.Fish)
  function CJ_BOSS:ctor(fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay)
     self.m_last_action_kind=0;
	 self.m_FrameSpeed1=0.04;
	 self.m_FrameSpeed2=0.04;
	 self.m_FrameSpeed3=0.04;
     CJ_BOSS.super.ctor(self,fish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay);
  end
  function CJ_BOSS:ActionChange( tag )
   
     if (self.m_last_action_kind == 1 and self.m_mov_pos_.x < 980 and self.m_mov_pos_.x>300) then --//喷火
         if (self.fis_node) then 
              self.fis_node:removeChildByTag(10086);	
              local t_reppeate_time = 1 + math.random(0,2);	 
              local  dis_x = 0;
			  if (self.m_mov_index >= 1) then 		
			       dis_x = self.m_mov_list[self.m_mov_index].x - self.m_mov_list[self.m_mov_index - 1].x;			
			   else 
                   dis_x = self.m_mov_list[self.m_mov_index + 1].x - self.m_mov_list[self.m_mov_index].x;
               end
               local readIndex=0;
               local i=0;
               local animFrames = cc.Animation:create();
	           for i = 0, 40, 1 do		
		          local file_name=string.format("BOSS_02_%03d.png", i);
		          local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
	     	      if (frame) then 	
			        if (readIndex == 0) then 			
				         aliveSpr = cc.Sprite:createWithSpriteFrame(frame);
			        end
			        readIndex=readIndex+1;    
                    animFrames:addSpriteFrame(frame);
		          end
	          end --for
	          if(readIndex > 0 and aliveSpr) then 
                  local function ActionChange_callback()
                        self:ActionChange();           
                   end
		           self.baseAngle = 0;
                   local dis_x =0;
		           --local t_frame_sapeed = game_fish_frame_Speed[t_fish_kind];
                    animFrames:setDelayPerUnit(self.m_FrameSpeed2);
		            local animation = cc.Animate:create(animFrames);               
		            local t_repeat =cc.Repeat:create(animation,t_reppeate_time);--   cc.RepeatForever:create(animation);
                    local t_call_=cc.CallFunc:create(ActionChange_callback);
                    local t_seq=cc.Sequence:create(t_repeat,t_call_,nil);

		            aliveSpr:runAction(t_seq);
                    self.m_last_action_kind = 0;
		            self.fis_node:addChild(aliveSpr, 0, 10086);
		            self.m_flip_l = 0;
		            self.baseAngle = 0; 
                      
	                if(self.m_mov_index <self.m_mov_point_num)	then 
                       local x,y=self.fis_node:getPosition();
		                dis_x=self.m_mov_list[self.m_mov_index].x -x;		
	      	            if(dis_x>0) then               
                           aliveSpr:setFlippedX(true);
                         end	      
                    end	
                    --//添加喷火
                    
                    local readIndexph = 0;
                    local animFramesph = cc.Animation:create();
                    local aliveSprph = nil;
                    for i = 0, 40, 1 do	
					     local file_name=string.format("BOSS_03_%03d.png", i);
		                 local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
	     	             if(frame) then 	
			                 if(readIndexph == 0) then 			
				                aliveSprph = cc.Sprite:createWithSpriteFrame(frame);
			                  end
			                 readIndexph=readIndexph+1;    
                             animFramesph:addSpriteFrame(frame);
		                end
                    end --for
                   -- cclog("CJ_BOSS:ActionChange( tag ) readIndexph=%d",readIndexph);
					if (readIndexph > 0 and aliveSprph) then 	
                           --  cclog("CJ_BOSS:ActionChange( tag ) readIndexph=%d aaa",readIndexph);
                            local function remove__()
                                aliveSprph:removeFromParent();
                            end				
                            animFramesph:setDelayPerUnit(self.m_FrameSpeed3);
						    local animation1 = cc.Animate:create(animFramesph);
						    local t_CCRepeat=cc.Repeat:create(animation1,t_reppeate_time);
						    local funcall = cc.CallFunc:create(remove__);--//切换动作回调
						    local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
						    aliveSprph:runAction(seq);
                            self.fis_node:addChild(aliveSprph, -1);
                            if (dis_x >0.0001) then 
								aliveSprph:setFlipX(true);					
							    aliveSprph:setPosition(cc.p(460, -160));				    
						    else					
							    aliveSprph:setPosition(cc.p(-460, -160));					
					        end 		
                            aliveSprph:setScale(1.3);				
					end --if (readIndexph > 0 and aliveSprph) then                                     
     	      end --if(readIndex > 0 and aliveSpr) then 
        end -- if (self.fis_node) then 
      else  self:PlayWalkAction(10086);
    end-- if (self.m_last_action_kind == 1 and self.m_mov_pos_.x < 980 and self.m_mov_pos_.x>300) then --
    --]]
  end
  function CJ_BOSS:PlayWalkAction( tag )
 
       self.fis_node:removeChildByTag(10086);
       local i=0;
       local readIndex=0;
       local animFrames = cc.Animation:create();
	   for i = 0, 40, 1 do		
		 file_name=string.format("BOSS_01_%03d.png", i);
		 local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		 if (frame) then 	
			if (readIndex == 0) then 			
				aliveSpr = cc.Sprite:createWithSpriteFrame(frame);
			end
			readIndex=readIndex+1;    
            animFrames:addSpriteFrame(frame);
		 end
	  end
	  if (readIndex > 0 and aliveSpr) then 
           local function ActionChange_callback()
                  self:ActionChange();           
           end
		   self.baseAngle = 0;   
           animFrames:setDelayPerUnit(self.m_FrameSpeed1);
           local action =cc.Animate:create(animFrames);   
		   --local animation = cc.Animate:create(animFrames);
            -- animation:setDelayPerUnit(1/12.0);
			--	  local action =cc.Animate:create(animation);   
             --     local t_CCRepeat = cc.Repeat:create(action, 2);
           local t_reppeate_time = 3;
		   local t_repeat =cc.Repeat:create(action,t_reppeate_time);--   cc.RepeatForever:create(animation);
           local t_call_=cc.CallFunc:create(ActionChange_callback);
           local t_seq=cc.Sequence:create(t_repeat,t_call_,nil);
		   aliveSpr:runAction(t_seq);
           self.m_last_action_kind = 1;
		   self.fis_node:addChild(aliveSpr, 0, 10086);
		   self.m_flip_l = 0;
		   self.baseAngle = 0;
       
	       if(self.m_mov_index <self.m_mov_point_num)	then 
               local x,y=self.fis_node:getPosition();
		       local dis_x = self.m_mov_list[self.m_mov_index].x -x;		
	      	   if(dis_x>0) then               
                  aliveSpr:setFlippedX(true);
               end
		      
            end	
     	end
        --]]
  end
  return CJ_BOSS;

--endregion

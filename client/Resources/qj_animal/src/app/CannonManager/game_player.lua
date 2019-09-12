--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/5
--此文件由[BabeLua]插件自动生成
local game_player=class("game_player",
 function()
	return cc.Node:create()
end
)
function game_player:init()
   self.m_ui_main_root=nil;
   self.m_ui_cannon_main_root=nil;
   self.m_chair_num=0;
   self.m_score_num=0;
   self.m_cannonNum=0;
   self.m_bullet_kind=0;
   self.m_show_niname_timer=0;
   self.m_show_line_timer=0;              -- //显示射线
   self.m_show_line_flag=0;
   self.m_show_angle=0;
   self.m_show_as_bt_flag=0;
   self.m_fire_Main_Node=nil;         --//火焰节点
   self.m_cannon_nodePos=cc.p(0,0);        --//炮塔位置
   self.m_fire_flag=0;         --//开火标记           
   self.m_fire_timer=0;
   self.m_tick_num=0;         --////彩票
   self.m_tick_run_num=0;
   self.m_tick_RunArm=0;
   self.m_tick_run_step=0;
   self.m_tick_update_timer=0;
end
function game_player:ctor(local_chair_id,pos)
          self:init();
          local t__local_info_type=cc.exports._local_info_array_[local_chair_id];
          self.m_chair_num =local_chair_id;
		  self.m_score_num = 0;
		  self.m_cannonNum = 0;
		  self.m_bullet_kind = -1;
          self:setPosition(pos);
          self.m_fire_Main_Node=cc.Node:create();
		  self:addChild(self.m_fire_Main_Node,998);
          self.m_ui_main_root=ccs.GUIReader:getInstance():widgetFromJsonFile("qj_animal/res/game_res/Player_Ui_Animal/Player_Ui_Animal_1.json");
          self:addChild(self.m_ui_main_root);
          self.m_ui_main_root = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"main");
          self.m_ui_nicname = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"niname");--昵称
          if(self.m_ui_nicname~=nil) then 
      	     self.m_ui_nicname:setString("");
             if(t__local_info_type.sceore_angle>0) then 
                self.m_ui_nicname:setRotation(t__local_info_type.sceore_angle);
                self.m_ui_nicname:setAnchorPoint(cc.p(1, 0.5)) 
              end
          end;
          self.scoure_num = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"scoure_num");--分数
          if(self.scoure_num~=nil) then 
         	 self.scoure_num:setString("0");
         	 self.scoure_num:setRotation(t__local_info_type.sceore_angle);
             if (t__local_info_type.sceore_angle == 180) then 	self.scoure_num:setAnchorPoint(cc.p(0, 0.5)); end
          end;
          self.cannon_num =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"cannon_num");--切换值
		  if(self.cannon_num)then self.cannon_num:setString("100"); end
          self.m_ui_cannon_main_root =ccui.Helper:seekWidgetByName(self.m_ui_main_root, "cannon_manger");
          self.tick_num =ccui.Helper:seekWidgetByName(self.m_ui_main_root, "tick_num");
          if (self.tick_num) then 
              self.tick_num:setString("0"); 
              self.tick_num:setVisible(false);
          end
          self.tick_bg =ccui.Helper:seekWidgetByName(self.m_ui_main_root, "tick_bg");
          if (self.tick_bg) then 
              self.tick_bg:setVisible(false);
          end
          if (self.m_ui_cannon_main_root~=nil) then 
             self.cannon_main =ccui.Helper:seekWidgetByName(self.m_ui_cannon_main_root, "cannon_main");
             if (self.cannon_main)  then 
               local head =ccui.Helper:seekWidgetByName(self.cannon_main, "head");
               if(head) then head:setString(local_chair_id%10); end
             end
          end
          self:SetBulletKind(0);
		  self:ShowTick_Node(false);
		  self:ShowAdd_sub_bt(false);
         
   local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
   --]]
end

function game_player:update(delta)

  if(self.m_show_line_flag) then 	
		self:Show_line(true);
		if(self.m_show_line_timer > 0) then 
			self.m_show_line_timer = self.m_show_line_timer-delta;
		else		
			self.m_show_line_timer = 0;
			self.m_show_line_flag = 0;
		end
	else	
		self:Show_line(false);
	end
    
    if (self.m_fire_timer > 0)then
		self.m_fire_timer=self.m_fire_timer-delta;
		if (self.m_fire_timer <= 0) then self.m_fire_flag = 0;end
	end
    
    if (self.m_show_niname_timer < 20) then 
		self.m_show_niname_timer=self.m_show_niname_timer+ delta;
		if (self.m_show_niname_timer >= 20)	then
			if(self.m_ui_nicname)then 
				if(self.m_ui_nicname:isVisible()==false) then self.m_ui_nicname:setVisible(true); end
				if(self.m_ui_nicname:isVisible()) then self.m_ui_nicname:setVisible(false);       end
			end
		end
	end

    if (self.m_fire_Main_Node and self.m_ui_cannon_main_root) then	
		self.m_fire_Main_Node:setRotation(self.m_ui_cannon_main_root:getRotation());
		self.m_fire_Main_Node:setPosition(self:convertToNodeSpace(self:GetFirePoint()));
	end
    
    self:ShowTick_Effect_Update(delta);
end
function game_player:SetUserName(name)--//设置昵称
   if (self.m_ui_nicname) then 
		if (self.m_ui_nicname:isVisible()==false) then self.m_ui_nicname:setVisible(true); end
		self.m_ui_nicname:setText(name);
		self.m_show_niname_timer = 0;
	end
end
function game_player:SetBulletKind( kind)--//设置子弹类型 锥子
   if (self.m_bullet_kind ~= kind) then 
		kind = kind%4;
		self.m_bullet_kind = kind;
		if (self.cannon_main) then
           local i=0;
	        for i = 0,4, 1 do
				local tem_char_str=string.format("cannon_%d", i);
				 local  _layout_in=ccui.Helper:seekWidgetByName(self.cannon_main, tem_char_str);
				if (_layout_in) then 
					_layout_in:setVisible(false);
                    if (i == kind) then _layout_in:setVisible(true); end
				end				
			end
		end
	end   
end
function game_player:SetCannonNum( num)--//设置倍数
	if (self.m_cannonNum ~= num) then 
		self.m_cannonNum = num;
		if (self.cannon_num) then self.cannon_num:setString(num); end
	end  
end
function game_player:SetScoreNum( num)--//设置分数
    if (self.m_score_num~= num) then 
		self.m_score_num = num;		
		if (self.scoure_num) then self.scoure_num:setString(num); end
	end
end
function game_player:getScoreNumPos()--//获取分数位置
    local  t_pos=cc.p(0, 0);
	if(self.m_ui_main_root) then 
		if (self.scoure_num) then 	
            local px,py=self.scoure_num:getPosition();
			t_pos =cc.p(px,py);
		end
		t_pos = self.m_ui_main_root:convertToWorldSpace(t_pos);
	 end
	return t_pos;
end
function game_player:ShowAdd_sub_bt(show_ff)--//显示加减炮按钮
   -- cclog("game_player:ShowAdd_sub_bt(show_ff)");
	if (self.m_ui_main_root) then --self.m_ui_main_root
		--if(self.m_show_as_bt_flag ~= show_ff)then
			self.m_show_as_bt_flag = show_ff;
            local t_sub_bt =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"sub_bt");   
            local t_add_bt =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"add_bt");    
             --cclog("game_player:ShowAdd_sub_bt(show_ff) 11");  
			if (show_ff==true) then 	  
                     -- cclog("game_player:ShowAdd_sub_bt(show_ff) 12");                        
					if (t_sub_bt~=nil) then 	
                       -- cclog("game_player:ShowAdd_sub_bt(show_ff) 13"); 
                         local  function touchEvent_add_bt(sender, eventType)         
                              if eventType == ccui.TouchEventType.ended then  
                                  cc.exports.game_manager_:Sub_bullet_cur_Num();--ChangeConnonValue(self.m_chair_num, 0);
                              end
                         end		
						t_sub_bt:setVisible(true);
						t_sub_bt:addTouchEventListener(touchEvent_add_bt);
					end                             
					if (t_add_bt) then 	
                        -- cclog("game_player:ShowAdd_sub_bt(show_ff) 14"); 	
                         local  function touchEvent_sub_bt(sender, eventType)         
                                if eventType == ccui.TouchEventType.ended then  
                                    cc.exports.game_manager_:Add_bullet_cur_Num();--ChangeConnonValue(self.m_chair_num, 1);
                               end
                         end			
						t_add_bt:setVisible(true);
						t_add_bt:addTouchEventListener(touchEvent_sub_bt);
					end		
			else 
                --cclog("game_player:ShowAdd_sub_bt(show_ff) 22");           
				if (sub_bt)  then 				
					sub_bt:setVisible(false);
					sub_bt:setEnabled(false);
				end
				if (add_bt) then 			
					add_bt:setVisible(false);
					add_bt:setEnabled(false);
				end
			end
		--end
	end
end
function game_player:Fire(angle)--                        //开火
 -- cclog("function game_player:Fire(angle)");
  if(self.cannon_main~=nil) then 
     --//炮塔后退 
     local t_mov_timer0 = 0; --//(CANNONMOVMAX + _layout_in->getPosition().y) / 80.0f;
	 local t_mov_timer1 = 0; --// CANNONMOVMAX / 40.0f;
     local t_dis_y =10 -self.cannon_main:getPositionY();
     t_mov_timer0 = t_dis_y / 360.0;
	 t_mov_timer1 = 10 /240.0;
	 self.cannon_main:stopAllActions();
	 local moveTo0 = cc.MoveTo:create(t_mov_timer0,cc.p(0,-10));
	 local delaytime = cc.DelayTime:create(0.1);
	 local moveTo1 = cc.MoveTo:create(t_mov_timer1, cc.p(0, 0));
	 local seq = cc.Sequence:create(moveTo0, delaytime, moveTo1, nil);
	 self.cannon_main:runAction(seq);
     --添加火焰
     self.m_fire_timer = 0.3;
     self.m_fire_flag = 1;
     if(self.m_fire_Main_Node~=nil) then 
       -- cclog("function game_player:Fire(angle)11");
        local kind = self.m_bullet_kind%4;
        local tem_char_str=string.format("cannon_%d", kind);
        local _layout_in=ccui.Helper:seekWidgetByName(self.cannon_main,tem_char_str);  
        local _fire_point =ccui.Helper:seekWidgetByName(_layout_in, "fire_point");
        local t_fire_pos = cc.p(0, 0);
        local t_dis_y_num = 0;
		local dis_x_num = 15;
        local t_cannon_num = (kind + 1);
        local t_fire_effect_pos={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
        t_fire_pos.y = t_fire_pos.y+t_dis_y_num;
 
        if(t_cannon_num<1) then return ; end
        if (t_cannon_num == 1) then t_fire_effect_pos[0] = t_fire_pos;
        elseif(t_cannon_num == 2) then 				
			t_fire_effect_pos[0] = t_fire_pos;
			t_fire_effect_pos[1] = t_fire_pos;
			t_fire_effect_pos[0].x = t_fire_effect_pos[0].x-(1.0*dis_x_num);
			t_fire_effect_pos[1].x = t_fire_effect_pos[0].x+(1.0*dis_x_num);
        elseif(t_cannon_num == 3) then 				
			t_fire_effect_pos[0] = t_fire_pos;
			t_fire_effect_pos[1] = t_fire_pos;
			t_fire_effect_pos[2] = t_fire_pos;
			t_fire_effect_pos[0].x = t_fire_effect_pos[0].x-(1.5*dis_x_num);
			t_fire_effect_pos[2].x = t_fire_effect_pos[0].x+(1.5*dis_x_num);
        elseif (t_cannon_num == 4) then 
        	t_fire_effect_pos[0] = t_fire_pos;
			t_fire_effect_pos[1] = t_fire_pos;
			t_fire_effect_pos[2] = t_fire_pos;
			t_fire_effect_pos[3] = t_fire_pos;
			t_fire_effect_pos[0].x=t_fire_effect_pos[0].x-(1.0*dis_x_num);
			t_fire_effect_pos[1].x=t_fire_effect_pos[1].x+(1.0*dis_x_num);
			t_fire_effect_pos[2].x=t_fire_effect_pos[2].x-(2.0*dis_x_num);
			t_fire_effect_pos[3].x=t_fire_effect_pos[3].x+(2.0*dis_x_num);
		end --else if (t_cannon_num == 4) then       
        local t_frame_sapeed = 1 / 60.0;      
        local n=0;
        for n = 0,t_cannon_num-1,1 do
            local file_name ="";
	     	local _sprite = nil;
		    local readIndex = 0;
		    local animFrames = cc.Animation:create();
            local i=0;
	        for  i = 0,12, 1 do
                file_name=string.format("~FireEffect_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if(frame) then		
                    if(readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
                end
            end --for i
            --cclog("function game_player:Fire(angle)readIndex=%d",readIndex);
            if (readIndex > 0) then 	
                local function removefunc()
                   if(_sprite~=nil)then _sprite:removeFromParent(); end
                end			
                animFrames:setDelayPerUnit(t_frame_sapeed);
				local animation = cc.Animate:create(animFrames);
				local t_CCRepeat =cc.Repeat:create(animation, 1);
				local funcall = cc.CallFunc:create(removefunc);
				local seq =cc.Sequence:create(t_CCRepeat,funcall, nil);
				_sprite:setRotation(90);
				_sprite:setScale(1.3);
				_sprite:runAction(seq);				
				self.m_fire_Main_Node:addChild(_sprite);
				_sprite:setPosition(t_fire_effect_pos[n]);
          end	--	if (readIndex > 0) then			
        end --for n
     end --if(self.m_fire_Main_Node~=nil)
  end --if(self.cannon_main~=nil) then 
end
function game_player:GetFirePoint()    --//获取子弹发射点
  local  t_ccretpoint=cc.p(0,0);
  if (self.cannon_main) then 
		local kind = self.m_bullet_kind%4;
		local  tem_char_str=string.format("cannon_%d", kind);
		local _layout_in =ccui.Helper:seekWidgetByName(self.cannon_main,tem_char_str);  
		if (_layout_in~=nil) then 		
			local _fire_point =ccui.Helper:seekWidgetByName(_layout_in,"fire_point");
			if (_fire_point) then 			
            	 local px,py=_fire_point:getPosition();
				 local x,y= _layout_in:convertToWorldSpace(cc.p(px,py));
                 t_ccretpoint=cc.p(x,y);
			end
		end
	end
  return t_ccretpoint;
end
function game_player:SetCannon_angle( angle)
    if(self.m_ui_cannon_main_root) then 
      local tem_dis_angle =0;
      self.m_ui_cannon_main_root:setRotation(angle + tem_dis_angle);
      t_dis_angle = self.m_show_angle - angle;
	 if (t_dis_angle > 0.0001 or t_dis_angle < -0.0001) then 	
		 self.m_show_line_timer = 0.5;            
		 self.m_show_line_flag = 1;
	 end
	 self.m_show_angle = angle;
    end
end
function game_player:Show_line( show_flag)
--[[
		if(self.cannon_main) then 
			local kind = self.m_bullet_kind%4;
			local tem_char_str="";
            local i=0;
			for i = 0,4,1 do	
				tem_char_str=string.format("cannon_%d", i);
				local _layout_in =ccui.Helper:seekWidgetByName(self.cannon_main,tem_char_str);
				if (_layout_in) then 			
					local _layout_line0 =ccui.Helper:seekWidgetByName(_layout_in, "line0");
					local _layout_line1 =ccui.Helper:seekWidgetByName(_layout_in, "line1");
					if (i == kind) then 					
						if(_layout_in:isVisible()) then _layout_in:setVisible(true); end
						if (show_flag == 0)then 
							if (_layout_line0 and _layout_line0:isVisible()) then _layout_line0:setVisible(false); end
							if (_layout_line1 and _layout_line0:isVisible()) then _layout_line1:setVisible(false);  end
						else					
							if (_layout_line0 and _layout_line0:isVisible()==false) then _layout_line0:setVisible(true);  end
							if (_layout_line1 and _layout_line1:isVisible()==false) then _layout_line1:setVisible(true);  end
						end
					else					
						if (_layout_in:isVisible()) then _layout_in:setVisible(false); end
						if (_layout_line0 and _layout_line0:isVisible()) then _layout_line0:setVisible(false); end
						if (_layout_line1 and _layout_line1:isVisible())then _layout_line1:setVisible(false);  end
					end
				end
			end
		end
        --]]
end
function game_player:ShowTick_Effect_Update( dt)--   //更新

end
function game_player:ShowTick_Node( showflag)--      //显示节点
	if (self.m_ui_main_root) then 
		local tick_num = ccui.Helper:seekWidgetByName(self.m_ui_main_root, "tick_num");
		if (tick_num) then 	
			tick_num:setVisible(showflag);
		end
		local  tick_bg =ccui.Helper:seekWidgetByName(m_ui_main_root, "tick_bg");
		if (tick_bg) then 	
			tick_bg:setVisible(showflag);
		end
	end
end
function game_player:AddTick( ticknum,  tickTotal)--//获得彩票
end
return game_player;

--endregion

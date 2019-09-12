--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/13
--此文件由[BabeLua]插件自动生成 玩家类
local game_player=class("game_player",
 function()
	return cc.Node:create()
end
)
function game_player:ctor(local_chair_id,pos)
       cclog("game_player:ctor local_chair_id=%f,pos(%f,%f)\n",local_chair_id,pos.x,pos.y); 
      local t__local_info_type=cc.exports._local_info_array_[local_chair_id];
      self.m_chair_num = local_chair_id;
      self.m_score_num = 0;
      self.m_cannonNum = 0;
	  self.m_bullet_kind = 0;
      self:setPosition(pos);
      self:setScale(0.7);
      self.m_ui_main_root=ccs.GUIReader:getInstance():widgetFromJsonFile("haiwang/res/HW/Json/Player_Ex_1.json");
      self:addChild(self.m_ui_main_root);
      
      self.m_ui_nicname = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"niname");--昵称
      if(self.m_ui_nicname~=nil) then 
      	  self.m_ui_nicname:setString("");
          if (t__local_info_type.sceore_angle ==90)then 
            self.m_ui_nicname:setRotation(0);
         	self.m_ui_nicname:setAnchorPoint(cc.p(1, 0.5)); 
          elseif (t__local_info_type.sceore_angle ==-90)then 
            self.m_ui_nicname:setRotation(0);
         	self.m_ui_nicname:setAnchorPoint(cc.p(1, 0.5)); 
          elseif(t__local_info_type.sceore_angle>0) then 
            self.m_ui_nicname:setRotation(t__local_info_type.sceore_angle);
            self.m_ui_nicname:setAnchorPoint(cc.p(1, 0.5)) 
            end
         end;
       self.scoure_num = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"scoure_num");--分数
      if(self.scoure_num~=nil) then 
         	self.scoure_num:setString("0");
         	self.scoure_num:setRotation(t__local_info_type.sceore_angle);
         if (t__local_info_type.sceore_angle ==180)    then 	self.scoure_num:setAnchorPoint(cc.p(0, 0.5)); 
         elseif (t__local_info_type.sceore_angle ==90)then 
            self.scoure_num:setRotation(0);
         	self.scoure_num:setAnchorPoint(cc.p(1, 0.5)); 
         elseif (t__local_info_type.sceore_angle ==-90)then 
            self.scoure_num:setRotation(0);
         	self.scoure_num:setAnchorPoint(cc.p(1, 0.5)); 
         end
       end;
       	self.m_connon_numAtlas =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"zhuizi_num");--切换值
		if (	self.m_connon_numAtlas)	then self.m_connon_numAtlas:setString("0"); end
        local score_box = ccui.Helper:seekWidgetByName(self.m_ui_main_root,"score_box");--分数框
		if (score_box) then score_box:setString(local_chair_id % 10);end
        self.cannon_num =  ccui.Helper:seekWidgetByName(self.m_ui_main_root,"cannon_num");--子弹分数
		if (self.cannon_num) then 		
				self.cannon_num:setString("100");
				self.cannon_num:setRotation(t__local_info_type.sceore_angle);         
                if (t__local_info_type.sceore_angle ==90)then 
                     self.cannon_num:setRotation(0);
                elseif (t__local_info_type.sceore_angle ==-90)then 
                    self.cannon_num:setRotation(0);
                end
		end
         self.Front =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"Front");--
        -- static_cast<Layout*>	(UIHelper::seekWidgetByName(m_ui_main_root,"Front"));
        self.m_main_pos = cc.p(pos.x,pos.y);
         self.m_Shake_Flag = 0;
	    self.m_Shake_timer = 0;
          local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
end

function game_player:update(delta) --定时器
   if(delta>0.04) then delta=0.04; end;
   if (self.m_Shake_Flag) then 
		if (self.m_Shake_timer > 0) then 
			self.m_Shake_timer = self.m_Shake_timer-delta;
			local randx =math.random(0,100)%5;
			local randy =math.random(0,100) % 5;
            local _new_pos=cc.p(randx,randy);
            if(math.random()%2<1) then randx=-randx;end
            if(math.random()%2<1) then randy=-randy;end
            _new_pos.x=_new_pos.x+self.m_main_pos.x;
           _new_pos.y=_new_pos.y+self.m_main_pos.y;
			self:setPosition(_new_pos);
			if (self.m_Shake_timer < -0.00001) then 
				self:setPosition(self.m_main_pos);
				self.m_Shake_Flag = 0;
			end
		end
	end
end

function game_player:ShowCannon_( show_) --显示炮管
        if (self.cannon_num)then self.cannon_num:setVisible(show_); end
		if (	self.m_connon_numAtlas)then 	self.m_connon_numAtlas:setVisible(show_); end
		if (self.Front) then self. Front:setVisible(show_); end
     --self:setVisible(show_);
end


function game_player:SetCannon_angle( angle)--旋转炮管
      -- cclog("game_player:SetCannon_angle( angle=%d).......................",angle);
        if (self.m_connon_numAtlas) then
		   local t__local_info_type = cc.exports._local_info_array_[self.m_chair_num];
		   local tem_dis_angle = t__local_info_type.default_angle;
		--if ( (t__local_info_type.default_angle > 89 and t__local_info_type.default_angle < 91)or (t__local_info_type.default_angle <-89 and t__local_info_type.default_angle >-91))  then   
             self.m_connon_numAtlas:setRotation(angle - tem_dis_angle); 
	 	--else    self.m_connon_numAtlas:setRotation(angle + tem_dis_angle); end
       end      
end

function game_player:SetUserName(name, flag)--设置昵称
    if (self.m_ui_nicname) then
		self.m_ui_nicname:setString(name); 

		if (flag == 0) then self.m_ui_nicname:setColor(cc.c3b(255, 80, 0));
		else self.m_ui_nicname:setColor(cc.c3b(255, 255, 255));end
	end
end

function game_player:SetBulletKind( kind)--设置子弹类型 锥子
   -- cclog("game_player:SetBulletKind self.m_bullet_kind=%d kind=%d",self.m_bullet_kind,kind);
   if (self.m_bullet_kind ~= kind) then
		self.m_bullet_kind = kind;
		if ( self.m_connon_numAtlas) then self.m_connon_numAtlas:setString(self.m_bullet_kind); end
	end
    
end
function game_player:SetCannonNum(num) --设置倍数  
    if (self.m_cannonNum ~= num)  then
		self.m_cannonNum = num; 
		if ( self.cannon_num) then self.cannon_num:setString(num);end
	end
end

function game_player:SetScoreNum(num)--设置分数
    --cclog("game_player:SetScoreNum(num=%f).............................",num);
    if (self.m_score_num ~= num) then 
		self.m_score_num = num;
		if (self.scoure_num)then self.scoure_num:setString(self.m_score_num);end
	end 
end
function game_player:ShowMyConButton()  
   local  function touchEvent_sub_bt(sender, eventType)
    if eventType==ccui.TouchEventType.ended then  
    --print("game_player:touchEvent_sub_bt \n"); 
    cc.exports.game_manager_:Sub_bullet_cur_Num();
    end
   end
   local sub_bt =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"sub_bt");                   
  if(sub_bt) then
			sub_bt:addTouchEventListener(touchEvent_sub_bt);
			sub_bt:setVisible(true);
  end
  local  function touchEvent_add_bt(sender, eventType)
    if eventType == ccui.TouchEventType.ended then

      --print("  game_player:touchEvent_add_bt \n");
        cc.exports.game_manager_:Add_bullet_cur_Num();
       end
   end
   local add_bt =ccui.Helper:seekWidgetByName(self.m_ui_main_root,"add_bt");                 
  if (add_bt) then
	    add_bt:addTouchEventListener(touchEvent_add_bt);
		add_bt:setVisible(true);
	end
    
end
function game_player:getScoreNumPos() --获取分数位置
    local t_pos=cc.p(0,0);
	if (self.m_ui_main_root) then 
		if (self.scoure_num)then
            local x,y=self.scoure_num:getPosition(); 
        	t_pos = cc.p(x,y)
          end
		t_pos = self.m_ui_main_root:convertToWorldSpace(t_pos);
    end
	return  t_pos;
    
end
function game_player:GetFirePos()          --开火位置
	local t_pos=cc.p(0, 0);
	if (self.m_connon_numAtlas) then
		local fire_point = ccui.Helper:seekWidgetByName(self.m_connon_numAtlas,"firepoint");
		if (fire_point) 
        then
         local x,y = fire_point:getPosition();  
         t_pos=cc.p(x,y);
         end
		t_pos = self.m_connon_numAtlas:convertToWorldSpace(t_pos);    
	end
	return  t_pos;
end
function game_player:GetFireEffectPos() --特效位置
   --cclog("game_player:GetFireEffectPos00");
   local  t_pos=cc.p(0, 0);
	if (self.m_connon_numAtlas) then
       --cclog("game_player:GetFireEffectPos11");
		local fireEffectpoint= ccui.Helper:seekWidgetByName(self.m_connon_numAtlas,"fireEffectpoint");
		if (fireEffectpoint) then
         --cclog("game_player:GetFireEffectPos22");
         local x,y= fireEffectpoint:getPosition();
           t_pos=cc.p(x,y);
            --cclog("game_player:GetFireEffectPos(%f,%f)",x,y);
        end
		t_pos = self.m_connon_numAtlas:convertToWorldSpace(t_pos);
	end
	return  t_pos;
end
function game_player:PlayShake()         --震动
    self.m_Shake_Flag = 1;
	self.m_Shake_timer = 1;
end

return game_player;
--endregion

--region cannonmanager.lua 炮塔管理
--Author : Administrator
--Date   : 2017/4/8
--此文件由[BabeLua]插件自动生成
local cannonmanager = class("cannonmanager",
 function()
	return cc.Node:create()
end
)
function cannonmanager:inti()
    self.current_angle_={[0]=0,0,0,0,0,0,0,0,0};
    self.m_fFireAngle={[0]=0,0,0,0,0,0,0,0,0};
    self.current_bullet_kind_={0,0,0,0,0,0,0,0,0,0,0,0};
    self.current_mulriple_={[0]=10,10,10,10,10,10,10,10,10,10,10,10};
    self.m_onlineState={[0]=0,0,0,0,0,0,0,0,0};
    self.fish_score_={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Broach_Flag={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Broach_Delay={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Broach_BulletMul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Broach_CatchMul={[0]=0,0,0,0,0,0,0,0,0};
	self.m_Broach_CatchScore={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Broach_FireFlag={[0]=0,0,0,0,0,0,0,0,0};
    --self.m_Dianci_Delay={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Dianci_Flag={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Dianci_BulletMul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Dianci_CatchMul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Dianci_CatchScore={[0]=0,0,0,0,0,0,0,0,0};
    self.m_Dianci_CatchTimer={[0]=0,0,0,0,0,0,0,0,0};
   -- self.m_FreeBullet_Delay={[0]=0,0,0,0,0,0,0,0,0};
    self.m_FreeBullet_Flag={[0]=0,0,0,0,0,0,0,0,0};
    self.m_FreeBullet_Mul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_FreeBullet_Catch_Score={[0]=0,0,0,0,0,0,0,0,0};
    self.m_FreeBullet_Catch_Timer={[0]=0,0,0,0,0,0,0,0,0};
    --self.m_GuidedMissile_Delay={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_FireFlag={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_Flag={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_Mul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_CatchMul={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_CatchScore={[0]=0,0,0,0,0,0,0,0,0};
    self.m_GuidedMissile_Timer={[0]=0,0,0,0,0,0,0,0,0};
     --self.m_MRY_catch_Delay={[0]=0,0,0,0,0,0,0,0,0};
     self.m_MRY_catch_Flag={[0]=0,0,0,0,0,0,0,0,0};
     self.m_MRY_catch_Mul={[0]=0,0,0,0,0,0,0,0,0};
     self.m_MRY_catch_Score={[0]=0,0,0,0,0,0,0,0,0};
     self.m_MRY_catch_Timer={[0]=0,0,0,0,0,0,0,0,0};
     self.m_MRY_Fish_ID={[0]=0,0,0,0,0,0,0,0,0};
     self.m_BaoxiangNum={[0]=0,0,0,0,0,0,0,0,0};
     self.m_baoxiangScore={[0]=0,0,0,0,0,0,0,0,0};
     self.m__InterlinkBomb_Score={[0]=0,0,0,0,0,0,0,0,0};
     self.m__InterlinkBomb_Flag={[0]=0,0,0,0,0,0,0,0,0};
     self.m__InterlinkBomb_Delay={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_catch_ChainShell_Timer={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_catch_ChainShell_Flag={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_ChainShell_score={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_ChainShell_mul={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_king_timer={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_kingl_Flag={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_king_king_timer={[0]=0,0,0,0,0,0,0,0,0};
     self.m_catch_king_king_Flag={[0]=0,0,0,0,0,0,0,0,0};
     self.m_Dianci_FireFlag={[0]=0,0,0,0,0,0,0,0,0};
     self.sec_timer=0;
end
function cannonmanager:ctor()
      self:inti();
     
      --cc.exports._local_player_num_I=6;
     -- if( cc.exports._local_player_num_I==6) then cc.exports._local_info_array_= cc.exports._local_info_array_6;
     -- elseif( cc.exports._local_player_num_I==8) then cc.exports._local_info_array_= cc.exports._local_info_array_8; end

      local i=0;
      local t_node_scale=1;
      if( cc.exports._local_player_num_I==8) then t_node_scale=0.9 end;
	  for  i = 0,_local_player_num_I-1, 1 do
     	local cannon_base_node =cc.Node:create();      -- 一个炮塔节点
        cannon_base_node:setScale(t_node_scale);
		self:addChild(cannon_base_node, 11, 9999 + i);
       local t_game_player = CGame_player.new(i, cc.p(-240, -60)); --单人敲击
       cannon_base_node:addChild(t_game_player, 1, 6666);      --添加游戏虚拟节点和位置

        local t_node_cannon_node = cc.Node:create();           --炮管虚拟节点
		 local t_node_spec_node = cc.Node:create();              --特殊奖励效果管理节点 如双倍子弹==
	    local t_node_double_card_node = cc.Node:create();    --能量炮卡片
	    local t_node_lock_card_node = cc.Node:create();        --锁定卡片
	    local t_node_Stack_node = cc.Node:create();             --金币堆
        cannon_base_node:addChild(t_node_cannon_node, 0, PLAYER_CANNON_TAG);          --炮管虚拟节点
		cannon_base_node:addChild(t_node_spec_node, 0, PLAYER_SPEC_TAG);                   --特殊奖虚拟节点
		cannon_base_node:addChild(t_node_double_card_node, 3, 78);                                     --能量炮卡片
		cannon_base_node:addChild(t_node_lock_card_node, 3, 79);                                         --锁定卡片
		cannon_base_node:addChild(t_node_Stack_node, 3, 81);                                              --锁定卡片
        t_node_cannon_node:setAnchorPoint(cc.p(0.5, 0.5));
		t_node_double_card_node:setPosition(cc.p(140, 140));
		t_node_lock_card_node:setPosition(cc.p(-53, 142));
		t_node_Stack_node:setPosition(cc.p(-100, -58));
        local t_spr_cannon_fireNode =cc.Node:create();                                                                                                                  --子弹节点
		t_node_cannon_node:addChild(t_spr_cannon_fireNode, 0, CANNON_VIRFIREPOINT_TAG);                                                   --炮管上添加开火节点
		t_spr_cannon_fireNode:setPosition(cc.p(0, 65));
		cannon_base_node:setPosition(cc.p(_local_info_array_[i].x, _local_info_array_[i].y));  --显示
		cannon_base_node:setRotation(_local_info_array_[i].default_angle);
         cc.SpriteFrameCache:getInstance():addSpriteFrames("haiwang/res/HW/fireEffect.plist");		--加载开火特效
    end
    cc.exports.g_cannon_manager=self;--.cannon_manager_;
    for i=0,GAME_PLAYER,1 do
       self:SetPlayer_Type(i,4);
    end
      local function handler(interval)
            self:SecTimer(interval);
       end
      self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);

end



-------------------------------------------------------------功能函数---------------------------------------------
--region  功能函数
function cannonmanager:SetCurrentAngle( chair_id,  angle)        --设置角度
     --cclog("cannonmanager:SetCurrentAngle chair_id=%d,angle=%f",chair_id,angle);

	if (chair_id < GAME_PLAYER)
	then
		self.current_angle_[chair_id] =math.deg(angle); --MySriteCache::GetAngleForRadian(angle);
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node~=nil)
		then
            local t__local_info_type = cc.exports._local_info_array_[chair_id];
			local t_node_cannon_node = t_cannon_base_node:getChildByTag(PLAYER_CANNON_TAG);   --炮管节点

			if (t_node_cannon_node)	then		t_node_cannon_node:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);end
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_game_player:SetCannon_angle(self.current_angle_[chair_id]); end

			if (self.m_Broach_Flag[chair_id]>0)  then --穿甲弹
				local t_cannon_base =t_cannon_base_node:getChildByTag(77777 + chair_id);
				if (t_cannon_base)	then
					t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
				end
			end
			 if (self.m_Dianci_Flag[chair_id]>0)then    --电磁炮
				local t_cannon_base =t_cannon_base_node:getChildByTag(66667 + chair_id);
				if (t_cannon_base)	then
					t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
				end
			end
			 if (self.m_FreeBullet_Flag[chair_id]>0) then--免费子弹
				 local t_cannon_base = t_cannon_base_node:getChildByTag(55557 + chair_id);
				 if (t_cannon_base) then t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle); end
			 end
		end
        --print(self:getRotation())
	end
end
function cannonmanager:Connon_Angle_Reset( local_chair_id)  --炮管复位 主要用于锁定结束
  	 local t__local_info_type = cc.exports._local_info_array_[local_chair_id];
	self.current_angle_[chair_id] = t__local_info_type.default_angle;
	self:SetCurrentAngle(chair_id, self.current_angle_[chair_id]);
end
function cannonmanager:SetCannonMulriple( chair_id,  mulriple) --设置倍数
  -- cclog("cannonmanager:SetCannonMulriple chair_id=%f,mulriple=%f",chair_id,mulriple);
	if (chair_id <_local_player_num_I) then
    self.current_mulriple_[chair_id]= mulriple
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			local t_game_player =t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then 	t_game_player:SetCannonNum(mulriple); end
		end
    end
    --]]
end
function cannonmanager:GetCannonMulriple( chair_id) --取倍数
return  self.current_mulriple_[chair_id];
end
function cannonmanager:GetCurrentAngle( chair_id)  --取角度
return  math.rad(self.current_angle_[chair_id]);
end
function cannonmanager:ShowMyConButton(chair_id)  --显示控制按钮
    cclog("CannonManager::ShowMyConButton() \n");
	local t_cannon_base_node = self:getChildByTag(9999 +chair_id);
	if (t_cannon_base_node) then
		local t_game_player =t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then t_game_player:ShowMyConButton(); end
	end
end
function cannonmanager:GetCannonPos(chair_id,  flag)--取炮塔坐标
    local t_ccp_=cc.p(0,0);
	local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node)
	then
		local x,y =t_cannon_base_node:getPosition();
       -- cc.Node:convertToWorldSpace
       -- cclog("cannonmanager:GetCannonPos t_start_pos(%f,%f)",x,y);
		t_ccp_ = self:convertToWorldSpace(cc.p(x,y));
		if (flag>0)then
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_ccp_ = t_game_player:GetFirePos(); end
           -- cclog("cannonmanager:GetCannonPos t_start_pos(%f,%f)",x,y);
		end
	end
	return t_ccp_;
end
function cannonmanager:Switch( chair_id,  bullet_kind)--刷新
   --cclog(" cannonmanager:Switch chair_id=%d,bullet_kind=%d",chair_id,bullet_kind);
	if (chair_id <_local_player_num_I) then
	if (bullet_kind >= 0 and bullet_kind < 12) then
		if (bullet_kind ~= self. current_bullet_kind_[chair_id]) then
			self. current_bullet_kind_[chair_id] = bullet_kind;
			local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
				local t_game_player =t_cannon_base_node:getChildByTag(6666);
				if (t_game_player) then 	t_game_player:SetBulletKind(bullet_kind); end
                end
			end
		end
    end
    --]]
end
function cannonmanager:GetCurrentBulletKind( chair_id)
     return self.current_bullet_kind_[chair_id];
end
function cannonmanager:Fire( chair_id, bullet_kind)
    --cclog("cannonmanager:Fire( chair_id=%d, bullet_kind=%d)???????????????",chair_id,bullet_kind);
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
    if (t_cannon_base_node) then
       local t_game_player =t_cannon_base_node:getChildByTag(6666);
       if (t_game_player) then
          	t_cannon_base_node:removeChildByTag(11186);
			local t_effect_pos = t_game_player:GetFireEffectPos();
            -- cclog("cannonmanager:Fire t_effect_pos(%f,%f)",t_effect_pos.x,t_effect_pos.y);--
			local t_pt= t_cannon_base_node:convertToNodeSpace(t_effect_pos);
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,12, 1 do
				file_name=string.format("~FireEffect_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
                if(frame) then
				    if (readIndex <1)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
				    readIndex=readIndex+1;
                    animation:addSpriteFrame(frame);
                end
			end
			if (readIndex > 0)	then
                --cclog("cannonmanager:Fire(readIndex=%d)",readIndex);--
                local function fire_callback()
                    _sprite:removeFromParent();
               end
			    animation:setDelayPerUnit(1/60.0);
                local action =cc.Animate:create(animation);
				local t_CCRepeat = cc.Repeat:create(action,1);
				local funcall = cc.CallFunc:create(fire_callback);
				local seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
				_sprite:runAction(seq);
			end
            --cclog("cannonmanager:Fire t_effect_pos(%f,%f) t_pt(%f,%f)",t_effect_pos.x,t_effect_pos.y,t_pt.x,t_pt.y);--
            if (_sprite)	then
						_sprite:setPosition(t_pt);
						_sprite:setScale(2.5);
						_sprite:setRotation(self.current_angle_[chair_id]-90);
						t_cannon_base_node:addChild(_sprite, 0, 11186);
			end      
       end
    end
end
--cc.Node:setVisible
function  cannonmanager:setVisible_(chair_id,flag)
      
       print("cannonmanager:setVisible_...flag=.....................11",flag);
       print("cannonmanager:setVisible_...chair_id=.....................11",chair_id);
       local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node)then
             t_cannon_base_node:setVisible(flag);
        end
        --]]
end
function  cannonmanager:SetPlayer_Type( chair_id,  palyer_type)--设置玩家类型
     -- cclog("cannonmanager:SetPlayer_Type( chair_id=%d)", chair_id);
      if(palyer_type) then  cclog("cannonmanager:SetPlayer_Type( palyer_type=%d)", palyer_type); end
     -- if (chair_id < 8) then
           local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
                t_cannon_base_node:removeChildByTag(198204);
                if(palyer_type) then
                     if (palyer_type == 0) then --手机
							local t_ico_node =cc.Sprite:create("haiwang/res/HW/phoneinfo.png");
							if (t_ico_node) then
								t_cannon_base_node:addChild(t_ico_node, 10086, 198204);
                                t_ico_node:setRotation(_local_info_array_[chair_id].default_angle);
								t_ico_node:setScale(0.6);
								t_ico_node:setPosition(ccp(90, -20));
							end
				      elseif (palyer_type == 1) then --街机
							local t_ico_node =cc.Sprite:create("haiwang/res/HW/jiejiinfo.png");
							if (t_ico_node) then
								t_cannon_base_node:addChild(t_ico_node, 10086, 198204);
                                t_ico_node:setRotation(_local_info_array_[chair_id].default_angle);
								t_ico_node:setScale(0.6);
								t_ico_node:setPosition(ccp(90, -20));
							end
			      	end
                end
			end
    --  end
end
function cannonmanager:SetFishScore( chair_id,  swap_fish_score)
       --cclog("cannonmanager:SetFishScore chair_id=%d,  swap_fish_score=%d",chair_id,swap_fish_score);
        self.fish_score_[chair_id] = swap_fish_score;
		local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node)then
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player)	then
				t_game_player:SetScoreNum(swap_fish_score);
			end
		end
end
--[[
function cannonmanager:AddFishScore( chair_id,  swap_fish_score)
    --  cclog(" cannonmanager:AddFishScore chair_id=%d,swap_fish_score=%d fish_score_=%d",chair_id,swap_fish_score,self.fish_score_[chair_id]);
       if(self.fish_score_[chair_id]==nil) then self.fish_score_[chair_id]=0;end
       self.fish_score_[chair_id] =self.fish_score_[chair_id] +swap_fish_score;
	   self:SetFishScore(chair_id,self.fish_score_[chair_id]);
end
function cannonmanager:SubFishScore( chair_id,  swap_fish_score)
   --  cclog(" cannonmanager:SubFishScore chair_id=%d,swap_fish_score=%d fish_score_=%d",chair_id,swap_fish_score,self.fish_score_[chair_id]);
     self.fish_score_[chair_id] =self.fish_score_[chair_id]-swap_fish_score;
	  self:SetFishScore(chair_id,self.fish_score_[chair_id]);
end
--]]
function cannonmanager:ResetFishScore( chair_id)
     if(chair_id==nil ) then return ; end
     if(self.fish_score_[chair_id]==nil) then self.fish_score_[chair_id]=0;end
      self.fish_score_[chair_id] =0;
	    self:SetFishScore(chair_id,self.fish_score_[chair_id]);
        self:SetPlayer_Type(chair_id,4);
       --清空特殊图标
        self:Exit_Broach(chair_id);
		self:Exit_Dianci(chair_id);
		self:Exit_FreeBullet(chair_id);
		self:Exit_GuidedMissileBullet(chair_id);
		self:Exit_InterlinkBomb(chair_id);
		self:Catch_MRY_End(chair_id);
		self:Catch_BaoxiangEnd(chair_id,0);
end
function cannonmanager:GetFishScore( chair_id)
   if(self.fish_score_[chair_id]==nil) then self.fish_score_[chair_id]=0;end
    return  self.fish_score_[chair_id];
end
function cannonmanager:SetOnlineState( state,  chairID)
    self.m_onlineState[chairID] = state;
    local  t_cannon_base_node =self:getChildByTag(9999 + chairID);
    local show_flag=false;
     if(state) then show_flag=true; end
	if (t_cannon_base_node)
	then
			local t_game_player =t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_game_player:setVisible(state);end
	end


end
function cannonmanager:SetUserName( chair_id, name_str)
         --cclog("cannonmanager:SetUserName chair_id=%f,name_str=%s",chair_id,name_str);
        local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_game_player:SetUserName(name_str, t_flag); end
		end
end
function cannonmanager:get_score_num_position( local_chair_id)           --获取分数位置
   local r_pos = cc.p(0, 0);
   local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
   if (t_cannon_base_node) then
		local t_game_player = t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then r_pos = t_game_player:getScoreNumPos(); end
	end
	return r_pos;
end
function cannonmanager:get_double_card_position( local_chair_id)           --获取双倍子弹等卡片位置
   	local  r_pos = cc.p(0, 0);
	local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
	if (t_cannon_base_node)
	then
       local x,y= t_cannon_base_node:getChildByTag(78):getPosition();
		r_pos =cc.p(x,y);
		local t_pos = t_cannon_base_node:convertToWorldSpace(r_pos);
        r_pos=cc.p(t_pos.x,t_pos.y);
	end
	return r_pos;

end
function cannonmanager:get_lock_card_position( local_chair_id)             --获取锁定卡片位置
   	local  r_pos = cc.p(0, 0);
	local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
	if (t_cannon_base_node)
	then
       local x,y= t_cannon_base_node:getChildByTag(79):getPosition();
		r_pos =cc.p(x,y);
		local t_pos = t_cannon_base_node:convertToWorldSpace(r_pos);
        r_pos=cc.p(t_pos.x,t_pos.y);
	end
	return r_pos;
end
function cannonmanager:get_Stack_position( local_chair_id)                 --获取金币堆的位置
 	local  r_pos = cc.p(0, 0);
	local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
	if (t_cannon_base_node)
	then
       local x,y= t_cannon_base_node:getChildByTag(81):getPosition();
		r_pos =cc.p(x,y);
		local t_pos = t_cannon_base_node:convertToWorldSpace(r_pos);
        r_pos=cc.p(t_pos.x,t_pos.y);
	end
	return r_pos;
end

--local ccc_test_timer={[0]=10,10,10,10,10,10,10,10,10,10,10};
function   cannonmanager:SecTimer( dt)                                                                                  --秒表回调
  self.sec_timer=self.sec_timer+dt;
   if(self.sec_timer<1) then return ; end
    --
    self.sec_timer=self.sec_timer-1;
   local i=0; 
   for i=0,8,1 do       
        local t_cannon_base_node = self:getChildByTag(9999 + i);
		if (t_cannon_base_node) then
            --------------------------------------self.m_Broach_Delay
             if (self.m_Broach_Flag[i]>0) then
                self.m_Broach_Delay[i]=self.m_Broach_Delay[i]+1;
                if(self.m_Broach_FireFlag[i]>0) then
                   if(self.m_Broach_Delay[i]>10)then
                      self.m_Broach_Delay[i]=0;
                      cc.exports.game_manager_:SendUserFire(10, self:GetCurrentAngle(i), self.m_Dianci_BulletMul[i], -1,i);
                   end
                else
                  if(self.m_Broach_Delay[i]>20) then
                     self:Exit_Broach(i);
                   end
                end
             else --强制清空
                  local t_ui_Node = t_cannon_base_node:getChildByTag(88777 + i);
               	  if (t_ui_Node) then
                     t_ui_Node:removeFromParent();
		           end
             end
            -------------------------------

           -- self.m_Dianci_Delay
          	if (self.m_Dianci_CatchTimer[i] > 0)then
				self.m_Dianci_CatchTimer[i]=self.m_Dianci_CatchTimer[i]-1;
				if (self.m_Dianci_CatchTimer[i] <= 0)  	then  --//自动发射
					 if(self.m_Dianci_FireFlag[i]>0 and  self.m_Dianci_Flag[i]>0) then --//限时发射
                        --self:SendUserFire(self.current_bullet_kind_, angle,self.current_bullet_mulriple_, 0);
						cc.exports.game_manager_:SendUserFire(10, self:GetCurrentAngle(i), self.m_Dianci_BulletMul[i], -1,i);
					    t_cannon_base_node:removeChildByTag(61667 + i);
                     end
				else
					--//更新时间
                    if(self.m_Dianci_CatchTimer[i]>-100) then
					   local t_ccspr_xs =t_cannon_base_node:getChildByTag(61667 + i);
					   if (t_ccspr_xs)	then
                           self.m_Dianci_CatchTimer[i]=-100;
						   local t_cannon_mul_spr =t_ccspr_xs:getChildByTag(99);
						   if (t_cannon_mul_spr)	then
							   t_cannon_mul_spr:setString(self.m_Dianci_CatchTimer[i]);
						   end
					   end
                    end
				end
			end
            -----------------------------------美人鱼----------------

			if (self.m_MRY_catch_Flag[i]>0 and self.m_MRY_catch_Timer[i] > 0)	then
               -- cclog("  -----------------------------------美人鱼------------self.m_MRY_catch_Flag[i]=%d----self.m_MRY_catch_Timer[i]=%f",self.m_MRY_catch_Flag[i],self.m_MRY_catch_Timer[i]);
				self.m_MRY_catch_Timer[i]=self.m_MRY_catch_Timer[i]-1;
				if (self.m_MRY_catch_Timer[i] < 0) then self.m_MRY_catch_Timer[i] = 0; end
				self:Set_MRY_Time(i, self.m_MRY_catch_Timer[i]);

			end
           --------------------------------------------------------------------------------
           	if (self.m_FreeBullet_Flag[i]>0) then
					self.m_FreeBullet_Catch_Timer[i]=self.m_FreeBullet_Catch_Timer[i]-1;
					if (self.m_FreeBullet_Catch_Timer[i] <= 0) then
						self:Exit_FreeBullet(i);
					else
						local t_cannon_score_spr =t_cannon_base_node:getChildByTag(51557 + i);
						if (t_cannon_score_spr)	then
							local tem_free_numChar=string.format("00/%02d", self.m_FreeBullet_Catch_Timer[i]);
							t_cannon_score_spr:setString(tem_free_numChar);
						end
					end
			end
           --------------------------------------------------------------------------------
          if (self.m__InterlinkBomb_Flag[i]>0) then
             self.m__InterlinkBomb_Delay[i]=self.m__InterlinkBomb_Delay[i]+1;
             if(self.m__InterlinkBomb_Delay[i]>10) then
                 self:Exit_InterlinkBomb(i);
             end
          end
          ----------------------------------------------------------------------------------
          if(self.m_catch_ChainShell_Flag[i]>0) then
              self.m_catch_ChainShell_Timer[i]=self.m_catch_ChainShell_Timer[i]+1;
              if(self.m_catch_ChainShell_Timer[i]>15) then
                self:Catch_ChainShell_End(i,self.m_catch_ChainShell_score[i], self.m_catch_ChainShell_mul[i])
              end

            end
          --------------------------------------------------------------------------------
        end --if (t_cannon_base_node) then
   end--for
end

------------------------------------------------------------------------------------------------------------
------------------------------------------------------钻头弹------------------------------------------------------------------
function cannonmanager:Catch_Broach_Card( Alive_pos, alive_angle, chair_id,  mul,  catch_mul,  catch_score)--生成钻头炮
            self.m_Broach_Flag[chair_id] = 1;
             self.m_Broach_Delay[chair_id] = 0;
		    self.m_Broach_FireFlag[chair_id] = 1;
		    self.m_Broach_BulletMul[chair_id] = mul;        --//子弹倍数
		    self.m_Broach_CatchMul[chair_id] = 500;--// catch_mul;        //捕获倍数
		    self.m_Broach_CatchScore[chair_id] = catch_score;  --  //捕获分数
            --通知桌子生成钻头弹
		     local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
             if (t_cannon_base_node) then
                t_cannon_base_node:removeChildByTag(77777 + chair_id);
			    local t_cannon_base = cc.Sprite:createWithSpriteFrameName("~BroachCannonGunBase_000_000.png");
			    local t_cannon_top = cc.Sprite:createWithSpriteFrameName("~BroachCannonGunHead_000_000.png");
                if (t_cannon_base and t_cannon_top) then
					t_cannon_base:addChild(t_cannon_top,-1,99);
					t_cannon_top:setPosition(cc.p(40, 95));
			   end
               --原地 放大旋转回到对应玩家角度  移动到玩家炮塔  通知玩家激活穿甲炮   缩小
				t_cannon_base_node:addChild(t_cannon_base, 1111, 77777 + chair_id);
                local function _call_bakc__()
                   self:alive_Catch_Broach_Card_callback(chair_id)
              end
				local  t_end_pos = cc.p(20, 0);
				local  t__local_info_type =_local_info_array_[chair_id];
				t_cannon_base:setPosition(t_cannon_base_node:convertToNodeSpace(Alive_pos));
				t_cannon_base:setRotation(alive_angle);
				t_cannon_base:setAnchorPoint(cc.p(0.5, 0.2));
				local scaleto = cc.ScaleTo:create(0.5, 2);
				local rotateto = cc.RotateTo:create(0.5, self.current_angle_[chair_id] -t__local_info_type.default_angle);
				local moveTo = cc.MoveTo:create(0.5, t_end_pos);
				local funcall = cc.CallFunc:create(_call_bakc__);
				local scaleto1 = cc.ScaleTo:create(0.5, 1.0);
				local seq = cc.Sequence:create(scaleto, rotateto, moveTo, funcall, scaleto1, nil);
				t_cannon_base:runAction(seq);
             end -- if (t_cannon_base_node) then

end
function cannonmanager:alive_Catch_Broach_Card_callback( chair_id)
          local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
          if (t_cannon_base_node) then
                  local t__local_info_type = _local_info_array_[chair_id];
		          local  t_cannon_base =t_cannon_base_node:getChildByTag(77777 + chair_id);
		          local t_ui_Node = cc.Node:create();
		          t_cannon_base_node:addChild(t_ui_Node, 111, 88777 + chair_id);
	          	if (t_cannon_base) then
			         t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
		        end
                -------------钻头炮待播放特效
                local file_name ="";
			    local _sprite = nil;
		    	local readIndex = 0;
			    local animation = cc.Animation:create();
                local i=0;
			    for  i = 0,40, 1 do
                    file_name=string.format("BroachCannonReadyHead/~BroachCannonReadyHead_000_%03d.png", i);
				    local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then
						local offset_name=string.format("BroachCannonReadyHead_000_%03d.png", i);
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
					   if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					   readIndex=readIndex+1;
                       animation:addSpriteFrame(frame);
				 end
              end --for
             if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cannon_base:addChild(_sprite,-1);
		    	_sprite:setPosition(cc.p(39, 83));
			end

            --//添加提示
           local t_ccspr_ts = cc.Sprite:createWithSpriteFrameName("~BroachCannonTitle_000_000.png");
			if (t_ccspr_ts)then
				local tem_char=string.format("%d", self.m_Broach_BulletMul[chair_id]);
				local t__local_info_type = _local_info_array_[chair_id];
				local t_cannon_mul_spr = cc.LabelAtlas:_create(tem_char,"haiwang/res/HW/Json/Player/gunLevel.png", 22, 25,48);
				t_ui_Node:addChild(t_ccspr_ts, 11);
				t_ccspr_ts:setPosition(cc.p(0,160));
				if (t_cannon_mul_spr) then
					t_ccspr_ts:addChild(t_cannon_mul_spr,99);
					t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
					t_cannon_mul_spr:setScale(0.6);
					t_cannon_mul_spr:setPosition(cc.p(160, 130));
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_mul_spr:setRotation(0);                  
					else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
				end
				t_ccspr_ts:setScale(0.1);
				local t_CCScaleTo = cc.ScaleTo:create(0.3, 1);
				t_ccspr_ts:runAction(t_CCScaleTo);
			end
            --	//添加分数框
            local t_ccspr_scorebox = cc.Sprite:createWithSpriteFrameName("~BroachGainScore_000_000.png");
			if (t_ccspr_scorebox) then
				t_ui_Node:addChild(t_ccspr_scorebox, 11, 88777 + chair_id);
				t_ccspr_scorebox:setPosition(cc.p(150,30));
			end
            --//添加分数
            local t_cannon_score_spr = cc.LabelAtlas:create("0","haiwang/res/HW/Json/Player/ScoreNum.png", 46, 49, 48);
			if (t_cannon_score_spr) then
				t_cannon_score_spr:setAnchorPoint(cc.p(1, 0.5));
				if (t__local_info_type.sceore_angle == 180) then t_cannon_score_spr:setAnchorPoint(cc.p(0, 0.5)); end
				t_cannon_score_spr:setScale(0.3);
				t_ui_Node:addChild(t_cannon_score_spr, 18, 99777 + chair_id);
				--t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
                 if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_score_spr:setRotation(0);                  
					else t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle); end
				t_cannon_score_spr:setPosition(cc.p(174,18));
			end
            --隐藏炮塔
            local t_game_player =t_cannon_base_node:getChildByTag(6666);
		    if (t_game_player) then 	t_game_player:ShowCannon_(false);end
          end --if (t_cannon_base_node) then
end
function cannonmanager:AddBroach_Score( chair_id,  catch_score)
    if (self.m_Broach_Flag[chair_id]>0) then
		self.m_Broach_CatchScore[chair_id] = self.m_Broach_CatchScore[chair_id]+catch_score;
		self:Set_Broach_Score_Num(chair_id, self.m_Broach_CatchScore[chair_id]);
	end
end
function cannonmanager:Set_Broach_Score_Num( chair_id,  catch_score)--添加钻头炮中奖分
	if (self.m_Broach_Flag[chair_id]>0) then
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			local t_ui_Node = t_cannon_base_node:getChildByTag(88777 + chair_id);
			if (t_ui_Node) then
				local t_cannon_score_spr =t_ui_Node:getChildByTag(99777 + chair_id);
				if (t_cannon_score_spr) then 	t_cannon_score_spr:setString(catch_score);	end
			end
		end
	end
end

function cannonmanager:Exit_Broach( chair_id)--退出穿甲弹
   --cclog("cannonmanager:Exit_Broach( chair_id=%d)",chair_id);
    if (self.m_Broach_CatchScore[chair_id]>0) then cc.exports.g_BingoManager:AddBingo(chair_id, self.m_Broach_CatchScore[chair_id], 0); end
    self.m_Broach_Flag[chair_id] = 0;
	self.m_Broach_BulletMul[chair_id] = 0;        --//子弹倍数
	self.m_Broach_CatchMul[chair_id] = 0;        --//捕获倍数
	self.m_Broach_CatchScore[chair_id] = 0;    --//捕获分数
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
    if (t_cannon_base_node) then
        local t_ui_Node = t_cannon_base_node:getChildByTag(88777 + chair_id);
        local function __call_back()
                t_ui_Node:removeFromParent();
        end
      	if (t_ui_Node) then
				local t_CCDelayTime=cc.DelayTime:create(2.5);
				local t_callfunc = cc.CallFunc:create(__call_back);
				local t_seq = cc.Sequence:create(t_CCDelayTime, t_callfunc, nil);
				t_ui_Node:runAction(t_seq);
		end
        --显示炮塔
	    if (self.m_Dianci_Flag[chair_id] == 0
				and self.m_FreeBullet_Flag[chair_id] == 0
				and self.m_Broach_Flag[chair_id] == 0)
		then
				local t_game_player = t_cannon_base_node:getChildByTag(6666);
				if (t_game_player) then
					t_game_player:ShowCannon_(true);
				end
			end
    end
end
-----------------------------------------电磁炮--------------------------------------------------------------------------------------------------------------------------
function cannonmanager:Catch_DianCi_Card( Alive_pos,  alive_angle,  chair_id,  mul,  catch_mul,  catch_score)--生成电磁炮
       -- cclog(" cannonmanager:Catch_DianCi_Card 00 chair_id=%d",chair_id);
        cc.exports.g_soundManager:PlayGameEffect("DianCiPaoHit");
		self.m_Dianci_FireFlag[chair_id] = 1;
		self.m_Dianci_Flag[chair_id] = 1;
		self.m_Dianci_BulletMul[chair_id] = mul;       -- //子弹倍数
		self.m_Dianci_CatchMul[chair_id] = catch_mul;        --//捕获倍数
		self.m_Dianci_CatchScore[chair_id] = catch_score;   -- //捕获分数
		self.m_Dianci_CatchTimer[chair_id] = 9;
        local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			t_cannon_base_node:removeChildByTag(66667 + chair_id);
            local t_cannon_Node = cc.Node:create();
            t_cannon_base_node:addChild(t_cannon_Node, 1, 66667 + chair_id);
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
            -- cclog(" cannonmanager:Catch_DianCi_Card 01");
			for  i = 0,36, 1 do
				file_name=string.format("~DianCiPao_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						    local offset_name=string.format("DianCiPao_000_%03d.png", i);
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
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
				end
			end--for
            if (readIndex > 0)	then

			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cannon_Node:addChild(_sprite, 0, 10086);
		   end
           	local  t_end_pos = cc.p(20, 0);
            local function _dianci_call_back()
               self:alive_Catch_Dianci_Card_callback(chair_id);
            end
            t_cannon_Node:setPosition(t_cannon_base_node:convertToNodeSpace(Alive_pos));
			t_cannon_Node:setRotation(alive_angle);
			t_cannon_Node:setAnchorPoint(cc.p(0.5, 0.2));
            local t__local_info_type =_local_info_array_[chair_id];
			local scaleto =cc.ScaleTo:create(0.5, 2);
			local rotateto =cc.RotateTo:create(0.5, self.current_angle_[chair_id] - t__local_info_type.default_angle);
			local moveTo = cc.MoveTo:create(0.5, t_end_pos);
			local funcall = cc.CallFunc:create(_dianci_call_back);
			local scaleto1 = cc.ScaleTo:create(0.5, 1.0);
			local seq = cc.Sequence:create(scaleto, rotateto, moveTo, funcall, scaleto1, nil);
			t_cannon_Node:runAction(seq);
      end--if (t_cannon_base_node) then

end
function cannonmanager:alive_Catch_Dianci_Card_callback(chair_id)
     local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	 if (t_cannon_base_node) then
          local t__local_info_type = _local_info_array_[chair_id];
		  local t_ts_Node_ = cc.Node:create();
		  local t_cannon_base = t_cannon_base_node:getChildByTag(66667 + chair_id);
          t_cannon_base_node:removeChildByTag( 65667 + chair_id);
		  t_cannon_base_node:addChild(t_ts_Node_, 11, 65667 + chair_id);
          if (t_cannon_base) then
			   t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
            end
		--//添加提示
         local t_ccspr_ts = cc.Sprite:createWithSpriteFrameName("~CounterDownObj_000_000.png");
	  	 if (t_ccspr_ts) then
				local t_cannon_mul_spr = cc.LabelAtlas:_create(self.m_Dianci_BulletMul[chair_id],"haiwang/res/HW/Json/Player/gunLevel.png", 22, 25, 48);
				t_ts_Node_:addChild(t_ccspr_ts, 11);
				t_ccspr_ts:setPosition(cc.p(0, 170));
				if (t_cannon_mul_spr) then
					t_ccspr_ts:addChild(t_cannon_mul_spr);
					t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
					t_cannon_mul_spr:setScale(0.6);
					t_cannon_mul_spr:setPosition(cc.p(156, 125));
					local t__local_info_type = _local_info_array_[chair_id];
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_mul_spr:setRotation(0);
					else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
				end

				t_ccspr_ts:setScale(0.1);
				local t_CCScaleTo = cc.ScaleTo:create(0.3, 1);
			    t_ccspr_ts:runAction(t_CCScaleTo);
		  end --	if (t_ccspr_ts) then
          --显示碰撞框
          	local t_ccspr_hitts= cc.Sprite:create("haiwang/res/HW/DianCiPao/~DianCiPaoAttackRect_000_000.png");
			if (t_ccspr_hitts) then
				t_ccspr_hitts:setAnchorPoint(cc.p(0.5, 0));
				t_ccspr_hitts:setScaleX(2.5);
				t_ccspr_hitts:setScaleY(2.5);
				t_ccspr_hitts:setPosition(cc.p(0, 50));
				t_cannon_base:addChild(t_ccspr_hitts, -2,60677+chair_id);
			end
            --显示限时发射
           local t_ccspr_xs = cc.Sprite:create("haiwang/res/HW/DianCiPao/~CounterUpObj_000_000.png");
			if (t_ccspr_xs) then
				t_ccspr_xs:setPosition(cc.p(0, 90));
				t_ccspr_xs:setAnchorPoint(cc.p(0.5, 0.5));
                t_cannon_base_node:removeChildByTag(61667 + chair_id);
				t_cannon_base_node:addChild(t_ccspr_xs, 12, 61667 + chair_id);
				--限时发射时间
				local t_cannon_mul_spr = cc.LabelAtlas:create(self.m_Dianci_CatchTimer[chair_id],"haiwang/res/HW/DianCiPao/dianciFish_num.png", 67, 84, 48);
				if (t_cannon_mul_spr) then
						t_cannon_mul_spr:setScale(0.5);
						t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
						t_cannon_mul_spr:setPosition(cc.p(65, 0));
						local  t__local_info_type = _local_info_array_[chair_id];
						--t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle);
                        if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                           t_cannon_mul_spr:setRotation(0);
					   else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
						t_ccspr_xs:addChild(t_cannon_mul_spr, 12, 99);

				end
                local function call_back__()
                   t_ccspr_xs:removeFromParent();
                end
                local t_delay=cc.DelayTime:create(self.m_Dianci_CatchTimer[chair_id]+2);
                local t_remov_call=cc.CallFunc:create(call_back__);
                local t_seq=cc.Sequence:create(t_delay,t_remov_call,nil);
                t_ccspr_xs:runAction(t_seq);
			end --if (t_ccspr_xs) then
            --隐藏炮塔
            local t_game_player =t_cannon_base_node:getChildByTag(6666);
		   if (t_game_player) then
			t_game_player:ShowCannon_(false);
		end
     end --	if (t_cannon_base_node) then
end
function cannonmanager:Play_dianci_Fire( chair_id)
    --//播放发射动画

	local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
            cc.exports.g_soundManager:PlayGameEffect("DianCiPaoFire");
	    	t_cannon_base_node:removeChildByTag(66667 + chair_id);
            local t_cannon_Node =cc.Node:create();
	     	t_cannon_base_node:addChild(t_cannon_Node, 1, 66667 + chair_id);
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,30, 1 do
				file_name=string.format("~DianCiPao_001_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
					    	local offset_name=string.format("DianCiPao_001_%03d.png", i);
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
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
				end
			end --for
            if (readIndex > 0)	then
                 local function call_back__()
                    self:fire_Catch_Dianci_Card_callback(chair_id);
                 end
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  --_sprite:runAction(cc.RepeatForever:create(action));
                  local t_CCRepeatForever = cc.Repeat:create(action, 1);
			      local funcall = cc.CallFunc:create(call_back__);
			      local t_CCSequence = cc.Sequence:create(t_CCRepeatForever, funcall, nil);
			      --local t_fade_out = cc.FadeOut:create(0.1);
                  _sprite:runAction(t_CCSequence);
                 t_cannon_Node:addChild(_sprite, 0, 10086);
                 local  t_end_pos = cc.p(20, 0);
		         local t__local_info_type = _local_info_array_[chair_id];
		         t_cannon_Node:setPosition(t_end_pos);
		         t_cannon_Node:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
		   end
    end
end
function cannonmanager:fire_Catch_Dianci_Card_callback(chair_id)
        --显示炮塔
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			 local t_game_player =t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then
				t_game_player:ShowCannon_(false);
			end
		end
end
function cannonmanager:Exit_Dianci( chair_id)--退出穿甲弹
   --if (self.m_Dianci_Flag[chair_id]>0)then
		self.m_Dianci_FireFlag[chair_id] = 0;
		self.m_Dianci_Flag[chair_id] = 0;
		self.m_Dianci_BulletMul[chair_id] = 0;       -- //子弹倍数
		self.m_Dianci_CatchMul[chair_id] = 0;       -- //捕获倍数
		self.m_Dianci_CatchScore[chair_id] = 0;    --//捕获分数
		self.m_Dianci_CatchTimer[chair_id] = 0;
	--end
    local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
        t_cannon_base_node:removeChildByTag(66667 + chair_id);
        local t_cannon_Node = t_cannon_base_node:getChildByTag( 65667 + chair_id);
        if (t_cannon_Node) then
            local function call_back__()
                 t_cannon_Node:removeFromParent();
           end
			local t_CCDelayTime=cc.DelayTime:create(1);
			local t_callfunc = cc.CallFunc:create(call_back__);
			local t_seq=cc.Sequence:create(t_CCDelayTime, t_callfunc, nil);
			t_cannon_Node:runAction(t_seq);
		end
        --显示炮塔
		if (self.m_Dianci_Flag[chair_id] == 0
			and self.m_FreeBullet_Flag[chair_id] == 0
			and self.m_Broach_Flag[chair_id]==0)
		then
			 local t_game_player = t_cannon_base_node:getChildByTag(6666);
			 if (t_game_player) then
				t_game_player:ShowCannon_(true);
			end
		end
    end
end
function cannonmanager:DianciDelayCheck( chair_id)
	if (self.m_Dianci_Flag[chair_id] and self.m_Dianci_FireFlag[chair_id] and self.m_Dianci_CatchTimer[chair_id] > 0) then return 1;
	else return 0; end
end

----------------------------------------免费子弹----------------------------------------
function cannonmanager:Catch_FreeBullet_Card( Alive_pos,  alive_angle,  chair_id,  mul,  catch_mul,  catch_score)--生成免费子弹
       -- cclog("cannonmanager:Catch_FreeBullet_Card( Alive_pos(%f,%f),  alive_angle(%f),  chair_id(%d),  mu(%d)l,  catch_mul(%d),  catch_score(%d))......................................................",
       -- Alive_pos.x,Alive_pos.y,alive_angle,chair_id,mul,catch_mul,catch_score);
		self.m_FreeBullet_Catch_Timer[chair_id] = 30;
		self.m_FreeBullet_Catch_Score[chair_id] = 0;
		self.m_FreeBullet_Mul[chair_id] = mul;        --//子弹倍数
        --self.m_FreeBullet_Delay[chair_id] = 0;
		if (self.m_FreeBullet_Flag[chair_id]>0) then      --//已经免费子弹状态
			self.m_FreeBullet_Flag[chair_id] = 1;
			return;
		end
		self.m_FreeBullet_Flag[chair_id] = 1;
        local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
                t_cannon_base_node:removeChildByTag(55557 + chair_id);
                local t_cannon_Node = cc.Node:create();
		    	t_cannon_base_node:addChild(t_cannon_Node, 1, 55557 + chair_id);
                local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame("~FreeFireGun_000_000.png");
--                 local offset_name="FreeFireGun_000_000.png";
--				 local t_offset_ = cc.p(0, 0);
--                 local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
--                 local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
--                 local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
--                 local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
--                 local t_offeset_pos=cc.p(0,0);
--                 local t_offset_0 = frame:getOffsetInPixels();
--                 t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
--		 	     t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;
--                 frame:setOffsetInPixels(t_offset_);
                 --frame:setOffsetInPixels(cc.p(2.5/2,-61.0/2));
                 local _sprite=cc.Sprite:createWithSpriteFrame(frame) ;
                 _sprite:setAnchorPoint(cc.p(0.5, 0.2));
                 t_cannon_Node:addChild(_sprite, 0, 10086);
                 t_cannon_Node:setPosition(t_cannon_base_node:convertToNodeSpace(Alive_pos));
			    t_cannon_Node:setRotation(alive_angle);
			    t_cannon_Node:setAnchorPoint(cc.p(0.5, 0.5));

               local function call_back__()
                  self:alive_Catch_FreeBullet_Card_callback(chair_id);
               end
               local  t_end_pos = cc.p(20, 0);
               local t__local_info_type = _local_info_array_[chair_id];
               local  scaleto = cc.ScaleTo:create(0.2, 2);
			   local  rotateto = cc.RotateTo:create(0.2, self.current_angle_[chair_id] - t__local_info_type.default_angle);
			   local  moveTo = cc.MoveTo:create(0.5, t_end_pos);
			   local  funcall = cc.CallFunc:create(call_back__);
			   local   scaleto1 = cc.ScaleTo:create(0.5, 1.4);
			   local  seq = cc.Sequence:create(scaleto, rotateto, moveTo, funcall, scaleto1, nil);
			   t_cannon_Node:runAction(seq);
             -- cclog("cannonmanager:Catch_FreeBullet_Card( Alive_pos,  alive_angle,  chair_id(%d),  mul,  catch_mul,  catch_score)333",chair_id);
        end --	if (t_cannon_base_node) then
end
function cannonmanager:alive_Catch_FreeBullet_Card_callback(chair_id)

     local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
     if (t_cannon_base_node) then
         local t__local_info_type = _local_info_array_[chair_id];
        local t_ts_Node_ = cc.Node:create();
		local t_cannon_base = t_cannon_base_node:getChildByTag(55557 + chair_id);
        t_cannon_base_node:removeChildByTag(54557 + chair_id);
		t_cannon_base_node:addChild(t_ts_Node_, 11, 54557 + chair_id);
        if (t_cannon_base) then
			t_cannon_base:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
		end -- if (t_cannon_base) then
        --//添加提示

        	local t_ccspr_ts = cc.Sprite:createWithSpriteFrameName("~FreeFireLogo_000_000.png");
			if (t_ccspr_ts) then
                --cclog("self.m_FreeBullet_Mul[chair_id=%d]=..................................................",chair_id);
                --cclog("self.m_FreeBullet_Mul[chair_id]=%d..................................................",self.m_FreeBullet_Mul[chair_id]);
				local t_cannon_mul_spr = cc.LabelAtlas:create(self.m_FreeBullet_Mul[chair_id],"haiwang/res/HW/Json/Player/gunLevel.png", 22, 25, 48);
				t_ts_Node_:addChild(t_ccspr_ts, 11);
				t_ccspr_ts:setPosition(cc.p(0, 170));
				if (t_cannon_mul_spr)then
					t_ccspr_ts:addChild(t_cannon_mul_spr,11);
					t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
					t_cannon_mul_spr:setScale(0.8);
					t_cannon_mul_spr:setPosition(cc.p(100,70));
					local  t__local_info_type = _local_info_array_[chair_id];
					--t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle);
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                           t_cannon_mul_spr:setRotation(0);
					else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
				end

                --]]
				--t_ccspr_ts:setScale(0.1);
				--local t_CCScaleTo = cc.ScaleTo:create(0.3, 1);
				--t_ccspr_ts:runAction(t_CCScaleTo);
			end --if (t_ccspr_ts) then
           --- //添加分数框
            local t_ccspr_scorebox = cc.Sprite:createWithSpriteFrameName("~FreeFireGainScore_000_000.png");
			if (t_ccspr_scorebox)	then
                 t_cannon_base_node:removeChildByTag(53557 + chair_id);
				t_cannon_base_node:addChild(t_ccspr_scorebox, 11, 53557 + chair_id);
				t_ccspr_scorebox:setPosition(cc.p(150, 30));
				t_ccspr_scorebox:setScale(1.5);
			end
            --//添加分数
            local t_cannon_score_spr = cc.LabelAtlas:_create("0","haiwang/res/HW/Json/Player/ScoreNum.png", 46, 49, 48);
			if (t_cannon_score_spr)	then
				local  t__local_info_type = _local_info_array_[chair_id];
				t_cannon_score_spr:setAnchorPoint(cc.p(1, 0.5));
				if (t__local_info_type.sceore_angle == 180) then t_cannon_score_spr:setAnchorPoint(cc.p(0.0, 0.5)); end
				t_cannon_score_spr:setScale(0.3);
                t_cannon_base_node:removeChildByTag(52557 + chair_id);
				t_cannon_base_node:addChild(t_cannon_score_spr, 11, 52557 + chair_id);
				t_cannon_score_spr:setPosition(cc.p(200, 30));
                if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                          t_cannon_score_spr:setRotation(0);
			    else t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle); end
				--t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
			end
            --//添加剩余子弹数
            tem_free_numChar=string.format("00/%02d", self.m_FreeBullet_Catch_Timer[chair_id]);
            local t_cannon_score_spr = cc.LabelAtlas:create(tem_free_numChar,"haiwang/res/HW/GuidedMissileNum.png", 35, 44, 47);
			if (t_cannon_score_spr) then
				local t__local_info_type = _local_info_array_[chair_id];
				t_cannon_score_spr:setAnchorPoint(cc.p(1, 0.5));
				if (t__local_info_type.sceore_angle == 180) then t_cannon_score_spr:setAnchorPoint(cc.p(0.0, 0.5)); end
				t_cannon_score_spr:setScale(0.3);
                t_cannon_base_node:removeChildByTag(51557 + chair_id);
				t_cannon_base_node:addChild(t_cannon_score_spr, 11, 51557 + chair_id);
				t_cannon_score_spr:setPosition(cc.p(200, 50));
				--t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
                if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                          t_cannon_score_spr:setRotation(0);
			    else t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle); end
			end
            --//播放开始动画
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,27, 1 do
				file_name=string.format("~FreeFireStartHint_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
					    	local offset_name=string.format("FreeFireStartHint_000_%03d.png", i);
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
					      if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					      readIndex=readIndex+1;
                          animation:addSpriteFrame(frame);
				end
			end --for
		    animation:setDelayPerUnit(1/12.0);
	        local action =cc.Animate:create(animation);
             -------------------------------------------------------------------------------------
			local animation1 = cc.Animation:create();
           	for  i = 0,27, 1 do
                file_name=string.format("~FreeFireStartHint_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
					    	local offset_name=string.format("FreeFireStartHint_000_%03d.png", i);
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
                          animation1:addSpriteFrame(frame);
				end
            end --for
            animation1:setDelayPerUnit(1/24.0);
	        local action1 =cc.Animate:create(animation1);
            local t_CCFadeIn = cc.FadeIn:create(0.2);
			local t_CCRepeat = cc.Repeat:create(action, 1);
			local t_CCRepeat1 = cc.Repeat:create(action1, 1);
			local t_CCSequence = cc.Sequence:create(t_CCFadeIn, t_CCRepeat1, t_CCRepeat, nil);
			_sprite:runAction(t_CCSequence);
			_sprite:setPosition(cc.p(20, 0));
			t_ts_Node_:addChild(_sprite, 111);
            --//隐藏炮塔
		   local t_game_player =t_cannon_base_node:getChildByTag(6666);
		  if (t_game_player) then 	t_game_player:ShowCannon_(false); end
     end --  if (t_cannon_base_node) then

end
function cannonmanager:Play_FreeBullet_Fire( chair_id)
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       	--隐藏炮塔
		local t_game_player =t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then
			t_game_player:ShowCannon_(false);
		end
        cc.exports.g_soundManager:PlayGameEffect("FreeFireShoot");
        t_cannon_base_node:removeChildByTag(55557 + chair_id);
		local t_cannon_Node = cc.Node:create();
		t_cannon_base_node:addChild(t_cannon_Node, 1, 55557 + chair_id);
        local file_name ="";
		local _sprite = nil;
		local readIndex = 0;
		local animation = cc.Animation:create();
        local i=0;
	    for  i = 0,10, 1 do
				file_name=string.format("~FreeFireGun_001_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
--						if (cc.exports.FreeFireGun_001_<1) then
--                           local offset_name=string.format("FreeFireGun_001_%03d.png", i);
--							local t_offset_ = cc.p(0, 0);
--                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
--                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
--                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
--                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
--                            local t_offeset_pos=cc.p(0,0);
--                            local t_offset_0 = frame:getOffsetInPixels();
--                            t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
--		 	               t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;
--                           frame:setOffsetInPixels(t_offset_);
--					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
				end
			end --for
             if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.Repeat:create(action,1));
                 _sprite:setScale(1.2);
                  --self:addChild(_sprite, 0, 10086);
                  _sprite:setAnchorPoint(cc.p(0.5, 0.2));
			       t_cannon_Node:addChild(_sprite, 0, 10086);
		   end
           local  t_end_pos = cc.p(20, 0);
		  local t__local_info_type = _local_info_array_[chair_id];
	  	  t_cannon_Node:setPosition(t_end_pos);
		  t_cannon_Node:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);
    end
end
function cannonmanager:Add_FreeBulletCatch( chair_id, score)
     if (self.m_FreeBullet_Flag[chair_id]) then
		self.m_FreeBullet_Catch_Score[chair_id] =self.m_FreeBullet_Catch_Score[chair_id] +score;
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			local t_cannon_score_spr =t_cannon_base_node:getChildByTag(52557 + chair_id);
			if (t_cannon_score_spr) then
				t_cannon_score_spr:setString(self.m_FreeBullet_Catch_Score[chair_id]);
			end
		end
	end
end
function cannonmanager:Exit_FreeBullet( chair_id)--退出免费子弹
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	 cc.exports.g_soundManager:PlayGameEffect("FreeFireEnd");
	if (t_cannon_base_node)then
		t_cannon_base_node:removeChildByTag(55557 + chair_id);
		t_cannon_base_node:removeChildByTag(54557 + chair_id);
		t_cannon_base_node:removeChildByTag(53557 + chair_id);
		t_cannon_base_node:removeChildByTag(52557 + chair_id);
		t_cannon_base_node:removeChildByTag(51557 + chair_id);
	end
    self.m_FreeBullet_Flag[chair_id] = 0;
	self.m_FreeBullet_Catch_Timer[chair_id] = 0;
	self.m_FreeBullet_Catch_Score[chair_id] = 0;
	self.m_FreeBullet_Mul[chair_id] = 0;               --//子弹倍数
    --//显示炮塔
	if (self.m_Dianci_Flag[chair_id] == 0 and self.m_Broach_Flag[chair_id] == 0)	then
		local t_game_player = t_cannon_base_node:getChildByTag(6666);
		if (t_game_player)	then
			t_game_player:ShowCannon_(true);
		end
	end
end
function cannonmanager:GetFreeFirePos( chair_id)
    local t_ccp_=self:GetCannonPos(chair_id,1);--cc.p(0, 0);
	--local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	--if (t_cannon_base_node) then
		--local t_angle =  math.rad(self.current_angle_[chair_id]);
        --local x,y=t_cannon_base_node:getPosition();
	    --t_ccp_ = cc.p(x,y);
     --   t_ccp_.x =t_ccp_.x +12;
		--t_ccp_.x = t_ccp_.x+115 * math.sin(t_angle);
		--t_ccp_.y = t_ccp_.y+115 * math.cos(t_angle);
	--end
	return t_ccp_;
end
----------------------------------------必杀子弹----------------------------------------
function cannonmanager:Catch_GuidedMissile_Card( Alive_pos,  alive_angle,  chair_id,  mul,  catch_mul,  catch_score)--生成免费子弹
        self.m_GuidedMissile_FireFlag[chair_id] = 1;
		self.m_GuidedMissile_Flag[chair_id] = 1;
		self.m_GuidedMissile_Mul[chair_id] = mul;                        --//子弹倍数
		self.m_GuidedMissile_CatchMul[chair_id] = catch_mul;     --//子弹总数
		self.m_GuidedMissile_CatchScore[chair_id] = catch_score;--//子弹总数
		self.m_GuidedMissile_Timer[chair_id] = 30;
        local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
           t_cannon_base_node:removeChildByTag(44447 + chair_id);
           --播放必杀特效
           local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,22, 1 do
				file_name=string.format("~FistEff_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						local offset_name=string.format("FistEff_000_%03d.png", i);
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
                 local function call_back__()
                    self:alive_Catch_GuidedMissile_Card_callback(chair_id);
                 end
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);
				  --_sprite:runAction(cc.RepeatForever:create(action));
                 -- self:addChild(_sprite, 0, 10086);
                 local t_CCRepeat = cc.Repeat:create(action, 1);
				 local t_CCFadeOut = cc.FadeOut:create(0.2);
				 local funcall = cc.CallFunc:create(call_back__);
			 	local  t_CCSequence = cc.Sequence:create(t_CCRepeat, t_CCFadeOut, funcall, nil);
                _sprite:runAction(t_CCSequence);
                local  t__local_info_type = _local_info_array_[chair_id];
				t_cannon_base_node:addChild(_sprite,11, 44447 + chair_id);
                if(t__local_info_type.default_angle==90 or t__local_info_type.default_angle==-90) then 
                      _sprite:setRotation(0);
				else _sprite:setRotation(t__local_info_type.default_angle); end
				_sprite:setPosition(cc.p(0, 100));
		   end
		end
end
function cannonmanager:alive_Catch_GuidedMissile_Card_callback( chair_id)
    local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
        t_cannon_base_node:removeChildByTag(44447 + chair_id);
        local t__local_info_type = _local_info_array_[chair_id];
		local t_ts_Node_ = cc.Node:create();
		t_cannon_base_node:addChild(t_ts_Node_, 11, 44447 + chair_id);
        --添加提示
        local t_ccspr_ts = cc.Sprite:createWithSpriteFrameName("~FistUI_000_000.png");
		if (t_ccspr_ts)	then
				local t_cannon_mul_spr = cc.LabelAtlas:_create(self.m_GuidedMissile_Mul[chair_id],"haiwang/res/HW/GuidedMissileNum.png", 35, 44, 47);
				t_ts_Node_:addChild(t_ccspr_ts, 11);
				t_ccspr_ts:setPosition(cc.p(0, 170));
				if (t_cannon_mul_spr)then
					t_ccspr_ts:addChild(t_cannon_mul_spr, 11);
					t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
					t_cannon_mul_spr:setScale(0.7);
					t_cannon_mul_spr:setPosition(cc.p(88, 44));
					local t__local_info_type = _local_info_array_[chair_id];
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                       t_cannon_mul_spr:setRotation(0);
			       else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
					--t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle);
					t_ccspr_ts:setScale(0.1);
                    local function removecall_back__()
                         t_ts_Node_:removeFromParent();
                    end
					local t_CCScaleTo = cc.ScaleTo:create(0.3, 1);
                    local t_delay=cc.DelayTime:create(5);
                    local t_call_remov=cc.CallFunc:create(removecall_back__);
                    local t_seq = CCSequence:create(t_CCScaleTo,t_delay, t_call_remov, nil);
					t_ccspr_ts:runAction(t_seq);
				end
		end
    end --if (t_cannon_base_node) then

end
function cannonmanager:Exit_GuidedMissileBullet( chair_id)--退出必杀子弹
	self.m_GuidedMissile_Flag[chair_id] = 0;
	self.m_GuidedMissile_Mul[chair_id] = 0;                      --  //子弹倍数
	self.m_GuidedMissile_CatchMul[chair_id] = 0;     --//子弹总数
	self.m_GuidedMissile_CatchScore[chair_id] = 0;--//子弹总数
	local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node)	then
		local t_ts_Node_ = t_cannon_base_node:getChildByTag(44447 + chair_id);
		if (t_ts_Node_)	then
            local function call_back__()
               t_ts_Node_:removeFromParent();
            end
			local t_CCDelayTime=cc.DelayTime:create(2.0);
			local t_callfunc = cc.CallFunc:create(call_back__);
			local t_seq = CCSequence:create(t_CCDelayTime, t_callfunc, nil);
			t_ts_Node_:runAction(t_seq);
		end
	end
end
function cannonmanager:GetGuideMissileState( chair_id)
    return self.m_GuidedMissile_Flag[chair_id];
end
----------------------------------------连环炸蟹----------------------------------------
function cannonmanager:Catch_InterlinkBomb_( chair_id,  score,  bulet_mul)                              --捕获连环炸蟹

     --cclog("cannonmanager:Catch_InterlinkBomb_( chair_id=%d,  score=%d,  bulet_mul=%d)",chair_id,score,bulet_mul);
     self.m__InterlinkBomb_Score[chair_id] = 0;
     self.m__InterlinkBomb_Flag[chair_id] = 1;
     self.m__InterlinkBomb_Delay[chair_id] = 0;
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node)then
        local t__local_info_type = _local_info_array_[chair_id];
		local t_ccnode = cc.Node:create();
		t_cannon_base_node:removeChildByTag(953711 + chair_id);
		t_cannon_base_node:addChild(t_ccnode, 111, 953711 + chair_id);
        -- cclog("cannonmanager:Catch_InterlinkBomb_( chair_id=%d,  score=%d,  bulet_mul=%d) aaaaaaaaa",chair_id,score,bulet_mul);

        --//添加提示
		if (t_ccnode) then
              local function t_remov_callback()
                  t_ccnode:removeFromParent(1);
              end
              local t_delay=cc.DelayTime:create(20);
              local t_remov_action=cc.CallFunc:create(t_remov_callback);
              local t_seq=cc.Sequence:create(t_delay,t_remov_action,nil);
              t_ccnode:runAction(t_seq);
                                                               -- haiwang\res\HW\InterlinkBombCrab
			  local t_ccspr_ts = cc.Sprite:create("haiwang/res/HW/InterlinkBombCrab/~InterlinkBombCrabHint_000_000.png");
			  if (t_ccspr_ts) then
                  	t_ccnode:addChild(t_ccspr_ts, 11,1);
			    	t_ccspr_ts:setPosition(cc.p(0, 160));
                    local t_cannon_mul_spr = cc.LabelAtlas:create(bulet_mul,"haiwang/res/HW/Json/Player/gunLevel.png", 22, 25, 48);
                    if (t_cannon_mul_spr)then
						t_ccspr_ts:addChild(t_cannon_mul_spr);
						t_cannon_mul_spr:setAnchorPoint(cc.p(0.5, 0.5));
						t_cannon_mul_spr:setScale(0.6);
						t_cannon_mul_spr:setPosition(cc.p(162, 115));
                        if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                           t_cannon_mul_spr:setRotation(0);
			            else t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle); end
						--t_cannon_mul_spr:setRotation(t__local_info_type.sceore_angle);
					end
                    t_ccspr_ts:setScale(0.1);
					local t_CCScaleTo = cc.ScaleTo:create(0.3, 1);
					t_ccspr_ts:runAction(t_CCScaleTo);

              end
        end --	if (t_ccnode) then
        --添加分数框 和分数
        local t_ccspr_scorebox = cc.Sprite:create("haiwang/res/HW/InterlinkBombCrab/~InterlinkBombCrabUIKuang_000_000.png");
        if (t_ccspr_scorebox) then
            t_ccnode:addChild(t_ccspr_scorebox, 11,88);
			t_ccspr_scorebox:setPosition(cc.p(150, 30));
            local t_cannon_score_spr = cc.LabelAtlas:_create(score,"haiwang/res/HW/InterlinkBombCrab/InterlinkBombNum.png", 27, 31, 48);
		    if (t_cannon_score_spr) then
						t_cannon_score_spr:setScale(0.5);
						t_cannon_score_spr:setAnchorPoint(cc.p(1, 0.5));
						t_ccspr_scorebox:addChild(t_cannon_score_spr, 1111,99);
						t_cannon_score_spr:setPosition(cc.p(80, 18));
                        if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                           t_cannon_score_spr:setRotation(0);	
                           t_cannon_score_spr:setAnchorPoint(cc.p(0, 0.5));		            
						else
							t_cannon_score_spr:setAnchorPoint(cc.p(0, 0.5));
							t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
						end
			end
        end

        --
    end  --if (t_cannon_base_node)then
end

function cannonmanager:Add_InterlinkBomb_Score( chair_id,  score)                                          --更新连环炸蟹UI分数
   self.m__InterlinkBomb_Score[chair_id] = self.m__InterlinkBomb_Score[chair_id]+score;
	self:Set_InterlinkBomb_Score(chair_id, self.m__InterlinkBomb_Score[chair_id]);
end
function cannonmanager:Set_InterlinkBomb_Score( chair_id,  score)                                           --更新连环炸蟹UI分数
    --cclog("cannonmanager:Set_InterlinkBomb_Score( chair_id=%d,  score=%d)",chair_id,score);
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
    --local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
		local t_ccnode =t_cannon_base_node:getChildByTag(953711 + chair_id);
		if (t_cannon_base_node) then
			local t_ccspr_scorebox =t_ccnode:getChildByTag(88);
			local t_cannon_score_spr =t_ccspr_scorebox:getChildByTag(99);
			if (t_cannon_score_spr) then
				t_cannon_score_spr:setString(score);
			end
		end
	end--if (t_cannon_base_node) then
end
function cannonmanager:Exit_InterlinkBomb( chair_id)                                                                  --更新连环炸蟹UI分数
   	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
		if (self.m__InterlinkBomb_Score[chair_id]>0) then cc.exports.g_BingoManager:AddBingo(chair_id, self.m__InterlinkBomb_Score[chair_id], 0); end
		self.m__InterlinkBomb_Score[chair_id] = 0;
        self.m__InterlinkBomb_Flag[chair_id] = 0;
        self.m__InterlinkBomb_Delay[chair_id] = 0;
		local t_ccnode = t_cannon_base_node:getChildByTag(953711 + chair_id);
		if (t_ccnode) then
            local function call_back___()
               t_ccnode:removeFromParent();
           end
			local t_CCDelayTime=cc.DelayTime:create(2.5);
			local  t_callfunc = cc.CallFunc:create(call_back___);
			local  t_seq = cc.Sequence:create(t_CCDelayTime, t_callfunc, nil);
			t_ccnode:runAction(t_seq);
		end
	end
end

----------------------------------------美人鱼----------------------------------------
function cannonmanager:Set_MRY_Time( chair_id,  time)--设置美人鱼剩余时间
    --cclog("cannonmanager:Set_MRY_Time %d,flag=%d",time,self.m_MRY_catch_Flag[chair_id])
	if (self.m_MRY_catch_Flag[chair_id]>0) then
		if (time <=self.m_MRY_catch_Timer[chair_id])	then
			self.m_MRY_catch_Timer[chair_id] = time;
             --cclog("cannonmanager:Set_MRY_Time %daaaaaaaa",time)
			--时间
			local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
				local t_ccnode = t_cannon_base_node:getChildByTag(3333311 + chair_id);
				if (t_ccnode) then
					local t_score_box = t_ccnode:getChildByTag(99);
					if (t_score_box) then
						local t_Win_score_spr =t_score_box:getChildByTag(1222);
						if (t_Win_score_spr) then
                        -- cclog("cannonmanager:Set_MRY_Time %d bbbb",time)
							local tem_score_char=string.format("00/%02d", self.m_MRY_catch_Timer[chair_id]);
							t_Win_score_spr:setString(tem_score_char);
						end
					end
				end --if (t_cannon_base_node)
			end
		end --time
        if (self.m_MRY_catch_Timer[chair_id] == 0) then
				self:Catch_MRY_End(chair_id);
		end
	end --flag
end
function cannonmanager:Catch_MRYCarb( chair_id,  fishID, alivePos,  score,  mul_num)--捕获美人鱼

        self.m_MRY_catch_Flag[chair_id]=1;     --//捕获美人鱼标记
		self.m_MRY_catch_Mul[chair_id] = mul_num;      --//捕获美人鱼倍数
		self.m_MRY_catch_Score[chair_id]=0;    --//捕获美人鱼分数
		self.m_MRY_catch_Timer[chair_id]=30;    --//捕获美人鱼剩余时间
		self.m_MRY_Fish_ID[chair_id] = fishID;
        local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
            local t__local_info_type = _local_info_array_[chair_id];
			local t_ccnode = cc.Node:create();
			t_cannon_base_node:removeChildByTag(3333311 + chair_id);
			t_cannon_base_node:addChild(t_ccnode, 1111, 3333311 + chair_id);
            if (t_ccnode) then
               alivePos = t_cannon_base_node:convertToNodeSpace(alivePos);
               	t_ccnode:setPosition(alivePos);
               --
                local t_score_box = cc.Sprite:create("haiwang/res/HW/MryJumpScore/~MryJumpScore_000_000.png");--//生成
                if(t_score_box) then
                       if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                             t_score_box:setRotation(0);
				        else t_score_box:setRotation(t__local_info_type.sceore_angle); end
                       t_ccnode:addChild(t_score_box, 0, 99);
                       --添加分数
                       	tem_score_char=string.format(":%d", self.m_MRY_catch_Score[chair_id]);
						local t_Win_score_spr = cc.LabelAtlas:_create(tem_score_char,"haiwang/res/HW/MryJumpScore/JumScoreNum.png", 28, 30,48);
						if (t_Win_score_spr) then
							t_Win_score_spr:setAnchorPoint(cc.p(1, 0.5));
							t_Win_score_spr:setScale(0.8);
							t_score_box:addChild(t_Win_score_spr, 2, 99);
							t_Win_score_spr:setPosition(cc.p(165, 55));
						end
                        --添加剩余时间
                        tem_score_char=string.format("00/%02d", self.m_MRY_catch_Timer[chair_id]);
						local t_Win_time_spr =cc.LabelAtlas:_create(tem_score_char,"haiwang/res/HW/GuidedMissileNum.png", 35, 44, 47);
						if (t_Win_time_spr) then
							t_Win_time_spr:setAnchorPoint(cc.p(1, 0.5));
							t_Win_time_spr:setScale(0.6);
							t_score_box:addChild(t_Win_time_spr, 2, 1222);
							t_Win_time_spr:setPosition(cc.p(165, 90));
						end
                         local t_ccmovto = cc.MoveTo:create(1.5, cc.p(0, 120));
				         t_ccnode:runAction(t_ccmovto);
                end --if(t_score_box) then
            end --if (t_ccnode) then
        end --if (t_cannon_base_node) then
end
function cannonmanager:Add_MRY_Score( chair_id,  score)                                                    --更新美人鱼分数
        if (self.m_MRY_catch_Flag[chair_id])then
		       local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		       if (t_cannon_base_node  and score > 0) then
                 	  self.m_MRY_catch_Score[chair_id] =self.m_MRY_catch_Score[chair_id] +score;
                       local t_ccnode = t_cannon_base_node:getChildByTag(3333311 + chair_id);
			     	   if (t_ccnode) then
                           	local t_score_box = t_ccnode:getChildByTag(99);
				        	if (t_score_box) then
                                   local t_Win_score_spr =t_score_box:getChildByTag(99);
						          if (t_Win_score_spr) then
						            	local score_charstr=string.format(":%d", self.m_MRY_catch_Score[chair_id]);
						            	t_Win_score_spr:setString(score_charstr);
						       end--_spr
					        end --box
				      end --if (t_ccnode) then
                end
        end; --   if (self.m_MRY_catch_Flag[chair_id])then
end
function cannonmanager:Catch_MRY_End( chair_id) --捕获美人鱼

     if (self.m_MRY_catch_Flag[chair_id]>0) then
       local t_fish =cc.exports.g_pFishGroup:GetFish(self.m_MRY_Fish_ID[chair_id]);
       if (t_fish) then 	t_fish:CatchEnd(); end
    end
    if (self.m_MRY_catch_Flag[chair_id]>0) then
        self.m_MRY_catch_Flag[chair_id]=0;
        cc.exports.g_soundManager:PlayGameEffect("ScoreJumpEnd");
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		 if (t_cannon_base_node) then
           	local t__local_info_type =_local_info_array_[chair_id];
			local t_ccnode = cc.Node:create();
			t_cannon_base_node:removeChildByTag(3333311 + chair_id);
			t_cannon_base_node:addChild(t_ccnode, 111, 3333311 + chair_id);
			t_ccnode:setPosition(cc.p(0, 120));
            --------------------------------------------------------------------------
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
                end--if frame
            end--end for
            if (readIndex > 0) then
                     cc.exports.JumpScoreBG_=1;
					local t_run_time = 48 / readIndex;
					if (t_run_time < 1) then t_run_time = 1; end
                    animation:setDelayPerUnit(1/24.0);
                    local action =cc.Animate:create(animation);
                    --local action =cc.Animate:create(animation);
			    	_sprite:runAction(cc.RepeatForever:create(action));
					_sprite:setScale(2);
					t_ccnode:addChild(_sprite);
			end
            --添加分数
            local t_Win_score_spr = cc.LabelAtlas:_create(self.m_MRY_catch_Score[chair_id],"haiwang/res/HW/MryJumpScore/JumScoreNum.png", 28, 30,48);
			if (t_Win_score_spr) then
					t_Win_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
                       if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                           t_Win_score_spr:setRotation(0);	           
						else
							t_Win_score_spr:setRotation(t__local_info_type.sceore_angle);
						end
					--t_Win_score_spr:setRotation(t__local_info_type.sceore_angle);
					t_ccnode:addChild(t_Win_score_spr);
			end
            local function _call_back_()
                t_ccnode:removeFromParent();
            end
            if (t_ccnode) then
				local t_delay = cc.DelayTime:create(3);
				local t_callfunc = cc.CallFunc:create(_call_back_);
				local t_seq = cc.Sequence:create(t_delay, t_callfunc, nil);
				t_ccnode:runAction(t_seq);
			end
         end--if (t_cannon_base_node) then
         self.m_MRY_catch_Flag[chair_id] = 0;
		self.m_MRY_catch_Mul[chair_id] = 0;      --//捕获美人鱼倍数
		self.m_MRY_catch_Score[chair_id] = 0;   -- //捕获美人鱼分数
		self.m_MRY_catch_Timer[chair_id] = 0;   -- //捕获美人鱼剩余时间
		self.m_MRY_Fish_ID[chair_id] = 0;    --//捕获美人鱼FishID
    end --if (self.m_MRY_catch_Flag[chair_id]) then
end

function cannonmanager:GetMRY_Catch_Score(chair_id)return self.m_MRY_catch_Score[chair_id]; end
function cannonmanager:GetMRY_State(chair_id) return self.m_MRY_catch_Flag[chair_id]; end
function cannonmanager:GetMRY_Mul(chair_id) return self.m_MRY_catch_Mul[chair_id]; end
function cannonmanager:GetMRYFishID(chair_id)return self.m_MRY_Fish_ID[chair_id];end
----------------------------------------宝箱----------------------------------------
function cannonmanager:Catch_Baoxiang( chair_id,  num,  alivePos)-- 捕获宝箱
     local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
     if (t_cannon_base_node) then
       local t_baoxiangNode = t_cannon_base_node:getChildByTag(23232323);
       if (t_baoxiangNode == nil) then
			t_baoxiangNode = cc.Node:create();
			t_cannon_base_node:addChild(t_baoxiangNode, 1, 23232323);
			t_baoxiangNode:setPosition(cc.p(140, 30));
		end
        if (t_baoxiangNode) then
             --//生成飞回的图标
		     local t_spr = cc.Sprite:create("haiwang/res/HW/baoxiang/~TaskIcon_000_000.png");
			 t_baoxiangNode:addChild(t_spr);
             if (t_spr) then
				local t_alivePos = t_baoxiangNode:convertToNodeSpace(alivePos);
				local t_endPos = cc.p(0,0);
				t_endPos.x = t_endPos.x+((num - 1) * 22);
				t_spr:setPosition(t_alivePos);
				t_spr:setOpacity(0);
				local t_delay = cc.DelayTime:create(1);
				local t_fadeIn = cc.FadeIn:create(0.1);
				local t_movto = cc.MoveTo:create(0.8, t_endPos);
				local t_seq = cc.Sequence:create(t_delay, t_fadeIn, t_movto, nil);
				t_spr:runAction(t_seq);
			 end
        end
     end --if (t_cannon_base_node)
     self.m_BaoxiangNum[chair_id] = num;
end
function cannonmanager:Catch_BaoxiangEnd( chair_id,  num)                      --宝箱任务完成
            self.m_BaoxiangNum[chair_id] = 0;
        	if(num<1) then return ; end;
            self.m_baoxiangScore[chair_id] = num;
           	self.m_BaoxiangNum[chair_id] = 0;
        	self.m_baoxiangScore[chair_id] = num;
            local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	       if (t_cannon_base_node) then
                local t_baoxiangNode=nil;
                t_cannon_base_node:removeChildByTag(23232323);
                if(num==nil or num<=0) then
                if (t_baoxiangNode == nil) then return ; end;
		           	t_baoxiangNode = cc.Node:create();
		        	t_cannon_base_node:addChild(t_baoxiangNode, 1, 23232323);
			        t_baoxiangNode:setPosition(cc.p(140, 10));
		         end

                local t_wait_delay = 1.5;
                if (t_baoxiangNode) then
                     local t_effect_Node = cc.Node:create();
			          t_baoxiangNode:addChild(t_effect_Node);
		          	 t_effect_Node:setPosition(cc.p(-140, 200));
                     if(1) then
                        --	//播放箱子打开特效
                       local file_name ="";
			           local _sprite = nil;
			           local readIndex = 0;
		               local animation = cc.Animation:create();
                       local i=0;
			           for  i = 0,71, 1 do
				           file_name=string.format("~ActiveIcon_001_%03d.png", i);
				           local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				           if (frame) then
					         	local offset_name=string.format("ActiveIcon_001_%03d.png", i);
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
					              if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					              readIndex=readIndex+1;
                                  animation:addSpriteFrame(frame);
				           end
			          end --for
                      if (readIndex > 0)	then
			                animation:setDelayPerUnit(1/24.0);
				            local action =cc.Animate:create(animation);
                            _sprite:setOpacity(0);
					       local t_delay = cc.DelayTime:create(t_wait_delay);
				       	   local t_CCRepeat = cc.Repeat:create(action,1);
					       local t_fadeout = cc.FadeOut:create(0.2);
					       local t_fadeIn = cc.FadeIn:create(0.2);
					       local t_seq = cc.Sequence:create(t_delay,t_fadeIn, t_CCRepeat, t_fadeout, nil);
					       _sprite:runAction(t_seq);
                           if (_sprite) then t_effect_Node:addChild(_sprite, 0, 10086); end
		              end
                   end
                   --//播放任务完成特效 使用单张图片来代替
                    local _sprite =cc.Sprite:create("haiwang/res/HW/fishsub/~RWUIKuang_000_079.png");
                    if(_sprite) then
                           _sprite:setScale(0);
                           _sprite:setOpacity(0);
					       local t_delay = cc.DelayTime:create(t_wait_delay+2);
					       local t_scaleto=cc.ScaleTo:create(0.2,1);
					       local t_seq = cc.Sequence:create(t_delay,t_scaleto, nil);
					       _sprite:runAction(t_seq);
                            t_effect_Node:addChild(_sprite, 0, 10087);
                    end
                  -- //显示中奖分
                  local t_score_spr = cc.LabelAtlas:create(num, "haiwang/res/HW/baoxiang/baoxiangWinNum.png", 23, 30, 48);
                  if (t_score_spr) then
                     local function call_back_()
                             t_baoxiangNode:removeAllChildren();
                      end
                     t_score_spr:setOpacity(0);
					 t_score_spr:setScale(0.0);
                     local t_delay = cc.DelayTime:create(t_wait_delay + 2.3);
					local t_fadeIn = cc.FadeIn:create(0.2);
					local t_scaleto = cc.ScaleTo:create(0.8, 1);
					local t_showDelay = cc.DelayTime:create(5);
					local t_callfunc = cc.CallFunc:create(call_back_);
					local t_seq = cc.Sequence:create(t_delay, t_fadeIn, t_scaleto, t_showDelay, t_callfunc, nil);
                    t_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
					t_score_sp:runAction(t_seq);
					t_score_spr:setPosition(cc.p(0, -10));
					t_effect_Node:addChild(t_score_spr);
                    local t__local_info_type = _local_info_array_[chair_id];
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                        t_score_spr:setRotation(0);	           
					else
					    t_score_spr:setRotation(t__local_info_type.sceore_angle);
					end
					-- t_score_spr:setRotation(t__local_info_type.sceore_angle);
                   end
                    cc.exports.g_soundManager:PlayGameEffect("CaiJinSound");
                end-- if (t_baoxiangNode) then
           end
end
--endregion
function cannonmanager:Catch_FullScreenDragon( chair_id,  alivePos,  score,  mul_num)--捕获火龙
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       local t_start_pos = t_cannon_base_node:convertToNodeSpace(alivePos);
	   local t_ccnode = cc.Node:create();
	   local t_cart_node = cc.Node:create();
		t_cannon_base_node:removeChildByTag(952711);
		t_cannon_base_node:addChild(t_ccnode, 111, 952711);
		t_ccnode:addChild(t_cart_node, 113);
       --//生成图标
		if (t_ccnode) then
           	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,12, 1 do
			    file_name=string.format("~FullScreenFishMark_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						    local offset_name=string.format("FullScreenFishMark_000_%03d.png", i);
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
					      if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					      readIndex=readIndex+1;
                         animation:addSpriteFrame(frame);
				end
			end --for
           if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cart_node:addChild(_sprite, 111);
		   end
           ---移动会炮塔
			if(1) then
                local function call_back__()
                     t_ccnode:removeFromParent();
                end
				t_cart_node:setScale(0.1);
				t_cart_node:setPosition(t_start_pos);
				local t_CCScaleTo = cc.ScaleTo:create(0.2, 1.5);          -- //缩小到1
				local t_CCDelayTime0 = cc.DelayTime:create(0.8);--//在图标点转动
				local t_CCMoveTo = cc.MoveTo:create(2.0, cc.p(0, 250)); --//移动到图标点
				local t_CCDelayTime = cc.DelayTime:create(3);  --//在图标点转动
				local funcall = cc.CallFunc:create(call_back__);
				local seq = cc.Sequence:create(t_CCScaleTo, t_CCDelayTime0, t_CCMoveTo, t_CCDelayTime, funcall, nil);
				t_cart_node:runAction(seq);
			end   ---if(1) then 移动会炮塔
            --	//添加图标到炮塔
            if(1) then
               local  t_show_pos_ = t_start_pos;
			   local t_ccpr = cc.Sprite:createWithSpriteFrameName("~FullScreenFishLogo_000_000.png");--//图标
			   if (t_ccpr) then
				   t_ccnode:addChild(t_ccpr, 13);
				   t_ccpr:setPosition(cc.p(0, 100));
			   end
                local t_cannon_score_spr = cc.LabelAtlas:create(score, "haiwang/res/HW/fishnum.png", 28, 38, 48);
				 if (t_cannon_score_spr) then
					  t_cannon_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
					  t_ccnode:addChild(t_cannon_score_spr, 1111);
					  t_cannon_score_spr:setPosition(cc.p(0, 110));
					  local t__local_info_type = _local_info_array_[chair_id];
                      if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_score_spr:setRotation(0);	           
					  else
					     t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
				  	  end
					  --t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
				  end
            end--if(1) then
        end  --if (t_ccnode) then
	end --	if (t_cannon_base_node) then
end
function cannonmanager:Catch_EYuFish( chair_id,  alivePos,  score,  mul_num)  --捕获鳄鱼
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       local t_start_pos = t_cannon_base_node:convertToNodeSpace(alivePos);
	   local t_ccnode = cc.Node:create();
	   local t_cart_node = cc.Node:create();
		t_cannon_base_node:removeChildByTag(952711);
		t_cannon_base_node:addChild(t_ccnode, 111, 952711);
		t_ccnode:addChild(t_cart_node, 113);
       --//生成图标
		if (t_ccnode) then
           	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,36, 1 do
			    file_name=string.format("~EYuJumpLogo_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						    local offset_name=string.format("EYuJumpLogo_000_%03d.png", i);
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
					      if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					      readIndex=readIndex+1;
                         animation:addSpriteFrame(frame);
				end
			end --for
           if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cart_node:addChild(_sprite, 111);
		   end
           ---移动会炮塔
			if(1) then
                local function call_back__()
                     t_ccnode:removeFromParent();
                end
				t_cart_node:setScale(0.1);
				t_cart_node:setPosition(t_start_pos);
				local t_CCScaleTo = cc.ScaleTo:create(0.2, 1.5);          -- //缩小到1
				local t_CCDelayTime0 = cc.DelayTime:create(0.8);--//在图标点转动
				local t_CCMoveTo = cc.MoveTo:create(2.0, cc.p(0, 250)); --//移动到图标点
				local t_CCDelayTime = cc.DelayTime:create(3);  --//在图标点转动
				local funcall = cc.CallFunc:create(call_back__);
				local seq = cc.Sequence:create(t_CCScaleTo, t_CCDelayTime0, t_CCMoveTo, t_CCDelayTime, funcall, nil);
				t_cart_node:runAction(seq);
			end   ---if(1) then 移动会炮塔
            --	//添加图标到炮塔
            if(1) then
               local  t_show_pos_ = t_start_pos;
			   local t_ccpr = cc.Sprite:createWithSpriteFrameName("~EYuKuang_000_000.png");--//图标
			   if (t_ccpr) then
				   t_ccnode:addChild(t_ccpr, 13);
				   t_ccpr:setPosition(cc.p(0, 100));
			   end
                local t_cannon_score_spr = cc.LabelAtlas:create(score, "haiwang/res/HW/fishnum.png", 28, 38, 48);
				 if (t_cannon_score_spr) then
					  t_cannon_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
					  t_ccnode:addChild(t_cannon_score_spr, 1111);
					  t_cannon_score_spr:setPosition(cc.p(0, 110));
					  local t__local_info_type = _local_info_array_[chair_id];
					  --t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
                      if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_score_spr:setRotation(0);	           
					  else
					     t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
				  	  end
				  end
            end--if(1) then
        end  --if (t_ccnode) then
	end --	if (t_cannon_base_node) then

end
function cannonmanager:Catch_fishSuperCrab( chair_id,  alivePos,  score,  mul_num)--帝王蟹
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       local t_start_pos = t_cannon_base_node:convertToNodeSpace(alivePos);
	   local t_ccnode = cc.Node:create();
	   local t_cart_node = cc.Node:create();
		t_cannon_base_node:removeChildByTag(951711);
		t_cannon_base_node:addChild(t_ccnode, 111, 951711);
		t_ccnode:addChild(t_cart_node, 113);
       --//生成图标
		if (t_ccnode) then
           	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,36, 1 do
			    file_name=string.format("~SuperCrabJumpLogo_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						    local offset_name=string.format("SuperCrabJumpLogo_000_%03d.png", i);
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
					      if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					      readIndex=readIndex+1;
                         animation:addSpriteFrame(frame);
				end
			end --for
           if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cart_node:addChild(_sprite, 111);
		   end
           ---移动会炮塔
			if(1) then
                local function call_back__()
                     t_ccnode:removeFromParent();
                end
				t_cart_node:setScale(0.1);
				t_cart_node:setPosition(t_start_pos);
				local t_CCScaleTo = cc.ScaleTo:create(0.2, 1.5);          -- //缩小到1
				local t_CCDelayTime0 = cc.DelayTime:create(0.8);--//在图标点转动
				local t_CCMoveTo = cc.MoveTo:create(2.0, cc.p(0, 250)); --//移动到图标点
				local t_CCDelayTime = cc.DelayTime:create(3);  --//在图标点转动
				local funcall = cc.CallFunc:create(call_back__);
				local seq = cc.Sequence:create(t_CCScaleTo, t_CCDelayTime0, t_CCMoveTo, t_CCDelayTime, funcall, nil);
				t_cart_node:runAction(seq);
			end   ---if(1) then 移动会炮塔
            --	//添加图标到炮塔
            if(1) then
               local  t_show_pos_ = t_start_pos;
			   local t_ccpr = cc.Sprite:createWithSpriteFrameName("~SuperCrabKuang_000_000.png");--//图标
			   if (t_ccpr) then
				   t_ccnode:addChild(t_ccpr, 13);
				   t_ccpr:setPosition(cc.p(0, 100));
			   end
                local t_cannon_score_spr = cc.LabelAtlas:create(score, "haiwang/res/HW/fishnum.png", 28, 38, 48);
				 if (t_cannon_score_spr) then
					  t_cannon_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
					  t_ccnode:addChild(t_cannon_score_spr, 1111);
					  t_cannon_score_spr:setPosition(cc.p(0, 110));
					  local t__local_info_type = _local_info_array_[chair_id];
					  --t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
                       if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                         t_cannon_score_spr:setRotation(0);	           
					  else
					     t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
				  	  end
				  end
            end--if(1) then
        end  --if (t_ccnode) then
	end --	if (t_cannon_base_node) then

end
function cannonmanager:Catch_FishBigDengLong( chair_id,  alivePos,  score,  mul_num)--深海之王
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       local t_start_pos = t_cannon_base_node:convertToNodeSpace(alivePos);
	   local t_ccnode = cc.Node:create();
	   local t_cart_node = cc.Node:create();
		t_cannon_base_node:removeChildByTag(951711);
		t_cannon_base_node:addChild(t_ccnode, 111, 951711);
		t_ccnode:addChild(t_cart_node, 113);
       --//生成图标
		if (t_ccnode) then
           	local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,36, 1 do
			    file_name=string.format("~DengLongJumpLogo_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						    local offset_name=string.format("DengLongJumpLogo_000_%03d.png", i);
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
					      if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					      readIndex=readIndex+1;
                         animation:addSpriteFrame(frame);
				end
			end --for
           if (readIndex > 0)	then
			      animation:setDelayPerUnit(1/12.0);
				  local action =cc.Animate:create(animation);
				  _sprite:runAction(cc.RepeatForever:create(action));
                  t_cart_node:addChild(_sprite, 111);
		   end
           ---移动会炮塔
			if(1) then
                local function call_back__()
                     t_ccnode:removeFromParent();
                end
				t_cart_node:setScale(0.1);
				t_cart_node:setPosition(t_start_pos);
				local t_CCScaleTo = cc.ScaleTo:create(0.2, 1.5);          -- //缩小到1
				local t_CCDelayTime0 = cc.DelayTime:create(0.8);--//在图标点转动
				local t_CCMoveTo = cc.MoveTo:create(2.0, cc.p(0, 250)); --//移动到图标点
				local t_CCDelayTime = cc.DelayTime:create(3);  --//在图标点转动
				local funcall = cc.CallFunc:create(call_back__);
				local seq = cc.Sequence:create(t_CCScaleTo, t_CCDelayTime0, t_CCMoveTo, t_CCDelayTime, funcall, nil);
				t_cart_node:runAction(seq);
			end   ---if(1) then 移动会炮塔
            --	//添加图标到炮塔
            if(1) then
               local  t_show_pos_ = t_start_pos;
			   local t_ccpr = cc.Sprite:createWithSpriteFrameName("~DengLongKuang_000_000.png");--//图标
			   if (t_ccpr) then
				   t_ccnode:addChild(t_ccpr, 13);
				   t_ccpr:setPosition(cc.p(0, 100));
			   end
                local t_cannon_score_spr = cc.LabelAtlas:create(score, "haiwang/res/HW/fishnum.png", 28, 38, 48);
				 if (t_cannon_score_spr) then
					     t_cannon_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
					     t_ccnode:addChild(t_cannon_score_spr, 1111);
					     t_cannon_score_spr:setPosition(cc.p(0, 110));
					     local t__local_info_type = _local_info_array_[chair_id];
					     --t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
                         if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                            t_cannon_score_spr:setRotation(0);	           
					     else
					        t_cannon_score_spr:setRotation(t__local_info_type.sceore_angle);
				  	     end
				  end
            end--if(1) then
        end  --if (t_ccnode) then
	end --	if (t_cannon_base_node) then
end
function cannonmanager:PlayerCannonCut( chair_id)                                                                            --鳄鱼咬到炮塔
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
    if (t_cannon_base_node)then
           local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;
			for  i = 0,16, 1 do
				file_name=string.format("~screw_000_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						local offset_name=string.format("screw_000_%03d.png", i);
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
			end--for
             if (readIndex > 0)	then
                local function _call_bakc__()
                     _sprite:removeFromParent();
                  end
			      animation:setDelayPerUnit(1/24.0);
				  local action =cc.Animate:create(animation);
			    	--  _sprite:runAction(cc.RepeatForever:create(action));
                   --  self:addChild(_sprite, 0, 10086);
                  local  t_CCRepeat = cc.Repeat:create(action,1);
				  local t_callfunc = cc.CallFunc:create(_call_bakc__);
				  local t_seq = cc.Sequence:create(t_CCRepeat, t_callfunc, nil);
				 _sprite:runAction(t_seq);
				_sprite:setScale(1.5);
				t_cannon_base_node:addChild(_sprite);
			  end
              --抖动炮塔
	           local t_game_player = t_cannon_base_node:getChildByTag(6666);
		      if (t_game_player)  then 	t_game_player:PlayShake(); end
    end --basenode

end
---------------------------------------------------------------------显示捕获特殊鱼等----------------------------------------
function cannonmanager:Catch_ChainShell_( chair_id,  score,  mul_num)                                    --启动闪电连锁
    self.m_catch_ChainShell_Timer[chair_id] = 0;
	self.m_catch_ChainShell_Flag[chair_id] = 1;
    self.m_catch_ChainShell_score[chair_id] =score;
    self.m_catch_ChainShell_mul[chair_id] = mul_num;
    local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       t_cannon_base_node:removeChildByTag(1222555 + chair_id);
		local t_chain_Effect_Node = cc.Node:create();
		t_cannon_base_node:addChild(t_chain_Effect_Node, 11, 1222555 + chair_id);
		local t_tis_node = cc.Node:create();
		t_chain_Effect_Node:addChild(t_tis_node, 1, 99);
        --显示闪电连锁动画
        local file_name ="";
		local _sprite = nil;
		local readIndex = 0;
		local animation = cc.Animation:create();
        local i=0;
		for  i = 0,31, 1 do
          file_name=string.format("~ChainLogo_000_%03d.png", i);
          	local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			if (frame) then
            			local offset_name=string.format("ChainLogo_000_%03d.png", i);
						if (cc.exports.g_offsetmap_CL_UIFlag<1) then
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
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
            end
        end --for
        if (readIndex > 0)	then
              cc.exports.g_offsetmap_CL_UIFlag=1;
			    animation:setDelayPerUnit(1/12.0);
				local action =cc.Animate:create(animation);
				_sprite:runAction(cc.RepeatForever:create(action));
		end
		--if (_sprite) then self:addChild(_sprite); end
         if (_sprite)	then
				local t__local_info_type = _local_info_array_[chair_id];
				t_tis_node:addChild(_sprite);
				--if (t__local_info_type.sceore_angle==180)_sprite:setFlipX(true);
				_sprite:setPosition(cc.p(0, 100));
		end
        --显示倍数
        local t_CCLabelAtlas =cc.LabelAtlas:_create(mul_num,"haiwang/res/HW/ChainShell/chainShell_num.png", 30, 45, 48);
        if (t_CCLabelAtlas)
		then
				t_tis_node:addChild(t_CCLabelAtlas);
				t_CCLabelAtlas:setAnchorPoint(cc.p(0.5, 0.5));
				t_CCLabelAtlas:setScale(0.5);
				t_CCLabelAtlas:setPosition(cc.p(-5, 115));
				local t__local_info_type =_local_info_array_[chair_id];
				--if (t__local_info_type.sceore_angle == 180) then t_CCLabelAtlas:setPosition(ccp(5, 115)); end
				--t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
                if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                   t_CCLabelAtlas:setRotation(0);	           
			    else
					t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
				 end
	  end
  	  --旋转几周
		local t_rotate_ = cc.RotateBy:create(1, 360);
		t_tis_node:runAction(t_rotate_);
    end --if (t_cannon_base_node) then
end
function cannonmanager:Catch_ChainShell_End( chair_id,   score,  mul_num)                              --闪电连锁结束
     cclog("cannonmanager:Catch_ChainShell_End( chair_id,   score,  mul_num) ");
	self.m_catch_ChainShell_Flag[chair_id] = 0;
	self.m_catch_ChainShell_Timer[chair_id] = 0;
    self.m_catch_ChainShell_score[chair_id] =0;
    self.m_catch_ChainShell_mul[chair_id] = 0;
    local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
        local t_showScoreNode = t_cannon_base_node:getChildByTag(1222555 + chair_id);
        --显示获得分数
        if (t_showScoreNode) then
                local t_dis_Ui = t_showScoreNode:getChildByTag(99);
				if (t_dis_Ui) then
					local t_movto = cc.MoveTo:create(0.2, cc.p(0,10));
					t_dis_Ui:runAction(t_movto);
				end
                local t_text_node=cc.Node:create();
                 t_text_node:setAnchorPoint(cc.p(0.5,0.5));

                 t_showScoreNode:addChild(t_text_node);
                 t_text_node:setPosition(cc.p(0, 60));
                local tem_char="";
                tem_char=string.format("%d:", score);
                local t_str_length =#tem_char;
				t_str_length = (t_str_length + 2) * 24;--字串长度
				local start_x = -t_str_length / 2 + 48;
               local t_spr_s = cc.Sprite:createWithSpriteFrameName("~ChainLinkScoreHead_000_000.png");
				if (t_spr_s) then
					t_spr_s:setAnchorPoint(cc.p(1.0, 0.5));
					t_spr_s:setPosition(cc.p(start_x, 0));
					t_text_node:addChild(t_spr_s);
				end
                local t_CCLabelAtlas = cc.LabelAtlas:_create(tem_char,"haiwang/res/HW/ChainShell/chainwin_scoreNum.png", 48, 70, 48);
				if (t_CCLabelAtlas) then
					t_CCLabelAtlas:setScale(0.5);
					t_CCLabelAtlas:setAnchorPoint(cc.p(0, 0.5));
					t_CCLabelAtlas:setPosition(cc.p(start_x, 0));
					t_text_node:addChild(t_CCLabelAtlas);
				end
                local  t__local_info_type = _local_info_array_[chair_id];
				--t_text_node:setRotation(t__local_info_type.sceore_angle);
                if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                   t_text_node:setRotation(0);	           
			    else
					t_text_node:setRotation(t__local_info_type.sceore_angle);
				 end

                --自分离
                local function _call_bakc_()
                      t_showScoreNode:removeFromParent();
                end
				local t_CCDelayTime=cc.DelayTime:create(3.5);
				local t_CCFadeOut = cc.FadeOut:create(0.5);
				local t_callfunc = cc.CallFunc:create(_call_bakc_);
				local t_CCSequence=cc.Sequence:create(t_CCDelayTime, t_CCFadeOut, t_callfunc, nil);
				t_showScoreNode:runAction(t_CCSequence);
				--

        end --t_showScoreNode
    end
end
function cannonmanager:catch_king_card_( chair_id,  score,  mul_num)                                     --旋风鱼激活
    --cclog(" cannonmanager:catch_king_card_( chair_id=%d,  score=%d,  mul_num=%d)",chair_id,score,mul_num);
    self.m_catch_king_timer[chair_id] = 0;
	self.m_catch_kingl_Flag[chair_id] = 1;
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       t_cannon_base_node:removeChildByTag(1333555 + chair_id);
		local t_chain_Effect_Node = cc.Node:create();
		local t_dis_Ui = cc.Node:create();
		t_cannon_base_node:addChild(t_chain_Effect_Node, 11, 1333555 + chair_id);
		t_chain_Effect_Node:setPosition(cc.p(0, 120));
		t_chain_Effect_Node:addChild(t_dis_Ui,1,99);
        local t_king_ui_spr = cc.Sprite:createWithSpriteFrameName("~SameKindBombLogo_000_000.png");--卡片
		t_dis_Ui:addChild(t_king_ui_spr);
        --显示倍数
      local t_CCLabelAtlas = cc.LabelAtlas:_create(mul_num,"haiwang/res/HW/ChainShell/chainShell_num.png", 30, 45,48);
      	if (t_CCLabelAtlas)
		then
				t_dis_Ui:addChild(t_CCLabelAtlas);
				t_CCLabelAtlas:setAnchorPoint(cc.p(0.5, 0.5));
				t_CCLabelAtlas:setScale(0.5);
				t_CCLabelAtlas:setPosition(cc.p(-5, 15));
				local t__local_info_type = _local_info_array_[chair_id];
                if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then
                  t_CCLabelAtlas:setRotation(0);
                   t_CCLabelAtlas:setPosition(cc.p(0, 15));
				elseif(t__local_info_type.sceore_angle>0) then
                   t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
                   t_CCLabelAtlas:setPosition(cc.p(0, 15));
               end
		end
	end

end
function cannonmanager:catch_king_card_End( chair_id,  score,  mul_num)                               --旋风鱼结束
            cclog("cannonmanager:catch_king_card_End( chair_id=%d,  score=%d,  mul_num=%d)--旋风鱼结束--",chair_id,  score,  mul_num);
           	self.m_catch_king_timer[chair_id] = 0;
	        self.m_catch_kingl_Flag[chair_id] = 0;
            local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	        if (t_cannon_base_node) then
                 local t_showScoreNode = t_cannon_base_node:getChildByTag(1333555 + chair_id);
                 local t__local_info_type = _local_info_array_[chair_id];
                 if (t_showScoreNode)		then
                      local t_dis_Ui = t_showScoreNode:getChildByTag(99);
				      if (t_dis_Ui) then
					       local t_movto = cc.MoveTo:create(0.2, cc.p(0, 50));
					        t_dis_Ui:runAction(t_movto);
				     end
                     local  tem_char=string.format("%d:", score);
                     local t_str_length = string.len(tem_char);
				     t_str_length =( t_str_length+2) * 35;
			    	local start_x = -t_str_length / 2+70;
                    if (t__local_info_type.sceore_angle == 180) then start_x = -t_str_length / 2 + 130; end
                   local t_spr_s = cc.Sprite:createWithSpriteFrameName("~SameKindBombGainText_000_000.png");
                   if (t_spr_s)	then
					  t_spr_s:setAnchorPoint(cc.p(1.0, 0.5));
					  t_spr_s:setPosition(cc.p(start_x, -20));
					 -- t_spr_s:setRotation(t__local_info_type.sceore_angle);
                      if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                             t_spr_s:setRotation(0);	           
			            else
					         t_spr_s:setRotation(t__local_info_type.sceore_angle);
				        end
					  t_showScoreNode:addChild(t_spr_s);
				   end
                    local t_CCLabelAtlas = cc.LabelAtlas:create(tem_char,"haiwang/res/HW/king/king_num.png", 35, 34, 48);
				   if (t_CCLabelAtlas) then
					    t_CCLabelAtlas:setAnchorPoint(cc.p(0, 0.5));
				    	t_CCLabelAtlas:setPosition(cc.p(start_x, -20));
					    t_showScoreNode:addChild(t_CCLabelAtlas);
					    --t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
                        if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                             t_CCLabelAtlas:setRotation(0);	           
			            else
					         t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
				        end
				   end
                   --自分离		--
                    local function mov_callback()
                     t_showScoreNode:removeFromParent();
                   end
				   local t_CCDelayTime = cc.DelayTime:create(3);
				   local t_CCFadeOut = cc.FadeOut:create(0.5);
			       local t_callfunc = cc.CallFunc:create(mov_callback);
				   local t_CCSequence = cc.Sequence:create(t_CCDelayTime, t_CCFadeOut, t_callfunc, nil);
			       t_showScoreNode:runAction(t_CCSequence);
                 end
            end

end
function cannonmanager:catch_king_king_card_( chair_id,  score,  mul_num)                              --旋风鱼王激活
   self.m_catch_king_timer[chair_id] = 0;
	self.m_catch_kingl_Flag[chair_id] = 1;
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then
       t_cannon_base_node:removeChildByTag(1222555 + chair_id);
		local t_chain_Effect_Node = cc.Node:create();
		local t_dis_Ui = cc.Node:create();
		t_cannon_base_node:addChild(t_chain_Effect_Node, 11, 1222555 + chair_id);
		t_chain_Effect_Node:setPosition(cc.p(0, 120));
		t_chain_Effect_Node:addChild(t_dis_Ui,1,99);
        local t_king_ui_spr = cc.Sprite:createWithSpriteFrameName("~SameKindKingLOGO_000_000.png");--卡片
		t_dis_Ui:addChild(t_king_ui_spr);
        --显示倍数
      local t_CCLabelAtlas = cc.LabelAtlas:_create(mul_num,"haiwang/res/HW/ChainShell/chainShell_num.png", 30, 45,48);
      	if (t_CCLabelAtlas)
		then
				t_dis_Ui:addChild(t_CCLabelAtlas);
				t_CCLabelAtlas:setAnchorPoint(cc.p(0.5, 0.5));
				t_CCLabelAtlas:setScale(0.5);
				t_CCLabelAtlas:setPosition(cc.p(-5, 30));
				local t__local_info_type = _local_info_array_[chair_id];
                 if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then
                    t_CCLabelAtlas:setRotation(0);
				elseif(t__local_info_type.sceore_angle>0) then
                   t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
                 end
--
--				 if(t__local_info_type.sceore_angle>0)
--                then
--                   t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
--                   t_CCLabelAtlas:setPosition(cc.p(0, 15));
--               end
--
		end
	end

end
function cannonmanager:catch_king__king_card_End( chair_id,  score,  mul_num)                      --旋风鱼王结束
     	self.m_catch_king_timer[chair_id] = 0;
	        self.m_catch_kingl_Flag[chair_id] = 0;
            local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	        if (t_cannon_base_node) then
                 local t_showScoreNode = t_cannon_base_node:getChildByTag(1222555 + chair_id);
                 local t__local_info_type = _local_info_array_[chair_id];
                 if (t_showScoreNode)		then
                      local t_dis_Ui = t_showScoreNode:getChildByTag(99);
				      if (t_dis_Ui) then
					       local t_movto = cc.MoveTo:create(0.2, cc.p(0, 50));
					        t_dis_Ui:runAction(t_movto);
				    end
                 else
                    t_showScoreNode=cc.Node:create();
                     t_cannon_base_node:addChild(t_showScoreNode, 11, 1222555 + chair_id);
		            t_showScoreNode:setPosition(cc.p(0, 120));
                 end
                 local  tem_char=string.format("%d:", score);
                 local t_str_length = string.len(tem_char);
				t_str_length =( t_str_length+2) * 35;
				local start_x = -t_str_length / 2+70;
                if (t__local_info_type.sceore_angle == 180) then start_x = -t_str_length / 2 + 130; end
                local t_spr_s = cc.Sprite:createWithSpriteFrameName("~SameKindBombGainText_000_000.png");
                if (t_spr_s)	then
					t_spr_s:setAnchorPoint(cc.p(1.0, 0.5));
					t_spr_s:setPosition(cc.p(start_x, -20));
					--t_spr_s:setRotation(t__local_info_type.sceore_angle);
                     if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                        t_spr_s:setRotation(0);	           
			        else
					    t_spr_s:setRotation(t__local_info_type.sceore_angle);
				    end
					t_showScoreNode:addChild(t_spr_s);
				end
                local t_CCLabelAtlas = cc.LabelAtlas:create(tem_char,"haiwang/res/HW/king/king_num.png", 35, 34, 48);
				if (t_CCLabelAtlas) then
					t_CCLabelAtlas:setAnchorPoint(cc.p(0, 0.5));
					t_CCLabelAtlas:setPosition(cc.p(start_x, -20));
					t_showScoreNode:addChild(t_CCLabelAtlas);
					--t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
                    if(t__local_info_type.sceore_angle==90 or t__local_info_type.sceore_angle==-90) then 
                        t_CCLabelAtlas:setRotation(0);	           
			        else
					    t_CCLabelAtlas:setRotation(t__local_info_type.sceore_angle);
				    end
				end
                --自分离		--
                local function mov_callback()
                    t_showScoreNode:removeFromParent();
                end
				local t_CCDelayTime = cc.DelayTime:create(3);
				local t_CCFadeOut = cc.FadeOut:create(0.5);
				local t_callfunc = cc.CallFunc:create(mov_callback);
				local t_CCSequence = cc.Sequence:create(t_CCDelayTime, t_CCFadeOut, t_callfunc, nil);
			    t_showScoreNode:runAction(t_CCSequence);
            end

end
function cannonmanager:Getspec_KindNum( chair_id)                                                             --获取特殊子弹
  -- cclog("cannonmanager:Getspec_KindNum0");
	if (self.m_Broach_Flag[chair_id]>0 and self.m_Broach_FireFlag[chair_id]>0)  then  return 1; end
   -- cclog("cannonmanager:Getspec_KindNum1");
	if (self.m_Dianci_Flag[chair_id]>0 and self.m_Dianci_FireFlag[chair_id]>0) then return 2; end
   --  cclog("cannonmanager:Getspec_KindNum2");
	if (self.m_GuidedMissile_Flag[chair_id]>0 and self.m_GuidedMissile_FireFlag[chair_id]>0) then return 4; end
 --    cclog("cannonmanager:Getspec_KindNum3");
	if (self.m_FreeBullet_Flag[chair_id]>0) then return 3; end
  --   cclog("cannonmanager:Getspec_KindNum4");
	return 0;
end
function cannonmanager:FireSpecBullet( chair_id, specKind, bulletid, lockID)         --发射特殊子弹
    if (specKind == 1)then --穿甲弹
		if (self.m_Broach_Flag[chair_id]>0 and self.m_Broach_FireFlag[chair_id]>0) then
			self.m_Broach_FireFlag[chair_id] = 0;
			local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
				t_cannon_base_node:removeChildByTag(77777 + chair_id);                                                     	--//移除炮塔效果                                                                                                                                        //显示炮塔
				--//显示炮塔
					if (self.m_Dianci_Flag[chair_id] == 0
						and self.m_FreeBullet_Flag[chair_id] == 0
						)
				then
						local t_game_player =t_cannon_base_node:getChildByTag(6666);
						if (t_game_player)	then	t_game_player:ShowCannon_(true);end
				end
				if (cc.exports.g_Broach_Bullet_Manager)then
					cc.exports.g_Broach_Bullet_Manager:Alive_Broach_Bullet(
						bulletid,
						self.m_Broach_BulletMul[chair_id],
						self.m_Broach_CatchMul[chair_id],
						self.m_Broach_CatchScore[chair_id],
						chair_id,
						self:GetFreeFirePos(chair_id,0),
						self.current_angle_[chair_id]
						);
					return 1;
				end
			end --if (t_cannon_base_node) then
		end --if (m_Broach_Flag[chair_id] and m_Broach_FireFlag[chair_id]) then
     ---end --  if (specKind == 1)
     elseif (specKind == 2) then--电磁炮
     		if (self.m_Dianci_Flag[chair_id]>0 and self.m_Dianci_FireFlag[chair_id]>0) then
			    self.m_Dianci_FireFlag[chair_id] = 0;
			     local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
				self:Play_dianci_Fire(chair_id);
				if (cc.exports.g_Dianci_Bullet_Manager)	then
					cc.exports.g_Dianci_Bullet_Manager:Alive_Dianci_Bullet(
						bulletid,
						self.m_Dianci_BulletMul[chair_id],
						self.m_Dianci_CatchMul[chair_id],
						self.m_Dianci_CatchScore[chair_id],
						chair_id,
						self:GetCannonPos(chair_id,0),
						self.current_angle_[chair_id]
						);
					return 1;
				end
			end --if (t_cannon_base_node) then
		end
     --end--elseif (specKind == 2) then--电磁炮
      elseif (specKind == 4) then--必杀子弹
         	if ( self.m_GuidedMissile_Flag[chair_id]>0 and  self.m_GuidedMissile_FireFlag[chair_id]>0) then
			   self.m_GuidedMissile_FireFlag[chair_id] =0;
		    	local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
			   if (t_cannon_base_node) then
				self:Fire(chair_id);
				if (cc.exports.g_GuidedMissile_Bullet_Manager) then
					cc.exports.g_GuidedMissile_Bullet_Manager:Alive_GuidedMissile_Bullet(
						bulletid,
						self.m_GuidedMissile_Mul[chair_id],
						self.m_GuidedMissile_CatchMul[chair_id],
						self.m_GuidedMissile_CatchScore[chair_id],
						chair_id,
						self:GetCannonPos(chair_id, 1),
						self.current_angle_[chair_id]
						);
					return 1;
				end
			end
		 end  --if (m_GuidedMissile_Flag[chair_id] && m_GuidedMissile_FireFlag[chair_id]) then
      --end  -- elseif (specKind == 4) then--必杀子弹
      elseif (specKind == 3) then --免费子弹
          if(self.m_FreeBullet_Flag[chair_id]>0) then
            local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
			if (t_cannon_base_node) then
               self:Play_FreeBullet_Fire(chair_id);
               	if (cc.exports.g_Free_Bullet_Manager) then
                	cc.exports.g_Free_Bullet_Manager:Alive_Free_Bullet(
						bulletid,
						self.m_FreeBullet_Mul[chair_id],
						0,
						0,
						chair_id,
						self:GetCannonPos(chair_id,1),
						self.current_angle_[chair_id],
						lockID
						);
                        return 1;
                end
			end--if (t_cannon_base_node) then
          end  --  if (self.m_FreeBullet_Flag[chair_id]>0)
      end--else if (specKind == 3) --免费子弹
      return 0;
end
--
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------
return cannonmanager;
--endregion

--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/5
--此文件由[BabeLua]插件自动生成
local cannonmanager = class("cannonmanager",
 function()
	return cc.Node:create()
end
)

function cannonmanager:ctor()
     self:init();
     
     local i=0;
	 for  i = 0,cc.exports._local_player_num_I-1, 1 do
     	local cannon_base_node =cc.Node:create();      -- 一个炮塔节点
		self:addChild(cannon_base_node, 11, 9999 + i);
        local t_game_player = CGame_player.new(i, cc.p(-240, -50)); 
        cannon_base_node:addChild(t_game_player, 1, 6666);      --添加游戏虚拟节点和位置
		if (cc.exports.g_game_run_type == 3) then cannon_base_node:setScale(0.8); end
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
        self:SetPlayer_Type(i,4);
     end
     cc.SpriteFrameCache:getInstance():addSpriteFrames("qj_animal/res/game_res/fireEffect.plist");		--加载开火特效
    local function handler(interval)
           self:update(interval);
    end
    self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);   
end

function cannonmanager:init()
     self.current_angle_={[0]=0,0,0,0,0,0,0,0,0};
     self.m_fFireAngle={[0]=0,0,0,0,0,0,0,0,0};
     self.current_bullet_kind_={0,0,0,0,0,0,0,0,0,0,0,0};
     self.current_mulriple_={[0]=10,10,10,10,10,10,10,10,10,10,10,10};
     self.m_onlineState={[0]=0,0,0,0,0,0,0,0,0};
     self.fish_score_={[0]=0,0,0,0,0,0,0,0,0};  
     self.m_BaoxiangNum={[0]=0,0,0,0,0,0,0,0,0};
     self.m_baoxiangScore={[0]=0,0,0,0,0,0,0,0,0};
     self.m__InterlinkBomb_Score={[0]=0,0,0,0,0,0,0,0,0};
     self.m_double_flag={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_double_timer={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_freeTimer={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_free_Flag={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_free_bulletNum={[0]=0,0,0,0,0,0,0,0,0};
     self.m_BaoxiangNum={[0]=0,0,0,0,0,0,0,0,0};
	 self.m_baoxiangScore={[0]=0,0,0,0,0,0,0,0,0};
     self.sec_timer=0;
     cc.exports.g_cannon_manager=self;--.cannon_manager_;
end
function  cannonmanager:update(delta)
    self.sec_timer=self.sec_timer+delta;
    if(self.sec_timer>1.0) then 
       self.sec_timer=self.sec_timer-1.0;
       self:SecTimer(1);
    end
end
function  cannonmanager:SecTimer(dt)
   local i=0;
   for i=0,cc.exports._local_player_num_I-1,1 do 
       local t_cannon_base_node = self:getChildByTag(9999 + i);
		if (t_cannon_base_node) then 
           if (self.m_double_flag[i] > 0) then 
					self.m_double_timer[i]=self.m_double_timer[i]-1;
					if(self.m_double_timer[i] < 0) then  self:Ion_Double_Stop(i); 
					else                    	         self:Ion_Double_UpdateTimer(i, self.m_double_timer[i]); end
			end
		    if(self.m_free_Flag[i] > 0) then 
				self.m_freeTimer[i]=self.m_freeTimer[i]-1;
				if (self.m_freeTimer[i] < 0) then self:Ion_free_Stop(i); end
			end
        end
   end

end

function  cannonmanager:SetCurrentAngle( chair_id,  angle)
     if(chair_id < GAME_PLAYER) then
		self.current_angle_[chair_id] =math.deg(angle); --MySriteCache::GetAngleForRadian(angle);
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node~=nil)then
            local t__local_info_type = cc.exports._local_info_array_[chair_id];
			local t_node_cannon_node = t_cannon_base_node:getChildByTag(PLAYER_CANNON_TAG);   --炮管节点	
            if (t_node_cannon_node)	then t_node_cannon_node:setRotation(self.current_angle_[chair_id] - t__local_info_type.default_angle);end
            local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_game_player:SetCannon_angle(self.current_angle_[chair_id]); end
        end;
     end;
end
function  cannonmanager:Connon_Angle_Reset( local_chair_id)--                     //炮管复位 主要用于锁定结束
    local t__local_info_type = cc.exports._local_info_array_[local_chair_id];
	self.current_angle_[chair_id] = t__local_info_type.default_angle;
	self:SetCurrentAngle(chair_id, self.current_angle_[chair_id]);
end
function  cannonmanager:SetCannonMulriple( chair_id,  mulriple)
if (chair_id <_local_player_num_I) then 
    self.current_mulriple_[chair_id]= mulriple
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then
			local t_game_player =t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then 	t_game_player:SetCannonNum(mulriple); end
		end
    end
end

function  cannonmanager:GetCannonMulriple( chair_id)
           return  self.current_mulriple_[chair_id];
end
function  cannonmanager:GetCurrentAngle( chair_id)
          return  math.rad(self.current_angle_[chair_id]);
end
function  cannonmanager:ShowMyConButton(chair_id)--  //显示控制按钮
    cclog("cannonmanager:ShowMyConButton(chair_id=%d)--------------------",chair_id);
    local t_cannon_base_node = self:getChildByTag(9999 +chair_id);
	if (t_cannon_base_node) then 
		local t_game_player =t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then t_game_player:ShowAdd_sub_bt(true); end
	end
end
function  cannonmanager:GetCannonPos( chair_id, flag )
    local t_ccp_=cc.p(0,0);
	local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node)then
		local x,y =t_cannon_base_node:getPosition();
		t_ccp_ = self:convertToWorldSpace(cc.p(x,y));		
		if (flag>0)then
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_ccp_ = t_game_player:GetFirePoint(); end--GetFirePoint
		end
	end
	return t_ccp_;
end


function  cannonmanager:Switch( chair_id, bullet_kind)
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
end

function  cannonmanager:GetCurrentBulletKind(chair_id)
       if (chair_id >=_local_player_num_I)  then return 0; end
       return self.current_bullet_kind_[chair_id];
end
function  cannonmanager:Fire( chair_id,  bullet_kind)
    if (chair_id >=_local_player_num_I)  then return; end
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	if (t_cannon_base_node) then 	
		local t_game_player = t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then 	t_game_player:Fire(self.m_fFireAngle[chair_id]);end
	end
end
--function  cannonmanager:Fire( chair_id)
--   self:Fire(chair_id, self.current_bullet_kind_[chair_id])
--end
function  cannonmanager:SetFishScore( chair_id,  swap_fish_score)
        if(chair_id >=_local_player_num_I)  then return; end
        self.fish_score_[chair_id] = swap_fish_score;
		local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node)then
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player)	then
				t_game_player:SetScoreNum(swap_fish_score);
			end
		end
end
function  cannonmanager:ResetFishScore( chair_id)
        if(self.fish_score_[chair_id]==nil) then self.fish_score_[chair_id]=0;end
        self.fish_score_[chair_id] =0;
	    self:SetFishScore(chair_id,self.fish_score_[chair_id]);
        self:SetPlayer_Type(chair_id,4);
end
function  cannonmanager:Reset_IdleTimer( chair_id) self.m_undo_free_timer[chair_id] = 0; end
function  cannonmanager:GetFishScore( chair_id)
    if(chair_id >=_local_player_num_I)  then return; end
    if(self.fish_score_[chair_id]==nil) then self.fish_score_[chair_id]=0;end
    return  self.fish_score_[chair_id];
end
function  cannonmanager:SetOnlineState( state,  chairID)
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
function  cannonmanager:SetUserName( chair_id,name_str)
        local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 
			local t_game_player = t_cannon_base_node:getChildByTag(6666);
			if (t_game_player) then t_game_player:SetUserName(name_str, t_flag); end
		end
end
function  cannonmanager:get_score_num_position( local_chair_id)--           //获取分数位置
    if(chair_id >=_local_player_num_I)  then cc.p(0,0); end
    local r_pos = cc.p(0, 0);
    local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
    if (t_cannon_base_node) then 	
		local t_game_player = t_cannon_base_node:getChildByTag(6666);
		if (t_game_player) then r_pos = t_game_player:getScoreNumPos(); end
	end
	return r_pos;
end

function  cannonmanager:get_double_card_position( local_chair_id)--           //获取双倍子弹等卡片位置
    local  r_pos = cc.p(0, 0);
	if (local_chair_id >=_local_player_num_I) then  return r_pos; end
	local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
	if (t_cannon_base_node) then 
        local px,py=t_cannon_base_node:getChildByTag(78):getPosition();
		r_pos =cc.p(px,py);
		r_pos = t_cannon_base_node:convertToWorldSpace(r_pos);
	end
	return r_pos;
end
function  cannonmanager:get_lock_card_position( local_chair_id)           -- //获取锁定卡片位置
    local  r_pos = cc.p(0, 0);
	if (local_chair_id >=_local_player_num_I) then  return r_pos; end
	local t_cannon_base_node = self:getChildByTag(9999 + local_chair_id);
	if (t_cannon_base_node) then	
		r_pos = t_cannon_base_node:getChildByTag(79):getPosition();
		r_pos = t_cannon_base_node:convertToWorldSpace(r_pos);
	end
	return r_pos;
end
function  cannonmanager:get_Stack_position( local_chair_id)                -- //获取金币堆的位置
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

function  cannonmanager:Connon_Rot( local_chair_id,  add_num)--                //旋转炮管
end
function  cannonmanager:Check_angle_( local_chair_id)
end
function  cannonmanager:Check_Online( local_chair_id)  return self.m_onlineState[local_chair_id]; end
function  cannonmanager:SetPlayer_Type( local_chair_id, palyer_type )--//设置玩家类型
           if (local_chair_id >=_local_player_num_I) then  return ;end;
           local t_cannon_base_node =self:getChildByTag(9999 + local_chair_id);
           if(palyer_type) 
           then  cclog("cannonmanager:SetPlayer_Type( palyer_type=%d)", palyer_type); 
           else
              if(t_cannon_base_node) then t_cannon_base_node:removeChildByTag(198204); end
             return ;
           end
			if (t_cannon_base_node) then 
                t_cannon_base_node:removeChildByTag(198204);
                if(palyer_type) then 
                     if (palyer_type == 0) then --手机				
							local t_ico_node =cc.Sprite:create("qj_animal/res/game_res/phoneinfo.png");   
							if (t_ico_node) then 							
								t_cannon_base_node:addChild(t_ico_node, 10086, 198204);
                                t_ico_node:setRotation(_local_info_array_[local_chair_id].default_angle);
								t_ico_node:setScale(0.6);
								t_ico_node:setPosition(ccp(90, -20));
							end
				      elseif (palyer_type == 1) then --街机			
							local t_ico_node =cc.Sprite:create("qj_animal/res/game_res/jiejiinfo.png");
							if (t_ico_node) then 						
								t_cannon_base_node:addChild(t_ico_node, 10086, 198204);
                                t_ico_node:setRotation(_local_info_array_[local_chair_id].default_angle);
								t_ico_node:setScale(0.6);
								t_ico_node:setPosition(ccp(90, -20));
							end
			      	end
                end
		end
end

function  cannonmanager:Catch_Baoxiang( ChairID,  num,  alivePos)--  //捕获宝箱

end
function  cannonmanager:Catch_BaoxiangEnd( ChairID,  num)--                    //宝箱任务完成
end

function  cannonmanager:Ion_Double_Start( chair_id,  startpos, timerLength )

    if (chair_id < cc.exports._local_player_num_I) then 
		self.m_double_flag[chair_id] = 1;
		self.m_double_timer[chair_id] = timerLength;
		local t_cannon_base_node =self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 
			t_cannon_base_node:removeChildByTag(1237758);
			--//添加卡片
			local t_double_card = cc.Sprite:create("qj_animal/res/game_res/cannon/card_ionEx.png");		
			if (t_double_card) then 		
				local t_alivePos = t_cannon_base_node:convertToNodeSpace(startpos);
				t_double_card:setPosition(t_alivePos);
                local function removecall_func(args)
                    t_double_card:removeFromParent();
                 end
				--//飞回炮塔
				local  t_end_pos = cc.p(-120,60);
				local t_dis =cc.pGetDistance(t_alivePos,t_end_pos);-- t_alivePos:getDistance(t_end_pos);
				local t_mov_tim = t_dis / 1500.0;
				local t_delay = cc.DelayTime:create(0.2);
				local t_mov_to = cc.MoveTo:create(t_mov_tim,t_end_pos);
				local t_delay_ = cc.DelayTime:create(timerLength);
				local t_call_remov = cc.CallFunc:create(removecall_func);
				local t_seq = cc.Sequence:create(t_delay, t_mov_to, t_delay_, t_call_remov, nil);
				t_double_card:runAction(t_seq);
				--//添加倒计时
				local t_char=string.format("%d", timerLength);
				local t_spr_num_ = cc.LabelAtlas:create(t_char,"qj_animal/res/game_res/cannon/DoubleEffectNumber.png", 22, 26,48);--//数字 倒计时
				if (t_spr_num_) then 
				
					t_spr_num_:setAnchorPoint(cc.p(0.5, 0.5));
					t_spr_num_:setPosition(cc.p(40, 60));
					t_double_card:addChild(t_spr_num_,11,99);
				end
				t_cannon_base_node:addChild(t_double_card, 100000, 1237758);
			end		
		end
		local current_bullet_mulriple_ =self:GetCannonMulriple(chair_id);
		local current_bullet_kind_ =self:GetCurrentBulletKind(chair_id);
		if (current_bullet_mulriple_ < 100)                                       	then  current_bullet_kind_ = 4;
		elseif (current_bullet_mulriple_ >= 100 and current_bullet_mulriple_ < 1000) then current_bullet_kind_ = 5;
		elseif (current_bullet_mulriple_ >= 1000 and current_bullet_mulriple_ < 5000) then current_bullet_kind_ = 6;
		else                                                                          current_bullet_kind_ = 7;
        end
		self:Switch(chair_id, current_bullet_kind_);
	end
end
--]]
function  cannonmanager:Ion_Double_Stop(chair_id)
	if (chair_id < _local_player_num_I)   then
		self.m_double_flag[chair_id] = 0;
		self.m_double_timer[chair_id] = 0;
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 	t_cannon_base_node:removeChildByTag(1237758);end
		local current_bullet_mulriple_ = self:GetCannonMulriple(chair_id);
		local current_bullet_kind_ = self:GetCurrentBulletKind(chair_id);
		if (current_bullet_mulriple_ < 100)                                       	 then  current_bullet_kind_ = 0;
		elseif (current_bullet_mulriple_ >= 100 and current_bullet_mulriple_ < 1000) then current_bullet_kind_ = 1;
		elseif (current_bullet_mulriple_ >= 1000 and current_bullet_mulriple_ < 5000)then current_bullet_kind_ = 2;
		else                                                                         current_bullet_kind_ = 3;
        end
		self:Switch(chair_id, current_bullet_kind_);
	end
    
end

function  cannonmanager:Ion_Double_UpdateTimer( chair_id, timer)
	if (chair_id < _local_player_num_I and timer>0) then 	
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 
			local t_double_card = t_cannon_base_node:getChildByTag(1237758);
			if (t_double_card) then 		
				local t_spr_num_ =t_double_card:getChildByTag(99);
				if (t_spr_num_)then 	t_spr_num_:setString(timer);
				end
			end
		end
	end
end

--免费子弹
function  cannonmanager:Ion_free_Start( chair_id,  startpos,  bulleNum)
	if (chair_id >=_local_player_num_I)  then return end;
	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
	self.m_free_Flag[chair_id]=1;     --//免费子弹标记
	self.m_freeTimer[chair_id] = 30;    -- //免费子弹标记
	self.m_free_bulletNum[chair_id] = bulleNum;--//剩余免费子弹数 
	if (t_cannon_base_node) then 	
		t_cannon_base_node:removeChildByTag(1237760);
		local t_Free_card = cc.Sprite:create("qj_animal/res/game_res/cannon/freecardcard_ionEx.png");		--//添加卡片
		if (t_Free_card) then 
			local t_alivePos = t_cannon_base_node:convertToNodeSpace(startpos);
			t_Free_card:setPosition(t_alivePos);
            local function remove_call_func()
                  t_Free_card:removeFromParent();
            end
			--//飞回炮塔
			local t_end_pos = ccp(-120,60);
			local t_dis =cc.pGetDistance(t_alivePos,t_end_pos);-- t_alivePos.getDistance(t_end_pos);
			local t_mov_tim = t_dis / 1500.0;
			local t_delay = cc.DelayTime:create(0.2);
			local t_mov_to = cc.MoveTo:create(t_mov_tim, t_end_pos);
			local t_delay_ = cc.DelayTime:create(30);
			local t_call_remov = cc.CallFunc:create(remove_call_func);
			local t_seq = cc.Sequence:create(t_delay, t_mov_to, t_delay_, t_call_remov, nil);
			t_Free_card:runAction(t_seq);
			--//添加倒计时
			local t_char=string.format("%d", bulleNum);
			local t_spr_num_ = cc.LabelAtlas:create(t_char, "qj_animal/res/game_res/cannon/DoubleEffectNumber.png", 22, 26, 48);
			if (t_spr_num_) then 		
				t_spr_num_:setAnchorPoint(cc.p(0.5, 0.5));
				t_spr_num_:setPosition(cc.p(40, 60));
				t_Free_card:addChild(t_spr_num_, 11, 99);
			end
			t_cannon_base_node:addChild(t_Free_card, 100000, 1237760);
		end
	end
	local current_bullet_mulriple_ = self:GetCannonMulriple(chair_id);
	local current_bullet_kind_ = self:GetCurrentBulletKind(chair_id);
	if (current_bullet_mulriple_ < 100)                                       	 then current_bullet_kind_ = 8;
	elseif (current_bullet_mulriple_ >= 100 and current_bullet_mulriple_ < 1000)  then current_bullet_kind_ = 9;
	elseif (current_bullet_mulriple_ >= 1000 and current_bullet_mulriple_ < 5000) then current_bullet_kind_ = 10;
	else                                                                         current_bullet_kind_ = 11; end
	self:Switch(chair_id, current_bullet_kind_);
end
function  cannonmanager:Ion_free_Stop( chair_id)
       self.m_free_Flag[chair_id]=0;     --//免费子弹标记
	   self.m_freeTimer[chair_id] = 0;    -- //免费子弹标记
	   self.m_free_bulletNum[chair_id] = 0;--//剩余免费子弹数

    	local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 	t_cannon_base_node:removeChildByTag(1237760);end
		local current_bullet_mulriple_ = self:GetCannonMulriple(chair_id);
		local current_bullet_kind_ = self:GetCurrentBulletKind(chair_id);
		if (current_bullet_mulriple_ < 100)                                       	 then  current_bullet_kind_ = 0;
		elseif (current_bullet_mulriple_ >= 100 and current_bullet_mulriple_ < 1000) then current_bullet_kind_ = 1;
		elseif (current_bullet_mulriple_ >= 1000 and current_bullet_mulriple_ < 5000)then current_bullet_kind_ = 2;
		else                                                                         current_bullet_kind_ = 3;
        end
		self:Switch(chair_id, current_bullet_kind_);
end
function  cannonmanager:Ion_Set_Free_BulletNum( chair_id,  num)
       if (chair_id < _local_player_num_I and num>0) then 	
		local t_cannon_base_node = self:getChildByTag(9999 + chair_id);
		if (t_cannon_base_node) then 
			local t_double_card = t_cannon_base_node:getChildByTag(1237760);
			if (t_double_card) then 		
				local t_spr_num_ =t_double_card:getChildByTag(99);
				if (t_spr_num_)then 	t_spr_num_:setString(num);
				end
			end
		end
	 end
end
function  cannonmanager:Ion_Sub_Free_Bullet( chair_id)
  self.m_free_bulletNum[chair_id]=self.m_free_bulletNum[chair_id]-1;
  Ion_Set_Free_BulletNum( chair_id,  self.m_free_bulletNum[chair_id])
end

return cannonmanager;
--endregion

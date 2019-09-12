-- region NewFile_1.lua
-- Author : Administrator
-- Date   : 2017/4/22
-- 此文件由[BabeLua]插件自动生成

local Dianci_Bullet = class("Dianci_Bullet",
function()
    return cc.Node:create()
end
)
function Dianci_Bullet:ctor(bullet_id, bullet_mulriple, arm_mul, arm_score, chair_id, StartPos, angle)
    self:Init();
    if (angle >= 360) then angle = angle - 360; end
    if (angle < 0) then angle = angle + 360; end
    self.m_AliveStep = 0;
    self.m_alive_timer = 0;
    self._ReboundBulletTime=0;
    self.m_bulletID = bullet_id;
    self.m_bullet_Mul = bullet_mulriple;
    self.m_arm_mul = arm_mul;
    self.m_arm_score = arm_score;
    self.m_arm_chair_id = chair_id;
    self.m_angle = angle;
    self.m_start_pos = cc.p(StartPos.x, StartPos.y);
    ------------------------激光动画
    -----------------------------------
    local file_name = "";
    local _sprite = nil;
    local readIndex = 0;
    local animation = cc.Animation:create();
    local i = 0;
    for i = 0, 27, 1 do
        file_name = string.format("~DianCiPaoAttackEff_000_%03d.png", i);
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
        if (frame) then
            local offset_name = string.format("DianCiPaoAttackEff_000_%03d.png", i);
            local t_offset_ = cc.p(0, 0);
            local t_offect_str = cc.exports.OffsetPointMap[offset_name].Offset;
            local t_s_sub_x, t_s_sub_y = string.find(t_offect_str, ",");
            local t_x = string.sub(t_offect_str, 0, t_s_sub_x - 1);
            local t_y = string.sub(t_offect_str, t_s_sub_y + 1, #t_offect_str);
            local t_offeset_pos = cc.p(0, 0);
            local t_offset_0 = frame:getOffsetInPixels();
            t_offset_.x = t_x / 2;
            -- t_offset_.x * 10/ 20;
            t_offset_.y = - t_y / 2;
            -- t_offset_.y * 10/ 20;
            frame:setOffsetInPixels(t_offset_);
            if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
            readIndex = readIndex + 1;
            animation:addSpriteFrame(frame);
        end
        -- 	if (frame)
    end
    -- for
    if (readIndex > 0) then
        local function this_call_back()
            self:StartActionCallback();
        end
        animation:setDelayPerUnit(1 / 24.0);
        local action = cc.Animate:create(animation);
        local t_CCFadeIn = cc.FadeIn:create(0.1);
        local t_CCRepeat = cc.Repeat:create(action, 1);
        local funcall = cc.CallFunc:create(this_call_back);
        local seq = cc.Sequence:create(t_CCFadeIn, t_CCRepeat, funcall, nil);
        _sprite:runAction(seq);
    end
    if (_sprite) then
        _sprite:setPosition(self.m_start_pos);
        _sprite:setRotation(self.m_angle);
        _sprite:setAnchorPoint(cc.p(0.42, 0.08));
        _sprite:setScale(5.0);
        self:addChild(_sprite, 0, 10086);
    end
    -------------------------------------------------
    local function handler(interval)
        self:update(interval);
    end
    self:scheduleUpdateWithPriorityLua(handler, 0);
    -- 
end
function Dianci_Bullet:Init()
    self.g_dianci_HirR = 260;
    self.m_AliveStep = 0;
    -- //进度
    self.m_alive_timer = 0;
    -- //定时器
    self.m_bulletID = 0;
    self.m_bullet_Mul = 0;
    self.m_arm_mul = 0;
    self.m_arm_score = 0;
    self.m_arm_chair_id = 0;
    self.m_angle = 0;
    self.m_start_pos = cc.p(0, 0);
    --
end

function Dianci_Bullet:update(dt)
    if(dt>0.04) then dt=0.04; end;
    self.m_alive_timer = self.m_alive_timer + dt;
    if (self.m_AliveStep == 0 and self.m_alive_timer > 0.9)
    then
        self.m_AliveStep = 1;
        if (cc.exports.g_pFishGroup) then
            -- 检测碰撞	
            cc.exports.g_pFishGroup:DianciBom(self.m_start_pos, self.g_dianci_HirR, self.m_arm_chair_id, self.m_arm_mul, self.m_bullet_Mul, self.m_bulletID, self.m_angle, 0);
        end
    end
end
function Dianci_Bullet:get_dianci_HitR()
  return self.g_dianci_HirR;
end
function Dianci_Bullet:StartActionCallback()
    -- //开始动画
    self:removeAllChildren();
    -- 播放特效
    cc.exports.game_manager_:ShakeScreen();
    -- BG
    local file_name = "";
    local _sprite = nil;
    local readIndex = 0;
    local animation = cc.Animation:create();
    local i = 0;
    for i = 0, 20, 1 do
        file_name = string.format("~DianCiPaoAttackEff_001_%03d.png", i);
        local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
        if (frame) then
            local offset_name = string.format("DianCiPaoAttackEff_001_%03d.png", i);
            local t_offset_ = cc.p(0, 0);
            local t_offect_str = cc.exports.OffsetPointMap[offset_name].Offset;
            local t_s_sub_x, t_s_sub_y = string.find(t_offect_str, ",");
            local t_x = string.sub(t_offect_str, 0, t_s_sub_x - 1);
            local t_y = string.sub(t_offect_str, t_s_sub_y + 1, #t_offect_str);
            local t_offeset_pos = cc.p(0, 0);
            local t_offset_0 = frame:getOffsetInPixels();
            t_offset_.x = t_x / 2;
            -- t_offset_.x * 10/ 20;
            t_offset_.y = - t_y / 2;
            -- t_offset_.y * 10/ 20;
            frame:setOffsetInPixels(t_offset_);
            if (readIndex == 0) then _sprite = cc.Sprite:createWithSpriteFrameName(file_name); end
            readIndex = readIndex + 1;
            animation:addSpriteFrame(frame);
        end
        -- if (frame) then
    end
    -- for
    if (readIndex > 0) then
        local function action_call_back()
            self:RunActionCallback();
        end
        animation:setDelayPerUnit(1 / 24.0);
        local action = cc.Animate:create(animation);
        local t_CCFadeIn = cc.FadeIn:create(0.1);
        local t_CCRepeat = cc.Repeat:create(action, 3);
        local funcall = cc.CallFunc:create(action_call_back);
        local seq = cc.Sequence:create(t_CCFadeIn, t_CCRepeat, funcall, nil);
         _sprite:setOpacity(0);
        _sprite:runAction(seq);
    end
    if (_sprite) then
        _sprite:setPosition(self.m_start_pos);
        _sprite:setRotation(self.m_angle);
        _sprite:setAnchorPoint(cc.p(0.42, 0.08));
        _sprite:setScaleX(5);
        _sprite:setScaleY(5);
        self:addChild(_sprite, 0, 10086);
    end
    --
end
function Dianci_Bullet:RunActionCallback() --//过程动画
    self:removeAllChildren();
	---BG
	local file_name ="";
	local _sprite = nil;
	local readIndex = 0;
	local animation = cc.Animation:create();
    local i=0;
	for  i = 0,20, 1 do
                file_name=string.format("~DianCiPaoAttackEff_002_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then						
				    local offset_name=string.format("DianCiPaoAttackEff_002_%03d.png", i);
					local t_offset_ = cc.p(0, 0);
                    local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                    local t_s_sub_x,t_s_sub_y=string.find(t_offect_str, ",");
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
			 end --end frame
		end --for
		if (readIndex > 0)then
           local function call_back_()
                  self:EndCallBack();
            end
			animation:setDelayPerUnit(1/12.0);		 
		   local action =cc.Animate:create(animation);  
			local t_CCFadeIn =cc.FadeIn:create(0.1);
			local t_CCRepeat=cc.Repeat:create(action, 1);
			local t_CCFadeOut=cc.FadeOut:create(0.2);
			local funcall = cc.CallFunc:create(call_back_);
			local seq = cc.Sequence:create(t_CCFadeIn, t_CCRepeat, t_CCFadeOut,funcall, nil);
            _sprite:setOpacity(0);
			_sprite:runAction(seq);
		end
		if (_sprite)then
			_sprite:setPosition(self.m_start_pos);
			_sprite:setAnchorPoint(cc.p(0.42, 0.08));
			_sprite:setScaleX(5);
			_sprite:setScaleY(5);
			_sprite:setRotation(self.m_angle);
			self:addChild(_sprite, 0, 10086);
		end
end
function Dianci_Bullet:EndCallBack()         --//结束动画回调
	--通知关闭电磁炮
	cc.exports.g_cannon_manager:Exit_Dianci(self.m_arm_chair_id);
    self:removeFromParent();
end
function Dianci_Bullet:GetPos() return self.m_start_pos; end
return Dianci_Bullet;

--endregion

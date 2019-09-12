--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--必杀弹管理类
local GuidedMissile_Bullet_Manager = class("GuidedMissile_Bullet_Manager",
 function()
	return cc.Node:create()
end
)
function GuidedMissile_Bullet_Manager:ctor()
   cc.exports.g_GuidedMissile_Bullet_Manager=self;
end
function  GuidedMissile_Bullet_Manager:Alive_GuidedMissile_Bullet( bullet_id,  bullet_mulriple,  arm_mul,  arm_score,   chair_id,  StartPos,  angle)--//添加穿甲弹
	 self:removeChildByTag(bullet_id);
	local t_Dianci_Bullet = GuidedMissile:create(bullet_id, bullet_mulriple, arm_mul, arm_score, chair_id, StartPos, angle);
	if (t_Dianci_Bullet) then self:addChild(t_Dianci_Bullet, 0, bullet_id); end
end

function GuidedMissile_Bullet_Manager:RemovAll()
	self:removeAllChildren();
end
function  GuidedMissile_Bullet_Manager:RemovbyId( bulletID)
	self:removeChildByTag(bulletID);
end
return GuidedMissile_Bullet_Manager;


--endregion

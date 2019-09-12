--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/22
--此文件由[BabeLua]插件自动生成

local Broach_Bullet_Manager = class("Broach_Bullet_Manager",
 function()
	return cc.Node:create()
end
)

function Broach_Bullet_Manager:ctor()
       cc.exports.g_Broach_Bullet_Manager=self;
end
function Broach_Bullet_Manager:GetBulletTotalNum()
 local childCount = self:getChildrenCount();
 return  childCount;
end
function Broach_Bullet_Manager:Alive_Broach_Bullet( bullet_id,  bullet_mulriple,  arm_mul,  arm_score,  chair_id,  StartPos,  angle)--添加穿甲弹
    self:removeChildByTag(bullet_id);
	local t_Broach_Bullet =Broach_Bullet.new(bullet_id, bullet_mulriple, arm_mul, arm_score, chair_id, StartPos, angle);
	self:addChild(t_Broach_Bullet, 0, bullet_id);
end
function Broach_Bullet_Manager:RemovAll()
   self:removeAllChildren();
end
function Broach_Bullet_Manager:RemovbyId( bulletID)
    self:removeChildByTag(bulletID);
end
return Broach_Bullet_Manager;


--endregion

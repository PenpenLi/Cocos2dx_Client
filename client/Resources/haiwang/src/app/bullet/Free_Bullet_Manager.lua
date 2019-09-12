--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--免费子弹管理类
local Free_Bullet_Manager = class("Free_Bullet_Manager",
 function()
	return cc.Node:create()
end
)

function Free_Bullet_Manager:ctor()
    cc.exports.g_Free_Bullet_Manager=self;
end

function Free_Bullet_Manager:FreeAllBullet( bullet)
	if (self:getChildrenCount() > 0) then 
	   local pChildren =self:getChildren();
       local i=0;
		for i=#pChildren,0,-1 do
				local bullet = pChildren[i];
				if (bullet ) then 
                          if(bullet:getbom_flag()>0)  then self:removeChild(bullet);  
                          else 
                             local t_pos=bullet:get_mov_pos();
                             if(t_pos.x<-20 or t_pos.y<-20 or t_pos.x>1300 or t_pos.y>740) then self:removeChild(bullet); end
                       end --if(bullet:getbom_flag()>0)
                end             --	if (bullet ) then    
		end  --	for i=#pChildren,0,-1 do
	end --	if (self:getChildrenCount() > 0) then 
end
function Free_Bullet_Manager:GetBulletTotalNum()
    local childCount = self:getChildrenCount();
    return  childCount;
end
 function Free_Bullet_Manager:getbullet_total_count()
   return self:getChildrenCount();
 end
function Free_Bullet_Manager:Alive_Free_Bullet( bullet_id,  bullet_mulriple, arm_mul,  arm_score,  chair_id,  StartPos,  angle,  locak_id)--添加穿甲弹
    self:removeChildByTag(bullet_id);
	local t_Dianci_Bullet = Free_Bullet.new(bullet_id, bullet_mulriple, arm_mul, arm_score, chair_id, StartPos, angle, locak_id);
	self:addChild(t_Dianci_Bullet, 0, bullet_id);
end

function Free_Bullet_Manager:RemovAll()
 self:removeAllChildren();
end

function Free_Bullet_Manager:RemovbyId( bulletID)
self:removeChildByTag(bulletID);
end
return Free_Bullet_Manager;

--endregion

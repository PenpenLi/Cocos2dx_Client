--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--子弹管理类

local bulletmanager = class("bulletmanager",
 function()
	return cc.Node:create()
end
)
function bulletmanager:ctor()
            self:init();
            cc.exports.g_Bullet_Manager=self;
            cc.exports.g_game_player_bullet_num_list={[0]=0,0,0,0,0,0,0,0,0,0,0}
end

function bulletmanager:init()
   local spriteFrame  = cc.SpriteFrameCache:getInstance();  
   spriteFrame:addSpriteFrames("haiwang/res/HW/bulletEx.plist");
   local i=0;
   for i=0,20,1 do
     cc.exports.g_offsetBullet_InitFlag[i]=0;
   end
end
function bulletmanager:FreeAllBullet( bullet)
     cc.exports.g_game_player_bullet_num_list={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0}
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

function bulletmanager:FreeBullet( bullet)
  if (bullet) then self:removeChildByTag(bullet:bullet_id()); end
	return false;
end
function bulletmanager:Fire( src_x_pos,  src_y_pos,  angle,  bullet_kind,  bullet_id,  bullet_mulriple,  firer_chair_id, bullet_speed,  net_radius,  lock_fishid)
	if (firer_chair_id >= GAME_PLAYER) then  return 0; end
    if (firer_chair_id <0) then  return 0; end
    if(cc.exports.g_game_player_bullet_num_list[firer_chair_id]>35)then  return 0; end
  --  cclog(" bulletmanager:Fire x_=%f,y=%f, angle=%f,kind=%d,id=%d,mulriple=%d,chair_id=%d,speed=%f,radius=%f,fishid=%d",
  --  src_x_pos,  src_y_pos,  angle,  bullet_kind,  bullet_id,  bullet_mulriple,  firer_chair_id, bullet_speed,  net_radius,  lock_fishid);
	self:removeChildByTag(bullet_id);
    
	local bullet =cc.exports.Bullet.new(bullet_kind, bullet_id, bullet_mulriple, firer_chair_id, net_radius, cc.p(src_x_pos, src_y_pos), bullet_speed, angle, lock_fishid);
	if (nil==bullet) then return -1; 
	else self:addChild(bullet, 0, bullet_id);
    end
	return bullet_id;
end
function bulletmanager:GetBullet( bulletID)--检测子弹是否存在
    local bullet_info = self:getChildByTag(bulletID);
	if (bullet_info~=nil) then return true; end
	return false;
end
function bulletmanager:GetBulletTotalNum()
 local childCount = self:getChildrenCount();
 return  childCount;
end
function bulletmanager:GetBulletNum( chairID)--获取座位子弹数
    local  tem_me_bulletNum = 0;
      if(chairID>=0 and chairID<10) then tem_me_bulletNum= cc.exports.g_game_player_bullet_num_list[chairID] end
    --[[
     local childCount = self:getChildrenCount()
    if (childCount > 1)then 
		local pChildren = self:getChildren();
		if (#pChildren> 0)then
			local i=0;
			for i=1,#pChildren, 1 do	
				local  bullet_info = pChildren[i];
				if (bullet_info~=nil and bullet_info:getChair_id() == chairID and bullet_info:getAliveTimer()<60 and bullet_info:getbom_flag()==0 )then
					tem_me_bulletNum=tem_me_bulletNum+1;
			  end
			end
		end
	end
    --]]
	return tem_me_bulletNum;
end
 function bulletmanager:getbullet_total_count()
   return self:getChildrenCount();
 end
function bulletmanager:GetUserBulletCount( wChairID)
     return self:GetBulletNum(wChairID);
end
function bulletmanager:GetChairIDByBulletID( bulletID)
    local  bullet_info = self:getChildByTag(bulletID);
	if (bullet_info~=nil) then   return bullet_info:firer_chair_id();   end
	return -1;
end
function bulletmanager:get_local_chair_ID( bulletID)    --获取本地椅子号
   local  bullet_info = self:getChildByTag(bulletID);
	if (bullet_info~=nil) then  return bullet_info:firer_chair_id(); end
	return -1;
end

return bulletmanager;

--endregion

--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--此文件由[BabeLua]插件自动生成

local lock_fish_manager = class("lock_fish_manager",
 function()
	return cc.Node:create()
end
)
function lock_fish_manager:ctor()
      self:init();
      cc.exports.g_lock_fish_manager=self;
       local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
end
  function lock_fish_manager:update( delta_time)
   if(delta_time>0.04) then delta_time=0.04; end;
    local i=0;
    local cannon_manager=cc.exports.g_cannon_manager;
    for i = 0,GAME_PLAYER,1 do
       if (self.palyer_spr_Node[i]) then 
            if (self.lock_fish_id_[i] <= 0 or self.lock_fish_kind_[i] == FISH_KIND_COUNT) then
				self.palyer_spr_Node[i]:removeAllChildren();
			else 
                local  cannon_pos = cannon_manager:GetCannonPos(i,0);
                local  LockFlag_pos =cc.p(0,0);
                LockFlag_pos=self:LockPos(i);
                local angle = math.atan2(LockFlag_pos.x-cannon_pos.x, LockFlag_pos.y-cannon_pos.y);
                cannon_manager:SetCurrentAngle(i, angle);
                local t_flagspr =self.palyer_spr_Node[i]:getChildByTag(11);--图标
				if (t_flagspr == nil)	then
					tem_flag_char=string.format("~TrackFlagList2_%02d_000_000.png",i+1);
					t_flagspr = cc.Sprite:createWithSpriteFrameName(tem_flag_char);
					self.palyer_spr_Node[i]:addChild(t_flagspr, 10, 11);
				end
                if (t_flagspr~=nil) then  	t_flagspr:setPosition(LockFlag_pos);	end
                local t_sprLine = self.palyer_spr_Node[i]:getChildByTag(22);--线
				if (t_sprLine == nil) then
					t_sprLine = cc.Sprite:create("haiwang/res/HW/~TrackLine_000_000.png");
					t_sprLine:setAnchorPoint(cc.p(0, 0.5));
					t_sprLine:setPosition(cannon_pos);
					self.palyer_spr_Node[i]:addChild(t_sprLine, 10, 22);
				end
				if (t_sprLine)then
					t_sprLine:setRotation(math.deg(angle)-90);
                    local dis_x=cannon_pos.x-LockFlag_pos.x;
                    local dis_y=cannon_pos.y-LockFlag_pos.y;
					local tem_dis_length =math.sqrt(dis_x*dis_x+dis_y*dis_y) ;--LockFlag_pos.getDistance(cannon_pos);
					t_sprLine:setTextureRect(cc.rect(0, 0, tem_dis_length, 6));
				end
            end
       end
	end
  end
  function lock_fish_manager:GetLockFishID( chair_id) 
   --   cclog("lock_fish_manager:GetLockFishID chair_id=%d,lock_fish_id=%d",chair_id,  self.lock_fish_id_[chair_id]);
     if(self.lock_fish_id_[chair_id]==nil) then return -1; end
     return self.lock_fish_id_[chair_id]; 
   end
  function lock_fish_manager:GetLockFishKind( chair_id)  
      if(self.lock_fish_kind_[chair_id]==nil) then return -1; end
     return self.lock_fish_kind_[chair_id];
   end
  function lock_fish_manager:SetLockFishID( chair_id,  lock_fish_id)
    -- cclog("lock_fish_manager:SetLockFishID chair_id=%d,lock_fish_id=%d",chair_id,  lock_fish_id);
     self.lock_fish_id_[chair_id] = lock_fish_id; 
      self.lock_fish_kind_[chair_id]=FISH_KIND_COUNT;
      local fish=cc.exports.g_pFishGroup:GetFish(lock_fish_id);
      if(fish~=nil) then self.lock_fish_kind_[chair_id]=fish:fish_kind(); end;
  end
  function lock_fish_manager:UpdateLockTrace( chair_id,  fish_pos_x,  fish_pos_y)
  end
  function lock_fish_manager:ClearLockTrace( chair_id)
     self.lock_fish_id_[chair_id] = 0;
	 self.lock_fish_kind_[chair_id] = FISH_KIND_COUNT;
  end
  function lock_fish_manager:LockPos( chair_id)
  local pos =cc.p(0,0);
	if (self.lock_fish_id_[chair_id]>0)then 
		if (cc.exports.g_pFishGroup) then 
			local t_fish=cc.exports.g_pFishGroup:GetFish(self.lock_fish_id_[chair_id]);
			if (t_fish) then 
                 local x,y = t_fish:GetFishccpPos(); 
                  pos=cc.p(x,y);
            end
       end
	end
	return pos;
  end
  function lock_fish_manager:init()
       local i=0;
       self.lock_fish_id_={};
       self.lock_fish_kind_={};
       self.palyer_spr_Node={};
       for  i = 0, GAME_PLAYER,1 do		
			self.lock_fish_id_[i] = 0;
			self.lock_fish_kind_[i] = FISH_KIND_COUNT;
			self.palyer_spr_Node[i] = cc.Node:create();
			if (self.palyer_spr_Node[i]) then self:addChild(self.palyer_spr_Node[i],1, i+1); end
		end	
        local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
  end

return lock_fish_manager;
--endregion

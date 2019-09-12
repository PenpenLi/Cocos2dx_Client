--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--此文件由[BabeLua]插件自动生成

local gamefishmanager = class("gamefishmanager",
 function()
	return cc.Node:create()
end
)

 function  gamefishmanager:update(dt)
 --[[
  self.test_timer=self.test_timer+dt;
  if(self.test_timer>1) then
    self.test_timer=0;
    cclog("ChildrenCount fishmanger(%d) bulletmanager(%d),Free_Bullet_Manager(%d)fishlayer(%d)",
    self:getChildrenCount(),cc.exports.g_Bullet_Manager:getbullet_total_count(),cc.exports.g_Free_Bullet_Manager:getbullet_total_count(),fishlayer:getChildrenCount());
  end
  --]]
   --if(dt>0.04) then dt=0.04; end;
   if (self:getChildrenCount() > 0)then
       if(self:getChildrenCount()>400) then self:FreeAllFish();end
       local lock_fish_manager=cc.exports.g_lock_fish_manager;
       local game_manager_=cc.exports.game_manager_;
       local switch_lock = false;
       local pChildren =self:getChildren();
       local me_chair_id=game_manager_:getMeChairID();
       local index = 0
        for index = #pChildren,0,-1 do
           local fish=pChildren[index];
           if(fish) then
                    if (fish:OnFrame(dt)==true)then
                           if (fish:fish_kind() == 27) then self.g_EYU_AliveFlag = 0;
                           elseif (fish:fish_kind() == 28) then self.g_fishSuperCrab_AliveNum=self.g_fishSuperCrab_AliveNum-1;
                           elseif (fish:fish_kind() == 29) then  self.g_FishBigDengLong_AliveFlag=0;  end
                           local i=0;
                           for i = 0, GAME_PLAYER,1 do
                              if (lock_fish_manager:GetLockFishID(i) == fish:fish_id()) then
                                   lock_fish_manager:ClearLockTrace(i);
                                   if (i == me_chair_id) then
                                        if(game_manager_:getKeyLockBTState()>0)  then
                                           switch_lock = true;
                                        --cclog("gamefishmanager:update switch_lock=%d ---------------------------------------",switch_lock);
                                         end;
                                   end
                              end  --lock_fish_manager:GetLockFishID(i) == fish:fish_id()
                           end     --for
                           fish:removeFromParent();
						   fish = nil;
                   end
             end
        end
        if(switch_lock==true) then
               -- cclog("gamefishmanager:update(dt) switch_lock==true");
                local lock_fish_kind=self:LockFish(0,FISH_KIND_COUNT);
				lock_fish_manager:SetLockFishID(me_chair_id, lock_fish_kind);
        end
    end
    --]]
 end

function gamefishmanager:ctor()
    self:LoadGameResource();
   --复位参数校对参数
   cc.exports.g_offsetmap_CL_RingFlag=0;
   cc.exports.g_offsetmap_kindxuanfnegnFlag=0;
   cc.exports.g_offsetmap_KKxuanfnegnFlag=0;
   cc.exports.g_offsetmap_CL_pipeFlag=0;
   cc.exports.g_offsetmap_CL_UIFlag=0;
   cc.exports.JumpScoreBG_=0;
   cc.exports.g_offset_ChainEff_Init=0;
   cc.exports.g_offset_ChainRope_Init=0;
   --
   self.test_timer=0;
   self.g_EYU_AliveFlag=0;
   self.g_fishSuperCrab_AliveNum=0;
   self.g_FishBigDengLong_AliveFlag=0;
   local i=0;
   for i=0,60,1 do
     cc.exports.g_offsetmap_InitFlag[i]=0;
     cc.exports.g_offsetmap_InitFlag_D[i]=0;

   end
   --
   local function handler(interval)
         self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
   cc.exports.g_pFishGroup=self;--给全局赋值
end

 function  gamefishmanager:LoadGameResource()
     cclog("gamefishmanager:LoadGameResource");
     local spriteFrame  = cc.SpriteFrameCache:getInstance();

     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishA0.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishA1.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishA2.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishA3.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishA4.plist");

     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB0.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB1.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB2.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB3.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB4.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishB5.plist");

     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC0.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC1.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC2.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC3.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC4.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC5.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC6.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FishC7.plist");

     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/OtherEffect0.plist");
 
     spriteFrame:addSpriteFrames("haiwang/res/HW/fishsub/FullDragon.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/king/king_ui.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/ChainShell/ChainFishIdDigital.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/ChainShell/ChainShellPope.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/turntable/table_catch.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/MryJumpScore/junmScore_winbg.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/BroachCannonCrab/BroachCannon.plist");
      spriteFrame:addSpriteFrames("haiwang/res/HW/BroachCannonCrab/BroachCannonCrab.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/eyuScrew.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/DianCiFish.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/FreeGunFish.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/FreeBullet/FreeGunEffect.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/fist_gun_Effect.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/BombCrabExplose.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/wav_.plist");
     spriteFrame:addSpriteFrames("haiwang/res/HW/lock_line.plist");
    
 end
function  gamefishmanager:SetStatus( nFishKind, dwFishID,FishStatus)
    local  pFishInfo = nil;
	pFishInfo = self:GetFish(dwFishID);
	if (nil==pFishInfo)  then return false; end
    pFishInfo:Set_fish_status(FishStatus);
	return true;
end
function  gamefishmanager:getChainLinkMul( mulself)                                               --获取闪电链倍数
 	    --定个数取
		local  t_mul_num = mulself;
		local t_get_num =1;
		local t_cycle_time = 0;
		local t_sizeofNum = 4 + math.random(0,100) % 5;  --一只为自己本身
        local i=0;
		for i = 16,4,-1 do
			local fish = self:GetFishByKind(i);
			if (fish) then
				t_mul_num= t_mul_num+fish:get_fish_mulriple();
				t_get_num=t_get_num+1;
				if (t_get_num >= t_sizeofNum) then return t_mul_num; end
			 end
		end
		--cclog("CFishGroup::getChainLinkMul t_get_num=%d,t_mul_num=%d\n", t_get_num, t_mul_num);
		return t_mul_num;
end
function  gamefishmanager:getChainLinkMuExl(mul_Num,  mulself,kind_list)               --获取闪电链倍数
	local t_max_Num = 9;
	local t_mul_left = mul_Num - mulself;
	local t_kind_index = 1;
    local i=0;
    local t_catch_list={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
    t_catch_list[0]=kind_list[0];
    if(t_mul_left==0)then _mul_left=10; end
    for  i = 16, 4, -1 do
			if (t_mul_left > 0) then
				local fish = self:GetFishByKind(i);
				if (fish and t_mul_left > fish:get_fish_mulriple())
				then
					t_mul_left = t_mul_left-fish:get_fish_mulriple();
					kind_list[t_kind_index]=fish:fish_kind();
                    t_catch_list[t_kind_index-1]=fish:fish_kind();
					t_kind_index=t_kind_index+1;
					if (t_kind_index >= t_max_Num) then  return t_catch_list; end
					if (t_mul_left <= 0) then return t_catch_list; end--查找完毕
				end
			end
	 end
     if (t_mul_left > 0)	then --找只巨大鱼来填充 有余数
			local fish = self:GetFishByKind(19);
			if (fish==nil)  then fish = self:GetFishByKind(20);end
			if (fish == nil) then  fish = self:GetFishByKind(21); end
			if (fish)
			then
				kind_list[1] = fish:fish_kind();
                t_catch_list[1]=fish:fish_kind();
				t_mul_left = 0;
			end
    end
    if (t_mul_left > 0) then
           local i=0;
			for  i = 4, 0, -1  do
				if (t_mul_left > 0) then
					local fish = self:GetFishByKind(i);
					if (fish and t_mul_left > fish:get_fish_mulriple())
					then
						t_mul_left =t_mul_left- fish:get_fish_mulriple();
						kind_list[t_kind_index] = fish:fish_kind();
                         t_catch_list[t_kind_index-1]=fish:fish_kind();
						t_kind_index=t_kind_index+1;
						if (t_kind_index >= t_max_Num)then   return t_catch_list; end;
						if (t_mul_left <= 0) then   return t_catch_list; end
					end
				end
			end
	end
     return t_catch_list;
end

function gamefishmanager:GetFishTotalNum()
 local childCount = self:getChildrenCount();
 return  childCount;
end
function  gamefishmanager:Catch_fish_King( catch_pos,  kind,  mul,  chair_ID)--返回捕获的倍数
      local  t_catch_mul = 0;
	  local t_catch_mul_max = mul;
      if (self:getChildrenCount() > 0) then
      local pChildren =self:getChildren();
      local i=0;
      for i=0,#pChildren,1  do
          local fish = pChildren[i];
          	if (fish) then
               if (fish:fish_kind() == kind  and fish:IfCanCatchQuick()==true) then
                        local t_fish_mul = fish:get_fish_mulriple();
						if (t_catch_mul_max >t_fish_mul) then
							fish:xuanfengCatch(catch_pos, chair_ID, mul);
							t_catch_mul=t_catch_mul+t_fish_mul;
							t_catch_mul_max= t_catch_mul_max-t_fish_mul;
							if (t_catch_mul_max < t_fish_mul) then t_catch_mul = t_catch_mul+t_catch_mul_max; end
							return t_catch_mul;
						end
               end
            end
      end
    end
end

function   gamefishmanager:ActiveFish( fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startpos,   delay, switch_scene_ )
             -- cclog(" gamefishmanager:ActiveFish");
               --cclog("ActiveFish( fish_kind=%d",fish_kind);
               --[[
             cclog("ActiveFish( fish_kind=%d,  fish_id=%d,  fish_multiple=%d,  fish_speed=%d,  bounding_box_width=%d,  bounding_box_height=%d,  hit_radius=%d,  startpos(%f,%f), delay=%d )"
             ,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startpos.x,startpos.y,   delay);]]
              --if( math.random(100)>50) then fish_kind=24; end

              if(fish_kind==nil or fish_kind<0 or fish_kind>=60) then return nil; end
             local t_Fish=nil;
             if (fish_kind == 22) then
	      	     t_Fish = TurnTableFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind == 23) then
	         	t_Fish = DcJumpScoreFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind == 24) then
	         	t_Fish = DcBroachCannonFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind == 25) then
		        t_Fish = FullScreenDragon.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind == 26) then
	            	t_Fish = InterlinkBombCrab.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind == 27) then
                   if(self.g_EYU_AliveFlag == 0) then
	            	   t_Fish = EYuFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                       self.g_EYU_AliveFlag = 1;
                       cc.exports.game_manager_:BOSSTSLOGO(1);
                  end
              elseif (fish_kind == 28) then
                     if(self.g_fishSuperCrab_AliveNum <2) then
	            	    t_Fish = fishSuperCrab.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                        t_Fish:setLocalZOrder(100);
                        self.g_fishSuperCrab_AliveNum=self.g_fishSuperCrab_AliveNum+1;
                         cc.exports.game_manager_:BOSSTSLOGO(2);
                    end
                elseif (fish_kind == 29) then
                     if( self.g_FishBigDengLong_AliveFlag == 0) then
	            	    t_Fish = FishBigDengLong.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                        t_Fish:setLocalZOrder(100);
                         self.g_FishBigDengLong_AliveFlag=1;
                          cc.exports.game_manager_:BOSSTSLOGO(0);
                    end
              elseif (fish_kind == 30) then
	            	t_Fish = DianCiFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                    t_Fish:setLocalZOrder(-2);
            elseif (fish_kind == 31) then
	            	t_Fish = FreeGunFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                    t_Fish:setLocalZOrder(-2);
            elseif (fish_kind == 32) then
	            	t_Fish = GuidedMissileFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                    t_Fish:setLocalZOrder(-2);
             elseif (fish_kind == 33) then
	                	 t_Fish = JellyFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
                         t_Fish:setLocalZOrder(-1);
            elseif (fish_kind == 34)    then
	          	t_Fish = BaoxiangFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
             elseif (fish_kind >= 35 and fish_kind <= 39) then
	         	  t_Fish = ChainLinkFish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
               elseif (fish_kind >= 40 and fish_kind <= 49) then
		          t_Fish = FishKing_Kind.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              elseif (fish_kind >= 50 and fish_kind <= 59) then
		          t_Fish = FishKing.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
              else
                  t_Fish=Fish.new(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay);
            end
            if(t_Fish) then
               local oo_fish=self:getChildByTag(fish_id);
               if(oo_fish~=nil) then self:removeChild(oo_fish); end
              self:addChild(t_Fish, 0, fish_id);
            end
            return t_Fish;
end
function  gamefishmanager:getFish_mul_by_kind( fish_kind)--取屏幕一类鱼的倍数
  	local total_mul = 0;
    if (self:getChildrenCount() > 0) then
        local pChildren =self:getChildren();
        local i=0;
        for i=0,#pChildren,1 do
             local fish =pChildren[i];
			if (fish and fish:fish_kind() == fish_kind and fish:IfCanCatchQuick()==true) then
					total_mul = total_mul+fish:get_fish_mulriple();
			end
        end
    end
    return total_mul;
end
function  gamefishmanager:getTotalFish_mul()                                     --取屏幕所有鱼倍数
    local  total_mul = 0;
	if (self:getChildrenCount() > 0) then
		local pChildren =self:getChildren();
        local i=0;
		for i=0, #pChildren, 1 do
				local fish =pChildren[i];
				if (fish and fish:IfCanCatchQuick()==true)then
					total_mul = total_mul+fish:get_fish_mulriple();
				end
		end
	end
    if (total_mul > 600) then total_mul = 600; end
    return total_mul;
end
function  gamefishmanager:FreeFish(fish)
    self:removeChild(fish);
end
function  gamefishmanager:FreeAllFish()
  -- self:removeAllChildren();
  	if (self:getChildrenCount() > 0) then
	   local pChildren =self:getChildren();
       local i=0;
		for i=#pChildren,0,-1 do
				local fish = pChildren[i];
				if (fish and fish:fish_status()<2 and  fish:getcatch_flag()==0) then
                    self:removeChild(fish);
                end
		end
	end
   self.g_EYU_AliveFlag = 0;
   self.g_fishSuperCrab_AliveNum=0;
   self.g_FishBigDengLong_AliveFlag=0;
end
function  gamefishmanager:GetFish( fish_id)
     local  t_fish =self:getChildByTag(fish_id);
     return t_fish;
end
function  gamefishmanager:GetFishByKind( kind)
    if (self:getChildrenCount() > 0)then
		   local pChildren = self:getChildren();
           local i=0;
		   for i=0,#pChildren, 1 do
				local fish = pChildren[i];
				if (fish~=nil and fish:active()==true) then
				    if (fish:fish_kind() == kind and fish:IfCanCatchQuick()==true) then  return fish; end
                end
			end
	end
	return nil;
end
function  gamefishmanager:GetFishByKindEx( kind)
   if (self:getChildrenCount() > 0)	then
		   local pChildren = self:getChildren();
           local i=0;
		   for i=0,#pChildren, 1 do
				local fish = pChildren[i];
				if (fish~=nil and fish:active()==true) then
				    if (fish:fish_kind() == kind) then  return fish; end
                end
			end
	end
	return nil;
end
function  gamefishmanager:SceneSwitchIterator()            --记录原场景鱼

end
function  gamefishmanager:FreeSceneSwitchFish()            --激活矩阵

end
function  gamefishmanager:GetFishKindCount( fish_kind)
   if (fish_kind >= FISH_KIND_COUNT) then return 0;end
	local fish_kind_count = 0;
	if (self:getChildrenCount() > 0) then
	   local pChildren =self:getChildren();
       local i=0;
		for i=0,#pChildren,1 do
				local fish = pChildren[i];
				if (fish and fish:fish_kind() == fish_kind) then fish_kind_count=fish_kind_count+1;  end
		end
	end
	return fish_kind_count;
end
function  gamefishmanager:BulletHitTest(bullet)
    local   fish_kind_count = 0;
	if (self:getChildrenCount() > 0) then
		    local pChildren = self:getChildren();
            local i=0;
			for i=0,#pChildren,1 do
				local fish = pChildren[i];
				if (fish and fish:BulletHitTest(bullet)) then return true; end
			end
	end
	return false;
end
function   gamefishmanager:bullet_catchfish(bullet,fish)
             if(fish and bullet ) then
              if(fish:IfCanCatchQuick_Ex()==true) then
                    local  nAllMulriple = fish:GetFish_Catch_Mul();  --//炸弹
			        cc.exports.game_manager_:SendCatchFish(
						fish:fish_id(),
						bullet:firer_chair_id(),
						bullet:bullet_id(),
						bullet:bullet_kind(),
						bullet:bullet_mulriple(),
						nAllMulriple);

                        return true
              end
         end
         return false
end


function  gamefishmanager:NetHitTest(bullet)
   -- cclog("gamefishmanager:NetHitTest");
	local   me_chair_id = cc.exports.game_manager_:getMeChairID();
	if (bullet:firer_chair_id() ~= me_chair_id) then return false; end
	if (self:getChildrenCount() > 0) then
		 local pChildren =self:getChildren();
         local i=0;
         for i=0,#pChildren,1 do
				local fish = pChildren[i];
				if (fish and fish:BulletHitTest(bullet))
				then
					local  nAllMulriple = fish:GetFish_Catch_Mul();  --//炸弹
					cc.exports.game_manager_:SendCatchFish(
						fish:fish_id(),
						bullet:firer_chair_id(),
						bullet:bullet_id(),
						bullet:bullet_kind(),
						bullet:bullet_mulriple(),
						nAllMulriple);
					return true;
				end
		end
	end
	return false;
end
function  gamefishmanager:GetDenglonglight_Pos()
     local t_fish = self:GetFishByKindEx(29);
	if (t_fish) then return t_fish:Getlight_Pos(); end
	return cc.p(-1000, -1000);
end
function   gamefishmanager:GetDenglongLiht_Angle()
    local t_fish = self:GetFishByKindEx(29);
	if (t_fish) then return t_fish:GetLiht_Angle(); end
	return 0;
end
function  gamefishmanager:HitCheck_Broach_Bullet( pos,  hitR,  chairID, mul_limit,  bullet_mul, bulletid, angle)--穿甲弹按需碰撞
  --cclog(" gamefishmanager:HitCheck_Broach_Bullet  pos (%f,%f) hitR=%f,mul_limit=%d ",pos.x,pos.y,hitR,mul_limit);
    local  t_mul_left = mul_limit
	local pChildren = self:getChildren();
	if (#pChildren > 0) then
       local i=0;
	   for i=0,#pChildren, 1  do
				local  fish =pChildren[i];
				if (fish and fish:IfCanCatchQuick()==true) then
					if (t_mul_left > fish:get_fish_mulriple() and  fish:getBroachCut() ~= bulletid)	then
						if (fish:touch_Catch_fish_test(pos, hitR, -1)) then
							--cclog("CFishGroup::HitCheck_Broach_Bullet pos(%f,%f),hitR=%f,mul_limit=%d,1111111\n", pos.x, pos.y, hitR, mul_limit);
							t_mul_left = t_mul_left-fish:get_fish_mulriple();
							fish:SetBroachCut(bulletid);
                             --	//通知服务端
                            local buff = sendBuff:new();
	                        buff:setMainCmd(pt.MDM_GF_GAME);
                        	buff:setSubCmd(pt.SUB_C_BROACHBULLET_CATCH);
	                        buff:writeInt(chairID);--chairID
                            buff:writeInt(0);--if_bom
                            buff:writeInt(fish:fish_id());--fish_id
                            buff:writeInt(bulletid);--bulletid
                            buff:writeInt(bullet_mul);--bullet_mul
                            buff:writeInt(fish:get_fish_mulriple());--fish_mul
                             buff:writeInt(angle);--angle
	                        netmng.sendGsData(buff)
							--播放碰撞特效
							--cclog(" CFishGroup::HitCheck_Broach_Bullet 播放碰撞特效\n");
                            local file_name ="";
		                    local _sprite = nil;
			                local readIndex = 0;
			                local animation = cc.Animation:create();
                            local i=0;
			                for  i = 0,15, 1 do
				                file_name=string.format("BroachHitEff/~BroachHitEff_000_%03d.png", i);
				                local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				                if (frame) then
						                    local offset_name=string.format("BroachHitEff_000_%03d.png", i);
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
                           if (readIndex > 0) then
                                local function call_back_()
                                    _sprite:removeFromParent();
                                end
                                 animation:setDelayPerUnit(1/24.0);
				                 local action =cc.Animate:create(animation);
                                 local t_CCRepeat = cc.Repeat:create(action, 1);
								 local t_CCDelayTime = cc.DelayTime:create(0.2);
							  	 local t_CCFadeOut = cc.FadeOut:create(1);
								 local t_callfunc = cc.CallFunc:create(call_back_);
								 local t_seq = cc.Sequence:create(t_CCRepeat, t_CCDelayTime, t_CCFadeOut, t_callfunc, nil);
									if (_sprite) then
										_sprite:runAction(t_seq);
										_sprite:setPosition(pos);
										_sprite:setRotation(angle + 90);
										cc.exports.game_manager_:addChild(_sprite, 1111);
									end
                           end
						end
					end
				end
			end
		end
	return t_mul_left;
end
function  gamefishmanager:Broach_bullet_Bom( pos,  hitR,  chairID,  mul_limit,  bullet_mul,  bulletid,  ccflag)--    穿甲弹爆炸

   -- cclog(" gamefishmanager:Broach_bullet_Bom  pos (%f,%f) hitR=%f,mul_limit=%d  ccflag=%d",pos.x,pos.y,hitR,mul_limit,ccflag);
     -- //获取碰撞返回的鱼倍数,发送给服务器
	local  t_mul_left = mul_limit;
	local  t_catch_mul_total=0; --//捕捉到的总倍数
	local pChildren =self:getChildren();
	if (#pChildren > 0) then
       local i=0;
	   for i=0,#pChildren, 1  do
                  if (t_mul_left > 0)  then
			     	local  fish =pChildren[i];
				    if (fish and fish:IfCanCatchQuick()==true and  fish:fish_kind() ~=22) then
                        local t_fish_mul_=fish:get_fish_mulriple();
                         if (t_mul_left > t_fish_mul_) then
                             if (fish:touch_Catch_fish_test(pos, hitR, -1)) then
                                  	t_mul_left =t_mul_left-t_fish_mul_;
								    t_catch_mul_total =t_catch_mul_total+ t_fish_mul_;
                                   if (ccflag >0) then
                                        fish:CatchFish(chairID, bullet_mul*fish:get_fish_mulriple(), bullet_mul, fish:get_fish_mulriple(), 1);
                                   end --	if (ccflag == 0)
                             end-- if (fish:touch_Catch_fish_test(pos, hitR, -1))
                         end-- if (t_mul_left > fish->get_fish_mulriple()) then
                      end --  if (fish and fish:IfCanCatchQuick() and  fish:fish_kind() ~=22)) then
             end--if (t_mul_left > 0)  then
        end --for
       if (ccflag<1) then
            --通知服务器  SUB_C_BROACHBULLET_CATCH
            local buff = sendBuff:new();
	        buff:setMainCmd(pt.MDM_GF_GAME);
            buff:setSubCmd(pt.SUB_C_BROACHBULLET_CATCH);
	        buff:writeInt(chairID);--chairID
            buff:writeInt(1);--if_bom
            buff:writeInt(0);--fish_id
            buff:writeInt(bulletid);--bulletid
            buff:writeInt(bullet_mul);--bullet_mul
            buff:writeInt(t_catch_mul_total);--fish_mul
            buff:writeInt(angle);--angle
	        netmng.sendGsData(buff);
        end
    end --if (#pChildren > 0) then
end
function  gamefishmanager:InterlinkBombCrab_Bom( pos,  hitR,  chairID,  mul_,  bullet_mul)                                      --连环炸弹
	local t_mul_left = mul_;
	local t_catch_mul=0;
	if (self:getChildrenCount() > 0) then
		local pChildren =self:getChildren();
		if (#pChildren > 0) then
		local i=0;
		for i=0,#pChildren, 1 do
			   if (t_mul_left > 0) then
                     local fish = pChildren[i];
					if (fish and fish:IfCanCatchQuick()==true) then
						if (t_mul_left > fish:get_fish_mulriple()) then
							if (fish:touch_Catch_fish_test(pos, hitR, -1)) then
								t_mul_left = t_mul_left-fish:get_fish_mulriple();
								t_catch_mul = t_catch_mul+fish:get_fish_mulriple();
								fish:CatchFish(chairID, bullet_mul*fish:get_fish_mulriple(), bullet_mul, fish:get_fish_mulriple(), 1);
							end --if (fish:touch_Catch_fish_test(pos, hitR, -1)) then
						end --	if (t_mul_left > fish:get_fish_mulriple()) then
					end  --if (fish and fish:IfCanCatchQuick()==true) then
				end --if (t_mul_left > 0) then
			end --for
		end --if (#pChildren > 0)
	end --if (self:getChildrenCount() > 0) then
	return t_catch_mul;
end
function  gamefishmanager:DianciBom( Startpos,  HitR,  chairID,  mul_,  bullet_mul,  bulletid,  angle,  ccflag)--电磁炮
              --cclog("gamefishmanager:DianciBom(Startpos(%f,%f), HitR=%d,chairID=%d,mul_=%d,bullet_mul=%d,bulletid=%d,angle=%d,ccfla=%d)",
             -- Startpos.x,Startpos.y,  HitR,  chairID,  mul_,  bullet_mul,  bulletid,  angle,  ccflag);
             local   t_mul_left = mul_;
	         local t_catch_mul = 0;
             local t_ccwinsize = cc.Director:getInstance():getWinSize();--::sharedDirector()->getWinSize();
             if (HitR < 100) then HitR = 100; end
             local t_touch_point={cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
             local t_touch_point_F={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0};
             local i=0;
             local t_math_angle = math.rad(angle);
             local t_sinfA = math.sin(t_math_angle);
         	 local t_cosfA = math.cos(t_math_angle);
             for i = 0,12,1 do
                 t_touch_point_F[i]=0;
                 t_touch_point[i] = cc.p(Startpos.x,Startpos.y);
		         t_touch_point[i].x =  t_touch_point[i].x +((i * 2 * HitR + HitR)*t_sinfA);
	             t_touch_point[i].y =  t_touch_point[i].y +((i * 2 * HitR + HitR)*t_cosfA);
		         if (t_touch_point[i].x > 0 and t_touch_point[i].x < t_ccwinsize.width and t_touch_point[i].y>0 and t_touch_point[i].y < t_ccwinsize.height) then
		             	t_touch_point_F[i] = 1;
		          end
             end--for
            local pChildren =self:getChildren();
	        if (#pChildren > 0) then
                 local i=0;
	             for i=0,#pChildren, 1  do
                       if (t_mul_left > 0) then
                          local fish = pChildren[i];
                          if (fish and fish:IfCanCatchQuick()==true) then
                               local t_fish_mul_num=fish:get_fish_mulriple();
                               if(t_mul_left>t_fish_mul_num)  then
                                       --cclog("gamefishmanager:DianciBom 00 ");
                                       local t_hit_flag = 0;
							           for i = 0,12,1 do
                                          if (t_hit_flag==0 and t_touch_point_F[i]>0 ) then
                                                --cclog("gamefishmanager:DianciBom 01 t_touch_point(%f,%f) HitR=%f",t_touch_point[i].x,t_touch_point[i].y,HitR);
                                                if (fish:touch_Catch_fish_test(t_touch_point[i], HitR, -1)) then
                                                    t_hit_flag = 1;
                                                end
                                           end--==0
                                        end --for
                                        if (t_hit_flag>0) then
								            t_mul_left= t_mul_left-fish:get_fish_mulriple();
								            t_catch_mul= t_catch_mul+fish:get_fish_mulriple();
								            if (ccflag>0) then
									             fish:CatchFish(chairID, bullet_mul*fish:get_fish_mulriple(), bullet_mul, fish:get_fish_mulriple(), 1);
								            end
							           end
                               end --if(t_mul_left>t_fish_mul_num)  then
                            end --if(fish
                       end-- if (t_mul_left > 0) then
                 end--for
            end-->#0
            if (ccflag==0) then
                   --//通知服务器
                   local buff = sendBuff:new();
	                buff:setMainCmd(pt.MDM_GF_GAME);
                   	buff:setSubCmd(pt.SUB_C_DIANCIBULLET_CATCH);
	                buff:writeInt(chairID);
                    buff:writeInt(bulletid);
                    buff:writeInt(bullet_mul);
                    buff:writeInt(t_catch_mul);
                    buff:writeInt(angle);
	                netmng.sendGsData(buff)
         end
         return t_catch_mul;
end

function   gamefishmanager:freebullet_catchfish(bullet,fish)
             if(fish and bullet ) then
              if(fish:IfCanCatchQuick_Ex()==true) then
                    local  nAllMulriple =fish:GetFish_Catch_Mul();  --//炸弹
			        local buff = sendBuff:new();
	                buff:setMainCmd(pt.MDM_GF_GAME);
                   	buff:setSubCmd(pt.SUB_C_CATCH_FISH);
	                buff:writeShort(bullet:firer_chair_id());
                    buff:writeInt(fish:fish_id());
                    buff:writeInt(8);
                    buff:writeInt(bullet:bullet_id());
                    buff:writeInt(bullet:bullet_mulriple());
                    buff:writeInt(nAllMulriple);
	                netmng.sendGsData(buff)
                   return true
              end
         end
         return false
end

function  gamefishmanager:FreeBulletCatch( Startpos,  HitR,  chairID,  bullet_mul,  bulletid,  angle, locakID) --免费子弹
   --cclog("gamefishmanager:FreeBulletCatch Startpos(%f,%f) HitR,=%d",Startpos.x,Startpos.y,HitR);
   if (self:getChildrenCount() > 0)	then
   	local pChildren =self:getChildren();
		if (#pChildren > 0)then
        	local i=0;
			for i=0,#pChildren, 1 do
				local fish = pChildren[i];
				if (fish and fish:IfCanCatchQuick()==true and fish:touch_Catch_fish_test(Startpos,HitR, locakID)==true)	then
                   --	//通知服务端
                    local  nAllMulriple = fish:GetFish_Catch_Mul();  --//炸弹
                   local buff = sendBuff:new();
	                buff:setMainCmd(pt.MDM_GF_GAME);
                   	buff:setSubCmd(pt.SUB_C_CATCH_FISH);
	                buff:writeShort(chairID);
                    buff:writeInt(fish:fish_id());
                    buff:writeInt(8);
                    buff:writeInt(bulletid);
                    buff:writeInt(bullet_mul);
                    buff:writeInt(nAllMulriple);
	                netmng.sendGsData(buff)
                   return true;
                end
			end
		end
    end;--  if (self:getChildrenCount() > 0)	then
    return false;
end

function  gamefishmanager:MissileBulletCatch_fish(bullet,fish)
     if (fish) then 	--必杀只打BOSS
            local t_fish_kind=fish:fish_kind();
                if (  t_fish_kind== 25   --     //巨龙
						or t_fish_kind == 27    --//深海巨兽
						or t_fish_kind == 28    --//帝王蟹
						or t_fish_kind == 29    --//深海之王
						or t_fish_kind == 33    --//大水母
						) then
                          if (fish:IfCanCatchQuick_Ex()==true) then
                                  local buff = sendBuff:new();
	                              buff:setMainCmd(pt.MDM_GF_GAME);
                                  buff:setSubCmd(pt.SUB_C_MissileBULLET_CATCH);
	                              buff:writeShort(bullet:firer_chair_id());
                                  buff:writeInt(fish:fish_id());--fish_id
                                  buff:writeInt(bullet:bullet_id());--bullet_id
                                  buff:writeInt(bullet:bullet_mulriple());--bullet_mulriple
                                  buff:writeInt(fish:fish_kind());--fish_kind
                                  buff:writeInt(300);  --fish_mul
	                              netmng.sendGsData(buff)
                           return     true;
                          end

                        end
     end
     return false;
end
function  gamefishmanager:MissileBulletCatch( Startpos,  HitR,  chairID,  bullet_mul,  bulletid,  angle,  locakID)--必杀子弹
            local pChildren =self:getChildren();
		    if (#pChildren > 0)then
                 local i=0;
			     for i=0,#pChildren, 1 do
                     local  fish = pChildren[i];
                     if (fish) then 	--必杀只打BOSS
                        local t_fish_kind=fish:fish_kind();
                        if (
                         t_fish_kind== 25   --     //巨龙
						or t_fish_kind == 27    --//深海巨兽
						or t_fish_kind == 28    --//帝王蟹
						or t_fish_kind == 29    --//深海之王
						or t_fish_kind == 33    --//大水母
						) then
                              --cclog(" gamefishmanager:MissileBulletCatch Startpos(%f,%f),HitR=%f aaaaaaaaaaaaaaaaaa",Startpos.x,Startpos.y,HitR);
                             if (fish:IfCanCatchQuick()==true and fish:touch_Catch_fish_test(Startpos, HitR, -1)==true) then
                                 --cclog(" gamefishmanager:MissileBulletCatch Startpos(%f,%f),HitR=%f bbbbbbbbbbbbbbbbbbb",Startpos.x,Startpos.y,HitR);
                                   --	//通知服务端
                                  local buff = sendBuff:new();
	                              buff:setMainCmd(pt.MDM_GF_GAME);
                                  buff:setSubCmd(pt.SUB_C_MissileBULLET_CATCH);
	                              buff:writeShort(chairID);
                                  buff:writeInt(fish:fish_id());--fish_id
                                  buff:writeInt(bulletid);--bullet_id
                                  buff:writeInt(bullet_mul);--bullet_mulriple
                                  buff:writeInt(fish:fish_kind());--fish_kind
                                  buff:writeInt(300);  --fish_mul
	                              netmng.sendGsData(buff)
                                  -- cclog(" gamefishmanager:MissileBulletCatch Startpos(%f,%f),HitR=%f  aaaaaa",Startpos.x,Startpos.y,HitR);
                                    return true;
                               end
                        end
                     end
                 end
            end
            return false;
end
function  gamefishmanager:touch_Catch_fish_test( touch_pos,  touch_r,  lock_fishid)
		local pChildren =self:getChildren();
		if (#pChildren > 0)then
        	local i=0;
			for i=0,#pChildren, 1 do
				local fish = pChildren[i];
				if (fish and fish:IfCanCatchQuick()==true  and fish:touch_Catch_fish_test(touch_pos, touch_r, lock_fishid)==true)	then
					return true;
				end
			end
		end
	return false;
end
function  gamefishmanager:Touch_FishByPosition( x,  y,  MinFishKind)--触点锁定鱼
   cclog("gamefishmanager:Touch_FishByPosition( x=%f,y=%f,MinFishKind=%d)", x,y,MinFishKind);
   if(self:getChildrenCount() > 0)
	then
		local pChildren = self:getChildren();
		if (#pChildren> 0)then
			local i=0;
			for i=0,#pChildren,1 do
				local  fish = pChildren[i];
				if (fish  and fish:fish_kind() >= MinFishKind and fish:CheckValidForLock()==true )  then
                   cclog("gamefishmanager:Touch_FishByPosition( x=%f,y=%f,MinFishKind=%d)11111111", x,y,MinFishKind);
					if (fish:TouchHitTest(x, y)==true)	then
                        cclog("gamefishmanager:Touch_FishByPosition( x=%f,y=%f,MinFishKind=%d) 33333333", x,y,MinFishKind);
                         return fish;
                     end
                end
			end
		end
	end
	return nil;
end
function  gamefishmanager:CatchFish( chair_id,  fish_id,  score,  bulet_mul,  fish_mul, if_bom)
       --cclog(" gamefishmanager:CatchFish(param) ------------------------------if_bom=%d---------------",if_bom);
		local fish = self:GetFish(fish_id);
		if (fish)   then
           -- cclog(" gamefishmanager:CatchFish(param) -11--------------------------------------------");
            fish:CatchFish(chair_id, score, bulet_mul, fish_mul, if_bom);
        end
end

function  gamefishmanager:LockFish(last_lock_fish_id, last_fish_kind)
  -- cclog(" gamefishmanager:LockFish last_lock_fish_id=%d, last_fish_kind=%d",last_lock_fish_id, last_fish_kind);
   local lock_fish_kind=last_fish_kind;
   local lock_fish_id=last_lock_fish_id;
   local LOCKFISH_MIN=1;
  if (self:getChildrenCount()>0)  then
	local pChildren =self:getChildren();
	if (last_fish_kind == FISH_KIND_COUNT) then last_fish_kind = LOCKFISH_MIN; end
	local  next_fish_kind = last_fish_kind;
    --查找类型
    local exist_fish_kind={};
	if (next_fish_kind~= FISH_KIND_COUNT) then
        local i=0;
		for i=0,#pChildren, 1 do
				local  fish=pChildren[i];
				if (
                  fish~=nil
                  and fish:active()==true
                  and fish:fish_status() == 1
                  and fish:fish_id()~= last_lock_fish_id
                  and fish:fish_kind() >= LOCKFISH_MIN
                  and fish:CheckValidForLock()==true)  then
				   exist_fish_kind[fish:fish_kind()] = true;
                end
		end
		for i = LOCKFISH_MIN, FISH_KIND_COUNT, 1 do
			next_fish_kind = (next_fish_kind + 1) % FISH_KIND_COUNT;
			if (next_fish_kind < LOCKFISH_MIN)  then next_fish_kind = LOCKFISH_MIN; end
			if (exist_fish_kind[next_fish_kind]~=nil and exist_fish_kind[next_fish_kind]==true) then break; end
		end
	end
    --查找锁定对象
    local i=0;
	for i=0,#pChildren, 1 do
			local  fish =pChildren[i];
			if (
                  fish~=nil
                  and fish:active()==true
                  and fish:fish_status() == 1
                  and fish:fish_id()~= last_lock_fish_id
                  and fish:fish_kind() >= LOCKFISH_MIN
                  and fish:CheckValidForLock()==true)  then
		    	if (next_fish_kind == FISH_KIND_COUNT or next_fish_kind == fish:fish_kind()) then
				   if (lock_fish_kind~= nil) then
                       lock_fish_kind = fish:fish_kind();
				       lock_fish_id=fish:fish_id();
                       break;
                   end --if (lock_fish_kind~= nil) then
                end   --next_fish_kind == FISH_KIND_COUNT
            end      --fish:active()==true
	   end            --for i=0,#pChildren, 1 do
    end              --if (self:getChildrenCount()>0)
    return lock_fish_id;--,lock_fish_kind;
end
function  gamefishmanager:LockFishReachPos( lock_fishid,  size, pos)
	local pChildren =self:getChildren();
    local i=0;
	for i=0,#pChildren-1, 1 do
		local  fish = pChildren[i];
		if (fish and fish:active()==true and fish:fish_id() == lock_fishid)
		then
			local pos,check=fish:GetCurPos();
			return true;
		end
	end
	return false;
end
return gamefishmanager;
--endregion

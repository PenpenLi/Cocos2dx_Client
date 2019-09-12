--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/7
--此文件由[BabeLua]插件自动生成
local gamefishmanager = class("gamefishmanager",
 function()
  return cc.Node:create()
end
)

function gamefishmanager:ctor(sceneNode)
    self:LoadGameResource();
    self.m_fisgroup_node = cc.Node:create();
  self.m_Birdgroup_node = cc.Node:create();     
    self:addChild(self.m_fisgroup_node, 1);
    self.fish_vector_={};
  if (sceneNode~=nil) then sceneNode:addChild(self.m_Birdgroup_node, 11); 
  else self:addChild(self.m_Birdgroup_node, 11); end
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
  -- local i=0;
   --for i=0,40,1 do
    -- cc.exports.g_offsetmap_InitFlag[i]=0;
    -- cc.exports.g_offsetmap_InitFlag_D[i]=0;
  -- end
   local function handler(interval)
        self:update(interval);
   end
   self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
   cc.exports.g_pFishGroup=self;--给全局赋值
end
 function  gamefishmanager:update(dt)
 end
--
 function  gamefishmanager:LoadGameResource()
    local spriteFrame  = cc.SpriteFrameCache:getInstance();  
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/bullet_ex11.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/fireEffect.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/lock_line.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/yunxuan.plist");

    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/animal1.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/animal2.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/animal3.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/animal4.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/CJ_BOSS.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/Animal/vbd_.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/cannon/FreeBullet/FreeGunEffect.plist");   

    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/king_bobo.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/new_bullet.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/new_king_effect.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/new_link_effect.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/new_net.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/new_coin.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/sceneEffect0.plist");
    spriteFrame:addSpriteFrames("qj_animal/res/game_res/new/scene_effect_0.plist");
 end
 --
 function  gamefishmanager:SetStatus(nFishKind, dwFishID,FishStatus)
    local  pFishInfo = nil;
  pFishInfo = self:GetFish(dwFishID);
  if (nil==pFishInfo)  then return false; end
    pFishInfo:Set_fish_status(FishStatus);
  return true;
end
--]]
--cc.exports.alive_test_flag=0;
function gamefishmanager:ActiveFish( fish_kind,  fish_id,  fish_multiple,  bounding_box_width,  bounding_box_height, c_mov_list,  c_mov_point_num,  c_mov_speed,  c_mov_delay )
    --cclog("gamefishmanager:ActiveFish kkk fish_kind=%d fish_id=%d",fish_kind,fish_id);
    --cclog("gamefishmanager:ActiveFish00 fish_kind=%d",fish_kind);
   -- if(cc.exports.alive_test_flag==1) then return ; end;
   -- cc.exports.alive_test_flag=1;
    local fish = nil; 
    if(fish_id<=0) then return nil; end;
  if (self.m_fisgroup_node and self.m_Birdgroup_node) then 
      if (fish_kind == 15) then --//彩金
           --cclog("gamefishmanager:ActiveFish00 fish_kind=%d aa",fish_kind);
           fish = CJ_BOSS.new(fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
       if (fish) then self.m_Birdgroup_node:addChild(fish); end
    elseif (fish_kind == 31 or fish_kind == 32) then 
            --cclog("gamefishmanager:ActiveFish00 fish_kind=%d bb",fish_kind);
            fish = BirdKing.new(fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
      --if (fish) then self.m_fisgroup_node:addChild(fish); end
            if(fish) then self.m_Birdgroup_node:addChild(fish); end
      elseif(fish_kind >= 30 and fish_kind <= 39) then 
           --cclog("gamefishmanager:ActiveFish00 fish_kind=%d cc",fish_kind);
           fish = FishKing.new(fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
       if (fish) then self.m_fisgroup_node:addChild(fish); end
      elseif(fish_kind == 1 or fish_kind == 2) then --//鸟 
              --cclog("gamefishmanager:ActiveFish00 fish_kind=%d dd",fish_kind);    
        fish = Bird.new(fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
        if (fish) then self.m_Birdgroup_node:addChild(fish); end    
    else
              --cclog("gamefishmanager:ActiveFish00 fish_kind=%d ee",fish_kind);
        fish = Fish.new(fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
        if (fish) then self.m_fisgroup_node:addChild(fish); end
    end
    end
    --fish = Fish.new(c_fish_kind, fish_id, fish_multiple, bounding_box_width, bounding_box_height, c_mov_list, c_mov_point_num, c_mov_speed, c_mov_delay);
    if (fish~=nil) then  
       --cclog("gamefishmanager:ActiveFish bbb fish_kind=%d fish_id=%d aa",fish_kind,fish_id);
      if(self.fish_vector_==nil) then self.fish_vector_={}; end;
      self.fish_vector_[fish_id]=fish;
    end
    --]]
   -- cclog("gamefishmanager:ActiveFish03");
    return fish;

end
function  gamefishmanager:FreeFish(fish)
   --cclog("gamefishmanager:FreeFish(fish)00 id=%d",fish:fish_id()); 
   if(fish) then    
       --cclog("gamefishmanager:FreeFish(fish)11 id=%d",fish:fish_id()); 
       local t_fish_id=fish:fish_id();
       self.m_fisgroup_node:removeChild(fish);
       self.m_Birdgroup_node:removeChild(fish);
       self.fish_vector_[t_fish_id]=nil;
      --[[
     cclog("gamefishmanager:FreeFish(fish)01");
     local fish= self.fish_vector_[fish_id];      
     if(fish) then 
     self.m_fisgroup_node:removeChildByTag(fish_id);
     self.m_Birdgroup_node:removeChildByTag(fish_id);
     --   fish:removeFromParent();
     --   fish=nil;  
     end
     self.fish_vector_[fish_id]=nil;
     --]]
     --self.fish_vector_.remove(fish:Fish_id());
    end;
    -- cclog("gamefishmanager:FreeFish(fish)12");
end
function gamefishmanager:FreeAllFish() 
   self.m_fisgroup_node:removeAllChildren();
   self.m_Birdgroup_node:removeAllChildren();
   self.fish_vector_=nil;
   self.fish_vector_ = {};
end
function gamefishmanager:GetFish(fish_id) 
   return self.fish_vector_[fish_id];
end
function gamefishmanager:GetFishByKind(fish_kind, cancatch)
  local fish = nil;
   -- if(#self.fish_vector_<=0) then return nil ; end;
  for key, value in pairs(self.fish_vector_) do  
      fish =value;
      if(fish~=nil) then 
        if (fish:fish_kind() == fish_kind) then 
           if (cancatch~=nil and cancatch>0)then 
              if (fish:IfCanCatchQuick(0))then  return fish; end
           else 
           return fish;
           end
        end
      end
   end 
   return nil;
end
function gamefishmanager:GetFishKindCount( fish_kind,  check)
  if (fish_kind >= 40) then return 0; end
  local fish_kind_count = 0;
  local fish = nil;
     --if(#self.fish_vector_<=0) then return 0 ; end;
  for key, value in pairs(self.fish_vector_) do   
    fish = value;
    if (fish~=nil) then 
         if(fish:fish_kind() == fish_kind) then   
      if (check>0) then   
        if (fish:IfCanCatchQuick(1)) then fish_kind_count=fish_kind_count+1;   end  
      else fish_kind_count=fish_kind_count+1;
            end
      end
    end 
  end
  return fish_kind_count;
end
function gamefishmanager:touch_Catch_fish_test(touch_pos,touch_r,lock_fishid)
  local fish = nil;
     --if(#self.fish_vector_<=0) then return false ; end;
  for key, value in pairs(self.fish_vector_) do   
    fish = value;
        if (fish~=nil) then 
      if (fish:touch_Catch_fish_test(touch_pos, touch_r, lock_fishid)) then 
      return true;  
            end
        end
  end
  return false;
end

function  gamefishmanager:Touch_FishByPosition( x, y,MinFishKind)--//触点锁定鱼
    --cclog("gamefishmanager:Touch_FishByPosition( x=%f, y=%f,MinFishKind)",x,y);
  local fish = nil;
   -- if(#self.fish_vector_<=0) then return nil ; end;
  for key, value in pairs(self.fish_vector_) do     
    fish = value;
        if(fish~=nil) then 
       if (fish:CheckValidForLock()==true) then   
                -- cclog("gamefishmanager:Touch_FishByPosition( x=%f, y=%f,MinFishKind)1111",x,y);  
          if (fish:TouchHitTest(x, y)) then       
        return fish;  
            end
       end --lock
        end--~nil
  end--for
  return nil;
end
function  gamefishmanager:CatchFish(chair_id_,fish_id,score,bulet_mul,fish_mul,if_bom)

   -- cclog(" gamefishmanager:CatchFish...........");
  if (chair_id_ <8) then  
          --cclog(" gamefishmanager:CatchFish...........00");
         --if(#self.fish_vector_<=0) then return  ; end;
         -- cclog(" gamefishmanager:CatchFish...........01");
    local fish = self.fish_vector_[fish_id];
    if (fish~=nil) then 
           -- cclog(" gamefishmanager:CatchFish...........02");
        fish:CatchFish(chair_id_, score, bulet_mul, fish_mul, if_bom);  
           
           --  cclog(" gamefishmanager:CatchFish...........03");  
        end
  end
end
function gamefishmanager:LockFish( last_lock_fish_id,last_fish_kind) 
  if last_fish_kind then
    local fish = nil;
    local next_fish_kind =last_fish_kind+1;
    if (next_fish_kind >40) then next_fish_kind = 40; end
    local fish = nil;
     -- if(#self.fish_vector_<=0) then return -1 ; end;
    for key, value in pairs(self.fish_vector_) do   
       fish =value;
      if (fish:fish_status() == 1) then 
         if (fish:fish_id()~= last_lock_fish_id) then 
         if (fish:fish_kind() ~= last_fish_kind) then 
         if (fish:CheckValidForLock()==true)  then    
        return fish:fish_id();    
              end --can lock
             end --~kind
           end--~-lock
          end
    end
  end
  return -1;
end
function gamefishmanager:ResetFish()
  self:FreeAllFish();
end
function gamefishmanager:IsValidFish(pFishInfo)
  if (nil==pFishInfo) then  return false; end
  if (false==pFishInfo:active()) then return false; end
  if (pFishInfo:fish_status()~=1) then return false; end
  return true;
end

function gamefishmanager:NetHit_Bullet(bullet,fish,lock_pass)
  --  cclog("gamefishmanager:NetHit_Bullet(bullet,fish)..00");
  if (fish~=nil and bullet~=nil) then 
    if (bullet:getBomFlag() == 0 and fish:IfCanCatchQuick(0)==true) then
            local t_catch_flag=0;
            if(lock_pass~=nil) then
             --cclog("gamefishmanager:NetHit_Bullet if(lock_pass~=nil)")
             t_catch_flag=1;
            else 
               --  cclog("gamefishmanager:NetHit_Bullet(bullet,fish)..01");   
           if (bullet:lock_fishid() <= 0) then 
                     -- cclog("gamefishmanager:NetHit_Bullet bullet:lock_fishid() <= 0")
                    t_catch_flag=1;
                  elseif(bullet:lock_fishid() > 0 and fish:fish_id() == bullet:lock_fishid()) then
                       t_catch_flag=1;
                       --[[
                        --进行距离检测
                       -- cclog("gamefishmanager:NetHit_Bullet(bullet,fish).fish:fish_id()=%d == bullet:lock_fishid()=%d",
                       -- bullet:lock_fishid(),fish:fish_id());   
                       local t_fish_pos=fish:GetFishccpPos();
                       local t_bullet_pos=bullet:get_mov_pos();
                       local dx=t_fish_pos.x-t_bullet_pos.x;
                       local dy=t_fish_pos.y-t_bullet_pos.y;
                       local t_dis_=(dx*dx)+(dy*dy);
                       local t_dis_max=fish:GetHit_disRMin();
                       if(t_dis_max<100) then t_dis_max=100; end
                       t_dis_max=t_dis_max*t_dis_max;
                       --t_catch_flag=1;
                      -- cclog("gamefishmanager:NetHit_Bullet(bullet,fish) t_fish_pos(%f,%f)",t_fish_pos.x,t_fish_pos.y)
                      -- cclog("gamefishmanager:NetHit_Bullet(bullet,fish) t_bullet_pos(%f,%f)",t_bullet_pos.x,t_bullet_pos.y)
                       --cclog("gamefishmanager:NetHit_Bullet(bullet,fish) t_dis_=%d",t_dis_)
                      if(t_dis_<t_dis_max) then    t_catch_flag=1; end
                      --]]
            end
            end
            if(t_catch_flag>0) then
               -- cclog("gamefishmanager:NetHit_Bullet(bullet,fish)..02");  
               local nAllMulriple = fish:GetFish_Catch_Mul();
        if (bullet:android_chairid() >=0 and bullet:android_chairid()<8) then         
          cc.exports.game_manager_:SendCatchFish(
            fish:fish_id(),
            bullet:firer_chair_id(),
            bullet:bullet_id(),
            bullet:bullet_kind(),
            bullet:bullet_mulriple(),
            nAllMulriple);
        end 
        bullet:CastingNet();
                return true;
            end
    end
  end
  return false;
end
return gamefishmanager;
--endregion

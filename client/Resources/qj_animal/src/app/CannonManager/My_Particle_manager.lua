--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--特效管理

local My_Particle_manager = class("My_Particle_manager",
 function()
	return cc.Node:create()
end
)
function My_Particle_manager:ctor()
   cc.exports.g_My_Particle_manager=self;
end
--//0 一网打尽爆炸 1 海啸来袭爆炸  2鱼雷爆炸  3 同类炸弹
function My_Particle_manager:PlayParticle( kind,  pos)

  if(kind==0) then --
      	Action:crBBom(cc.p(pos.x,pos.y));
  elseif(kind==1) then --
    Action:crDsBoom(cc.p(pos.x,pos.y));
  elseif(kind==3) then --
    Action:crFishBoom(cc.p(pos.x,pos.y));
   else--if(kind==2) then --
    Action:crBBom(cc.p(pos.x,pos.y));
  end
  
end
return My_Particle_manager;

--endregion

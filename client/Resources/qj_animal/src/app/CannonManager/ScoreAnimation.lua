--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/21
--此文件由[BabeLua]插件自动生成
local ScoreAnimation = class("ScoreAnimation",
 function()
	return cc.Node:create()
end
)
function ScoreAnimation:ctor( t_position,MulNum,chair_id,score)
  local function Endcallback()
      self:removeFromParent()
    end
	  local ani_score_ = cc.LabelAtlas:_create(score,"qj_animal/res/game_res/score_num.png",33,38,48);	
	 ani_score_:setAnchorPoint(cc.p(0.5,0.5));
	 ani_score_:setRotation(0);
	 self:addChild(ani_score_);
    local funcall = cc.CallFunc:create(Endcallback);
    local moveby = cc.MoveBy:create(0.4,cc.p(0,20))
    local moveb = moveby:reverse()                                 
    local seq = cc.Sequence:create(moveby,moveb,funcall)
    self:runAction(seq)
    self:setPosition(t_position);
end
return ScoreAnimation;


--endregion

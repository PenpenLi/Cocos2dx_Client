local Blast = class("Blast", function()
    return cc.Node:create()
end)
function Blast:ctor(idx)
	self:creat(idx)
end
function Blast:creat(idx)
  --[[
  self.sp = cc.Sprite:create("buyu1/res/fishui/balst.png")
  self:addChild(self.sp)
  self:play()]]
  self.sp = cc.Sprite:createWithSpriteFrameName(fireFrameSet[idx])
  local anim = animateCache:getAnimation(fireAnimSet[idx])
  local action = cc.Animate:create(anim)
  local function Endcallback(  )
    self:removeFromParent()
  end
  local funcall = cc.CallFunc:create(Endcallback)
  self.sp:runAction(cc.Sequence:create(action,funcall))
  self:addChild(self.sp)
  self.sp:setScale(0.8)
end
function Blast:rota(a)
	self.sp:setRotation(a)
end
function Blast:play( ... )
  local function enK()
    self:removeFromParent()
  end
  local funcall = cc.CallFunc:create(enK)
  local action2 = cc.FadeOut:create(15/60)
  local seq = cc.Sequence:create(action2,funcall)
  self.sp:runAction(seq)
end
return Blast
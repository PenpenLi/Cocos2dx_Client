local Bingo = class("Bingo", function()
    return cc.Node:create()
end)

function Bingo:ctor(gold)
	 self.sp = cc.Sprite:createWithSpriteFrameName("YQS_caijinpan_00.png")
    local anim = ActionEx:createGameObjectAnimationRep("CJP")
    self.sp:runAction(anim)
    self:addChild(self.sp)
    self.sp:setScale(0.7)

    local function Endcallback()
      self:removeFromParent()
    end

    local dtime = cc.DelayTime:create(3)
    local remove = cc.CallFunc:create(Endcallback)
    self:runAction(cc.Sequence:create(dtime,remove))


    self.testNumber = Digital:create("0","buyu2/res/fishui/num_caijin.png",40,54,string.byte("0"))
    self.testNumber:setNumber(gold)
    self:addChild(self.testNumber,1)
    self.testNumber:setAnchorPoint(cc.p(0.5,0.0))
    self.testNumber:setPosition(cc.p(0,-40))

    local actionBy = cc.RotateBy:create(0.2,25)
    local action = actionBy:reverse()
    local actionBy1 = cc.RotateBy:create(0.2,-25)
    local action1 = actionBy1:reverse()
    local seq = cc.Sequence:create(actionBy,action,actionBy1,action1)
    self.testNumber:runAction(cc.RepeatForever:create(seq))

    soundManager:PlayGameEffect(5)
end

return Bingo
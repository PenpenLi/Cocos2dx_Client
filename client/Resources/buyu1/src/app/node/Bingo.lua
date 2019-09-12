require ("buyu1.src.app.node.Digital")

local Bingo = class("Bingo", function()
    return cc.Node:create()
end)
local rectTab = {}
for i = 1,2 do
    for j = 1,5 do
        local a = cc.rect((j-1)*256,(i-1)*256,256,256)
        table.insert(rectTab,a)
    end
end
function Bingo:ctor(gold)
    self.sp = cc.Sprite:createWithSpriteFrameName("XY_caijinpan_00.png")
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


    self.testNumber = Digital:create("0","buyu1/res/fishui/num_caijin.png",40,54,string.byte("0"))
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
    --[[
    local filename = "buyu1/res/bingo.png"
    self.sp = Action:creatsp1(filename,rectTab,0.28)
    self:addChild(self.sp)
    local sola = ScoreLab.new()
    sola:setS(tostring(gold))
    self.sp:setScale(0.45)
    self:addChild(sola,1)
    sola:setSa(1.2)
    local actionBy = cc.RotateBy:create(0.2,25)
    local action = actionBy:reverse()
    local actionBy1 = cc.RotateBy:create(0.2,-25)
    local action1 = actionBy1:reverse()
    local seq = cc.Sequence:create(actionBy,action,actionBy1,action1)
    sola:runAction(cc.RepeatForever:create(seq))]]
    soundManager:PlayGameEffect(5)
end

return Bingo
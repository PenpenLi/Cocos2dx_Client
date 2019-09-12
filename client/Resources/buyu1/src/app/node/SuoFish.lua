local SuoFish = class("SuoFish", function()
    return cc.Node:create()
end)

function SuoFish:ctor()
    self.textureDog = cc.Director:getInstance():getTextureCache():addImage("buyu1/res/xfish/lock_flag.png")
    local frame = cc.SpriteFrame:createWithTexture(self.textureDog,SuoFishrectTable[1])
    self.sp = cc.Sprite:createWithSpriteFrame(frame)
    self:addChild(self.sp)
    self:play()
end
function SuoFish:lodTex(m)
    self.sp:setTextureRect(SuoFishrectTable[m+1])
end
function SuoFish:play()
	local action = cc.MoveBy:create(0.4,cc.p(10,10))
    local action1 = cc.MoveBy:create(0.4,cc.p(-10,10))
    local action2 = cc.MoveBy:create(0.4,cc.p(-10,-10))
    local action3 = cc.MoveBy:create(0.4,cc.p(10,-10))
    local actionre = action:reverse()
    local actionre1 = action1:reverse()
    local actionre2 = action2:reverse()
    local actionre3 = action3:reverse()
    local seq = cc.Sequence:create(action,actionre,action1,actionre1,action2,actionre2,action3,actionre3)
    self.sp:runAction(cc.RepeatForever:create(seq))
end
return SuoFish
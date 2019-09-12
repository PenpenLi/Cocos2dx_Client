local FishBoom = class("FishBoom", function()
    return cc.Node:create()
end)

function FishBoom:ctor(fishKind)
    self.halo = cc.Sprite:create("buyu1/res/xfish/halo.png")
    self.m = fishKind
    self:addChild(self.halo)
    self.fish = Fish.new(fishKind)
    self.fish:setRotation(-90)
    self:addChild(self.fish,1)
    self:play()
end
function FishBoom:play()
	local action = cc.RotateBy:create(6,-360)
    self.halo:runAction(cc.RepeatForever:create(action))
end
return FishBoom
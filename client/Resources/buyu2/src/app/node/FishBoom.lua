local FishBoom = class("FishBoom", function()
    return cc.Node:create()
end)

function FishBoom:ctor(fishKind)
    self.halo = cc.Sprite:createWithSpriteFrameName("YQS_halo.png")
    self.m = fishKind
    self:addChild(self.halo)
    self.fish = Fish.new(fishKind)
    self.fish:setRotation(-90)
    self:addChild(self.fish,1)
    self.halo:setRotation(-90)
end
return FishBoom
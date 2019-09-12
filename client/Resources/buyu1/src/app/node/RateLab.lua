local RateLab = class("RateLab", function()
    return cc.Node:create()
end)

function RateLab:ctor()
	self.scorelab = cc.LabelAtlas:_create("10", "buyu1/res/fishui/num2.png",16,21,48)
	self.scorelab:setAnchorPoint(cc.p(0.5,0.5))
    self:addChild(self.scorelab)
end
function RateLab:setS(name)
    self.scorelab:setString(name)
end
return RateLab
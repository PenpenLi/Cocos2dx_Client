local ScoreLab = class("ScoreLab", function()
    return cc.Node:create()
end)
function ScoreLab:ctor()
    self.scorelab = cc.LabelAtlas:_create("123", "buyu2/res/a.png",18,24,43)
    self.scorelab:setAnchorPoint(0.5,0.5)
    self:addChild(self.scorelab)	
end
function ScoreLab:setS(name)
    self.scorelab:setString(name)
end
function ScoreLab:setSa(vb)
    self.scorelab:setScale(vb)
end
function ScoreLab:SetAnP(p)
	self.scorelab:setAnchorPoint(p)
end
return ScoreLab
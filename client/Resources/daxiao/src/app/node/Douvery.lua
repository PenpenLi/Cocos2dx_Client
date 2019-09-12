local Douvery = class("Douvery", function()
    return cc.Node:create()
end)

function Douvery:ctor()
    self.dobv = cc.Sprite:create("buyu2/res/card_ion.png") 
    self.dotx = cc.Sprite:create("buyu2/res/DoubleEffect11.png")
	self:addChild(self.dobv)
	self.dotx:setPosition(self.dobv:getContentSize().width/2,self.dobv:getContentSize().height+20)
	self.dobv:addChild(self.dotx)
	self.dotx:setScale(0.6)
	self:play()
    self:enableNodeEvents(true) 
end
function Douvery:setTexter(a)
    if a == 1 then
        self.dobv:setTexture("buyu2/res/card_ion.png")
        self.dotx:setTexture("buyu2/res/DoubleEffect11.png")
    elseif a == 3 then
        self.dobv:setTexture("buyu2/res/freecardcard_ion.png")
        self.dotx:setTexture("buyu2/res/free_bullet.png")
    end 
end
function Douvery:play( ... )
	local action = cc.MoveBy:create(0.4,cc.p(10,10))
    local action1 = cc.MoveBy:create(0.4,cc.p(-10,10))
    local action2 = cc.MoveBy:create(0.4,cc.p(-10,-10))
    local action3 = cc.MoveBy:create(0.4,cc.p(10,-10))
    local actionre = action:reverse()
    local actionre1 = action1:reverse()
    local actionre2 = action2:reverse()
    local actionre3 = action3:reverse()
    local seq = cc.Sequence:create(action,actionre,action1,actionre1,action2,actionre2,action3,actionre3)
    self.dobv:runAction(cc.RepeatForever:create(seq))
end
return Douvery
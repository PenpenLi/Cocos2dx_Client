local SuDin1 = class("SuDin1", function()
    return cc.Node:create()
end)
function SuDin1:ctor(a)
	local sum = a + 1
	local filename = "buyu2/res/images/lock_fish/lock_flag_"..sum..".png"
	self.sp = cc.Sprite:create(filename)
	self:addChild(self.sp)
	self:enableNodeEvents(true)
end
function SuDin1:onExit()
	if lablayer:getChildByTag(5) ~= nil then
        lablayer:removeChildByTag(5,true)
    end 
    if lablayer:getChildByTag(6) ~= nil then
    	lablayer:removeChildByTag(6,true)
    end 
end
return SuDin1
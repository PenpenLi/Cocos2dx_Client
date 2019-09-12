local SuDin = class("SuDin", function()
    return cc.Node:create()
end)
function SuDin:ctor(a)
	local sum = a + 1
	local filename = "buyu1/res/images/lock_fish/lock_flag_"..sum..".png"
	self.sp = cc.Sprite:create(filename)
	self:addChild(self.sp)
	self:enableNodeEvents(true)
end
function SuDin:onExit()
	
end
return SuDin
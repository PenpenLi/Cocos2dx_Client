local Wave = class("Wave", function()
    return cc.Node:create()
end)

function Wave:ctor( ... )
	local file = "buyu1/res/images/Scene/wave.png"
	local textur = cc.Director:getInstance():getTextureCache():addImage(tostring(file))
    local actab = {cc.rect(0,0,textur:getContentSize().width/2,textur:getContentSize().height),cc.rect(textur:getContentSize().width/2,0,textur:getContentSize().width/2,textur:getContentSize().height)}
	self.spp = Action:creatsp(file,actab,0.28)
	self:addChild(self.spp)
	local scax = 400/900
	local scay = 1000/1000
    self.spp:setScaleX(scax)
    self.spp:setScaleY(scay)
end

return Wave
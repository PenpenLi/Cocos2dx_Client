ParticleEff = class("ParticleEff", function()
    return cc.Sprite:create()
end)

function ParticleEff:ctor(startPos)
    self:setTexture("wacaibao/res/common/img/dian.png")

    self.posX = startPos.x + math.random(-50, 50)
    self.posY = startPos.y + math.random(-50, 50)
    self:setPosition(cc.p(self.posX, self.posY))
    self:setScale(math.random() + 0.5)
    self:setBlendFunc(gl.SRC_ALPHA,gl.ONE) -- gl.SRC_COLOR,gl.ONE   gl.SRC_ALPHA,gl.ONE
end 







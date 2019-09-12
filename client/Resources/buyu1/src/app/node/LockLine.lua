local LockLine = class("LockLine", function()
    return cc.Node:create()
end)
function LockLine:ctor(point)
  self.point = point
  self.locklinetable = {}
	self:setAnchorPoint(0.5,0)
  self:setPosition(point)
  for i = 1,math.floor(1468/60) do
    local locksp = cc.Sprite:create("buyu1/res/images/lock_fish/lock_line.png")
    locksp:setPosition(0,60*(i-1))
    self:addChild(locksp)
    table.insert(self.locklinetable,locksp)
  end 
end
function LockLine:setRo(rotation)
	self:setRotation(rotation)
end
function LockLine:setHig(point2)
  local dis = Tesdis:getDitens(self.point,point2)
  for i = 1,#self.locklinetable do
    if self.locklinetable[i]:getPositionY() > dis then
      self.locklinetable[i]:setVisible(false)
    else
      self.locklinetable[i]:setVisible(true)
    end
  end  
  local deng = Tesdis:getRota(self.point,point2)
  local rota = deng * 180 / math.pi
  self:setRo(rota)
end

return LockLine
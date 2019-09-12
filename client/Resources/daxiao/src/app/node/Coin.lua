local Coin = class("Coin", function()
    return cc.Node:create()
end)
function Coin:ctor()
  self:creat()
  self.boom = true
end
local rectTab = {}
for j = 1,12 do
  local a = cc.rect((j-1)*90,0,90,90)
  table.insert(rectTab,a)                      
end 
function Coin:creat()
  local filename = "buyu2/res/coin2.png"
  self.sp = Action:creatsp(filename,rectTab,0.04)
  self:addChild(self.sp) 
end
function Coin:Moveto(p)
	local moveto = cc.MoveTo:create(1,p)
	local function Endcallback()
    self:removeFromParent()
  end
  local funcall = cc.CallFunc:create(Endcallback)
  local seq = cc.Sequence:create(moveto,funcall)
  self.sp:runAction(seq)
end
return Coin
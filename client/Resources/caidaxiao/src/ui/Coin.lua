Coin = class("Coin", function()
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

--切割图片创建精灵
function Coin:creatsp(bimg, rectTab, times) 
  local textureDog = cc.Director:getInstance():getTextureCache():addImage(tostring(bimg))
  local tab = {}  
  local spriteDog = nil  
  for i=1, #rectTab do  
    local frame = cc.SpriteFrame:createWithTexture(textureDog, rectTab[i])  
    table.insert(tab, i, frame)   
    if i == 1 then  
      spriteDog = cc.Sprite:createWithSpriteFrame(frame)    
    end  
  end  
  local animation = cc.Animation:createWithSpriteFrames(tab, times)  
  local animate = cc.Animate:create(animation)
  spriteDog:runAction(cc.RepeatForever:create(animate))  
  return spriteDog  
end

function Coin:creat()
  local filename = "caidaxiao/res/game/other/coin2.png"
  self.sp = Coin:creatsp(filename,rectTab,0.04)
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
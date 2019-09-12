local RanPoint = class("RanPoint")

function RanPoint:ctor()
end

function RanPoint:getRo(point1,point2)
  local jlX = point1.x - point2.x
  local jlY = point1.y - point2.y
  local jd = math.deg(math.atan(jlY/jlX))
  return jd
end
function RanPoint:getRo1(point1,point2)
  local jlX = point1.x - point2.x
  local jlY = point1.y - point2.y
  local jd = math.deg(math.atan(jlX/jlY))
  return jd
end 
function RanPoint:BulleRoPo(sprite1,point)
  if sprite1 ~= nil and point ~= nil then
    local y1 = sprite1:getPositionY()
    local y2 = point.y
    local x1 = sprite1:getPositionX()
    local x2 = point.x
    local jlX = x1 - x2
    local jlY = y1 - y2
    local jd = math.deg(math.atan(jlX/jlY))
    if jlY > 0 then
      jd = jd + 180
    elseif jlY <= 0 then
      jd = jd
    end
    sprite1.rotaion = jd
  end
end

return RanPoint
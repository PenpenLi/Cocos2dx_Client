local BoJFish = class("BoJFish")



function BoJFish:creaFishLine(fishID,fishKind,fishSpeed,points,type)
  local fish = Fish.new(fishKind,fishID,points,type, {Fish.createLinearBehavior(points[1], points[2], fishSpeed)})
  fishlayer:addChild(fish,0)
  fishMap[fishID] = fish
end

function BoJFish:creaFishBezier(fishID,fishKind,fishSpeed,points,type)
  local fish = Fish.new(fishKind,fishID,points,type, {Fish.createBezierBehavior(points, fishSpeed)})
  fishlayer:addChild(fish,0)
  fishMap[fishID] = fish
end

function BoJFish:creaFishBehaviour(fishID,fishKind,behaviour,position)
  local fish = Fish.new(fishKind,fishID,{},0, behaviour)
  fishlayer:addChild(fish,0)
  if position then
    fish:setPosition(position)
  end
  fishMap[fishID] = fish
end

function BoJFish:creaFish(fishID,fishKind,trace,csFish)
  local fish = Fish.new(fishKind,fishID,{},0, {},csFish)
  fish.trace = trace
  fishlayer:addChild(fish,0)
  local x,y,angle = trace:Index(0)
  fish:setPosition(cc.p(x,y))
  fishMap[fishID] = fish

  return fish
end

return BoJFish
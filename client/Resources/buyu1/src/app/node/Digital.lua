Digital = class("Digital")
Digital.__index = Digital

function Digital:extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, self)
    return target
end

function Digital:create(string,charMapFile,itemWidth,itemHeight,startCharMap)
    local t = Digital:extend(CCLabelAtlas:_create(string,charMapFile,itemWidth,itemHeight,startCharMap))
    return t
end

function Digital:InitPar(allen,pos,scale,rot)
    self:setPosition(pos)
    self:setScale(scale)
    self:setRotation(rot)

    if(allen=="left") then
    cclog(allen)
    self:setAnchorPoint(cc.p(0.0,0.0))--左
    elseif(allen=="center") then
    cclog(allen)
    self:setAnchorPoint(cc.p(0.5,0.0))--中
    elseif(allen=="right") then
    cclog(allen)
    self:setAnchorPoint(cc.p(1.0,0.0))--右
    end
end

function Digital:setNumber(cnt)
    local t=type(cnt)
    if t=="number" then
         if(cnt>=0) then
         self:setString(tostring(cnt))
         else
          cnt=-cnt
         self:setString(":"..tostring(cnt))
         end
    else
    self:setString(cnt)
    end
end

return Digital


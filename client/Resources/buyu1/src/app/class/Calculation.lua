local Calculation = class("Calculation")

function Calculation:ctor( ... )
	
end

--子弹运动以及各种情况处理函数
local fishMap = fishMap
local bulletMap = bulletMap

function Calculation:bulltRfish(dt,sum,bom_width,bom_height, segment_fish)
    local bullt = bulletMap[sum]
    if bullt:OnFrame(dt) then
        bullt:Rebound()
    end
end

--小炸弹
function Calculation:reFusBB(tfish,point,bom_width,bom_height)
    tfish.bomfish = {}
    local param = 0

    for k, v in pairs(fishMap) do
        if k ~= tfish.fishID  then
            local point1 = cc.p(v:getPositionX(),v:getPositionY())
            local bollrec = Tesdis:RectIntectsRect(bom_width,bom_height,point,point1)
            if bollrec == true then
                param = param + v.rate 
                table.insert(tfish.bomfish, v.fishID) 
            end 
        end
    end

    return param                                                
end

--大炸弹
function Calculation:reFusBom(tfish)
    tfish.bomfish = {}
    self:pdFishWid()
    local param = 0

    for k, v in pairs(fishMap) do
        if k ~= tfish.fishID and v.fishwidow then
            param = param + v.rate 
            table.insert(tfish.bomfish, v.fishID)
        end
    end

    return param
end

--鱼王炸弹
function Calculation:reFusBomFis(tfish,fishKind)
    tfish.bomfish = {}
    self:pdFishWid()
    local param = fish_multiple[fishKind - 30]
    for k, v in pairs(fishMap) do
        if v.fishKind == (fishKind - 30) and v.fishwidow then
            param = param + v.rate 
            table.insert(tfish.bomfish, k) 
        end
    end
    return param
end

--判断鱼是否处于屏幕中
function Calculation:pdFishWid()
    for _, v in pairs(fishMap) do
        local point = cc.p(v:getPositionX(), v:getPositionY())
        v.fishwidow = (point.x <= winwidth and point.x >= 0 and point.y <= winheight and point.y >= 0)
    end
end

return Calculation
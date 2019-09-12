-- 移除表中的某个元素 
function tableRemoveElement(tab, element)
    local len = #tab 
    for j=len, 1, -1 do 
        if tab[j] ==  element then 
            table.remove(tab ,j) 
        end 
    end 
end

function createWithSingleFrameName(name, delay, iLoops)
    local cache = cc.SpriteFrameCache:getInstance() 
    local frame = nil 
    local index = 1 
    local animation = cc.Animation:create()
    repeat
        frame = cache:getSpriteFrame(string.format("%s%d.png", name, index))
        index = index + 1
        if(frame == nil) then 
            break 
        end 
        animation:addSpriteFrame(frame)
    until false;

    animation:setLoops(iLoops) 
    animation:setDelayPerUnit(delay)
    animation:setRestoreOriginalFrame(true)

    return cc.Animate:create(animation)
end
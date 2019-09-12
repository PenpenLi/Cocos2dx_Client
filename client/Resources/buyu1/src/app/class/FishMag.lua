local FishMag = class("FishMag")

function FishMag:ctor( ... )

end

local fishMap = fishMap
function FishMag:FirCs(i,goma,ScoreTex,pao,dt,segment_fish)
    local fish = fishMap[i]
    if fish then
        --鱼的游动  以及定
        fish:updataSuoD(dt,pao)

        if fish:OnFrame(dt, not boodr) then
            fishMap[i] = nil
            --if fish.fishKind == 20 then isCreateFish21 = true end
            fish:removeFromParent()
            return
        end
    end
end

function FishMag:getFish(fishid)
  return fishMap[fishid]
end

return FishMag

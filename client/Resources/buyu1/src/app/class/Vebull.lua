local Vebull = class("Vebull")

function Vebull:ctor()
end

--自动子弹执行
function Vebull:VeryCr(roate,buttnum,bullet_multiple,playID)
    local very = nil
    local bullet_kind = 0
    if bovder[num] == true then
	    very = Very.new(buttnum+4,playID,-1)
       -- very:setSpeed(bullet_speed[buttnum+4])
        bullet_kind = buttnum + 4
    end
    if freeve[num] == true then
        very = Very.new(buttnum,playID,-1)
        --very:setSpeed(bullet_speed[buttnum])
        bullet_kind = buttnum
    end
    if bovder[num] == false and freeve[num] == false then
        very = Very.new(buttnum,playID,-1)
        --very:setSpeed(bullet_speed[buttnum])
        bullet_kind = buttnum
    end
    very:setRota(roate)
    local angle = 90 - roate
    very:SetMoveSpeed(angle,bulletSpeed[bullet_kind])
    local Bpoint = cc.p(paoPoint.x+90*math.sin(math.rad(roate)),paoPoint.y+90*math.cos(math.rad(roate)))
    very:setPosition(Bpoint)
    very.FishSuId = lock_fishid
    very:setBu_multiple(bullet_multiple)
    --very:setRotation(very.rotaion)
    verylayer:addChild(very,0)
	veIDnum1 = veIDnum1 + 1
    if veIDnum1 > 60 then
       veIDnum1=1;
    end
    very.VeryId = num*10000;
	very.VeryId =very.VeryId +veIDnum1;
	--[[
    if num == 0 then
        veIDnum1 = veIDnum1 + 1
        if veIDnum1 >= 10000 then
            veIDnum1 = 0
        end
        very.VeryId = veIDnum1
    elseif num == 1 then
        veIDnum2 = veIDnum2 + 1
        if veIDnum2 >= 20000 then
            veIDnum2 = 10000
        end
        very.VeryId = veIDnum2
    elseif num == 2 then
        veIDnum3 = veIDnum3 + 1
        if veIDnum3 >= 30000 then
            veIDnum3 = 20000
        end
        very.VeryId = veIDnum3
    elseif num == 3 then
        veIDnum4 = veIDnum4 + 1
        if veIDnum4 >= 40000 then
            veIDnum4 = 30000
        end
        very.VeryId = veIDnum4
    end
	--]]
    bulletMap[very.VeryId] = very
    very:Fire(Bpoint.x, Bpoint.y)
    local m = very.rotaion / 180 * math.pi
    gamesvr.sendUserFire(bullet_kind,m,bullet_multiple,very.FishSuId,very.VeryId)
end

--金币更新
function Vebull:LabSet(ScoreTex,goma,playID,getsconum)
    if getsconum ~= nil then
        g_score[playID] =  getsconum + g_score[playID]
    end
    if freeve[playID] == false then
        g_score[playID] = g_score[playID] - goma
    end
    ScoreTex:setString(tostring(g_score[playID]))
end

--点击子弹生成
function Vebull:CrBul(point1,pao,buttnum,bullet_multiple,playID)
    local deg = Tesdis:getRota(paoPoint,point1)
    local rota = deg * 180 / math.pi
    pao:Rotation(rota)
    local very = nil
    local bullet_kind = 0
    if bovder[num] == true then
        very = Very.new(buttnum+4,playID,-1)
        --very:setSpeed(bullet_speed[buttnum+4])
        bullet_kind = buttnum+4
    end
    if freeve[num] == true then
        very = Very.new(buttnum,playID,-1)
       --very:setSpeed(bullet_speed[buttnum])
        bullet_kind = buttnum
    end
    if bovder[num] == false and freeve[num] == false then
        very = Very.new(buttnum,playID,-1)
        bullet_kind = buttnum
    end
    local angle = 90 - rota
   -- cclog("angle = %f",angle)
    very:SetMoveSpeed(angle,bulletSpeed[bullet_kind])
    local barrelLen  = pao:getBarrelLenth()
    --子弹生成的位置，这里应该根据炮台的高度
    local Bpoint = cc.p(paoPoint.x+barrelLen*math.sin(math.rad(pao.rotate)),paoPoint.y+barrelLen*math.cos(math.rad(pao.rotate)))
    very:setPosition(Bpoint)
    very.FishSuId = lock_fishid
    very:setBu_multiple(bullet_multiple)
    verylayer:addChild(very,0)
    if num == 0 then
        veIDnum1 = veIDnum1 + 1
        if veIDnum1 >= 10000 then
            veIDnum1 = 0
        end
        very.VeryId = veIDnum1
    elseif num == 1 then
        veIDnum2 = veIDnum2 + 1
        if veIDnum2 >= 20000 then
            veIDnum2 = 10000
        end
        very.VeryId = veIDnum2
    elseif num == 2 then
        veIDnum3 = veIDnum3 + 1
        if veIDnum3 >= 30000 then
            veIDnum3 = 20000
        end
        very.VeryId = veIDnum3
    elseif num == 3 then
        veIDnum4 = veIDnum4 + 1
        if veIDnum4 >= 40000 then
            veIDnum4 = 30000
        end
        very.VeryId = veIDnum4
    end
    bulletMap[very.VeryId] = very
    very:Fire(Bpoint.x, Bpoint.y)
    gamesvr.sendUserFire(bullet_kind,deg,bullet_multiple,very.FishSuId,very.VeryId)
end

--同步别人的子弹
function Vebull:onUserVery(point,pao,playID,bullet_multiple,veryType,deg,ScoreTex,veryID,bllock_fishid,android_chairid)
    self:LabSet(ScoreTex,bullet_multiple,playID)
    local very = nil
    very = Very.new(veryType,playID,android_chairid)

    local roate = deg * 180 / math.pi

    pao:Rotation(roate)
    pao:stop()
    pao:play()
    pao:addBlast()
    local angle = 90-roate
    very:SetMoveSpeed(angle,bulletSpeed[veryType])
    local barrelLen  = pao:getBarrelLenth()
    local Bpoint = cc.p(point.x+barrelLen*math.sin(math.rad(roate)),point.y+barrelLen*math.cos(math.rad(roate)))
    very:setPosition(Bpoint)
    very:setBu_multiple(bullet_multiple)
    verylayer:addChild(very,0)
    very.VeryId = veryID
    very.FishSuId = bllock_fishid
    pao:setRateNumber(bullet_multiple)
    bulletMap[very.VeryId] = very
    very:Fire(Bpoint.x, Bpoint.y)

    pao:OtherUserSwitchFrame(veryType+1)
end

return Vebull
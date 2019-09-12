local Tesdis = class("Tesdis")

local fishMap = fishMap

function Tesdis:ctor()
	
end

--判断触摸锁定
function Tesdis:touSuo(point,ppoint)
	Calculation:pdFishWid()
	for k, v in pairs(fishMap) do
		if v.fishKind >= 15 and not v.block and v.fishwidow then
			local point1 = cc.p(v:getPositionX(), v:getPositionY())
			local acd = self:RectIntectsRect(v.width, v.height, point1, point)
			if acd then
				v.count = v.count + 1
				if v.count >= 2 then
					v.count = 0										
					if fishMap[lock_fishid] then
						fishMap[lock_fishid].block = false
					end 
					v.block = true
					lineTable[num]:setVisible(true)	
					suodinTable[num]:setVisible(true)	
					SuoFishTable[num]:setVisible(true)	
					SuoFishTable[num]:lodTex(v.fishKind)		
					lock_fishid = k
					g_bolsuo = true
					return 
				end
			end
		else
			g_bolsuo = false
			local fish = fishMap[lock_fishid] 
			if fish ~= nil then
				fish.block = false
				lock_fishid = 0
				lineTable[num]:setVisible(false)	
				suodinTable[num]:setVisible(false)	
				SuoFishTable[num]:setVisible(false)
			end 
		end
	end
end

function Tesdis:AcSuoFish()
	Calculation:pdFishWid()
	for k, v in pairs(fishMap) do
		if v.fishwidow and not v.block and v.fishKind >= 15 then		
			local suofish = fishMap[k]
			if suofish ~= nil then
				if fishMap[lock_fishid] then
					fishMap[lock_fishid].block = false
				end
				lock_fishid = k
				suofish.block = true
				lineTable[num]:setVisible(true)
				suodinTable[num]:setVisible(true)
				SuoFishTable[num]:setVisible(true)
				SuoFishTable[num]:lodTex(suofish.fishKind)
				g_bolsuo = true
				return true
			end
		end
	end
	return false
end
function Tesdis:ConSuoFish()
	ofish = fishMap[lock_fishid]
	if ofish then
	    lineTable[num]:setVisible(false) 
	    suodinTable[num]:setVisible(false)
	    SuoFishTable[num]:setVisible(false)
	end
	lock_fishid = 0
end

--求弧度接口
function Tesdis:getRota(point1,point2)
	local deg = math.calcAngle(point1,point2)
	local den = deg + math.pi
	return den
end

--求碰撞接口
function Tesdis:RectIntectsRect(width,height,point1,point2)
	if math.abs(point1.x-point2.x) <= width/2 and math.abs(point1.y-point2.y) <= height/2 then
		return true
	end 
	return false
end

--求距离接口
function Tesdis:getDitens(point1,point2)
	return math.sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.y-point2.y)*(point1.y-point2.y))
end

return Tesdis


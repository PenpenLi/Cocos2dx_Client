local interval = cc.Director:getInstance():getAnimationInterval() * 2

function math.factorial(n)
	local ret = 1
	for i = 2, n do
		ret = ret * i
	end
	return ret
end

local factorial = math.factorial
function math.combination(m, n)
	return factorial(m) / (factorial(n) * factorial(m-n))
end

local combination = math.combination
local ut = util
local getDistance = cc.pGetDistance
local ccp = cc.p
local tabInsert = table.insert

function math.buildBezier(points, speedSec, precision)
	precision = precision or 0.001

	local pTable = {}
	
	local frameSpeed = speedSec * interval
	local count = #points - 1
	local value = 0
	local distance = 0
	local pNext = ccp(0, 0)
	local pPrevious = ccp(points[1].x, points[1].y)
	local t = 0

	while not (t > 1) do
		pNext.x = 0
		pNext.y = 0
		for j = 0, count do
			local p = points[j+1]
			value = ut:powf(t, j) * ut:powf(1-t, count-j) * combination(count, j)
			
			pNext.x = pNext.x + p.x * value
			pNext.y = pNext.y + p.y * value
		end
		
		distance = distance + getDistance(pNext, pPrevious)
		if distance >= frameSpeed then
			tabInsert(pTable, ccp(pNext.x, pNext.y))
			distance = distance - frameSpeed
		end

		pPrevious.x = pNext.x
		pPrevious.y = pNext.y
		t = t + precision
	end

	return pTable
end

local ccAdd = cc.pAdd
local ccSub = cc.pSub
local ccMul = cc.pMul
local getLength = cc.pGetLength

function math.buildLinear(pStart, pEnd, speedSec)
	local pTable = {}
	local frameSpeed = speedSec * interval
	local pDelta = ccSub(pEnd, pStart)
	local distance = getLength(pDelta)
	local count = distance / frameSpeed
	local step = 1 / count
	
	local t = 0
	while not (t > 1) do
		local pCurrent = ccAdd(pStart, ccMul(pDelta, t))
		tabInsert(pTable, pCurrent)

		t = t + step
	end

	return pTable
end

local cosf = math.cos
local sinf = math.sin
local atan2f = math.atan2

function math.buildCircleStatic(centerPoint, radius, count)
	local pTable = {}
	local radian = 2 * math.pi / count
	for i = 1, count do
		local iRadian = (i - 1) * radian
		local x = centerPoint.x + radius * cosf(iRadian)
		local y = centerPoint.y + radius * sinf(iRadian)

		tabInsert(pTable, cc.p(x, y))
	end

	return pTable
end

function math.buildCircleDynamic(centerPoint, radius, count, rotate, rotateSpeed)
	local pTable = {}
	local radian = 2 * math.pi / count
	for i = 1, count do
		local iRadian = (i - 1) * radian
		local ox = centerPoint.x + radius * cosf(iRadian + rotate - rotateSpeed)
		local oy = centerPoint.y + radius * sinf(iRadian + rotate - rotateSpeed)

		local x = centerPoint.x + radius * cosf(iRadian + rotate)
		local y = centerPoint.y + radius * sinf(iRadian + rotate)
		local angle = atan2f(x - ox, y - oy)

		tabInsert(pTable, {x = x, y = y, angle = angle})
	end

	return pTable
end

function math.calcAngle(p1, p2)
	local delta = ccSub(p1, p2)

	return atan2f(delta.x, delta.y)
end

function math.calculateLinearTime(pSrc, pDst, speedSec)
	local distance = getDistance(pSrc, pDst)

	return distance / speedSec
end

function math.calculateBezierTime(points, speedSec, precision)
	precision = precision or 0.001
	return ut:calcBezierTime(points, speedSec, precision)
end

function math.calculateCircleTime(startAngle, endAngle, radius, speedSec, precision)
	precision = precision or 0.001
	return ut:calcCircleTime(startAngle, endAngle, radius, speedSec, precision)
end

local absf = math.abs
function math.calculateAngleTime(startAngle, endAngle, angleSec)
	local angleDelta = absf(endAngle - startAngle)
	local time = angleDelta / angleSec

	return time
end

function math.circle(pCenter, startAngle, endAngle, radius, time)
	return ut:calcCirclePoint(pCenter, startAngle, endAngle, radius, time)
end

function math.bezier(points, time)
	return ut:calcBezierPoint(points, time)
end

function math.linear(pStart, pEnd, time)
	local pDelta = ccSub(pEnd, pStart)
	local pCurrent = ccAdd(pStart, ccMul(pDelta, time))
   
	return pCurrent
end

function math.angle(startAngle, endAngle, time)
	local deltaAngle = endAngle - startAngle
	local timeAngle = deltaAngle * time

	return timeAngle + startAngle
end
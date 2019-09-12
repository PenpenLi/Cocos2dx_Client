--常量定义
GAME_LHDB_GAME_START = 'GAME_LHDB_GAME_START'--游戏开始
GAME_LHDB_GAME_NEXT = 'GAME_LHDB_GAME_NEXT'--发送宝石布局
GAME_LHDB_GAME_EXIT = 'GAME_LHDB_GAME_EXIT'--退出
GAME_LHDB_GAME_END = 'GAME_LHDB_GAME_END'--游戏结束,写分

GAME_LHDB_GAME_BOMB = 'GAME_LHDB_GAME_BOMB'--钻头/宝石爆炸
GAME_LHDB_GAME_NOBOMB = 'GAME_LHDB_GAME_NOBOMB' --没有爆炸

MAX_BOMB_SCREEN = 7	 -- 最多连续连锁的屏数,此数值与GEM_HIGH的数值必须配套
GEM_WIDE  = 6
MAX_SCREEN = MAX_BOMB_SCREEN + 1					 -- 最大屏数,比最大连锁屏数多1
GEM_HIGH  = MAX_SCREEN * GEM_WIDE + 1		 -- 宝石区域的最大行数:最大连锁屏数*屏内最大行数+1(悬在屏幕上方最后的1行)

-- 宝石种类
ZUAN_TOU = 0  -- 钻头
BAI_YU = 1  -- 白玉
BI_YU = 2  -- 碧玉
MO_YU = 3  -- 墨玉
MA_NAO = 4  -- 玛瑙
HU_PO = 5  -- 琥珀
ZU_MU_LV = 6  -- 祖母绿
MAO_YAN_SHI = 7  -- 猫眼石
ZI_SHUI_JING = 8  -- 紫水晶
FEI_CUI = 9  -- 翡翠
ZHEN_ZHU = 10  -- 珍珠
HONG_BAO_SHI = 11  -- 红宝石
LV_BAO_SHI = 12  -- 绿宝石
HUANG_BAO_SHI = 13  -- 黄宝石
LAN_BAO_SHI = 14  -- 蓝宝石
ZUAN_SHI = 15  -- 钻石
FAKE_GEM = -1  -- 假宝石，宝石下沉时用来填充顶部空格的[假的]宝石类型

STAGE_SIZE = {4, 5, 6}  -- 关卡对应的游戏区域大小


local SOUND_GEMDOWN = "lianhuanduobao/res/sound/typedown.wav"
local SOUND_GEMCLEAN = "lianhuanduobao/res/sound/clean_type.wav"
local SOUND_GEMBOMB = "lianhuanduobao/res/sound/typebomb.wav"
local SOUND_WOODBOMB = "lianhuanduobao/res/sound/wood_bomb.wav"
SOUND_BT = "lianhuanduobao/res/sound/bt.wav"
SOUND_BACK = "lianhuanduobao/res/sound/back.wav"

GEM_POINTS = {}

GEM_POINTS[1] = {
	[4] = {2,		4,		5,		10,		20,},
	[5] = {4,		5,		10,		30,		50,},
	[6] = {5,		10,		20,		50,		100,},
	[7] = {8,		20,		40,		60,		500,},
	[8] = {10,		30,		80,		100,	1000,},
	[9] = {20,		50,		160,	750,	2000,},
	[10] = {30,		100,	500,	1000,	5000,},
	[11] = {50,		250,	1000,	10000,	20000,},
	[12] = {100,	500,	2000,	20000,	50000,},
	[13] = {200,	750,	5000,	50000,	60000,},
	[14] = {400,	800,	6000,	60000,	80000},
}

GEM_POINTS[2] = {
	[5] = {2,		4,		5,		10,		20,},
	[6] = {4,		5,		10,		30,		50,},
	[7] = {5,		10,		20,		50,		100,},
	[8] = {8,		20,		40,		60,		500,},
	[9] = {10,		30,		80,		100,	1000,},
	[10] = {20,		50,		160,	750,	2000,},
	[11] = {30,		100,	500,	1000,	5000,},
	[12] = {50,		250,	1000,	10000,	20000,},
	[13] = {100,	500,	2000,	20000,	50000,},
	[14] = {200,	750,	5000,	50000,	80000,},
	[15] = {450,	1000,	7000,	70000,	100000},
}

GEM_POINTS[3] = {
	[6] = {2,		4,		5,		10,		20,},
	[7] = {4,		5,		10,		30,		50,},
	[8] = {5,		10,		20,		50,		100,},
	[9] = {8,		20,		40,		60,		500,},
	[10] = {10,		30,		80,		100,	1000,},
	[11] = {20,		50,		160,	750,	2000,},
	[12] = {30,		100,	500,	1000,	5000,},
	[13] = {50,		250,	1000,	10000,	20000,},
	[14] = {100,	500,	2000,	20000,	50000,},
	[15] = {200,	750,	5000,	50000,	100000,},
	[16] = {500,	1200,	8000,	80000,	100000},
}

local CELL_SIZE = 64
local CELL_NUM = 16
function createGemAni(gemType)
	local index = ZUAN_TOU == gemType and 1 or gemType + 1
	local sprite
	local frames = {}
	for i=1,CELL_NUM do
		local righDownX ,rightDownY = i*CELL_SIZE, index*CELL_SIZE

		local leftTopX ,leftTopY = righDownX-CELL_SIZE, rightDownY-CELL_SIZE;

		local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/gem.png", cc.rect(leftTopX,leftTopY, CELL_SIZE,CELL_SIZE))
		frames[i] = spriteFrame
		if i == 1 then
			 sprite = cc.Sprite:createWithSpriteFrame(spriteFrame)
		end
	end
	if sprite then
		local speed = math.random(5,10) / 100
		local animation = cc.Animation:createWithSpriteFrames(frames, speed)
		sprite:runAction(cc.RepeatForever:create(cc.Animate:create(animation)))
	end
	return sprite
end

function getGemRes(gemType)
	local index = ZUAN_TOU == gemType and 1 or gemType + 1
	local sprite
	local frames = {}
	for i=1,CELL_NUM do
		local righDownX ,rightDownY = i*CELL_SIZE, index*CELL_SIZE

		local leftTopX ,leftTopY = righDownX-CELL_SIZE, rightDownY-CELL_SIZE;

		local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/gem.png", cc.rect(leftTopX,leftTopY, CELL_SIZE,CELL_SIZE))
		frames[i] = spriteFrame
		if i == 1 then
			 sprite = cc.Sprite:createWithSpriteFrame(spriteFrame)
			 return sprite
		end
	end
end

function gembombAni()
	local frames = {}
	for i=1,16 do
		local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/bomb_gem.png", cc.rect((i-1) * 128,0, 128,128))
		frames[i] = spriteFrame
	end
	local animation = cc.Animation:createWithSpriteFrames(frames, 0.07)
	return cc.Animate:create(animation)
end

function woodbombAni()
	local frames = {}
	for i=0,15 do
		local x,y = i%4, math.floor(i/4)
		local spriteFrame = cc.SpriteFrame:create("lianhuanduobao/res/img/bomb_floor.png", cc.rect(x*512, y*512, 512,512))
		frames[i] = spriteFrame
	end
	local animation = cc.Animation:createWithSpriteFrames(frames, 0.06)
	return cc.Animate:create(animation)
end



local function isIn(tList, gem)
	for i,v in ipairs(tList) do
		if v == gem then
			return true
		end
	end
	return false
end

--生成消除列表，注意tData的下标要从0开始
function genCleanList(tData, minLinkNum, iWidth, availableH)
	local cleanList = {}
	local availableH = availableH or iWidth
	local function inCleanList(gemIdx)
		for i,tList in pairs(cleanList) do
			if isIn(tList, gemIdx) then
				return true
			end
		end
		return false
	end

	--收集i，v相连的
	local function collector(tList, index)
		local gemIdx = tList[index]
		if not gemIdx then
			return
		end
		local i,j = math.floor(gemIdx/iWidth), gemIdx%iWidth
		local iu,ju = i+1, j
		local uIdx = iu*iWidth + ju
		local id,jd = i-1, j
		local dIdx = id * iWidth + jd
		local il,jl = i, j -1
		local lIdx = il * iWidth + jl
		local ir,jr = i, j + 1
		local rIdx = ir * iWidth + jr
		if iu < availableH and tData[gemIdx] == tData[uIdx] and not isIn(tList, uIdx) then
			tList[#tList + 1] = uIdx
		end
		if id >= 0 and tData[gemIdx] == tData[dIdx] and not isIn(tList, dIdx) then
			tList[#tList + 1] = dIdx
		end
		if jl >= 0 and tData[gemIdx] == tData[lIdx] and not isIn(tList, lIdx) then
			tList[#tList + 1] = lIdx
		end
		if jr < iWidth and tData[gemIdx] == tData[rIdx] and not isIn(tList, rIdx) then
			tList[#tList + 1] = rIdx
		end

		return collector(tList, index + 1)
	end
	local bReturn = false
	for i=0,availableH-1 do
		for j =0, iWidth-1 do
			local index = i*iWidth + j
			if tData[index]== ZUAN_TOU then
				cleanList[index] = {index}
				bReturn = true
			end
		end
	end
	--有钻头立即返回
	if bReturn then
		local ret = {}
		for i,v in pairs(cleanList) do
			ret[#ret + 1] = {gemType = tData[i], gemIdxs = v}
		end
		return ret
	end

	for i=0,availableH-1 do
		for j =0, iWidth-1 do
			local index = i*iWidth + j
			if not inCleanList(index) and tData[index]~= FAKE_GEM then
				--如果没有检查过 ， 那就检查一下
				cleanList[index] = {index}
				collector(cleanList[index], 1)
			end
		end
	end
	local ret = {}
	for i,v in pairs(cleanList) do
		if #v >=minLinkNum or tData[i] == ZUAN_TOU then
			ret[#ret + 1] = {gemType = tData[i], gemIdxs = v}
		end
	end
	table.sort(ret, function(a,b) return a.gemType < b.gemType end)
	return ret
end



local GEM_GAP_V = CELL_SIZE
local GEM_GAP_H = CELL_SIZE
local SPACE_GAP = 100
local FALL_OFF_TIME = 0.5
local CONTENT_HEIGHT = 609

--注意tArray的下标必须从0开始
function performanceNode(tArray, minLinkNum, iWidth, availableH)
	--布局 --消除 -- 填补 --消除 --填补--消除
	local tData = {}
	local iWidth = iWidth or GEM_WIDE
	local iHeight = iHeight or iWidth
	local gap = CONTENT_HEIGHT - (availableH+1)*CELL_SIZE
	for i,v in pairs(tArray) do
		tData[i] = v
	end
	local iHeight = math.floor(#tArray/iWidth)
	local boardNode = cc.Node:create()
	for i=0, iHeight-1 do
		for j=0, iWidth-1 do
			local index = i*iWidth + j
			local gem = tData[index]
			if gem >= 0 then
				local gemSp = createGemAni(gem)
				local posx = j * GEM_GAP_H ,posy
				boardNode:addChild(gemSp)
				if i >= availableH then
					posy =  i*GEM_GAP_V + gap
				else
					posy =  i*GEM_GAP_V
				end
				gemSp:setTag(index)

				gemSp:runAction(cc.Sequence:create{cc.Place:create(cc.p(posx, posy + CONTENT_HEIGHT)), 
					cc.MoveTo:create(0.4, cc.p(posx,posy))})
			end
		end
	end

	local eliminate,fallOff
	--填补
	fallOff = function( )
		for i=0, iHeight-1 do
			for j=0, iWidth-1 do
				local index = i*iWidth + j
				--如果是空的，则用正上方不为空的宝石填位
				if tData[index] == FAKE_GEM then
					for k=i+1, iHeight-1 do
						local dstIndex = k*iWidth + j
						--k,j填补到i,j
						if tData[dstIndex] ~= FAKE_GEM then
							tData[index] = tData[dstIndex]
							tData[dstIndex] = FAKE_GEM
							local gemSp = boardNode:getChildByTag(dstIndex)
							gemSp:setTag(index)
							local posx,posy = j * GEM_GAP_H, i*GEM_GAP_V
							if i >= availableH then
								posy = posy + gap
							end
							gemSp:runAction(cc.MoveTo:create(FALL_OFF_TIME, cc.p(posx, posy)))
							break
						end
					end
				end
			end
		end
		boardNode:runAction(cc.Sequence:create{cc.DelayTime:create(FALL_OFF_TIME), cc.CallFunc:create(function()
			eliminate()
		end)})		
	end

	--消除
	eliminate =  function()
		--生成消除表
		local cleanList = genCleanList(tData, minLinkNum, iWidth, availableH)
		--对每一个宝石执行爆炸动画后，移除
		for i,v in ipairs(cleanList) do
			local gemType = v.gemType
			for j,k in ipairs(v.gemIdxs) do
				local gemSp = boardNode:getChildByTag(k)
				if gemSp then
					
					-- gemSp:stopAllActions()
					gemSp:runAction(cc.Sequence:create{cc.DelayTime:create(i),cc.CallFunc:create(function()
						gemSp:stopAllActions()
						local act = gembombAni()
						gemSp:runAction(cc.Sequence:create{act, cc.RemoveSelf:create()})
					end)})
					tData[k] = FAKE_GEM
				end
			end
			boardNode:runAction(cc.Sequence:create{cc.DelayTime:create(i),cc.CallFunc:create(function() 
				global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_BOMB, v)
				if v.gemType ~= ZUAN_TOU then
					AudioEngine.playEffect(SOUND_GEMBOMB)
				else
					AudioEngine.playEffect(SOUND_WOODBOMB)
				end
			end)})
		end
		--消除动画完毕后，执行填补
		if #cleanList > 0 then
			boardNode:runAction(cc.Sequence:create{cc.DelayTime:create(#cleanList+1), cc.CallFunc:create(function()
				--消除完毕执行填补
				fallOff()
			end)})
		else
			boardNode:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function()
				global.g_gameDispatcher:sendMessage(GAME_LHDB_GAME_NOBOMB,nil)
			end)}))
			
		end
	end
	eliminate()
	return boardNode
end




function decodeArray(tArray, stage)
	local ret = {}
	local index = 0
	local function insertToArray(n)
		local value
		if n == 7 then
			value = FAKE_GEM
		elseif n == 0 then
			value = ZUAN_TOU
		else
			value = n + 5 *(stage - 1)
		end
		ret[index] = value
		index = index + 1
		if index == GEM_WIDE * GEM_HIGH then
			return true
		end
	end

	for i,v in ipairs(tArray) do
		if insertToArray(v%8) then return ret end
		if insertToArray(bit.rshift(v, 3) %8) then return ret end
		if insertToArray(bit.rshift(v, 6) %8) then return ret end
		if insertToArray(bit.rshift(v, 9) %8) then return ret end
		if insertToArray(bit.rshift(v, 12) %8) then return ret end
	end
end

--清盘子
function freeGemBoard( node , callback)
	local childs = node:getChildren()
	for i, childNode in ipairs(childs) do
		local posx, posy = childNode:getPosition()
		if posy < CONTENT_HEIGHT-CELL_SIZE then
			local dx, dy = math.random(-300,300), math.random(-300,-50)
			local bezier = {
				cc.p(dx,posy),
				cc.p(dx,posy),
				cc.p(dx, dy-posy),
			}
			childNode:runAction(cc.BezierBy:create(0.7, bezier))
		end
	end
	node:runAction(cc.Sequence:create{cc.CallFunc:create(function()
		AudioEngine.playEffect(SOUND_GEMCLEAN)
	end),cc.DelayTime:create(0.7), cc.CallFunc:create(function()
		if callback then
			callback()
		end
	end)})
end
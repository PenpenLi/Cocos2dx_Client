BetView = class("BetView", PopUpView)

local BET_COUNT = {10, 100, 1000, 10000, 100000}

local curBet = nil
local lastBet = nil
local curTimes = 0  -- 现在是游戏开始以来的第几局
local curPoint = BET_COUNT[1]  -- 当前下注点数

local function createEmptyBet( )
	curBet = {
		animPoints = {},
		enjoyPoints = {},
	}
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		curBet.animPoints[i] = {}
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			curBet.animPoints[i][j] = 0
		end
	end
	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		curBet.enjoyPoints[i] = 0
	end
end

local function copyBet( oldBet )
	local bet = {
		animPoints = {},
		enjoyPoints = {},
	}
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		bet.animPoints[i] = {}
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			bet.animPoints[i][j] = oldBet.animPoints[i][j]
		end
	end
	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		bet.enjoyPoints[i] = oldBet.enjoyPoints[i]
	end	
	return bet
end

function BetView:ctor()
	BetView.super.ctor(self, true)

	self._leftPoint = 0
	self:initView()
	self:initBet()
end

function BetView:initView( )
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("liushiwangchao/res/json/SWPleaseBet.json")
	root:setAnchorPoint(0.5, 0.5)
	self.nodeUI_:addChild(root)

	local closeBtn = ccui.Helper:seekWidgetByName(root, "Button_close")
	closeBtn:addTouchEventListener(makeClickHandler(self, self.onClose))

	local clearBtn = ccui.Helper:seekWidgetByName(root, "Button_clear")
	clearBtn:addTouchEventListener(makeClickHandler(self, self.onClearBtnClick))

	local againBtn = ccui.Helper:seekWidgetByName(root, "Button_again")
	againBtn:addTouchEventListener(makeClickHandler(self, self.onAgainBtnClick))

	self._animBtns = {}
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		self._animBtns[i] = {}
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			local name = "Button_anim"..i..j
			local btn = ccui.Helper:seekWidgetByName(root, name)
			btn:setTag(i * ANIMALTYPE_MAX + j)
			self._animBtns[i][j] = btn

			local function animalClicked(  )
				self:onAnimalClicked(i, j)
			end
			btn:addTouchEventListener(makeClickHandler(nil, animalClicked))
		end
	end

	self._enjoyBtns = {}
	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		local name = "Button_enjoy"..i
		local btn = ccui.Helper:seekWidgetByName(root, name)
		self._enjoyBtns[i] = btn

		local function enjoyClicked()
			self:onEnjoyClicked(i)
		end
		btn:addTouchEventListener(makeClickHandler(nil, enjoyClicked))
	end

	for i,v in ipairs(BET_COUNT) do
		local name = "Button_count"..i
		local btn = ccui.Helper:seekWidgetByName(root, name)

		local function countClicked()
			self:onCountClicked(v)
		end
		btn:addTouchEventListener(makeClickHandler(nil, countClicked))
	end
end

function BetView:initBet()
	if not curBet then  -- 未初始化
		createEmptyBet()
	end

	self:updateBet()
end

function BetView:updateBet( )
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			local btn = self._animBtns[i][j]
			local label = btn:getChildByName("Label_myBet")
			label:setString(curBet.animPoints[i][j])
		end
	end

	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		local btn = self._enjoyBtns[i]
		local label = btn:getChildByName("Label_myBet")
		label:setString(curBet.enjoyPoints[i])
	end
end

function BetView:setData( animOdds, enjoyOdds, coin, times )
	self._score = coin
	for i,arr in ipairs(animOdds) do
		for j,attr in ipairs(arr) do
			local animInfo = attr.stAnimal
			local btn = self._animBtns[animInfo.eAnimal][animInfo.eColor]
			local label = btn:getChildByName("Label_ratio")
			label:setString(attr.dwMul)
			print("=====beilv="..attr.dwMul)
		end
	end
	for i,info in ipairs(enjoyOdds) do
		local btn = self._enjoyBtns[info.eEnjoyGame]
		local label = btn:getChildByName("Label_ratio")
		label:setString(info.dwMul)
	end
	print("BetView:setData coin and times", coin, times)
	print("BetView:setData my times", curTimes, lastBet)
	if not lastBet or times ~= curTimes then
		lastBet = curBet
		createEmptyBet()
		curTimes = times
		self:clearBet()
	end
end

function BetView:onClose()
	print('BetView:onClose')
	self:close()
	global.g_gameDispatcher:sendMessage(GAME_LSWC_CLOSE_BET_VIEW)
end

function BetView:onClearBtnClick()
	print('BetView:onClearBtnClick')
	gamesvr.clearBet()
end

function BetView:onAgainBtnClick()
	print('BetView:onAgainBtnClick')
	if not lastBet then
		return
	end
	curBet = copyBet(lastBet) 
	-- self:updateBet()
	gamesvr.clearBet()
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			if curBet.animPoints[i][j] > 0 then
				gamesvr.sendBet(curBet.animPoints[i][j], i, j, ENJOYGAMETYPE_INVALID)
			end
		end
	end

	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		if curBet.enjoyPoints[i] > 0 then
			gamesvr.sendBet(curBet.enjoyPoints[i], ANIMALTYPE_INVALID, COLORTYPE_INVALID, i)
		end
	end
end

function BetView:clearBet( )
	for i = ANIMALTYPE_LION, ANIMALTYPE_RABBIT do
		for j = COLORTYPE_RED, COLORTYPE_YELLOW do
			curBet.animPoints[i][j] = 0
		end
	end

	for i = ENJOYGAMETYPE_ZHUANG, ENJOYGAMETYPE_HE do
		curBet.enjoyPoints[i] = 0
	end

	self:updateBet()
	self._leftPoint = self._score
end

function BetView:onAnimalClicked( anim, color )
	print("BetView:onAnimalClicked", anim, color, curPoint)
	gamesvr.sendBet(curPoint, anim, color, ENJOYGAMETYPE_INVALID)
end

function BetView:betAnimal( anim, color, count, total )
	print("BetView:betAnimal", anim, color, count)
	local btn = self._animBtns[anim][color]
	curBet.animPoints[anim][color] = count
	local label = btn:getChildByName("Label_myBet")
	label:setString(curBet.animPoints[anim][color])
	local totalLb = btn:getChildByName("Label_totalMyBet")
	totalLb:setString(tostring(total))
end

function BetView:onEnjoyClicked( enjoyType )
	print("BetView:onEnjoyClicked", enjoyType)
	gamesvr.sendBet(curPoint, ANIMALTYPE_INVALID, COLORTYPE_INVALID, enjoyType)
end

function BetView:betEnjoy( enjoyType, count, total )
	local btn = self._enjoyBtns[enjoyType]
	curBet.enjoyPoints[enjoyType] = count
	local label = btn:getChildByName("Label_myBet")
	label:setString(curBet.enjoyPoints[enjoyType])
	local totalLb = btn:getChildByName("Label_totalMyBet")
	totalLb:setString(tostring(total))
end

function BetView:onCountClicked( count )
	print("BetView:onCountClicked", count)
	curPoint = count
end

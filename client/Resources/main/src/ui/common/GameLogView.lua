local GameLogView = class("GameLogView", PopUpView)

LINE_IN_PAGE = 35

function GameLogView:ctor()
	GameLogView.super.ctor(self, true)

	self.touchTime_ = 0
	self.lines = {}
	self.page = 0
	self.isOver = false

	self.logFile = io.open(pathErrlog, "r")

	self.labelLog = cc.LabelTTF:create("", "", 18, cc.size(display.width - 100, display.height), cc.TEXT_ALIGNMENT_LEFT, cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
	self.nodeUI_:addChild(self.labelLog)

	local btnBack = ccui.Button:create("main/res/common/button.png")
	btnBack:setTitleText("front")
	btnBack:setPosition(cc.p(display.cx - 100, 100))
	btnBack:addTouchEventListener(makeClickHandler(self, self.backHandler))
	self.nodeUI_:addChild(btnBack)

	local btnNext = ccui.Button:create("main/res/common/button.png")
	btnNext:setTitleText("next")
	btnNext:setPosition(cc.p(display.cx - 100, 0))
	btnNext:addTouchEventListener(makeClickHandler(self, self.nextHandler))
	self.nodeUI_:addChild(btnNext)

	local btnClose = ccui.Button:create("main/res/common/button.png")
	btnClose:setTitleText("close")
	btnClose:setPosition(cc.p(display.cx - 100, -100))
	btnClose:addTouchEventListener(makeClickHandler(self, self.closeWindow))
	self.nodeUI_:addChild(btnClose)
end

function GameLogView:backHandler()
	self.page = math.max(self.page - 1, 1)

	local min = (self.page-1)*LINE_IN_PAGE+1
	local max = math.min(min+LINE_IN_PAGE-1, #self.lines)
	local str = ""
	for i = min, max do
		local line = self.lines[i]
		str = str .. "\n" .. line
	end

	self.labelLog:setString(str)
end

function GameLogView:nextHandler()
	self.page = self.page + 1

	local min = (self.page-1)*LINE_IN_PAGE+1
	if min > #self.lines then
		if not self.isOver then
			for i = 1, LINE_IN_PAGE do
				local line = self.logFile:read("*line")
				if line == nil then
					self.isOver = true
					break
				end
				table.insert(self.lines, line)
			end
		else
			self.page = self.page - 1
		end
	end

	min = (self.page-1)*LINE_IN_PAGE+1
	local max = math.min(min+LINE_IN_PAGE-1, #self.lines)

	local str = ""
	for i = min, max do
		local line = self.lines[i]
		str = str .. "\n" .. line
	end

	self.labelLog:setString(str)
end

function GameLogView:closeWindow()
	self.logFile:close()
	self:close()
end

return GameLogView
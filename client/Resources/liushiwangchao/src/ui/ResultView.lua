ResultView = class("ResultView", PopUpView)

function ResultView:ctor()
	ResultView.super.ctor(self, true)
	self:initView()
	self:updateView()
end

function ResultView:initView()
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("liushiwangchao/res/json/SWResult.json")
	self.nodeUI_:addChild(root)

	self.imgHead = ccui.Helper:seekWidgetByName(root, "Image_head")
	self.imgResult = ccui.Helper:seekWidgetByName(root, "Image_result")
	self.animalLabel = ccui.Helper:seekWidgetByName(root, "BitmapLabel1")
	self.resultLabel = ccui.Helper:seekWidgetByName(root, "BitmapLabel2")
	self.scoreLabel = ccui.Helper:seekWidgetByName(root, "Label_score")
	
	-- local closeBtn = ccui.Helper:seekWidgetByName(root, "Button_close")
	-- closeBtn:addTouchEventListener(makeClickHandler(self, self.onTouch))
	
	performWithDelay(root, function()
		self:onTouch()
	end, 2)
end

function ResultView:updateView()
	
end

function ResultView:setData(results)
	local colorList = {"red", "green", "yellow"}
        local animalList = {"lion", "panda", "monkey", "rabbit"}
	local icon = "%s_%s.png"
	local symbol = "+"
	
	local res = results[#results]
	if res.score < 0 then symbol = "" end
	local animalIndex = animalList[res.anim + 1]
	local colorIndex = colorList[res.color + 1]
	icon = string.format(icon, animalIndex, colorIndex)
	local iconName = "liushiwangchao/res/img/big/".. icon
	local resultName = "liushiwangchao/res/img/big/10".. res.enjoy + 1 .. ".png"
	self.imgHead:loadTexture(iconName)
	self.imgResult:loadTexture(resultName)
	
	self.scoreLabel:setString(symbol .. res.score)
end

function ResultView:onTouch()
	self:close()
end
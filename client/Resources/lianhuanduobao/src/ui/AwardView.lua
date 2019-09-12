AwardView = class("AwardView", PopUpView)

local AWARD_RES = {
	[1] = "lianhuanduobao/res/img/one.png",
	[2] = "lianhuanduobao/res/img/two.png",
	[3] = "lianhuanduobao/res/img/three.png",
}
function AwardView:ctor()
	AwardView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("lianhuanduobao/res/json/awardpanel.json")
	self.nodeUI_:addChild(root)

	local upBtn = ccui.Helper:seekWidgetByName(root, "upBtn")
	upBtn:addTouchEventListener(makeClickHandler(self, self.onUpBtnClick))

	local nextBtn = ccui.Helper:seekWidgetByName(root, "nextBtn")
	nextBtn:addTouchEventListener(makeClickHandler(self, self.onNextBtnClick))

	local closeBtn = ccui.Helper:seekWidgetByName(root, "closeBtn")
	closeBtn:addTouchEventListener(makeClickHandler(self, self.onCloseBtnClick))

	self.bg = ccui.Helper:seekWidgetByName(root, "bg")

	self.currPage = 1
end

function AwardView.changeBgImage(self)
	self.bg:loadTexture(AWARD_RES[self.currPage])
end

function AwardView:onUpBtnClick()
	print('AwardView:onUpBtnClick')

	if self.currPage == 1 then
		self.currPage = 3
	else
		self.currPage = self.currPage - 1
	end

	self:changeBgImage()
end

function AwardView:onNextBtnClick()
	print('AwardView:onNextBtnClick')
	if self.currPage == 3 then
		self.currPage = 1
	else
		self.currPage = self.currPage + 1
	end

	self:changeBgImage()
end

function AwardView:onCloseBtnClick()
	print('AwardView:onCloseBtnClick')
	self:close()
end
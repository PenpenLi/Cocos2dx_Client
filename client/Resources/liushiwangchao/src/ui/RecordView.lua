RecordView = class("RecordView", PopUpView)

function RecordView:ctor()
	RecordView.super.ctor(self, true)
	self:initView()
end

function RecordView:initView( )
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("liushiwangchao/res/json/SWRecord.json")
	root:setAnchorPoint(0.5, 0.5)
	self.nodeUI_:addChild(root)

	local closeBtn = ccui.Helper:seekWidgetByName(root, "Button_close")
	closeBtn:addTouchEventListener(makeClickHandler(self, self.onCloseBtnClick))

	local leftBtn = ccui.Helper:seekWidgetByName(root, "Button_left")
	leftBtn:addTouchEventListener(makeClickHandler(self, self.onLeftBtnClicked))

	local rightBtn = ccui.Helper:seekWidgetByName(root, "Button_right")
	rightBtn:addTouchEventListener(makeClickHandler(self, self.onRightBtnClicked))

	self._list = ccui.Helper:seekWidgetByName(root, "ListView_result")
	-- local template = ccui.Widget:create()
	-- template:setContentSize(80, 400)
	-- local anim = cc.Sprite:create("liushiwangchao/res/img/small/2.png")
	-- anim:setPosition(40, 255)
	-- anim:setName("anim")
	-- anim:setTag(112)
	-- template:addChild(anim)
	-- local text = cc.LabelBMFont:create("233", "liushiwangchao/res/font/num8.fnt")
	-- text:setAnchorPoint(0.5, 0)
	-- text:setPosition(40, 0)
	-- text:setName("score")
	-- text:setTag(122)
	-- template:addChild(text)
	-- self._list:setItemModel(template)

	self.totalScore = ccui.Helper:seekWidgetByName(root, "BitmapLabel_total")
end

function RecordView:onCloseBtnClick()
	print('RecordView:onCloseBtnClick')
	self:close()
end

function RecordView:onLeftBtnClicked()
	print('RecordView:onLeftBtnClicked')
	self:scrollStep(200)
end

function RecordView:onRightBtnClicked()
	print('RecordView:onRightBtnClicked')
	self:scrollStep(-200)
end

function RecordView:scrollStep( step )
	local cont = self._list:getInnerContainer()
	local x = cont:getPositionX()
	local szList = self._list:getContentSize()
	local szCont = cont:getContentSize()
	local allPercent = szList.width - szCont.width
	if allPercent >= 0 then  -- 列表不足一页，直接返回
		return
	end
	x = x + step
	if x > 0 then
		x = 0
	elseif x < allPercent then
		x = allPercent
	end
	local per = 100 * x / allPercent
	self._list:scrollToPercentHorizontal(per, 0.15, false)
end

local imgAnimPath = {
	[ANIMALTYPE_LION] = {
		[COLORTYPE_RED] = "liushiwangchao/res/img/small/13.png",
		[COLORTYPE_GREEN] = "liushiwangchao/res/img/small/3.png",
		[COLORTYPE_YELLOW] = "liushiwangchao/res/img/small/6.png",
	},
	[ANIMALTYPE_PANDA] = {
		[COLORTYPE_RED] = "liushiwangchao/res/img/small/31.png",
		[COLORTYPE_GREEN] = "liushiwangchao/res/img/small/2.png",
		[COLORTYPE_YELLOW] = "liushiwangchao/res/img/small/5.png",
	},
	[ANIMALTYPE_MONKEY] = {
		[COLORTYPE_RED] = "liushiwangchao/res/img/small/15.png",
		[COLORTYPE_GREEN] = "liushiwangchao/res/img/small/14.png",
		[COLORTYPE_YELLOW] = "liushiwangchao/res/img/small/18.png",
	},
	[ANIMALTYPE_RABBIT] = {
		[COLORTYPE_RED] = "liushiwangchao/res/img/small/26.png",
		[COLORTYPE_GREEN] = "liushiwangchao/res/img/small/25.png",
		[COLORTYPE_YELLOW] = "liushiwangchao/res/img/small/7.png",
	},
}

function RecordView:setData( results )
	local total = 0
	local ITEM_WIDTH = 100
	local ITEM_HEIGHT = 400
	local animPos = {
		[ENJOYGAMETYPE_ZHUANG] = 345,
		[ENJOYGAMETYPE_XIAN] = 230,
		[ENJOYGAMETYPE_HE] = 115,
	}
	for i,res in ipairs(results) do
		local path = imgAnimPath[res.anim][res.color]
		local template = ccui.Widget:create()
		template:setContentSize(ITEM_WIDTH, ITEM_HEIGHT)
		local anim = cc.Sprite:create(path)
		anim:setPosition(ITEM_WIDTH / 2, animPos[res.enjoy])
		template:addChild(anim)
		local text = cc.LabelBMFont:create(tostring(res.score), "liushiwangchao/res/font/num4.fnt")
		text:setAnchorPoint(0.5, 0)
		text:setPosition(ITEM_WIDTH / 2, 35)
		template:addChild(text)
		self._list:pushBackCustomItem(template)

		total = total + res.score
	end
	self.totalScore:setString(total)
end

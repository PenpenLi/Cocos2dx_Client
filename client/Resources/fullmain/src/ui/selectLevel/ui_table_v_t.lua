ui_table_v_t = class("ui_table_v_t", NodeBase)

function ui_table_v_t:ctor(tableId, chairId)
	ui_table_v_t.super.ctor(self)

	self.tableId_ = tableId
	self.chairId_ = chairId

	local tableCount = global.g_mainPlayer:getConfigTableCount()
	local indexId = tableCount > 1 and self.tableId_ or self.chairId_

	local gameId = global.g_mainPlayer:getCurrentGameId()

	local localPath = string.format("fullmain/res/selectLevel/vertical/%d/", gameId)

	local machine = cc.Sprite:create(localPath .. "machine1.png")
	self:addChild(machine)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(string.format("fullmain/res/json/selectLevel/vertical/ui_main_v_machine_%d.json", gameId))
	self:addChild(root)

	self:setContentSize(root:getContentSize())

	self.iconArrow_ = ccui.Helper:seekWidgetByName(root, "Image_4")
	self.iconArrow_:loadTexture(string.format("fullmain/res/selectLevel/vertical/arrow%d.png", indexId + 1))

	local action = cc.RepeatForever:create(cc.Sequence:create({
			cc.MoveBy:create(1, cc.p(0, 50)),
			cc.MoveBy:create(1, cc.p(0, -50))
		}))
	self.iconArrow_:runAction(action)

	local machine1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	machine1:setVisible(false)
	local px, py = machine1:getPosition()

	machine:setScale(machine1:getScale())
	machine:setPosition(cc.p(px, py))

	self.person_ = ccui.Helper:seekWidgetByName(root, "Image_3")

	local chairEmpty = true--global.g_mainPlayer:isChairEmpty(self.tableId_, self.chairId_)
	self.person_:setVisible(not chairEmpty)
	self.iconArrow_:setVisible(chairEmpty)

	local animation = cc.Animation:create()
	local mod = indexId % 2
	if mod == 0 then
		self.person_:loadTexture("fullmain/res/selectLevel/vertical/person1.png")

		animation:addSpriteFrameWithFile(localPath .. "machine1.png")
		animation:addSpriteFrameWithFile(localPath .. "machine2.png")
	else
		self.person_:loadTexture("fullmain/res/selectLevel/vertical/person2.png")

		animation:addSpriteFrameWithFile(localPath .. "machine2.png")
		animation:addSpriteFrameWithFile(localPath .. "machine1.png")
	end
	animation:setDelayPerUnit(0.5)

	local actionAni = cc.RepeatForever:create(cc.Animate:create(animation))
	machine:runAction(actionAni)

	root:addTouchEventListener(makeClickHandler(self, self.onTouchChair))
end

function ui_table_v_t:onTouchChair()
	local chairEmpty = true--global.g_mainPlayer:isChairEmpty(self.tableId_, self.chairId_)
	if chairEmpty then
		gamesvr.sendRequireSitdown(-1, -1, "")
		
		LoadingView.showTips()
	else
		WarnTips.showTips(
				{
					text = LocalLanguage:getLanguageString("L_51af047104086c95"),
					style = WarnTips.STYLE_Y
				}
			)
	end
end

function ui_table_v_t:userSitdown()
	self.person_:setVisible(true)
	self.iconArrow_:setVisible(false)
end

function ui_table_v_t:userLeave()
	self.person_:setVisible(false)
	self.iconArrow_:setVisible(true)
end
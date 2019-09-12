ui_table196_h_t = class("ui_table196_h_t", NodeBase)

function ui_table196_h_t:ctor(tableId)
	ui_table196_h_t.super.ctor(self)

	self.tableId_ = tableId

	local serverId = global.g_mainPlayer:getCurrentRoom()
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/selectLevel/horizontal/ui_main_h_machine_196.json")
	self:addChild(root)

	self.labelTable_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_7")
	self.labelTable_:setString(self.tableId_ + 1)

	self.player_ = ccui.Helper:seekWidgetByName(root, "Player_0")
	self.arrow_ = ccui.Helper:seekWidgetByName(root, "Arrow_0")
	local touchPanel = ccui.Helper:seekWidgetByName(root, "Touch_0")
	touchPanel:addTouchEventListener(makeClickHandler(self, self.onTouchChair))
	touchPanel:setSwallowTouches(false)

	self:initSurface()
end

function ui_table196_h_t:initSurface()
	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	if tablePlayer[0] then
		--桌子上有人
		self:setPersonVisible(true, 0)
		self:setArrowVisible(false, 0)
	else
		--桌子上没人
		self:setArrowVisible(true, 0)
		self:setPersonVisible(false, 0)
	end

	self:randomAniChair()
end

function ui_table196_h_t:stopAllAniChair()
	self.arrow_:stopAllActions()
	self.arrow_:setPosition(cc.p(0, 238))
	self.arrow_:setOpacity(255)
end

function ui_table196_h_t:randomAniChair()
	self:stopAllAniChair()

	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	if not tablePlayer[0] then
		local actionSpa1 = cc.Spawn:create(
				{
					cc.MoveTo:create(0.5, cc.p(0, 238 - 90)),
					cc.FadeOut:create(0.5),
				}
			)

		local actionSpa2 = cc.Spawn:create(
				{
					cc.MoveTo:create(0, cc.p(0, 238)),
					cc.FadeIn:create(0),
				}
			)

		local actionSeq = cc.RepeatForever:create(cc.Sequence:create(
					{
						actionSpa1,
						cc.DelayTime:create(0.5),
						actionSpa2,
					}
				)
			)
		self.arrow_:runAction(actionSeq)
	end
end

function ui_table196_h_t:setPersonVisible(bVisible, chairId)
	self.player_:setVisible(bVisible)
end

function ui_table196_h_t:setArrowVisible(bVisible, chairId)
	self.arrow_:setVisible(bVisible)
end

function ui_table196_h_t:onTouchChair(sender)
	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	if tablePlayer[0] then
		--位置上有人,直接返回
		return
	end

	gamesvr.sendRequireSitdown(self.tableId_, 0, "")

	LoadingView.showTips()
end

function ui_table196_h_t:userLeave(chairId)
	self:setArrowVisible(true, 0)
	self:setPersonVisible(false, 0)

	self:randomAniChair()
end

function ui_table196_h_t:userSitdown(chairId)
	self:setArrowVisible(false, 0)
	self:setPersonVisible(true, 0)

	self:randomAniChair()
end
ui_table_h_t = class("ui_table_h_t", NodeBase)

function ui_table_h_t:ctor(tableId)
	ui_table_h_t.super.ctor(self)

	self.tableId_ = tableId

	local serverId = global.g_mainPlayer:getCurrentRoom()
	local rt = global.g_mainPlayer:getRoomType(serverId)
	rt = (rt == ROOM_TYPE_TIYAN) and ROOM_TYPE_PUTONG or rt
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(string.format("fullmain/res/json/selectLevel/horizontal/ui_main_h_machine_%d.json", rt))
	self:addChild(root)

	local numBg = ccui.Helper:seekWidgetByName(root, "Image_6")
	if global.g_mainPlayer:isTableAnyLookon(self.tableId_) then
		numBg:loadTexture("fullmain/res/selectLevel/arcadeNumBg.png")
	else
		numBg:loadTexture("fullmain/res/selectLevel/tableNumBg.png")
	end

	local gameId = global.g_mainPlayer:getCurrentGameId()
	local chairUI = ccui.Helper:seekWidgetByName(root, "Image_1")
	chairUI:loadTexture(string.format("fullmain/res/selectLevel/horizontal/room_%d/%d.png", rt, gameId))

	self.labelTable_ = ccui.Helper:seekWidgetByName(root, "AtlasLabel_7")
	self.labelTable_:setString(self.tableId_ + 1)

	self.arrows_ = {}
	self.players_ = {}
	for i = 0, 3 do
		local p = ccui.Helper:seekWidgetByName(root, "Player_" .. i)
		self.players_[i] = p
		p:setVisible(false)

		local arrow = ccui.Helper:seekWidgetByName(root, "Arrow_" .. i)
		self.arrows_[i] = {arrow = arrow, point = cc.p(arrow:getPositionX(), arrow:getPositionY())}
		arrow:setVisible(false)

		local touchPanel = ccui.Helper:seekWidgetByName(root, "Touch_" .. i)
		touchPanel:setSwallowTouches(false)
		touchPanel:addTouchEventListener(makeClickHandler(self, self.onTouchChair))
	end
	
	self:initSurface()
end

function ui_table_h_t:initSurface()
	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	for i = 0, 3 do
		if tablePlayer[i] then
			--桌子上有人
			self:setPersonVisible(true, i)
			self:setArrowVisible(false, i)
		else
			--桌子上没人
			self:setArrowVisible(true, i)
			self:setPersonVisible(false, i)
		end
	end

	self:randomAniChair()
end

function ui_table_h_t:stopAllAniChair()
	for k, v in pairs(self.arrows_) do
		local arrow = v.arrow
		arrow:stopAllActions()

		local pos = v.point
		arrow:setPosition(v.point)
		arrow:setOpacity(255)
	end
end

function ui_table_h_t:randomAniChair()
	self:stopAllAniChair()

	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	for i = 0, 3 do
		if not tablePlayer[i] then
			local bd = self.arrows_[i]
			local arrow = bd.arrow
			local actionSpa1 = cc.Spawn:create(
					{
						cc.MoveTo:create(0.5, cc.p(bd.point.x, bd.point.y - 90)),
						cc.FadeOut:create(0.5),
					}
				)

			local actionSpa2 = cc.Spawn:create(
					{
						cc.MoveTo:create(0, bd.point),
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
			arrow:runAction(actionSeq)
			return
		end
	end
end

function ui_table_h_t:setPersonVisible(bVisible, chairId)
	local person = self.players_[chairId]
	person:setVisible(bVisible)
end

function ui_table_h_t:setArrowVisible(bVisible, chairId)
	local arrow = self.arrows_[chairId].arrow
	arrow:setVisible(bVisible)
end

local TOUCH_TO_CHAIRID = {
	["Touch_0"] = 0,
	["Touch_1"] = 1,
	["Touch_2"] = 2,
	["Touch_3"] = 3,
}
function ui_table_h_t:onTouchChair(sender)
	local name = sender:getName()
	local chairId = TOUCH_TO_CHAIRID[name]
	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	if tablePlayer[chairId] then
		--位置上有人,直接返回
		return
	end

	gamesvr.sendRequireSitdown(self.tableId_, chairId, "")

	LoadingView.showTips()
end

function ui_table_h_t:userLeave(chairId)
	self:setArrowVisible(true, chairId)
	self:setPersonVisible(false, chairId)

	self:randomAniChair()
end

function ui_table_h_t:userSitdown(chairId)
	self:setArrowVisible(false, chairId)
	self:setPersonVisible(true, chairId)

	self:randomAniChair()
end
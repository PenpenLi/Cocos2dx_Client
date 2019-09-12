ui_table_t = class("ui_table_t", NodeBase)

function ui_table_t:ctor(tableNum ,tableId)
	ui_table_t.super.ctor(self)

	self.tableId_ = tableId

	local gameNum = global.g_mainPlayer:getCurrentGameNum() or 4
	local strJson = string.format("fullmain/res/json/ui_main_table_%d.json", gameNum)
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile(strJson)
	self:addChild(root)

	local tableNo = ccui.Helper:seekWidgetByName(root, "AtlasLabel_2")
	tableNo:setString(tableNum)

	self.tableLogo_ = ccui.Helper:seekWidgetByName(root, "Image_1")

	local tableType = ccui.Helper:seekWidgetByName(root, "Image_36")
	tableType:setVisible(global.g_mainPlayer:isTableAnyLookon(self.tableId_))

	self.chairs_ = {}
	for i = 0, gameNum - 1 do
		local chairUI = ccui.Helper:seekWidgetByName(root, "Chair_" .. i)
		chairUI:setVisible(true)
		chairUI.nodeHead_ = ccui.Helper:seekWidgetByName(chairUI, "Chair_Head")
		chairUI.iconHead_ = ccui.Helper:seekWidgetByName(chairUI, "head")
		chairUI:setTag(i)
		chairUI:addTouchEventListener(makeClickHandler(self, self.onTouchChair))

		self.chairs_[i] = chairUI
		-- local gameId = global.g_mainPlayer:getCurrentGameId()
		-- if gameId==168 then
		-- 	if i==0 then
		-- 		--chairUI:setPosition(cc.p(0,120))
		-- 	elseif i==1 then
		-- 		--chairUI:setPosition(cc.p(0,-120))
		-- 	else
		-- 		chairUI:setVisible(false)
		-- 	end
		-- end
	end
	
	self:initSurface()
end

function ui_table_t:initSurface()
	local tableUser = global.g_mainPlayer:getTableUser(self.tableId_)
	local gameNum = global.g_mainPlayer:getCurrentGameNum() or 4
	for i = 0, gameNum - 1 do
		if tableUser[i] then
			--桌子上有人
			self:setPersonVisible(true, i)
		else
			--桌子上没人
			self:setPersonVisible(false, i)
		end
	end

	self:checkTableEmpty()
end

function ui_table_t:setPersonVisible(bVisible, chairId)
	local chairUI = self.chairs_[chairId]
	chairUI.nodeHead_:setVisible(bVisible)

	if bVisible then
		local playerId = global.g_mainPlayer:getTableChairUser(self.tableId_, chairId)
		local pd = global.g_mainPlayer:getRoomPlayer(playerId)

		local scale=1
		if global.g_mainPlayer:isLogin3rdAvailable() then
			local data = global.g_mainPlayer:getLoginData3rd()
			local faceUrl = data.icon
			gatesvr.sendSetWxFace(faceUrl)
		end
		local iconHead = ui_head_t.new(playerId, cc.size(92, 92), "fullmain/res/hall/maskHead.png", cc.rect(24, 24, 44, 44), cc.size(92, 92))
		iconHead:setScale(scale)
		local size = chairUI.iconHead_:getContentSize()
		iconHead:setPosition(cc.p(size.width / 2, size.height / 2))
		-- iconHead:setAnchorPoint(cc.p(0, 0))
		--chairUI.iconHead_:loadTexture(string.format("fullmain/res/head/%d.png", pd.faceId))
		chairUI.iconHead_:addChild(iconHead)
	end
end

function ui_table_t:checkTableEmpty()
	local gameId = global.g_mainPlayer:getCurrentGameId()
	if global.g_mainPlayer:isTableEmpty(self.tableId_) then
		self.tableLogo_:loadTexture(string.format("fullmain/res/selectLevel/table/%d_0.png", gameId))
	else
		self.tableLogo_:loadTexture(string.format("fullmain/res/selectLevel/table/%d_1.png", gameId))
	end
end

function ui_table_t:onTouchChair(sender)
	local chairId = sender:getTag()
	local tablePlayer = global.g_mainPlayer:getTableUser(self.tableId_)
	if tablePlayer[chairId] then
		--位置上有人,直接返回
		return
	end

	gamesvr.sendRequireSitdown(self.tableId_, chairId, "")

	LoadingView.showTips()
end

function ui_table_t:userLeave(chairId)
	self:setPersonVisible(false, chairId)

	self:checkTableEmpty()
end

function ui_table_t:userSitdown(chairId)
	self:setPersonVisible(true, chairId)

	self:checkTableEmpty()
end
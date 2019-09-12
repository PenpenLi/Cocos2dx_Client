RankView = class("RankView", NodeBase)

function RankView:ctor()
	RankView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_rank_full.json")
	self:addChild(root)

	self.paneMask_ = ccui.Helper:seekWidgetByName(root, "Panel_Mask")
	self.paneMask_:addTouchEventListener(makeClickHandler(self, self.onHide))
	self.paneMask_:setVisible(false)

	self.btnHide_ = ccui.Helper:seekWidgetByName(root, "Button_FullHide")
	self.btnHide_:addTouchEventListener(makeClickHandler(self, self.onHide))
	self.btnHide_:setVisible(false)

	self.btnShow_ = ccui.Helper:seekWidgetByName(root, "Button_FullShow")
	self.btnShow_:addTouchEventListener(makeClickHandler(self, self.onShow))

	self.listRank_ = ccui.Helper:seekWidgetByName(root, "ListView_Rank")
end

function RankView:onShow()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_RANK_SHOW_FULL)
end

function RankView:onHide()
	global.g_gameDispatcher:sendMessage(GAME_MESSAGE_RANK_HIDE_FULL)
end

function RankView:onSelectedClassify(sender, eventType)
	if eventType == ccui.CheckBoxEventType.selected then
		local classify = sender:getTag()
		for k, v in pairs(self.cbCheckBoxs_) do
			if k == classify then
				v.listView:setVisible(true)
			else
				v.checkbox:setSelected(false)
				v.listView:setVisible(false)
			end
		end
		gatesvr.sendGetRankList(classify)
	elseif eventType == ccui.CheckBoxEventType.unselected then
		sender:setSelected(true)
	end
end

function RankView:onRankShowFull()
	self:stopAllActions()
	self:setPositionX(-545)
	self.btnShow_:setVisible(false)
	self.btnHide_:setVisible(true)
	self.paneMask_:setVisible(true)

	local action = cc.MoveTo:create(0.2, cc.p(0, 0))
	self:runAction(action)
end

function RankView:onRankHideFull()
	self:stopAllActions()
	self:setPositionX(0)
	self.btnShow_:setVisible(true)
	self.btnHide_:setVisible(false)
	self.paneMask_:setVisible(false)

	local action = cc.MoveTo:create(0.2, cc.p(-545, 0))
	self:runAction(action)
end

function RankView:onRankList(rankList)
	for i = 1, #rankList do
		local rd = rankList[i]
		local item = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_rank_gold_item.json")
		local itemBg = ccui.Helper:seekWidgetByName(item, "Image_Bg")
		local iconRank = ccui.Helper:seekWidgetByName(item, "Image_Rank")
		local labelRank = ccui.Helper:seekWidgetByName(item, "AtlasLabel_Rank")
		local panelHead = ccui.Helper:seekWidgetByName(item, "Panel_Head")
		local labelName = ccui.Helper:seekWidgetByName(item, "Label_Name")
		labelName:enableOutline(cc.c4b(0, 0, 0, 255), 2)

		local labelGold = ccui.Helper:seekWidgetByName(item, "Label_Gold")
		labelGold:enableOutline(cc.c4b(0, 0, 0, 255), 2)

		if rd.randId > 3 then
			iconRank:setVisible(false)
		else
			iconRank:loadTexture(string.format("fullmain/res/rank/iconBig%d.png", rd.randId))
			iconRank:setVisible(true)
		end

		local playerId = global.g_mainPlayer:getPlayerId()
		if rd.userId == playerId then
			itemBg:loadTexture("fullmain/res/rank/bgFullOwn.png")
		else
			itemBg:loadTexture("fullmain/res/rank/bgFullOther.png")
		end
		labelRank:setString(rd.randId)

		local iconHead = ui_head_t.new(rd.userId, cc.size(78, 78), "fullmain/res/rank/bgHead.png", cc.rect(8, 8, 44, 44), cc.size(78, 78))
		panelHead:addChild(iconHead)

		labelName:setString(rd.userId)
		labelGold:setString(rd.score)

		self.listRank_:pushBackCustomItem(item)
	end

	self.listRank_:runAction(
		cc.CallFunc:create(function()
					self.listRank_:jumpToTop()
				end
			)
		)
	-- handlerDelayed(function()  end, 0)
end

function RankView:initMsgHandler()
	gatesvr.sendGetRichList(0)
	
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RANK_SHOW_FULL, self, self.onRankShowFull)
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_RANK_HIDE_FULL, self, self.onRankHideFull)
	-- global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_RANK_LIST, self, self.onRankList)

	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_RICH_LIST_RESUALT, self, self.onRankList)
end

function RankView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RANK_SHOW_FULL, self)
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_RANK_HIDE_FULL, self)
	-- global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_RANK_LIST, self)

	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_RICH_LIST_RESUALT, self)
end
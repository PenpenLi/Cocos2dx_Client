--
-- Author: lzg
-- Date: 2018-04-25 09:19:43
-- Function: 排行榜UI

ui_leaderboard_t = class("ui_leaderboard_t", PopUpView)

function ui_leaderboard_t:ctor()
	ui_leaderboard_t.super.ctor(self, true)

	gatesvr.sendGetRichList(0)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_leaderboard.json")
	self.nodeUI_:addChild(root)

	local btnClose = ccui.Helper:seekWidgetByName(root, "Button_2")
	btnClose:setPressedActionEnabled(true)
	btnClose:addTouchEventListener(makeClickHandler(self, self.onCloseHandler))

	self.listView_ = ccui.Helper:seekWidgetByName(root, "ListView_3")
end

function ui_leaderboard_t:onCloseHandler()
	self:close()
end

function ui_leaderboard_t:onGetLeaderboardHandler(list)
	for i = 1, #list do
		local data = list[i]
		if data.userId ~= 0 then
			local item = ui_leaderboard_item_t.new(data)
			self.listView_:pushBackCustomItem(item.node_)
		end
	end
end


function ui_leaderboard_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_RICH_LIST_RESUALT, self, self.onGetLeaderboardHandler)
end

function ui_leaderboard_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_RICH_LIST_RESUALT, self)
end

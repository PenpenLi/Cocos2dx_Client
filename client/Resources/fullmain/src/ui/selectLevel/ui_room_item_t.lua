ui_room_item_t = class("ui_room_item_t")

function ui_room_item_t:ctor(serverId)
	self.serverId_ = serverId
	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_room_item.json")
	local rd = global.g_mainPlayer:getRoomData(self.serverId_)
	local icon = ccui.Helper:seekWidgetByName(self.node_, "Image_2")
	icon:loadTexture(string.format("fullmain/res/selectLevel/gameIcon/%d.png", rd.kindId))

	local labelMul = ccui.Helper:seekWidgetByName(self.node_, "Label_3")
	labelMul:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	if rd.serverType == 8 then
		labelMul:setString(string.format(LocalLanguage:getLanguageString("L_f1b24960942a2874")))
	else
		labelMul:setString(string.format(LocalLanguage:getLanguageString("L_72a0fc8ebbd852d3"), rd.cellScore))
	end
	
	local labelLimit = ccui.Helper:seekWidgetByName(self.node_, "Label_4")
	labelLimit:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelLimit:setString(string.format(LocalLanguage:getLanguageString("L_d4a579eaec72ddc8"), moneyFormat(rd.enterScore)))

	local gameNum = 0
	local cfg = games_config[rd.kindId]
	if cfg.style == 1 then
		gameNum = 4
		if rd.nodeId == 6 then
			gameNum = 6
		elseif rd.nodeId == 8 then
			gameNum = 8 
		end
	end


	local sprPlayerNum = ccui.Helper:seekWidgetByName(self.node_, "Image_5")
	local isVisible = (gameNum ~= 0 and gameNum ~= 4)
	sprPlayerNum:setVisible(isVisible)
	if isVisible then
		sprPlayerNum:loadTexture(string.format("fullmain/res/selectLevel/p%d.png", gameNum))
	end
end
HeadLargeView = class("HeadLargeView", NodeBase)

function HeadLargeView:ctor(playerId, playerlevel)
	HeadLargeView.super.ctor(self)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_head_large.json")
	self:addChild(root)

	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local iconHead = ui_head_t.new(playerId, cc.size(200, 200), "fullmain/res/portrait/large/head_mask.png", cc.rect(0, 0, 200, 200), cc.size(200, 200))
	panelHead:addChild(iconHead)

	local gradient = math.ceil(playerlevel / 10)
	local levelFrame = ccui.Helper:seekWidgetByName(root, "Image_Frame")
	levelFrame:loadTexture(string.format("fullmain/res/portrait/large/frame/frame_%d.png", gradient))

	local labelLevel = ccui.Helper:seekWidgetByName(root, "Label_Level")
	labelLevel:setTextColor(cc.c4b(255, 255, 0, 255))
	labelLevel:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelLevel:setString(string.format("Lv.%d", playerlevel))
end

function HeadLargeView:initMsgHandler()

end

function HeadLargeView:removeMsgHandler()

end
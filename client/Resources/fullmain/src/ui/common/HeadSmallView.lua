HeadSmallView = class("HeadSmallView", NodeBase)

function HeadSmallView:ctor(playerId, playerlevel)
	HeadSmallView.super.ctor(self)

	self.playerId_ = playerId

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_head_small.json")
	self:addChild(root)

	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local iconHead = ui_head_t.new(playerId, cc.size(134, 134), "fullmain/res/portrait/small/head_mask.png", cc.rect(0, 0, 134, 134), cc.size(134, 134))
	panelHead:addChild(iconHead)

	local gradient = math.ceil(playerlevel / 10)
	local levelFrame = ccui.Helper:seekWidgetByName(root, "Image_Frame")
	levelFrame:loadTexture(string.format("fullmain/res/portrait/small/frame/frame_%d.png", gradient))

	local labelLevel = ccui.Helper:seekWidgetByName(root, "Label_Level")
	labelLevel:setTextColor(cc.c4b(255, 255, 0, 255))
	labelLevel:enableOutline(cc.c4b(0, 0, 0, 255), 1)
	labelLevel:setString(string.format("Lv.%d", playerlevel))
end

function HeadSmallView:initMsgHandler()

end

function HeadSmallView:removeMsgHandler()

end
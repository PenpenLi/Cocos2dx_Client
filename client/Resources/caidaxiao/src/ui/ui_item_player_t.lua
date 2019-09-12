ui_item_player_t = class("ui_item_player_t")

function ui_item_player_t:ctor(data)
	self.data_ = data

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_player_item.json")

	local paiming_pic = ccui.Helper:seekWidgetByName(self.node_, "paiming")
	local paiming_lab = ccui.Helper:seekWidgetByName(self.node_, "paiming_lab")
	local name_lab = ccui.Helper:seekWidgetByName(self.node_, "Label_9")
	local lab_score = ccui.Helper:seekWidgetByName(self.node_, "lab_score")


	if self.data_.paiming > 3 then
		paiming_pic:setVisible(false)
		paiming_lab:setVisible(true)
	else
		paiming_lab:setVisible(false)
		paiming_pic:setVisible(true)
	end
	paiming_lab:setString(self.data_.paiming);
	if self.data_.paiming == 1 then
		paiming_pic:loadTexture("caidaxiao/res/playeritem/11.png")

	elseif self.data_.paiming == 2 then
		paiming_pic:loadTexture("caidaxiao/res/playeritem/22.png")
	elseif self.data_.paiming == 3 then
		paiming_pic:loadTexture("caidaxiao/res/playeritem/33.png")
	end

	name_lab:setString(self.data_.name)
	lab_score:setString(self.data_.score)
	
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_Head")
	local iconHead = ui_head_t.new(self.data_.playerId, cc.size(82, 82), "caidaxiao/res/playeritem/moren.png", cc.rect(0, 0, 134, 134), cc.size(82, 82))
	panelHead:addChild(iconHead)
end
ui_leaderboard_item_t = class("ui_leaderboard_item_t")

function ui_leaderboard_item_t:ctor(itemData)
	self.itemData_ = itemData

	self.node_ = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_leaderboard_item.json")

	local labelTitle = ccui.Helper:seekWidgetByName(self.node_, "Label_14")
	labelTitle:setString(self.itemData_.nickName)

	local labelScore = ccui.Helper:seekWidgetByName(self.node_, "Label_15")
	labelScore:setString(self.itemData_.score)

	local bg = ccui.Helper:seekWidgetByName(self.node_, "Image_10")
	if self.itemData_.userId == global.g_mainPlayer:getPlayerId() then
		bg:loadTexture("fullmain/res/leaderboard/Leaderboard_bg_3.png")
	end

	local sprRandId1 = ccui.Helper:seekWidgetByName(self.node_, "Image_11")
	local sprRandId2 = ccui.Helper:seekWidgetByName(self.node_, "Image_11_0")
	if self.itemData_.randId <= 9 then
		sprRandId1:loadTexture("fullmain/res/leaderboard/number_" .. self.itemData_.randId .. ".png")
	else
		local tens = math.floor(self.itemData_.randId / 10)
		sprRandId1:loadTexture("fullmain/res/leaderboard/number_" .. tens .. ".png")
		sprRandId1:setPosition(sprRandId1:getPositionX() - 15, sprRandId1:getPositionY())
		sprRandId2:loadTexture("fullmain/res/leaderboard/number_" .. self.itemData_.randId - tens * 10 .. ".png") 
		sprRandId2:setVisible(true)
		sprRandId2:setPosition(sprRandId2:getPositionX() - 15, sprRandId2:getPositionY())

	end

	--Í·Ïñ
	local hepo = ccui.Helper:seekWidgetByName(self.node_, "Image_13")

	local px, py = hepo:getPosition()
	local nodeClip = cc.ClippingNode:create(cc.Sprite:create("fullmain/res/hall/headMask.png"))
	nodeClip:setInverted(false)
	nodeClip:setAlphaThreshold(0.5)
	nodeClip:setPosition(cc.p(35, 35))
	hepo:getParent():addChild(nodeClip, 2)

	self.iconHead_ = ui_head_t.new(self.itemData_.userId, cc.size(92, 92), "fullmain/res/hall/maskHead.png", cc.rect(24, 24, 44, 44), cc.size(92, 92))
	self.iconHead_:setPosition(cc.p(35, 35))
	hepo:addChild(self.iconHead_,10)
end


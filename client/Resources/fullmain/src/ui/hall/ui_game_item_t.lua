ui_game_item_t = class("ui_game_item_t", NodeBase)

function ui_game_item_t:ctor(gameId)
	ui_game_item_t.super.ctor(self)

	self.gameId_ = gameId

	self.icon_ = cc.Sprite:create(string.format("fullmain/res/games/%d.png", self.gameId_))
	self.icon_:setAnchorPoint(CCPointZero)
	self:addChild(self.icon_)

	local size = self.icon_:getContentSize()
	self:setContentSize(size)
	self:setAnchorPoint(CCPointMidCenter)

	local cfg = games_config[self.gameId_]
	if cfg.open == 0 then
		--未开放
		self.icon_:setColor(COLOR_DIM)
	else
		--已开放
		self.icon_:setColor(COLOR_WHITE)
	end
end

function ui_game_item_t:getTouchRect()
	local border = 25 * self:getScale()
	local rect = self:getBoundingBox()
	rect.x = rect.x + border
	rect.y = rect.y + border
	rect.width = rect.width - border*2
	rect.height = rect.height - border*2

	return rect
end

function ui_game_item_t:setIdle()
	--闲置中
	-- self.icon_:stopActionByTag(1001)

	-- self.icon_:setTexture(string.format("fullmain/res/games/%d.png", self.gameId_))
end

function ui_game_item_t:setActivity()
	--活动中
	-- self.icon_:stopActionByTag(1001)

	-- local cfg = games_config[self.gameId_]
	-- if cfg.open == 1 then
	-- 	local animation = cc.Animation:create()
	-- 	for i = 1, 2 do
	-- 		animation:addSpriteFrameWithFile(string.format("fullmain/res/games/%d_%d.png", self.gameId_, i))
	-- 	end
	-- 	animation:setDelayPerUnit(0.5)

	-- 	local action = cc.RepeatForever:create(cc.Animate:create(animation))
	-- 	action:setTag(1001)
	-- 	self.icon_:runAction(action)
	-- end
end
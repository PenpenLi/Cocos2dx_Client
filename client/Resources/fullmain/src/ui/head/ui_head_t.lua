ui_head_t = class("ui_head_t", NodeBase)

function ui_head_t:ctor(playerId, sizeHead, pathMask, rect9Mask, sizeMask)
	ui_head_t.super.ctor(self)

	self.playerId_ = playerId
	self.sizeHead_ = sizeHead
	self.pathMask_ = pathMask
	self.rect9Mask_ = rect9Mask
	self.sizeMask_ = sizeMask

	if global.g_mainPlayer:isHead3rdExist(self.playerId_) then
		local faceUrl = global.g_mainPlayer:getHead3rd(self.playerId_)
		self:onGetWechatFace(self.playerId_, faceUrl)
	else
		gatesvr.sendGetWxFace(self.playerId_)
		global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GET_WECHAT_FACE, self, self.onGetWechatFace)
	end
end

function ui_head_t:onGetWechatFace(playerId, faceUrl)
	if playerId ~= self.playerId_ then return end

	if faceUrl == "" then
		local pathFace = string.format("fullmain/res/portrait/head/%d.jpg", (self.playerId_ % 9) + 1)
		local nodeHead = ui_head_local_t.new(pathFace, self.sizeHead_, self.pathMask_, self.rect9Mask_, self.sizeMask_)
		self:addChild(nodeHead)
	else
		local nodeHead = ui_head_remote_t.new(faceUrl, self.sizeHead_, self.pathMask_, self.rect9Mask_, self.sizeMask_)
		self:addChild(nodeHead)
	end

	self:removeMsgHandler()
end

function ui_head_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GET_WECHAT_FACE, self)
end
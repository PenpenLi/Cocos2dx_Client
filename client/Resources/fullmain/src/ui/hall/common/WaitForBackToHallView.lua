WaitForBackToHallView = class("WaitForBackToHallView", PopUpView)

function WaitForBackToHallView:ctor(callback)
	WaitForBackToHallView.super.ctor(self, true)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("main/res/json/ui_main_loading.json")
	self.nodeUI_:addChild(root)

	local content = LocalLanguage:getLanguageString("L_0ef3cc99a0ff7fee")
	self.callback_ = callback

	self.labelContent_ = ccui.Helper:seekWidgetByName(root, "Label_2")
	self.labelContent_:setString(content)
	local timeoutAction = cc.Sequence:create(
			cc.DelayTime:create(5),
			cc.CallFunc:create(function()
						self.callback_()
						self:close()
					end
				)
		)
	self.labelContent_:runAction(timeoutAction)

	local iconLoad = ccui.Helper:seekWidgetByName(root, "Image_1")
	iconLoad:setScale(0.6)
	local action = cc.RepeatForever:create(cc.RotateBy:create(5, 359))
	iconLoad:runAction(action)
end

function WaitForBackToHallView:onRoomUserStandUp(playerId, tableId, chairId, status)
	local ownerId = global.g_mainPlayer:getPlayerId()
	if playerId == ownerId then
		self.labelContent_:stopAllActions()

		self.callback_()

  	self:close()
	end
end

function WaitForBackToHallView:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self, self.onRoomUserStandUp)
end

function WaitForBackToHallView:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_ROOM_USER_FREE, self)
end
ui_turntable_t = class("ui_turntable_t", PopUpView)

--[[开奖结果
0---	200金币
1---	100金币
2---	100金币+1啤酒
3---	100金币+1咖啡
4---	100金币+5啤酒
5---	100金币+5咖啡
6---	100金币+12啤酒
7---	100金币+12咖啡
]]

local LOTTERY_ITEMS = {
	[0] = {{{0,200}}, 0},
	[1] = {{{0,100}}, 36},
	[2] = {{{0,100}, {1,1}}, 72},
	[3] = {{{0,100}, {2,1}}, 108},
	[4] = {{{0,100}, {1,5}}, 144},
	[5] = {{{0,100}, {2,5}}, 180},
	[6] = {{{0,100}, {1,12}}, 216},
	[7] = {{{0,100}, {2,12}}, 252},
}

function ui_turntable_t:ctor(scene)
	ui_turntable_t.super.ctor(self, true)

	self.scene_ = scene

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("fullmain/res/json/ui_main_turntable.json")
	self.nodeUI_:addChild(root)

	self.turntable_ = ccui.Helper:seekWidgetByName(root, "Image_2")

	self.btnLottery_ = ccui.Helper:seekWidgetByName(root, "Button_3")
	self.btnLottery_:addTouchEventListener(makeClickHandler(self, self.onLotteryHandler))

	local btnRule = ccui.Helper:seekWidgetByName(root, "Button_10")
	btnRule:addTouchEventListener(makeClickHandler(self, self.onRuleHandler))

	self.tablePanel_ = ccui.Helper:seekWidgetByName(root, "Panel_Lottery")
	self.rulePanel_ = ccui.Helper:seekWidgetByName(root, "Image_11")
end

function ui_turntable_t:onRuleHandler()
	if self.moving_ then
		return
	end

	self.moving_ = true

	if self.openRule_ then
		--隐藏规则
		local action1 = cc.MoveTo:create(0.2, cc.p(0, 0)) 
		self.tablePanel_:runAction(action1)

		local action2 = cc.Sequence:create(
			cc.MoveTo:create(0.2, cc.p(-606, 263)),
			cc.CallFunc:create(function()
					self.openRule_ = nil
					self.moving_ = nil
				end))
		self.rulePanel_:runAction(action2)
	else
		--打开规则
		local action1 = cc.MoveTo:create(0.2, cc.p(-190, 0))
		self.tablePanel_:runAction(action1)

		local action2 = cc.Sequence:create(
			cc.MoveTo:create(0.2, cc.p(0, 263)),
			cc.CallFunc:create(function()
					self.openRule_ = true
					self.moving_ = nil
				end))
		self.rulePanel_:runAction(action2)
	end
end

function ui_turntable_t:onLotteryHandler()
	self:startLottery()

	self.btnLottery_:setEnabled(false)
end

function ui_turntable_t:startLottery()
	LoadingView.showTips()

	gatesvr.sendTurntableLottery(self.scene_)
end

function ui_turntable_t:onLotteryResultHandler(lottery, orderId)
	local t = LOTTERY_ITEMS[lottery]
	local rotation = t[2]
	local rotationHead = 360 * 2
	local rotationMid = 360 * 4
	local rotateLast = 360 * 2 + 360 - rotation

	local action = cc.Sequence:create(
				cc.EaseQuarticActionIn:create(cc.RotateTo:create(rotationHead * 0.002, rotationHead)),
				cc.RotateTo:create(rotationMid * 0.001, rotationMid),
				cc.EaseQuarticActionOut:create(cc.RotateTo:create(rotateLast * 0.005, rotateLast)),
				cc.CallFunc:create(function()
					PopUpView.showPopUpView(ui_turntable_reward_t, t[1], orderId)
					global.g_gameDispatcher:sendMessage(GAME_MESSAGE_HALL_SCORE_CHANGE)

					self:close()
				end)
			)
	self.turntable_:runAction(action)
end

function ui_turntable_t:initMsgHandler()
	global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_LOTTERY_RESULT, self, self.onLotteryResultHandler)
end

function ui_turntable_t:removeMsgHandler()
	global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_LOTTERY_RESULT, self)
end
--
-- Author: Yang
-- Date: 2016-10-28 09:05:48
--
SettleView = class("SettleView",PopUpView)

function SettleView:ctor()
	SettleView.super.ctor(self, true)

	--获取ui_settle的json文件
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_settle.json")
	self.nodeUI_:addChild(root)

	local btn_ok   = ccui.Helper:seekWidgetByName(root,"btn_ok")
	local btn_close= ccui.Helper:seekWidgetByName(root,"btn_close")
	local bl_score = ccui.Helper:seekWidgetByName(root,"scoretest")
	local bl       = global.g_mainPlayer:getCurrentRoomBeilv()
	bl_score :setString(bl)
	btn_ok   :addTouchEventListener(makeClickHandler(self,self.onOKHandler))
	btn_close:addTouchEventListener(makeClickHandler(self,self.onCloseHandler))

	local gold     = math.floor(GameScene.score_/bl)
	self.scorelab_ = ccui.Helper:seekWidgetByName(root,"scorelab")
	self.glodlab_  = ccui.Helper:seekWidgetByName(root,"glodlab")
	self.scorelab_ :setString(GameScene.score_)
	self.glodlab_  :setString(gold)
end

--ok按钮
function SettleView:onOKHandler()
	local ratio    = global.g_mainPlayer:getCurrentRoomBeilv()
	if GameScene.score_ > ratio then
		local gold   = math.floor(GameScene.score_/ratio)
		local remain = GameScene.score_ % ratio

		GameScene.gold_ = GameScene.gold_ + gold
		GameScene.score_= remain
		global.g_gameDispatcher:sendMessage(GAME_EXCHANGE_GOLD_SUCCESS)
		gamesvr.sendUpScore(-1)
	end
	self:close()
	print("ok按钮")
end

--close按钮
function SettleView:onCloseHandler()
	self:close()
end
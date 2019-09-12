LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
	LoadScene.super.ctor(self)

	-- local root = ccs.GUIReader:getInstance():widgetFromJsonFile("feiqinzoushou/res/json/ui_loading.json")
	-- self:addChild(root)

	-- local progress = ccui.Helper:seekWidgetByName(root, "ProgressBar_3")
	-- progress:setPercent(0)

	-- local percent = 0
	-- local scheduleId
	-- local function onUpdate()
	-- 	local percent = progress:getPercent()
	-- 	if percent < 100 then
	-- 		progress:setPercent(percent + 1)
	-- 		percent = percent + 1
	-- 	else
	-- 		cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)
	-- 		self:enterGame()
	-- 	end
	-- end
	-- scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onUpdate, 0, false)

	-- gamesvr.sendLoginGame()

	-- self:enterGame()
end

function LoadScene:enterGame()
	print("进入游戏")
	-- local scene = GameScene.new()
	-- cc.Director:getInstance():replaceScene(scene)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
	-- gamesvr.sendLoginGame()
end

function LoadScene:onEndEnterTransition()
    self:enterGame()
end
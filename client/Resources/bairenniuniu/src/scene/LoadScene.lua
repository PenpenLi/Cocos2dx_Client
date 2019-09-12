LoadScene = class("LoadScene", LayerBase)

local winSize = cc.Director:getInstance():getWinSize()
function LoadScene:ctor()
	LoadScene.super.ctor(self)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("bairenniuniu/res/json/ui_loading1.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	local version = ccui.Helper:seekWidgetByName(root, "Label_7")
  	version:setTextColor(cc.c4b(255, 0, 0, 255))
  	version:setString("version: 2")

	--获取进度条,初始值设为0
	self.progress_Bar_ = ccui.Helper:seekWidgetByName(root,"ProgressBar_4")
	self.fire_         = ccui.Helper:seekWidgetByName(root,"fire")
	self.progress_Bar_:setPercent(0)
end

function LoadScene:enterGame()
	print("进入游戏")

	-- local scene = GameScene.new()
	-- cc.Director:getInstance():replaceScene(scene)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
	-- global.g_gameScene_ = scene
	gamesvr.sendLoginGame()
end

function LoadScene:startLoad()
	local function onUpdate()
		local barPercent = self.progress_Bar_:getPercent()
		if barPercent < 100 then
			self.fire_:setPositionX(self.fire_:getPositionX()+self.progress_Bar_:getContentSize().width*(1/100))
			self.progress_Bar_:setPercent(barPercent+1)
		else
			self.fire_:setVisible(false)
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickLoad_)
			self.tickLoad_ = nil
			self:enterGame()
		end	
	end
	self.tickLoad_ = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onUpdate, 0, false)
end

function LoadScene:stopLoad()
    if self.tickLoad_ then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.tickLoad_)
        self.tickLoad_ = nil
    end
end

function LoadScene:onEndEnterTransition()
    self:startLoad()
end

function LoadScene:onStartExitTransition()
    self:stopLoad()
end
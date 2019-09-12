LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
	LoadScene.super.ctor(self)

	--预加载
	for i=0,5 do
		local plist = string.format("caidaxiao/res/game/BiBei/pvr/BiBei%d.plist", i)
		cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
		cc.SpriteFrameCache:getInstance():retainPlist(plist)
	end

	for i=0,3 do
		local plist = string.format("caidaxiao/res/game/type/pvr/type%d.plist", i)
		cc.SpriteFrameCache:getInstance():addSpriteFrames(plist)
		cc.SpriteFrameCache:getInstance():retainPlist(plist)
	end
	
	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("caidaxiao/res/json/ui_loading.json")
	root:setClippingEnabled(true)
	self:addChild(root)

	self.progress_ = ccui.Helper:seekWidgetByName(root, "ProgressBar_3")
	self.progress_:setPercent(0)

	-- gamesvr.sendGameOption()
end

function LoadScene:enterGame()
	print("进入游戏")

	-- local scene = GameScene.new()
	-- cc.Director:getInstance():replaceScene(scene)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
end

function LoadScene:startLoad()
	local function onUpdate()
		local percent = self.progress_:getPercent()
		if percent < 100 then
			self.progress_:setPercent(percent + 1)
		else
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
	AudioEngine.stopMusic(true)
  self:stopLoad()
end
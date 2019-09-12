LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
	LoadScene.super.ctor(self)

	local root = ccs.GUIReader:getInstance():widgetFromJsonFile("daxiao/res/json/ui_loading.json")
	self:addChild(root)

	local version = ccui.Helper:seekWidgetByName(root, "Label_5")
	version:setString("version:2")

	local progress = ccui.Helper:seekWidgetByName(root, "ProgressBar_3")
	progress:setPercent(0)

	local scheduleId
	local function onUpdate()
		local percent = progress:getPercent()
		if percent < 100 then
			progress:setPercent(percent + 1)
		else
			cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)
			self:enterGame()
		end
	end

	scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onUpdate, 0, false)
	local function loadingFinished()

	end
	local str=nil
	for i=30,150 do
		str="daxiao/res/game/fight/CJB__"..i..".png"
  		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
	end
	for i=30,119 do
		str="daxiao/res/game/fight2/CJB__"..i..".png"
  		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
	end
	for i=30,90 do
		str="daxiao/res/game/blue/enger1/Continued__"..i..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
		str="daxiao/res/game/blue/enger2/Continued2__"..i..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)

		if i<90 then
			str="daxiao/res/game/green/enger1/Continued__"..i..".png"
			cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
		end
		str="daxiao/res/game/green/enger2/Continued2__"..i..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)

		str="daxiao/res/game/red/enger1/Continued__"..i..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
		str="daxiao/res/game/red/enger2/Continued2__"..i..".png"
		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
	end
    for i=1,31 do
		str="daxiao/res/game/blue/enger/Continued_"..i..".png"
		if i<=16 then
  			cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
  			str="daxiao/res/game/red/enger/Continued_"..i..".png"
  			cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
  		end
  		if i<=30 then
	  		str="daxiao/res/game/gameover/KO_"..i..".png"
	  		cc.Director:getInstance():getTextureCache():addImageAsync(str,loadingFinished)
  		end
  	end
end

function LoadScene:enterGame()
	print("进入游戏")
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

	gamesvr.sendLoginGame()
end
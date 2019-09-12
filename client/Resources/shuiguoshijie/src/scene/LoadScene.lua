LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
  LoadScene.super.ctor(self)

	local winSize =  cc.Director:getInstance():getWinSize() 
	--进度条
	self.right = cc.ProgressTimer:create(cc.Sprite:create("shuiguoshijie/res/sprite/bar_full.png"))  
	self.right:setType(cc.PROGRESS_TIMER_TYPE_BAR)  
	self.right:setMidpoint(cc.p(0,0))
	self.right:setScale(500/825)
	self.right:setPosition(cc.p(winSize.width/2, winSize.height/2-240))  
	self.right:setBarChangeRate(cc.p(1, 0))  
	self:addChild(self.right,2)

	--进度条背景
	self.babg = cc.Sprite:create("shuiguoshijie/res/sprite/loading_bg.png")
	self.babg:setPosition(winSize.width/2, winSize.height/2-255)
	self.babg:setScale(500/825)
	self:addChild(self.babg,1)

	self.bg = cc.Sprite:create("shuiguoshijie/res/sprite/fruit_welcome_bg.jpg")
	self.bg:setPosition(winSize.width/2,winSize.height/2)  
	self.bg:setAnchorPoint(cc.p(0.5,0.5))                                
	self:addChild(self.bg)
	self:enableNodeEvents(true)

  local version = cc.LabelTTF:create("version:3", "arial", 24)
  version:setAnchorPoint(cc.p(1, 0.5))
  version:setPosition(winSize.width/2 + 400, winSize.height/2 - 585)
  self:addChild(version, 1)
end

function LoadScene:onEndEnterTransition()
  	self:loadmag()
end

function LoadScene:loadmag( ... )
	local function edback( ... )
		-- local secondScene = GameScene.new()
  --   	--local tranceAnima = cc.TransitionFlipX:create(0.5,secondScene)
  --   	cc.Director:getInstance():replaceScene(secondScene)
    replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

      gamesvr.sendLoginGame()
	end
	local funcall = cc.CallFunc:create(edback)
	self.right:runAction(cc.Sequence:create(cc.ProgressTo:create(1,100),funcall))
end
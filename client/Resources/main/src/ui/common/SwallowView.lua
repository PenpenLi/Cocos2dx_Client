--模态界面,吞噬触摸事件
SwallowView = class("SwallowView", LayerBase)

function SwallowView.showSwallowView(cls, ...)
	local scene = cc.Director:getInstance():getRunningScene()
	local popup = cls.new(...)
	-- scene:addChild(popup)
	scene:addChildWithLayerType(MAIN_LAYER.LAYER_POPUP, popup)

	return popup
end

function SwallowView.closeSwallowView(view)
	view:removeFromParent()
end

function SwallowView:ctor(bSwallow, clr)
	SwallowView.super.ctor(self)

	self.isSwallow_ = bSwallow or false
	
	if self.isSwallow_ then
		self.maskLayer_ = cc.LayerColor:create(clr or cc.c4b(0, 0, 0, 128))
		self:addChild(self.maskLayer_)
	end
end

function SwallowView:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
	-- print("SwallowView touchBegan ...")
	return self.isSwallow_
end

function SwallowView:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
	-- print("SwallowView touchMoved ...")
end

function SwallowView:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
	-- print("SwallowView touchEnded ...")
end

function SwallowView:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
	-- print("SwallowView touchCancelled ...")
end
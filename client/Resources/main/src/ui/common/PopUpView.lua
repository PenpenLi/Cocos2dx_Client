--弹出界面
PopUpView = class("PopUpView", SwallowView)

function PopUpView.showPopUpView(cls, ...)
	local scene = cc.Director:getInstance():getRunningScene()
	local popup = cls.new(...)
	-- scene:addChild(popup, POPUP_ZORDER)
	scene:addChildWithLayerType(MAIN_LAYER.LAYER_POPUP, popup)

	popup.nodeUI_:setScale(0)

	local action = cc.Sequence:create(
			{
				cc.EaseBackOut:create(cc.ScaleTo:create(0.3, 1)),
				cc.CallFunc:create(handler(popup, popup.onPopUpComplete))
			}
		)
	popup.nodeUI_:runAction(action)

	return popup
end

function PopUpView.closePopUpView(view)
	local action = cc.Sequence:create(
			{
				cc.EaseBackIn:create(cc.ScaleTo:create(0.2, 0)),
				cc.CallFunc:create(function()
					view:onPopBackComplete()
					view:removeFromParent()
				end)
			}
		)
	view.nodeUI_:runAction(action)
end

function PopUpView:onPopUpComplete()
	--弹出效果结束后调用
	print("打开界面完成")
end

function PopUpView:onPopBackComplete()
	--关闭效果结束后调用
	print("关闭界面完成")
end

function PopUpView:ctor(bSwallow, clr)
	PopUpView.super.ctor(self, bSwallow, clr)

	self.nodeUI_ = cc.Node:create()
	self.nodeUI_:setPosition(cc.p(display.cx, display.cy))
	self:addChild(self.nodeUI_, 2)
end

function PopUpView:close()
	--子类可继承,但要调用基类
	PopUpView.closePopUpView(self)
end
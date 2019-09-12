LayerBase = class("LayerBase", function ()
		return cc.Layer:create()
	end)

function LayerBase:ctor()
	NodeBase.ctor(self)

	if self.touchBegan ~= nil then
		--单点触控
		local function onTouchBegan(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			return self:touchBegan(cur.x, cur.y, pre.x, pre.y)
		end

		local function onTouchMoved(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchMoved(cur.x, cur.y, pre.x, pre.y)
		end

		local function onTouchEnded(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchEnded(cur.x, cur.y, pre.x, pre.y)
		end

		local function onTouchCancelled(touch, event)
			local cur = touch:getLocation()
			local pre = touch:getPreviousLocation()
			self:touchCancelled(cur.x, cur.y, pre.x, pre.y)
		end

		local listener = cc.EventListenerTouchOneByOne:create()
		listener:setSwallowTouches(true)
		listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
		listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
		listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
		listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	elseif self.touchesBegan ~= nil then
		--多点触控
		local function onTouchesBegan(touches, event)
			local t = {}
			for _, v in ipairs(touches) do
				local cur = v:getLocation()
				local pre = v:getPreviousLocation()
				table.insert(t, cur.x)
				table.insert(t, cur.y)
				table.insert(t, pre.x)
				table.insert(t, pre.y)
			end
			self:touchesBegan(t)
		end

		local function onTouchesMoved(touches, event)
			local t = {}
			for _, v in ipairs(touches) do
				local cur = v:getLocation()
				local pre = v:getPreviousLocation()
				table.insert(t, cur.x)
				table.insert(t, cur.y)
				table.insert(t, pre.x)
				table.insert(t, pre.y)
			end
			self:touchesMoved(t)
		end

		local function onTouchesEnded(touches, event)
			local t = {}
			for _, v in ipairs(touches) do
				local cur = v:getLocation()
				local pre = v:getPreviousLocation()
				table.insert(t, cur.x)
				table.insert(t, cur.y)
				table.insert(t, pre.x)
				table.insert(t, pre.y)
			end
			self:touchesEnded(t)
		end

		local function onTouchesCancelled(touches, event)
			local t = {}
			for _, v in ipairs(touches) do
				local cur = v:getLocation()
				local pre = v:getPreviousLocation()
				table.insert(t, cur.x)
				table.insert(t, cur.y)
				table.insert(t, pre.x)
				table.insert(t, pre.y)
			end
			self:touchesCancelled(t)
		end

		local listener = cc.EventListenerTouchAllAtOnce:create()
		listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN )
		listener:registerScriptHandler(onTouchesMoved,cc.Handler.EVENT_TOUCHES_MOVED )
		listener:registerScriptHandler(onTouchesEnded,cc.Handler.EVENT_TOUCHES_ENDED )
		listener:registerScriptHandler(onTouchesCancelled,cc.Handler.EVENT_TOUCHES_CANCELLED )
		local eventDispatcher = self:getEventDispatcher()
		eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
	end

    --子类构造keycode回调映射
    -- self.keypadHanlder_ = {
    --   [6] = self.keyboardBackClicked,
    --   [18] = self.keyboardMenuClicked,
    -- }

    if self.keypadHanlder_ then
        local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(handler(self, self.keyboardReleased), cc.Handler.EVENT_KEYBOARD_RELEASED)
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    end
end

function LayerBase:keyboardReleased(keycode, event)
    if self.waitHandler_ or global.g_loading_ then
        --上一次按键处理未完成
        return
    end

    local handle = self.keypadHanlder_[keycode]
    if handle then
        --设置处理等待标记
        self.waitHandler_ = true

        handle(self)
    end
end

function LayerBase:keyboardHandleRelease()
    self.waitHandler_ = nil
end

function LayerBase:close()
	NodeBase.close(self)
end

function LayerBase:onEnter()
	NodeBase.onEnter(self)
end

function LayerBase:onExit()
	NodeBase.onExit(self)
end

function LayerBase:onEnterTransitionFinish()
	NodeBase.onEnterTransitionFinish(self)
end

function LayerBase:onExitTransitionStart()
	NodeBase.onExitTransitionStart(self)
end

function LayerBase:onCleanup()
	NodeBase.onCleanup(self)
end

function LayerBase:close()
	NodeBase.close(self)
end

function LayerBase:initMsgHandler()
	NodeBase.initMsgHandler(self)
end

function LayerBase:removeMsgHandler()
	NodeBase.removeMsgHandler(self)
end

function LayerBase:onStartEnterTransition()

end

function LayerBase:onEndEnterTransition()

end

function LayerBase:onStartExitTransition()

end

function LayerBase:onEndExitTransition()

end

--[[
function LayerBase:touchesBegan(_touches)
    --cclog("touchesBegan")
end

function LayerBase:touchesMoved(_touches)
    --cclog("touchesMoved")
end

function LayerBase:touchesEnded(_touches)
    --cclog("touchesEnded")
end

function LayerBase:touchesCancelled(_touches)
    --cclog("touchesCancelled")
end
--]]

--[[
function LayerBase:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchBegan")
    return true
end

function LayerBase:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchMoved")
end

function LayerBase:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchEnded")
end

function LayerBase:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchCancelled")
end
--]]
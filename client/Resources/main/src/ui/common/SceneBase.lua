SceneBase = class("SceneBase", function()
        -- return cc.Scene:create()
        local scene = cc.Scene:createWithPhysics()
        local physicsWorld = scene:getPhysicsWorld()
        physicsWorld:setAutoStep(false)
        return scene
    end)

function SceneBase:ctor()
    LayerBase.ctor(self)
end

function SceneBase:openPhysicsWorld()
  local physicsWorld = self:getPhysicsWorld()
  physicsWorld:setAutoStep(true)
end

function SceneBase:closePhysicsWorld()
  local physicsWorld = self:getPhysicsWorld()
  physicsWorld:setAutoStep(false)
end

--[[
function SceneBase:touchesBegan(_touches)
    --cclog("touchesBegan")
end

function SceneBase:touchesMoved(_touches)
    --cclog("touchesMoved")
end

function SceneBase:touchesEnded(_touches)
    --cclog("touchesEnded")
end

function SceneBase:touchesCancelled(_touches)
    --cclog("touchesCancelled")
end
--]]

--[[
function SceneBase:touchBegan(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchBegan")
    return true
end

function SceneBase:touchMoved(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchMoved")
end

function SceneBase:touchEnded(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchEnded")
end

function SceneBase:touchCancelled(_touchX, _touchY, _preTouchX, _preTouchY)
    --cclog("touchCancelled")
end
]]

function SceneBase:keyboardReleased(keycode, event)
    LayerBase.keyboardReleased(self, keycode, event)
end

function SceneBase:keyboardHandleRelease()
    LayerBase.keyboardHandleRelease(self)
end

function SceneBase:onEnter()
    LayerBase.onEnter(self)
end

function SceneBase:onExit()
    LayerBase.onExit(self)
end

function SceneBase:onEnterTransitionFinish()
    LayerBase.onEnterTransitionFinish(self)
end

function SceneBase:onExitTransitionStart()
    LayerBase.onExitTransitionStart(self)
end

function SceneBase:onCleanup()
    LayerBase.onCleanup(self)
end

function SceneBase:initMsgHandler()
    LayerBase.initMsgHandler(self)
end

function SceneBase:removeMsgHandler()
    LayerBase.removeMsgHandler(self)
end
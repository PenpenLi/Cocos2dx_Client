MainScene = class("MainScene", SceneBase)

MAIN_SCENE_TYPE = {
    SCENE_NORMAL = 1, --普通场景
    SCENE_UPDATE = 2, --热更场景
}

TRANS_CONST = {
    TRANS_DELAY = 1, --延迟
    TRANS_MOVE = 2, --平移
    TRANS_SCALE = 3, --缩放
}

MAIN_LAYER = {
    LAYER_SCENE = 1, --场景层
    LAYER_VIEW = 2, --界面层
    LAYER_POPUP = 3, --弹框层
    LAYER_TOP = 4, --顶层
    LAYER_TIPS = 5, --提示层
    LAYER_SWALLOW = 6, --吞噬层
}

MAIN_LAYER_LIST = {
    MAIN_LAYER.LAYER_SCENE,
    MAIN_LAYER.LAYER_VIEW,
    MAIN_LAYER.LAYER_POPUP,
    MAIN_LAYER.LAYER_TOP,
    MAIN_LAYER.LAYER_TIPS,
    MAIN_LAYER.LAYER_SWALLOW,
}

function MainScene:ctor(sceneType)
    MainScene.super.ctor(self)

    self.sceneType_ = sceneType or MAIN_SCENE_TYPE.SCENE_NORMAL

    self.mainLayers_ = {}
    self.transitionScenes_ = {}

    for i = 1, #MAIN_LAYER_LIST do
        local lt = MAIN_LAYER_LIST[i]
        local l = cc.Layer:create()
        self.mainLayers_[lt] = l
        self:addChild(l)
    end

    self.layerSwallow_ = self.mainLayers_[MAIN_LAYER.LAYER_SWALLOW]

    local function onTouchBegan(touch, event)
        return self.transitioning_
    end

    local function onTouchMoved(touch, event)

    end

    local function onTouchEnded(touch, event)

    end

    local function onTouchCancelled(touch, event)

    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self.layerSwallow_:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.layerSwallow_)
end

function MainScene:replaceScene(classT, trans, ...)
    table.insert(self.transitionScenes_, {class = classT, trans = trans, options = {...}})
    self:check2Transition()
end

function MainScene:check2Transition()
    if self.transitioning_ then return end

    if #self.transitionScenes_ > 0 then
        self:startTransition()
    end
end

function MainScene:startTransition()
    global.g_gameDispatcher:sendMessage(GAME_MESSAGE_REPLACE_SCENE)

    self.transitioning_ = true

    local sd = table.remove(self.transitionScenes_, 1)
    local classT = sd.class
    local options = sd.options
    local nodeView = classT.new(unpack(options))

    local l = self.mainLayers_[MAIN_LAYER.LAYER_SCENE]
    local oChild = l:getChildByTag(0)

    if oChild then
        oChild:setTag(1)
        oChild:setLocalZOrder(1)

        local oAction = cc.Sequence:create(
                {
                    cc.CallFunc:create(function()
                            if oChild.onStartExitTransition then
                                oChild:onStartExitTransition()
                            end
                        end),
                    cc.Spawn:create(
                            {
                                cc.ScaleTo:create(0.3, 0),
                                cc.MoveTo:create(0.3, cc.p(-display.width, 0))
                            }
                        ),
                    cc.CallFunc:create(function()
                            if oChild.onEndExitTransition then
                                oChild:onEndExitTransition()
                            end

                            oChild:removeFromParent()
                        end),
                }
            )
        oChild:runAction(oAction)
    end

    local inAction = nil
    if sd.trans == TRANS_CONST.TRANS_DELAY then
        inAction = cc.DelayTime:create(0.5)
    elseif sd.trans == TRANS_CONST.TRANS_MOVE then
        nodeView:setPosition(cc.p(display.width, 0))
        inAction = cc.EaseBackOut:create(cc.MoveTo:create(0.5, cc.p(0, 0)))
    elseif sd.trans == TRANS_CONST.TRANS_SCALE then
        nodeView:setScale(0)
        inAction = cc.EaseBackOut:create(cc.ScaleTo:create(0.5, 1))
    end

    self:addChildWithLayerType(MAIN_LAYER.LAYER_SCENE, nodeView, 0, 0)

    local nAction = cc.Sequence:create(
            {
                cc.CallFunc:create(function()
                        if nodeView.onStartEnterTransition then
                            nodeView:onStartEnterTransition()
                        end
                    end),
                inAction,
                cc.CallFunc:create(function()
                        if nodeView.onEndEnterTransition then
                            nodeView:onEndEnterTransition()
                        end

                        self.transitioning_ = nil

                        self:check2Transition()
                    end),
            }
        )
    nodeView:runAction(nAction)
end

function MainScene:addChildWithLayerType(layerType, nodeView, zorder, tag)
    zorder = zorder or 0
    tag = tag or 0

    local l = self.mainLayers_[layerType]
    l:addChild(nodeView, zorder, tag)
end

function MainScene:startUpdate()
    replaceScene(UpdateScene, TRANS_CONST.TRANS_DELAY)
end

function MainScene:onEnterTransitionFinish()
    if self.sceneType_ == MAIN_SCENE_TYPE.SCENE_NORMAL then
        --普通场景,无处理
    else
        --更新场景,热更新
        self:startUpdate()
    end
end
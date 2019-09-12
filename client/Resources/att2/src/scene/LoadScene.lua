LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
    LoadScene.super.ctor(self)

    local root = ccs.GUIReader:getInstance():widgetFromJsonFile("att2/res/json/ui_loading.json")
    root:setClippingEnabled(true)
    self:addChild(root)

    local version = ccui.Helper:seekWidgetByName(root, "Label_6")
    version:setString("version: 3")

    self.progress_ = ccui.Helper:seekWidgetByName(root, "ProgressBar_barFull")
    self.light_ = ccui.Helper:seekWidgetByName(root, "Image_light")
    self.progress_:setPercent(0)

    -- local progress = ccui.Helper:seekWidgetByName(root, "ProgressBar_barFull")
    -- local light = ccui.Helper:seekWidgetByName(root, "Image_light")
    -- progress:setPercent(0)

    -- local scheduleId
    -- local width = progress:getContentSize().width
    -- local height = progress:getContentSize().height
    -- local initial = width / 100 * -1;
    -- local schedule
    -- local function onUpdate()
    --     local percent = progress:getPercent()
    --     if percent < 100 then
    --         progress:setPercent(percent + 1)
    --         schedule = initial + width / 100 * (percent + 1)
    --         light:setPosition(schedule, height / 2);
    --     else
    --         cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduleId)
    --         self:enterGame()
    --     end
    -- end

    -- scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(onUpdate, 0, false)
end

function LoadScene:startLoad()
    local width = self.progress_:getContentSize().width
    local height = self.progress_:getContentSize().height
    local initial = width / 100 * -1;
    local schedule
    local function onUpdate()
        local percent = self.progress_:getPercent()
        if percent < 100 then
            self.progress_:setPercent(percent + 1)
            schedule = initial + width / 100 * (percent + 1)
            self.light_:setPosition(schedule, height / 2);
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

function LoadScene:enterGame()
    print("进入游戏")
    -- local scene = GameScene.new()
    -- cc.Director:getInstance():replaceScene(scene)
    replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
    
    gamesvr.sendLoginGame()
    gamesvr.sendUserReady()
end

function LoadScene:onEndEnterTransition()
    self:startLoad()
end

function LoadScene:onStartExitTransition()
    self:stopLoad()
end
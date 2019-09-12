LoadScene = class("LoadScene", LayerBase)

function LoadScene:ctor()
    LoadScene.super.ctor(self)
    self.direction = 1 -- 强制赋值为1 load场景用横版
    self.paraValueTab = {} -- 游戏参数表

    self:initScene()
end

function LoadScene:initScene()
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()

    local root = ccs.GUIReader:getInstance():widgetFromJsonFile(JSON_LOAD_ROOT[self.direction])
    root:setClippingEnabled(true)
    self:addChild(root)

    local version = ccui.Helper:seekWidgetByName(root, "lab_version")
    version:setString("version:2") 

    self.star =  ccui.Helper:seekWidgetByName(root, "star")
    self.progressBar = ccui.Helper:seekWidgetByName(root, "progressBar")

    self:loadingRes() -- 异步加载资源
    self:loadingSound()
end 

-- 异步加载资源
function LoadScene:loadingRes() 
    local curLoadNum = 0 
    local function loadingTextureCallback(texture) 
        print("Loading Resources") 
        curLoadNum = curLoadNum + 1
        local plistRoot = string.format("wacaibao/res/common/plist/resources_%d.plist", curLoadNum)
        frameCache:addSpriteFrames(plistRoot) 
  
        local percent = curLoadNum / RESOURCES_TOTAL_NUM
        self.progressBar:setPercent(percent * 100)
        self.star:setPositionX(21.5 + percent * STAR_MOVE_DISTANCE[self.direction]) -- 移动总距离 934  起始坐标  x = 21.5

        if curLoadNum == RESOURCES_TOTAL_NUM then 
            gamesvr.sendLoginGame()
        end 
    end 

    for i = 1,  RESOURCES_TOTAL_NUM do
        local cczRoot = string.format("wacaibao/res/common/plist/resources_%d.pvr", i)
        print(cczRoot)
        textureCache:addImageAsync(cczRoot, loadingTextureCallback) 
    end 
end 

function LoadScene:loadingSound()
    -- 预加载背景音和音效
    AudioEngine.preloadMusic("wacaibao/res/common/sound/backgroundMusic.mp3") -- 背景音乐
    AudioEngine.preloadEffect("wacaibao/res/common/sound/blast.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/compositeFlame.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/iceFracture.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/maglcLampRemove.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/remove.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/lightningRemove.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/getTreasure.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/moveUp.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/removeMud.mp3")  -- 音效
    AudioEngine.preloadEffect("wacaibao/res/common/sound/click.mp3")  -- 音效
end 


function LoadScene:enterGame()
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    local frame_size = glview:getFrameSize()

    if HORV == 1 then
        -- glview:setDesignResolutionSize(1707, 960, cc.ResolutionPolicy.FIXED_HEIGHT)
        display.setAutoScale(
                {
                    width = 1707,
                    height = 960,
                    autoscale = "FIXED_HEIGHT",
                }
            )
    else
        changeOrientation(1)
        -- if cc.PLATFORM_OS_WINDOWS ~= PLATFROM then
        --     -- glview:setFrameSize(frame_size.height, frame_size.width)
        --     glview:setFrameSize(frame_size.height, frame_size.width)
        -- else
        --     -- glview:setFrameSize(450, 800) -- 600, 800  450, 800
        --     glview:setFrameSize(frame_size.height, frame_size.width)
        -- end 
        glview:setFrameSize(PORTRAIT_FRAME_SIZE.width, PORTRAIT_FRAME_SIZE.height)
        -- glview:setDesignResolutionSize(1200, 1600, cc.ResolutionPolicy.FIXED_HEIGHT)
        display.setAutoScale(
                {
                    width = 1200,
                    height = 1600,
                    autoscale = "FIXED_HEIGHT",
                }
            )
        display.centerWindows()
    end 

    -- global.g_nowSceneObj = createObj(WCB_GameScene)
    -- cc.Director:getInstance():replaceScene(global.g_nowSceneObj:getCCScene())
    replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

    handlerDelayed(function()
            global.g_gameDispatcher:sendMessage(GAME_MESSAGE_GAME_OPTION, self.paraValueTab)
        end, 0.04)
end

function LoadScene:onGetParam(paraTab)
    self.paraValueTab = paraTab
end
 --  订阅消息
function LoadScene:onEndEnterTransition()
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_OPTION, self, self.onGetParam)
    global.g_gameDispatcher:addMessageListener(GAME_MESSAGE_GAME_DIRECTIONBACK, self, self.enterGame)
end

function LoadScene:onStartExitTransition()
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_OPTION, self)
    global.g_gameDispatcher:removeMessageListener(GAME_MESSAGE_GAME_DIRECTIONBACK, self)
end



g_wcb_window_size = nil
function start_wacaibao()
    print("启动wacaibao---------------------------------------------------------")

    cc.FileUtils:getInstance():setPopupNotify(false)

    require_ex ("wacaibao.src.util.tools")
    require_ex ("wacaibao.src.util.common")
    require_ex ("wacaibao.src.util.PlanetItem") 
    require_ex ("wacaibao.src.util.ParticleEff") 
    require_ex ("wacaibao.src.ui.ExitView") 
    require_ex ("wacaibao.src.ui.HelpView") 
    require_ex ("wacaibao.src.scene.LoadScene")
    require_ex ("wacaibao.src.prot.pt")
    require_ex ("wacaibao.src.handler.gs_wcb_handler") -- 这个要放到wacaibao.src.handler.gamesvr 前面
    require_ex ("wacaibao.src.handler.gamesvr")
    require_ex ("wacaibao.src.scene.GameScene")

    -- 在这里发送这两个消息 会出现启动两次start_wacaibao（）方法  导致出错
    --gamesvr.sendUserReady() 
    --gamesvr.sendRequestDirection() -- 请求屏幕方向

    g_wcb_window_size = cc.Director:getInstance():getOpenGLView():getFrameSize()

    -- local director = cc.Director:getInstance()
    -- local glview = director:getOpenGLView()
    -- glview:setDesignResolutionSize(1707, 960, cc.ResolutionPolicy.FIXED_HEIGHT)
    display.setAutoScale(
            {
                width = 1707,
                height = 960,
                autoscale = "FIXED_HEIGHT",
            }
        )

    replaceScene(LoadScene, TRANS_CONST.DELAY)

    collectgarbage("collect")
end

function exit_wacaibao()
    print("退出wacaibao---------------------------------------------------------")

    require_ex("main.src.prot.pt_gate")
    require_ex("main.src.prot.pt_game")
    require_ex("main.src.handler.gt_login_handler")
    require_ex("main.src.handler.gt_hall_handler")
    require_ex("main.src.handler.gatesvr")
    require_ex("main.src.handler.gs_room_handler")
    require_ex("main.src.handler.gs_config_handler")
    require_ex("main.src.handler.gamesvr")

    changeOrientation(0)
    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()

    glview:setFrameSize(LANDSCAPE_FRAME_SIZE.width, LANDSCAPE_FRAME_SIZE.height)
    display.setAutoScale(CC_DESIGN_RESOLUTION)
    display.centerWindows()

    UnloadSound()

    local gameId = global.g_mainPlayer:getCurrentGameId()
    replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)

    --声量
    local musicVolume = global.g_mainPlayer:getMusicVolume()
    local effectVolume = global.g_mainPlayer:getEffectVolume()
    AudioEngine.setMusicVolume(musicVolume)
    AudioEngine.setEffectsVolume(effectVolume)

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")

    gatesvr.sendInsureInfoQuery(true)
end

function LoadSound()
    cclog("LoadSound")
    AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
end

function UnloadSound()
    cclog("UnloadSound")
    AudioEngine.stopAllEffects()
    AudioEngine.stopMusic(true)
    AudioEngine.playMusic("fullmain/res/music/background.mp3", true)
end
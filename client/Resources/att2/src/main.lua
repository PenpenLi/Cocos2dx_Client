function start_att2()
    print("启动ATT2---------------------------------------------------------")

    cc.FileUtils:getInstance():setPopupNotify(false)

    require_ex("att2.src.data.LocalStorage")
    require_ex("att2.src.global.global")
    require_ex("att2.src.util.common")
    require_ex("att2.src.util.CommonUtil")
    require_ex("att2.src.util.PokerCard")
    require_ex("att2.src.util.MusicUtil")
    require_ex("att2.src.util.DeskData")
    require_ex("att2.src.util.CardTypeUtil")
    require_ex("att2.src.util.AnimationUtil")
    require_ex("att2.src.util.SchedulerUtil")
    require_ex("att2.src.port.pt")
    require_ex("att2.src.handler.gs_att2_handler")
    require_ex("att2.src.handler.gamesvr")
    require_ex("att2.src.scene.LoadScene")
    require_ex("att2.src.scene.CompareScene")
    require_ex("att2.src.scene.GameScene")
    require_ex("att2.src.scene.RecordScene")

    global.g_attPlayer = createObj(LocalStorage)
    local volume = global.g_mainPlayer:getLocalData("att2_music", 1)
--  local volume = global.g_attPlayer:getMusicVolume()
    if volume > 0 then
        MusicUtil.isPlayMusic = true;
        global.g_musicopen=1;
    elseif volume == 0 then
        MusicUtil.isPlayMusic = false;
        global.g_musicopen=0;
    end
    
    LoadSound()

    local director = cc.Director:getInstance()
    local glview = director:getOpenGLView()
    -- glview:setDesignResolutionSize(1280, 720, cc.ResolutionPolicy.SHOW_ALL)
    display.setAutoScale(
            {
                width = 1280,
                height = 720,
                autoscale = "SHOW_ALL",
            }
        )

    replaceScene(LoadScene, TRANS_CONST.TRANS_SCALE)

    collectgarbage("collect")
end

function exit_att2()
    print("退出ATT2---------------------------------------------------------")

    require_ex("main.src.prot.pt_gate")
    require_ex("main.src.prot.pt_game")
    require_ex("main.src.handler.gt_login_handler")
    require_ex("main.src.handler.gt_hall_handler")
    require_ex("main.src.handler.gatesvr")
    require_ex("main.src.handler.gs_room_handler")
    require_ex("main.src.handler.gs_config_handler")
    require_ex("main.src.handler.gamesvr")

    display.setAutoScale(CC_DESIGN_RESOLUTION)

    local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
    gamesvr.sendExitGame(pd.tableId, pd.chairId)

    UnloadSound()

    local gameId = global.g_mainPlayer:getCurrentGameId()
    replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId, true)

    --声量
    local musicVolume = global.g_mainPlayer:getMusicVolume()
    local effectVolume = global.g_mainPlayer:getEffectVolume()
    AudioEngine.setMusicVolume(musicVolume)
    AudioEngine.setEffectsVolume(effectVolume)
    
    if global.g_musicopen==1 then
        global.g_mainPlayer:setLocalData("att2_music", 1)
    elseif global.g_musicopen==0 then
         global.g_mainPlayer:setLocalData("att2_music", 0)
    end

    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    collectgarbage("collect")
    collectgarbage("collect")
    collectgarbage("collect")
end

function LoadSound()
    cclog("LoadSound")
    -- MusicUtil.startAll()
end

function UnloadSound()
    cclog("UnloadSound")
    MusicUtil.stopAll()
end
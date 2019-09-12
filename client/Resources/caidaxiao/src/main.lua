function start_caidaxiao()
	cclog("start_caidaxiao")
	cc.FileUtils:getInstance():setPopupNotify(false)

	require_ex ("caidaxiao.src.global.global")
	require_ex ("caidaxiao.src.util.common")
	require_ex ("caidaxiao.src.prot.pt")
	require_ex ("caidaxiao.src.handler.gs_caidaxiao_handler")
	require_ex ("caidaxiao.src.handler.gamesvr")
	require_ex ("caidaxiao.src.scene.LoadScene")
	require_ex ("caidaxiao.src.scene.GameScene")


	require_ex ("caidaxiao.src.ui.ui_item_player_t")
	require_ex ("caidaxiao.src.ui.SettingView")
	require_ex ("caidaxiao.src.ui.LuDanView")
	require_ex ("caidaxiao.src.ui.ShuoMingView")
	require_ex ("caidaxiao.src.ui.RoomPlayerView")
	require_ex ("caidaxiao.src.ui.Coin")
	require_ex ("caidaxiao.src.util.SoundManager")

	LoadSound()

	replaceScene(LoadScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("caidaxiao_music", 0.5)
	global.g_mainPlayer:setLocalData("caidaxiao_music", music_percent)
	AudioEngine.setMusicVolume(music_percent)
	local effect_percent = global.g_mainPlayer:getLocalData("caidaxiao_effect", 0.5)
	global.g_mainPlayer:setLocalData("caidaxiao_effect", effect_percent)
	AudioEngine.setEffectsVolume(effect_percent)

	collectgarbage("collect")
end

function exit_caidaxiao()
  require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")

	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")

	display.setAutoScale(CC_DESIGN_RESOLUTION)

	local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
	gamesvr.sendExitGame(pd.tableId, pd.chairId)

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

function LoadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
end

function UnloadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
	AudioEngine.playMusic("main/res/music/background.mp3", true)
end
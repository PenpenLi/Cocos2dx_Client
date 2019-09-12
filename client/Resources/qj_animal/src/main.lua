


function start_qj_animal()
	cc.FileUtils:getInstance():setPopupNotify(false)

	-- require_ex ("qj_animal.src.config")
	-- require_ex ("qj_animal.src.cocos.init")
	require_ex ("qj_animal.src.util.common")
	require_ex ("qj_animal.src.prot.pt")
	require_ex ("qj_animal.src.handler.gs_fish_handler")
	require_ex ("qj_animal.src.handler.gamesvr")
	--require_ex ("qj_animal.src.app.class.SceneFishTrace")
	--require_ex ("qj_animal.src.app.class.SoundManager")
	cc.exports.Data =require_ex "qj_animal.src.app.data.Data"

	cc.exports.Action =require_ex "qj_animal.src.app.class.Action"

	cc.exports.GameScene =           require_ex"qj_animal.src.app.views.GameScene"  
	cc.exports.game_start_qj_animal =require_ex"qj_animal.src.app.views.game_start"  
	cc.exports.CGameBack =           require_ex"qj_animal.src.app.views.CGameBack" 

	cc.exports.g_soundManager=       require_ex"qj_animal.src.app.sound.soundManager" 
	cc.exports.cannonmanager=       require_ex"qj_animal.src.app.CannonManager.CannonManager" 
	cc.exports.CGame_player =       require_ex"qj_animal.src.app.CannonManager.game_player"  
	cc.exports.My_Particle_manager= require_ex"qj_animal.src.app.CannonManager.My_Particle_manager" 


	cc.exports.Coin=require_ex"qj_animal.src.app.CannonManager.Coin" 
	cc.exports.CoinManager=require_ex"qj_animal.src.app.CannonManager.CoinManager" 

	cc.exports.red_coin=            require_ex"qj_animal.src.app.CannonManager.red_coin" 
	cc.exports.red_envelope=        require_ex"qj_animal.src.app.CannonManager.red_envelope" 
	cc.exports.red_envelope_Manager=require_ex"qj_animal.src.app.CannonManager.red_envelope_Manager" 
	cc.exports.ScoreAnimation=      require_ex"qj_animal.src.app.CannonManager.ScoreAnimation" 



	cc.exports.lock_fish_manager=require_ex"qj_animal.src.app.gameFish.lock_fish_manager"  
	cc.exports.gamefishmanager=  require_ex"qj_animal.src.app.gameFish.gamefishmanager"  
	cc.exports.Fish=             require_ex"qj_animal.src.app.gameFish.Fish"  
	cc.exports.FishKing=         require_ex"qj_animal.src.app.gameFish.FishKing"  
	cc.exports.Bird=             require_ex"qj_animal.src.app.gameFish.Bird"  
	cc.exports.BirdKing=         require_ex"qj_animal.src.app.gameFish.BirdKing"  
	cc.exports.CJ_BOSS=          require_ex"qj_animal.src.app.gameFish.CJ_BOSS"  
	cc.exports.offsetPoint =     require_ex"qj_animal.src.app.gameFish.offsetPoint"

	cc.exports.Bullet=       require_ex"qj_animal.src.app.bullet.Bullet" 
	cc.exports.bulletmanager=require_ex"qj_animal.src.app.bullet.bulletmanager" 

	FishFactory:build_scene_fish_trace()
	LoadSound()
    -- cc.Director:getInstance():replaceScene(GameScene.new());
	--cc.Director:getInstance():replaceScene(StarScene.new()) 
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("buyu1_music", 100)
	AudioEngine.setMusicVolume(music_percent/100)
  	local effect_percent = global.g_mainPlayer:getLocalData("buyu1_effect", 100)
  	AudioEngine.setEffectsVolume(effect_percent/100)

	collectgarbage("collect")
end

function exit_qj_animal(guideType)
    require_ex ("main.src.prot.pt_gate")
	require_ex ("main.src.prot.pt_game")
	require_ex ("main.src.handler.gt_login_handler")
	require_ex ("main.src.handler.gt_hall_handler")
	require_ex ("main.src.handler.gatesvr")
	require_ex ("main.src.handler.gs_room_handler")
	require_ex ("main.src.handler.gs_config_handler")
	require_ex ("main.src.handler.gamesvr")
	display.setAutoScale(CC_DESIGN_RESOLUTION)
	UnloadSound()

	local pd = global.g_mainPlayer:getRoomPlayer(global.g_mainPlayer.playerId_)
	gamesvr.sendExitGame(pd.tableId, pd.chairId)

	local serverId = global.g_mainPlayer:getCurrentRoom()
	local md = global.g_mainPlayer:getRoomData(serverId)
	if md.serverType == 4 or GAME_GUIDES.GUIDE_HALL == guideType then
		--比赛房退出
		PopUpView.showPopUpView(WaitForBackToHallView, function()
				global.g_mainPlayer:setCurrentGameId(nil)
				netmng.gsClose()

				replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
			end)
	else
		-- --正常游戏房退出
		-- local selectTable = createObj(ui_selectTable_t)
		-- replaceScene(selectTable:getCCScene(), selectTable, true)
		local gameId = global.g_mainPlayer:getCurrentGameId()
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)
		-- local selectTable = createObj(ui_selectLevel_v_t, gameId)
		-- replaceScene(selectTable:getCCScene(), selectTable, true)
	end

	--声量
	local musicVolume = global.g_mainPlayer:getMusicVolume()
	local effectVolume = global.g_mainPlayer:getEffectVolume()
	AudioEngine.setMusicVolume(musicVolume)
	AudioEngine.setEffectsVolume(effectVolume)
	cc.TextureCache:getInstance():removeUnusedTextures()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
end

function LoadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)

end

function UnloadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
	AudioEngine.playMusic("fullmain/res/music/background.mp3")
end
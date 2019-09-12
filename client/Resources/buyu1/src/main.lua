


function start_buyu1()
	cc.FileUtils:getInstance():setPopupNotify(false)

	-- require_ex ("buyu1.src.config")
	-- require_ex ("buyu1.src.cocos.init")
	require_ex ("buyu1.src.util.common")
	require_ex ("buyu1.src.prot.pt")
	require_ex ("buyu1.src.handler.gs_fish_handler")
	require_ex ("buyu1.src.handler.gamesvr")
	require_ex ("buyu1.src.app.class.SceneFishTrace")
	require_ex ("buyu1.src.app.class.SoundManager")

	cc.exports.Data =require_ex "buyu1.src.app.data.Data"

	cc.exports.StartScene =require_ex "buyu1.src.app.views.StartScene"
	cc.exports.GameScene =require_ex "buyu1.src.app.views.GameScene"
	cc.exports.Action =require_ex "buyu1.src.app.class.Action"
	cc.exports.ActionEx =require_ex "buyu1.src.app.class.ActionEx"
	cc.exports.Tesdis =require_ex "buyu1.src.app.class.Tesdis"
	cc.exports.RanPoint =require_ex "buyu1.src.app.class.RanPoint"
	cc.exports.BoJFish =require_ex "buyu1.src.app.class.BoJFish"

	cc.exports.Calculation =require_ex "buyu1.src.app.class.Calculation"
	cc.exports.Vebull =require_ex "buyu1.src.app.class.Vebull"
	cc.exports.FishMag =require_ex "buyu1.src.app.class.FishMag"


	cc.exports.winCoinItem =require_ex "buyu1.src.app.node.winCoinItem"
	cc.exports.Fish =require_ex "buyu1.src.app.node.Fish"
	cc.exports.dieGroupFish = require_ex "buyu1.src.app.node.dieGroupFish"
	cc.exports.Very =require_ex "buyu1.src.app.node.Very"
	cc.exports.Pao =require_ex "buyu1.src.app.node.Pao"
	cc.exports.Fishnet =require_ex "buyu1.src.app.node.Fishnet"
	cc.exports.Blast =require_ex "buyu1.src.app.node.Blast"
	cc.exports.Coin =require_ex "buyu1.src.app.node.Coin"
	cc.exports.ScoreLab =require_ex "buyu1.src.app.node.ScoreLab"
	cc.exports.Dsyuan =require_ex "buyu1.src.app.node.Dsyuan"
	cc.exports.DSxfish =require_ex "buyu1.src.app.node.DSxfish"
	cc.exports.SuDin =require_ex "buyu1.src.app.node.SuDin"
	cc.exports.SuDin1 =require_ex "buyu1.src.app.node.SuDin1"
	cc.exports.LockLine =require_ex "buyu1.src.app.node.LockLine"
	cc.exports.FishBoom =require_ex "buyu1.src.app.node.FishBoom"
	cc.exports.Bingo =require_ex "buyu1.src.app.node.Bingo"
	cc.exports.SuoFish =require_ex "buyu1.src.app.node.SuoFish"
	cc.exports.Douvery =require_ex "buyu1.src.app.node.Douvery"
	cc.exports.Wave =require_ex "buyu1.src.app.node.Wave"
	cc.exports.RateLab =require_ex "buyu1.src.app.node.RateLab"
	cc.exports.Mask =require_ex "buyu1.src.app.node.Mask"
	cc.exports.Settle = require_ex "buyu1.src.app.node.Settle"
	cc.exports.Under = require_ex "buyu1.src.app.node.Under"
	cc.exports.SoundSetting =require_ex "buyu1.src.app.node.SoundSetting"
	cc.exports.GameSetting =require_ex "buyu1.src.app.node.GameSetting"

	FishFactory:build_scene_fish_trace()
	LoadSound()
	-- cc.Director:getInstance():replaceScene(StarScene.new())
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(StartScene, TRANS_CONST.TRANS_SCALE)

	--声量
	local music_percent = global.g_mainPlayer:getLocalData("buyu1_music", 100)
	AudioEngine.setMusicVolume(music_percent/100)
  	local effect_percent = global.g_mainPlayer:getLocalData("buyu1_effect", 100)
  	AudioEngine.setEffectsVolume(effect_percent/100)

	collectgarbage("collect")
end

function exit_buyu1(guideType)
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
	if md.serverType == 4 or guideType == GAME_GUIDES.GUIDE_HALL then
		--比赛房退出
		PopUpView.showPopUpView(WaitForBackToHallView, function()
				global.g_mainPlayer:setCurrentGameId(nil)
				netmng.gsClose()

				replaceScene(HallScene, TRANS_CONST.TRANS_SCALE)
			end)
	else
		--正常游戏房退出
		-- local selectTable = createObj(ui_selectTable_t)
		-- replaceScene(selectTable:getCCScene(), selectTable, true)
		local gameId = global.g_mainPlayer:getCurrentGameId()
		-- local selectTable = createObj(ui_selectLevel_v_t, gameId)
		-- replaceScene(selectTable:getCCScene(), selectTable, true)
		replaceScene(SelectRoomScene, TRANS_CONST.TRANS_SCALE, gameId)
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
	
	gatesvr.sendInsureInfoQuery(true)
end

function LoadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)

	-- AudioEngine.preloadMusic("buyu1/res/sounds/bgm/bgm1.mp3")
	-- AudioEngine.preloadMusic("buyu1/res/sounds/bgm/bgm2.mp3")
	-- AudioEngine.preloadMusic("buyu1/res/sounds/bgm/bgm3.mp3")
	-- AudioEngine.preloadMusic("buyu1/res/sounds/bgm/bgm4.mp3")

 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/bingo.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/cannonSwitch.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/casting.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/catch.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fire.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish10_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish10_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish11_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish11_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish12_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish12_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish13_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish13_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish14_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish14_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish15_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish15_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish16_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish16_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish17_1.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish17_2.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/fish17_3.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/superarm.mp3")
 --  	AudioEngine.preloadEffect("buyu1/res/sounds/effect/wave.mp3")
end

function UnloadSound( )
	AudioEngine.stopAllEffects()
	AudioEngine.stopMusic(true)
	AudioEngine.playMusic("fullmain/res/music/background.mp3")
	
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/bingo.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/cannonSwitch.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/casting.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/catch.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fire.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish10_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish10_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish11_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish11_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish12_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish12_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish13_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish13_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish14_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish14_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish15_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish15_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish16_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish16_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish17_1.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish17_2.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/fish17_3.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/superarm.mp3")
  	-- AudioEngine.unloadEffect("buyu1/res/sounds/effect/wave.mp3")
end
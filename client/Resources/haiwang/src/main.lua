
--  入口
function start_haiwang()
    cclog("function start_haiwang()");
   -- package.path = package.path .. ";src/"
	cc.FileUtils:getInstance():setPopupNotify(false)
	-- require_ex ("haiwang.src.config")
    --初始化 代自定义全局
	-- require_ex ("haiwang.src.cocos.init")
    -- 自定义事件
	require_ex ("haiwang.src.util.common")
    -- 网络消息定义
	require_ex ("haiwang.src.prot.pt")
    -- 网络事件响应
	require_ex ("haiwang.src.handler.gs_fish_handler")
	require_ex ("haiwang.src.handler.gamesvr")
    -- 路径管理
	--require_ex ("haiwang.src.app.class.SceneFishTrace")
    --声音管理
	--require_ex ("haiwang.src.app.class.SoundManager")
    -- 
    -- 
	---
	cc.exports.Data =require_ex"haiwang.src.app.data.Data"

	--cc.exports.scene_kind_5_trace_s =require_ex"haiwang.src.app.data.scene_kind_5_trace_"

	cc.exports.scene_fish_trace =require_ex"haiwang.src.app.data.scene_fish_trace"
	--cc.exports.StarScene =require_ex"haiwang.src.app.views.StarScene"
	--cc.exports.TestScene =require_ex"haiwang.src.app.views.TestScene"  
	cc.exports.offsetPoint =require_ex"haiwang.src.app.gameFish.offsetPoint"

	--cc.exports.GameScene =require_ex"haiwang.src.app.views.GameScene"  
	cc.exports.Action =require_ex"haiwang.src.app.class.Action"
	--cc.exports.Tesdis =require_ex"haiwang.src.app.class.Tesdis"
	--cc.exports.RanPoint =require_ex"haiwang.src.app.class.RanPoint"
	--cc.exports.BoJFish =require_ex"haiwang.src.app.class.BoJFish"
	     
	--cc.exports.Calculation =require_ex"haiwang.src.app.class.Calculation"     
	--cc.exports.Vebull =require_ex"haiwang.src.app.class.Vebull" 
	--cc.exports.FishMag =require_ex"haiwang.src.app.class.FishMag" 


	--cc.exports.Fish =require_ex"haiwang.src.app.node.Fish"

	--cc.exports.Very =require_ex"haiwang.src.app.node.Very"
	--cc.exports.Pao =require_ex"haiwang.src.app.node.Pao"
	--cc.exports.Fishnet =require_ex"haiwang.src.app.node.Fishnet"
	--cc.exports.Blast =require_ex"haiwang.src.app.node.Blast"
	--cc.exports.Coin =require_ex"haiwang.src.app.node.Coin"
	--cc.exports.ScoreLab =require_ex"haiwang.src.app.node.ScoreLab"
	--cc.exports.Dsyuan =require_ex"haiwang.src.app.node.Dsyuan"
	--cc.exports.DSxfish =require_ex"haiwang.src.app.node.DSxfish"
	--cc.exports.SuDin =require_ex"haiwang.src.app.node.SuDin"
	--cc.exports.LockLine =require_ex"haiwang.src.app.node.LockLine" 
	--cc.exports.FishBoom =require_ex"haiwang.src.app.node.FishBoom" 
	--cc.exports.Bingo =require_ex"haiwang.src.app.node.Bingo"   
	--cc.exports.SuoFish =require_ex"haiwang.src.app.node.SuoFish"  
	--cc.exports.Douvery =require_ex"haiwang.src.app.node.Douvery"   
	--cc.exports.Wave =require_ex"haiwang.src.app.node.Wave"
	--cc.exports.RateLab =require_ex"haiwang.src.app.node.RateLab" 
	cc.exports.Mask =require_ex"haiwang.src.app.node.Mask" 
	--cc.exports.Settle = require_ex"haiwang.src.app.node.Settle" 
	--cc.exports.Under = require_ex"haiwang.src.app.node.Under" 
	--cc.exports.SoundSetting =require_ex"haiwang.src.app.node.SoundSetting"
	cc.exports.game_start_haiwang =require_ex"haiwang.src.app.views.game_start"  
	cc.exports.CGame_player =require_ex"haiwang.src.app.CannonManager.game_player"  
	cc.exports.CGameBack =require_ex"haiwang.src.app.views.CGameBack"  
	--Óã
	cc.exports.Fish=require_ex"haiwang.src.app.gameFish.Fish"  
	cc.exports.FishKing =require_ex"haiwang.src.app.gameFish.FishKing"
	cc.exports.FishKing_Kind =require_ex"haiwang.src.app.gameFish.FishKing_Kind"
	cc.exports.ChainLinkFish =require_ex"haiwang.src.app.gameFish.ChainLinkFish"
	cc.exports.TurnTableFish =require_ex"haiwang.src.app.gameFish.TurnTableFish"
	cc.exports.DcJumpScoreFish =require_ex"haiwang.src.app.gameFish.DcJumpScoreFish"
	cc.exports.DcBroachCannonFish =require_ex"haiwang.src.app.gameFish.DcBroachCannonFish"
	cc.exports.FullScreenDragon =require_ex"haiwang.src.app.gameFish.FullScreenDragon"
	cc.exports.InterlinkBombCrab =require_ex"haiwang.src.app.gameFish.InterlinkBombCrab"
	cc.exports.EYuFish =require_ex"haiwang.src.app.gameFish.EYuFish"
	cc.exports.fishSuperCrab =require_ex"haiwang.src.app.gameFish.fishSuperCrab"
	cc.exports.FishBigDengLong =require_ex"haiwang.src.app.gameFish.FishBigDengLong"
	cc.exports.DianCiFish =require_ex"haiwang.src.app.gameFish.DianCiFish"
	cc.exports.FreeGunFish =require_ex"haiwang.src.app.gameFish.FreeGunFish"
	cc.exports.GuidedMissileFish =require_ex"haiwang.src.app.gameFish.GuidedMissileFish"
	cc.exports.JellyFish =require_ex"haiwang.src.app.gameFish.JellyFish"
	cc.exports.BaoxiangFish =require_ex"haiwang.src.app.gameFish.BaoxiangFish"
	--
	cc.exports.soundManager=require_ex"haiwang.src.app.sound.soundManager"  
	cc.exports.BoundingBox=require_ex"haiwang.src.app.gameFish.BoundingBox"  
	cc.exports.gamefishmanager=require_ex"haiwang.src.app.gameFish.gamefishmanager"  
	cc.exports.lock_fish_manager=require_ex"haiwang.src.app.gameFish.lock_fish_manager"  
	cc.exports.cannonmanager=require_ex"haiwang.src.app.CannonManager.CannonManager" 
	cc.exports.Bingo=require_ex"haiwang.src.app.CannonManager.Bingo" 
	cc.exports.BingoManager=require_ex"haiwang.src.app.CannonManager.BingoManager" 
	cc.exports.Coin=require_ex"haiwang.src.app.CannonManager.Coin" 
	cc.exports.CoinManager=require_ex"haiwang.src.app.CannonManager.CoinManager" 
	cc.exports.My_Particle_manager=require_ex"haiwang.src.app.CannonManager.My_Particle_manager" 
	cc.exports.ScoreAnimation=require_ex"haiwang.src.app.CannonManager.ScoreAnimation" 
	cc.exports.Bullet=require_ex"haiwang.src.app.bullet.Bullet" 


	cc.exports.red_envelope_Manager=require_ex"haiwang.src.app.CannonManager.red_envelope_Manager" 
	cc.exports.red_coin=require_ex"haiwang.src.app.CannonManager.red_coin" 
	cc.exports.red_envelope=require_ex"haiwang.src.app.CannonManager.red_envelope" 


	cc.exports.Dianci_Bullet=require_ex"haiwang.src.app.bullet.Dianci_Bullet" 
	cc.exports.Free_Bullet=require_ex"haiwang.src.app.bullet.Free_Bullet" 
	cc.exports.GuidedMissile=require_ex"haiwang.src.app.bullet.GuidedMissile" 
	cc.exports.Broach_Bullet=require_ex"haiwang.src.app.bullet.Broach_Bullet" 
	cc.exports.Broach_Bullet_Manager=require_ex"haiwang.src.app.bullet.Broach_Bullet_Manager" 
	cc.exports.bulletmanager=require_ex"haiwang.src.app.bullet.bulletmanager" 
	cc.exports.Dianci_Bullet_Manager=require_ex"haiwang.src.app.bullet.Dianci_Bullet_Manager" 
	cc.exports.Free_Bullet_Manager=require_ex"haiwang.src.app.bullet.Free_Bullet_Manager" 
	cc.exports.GuidedMissile_Bullet_Manager=require_ex"haiwang.src.app.bullet.GuidedMissile_Bullet_Manager" 
	cc.exports.GameScene =require_ex"haiwang.src.app.views.GameScene"  

	FishFactory:build_scene_fish_trace();
	LoadSound();
	-- cc.Director:getInstance():replaceScene(GameScene.new()) ;
	local gameId = global.g_mainPlayer:getCurrentGameId()
	local cfg = games_config[gameId]
	display.setAutoScale(cfg.resolution)
	replaceScene(GameScene, TRANS_CONST.TRANS_SCALE)
	--声量
--	local music_percent = global.g_mainPlayer:getLocalData("buyu1_music", 100)
--	AudioEngine.setMusicVolume(music_percent/100)
--  	local effect_percent = global.g_mainPlayer:getLocalData("buyu1_effect", 100)
--  	AudioEngine.setEffectsVolume(effect_percent/100)
    --collectgarbage("count")  用于监听Lua的内存使用情况
    --collectgarbage("collect"),允许在适当的时候进行显式的回收
	collectgarbage("collect")
end

function exit_haiwang(guideType)
    cclog("function exit_haiwang()");
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
	if global.g_mainPlayer:isSilence() then
		AudioEngine.setMusicVolume(0)
		AudioEngine.setEffectsVolume(0)
	else
		AudioEngine.setMusicVolume(musicVolume)
		AudioEngine.setEffectsVolume(effectVolume)
	end
	cc.TextureCache:getInstance():removeUnusedTextures()
	collectgarbage("collect")
	collectgarbage("collect")
	collectgarbage("collect")
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
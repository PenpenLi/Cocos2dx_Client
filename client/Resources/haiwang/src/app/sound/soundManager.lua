--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/28
--此文件由[BabeLua]插件自动生成
 soundManager = class("soundManager",
 function()
	return cc.Node:create()
end
)
function soundManager:ctor()
     cc.exports.g_soundManager=self;
     --cc.exports.My_Sound_Path_Map=
     self.My_Sound_Path_Map=
    {
		--背景音乐-->
		["bgm_normal1"]="haiwang/res/HW/sound/bg/bg_01.mp3",
		["bgm_normal2"]="haiwang/res/HW/sound/bg/bg_02.mp3",
		["bgm_normal3"]="haiwang/res/HW/sound/bg/bg_03.mp3",
		["bgm_normal4"]="haiwang/res/HW/sound/bg/bg_04.mp3",


		["denglongyumusic"]="haiwang/res/HW/sound/denglongyumusic.mp3",
		["AddGunLevelSound"]="haiwang/res/HW/sound/AddGunLevelSound.mp3",
		["SwitchGunSound"]="haiwang/res/HW/sound/SwitchGunSound.mp3",
		["NormalFireSound"]="haiwang/res/HW/sound/NormalFireSound.wav",
		["bulletbaozha"]="haiwang/res/HW/sound/bulletbaozha.wav",
		["MakeCoinSound "]="haiwang/res/HW/sound/MakeCoinSound.mp3",

		["FishDieSound"]="haiwang/res/HW/sound/catchfish/FishDieSound.mp3",
       ["HitBigFish"]="haiwang/res/HW/sound/catchfish/HitBigFish.mp3",
       ["LargeFishSound"]="haiwang/res/HW/sound/catchfish/HitBOSS.mp3",
       ["HitBOSS"]="haiwang/res/HW/sound/catchfish/LargeFishSound.mp3",
       ["HitDragon"]="haiwang/res/HW/sound/catchfish/HitDragon.mp3",
       ["HitEYu"]="haiwang/res/HW/sound/catchfish/HitEYu.mp3",
       ["HitScore "]="haiwang/res/HW/sound/catchfish/HitScore.mp3",
		["effect_fish10_1"]="haiwang/res/HW/sound/effect/fish10_1.mp3",
		["effect_fish10_2"]="haiwang/res/HW/sound/effect/fish10_2.mp3",
		["effect_fish11_1"]="haiwang/res/HW/sound/effect/fish11_1.mp3",
		["effect_fish11_2"]="haiwang/res/HW/sound/effect/fish11_2.mp3",
		["effect_fish12_1"]="haiwang/res/HW/sound/effect/fish12_1.mp3",
		["effect_fish12_2"]="haiwang/res/HW/sound/effect/fish12_2.mp3",
		["effect_fish13_1"]="haiwang/res/HW/sound/effect/fish13_1.mp3",
		["effect_fish13_2"]="haiwang/res/HW/sound/effect/fish13_2.mp3",
		["effect_fish14_1"]="haiwang/res/HW/sound/effect/fish14_1.mp3",
		["effect_fish14_2"]="haiwang/res/HW/sound/effect/fish14_2.mp3",
		["effect_fish15_1"]="haiwang/res/HW/sound/effect/fish15_1.mp3",
		["effect_fish15_2"]="haiwang/res/HW/sound/effect/fish15_2.mp3",
		["effect_fish16_1"]="haiwang/res/HW/sound/effect/fish16_1.mp3",
		["effect_fish16_2"]="haiwang/res/HW/sound/effect/fish16_2.mp3",
		["effect_fish17_1"]="haiwang/res/HW/sound/effect/fish17_1.mp3",
		["effect_fish17_2"]="haiwang/res/HW/sound/effect/fish17_2.mp3",

		["effect_bingo"]="haiwang/res/HW/sound/effect/bingo.mp3",
		["TaskUI"]="haiwang/res/HW/sound/TaskUI.mp3",
		["TaskOver "]="haiwang/res/HW/sound/TaskOver.mp3",
		["CaiJinSound"]="haiwang/res/HW/sound/CaiJinSound.mp3",
		["ScopeBombSound"]="haiwang/res/HW/sound/ScopeBombSound.mp3",
		--跳分 --
		["ScoreStartJump"]="haiwang/res/HW/sound/ScoreStartJump.mp3",
		["ScoreJumpPause"]="haiwang/res/HW/sound/ScoreJumpPause.mp3",
		["ScoreJumping"]="haiwang/res/HW/sound/ScoreJumping.mp3",
		["ScoreJumpEnd"]="haiwang/res/HW/sound/ScoreJumpEnd.mp3",
		--旋风鱼 --
		["SameKindBombSound"]="haiwang/res/HW/sound/SameKindBombSound.mp3",
		["SameKindFishDyingSound"]="haiwang/res/HW/sound/SameKindBombSound.mp3",
		["SameKindKingDone "]="haiwang/res/HW/sound/SameKindBombSound.mp3",
		["SameKindKingEnd"]="haiwang/res/HW/sound/SameKindBombSound.mp3",
		  --闪电链 --
		["ChainLinkStart"]="haiwang/res/HW/sound/ChainLinkStart.mp3",
		["ChainEnd"]="haiwang/res/HW/sound/ChainEnd.mp3",
		["NextChain"]="haiwang/res/HW/sound/NextChain.mp3",
		--电磁炮--
		["DianCiPaoAppear "]="haiwang/res/HW/sound/DianCiPaoAppear.mp3",
		["DianCiPaoFire"]="haiwang/res/HW/sound/DianCiPaoFire.mp3",
		["DianCiPaoHit"]="haiwang/res/HW/sound/DianCiPaoHit.mp3",
		--免费子弹--
		["FreeFireEnd"]="haiwang/res/HW/sound/FreeFireEnd.mp3",
		["FreeFireShoot"]="haiwang/res/HW/sound/FreeFireShoot.mp3",
		--转盘--
		["HitTurn"]="haiwang/res/HW/sound/HitTurn.mp3",
		["Turning"]="haiwang/res/HW/sound/Turning.mp3",
		--钻头炮 必杀弹--
		["SuperGunFireSound"]="haiwang/res/HW/sound/SuperGunFireSound.mp3",
		["SuperGunShowSound"]="haiwang/res/HW/sound/SuperGunShowSound.mp3",
		--场景切换--
		["LogoSound1"]="haiwang/res/HW/sound/LogoSound1.mp3",
		["LogoSound2"]="haiwang/res/HW/sound/LogoSound2.mp3",
};
self.bg_music_=0;
end
 function soundManager:LoadGameResource()
   	--self.My_Sound_Path_Map["bgm_normal1"]="";
	--CocosDenshion::SimpleAudioEngine::sharedEngine()->preloadBackgroundMusic(My_Sound_Path_Map["bgm_normal1"].c_str());//缓存音效
     cc.SimpleAudioEngine:getInstance():preloadMusic(self.My_Sound_Path_Map["bgm_normal1"]);
     cc.SimpleAudioEngine:getInstance():preloadMusic(self.My_Sound_Path_Map["bgm_normal2"]);
     cc.SimpleAudioEngine:getInstance():preloadMusic(self.My_Sound_Path_Map["bgm_normal3"]);
     cc.SimpleAudioEngine:getInstance():preloadMusic(self.My_Sound_Path_Map["bgm_normal4"]);
     local i=0;
     for i=5, #(self.My_Sound_Path_Map) do
          cc.SimpleAudioEngine:getInstance():preloadEffect(self.My_Sound_Path_Map[i]);
    end
 end
function soundManager:PlayBackMusic()

       self:StopBackMusic();
   	    self.bg_music_ =(self.bg_music_+1)% 4;
    	tem_char=string.format( "bgm_normal%d", self.bg_music_ + 1);
       -- cclog("soundManager:PlayBackMusic()...tem_char=%s.......",tem_char);
        cc.SimpleAudioEngine:getInstance():playMusic(self.My_Sound_Path_Map[tem_char],true);

 end
function soundManager:StopBackMusic()

--    cclog("soundManager:StopBackMusic()");
    cc.SimpleAudioEngine:getInstance():stopMusic();
    --]]
 end
function soundManager:PlayGameEffect(effectName)

 --   cclog("soundManager:PlayGameEffect() %s",effectName);
    if(self.My_Sound_Path_Map[effectName]) then
      --cclog("soundManager:PlayGameEffect() %s....",effectName);
      cc.SimpleAudioEngine:getInstance():playEffect(self.My_Sound_Path_Map[effectName]);
    end
    --]]
 end
function soundManager:PlayFishEffect(fish_kind)
--
  --   cclog("soundManager:PlayFishEffect() %d",fish_kind);
     if (fish_kind >= 9  and fish_kind <= 16) then
         local  get_index=1;
         if( math.random()%2<1) then get_index=2; end
         local file_name=string.format("effect_fish%d_%d", fish_kind + 1, get_index);
          if(self.My_Sound_Path_Map[file_name]) then
             cc.SimpleAudioEngine:getInstance():playEffect(self.My_Sound_Path_Map[file_name]);
         end
     end -- if (fish_kind >= 9  and fish_kind <= 16) then
     --]]
 end


 return soundManager;
--endregion

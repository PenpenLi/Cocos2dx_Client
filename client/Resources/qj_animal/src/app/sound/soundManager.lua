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
     self.bg_music_=1;
     --cc.exports.My_Sound_Path_Map=
     self.My_Sound_Path_Map=
    {
		--背景音乐-->
        ["bgm_normal1"]="qj_animal/res/game_res/sounds/bgm/bgm1.mp3" ,
		["bgm_normal2"]="qj_animal/res/game_res/sounds/bgm/bgm2.mp3" ,
		["bgm_normal3"]="qj_animal/res/game_res/sounds/bgm/bgm3.mp3" ,
		["bgm_normal4"]="qj_animal/res/game_res/sounds/bgm/bgm4.mp3" ,	
		["effect_cannon_switch"]="qj_animal/res/game_res/sounds/effect/cannonSwitch.mp3" ,
		["effect_casting"]="qj_animal/res/game_res/sounds/effect/casting.mp3" ,
		["effect_catch"]="qj_animal/res/game_res/sounds/effect/catch.mp3" ,
		["effect_fire"]="qj_animal/res/game_res/sounds/effect/fire.mp3" ,	
        ["effect_Animal0"]="qj_animal/res/game_res/Animal/name_ef/0.mp3" ,
        ["effect_Animal1"]="qj_animal/res/game_res/Animal/name_ef/1.mp3" ,
        ["effect_Animal2"]="qj_animal/res/game_res/Animal/name_ef/2.mp3" ,
        ["effect_Animal3"]="qj_animal/res/game_res/Animal/name_ef/3.mp3" ,
        ["effect_Animal4"]="qj_animal/res/game_res/Animal/name_ef/4.mp3" ,
        ["effect_Animal5"]="qj_animal/res/game_res/Animal/name_ef/5.mp3" ,
        ["effect_Animal6"]="qj_animal/res/game_res/Animal/name_ef/6.mp3" ,
        ["effect_Animal7"]="qj_animal/res/game_res/Animal/name_ef/7.mp3" ,
        ["effect_Animal8"]="qj_animal/res/game_res/Animal/name_ef/8.mp3" ,
        ["effect_Animal9"]="qj_animal/res/game_res/Animal/name_ef/9.mp3" ,
        ["effect_Animal10"]="qj_animal/res/game_res/Animal/name_ef/10.mp3" ,
        ["effect_Animal11"]="qj_animal/res/game_res/Animal/name_ef/11.mp3" ,
        ["effect_Animal12"]="qj_animal/res/game_res/Animal/name_ef/12.mp3" ,
        ["effect_Animal13"]="qj_animal/res/game_res/Animal/name_ef/13.mp3" ,                
        ["effect_Animal14"]="qj_animal/res/game_res/Animal/name_ef/14.mp3" ,
        ["effect_Animal15"]="qj_animal/res/game_res/Animal/name_ef/15.mp3" ,    
		["effect_superarm"]="qj_animal/res/game_res/sounds/effect/superarm.mp3" ,
		["effect_bingo"]="qj_animal/res/game_res/sounds/effect/music_win_01.mp3" ,
		["effect_wave"]="qj_animal/res/game_res/sounds/effect/scene_change.mp3" 
        };
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
       --cclog("soundManager:PlayBackMusic()..........");
        self:StopBackMusic();
        if(self.bg_music_==nil) then  self.bg_music_=0; end
   	    self.bg_music_=(self.bg_music_+1)% 4+1;
    	tem_char=string.format( "bgm_normal%d", self.bg_music_ + 1);
        cc.SimpleAudioEngine:getInstance():playMusic(self.My_Sound_Path_Map[tem_char],true);  
 end
function soundManager:StopBackMusic()
    -- cclog("soundManager:StopBackMusic()");
    cc.SimpleAudioEngine:getInstance():stopMusic();
 end
function soundManager:PlayGameEffect(effectName)
    --cclog("soundManager:PlayGameEffect(effectName=%s)",effectName);
    if(self.My_Sound_Path_Map[effectName]) then 
     -- cclog("soundManager:PlayGameEffect(effectName=%s) aa",effectName);
      local sound_path=self.My_Sound_Path_Map[effectName];
     -- cclog("soundManager:PlayGameEffect(effectName=%s) sound_path=%s",effectName,sound_path);
      cc.SimpleAudioEngine:getInstance():playEffect(sound_path);
    end
 end
function soundManager:PlayFishEffect(fish_kind)
     if (fish_kind<15) then
         local  get_index=1;
         local file_name=string.format("effect_Animal%d", fish_kind);
          if(self.My_Sound_Path_Map[file_name]) then 
             cc.SimpleAudioEngine:getInstance():playEffect(self.My_Sound_Path_Map[file_name]);
         end
     end -- if (fish_kind >= 9  and fish_kind <= 16) then
 end
 function soundManager:PlayAnimalEffect(fish_kind)
     if (fish_kind<30) then
         local  get_index=1;
         local file_name=string.format("effect_Animal%d", fish_kind);
          if(self.My_Sound_Path_Map[file_name]) then 
             cc.SimpleAudioEngine:getInstance():playEffect(self.My_Sound_Path_Map[file_name]);
         end
     end -- if (fish_kind >= 9  and fish_kind <= 16) then
 end

 return soundManager;
--endregion

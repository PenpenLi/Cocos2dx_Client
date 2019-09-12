--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/20
--此文件由[BabeLua]插件自动生成
local game_start = class("game_start", function() return cc.Layer:create() end )
function game_start:ctor()
   --exit_haiwang();
  --self.g_scene_fish_trace=scene_fish_trace.new();
  --self:addChild(self.g_scene_fish_trace);
    local gameKey =166;
    if(global.g_mainPlayer) then  
       if(global.g_mainPlayer.getCurrentGameKey) then 
           gameKey=global.g_mainPlayer:getCurrentGameKey()
        end
      if(gameKey==nil) then gameKey=166 end
    end
   local cfg = games_config[gameKey] 
   if(global.g_mainPlayer.getCurrentGameNum) then 
     local gameNum = global.g_mainPlayer:getCurrentGameNum()
     cc.exports._local_player_num_I=gameNum; 
  end
  if( cc.exports._local_player_num_I==6) then cc.exports._local_info_array_= cc.exports._local_info_array_6;
  elseif( cc.exports._local_player_num_I==8) then cc.exports._local_info_array_= cc.exports._local_info_array_8; end
  self:Init();
  local winSize =  cc.Director:getInstance():getWinSize() ;
  local  t_scaleX=winSize.width/1280;
  local t_scaleY=winSize.height/720;
  -- 背景
  self.bg=cc.Sprite:create("haiwang/res/HW/load/StartLogo.png");
  self.bg:setScaleX(t_scaleX);
  self.bg:setScaleY(t_scaleY);
  self.bg:setPosition(winSize.width/2,winSize.height/2);
  self.bg:setAnchorPoint(cc.p(0.5,0.5));
  self:addChild(self.bg,-1);

  local version = cc.LabelTTF:create("version:2", "arial", 24)
  version:setAnchorPoint(cc.p(1, 0.5))
  version:setPosition(1250, 15)
  version:setFontFillColor(cc.c3b(255, 0, 0))
  self:addChild(version, 1)
  
 -- 右下转动
  self.right_rot=cc.Sprite:create("haiwang/res/HW/load/~LoadingText_000_000.png");
  self.right_rot:setScaleX(t_scaleX*0.5);
  self.right_rot:setScaleY(t_scaleY*0.5);
  self.right_rot:setPosition(winSize.width-100, 90);
  self.right_rot:setAnchorPoint(cc.p(0.5,0.5));
  self:addChild(self.right_rot,1);
   local animate = cc.RotateBy:create(2, 360);
  self.right_rot:runAction(cc.RepeatForever:create(animate));
  --添加载入进度
  self.pross_text=cc.LabelAtlas:_create("0:","haiwang/res/HW/load/LoadNum.png", 28, 36, string.byte("0"));
  self.pross_text:setPosition(winSize.width-100, 90);
  self.pross_text:setAnchorPoint(cc.p(0.5,0.5));
  self:addChild(self.pross_text,10,99);
  --
   cc.exports.g_soundManager:LoadGameResource();
  local function waitforload() self:resources();end;
  local delay_=cc.DelayTime:create(0.8);
  local delay_call=cc.CallFunc:create(waitforload);
  local seq_call=cc.Sequence:create(delay_,delay_call,nil);
  self:runAction(seq_call);
  --]]
end

function game_start:Init()
    self.count=0;
    self.load_total=37
end;

function game_start:resources()   --需要加载资源都放到这个函数里了
   local function transition()
    --信息量太大
    -- cc.exports.scene_kind_1_trace_s =
    require_ex"haiwang.src.app.data.scene_kind_1_trace_"
    --cc.exports.scene_kind_2_trace_sEx =
    require_ex"haiwang.src.app.data.scene_kind_2_trace_ex"
    --cc.exports.scene_kind_2_trace_s0 =
    require_ex"haiwang.src.app.data.scene_kind_2_trace0"
    --cc.exports.scene_kind_2_trace_s1 =
    require_ex"haiwang.src.app.data.scene_kind_2_trace1"
    --cc.exports.scene_kind_3_trace_s =
    require_ex"haiwang.src.app.data.scene_kind_3_trace_"
    --cc.exports.scene_kind_4_trace_s =
    require_ex"haiwang.src.app.data.scene_kind_4_trace_"
    --cc.exports.scene_kind_5_trace0 =
    require_ex"haiwang.src.app.data.scene_kind_5_trace0"
    --cc.exports.scene_kind_5_trace1 =
    require_ex"haiwang.src.app.data.scene_kind_5_trace1"
    --cc.exports.scene_kind_5_trace2 =
    require_ex"haiwang.src.app.data.scene_kind_5_trace2"
    require_ex"haiwang.src.app.data.scene_kind_5_trace11"
    cc.exports.game_manager_:StartGame();
	self:removeFromParent();
  end;
  local  function loadingFinished()
       self.count=self.count+1;
	   if(self.load_total < 1) then self.load_total = 1; end
	   local percentage =math.floor(self.count * 100 /  self.load_total);
      cclog("game_start::loadingFinished count=%d,percentage=%d", self.count, percentage);
     -- cc.exports.debug_text:setString("game_start:resources loadingFinished.....");
       if (self.pross_text~=nil) then self.pross_text:setString(percentage..":");end

     if (self.count >=self.load_total)
	 then
		local t_ccdelay=cc.DelayTime:create(0.5);
		local t_callfunc=cc.CallFunc:create(transition);
		local t_seq = cc.Sequence:create(t_ccdelay, t_callfunc, nil);
		self:runAction(t_seq);
	end
    --]]
  end;
    local textureCache=cc.Director:getInstance():getTextureCache();
     cc.Texture2D:setDefaultAlphaPixelFormat(cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A4444)
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishA0.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishA1.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishA2.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishA3.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishA4.png",loadingFinished);

     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB0.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB1.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB2.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB3.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB4.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishB5.png",loadingFinished);

     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC0.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC1.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC2.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC3.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC4.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC5.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC6.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FishC7.png",loadingFinished);

     textureCache:addImageAsync("haiwang/res/HW/fishsub/OtherEffect0.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fishsub/FullDragon.png",loadingFinished);


     textureCache:addImageAsync("haiwang/res/HW/king/king_ui.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/ChainShell/ChainFishIdDigital.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/ChainShell/ChainShellPope.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/turntable/table_catch.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/MryJumpScore/junmScore_winbg.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/BroachCannonCrab/BroachCannonCrab.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/BroachCannonCrab/BroachCannon.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/eyuScrew.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/DianCiFish.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/FreeGunFish.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/FreeBullet/FreeGunEffect.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/fist_gun_Effect.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/BombCrabExplose.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/wav_.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/lock_line.png",loadingFinished);
     textureCache:addImageAsync("haiwang/res/HW/bulletEx.png",loadingFinished);

end;
return game_start;
--endregion

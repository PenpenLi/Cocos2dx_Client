--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/4
--此文件由[BabeLua]插件自动生成
local game_start = class("game_start", function() return cc.Layer:create() end )
function game_start:ctor()
  self:Init();
  local winSize =  cc.Director:getInstance():getWinSize() ;
  local  t_scaleX=winSize.width/1280;
  local t_scaleY=winSize.height/720;
  self.m_Size=winSize;
  -- 背景1
  self.bg=cc.Sprite:create("qj_animal/res/game_res/LogoBG.png");
  self.bg:setScaleX(t_scaleX);
  self.bg:setScaleY(t_scaleY);
  self.bg:setPosition(winSize.width/2,winSize.height/2);  
  self.bg:setAnchorPoint(cc.p(0.5,0.5));                                
  self:addChild(self.bg,-1);

  local version = cc.LabelTTF:create("version:3", "arial", 24)
  version:setAnchorPoint(cc.p(1, 0.5))
  version:setPosition(1250, 50)
  version:setFontFillColor(cc.c3b(255,0,0), true)
  self:addChild(version, 1)

  --进度条背景
  self.jindu_bg=cc.Sprite:create("qj_animal/res/game_res/jindu.png");
  local t_CCRect = self.jindu_bg:getTextureRect();
  local tem_scale_x = winSize.width /t_CCRect.width; 
  self.jindu_bg:setColor(cc.c3b(128, 0, 0));
  self.jindu_bg:setScaleX(tem_scale_x);
  self.jindu_bg:setAnchorPoint(cc.p(0, 0.5));
  self.jindu_bg:setPosition(cc.p(0, 88));                       
  self:addChild(self.jindu_bg,0);
  --进度前景
  self.jindu_Front=cc.Sprite:create("qj_animal/res/game_res/jindu.png");
  self:addChild(self.jindu_Front,1,99);
  self.m_Size=self.jindu_Front:getTextureRect();
  local tem_scale_x = winSize.width /self.m_Size.width; 
  self.jindu_Front:setTextureRect(cc.rect(0, 0, 0, self.m_Size.height-100));
  self.jindu_Front:setScaleX(tem_scale_x);
  self.jindu_Front:setAnchorPoint(cc.p(0, 0.5));
  self.jindu_Front:setPosition(cc.p(0, 88));          
               
  -- cc.exports.g_soundManager:LoadGameResource();
  local function waitforload() self:resources();end;
  local delay_=cc.DelayTime:create(0.8);
  local delay_call=cc.CallFunc:create(waitforload);
  local seq_call=cc.Sequence:create(delay_,delay_call,nil);
  self:runAction(seq_call);
end
function game_start:resources()   --需要加载资源都放到这个函数里了 
  local function transition()
    cclog("game_start:resources transition...............");
    cc.exports.game_manager_:StartGame();
	self:removeFromParent();
  end;
  local  function loadingFinished()
      self.count=self.count+1;
	  if(self.load_total < 1) then self.load_total = 1; end
	  local percentage =math.floor(self.count * 100 /  self.load_total);
      cclog("game_start::loadingFinished count=%d,percentage=%d", self.count, percentage);  
      self.jindu_Front:setTextureRect(cc.rect(0, 0, self.m_Size.width*percentage/100, self.m_Size.height));   
      if (self.count >=self.load_total) then
         cclog("game_start:resources self.count >=self.load_total......");
		 local t_ccdelay=cc.DelayTime:create(0.5);
		 local t_callfunc=cc.CallFunc:create(transition);
		 local t_seq = cc.Sequence:create(t_ccdelay, t_callfunc, nil);
		 self:runAction(t_seq);
	  end
    end
    local textureCache=cc.Director:getInstance():getTextureCache();
    textureCache:addImageAsync("qj_animal/res/game_res/score_num.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/or1.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/yunxuan.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/haoxian.png",loadingFinished);

    textureCache:addImageAsync("qj_animal/res/game_res/bullet_ex11.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/fireEffect.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/lock_line.png",loadingFinished);

    textureCache:addImageAsync("qj_animal/res/game_res/Animal/vbd_.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/animal1.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/animal2.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/animal3.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/animal4.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/Animal/CJ_BOSS.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/cannon/FreeBullet/FreeGunEffect.png",loadingFinished);


    textureCache:addImageAsync("qj_animal/res/game_res/new/king_bobo.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/new_bullet.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/new_king_effect.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/new_link_effect.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/new_net.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/new_coin.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/sceneEffect0.png",loadingFinished);
    textureCache:addImageAsync("qj_animal/res/game_res/new/scene_effect_0.png",loadingFinished);
    --textureCache:addImageAsync("qj_animal/res/game_res/cannon/FreeBullet/vbd_.png",loadingFinished);
end;
function game_start:Init()
    self.count=0;
    self.load_total=22;
--     local targetPlatform = cc.Application:getInstance():getTargetPlatform();
--      if(cc.PLATFORM_OS_WINDOWS == targetPlatform
--      or cc.PLATFORM_OS_ANDROID == targetPlatform)   then 
--        self.load_total=51;
--        else  self.load_total=49;
--     end
end;
return game_start;
--endregion

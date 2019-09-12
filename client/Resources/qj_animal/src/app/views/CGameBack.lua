--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/4
--此文件由[BabeLua]插件自动生成
local CGameBack = class("CGameBack", function()
    return cc.Node:create()
end)

function CGameBack:ctor(cmain_scene)
  self.m_pccNode=nil;
  self.m_pccNode=cmain_scene;--//背景节点
      
  if(self.m_pccNode~=nil) then 
   --cclog(" CGameBack:ctor() self.m_pccNode~=nil 0000000000");
   self.m_pccNode:setPosition(cc.p(0,0));
  end
   --cc.exports.g_soundManager:PlayBackMusic();
  self.spr_bg_Back_=nil;--////背景 
  self.spr_bg_Front=nil;--////前景
  --self.spr_bg_FrontEx=nil;--////前景
  self.Switch_Effect_Node=nil;--  //场景切换特效节点
  self.scene_style_=0;--
  self.scene_switching_=0;--
  self.m_sceneswitch_flag=0;--
  self.m_screen_jitter_timer=0;
  self.m_screen_jitter_flag=0;
  self:CreateSceneSpr(math.random(0,2));
  local function handler(interval)
           self:update(interval);
  end
  self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);   
  --self:Screen_jitter();
end


function CGameBack:update(dt)
    if(self.m_screen_jitter_flag>0) then 
        if(self.m_screen_jitter_timer>0) then 
            self.m_screen_jitter_timer=self.m_screen_jitter_timer-dt;
            local t_winsize=cc.Director:getInstance():getWinSize();
            local x= math.random(0,12);
            local y= math.random(0,7);
            if(self.m_screen_jitter_timer<0) then 
               self.m_screen_jitter_flag=0;
               x=0;
               y=0;
            end
            x=x+t_winsize.width/2;
            y=y+t_winsize.height/2;
            local t_pos=cc.p(x,y);
            if (self.spr_bg_Back_)  then self.spr_bg_Back_:setPosition(t_pos); end
			if (self.spr_bg_Front)  then self.spr_bg_Front:setPosition(t_pos); end
			--if (self.spr_bg_FrontEx)then self.spr_bg_FrontEx:setPosition(t_pos);end
        end
    end
end
function CGameBack:_AddSceneEffect()  
  --cclog("CGameBack:_AddSceneEffect()  00self.scene_switching_ =%d",self.scene_switching_ );
  if(self.scene_switching_ ==0) then 
     if(self.spr_bg_Back_) then
            local _spr=nil;
            local file_name ="";
		    local readIndex = 0;
		    local animFrames = cc.Animation:create();
            local i=0;
	        for  i = 0,40, 1 do
                file_name=string.format( "scene0_effect_%02d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if(frame) then		
                    if(readIndex == 0)then 	_spr=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
                end
            end --for i
            if(readIndex > 0) then 		
                 animFrames:setDelayPerUnit(1/12);
				local animation = cc.Animate:create(animFrames);
				local t_CCRepeat =cc.RepeatForever:create(animation);
                _spr:setAnchorPoint(cc.p(0.5,1));               
                 _spr:setPosition(cc.p(640,720));
                _spr:runAction(t_CCRepeat);
                self.spr_bg_Back_:addChild(_spr,50); 
          end	--	if (readIndex > 0) then		
   end
  elseif(self.scene_switching_ ==1) then 
   if(self.spr_bg_Back_) then
    local k=0;
    for k=0,2,1 do
           -- cclog("CGameBack:_AddSceneEffect()  11 k=%d",k);
            local _spr=nil;
            local file_name ="";
		    local readIndex = 0;
		    local animFrames = cc.Animation:create();
            local i=0;
	        for  i = 0,40, 1 do
                file_name=string.format("z00%02d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if(frame) then		
                    if(readIndex == 0)then 	_spr=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
                end
            end --for i
            if(readIndex > 0) then 		
                 animFrames:setDelayPerUnit(1/20);
				local animation = cc.Animate:create(animFrames);
				local t_CCRepeat =cc.RepeatForever:create(animation);
                _spr:setAnchorPoint(cc.p(0.5,0));
                if(k==1) then     _spr:setPosition(cc.p(1194,640));
                else              _spr:setPosition(cc.p(90,640));
                end 
                _spr:runAction(t_CCRepeat);
                self.spr_bg_Back_:addChild(_spr,50); 
          end	--	if (readIndex > 0) then		
    end

   end
  elseif(self.scene_switching_ ==2) then 
   if(self.spr_bg_Back_) then
    local emitter1 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Animal/scene/secene_2_effect.plist")  
    emitter1:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    emitter1:setPosition(cc.p(100,120))  
    self.spr_bg_Back_:addChild(emitter1,102) 

    local emitter2 = cc.ParticleSystemQuad:create("qj_animal/res/game_res/Animal/scene/secene_2_effect.plist")  
    emitter2:setAutoRemoveOnFinish(true)    --设置播放完毕之后自动释放内存  
    emitter2:setPosition(cc.p(1200, 120)) 
    self.spr_bg_Back_:addChild(emitter2,102) 
   end
  end
end  
function CGameBack:CreateSceneSpr_S(c_scene_style_)   
         --c_scene_style_=0;
         self.scene_style_ = c_scene_style_;
         self.scene_switching_ =c_scene_style_%3;
         cclog("CGameBack:CreateSceneSpr_S  aaa");
         if(self.m_pccNode~=nil) then 
            --场景切换特效
           if (self.Switch_Effect_Node~=nil) then 		
		       self.m_pccNode:removeChild(self.Switch_Effect_Node);
               self.Switch_Effect_Node=nil;
		   end
           self.Switch_Effect_Node = cc.Node:create();
		   self.Switch_Effect_Node:setPosition(cc.p(0, 0));
           local tem_pathstr="qj_animal/res/game_res/Animal/scene/Switch_LogoBG.png";
           local t_ccspr_bg = cc.Sprite:create(tem_pathstr);
           if(t_ccspr_bg) then 
              self.Switch_Effect_Node:addChild(t_ccspr_bg, 1, 100);
              self.m_pccNode:addChild(self.Switch_Effect_Node, 1000);--//覆盖
              local function callbackC()--更换背景 生成矩阵                      
                     self.m_sceneswitch_flag = 0;
                     self:CreateSceneSpr(self.scene_switching_);--//创建背景
                     cc.exports.g_soundManager:PlayBackMusic();
                     cc.exports.game_manager_:EndSceneTra();--//场景切换完成;

              end
              local function callbackC2()--移除
                    if (self.Switch_Effect_Node) then 	
		                self.Switch_Effect_Node:removeFromParent();
	                    self.Switch_Effect_Node = nil;
                         self.m_sceneswitch_flag = 0;
                    end
              end
              t_ccspr_bg:setAnchorPoint(cc.p(0, 0));
			  t_ccspr_bg:setPosition(cc.p(0, 0));
		      t_ccspr_bg:setOpacity(0);
              --出现动作
			  local fadein = cc.FadeIn:create(1);      --//出现
			  local funcall = cc.CallFunc:create(callbackC);--//更换背景 生成矩阵
			  local delaytime = cc.DelayTime:create(0.5);                                                   -- //延迟
			  local fadeout = cc.FadeOut:create(0.5);                                                           --//渐变隐藏
			  local funcall2 = cc.CallFunc:create(callbackC2);--//移除
			  local seq = cc.Sequence:create(fadein, funcall, delaytime, fadeout, funcall2, nil);
			  t_ccspr_bg:runAction(seq);                
          end
      end   --
end
function CGameBack:CreateSceneSpr(c_scene_style_)
     --cclog("CGameBack:CreateSceneSpr(c_scene_style=%d,effect_=%d)",c_scene_style_,effect_);
   -- self.m_pccNode=self:getParent();
    local t_winsize=cc.Director:getInstance():getWinSize();
    local t_win_center=cc.p(t_winsize.width/2,t_winsize.height/2);

    self.scene_style_ = c_scene_style_;
    self.scene_switching_ =c_scene_style_%3;
    if(self.m_pccNode~=nil) then         		
         if (c_scene_style_ < 3)then 
                if (self.spr_bg_Back_)  then self.m_pccNode:removeChild(self.spr_bg_Back_); end
				if (self.spr_bg_Front)  then self.m_pccNode:removeChild(self.spr_bg_Front); end
                self.spr_bg_Front=nil;
                self.spr_bg_Back_=nil;
				--if (self.spr_bg_FrontEx)then self.m_pccNode:removeChild(self.spr_bg_FrontEx); end
                --//背景
                local tem_pathstr= "qj_animal/res/game_res/Animal/scene/"..(c_scene_style_ + 1)..".png";
                self.spr_bg_Back_ =cc.Sprite:create(tem_pathstr);
                if(self.spr_bg_Back_) then
                    self.spr_bg_Back_:setScale(1.02);
					self.spr_bg_Back_:setPosition(t_win_center);
					self.m_pccNode:addChild(self.spr_bg_Back_,-1);
                end
                --前景
                if(c_scene_style_==0 or c_scene_style_==2) then 
                   local tem_pathstr_F= "qj_animal/res/game_res/Animal/scene/"..(c_scene_style_ + 1).."F.png";
                   self.spr_bg_Front =cc.Sprite:create(tem_pathstr_F);
                   if(self.spr_bg_Front) then
                        self.spr_bg_Front:setScale(1.02);
					    self.spr_bg_Front:setPosition(t_win_center);
				    	self.m_pccNode:addChild(self.spr_bg_Front,10);
                     end
                end
                --[[
                local tem_pathstr_Ex= "qj_animal/res/game_res/Animal/scene/"..(c_scene_style_ + 1).."Ex.png";
                self.spr_bg_FrontEx =cc.Sprite:create(tem_pathstr_Ex);
                if(self.spr_bg_FrontEx) then
                    self.spr_bg_FrontEx:setScale(1.02);
					self.spr_bg_FrontEx:setPosition(t_win_center);
					self.m_pccNode:addChild(self.spr_bg_FrontEx,17);
                end
                --]]
                 self:_AddSceneEffect();  
         end  --  if (c_scene_style_ < 3) 
   end --if(self.m_pccNode~=nil)
end
function CGameBack:SetSwitchSceneStyle(c_scene_style)
          cc.exports.g_soundManager:StopBackMusic();
	      cc.exports.g_soundManager:PlayGameEffect("effect_wave");
          cclog("CGameBack:SetSwitchSceneStyle(c_scene_style=%d)---------------------",c_scene_style);
          self.scene_switching_ =c_scene_style%3;
          self:CreateSceneSpr_S(self.scene_switching_);--//创建切换动画
          self.m_sceneswitch_flag = 1;
end
function CGameBack:SetSceneStyle(scene_style)
   self.scene_style_ = scene_style; 
 end

function CGameBack:get_switch_sceneType()
   return self.scene_switching_; 
 end

 --震动屏幕
 function CGameBack:Screen_jitter()
    self.m_screen_jitter_timer=0.6;
    self.m_screen_jitter_flag=1;
 end
return CGameBack;
--endregion

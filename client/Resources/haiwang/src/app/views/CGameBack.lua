--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/7
--此文件由[BabeLua]插件自动生成
local CGameBack = class("CGameBack", function()
    return cc.Node:create()
end)

function CGameBack:ctor()
    self.scene_switching_=2;--math.random(3);
    self.spr_bg_Back_SwitchFlag=0;
    self.fist_init_flag=0;
    self.spr_bg_Back_=nil;
    self.Main_Node = cc.Node:create();
	self.Main_Node:setScale(1.025);
     local nodegird = cc.NodeGrid:create()
     nodegird:addChild(self.Main_Node)   
     self:addChild(nodegird)
    self._nodegird = nodegird
    self.m_screen_shake_flag = 0;
	self.m_screen_shake_timer =0;
	--self:addChild(self.Main_Node,- 1);
    self:CreateSceneSpr(self.scene_switching_);
     cc.exports.g_soundManager:PlayBackMusic();
     local function handler(interval)
            self:update(interval);
       end
     self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);

end 
function CGameBack:CreateSceneSpr( cc_scene_style)

 local scene_style=cc_scene_style%3;
 cclog(" CGameBack:CreateSceneSpr( c_scene_style_=%d scene_style=%d).........................................",cc_scene_style,scene_style);
if(scene_style<3) then 
     local  winSize = cc.Director:getInstance():getWinSize();
     if (self.spr_bg_Back_~=nil) then self.Main_Node:removeChild(spr_bg_Back_); end
 	if(scene_style<1)then      self.spr_bg_Back_=cc.Sprite:create("haiwang/res/HW/Scene/~SceneA_000_000.png");
    elseif(scene_style<2)then 
         self.spr_bg_Back_=cc.Sprite:create("haiwang/res/HW/Scene/~SceneB_000_000.png");
         --添加左右可移动石头
         local t_left_node=cc.Node:create();
         local t_right_node=cc.Node:create();
         self.spr_bg_Back_:addChild(t_left_node, 1, 100);
         self.spr_bg_Back_:addChild(t_right_node, 1, 200);
         local  t_left_lSpr = cc.Sprite:create("haiwang/res/HW/Scene/~SceneB_LeftRockNode_000_000.png");
         local  t_right_lSpr = cc.Sprite:create("haiwang/res/HW/Scene/~SceneB_RightRockNode_000_000.png");
         if(t_left_lSpr~=nil)then
             t_left_lSpr:setAnchorPoint(cc.p(0.0,0.5));
             t_left_lSpr:setPosition(cc.p(0.0,360));     
             t_left_node:addChild(t_left_lSpr,1,100);
          end
          if(t_right_lSpr~=nil)then
             t_right_lSpr:setAnchorPoint(cc.p(1.0,0.5));
             t_right_lSpr:setPosition(cc.p(1280.0,360));
             t_right_node:addChild(t_right_lSpr,1,200);
         end   
    else                        
         self.spr_bg_Back_=cc.Sprite:create("haiwang/res/HW/Scene/~SceneC_000_000.png");
       --添加符石
        local  t_left_lSpr = cc.Sprite:create("haiwang/res/HW/Scene/~SceneC_ObjNode_000_000.png");
        t_left_lSpr:setPosition(cc.p(640.0,360)); 
       -- t_left_lSpr:setScale(0.95);    
        self.spr_bg_Back_:addChild(t_left_lSpr,10);
        -- 执行浮动动作
        local delaytime1 = cc.DelayTime:create(0.2);
        local delaytime2 = cc.DelayTime:create(0.2);
        local scaleto1 = cc.ScaleTo:create(3,1.04);
        local scaleto2 = cc.ScaleTo:create(3, 0.96);
        local seq=cc.Sequence:create(delaytime1, scaleto1, delaytime2, scaleto2,nil);
        local  rep_=cc.RepeatForever:create(seq);
        t_left_lSpr:runAction(rep_);
   end 
  self.spr_bg_Back_:setAnchorPoint(cc.p(0.5,0.5));
  self.spr_bg_Back_:setPosition(winSize.width/2,winSize.height/2);  
  self.spr_bg_Back_:setScaleX(winSize.width/1280);
  self.spr_bg_Back_:setScaleY(winSize.height/720);
   self.Main_Node:addChild(self.spr_bg_Back_,-1);
   self.fist_init_flag=1;
  end
end
function CGameBack:update(delta)

  if (self.m_screen_shake_flag>0) then 
      local t_shake_pos = cc.p((math.random(0,40)- 20), (math.random(0,20) -10));
      	self.Main_Node:setPosition(t_shake_pos);
		self.m_screen_shake_timer =self.m_screen_shake_timer - delta;
		if (self.m_screen_shake_timer < -0.0001)then 
			self.m_screen_shake_flag = 0;
			self.Main_Node:setPosition(cc.p(0, 0));
		end
  end
end
--场景切换
--  场景二次变换
function CGameBack:ChangeSceneB()
   if (self.scene_switching_ == 1) then 
        cc.exports.g_soundManager:PlayGameEffect("denglongyumusic");
        if (self.spr_bg_Back_) then 
            local t_left_node = self.spr_bg_Back_:getChildByTag(100);
			local t_right_node = self.spr_bg_Back_:getChildByTag(200);
            if (t_left_node) then 		
				local moveby = cc.MoveBy:create(3, cc.p(-580, 0));--//左移动
				t_left_node:runAction(moveby);
			end
            if (t_right_node) then 
				local moveby = cc.MoveBy:create(3, ccp(580, 0));--//左移动
				t_right_node:runAction(moveby);		
			end	
        end
   end
end
function CGameBack:ShakeScreen(t_shake_time)
    self.m_screen_shake_flag = 1;
	if(t_shake_time) then self.m_screen_shake_timer =  t_shake_time; 
    else  self.m_screen_shake_timer =  1; end
end
function  CGameBack:SetSwitchSceneStyle(cscene_style)

    cc.exports.g_soundManager:StopBackMusic();
	 cc.exports.g_soundManager:PlayGameEffect("LogoSound1");
	local winSize     = cc.Director:getInstance():getWinSize();--->getWinSize();
	self.scene_switching_ = cscene_style% 3;
	self.spr_bg_Back_SwitchFlag = false;
    self.Main_Node:removeChildByTag(993322);
    cclog("CGameBack:SetSwitchSceneStyle cscene_style=%d, scene_switching_=%d..........................................",cscene_style,self.scene_switching_);
    --添加logo
    local spr_logo = cc.Sprite:create("haiwang/res/HW/~SceneLogo_000_000.png");
	if (spr_logo) then 
			self.Main_Node:addChild(spr_logo, 11, 993322);
			spr_logo:setPosition(cc.p(winSize.width / 2, winSize.height/2));
			spr_logo:setScale(10);
			local t_scale = cc.ScaleTo:create(0.55, 1);
			spr_logo:runAction(t_scale);
	end
    --自行波纹动作
    --cc.exports.game_manager_:run_wave_Action();
   --[[
     local t_delay0 = cc.DelayTime:create(0.8);
	local t_CCRipple3D0 =cc.Ripple3D:create(10, cc.size(64, 68), cc.p(winSize.width / 2, winSize.height / 2), 240, 5,160); --cc.Ripple3D:create(10,cc.p(64,68),ccp(winSize.width / 2, winSize.height / 2),200,5,180);
    --10.0f, ccp(64, 48), ccp(winSize.width / 2, winSize.height / 2), 200, 5, 180, 0.012f);
	local t_seq0 = cc.Sequence:create(t_delay0, t_CCRipple3D0,nil);
	--self._nodegird:runAction(cc.RepeatForever(t_seq0));
    --cc.Waves3D.create(duration,gridSize,waves,amplitude)
    local actionInterval =cc.Waves3D:create(5, cc.size(10, 10), 10, 20)
    --cc.Ripple3D:create(55, cc.size(30, 30), cc.p(640, 360), 240, 4, 160)--- cc.Waves3D:create(115, cc.size(20, 20), 50, 120)--
    self._nodegird:runAction(actionInterval)
    --]]
    --cc.Action:reverse
   ------------------------------------------
   local t_spr_bg_Back__Mark = cc.LayerColor:create(ccc4(0, 0, 0, 255), winSize.width, winSize.height);
	if (t_spr_bg_Back__Mark)then
			cc.exports.game_manager_:removeChildByTag(9944411);
			cc.exports.game_manager_:addChild(t_spr_bg_Back__Mark, GAME_UIORDER_ - 1, 9944411);	
        local function callbackC()  
            self:CreateSceneSpr(self.scene_switching_);
	        self.spr_bg_Back_SwitchFlag = true;
            cc.exports.game_manager_:EndSceneTra();
	         cc.exports.g_soundManager:PlayGameEffect("LogoSound2");
        end
         local function callbackC2()
                	cc.exports.game_manager_:removeChildByTag(9944411);
                    --[[
		        	CCDelayTime *t_delay0 = CCDelayTime::create(0.1f);
			         CCRipple3D*t_CCRipple3D0 = CCRipple3D::create(10.0f, ccp(64, 48), ccp(winSize.width / 2, winSize.height / 2), 160, 4, 180, 0.015f,1);
		        	CCSequence *t_seq0 = CCSequence::create(t_delay0, t_CCRipple3D0, NULL);
			         Main_Node->runAction(t_seq0);
                     --]]          
		         local t_logo =self.Main_Node:getChildByTag(993322);
		         if (t_logo~=nil) then
                    local function logo_callbakc()
                        t_logo:removeFromParent();
                   end
			       local t_delay = cc.DelayTime:create(0.5);
			       local t_fadeout = cc.FadeOut:create(0.5);
			       local t_callfunc = cc.CallFunc:create(logo_callbakc);
			       local t_seq = cc.Sequence:create(t_delay, t_fadeout, t_callfunc, nil);
			       t_logo:runAction(t_seq);
		  end
        end
        --黑暗层
		t_spr_bg_Back__Mark:setOpacity(0)		
		local delaytimew = cc.DelayTime:create(2.5);
		local fadein = cc.FadeIn:create(0.50);--//
		local  funcall = cc.CallFunc:create(callbackC);--//更换背景 
		local  fadeOut = cc.FadeOut:create(0.50);--//
		local funcallremove = cc.CallFunc:create(callbackC2);--// 生成矩阵
		local seq = cc.Sequence:create(delaytimew, fadein, funcall, fadeOut, funcallremove, nil);
		t_spr_bg_Back__Mark:runAction(seq);
	end
end
return CGameBack;
--endregion

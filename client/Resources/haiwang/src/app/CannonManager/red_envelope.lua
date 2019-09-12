--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/6/7
--此文件由[BabeLua]插件自动生成
local red_envelope = class("red_envelope",
 function()
	return cc.Node:create()
end
)
function red_envelope:ctor( fish_pos, cannon_pos,chair_id,fish_score)
       cclog("red_envelope:ctor(fish_pos, cannon_pos, chair_id, score)");
        local function Excallback(  )
              self:ExplorCoin()
         end
            local function Endcallback(  )
               self:removeFromParent()
        end
        local t_end_pos = cannon_pos;
		if (chair_id < 2) then t_end_pos.y =  t_end_pos.y-100;
		else t_end_pos.y =t_end_pos.y+ 100; end
        self:setPosition(fish_pos);
		self:setScale(0.6);
        local t_bg_spr=cc.Sprite:create("haiwang/res/HW/red_envelope.png");
        local t_f_spr=cc.Sprite:create("haiwang/res/HW/red_envelope.png");
        local t_num = cc.LabelAtlas:_create(fish_score,"haiwang/res/HW/ChainShell/chainwin_scoreNum.png", 48, 70, 48);
        t_num:setAnchorPoint(cc.p(0.5, 0.5));
		t_num:setPosition(cc.p(0,-70));
		self:addChild(t_bg_spr, -1);
		self:addChild(t_f_spr, 99);
		self:addChild(t_num, 100);
        local t_delay=cc.DelayTime:create(0.4);
        local t_moveto=cc.MoveTo:create(0.3, t_end_pos);
        local t_callfunc=cc.CallFunc:create(Excallback);
        local t_delay1=cc.DelayTime:create(4);
        local t_fadeout=cc.FadeOut:create(0.2);
        local t_remov=cc.CallFunc:create(Endcallback);
        local t_seq=cc.Sequence:create(t_delay, t_moveto, t_callfunc, t_delay1, t_fadeout, t_remov);
        self:runAction(t_seq);
        cclog("red_envelope:ctor(fish_pos, cannon_pos, chair_id, score)11");
end
function red_envelope:ExplorCoin() 
        local t_alive_num = 15 + math.random(0,30) ;
        local  i=0;
        for  i = 0, t_alive_num,1  do
            local t_rand_num=math.random(0,200);
            t_rand_num=t_rand_num /100.0;
            local t_start_pos=cc.p(0,0);
		    local t_red_coin = red_coin.new(t_start_pos, 300, t_rand_num);
	    	self:addChild(t_red_coin, 10);
        end
end
return red_envelope;
--endregion

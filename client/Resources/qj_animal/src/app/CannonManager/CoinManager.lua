--region CoinManager.lua 
--Author : Administrator
--Date   : 2017/4/8
--此文件由[BabeLua]插件自动生成 金币管理

local CoinManager = class("CoinManager",
 function()
	return cc.Node:create()
end
)
function CoinManager:ctor()
   self.coin_width=48;
   self.coin_height=58;
   self.kCoinCountEnum= { [0]=0, 100, 1000, 10000, 100000 };
   self. kCointCount= { [0]=1, 2, 3, 4, 5 };
     local i=0;
     for i=0,20,1 do
        cc.exports.g_offsetCoin_InitFlag[i]=0;
    end
    cc.exports.g_CoinManager=self;
    --cc.SpriteFrameCache:getInstance():addSpriteFrames("haiwang/res/HW/coin_.plist");
end
function  CoinManager:BuildCoin( fish_pos, chair_id, score, Mul)

   cclog(" CoinManager:BuildCoin( fish_pos, chair_id, score, Mul)-------------");
   local  winSize     = cc.Director:getInstance():getWinSize();
   --local  t__local_info_type = _local_info_array_[chair_id];
   local t__local_info_type=cc.exports._local_info_array_[chair_id];
   local  coin_count =Mul;
   --[[
   local i=0;
	for i = 4, 0,-1 do
		if (score >= self.kCoinCountEnum[i]) then
			if (i ==4) then
				coin_count = self.kCointCount[i] + ((score - self. kCoinCountEnum[i]) / 10000);
				coin_count = math.min(20, coin_count);
			else 	coin_count = self. kCointCount[i];	end
			break;
		end
	end
    --]]
    local  radius = (coin_count - 1) * self.coin_width / 2;
	local center = cc.p(fish_pos.x, fish_pos.y);
	local  t_mov_angle = t__local_info_type.default_angle+ 1.57079632679489661923;
	if (coin_count > 10)
	then
		center.x = fish_pos.x + self.coin_width * math.cos(t_mov_angle);
		center.y = fish_pos.y + self.coin_width * math.sin(t_mov_angle);
		radius = (10 - 1) * self.coin_width / 2;
	end
    local t_alive_delay = 0.0;
	if (coin_count < 1) then coin_count = 1; end
	for  i = 0,coin_count, 1 do
		t_alive_delay= t_alive_delay+0.05;
		local t_score = score / coin_count;
		if (i == (coin_count - 1)) then t_score = t_score+score% coin_count; end
		local t_Coin = Coin.new(fish_pos,  chair_id, t_score, t_alive_delay);
		if (t_Coin)then	self:addChild(t_Coin); end
	end
end
return CoinManager;

--endregion

--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/8
--奖励显示管理
local BingoManager = class("BingoManager",
 function()
	return cc.Node:create()
end
)

function BingoManager:ctor()
   cc.exports.g_offsetBingo_InitFlag={[0]=0,0};
    cc.exports.g_BingoManager=self;
end
function BingoManager:AddBingo(chair_id,  fish_score,style)
    local t_Bingo = Bingo.new(chair_id, fish_score,style);
	self:addChild(t_Bingo);    
end

return BingoManager;

--endregion

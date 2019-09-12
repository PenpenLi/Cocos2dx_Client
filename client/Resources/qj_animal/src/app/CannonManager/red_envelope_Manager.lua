--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/6/7
--此文件由[BabeLua]插件自动生成
local red_envelope_Manager = class("red_envelope_Manager",
 function()
	return cc.Node:create()
end
)
function red_envelope_Manager:ctor()
end
function  red_envelope_Manager:add(fish_pos, cannon_pos, chair_id, score)
    --cclog("red_envelope_Manager:add(fish_pos, cannon_pos, chair_id, score)1112232323");
    local t_red_envelope = red_envelope.new(fish_pos, cannon_pos, chair_id, score);
	self:addChild(t_red_envelope);    
end
return red_envelope_Manager;
--endregion

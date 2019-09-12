--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/19
--此文件由[BabeLua]插件自动生成 矩形碰撞
--[[
(x1,y1)------(x2,y2)
   |            |
   |            |
(x4,y4)------(x3,y3)
--]]

BoundingBox=class("BoundingBox");
function BoundingBox:ctor(_width,_height,center_x,center_y,angle)
  self.box_width = _width / 2;
  self.box_height = _height / 2;
  self.d_min=math.min(_width,_height);
  self.d_max=math.max(_width,_height);
  self.cx=center_x;
  self.cy=center_y;
  local sint = math.sin(angle);
  local cost = math.cos(angle);
  local hot_x1 = -self.box_width;
  local hot_y1 = -self.box_height;
  local hot_x2 = self.box_width;
  local hot_y2 = self.box_height;
  self. x1_ = hot_x1 * cost - hot_y1 * sint + center_x;
  self.y1_ = hot_x1 * sint + hot_y1 * cost + center_y;
 self. x2_ = hot_x2 * cost - hot_y1 * sint + center_x;
 self. y2_ = hot_x2 * sint + hot_y1 * cost + center_y;
 self. x3_ = hot_x2 * cost - hot_y2 * sint + center_x;
 self. y3_ = hot_x2 * sint + hot_y2 * cost + center_y;
 self.x4_ = hot_x1 * cost - hot_y2 * sint + center_x;
 self.y4_ = hot_x1 * sint + hot_y2 * cost + center_y;
end
function BoundingBox:ComputeCollision(x, y,r)
   if(r<=0) then r=1; end  --半径检测最低精度1
   local c_disx=x-self.cx;
   local c_disy=y-self.cy;
   local c_dis=math.sqrt((c_disx*c_disx)+(c_disy*c_disy));--math.sqrt()
   c_dis=c_dis-r;
   if(c_dis>self.d_max) then return false;
   elseif(c_dis<self.d_min)   then return true; end
   --[[
   --四边形检测
    local point= { [0]=cc.p(self.x1_, self.y1_), [1]=cc.p(self.x2_, self.y2_), [2]=cc.p(self.x3_, self.y3_), [3]=cc.p(self.x4_, self.y4_) };
    local i, j=0,0;
    local inside = false;
    local count1 = 0;
    local count2 = 0;
    j = 3;
    for i = 0, 3,1 do    
      local  value = (x - point[j].x) * (point[i].y - point[j].y) - (y - point[j].y) * (point[i].x - point[j].x);
      if (value > 0)then  count1=count1+1;
      elseif(value < 0) then count2=count2+1; end
      j = i+1;
      if(j >3) then j =0;end
   end
    if (0 == count1 or 0 == count2)  then inside = true; end
    return inside;
    --]]
 end
return BoundingBox;
--endregion

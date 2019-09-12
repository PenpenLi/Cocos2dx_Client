--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/5/5
--此文件由[BabeLua]插件自动生成
local scene_fish_trace = class("scene_fish_trace", 
function()
    return cc.Node:create()
end)
function scene_fish_trace:ctor()      
     self.scene_kind_1_trace_ = {[0]={}};
     self.scene_kind_2_trace_ = {[0]={}};
     self.scene_kind_3_trace_ = {[0]={}};
     self.scene_kind_4_trace_ = {[0]={}};
     self.scene_kind_5_trace_ = {[0]={}};      

     self.scene_kind_2_small_fish_stop_index_={[0]=0};
     self.scene_kind_2_small_fish_stop_count_ = 0;
     self.scene_kind_2_big_fish_stop_index_ = 0;
     self.scene_kind_2_big_fish_stop_count_ = 0;
        
end 

---------------------------  
-- @function StringSplit lua字符串分割函数    
-- @param str 待分割的字符串  
-- @param splitStr 用于分割字符串  
-- @param addNemptyStr 是否将空字符串也放入返回字串表中（默认false,可空）  
-- @param addSplitStrInTable 是否将分割用的字符串加入数组（默认false,可空）  
-- @return 分割后字符串Table  
-- Create by ArcherPeng  
function scene_fish_trace:StringSplit(str, splitStr,addNemptyStr,addSplitStrInTable)  
    if not addNemptyStr then addNemptyStr = false end  
    if not addSplitStrInTable then addSplitStrInTable = false end  
    local subStrTab = {};  
    while (true) do  
        local pos = string.find(str, splitStr);  
        if (not pos)  then  
            if str ~="" or addNemptyStr then  
                subStrTab[#subStrTab + 1] = str;  
            end  
            break;  
        end  
        local subStr = string.sub(str, 1, pos - 1);  
        if subStr~="" or addNemptyStr then  
            subStrTab[#subStrTab + 1] = subStr;  
        end  
        if addSplitStrInTable then  
            subStrTab[#subStrTab + 1] = splitStr;  
        end  
        str = string.sub(str, pos +string.len(splitStr) , #str);  
    end  
    return subStrTab;  
end 

--function scene_fish_trace:get_scene_kind_2_small_fish_stop_index_() return self.scene_kind_2_small_fish_stop_index_; end
--function scene_fish_trace:get_scene_kind_2_small_fish_stop_count_() return self.scene_kind_2_small_fish_stop_count_; end
--function scene_fish_trace:get_scene_kind_2_big_fish_stop_index_() return self.scene_kind_2_big_fish_stop_index_; end
--function scene_fish_trace:get_scene_kind_2_big_fish_stop_count_() return self.scene_kind_2_big_fish_stop_count_; end

--function scene_fish_trace:GetScene1Trace() return self.scene_kind_1_trace_ ;   end;
function scene_fish_trace:GetScene2Trace()

    --    cclog("scene_fish_trace:GetScene2Trace()02");
       local t_scene_kind_2_trace_ = {[0]={}};
       local data=cc.FileUtils:getInstance():getStringFromFile("haiwang/res/HW/scene_kind_2_trace_.lua");
       local strTab=self:StringSplit(data,";"); 
       for i=1,#strTab,1 do
           t_scene_kind_2_trace_[i-1]= loadstring("return "..strTab[i])();
       end
       return t_scene_kind_2_trace_;
 end
--function scene_fish_trace:GetScene3Trace() return self.scene_kind_3_trace_ ;   end;
--function scene_fish_trace:GetScene4Trace() return self.scene_kind_4_trace_ ;    end;
function scene_fish_trace:GetScene5Trace()
       cclog("scene_fish_trace:GetScene5Trace()02");
      local t_scene_kind_5_trace_ = {[0]={}}; 
      local data1=cc.FileUtils:getInstance():getStringFromFile("haiwang/res/HW/scene_kind_5_trace_.lua");
      local strTab1=self:StringSplit(data1,";"); 
      for i=1,#strTab1,1 do
          t_scene_kind_5_trace_[i-1]= loadstring("return "..strTab1[i])();
      end
      return t_scene_kind_5_trace_;
  end;

function  scene_fish_trace:BuildCircle( center_x,  center_y,  radius, fish_count)
   if (fish_count <= 0)  then return; end
   local fish_pos={[0]=cc.p(0,0)};
	local cell_radian = 2 * 3.14159265358979323846 / fish_count;
    for i = 0, fish_count-1,1  do	
		local x = center_x + radius * math.cos(i * cell_radian);
		local y = center_y + radius * math.sin (i * cell_radian);
        fish_pos[i]=cc.p(x,y);
	end
    return fish_pos;
end

function  scene_fish_trace:BuildLinear_xy( init_,init_count,distance)
      local  teace_index=0;
      local trace_vector={[0]=cc.p(0,0)};
      if (init_count < 2) then   return; end
	  if (distance <= 0.0) then  return; end
      local  last_point=cc.p(init_[init_count - 1].x,init_[init_count - 1].y);
       local fist_point=cc.p(init_[0].x,init_[0].y);
      local dx_max=last_point.x-fist_point.x;
      local dy_max=last_point.y-fist_point.y;
      local  distance_total = math.sqrt(dx_max*dx_max+dy_max*dy_max); --CalcDistance(init_x[init_count - 1], init_y[init_count - 1], init_x[0], init_y[0]);
       if (distance_total <= 0.0) then  return; end
     local  cos_value = (init_[init_count - 1].y - init_[0].y) / distance_total;
     local  sin_value =   (init_[init_count - 1].x - init_[0].x) / distance_total;
	  local  angle =  math.acos(cos_value);
      trace_vector[0]=cc.p(fist_point.x,fist_point.y);
      teace_index=1;
      local  temp_distance = 0.0;
      while (temp_distance < distance_total) do
          local point=cc.p(init_[0].x,init_[0].y);
	  	 point.x = point.x +sin_value* (distance * teace_index);
		 point.y = point.y + cos_value * (distance * teace_index)
         trace_vector[teace_index]=point;
         teace_index=teace_index+1;
         local dx=point.x-fist_point.x;
         local dy=point.y-fist_point.y;
         temp_distance= math.sqrt(dx*dx+dy*dy);
	  end --while
      return trace_vector;
end

function  scene_fish_trace:BuildLinear_xya( init_,init_count,distance)
            --cclog("BuildLinear_xya init_count=%d,distance=%d",init_count,distance);
            if(distance<1) then distance=1; end
            local trace_vector={[0]={x=0,y=0,angle=0}};
            local  teace_index=0;
            local trace_vector={[0]=cc.p(0,0)};
            if (init_count < 2) then   return; end
	        if (distance <= 0.0) then  return; end
             local  last_point=cc.p(init_[init_count - 1].x,init_[init_count - 1].y);
            local fist_point=cc.p(init_[0].x,init_[0].y);
            local dx_max=last_point.x-fist_point.x;
            local dy_max=last_point.y-fist_point.y;
            local  distance_total = math.sqrt(dx_max*dx_max+dy_max*dy_max); --CalcDistance(init_x[init_count - 1], init_y[init_count - 1], init_x[0], init_y[0]);
            if (distance_total <= 0.0) then  return; end
            local  cos_value = (last_point.y - fist_point.y) / distance_total;
            local  sin_value =   (last_point.x - fist_point.x) / distance_total;
	        local  angle_ = math.atan2(dx_max,dy_max);-- math.acos(cos_value)+math.pi;
           -- cclog("scene_fish_trace:BuildLinear_xya(init_(%f,%f)(%f,%f)),angle_=%f",init_[0].x,init_[0].y,init_[1].x,init_[1].y,angle_);
            trace_vector[0]={x=fist_point.x,y=fist_point.y,1};
           teace_index=1;
           local  temp_distance = 0.0;
           local  temp_pos=cc.p(0,0);
           while (temp_distance < distance_total) do  
                local point=cc.p(fist_point.x,fist_point.y);
		        point.x = point.x + sin_value * (distance * teace_index);
		        point.y = point.y + cos_value * (distance * teace_index);                              
               trace_vector[teace_index]={x=point.x,y=point.y,angle=angle_;};
               teace_index=teace_index+1;
               local dx=point.x-fist_point.x;
               local dy=point.y-fist_point.y;
                temp_distance= math.sqrt(dx*dx+dy*dy);--
               -- cclog("point(%f,%f)sin_value(%f,%f),distance=%f,temp_distance=%f,distance_total=%d",
               -- point.x,point.y,sin_value,cos_value,distance,temp_distance,distance_total);
	     end --while
         return trace_vector;
end


function scene_fish_trace:ChangToGLPos(p)
     return cc.Director:getInstance():convertToGL(p)
end

function scene_fish_trace:BuildSceneKind2Trace()
   cclog(" scene_fish_trace:BuildSceneKind2Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kHScale = screen_width/kRESOLUTIONWIDTH;
  local kVScale = screen_height/kRESOLUTIONHEIGHT;
  local kStopExcursion = 180 * kVScale;
  local kHExcursion = 27 * kHScale / 2;
  local kSmallFishInterval = (screen_width - kHExcursion*2)/100;
  local kSmallFishHeight = 65 * kVScale;
  local kSpeed = 3 * kHScale;
  local fish_count = 0;
  --scene_kind_2_trace_.speed = kSpeed*30
 self.scene_kind_2_trace_.small_middle_delay = 1616/30;
  math.randomseed(0);
  local small_height = math.floor(kSmallFishHeight * 3);
  for i=0,199 do
    local sp,mp,ep = cc.p(0,0), cc.p(0, 0), cc.p(0,0);
    sp.x = kHExcursion + (i%100)* kSmallFishInterval;
    ep.x = sp.x;
    local excursion = math.random(0, 32767) % small_height;
    if i < 100 then --上排
      sp.y = -65 - excursion;
      ep.y = screen_height + 65;
    else --下排
      sp.y = screen_height + 65 + excursion;
      ep.y = -65;
    end
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
    local init_={[0]=sp,ep};
   	self. scene_kind_2_trace_[i]=self:BuildLinear_xya(init_,2,kSpeed);
  end
  fish_count = fish_count+200;
  --//大鱼
  local big_fish_width = {[0] = 270 * kHScale, 226 * kHScale, 375 * kHScale, 420 * kHScale, 540 * kHScale, 454 * kHScale, 600 * kHScale};
  local big_fish_excursion = {};
  for i=0,6 do
    big_fish_excursion[i] = big_fish_width[i];
    for j=0,i-1 do
      big_fish_excursion[i] = big_fish_excursion[i] + big_fish_width[j];
    end
  end
  local y_excursoin = 250 * kVScale / 2;

  for i=0,13 do
    local sp, ep = cc.p(0,0), cc.p(0, 0), cc.p(0,0);
    if i < 7 then
      sp.y = screen_height/2 - y_excursoin;
      ep.y = sp.y;
      sp.x = -big_fish_excursion[i%7];
      ep.x = screen_width + big_fish_width[i%7];
    else
      sp.y = screen_height/2 + y_excursoin;
      ep.y = sp.y;
      sp.x = screen_width + big_fish_excursion[i%7];
      ep.x = -big_fish_width[i%7];      
    end
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
    local init_={[0]=sp,ep};
    self.scene_kind_2_trace_[fish_count+i]=self:BuildLinear_xya(init_,2,kSpeed);
  end--for i
  local t_trace___=self.scene_kind_2_trace_[fish_count+5]
  local max_trace_size=#t_trace___;
  --//小鱼调整
   local big_stop_count = 0;
   local i,j=0,0;
   for i = 0,199,1 do
        for j = 0,#	self.scene_kind_2_trace_[i],1 do
          local  pos = self.scene_kind_2_trace_[i][j];
           if (i > 100)  then 
               	if (pos.y >= kStopExcursion) then --//停止点				
					self.scene_kind_2_small_fish_stop_index_[i] = j;
					if (big_stop_count == 0) then  big_stop_count = j;
					elseif (big_stop_count < j) then big_stop_count = j; end
					break;
				end
           else 
               if (pos.y < screen_height - kStopExcursion)  then          
					self.scene_kind_2_small_fish_stop_index_[i] = j;
					if (big_stop_count == 0) then  big_stop_count = j;
					elseif (big_stop_count < j)  then big_stop_count = j;end
					break;
				end
           end--if else
        end--for j
   end --for i
    self.scene_kind_2_small_fish_stop_count_ =max_trace_size;
	self.scene_kind_2_big_fish_stop_index_ = 0;
	self.scene_kind_2_big_fish_stop_count_ = big_stop_count + 1;
    --输出停止点
    local string_stop_str="{[0]=";
    for i=0,#self.scene_kind_2_small_fish_stop_index_,1 do
      string_stop_str=string.format("%s%d,",string_stop_str,self.scene_kind_2_small_fish_stop_index_[i]);
    end
    string_stop_str=string.format("%s};",string_stop_str);
    cclog("self.scene_kind_2_small_fish_stop_index_=%s",string_stop_str);
    ----------------------------------------------------------------------------------------
    --[[
  --输出文件
   local file = io.open("h:\\scene_kind_2_trace_.lua", "w");
   file:write("{ \n");
  local i=0;
  local n=0;
  for i=0,#self.scene_kind_2_trace_,1 do
     local string_data1=string.format("{ ",i);  
     file:write(string_data1);
      local  fish_table=self.scene_kind_2_trace_[i];
      local  array_count=#fish_table;   
     for n=1,array_count-1 do
         cclog("Get [%d][%d]=(%d,%d,%d)",i,n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);
         if(n==1) then 
            local string_data2=string.format("[%d]={%d,%d,%d},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);  
            file:write(string_data2);
         else 
            local string_data2=string.format("{%d,%d,%d},",fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);  
            file:write(string_data2);
         end
     end-- for n=0,array_count-2,1 do
     n=array_count;
     local string_data3=string.format("{%d,%d,%d} } \n",fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);
     file:write(string_data3);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
   ----------------------------------------------------------------------------------------------------------]]
end


function scene_fish_trace:BuildSceneKind5Trace()
 cclog(" scene_fish_trace:BuildSceneKind5Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
 -- local  kVScale = screen_height / kResolutionHeight;
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kVScale = screen_height / kRESOLUTIONHEIGHT;
  local kRadius = (screen_height - (200*kVScale))/2;
  local kRotateSpeed = 1.5*math.pi/180;
  local kSpeed = 5 * screen_width / kRESOLUTIONWIDTH;
  local lcenter = self:ChangToGLPos(cc.p(screen_width/4, kRadius + 100 * kVScale));
  local rcenter = self:ChangToGLPos(cc.p(screen_width - screen_width/4, kRadius + 100 * kVScale));
  local t_k_pi_num=math.pi / 180;
  local kLFish1Rotate = 720*t_k_pi_num; --* math.pi / 180;
  local kRFish2Rotate = (720 + 90)*t_k_pi_num; --* math.pi / 180;
  local kRFish5Rotate = (720 + 180)*t_k_pi_num; --* math.pi / 180;
  local kLFish3Rotate = (720 + 180 + 45)*t_k_pi_num; --* math.pi / 180;
  local kLFish4Rotate = (720 + 180 + 90)*t_k_pi_num; --* math.pi / 180;
  local kRFish6Rotate = (720 + 180 + 90 + 30)*t_k_pi_num; --* math.pi / 180;
  local kRFish7Rotate = (720 + 180 + 90 + 60)*t_k_pi_num; --* math.pi / 180;
  local kLFish6Rotate = (720 + 180 + 90 + 60 + 30)*t_k_pi_num; --* math.pi / 180;
  local kLFish18Rotate = (720 + 180 + 90 + 60 + 60)*t_k_pi_num; --* math.pi / 180;
  local kRFish17Rotate = (720 + 180 + 90 + 60 + 60 + 30)*t_k_pi_num; --* math.pi / 180;
  local fish_count=0;
  --self.scene_kind_5_trace_.speed = kSpeed*30
    for  j = 0, 235 ,1 do	
			self.scene_kind_5_trace_[j]={};--.push_back(fish_pos[j]);
	end
  --左外1
  local center={[0]=cc.p(screen_width / 4,kRadius + 100 * kVScale),[1]=cc.p(screen_width - screen_width / 4, kRadius + 100 * kVScale)};
   local get_index=0;
   local rotate=0;
  while(rotate <= kLFish1Rotate) do
		local center1=cc.p(center[0].x,center[0].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius, 40, rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 39 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
        --cclog("get_index=%d scene_fish_trace:BuildSceneKind5Trace  rotate=%f,kRotateSpeed=%f,kLFish1Rotate=%f",get_index,rotate,kRotateSpeed,kLFish1Rotate);
	end --while
	fish_count = fish_count+40;
   -- cclog(" scene_fish_trace:BuildSceneKind5Trace2");
  --右外1
  local rotate=0;
  local get_index=0;
  while(rotate <= kRFish2Rotate) do
		local center1=cc.p(center[1].x,center[1].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius, 40, rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 39 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
	fish_count = fish_count+40;

  local rotate=0;
  local get_index=0;

  while(rotate <= kRFish5Rotate) do
		local center1=cc.p(center[1].x,center[1].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius - 34.5* kVScale, 40, rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 39 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+40;

  local rotate=0;
  local get_index=0;

  while(rotate <= kLFish3Rotate) do
		local center1=cc.p(center[0].x,center[0].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius - 36.0* kVScale, 40, rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 39 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+40;

  local rotate=0;
  local get_index=0;

  while(rotate <= kLFish4Rotate) do
		local center1=cc.p(center[0].x,center[0].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius - 36.0* kVScale- 56.0 * kVScale, 24, rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 23 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+24;
  
  local rotate=0;
  local get_index=0;
  while(rotate <= kRFish6Rotate) do
		local center1=cc.p(center[1].x,center[1].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius - 34.5* kVScale - 58.5 * kVScale, 24,rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 23 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
         get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+24;

  local rotate=0;
  local get_index=0;
  while(rotate <= kRFish7Rotate) do
		local center1=cc.p(center[1].x,center[1].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y, kRadius- 34.5* kVScale - 58.5 * kVScale - 65.0 * kVScale, 13,rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 12 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
         get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+13;
  local rotate=0;
  local get_index=0;
  while(rotate <= kLFish6Rotate) do
		local center1=cc.p(center[0].x,center[0].y);
		center1=self:ChangToGLPos(center1);
        local fish_pos=self:BuildCircleEx(center1.x, center1.y,kRadius - 36.0 * kVScale - 56.0 * kVScale - 68.0 * kVScale, 13,rotate, kRotateSpeed);
		--MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for  j = 0, 12 ,1 do	
			self.scene_kind_5_trace_[fish_count+j][get_index]=fish_pos[j];--.push_back(fish_pos[j]);
		end
         get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+13;
  --	//大鱼
  local rotate=0;
  local get_index=0;
  while(rotate <= kLFish18Rotate) do
	    local fish_pos={x=center[0].x,y=center[0].y,angle= -1.5707963267948966 + rotate;}
		self.scene_kind_5_trace_[fish_count][get_index]=fish_pos;--.push_back(fish_pos[j]);
         get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+1;
    --	//大鱼1
  local rotate=0;
  local get_index=0;
  while(rotate <= kRFish17Rotate) do
	    local fish_pos={x=center[1].x,y=center[1].y,angle= -1.5707963267948966 + rotate;}
		self.scene_kind_5_trace_[fish_count][get_index]=fish_pos;--.push_back(fish_pos[j]);
        get_index=get_index+1;
        rotate =rotate+ kRotateSpeed;
  end --while
  fish_count = fish_count+1;
  local win_width_max=100+screen_width;
  local win_height_max=100+screen_height;
  --离开
  for i=0,235,1 do
     local back_index=#self.scene_kind_5_trace_[i]-1;
     local t_trace_data=self.scene_kind_5_trace_[i][back_index];
     local sp=cc.p(t_trace_data.x,t_trace_data.y);
     local s_angle=t_trace_data.angle;
      --cclog(" scene_fish_trace:BuildSceneKind5Trace2 back_index=%d i=%d t_trace_data(%f,%f,%f) kSpeed=%f",back_index,i,t_trace_data.x,t_trace_data.y,t_trace_data.angle,kSpeed);
     --直接延伸生成
     local sin_t= kSpeed*math.sin(s_angle);--*1.5;
     local cos_t= kSpeed*math.cos(s_angle);--*1.5;     
     local get_finish_flag=1;
     local next_posx,next_posy=sp.x,sp.y;
     while(get_finish_flag==1) do 
        next_posx=next_posx+sin_t;
        next_posy=next_posy+cos_t;
        local fish_pos={x=next_posx,y=next_posy,angle=s_angle};
        back_index=back_index+1;
        self.scene_kind_5_trace_[i][back_index]=fish_pos;
       -- sp.x=next_posx;
        --sp.y=next_posy;
        --sp=cc.p(next_posx,next_posy);
        if(i<233) then 
            if(fish_pos.x<-100 
            or fish_pos.x>win_width_max
             or fish_pos.y>win_height_max
             or fish_pos.y<-100
           ) then get_finish_flag=0; end
        else 
          if(fish_pos.x<-250 
            or fish_pos.x>(250+screen_width)
             or fish_pos.y>(250+screen_height)
             or fish_pos.y<-250
           ) then get_finish_flag=0; end
        end
     end
  end--for i=0;235,1 do

      ----------------------------------------------------------------------------------------
      
  --输出文件
   local file = io.open("h:\\scene_kind_5_trace_.lua", "w");
   file:write("{ \n");
  local i=0;
  local n=0;
  for i=0,#self.scene_kind_5_trace_,1 do
     local string_data1=string.format("{ ",i);  
     file:write(string_data1);
      local  fish_table=self.scene_kind_5_trace_[i];
      local  array_count=#fish_table;   
     for n=1,array_count-1 do
         cclog("Get [%d][%d]=(%d,%d,%d)",i,n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);
          -- trace_vector[teace_index]={x=point.x,y=point.y,angle=angle_;};
          if(n==1) then 
            local string_data2=string.format("[%d]={%d,%d,%d},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);  
            file:write(string_data2);
         else 
            local string_data2=string.format("{%d,%d,%d},",fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);  
            file:write(string_data2);
         end
     end-- for n=0,array_count-2,1 do
     n=array_count;
     local string_data3=string.format("{%d,%d,%d} } \n",fish_table[n].x,fish_table[n].y,fish_table[n].angle*57.2957795);
     file:write(string_data3);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
   ----------------------------------------------------------------------------------------------------------]]
end
--]]


function scene_fish_trace:BuildSceneKind1Trace()
  --cclog(" scene_fish_trace:BuildSceneKind1Trace0");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local fish_count = 0;
  local kVScale = screen_height / 768;
  local kRadius = (screen_height - (240 * kVScale)) / 2;
  local kSpeed = 1.5* screen_width / 1366;
  local center = cc.p(screen_width + kRadius+50, kRadius + 120 * kVScale)
  local center1 =  self:ChangToGLPos(cc.p(screen_width + kRadius+50, kRadius + 120 * kVScale))
  local fish_pos = self:BuildCircle(center1.x,center1.y, kRadius, 100)
  for i=0,99 do
    local init_={};
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+100;
  local kRotateRadian1 = 45 * math.pi / 180;
  local kRotateRadian2 = 135 * math.pi / 180;
  local kRadiusSmall = kRadius / 2;
  local kRadiusSmall1 = kRadius / 3;
  local center_small = {}
  center_small[0] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian2), center.y + kRadiusSmall * math.sin(-kRotateRadian2)))
  center_small[1] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian1), center.y + kRadiusSmall * math.sin(-kRotateRadian1)))
  center_small[2] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian2), center.y + kRadiusSmall * math.sin(kRotateRadian2)))
  center_small[3] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian1), center.y + kRadiusSmall * math.sin(kRotateRadian1)))
  center_small[0]=self:ChangToGLPos(center_small[0]);
  center_small[1]=self:ChangToGLPos(center_small[1]);
  center_small[2]=self:ChangToGLPos(center_small[2]);
  center_small[3]=self:ChangToGLPos(center_small[3]);
  local fish_pos =self:BuildCircle(center_small[0].x, center_small[0].y, kRadiusSmall1, 17); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
  for i=0,16 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  --cclog(" scene_fish_trace:BuildSceneKind1Trace3");
  fish_count =fish_count+17;
  local fish_pos =self:BuildCircle(center_small[1].x, center_small[1].y, kRadiusSmall1, 17); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
  for i=0,16 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end

   fish_count=fish_count+17;
   local fish_pos =self:BuildCircle(center_small[2].x, center_small[2].y, kRadiusSmall1, 30); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
   for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count =fish_count+30;

   local fish_pos =self:BuildCircle(center_small[3].x, center_small[3].y, kRadiusSmall1, 30); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
   for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count =fish_count+30;

  center1=center;
  center1=self:ChangToGLPos(center1);
  local fish_pos =self:BuildCircle(center1.x, center1.y, kRadiusSmall / 2, 15);
   for i=0,14 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+15;

  local sp = center;
  local ep = cc.p(-2*kRadius, sp.y);
  local init_= {[0]=sp,ep}

  
 self.scene_kind_1_trace_[fish_count]=self:BuildLinear_xya(init_, 2,  kSpeed);
 ---------------------------------------------------------------------------------------------------------------------
  --输出路径文件
   local file = io.open("h:\\scene_kind_1_trace_.lua", "w");
  file:write("cc.exports.scene_kind_1_trace_={ \n");
  file:write(" mov_type=0 \n");
  file:write(" mov_tspeed=60 \n");
  local i=0;
  local  fish_table=self.scene_kind_1_trace_[0];
  local string_data2=string.format("[0]={{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
  file:write(string_data2);
  for i=1,#self.scene_kind_1_trace_,1 do
      local  fish_table=self.scene_kind_1_trace_[i];
      local string_data2=string.format(",{{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
       file:write(string_data2);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
   ----------------------------------------------------------------------------------------------------------------------
end



function scene_fish_trace:BuildSceneKind3Trace()
  cclog(" scene_fish_trace:BuildSceneKind3Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kRadius = (screen_height-(240*kVScale))/2
  local kSpeed = 1.5 * screen_width / kRESOLUTIONWIDTH
  local center = cc.p(screen_width+kRadius, kRadius+120*kVScale)
  local fish_count=0;
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius, 50);
  for i=0,49 do
    local sp = cc.p(fish_pos[i].x,fish_pos[i].y);
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
    self.scene_kind_3_trace_[i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count = fish_count+50;--50
 local fish_pos = self:BuildCircle(center.x, center.y, kRadius * 40 / 50, 40);
  for i=0,39,1 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
     local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count + i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count = fish_count+40;--90
  --fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius * 30 / 50, 30);
  for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
     local init_={[0]=sp,ep};
      self.scene_kind_3_trace_[fish_count + i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end 
  fish_count =fish_count+30;--120
  if(1) then 
     local sp = cc.p(center.x,center.y);
    local ep = cc.p(-2*kRadius, sp.y)
    --
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
     local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count]=init_--self:BuildLinear_xya(init_, 2,  kSpeed);
       fish_count=fish_count+1;
  end
 
  --fish_pos = math.buildCircleStatic(center, kRadius, 50)
  local center = cc.p( -kRadius, kRadius+120*kVScale)
 -- center.x = -kRadius;
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius , 50);
  for i=0,49 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+50;--170
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius*40/50 , 40);
  for i=0,39 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=init_;--;=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+40;
  --fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
   local fish_pos = self:BuildCircle(center.x, center.y, kRadius*30/50 , 30);
  for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+30;
  if(1) then 
     local sp = cc.p(center.x,center.y);
    local ep = cc.p(screen_width+2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
     local init_={[0]=sp,ep};
      self.scene_kind_3_trace_[fish_count]=init_;--self:BuildLinear_xya(init_, 2,  kSpeed);
  end
 ---------------------------------------------------------------------------------------------------------------------
  --输出路径文件
   local file = io.open("h:\\scene_kind_3_trace_.lua", "w");
  file:write("cc.exports.scene_kind_3_trace_={ \n");
  file:write(" mov_type=0 \n");
  file:write(" mov_tspeed=60 \n");
  local i=0;
  local  fish_table=self.scene_kind_3_trace_[0];
  local string_data2=string.format("[0]={{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
  file:write(string_data2);
  for i=1,#self.scene_kind_3_trace_,1 do
      local  fish_table=self.scene_kind_3_trace_[i];
      local string_data2=string.format(",{{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
       file:write(string_data2);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();

   ----------------------------------------------------------------------------------------------------------------------
end

function scene_fish_trace:BuildSceneKind4Trace()
  cclog(" scene_fish_trace:BuildSceneKind4Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kHScale = screen_width/kRESOLUTIONWIDTH
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kSpeed = 3*kHScale
  self.scene_kind_4_trace_.speed = kSpeed*30
  local kFishWidth = 512*kHScale
  local kFishHeight = 304*kVScale
  --左下
  local start_pos = cc.p(0, screen_height - kFishHeight/2)
  local target_pos = cc.p(screen_width - kFishHeight/2, 0)
  local angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  local radius = kFishWidth*4
  local length = radius + kFishWidth/2
  local center_pos = cc.p(-length*math.cos(angle), start_pos.y + length*math.sin(angle))

  local ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))
  local fish_count=0;
  local sp
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp =  self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
      self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
     radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = screen_width
  target_pos.y = kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)
  ep =  self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))

  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp =  self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  --右下
  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = 0
  target_pos.y = kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)
  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
   local init_={[0]=sp,ep};
    self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = screen_width
  start_pos.y = screen_height - kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = 0
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
   fish_count=fish_count+8;

  --右上
  start_pos.x = screen_width
  start_pos.y = kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = 0
  target_pos.x = 0
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end  
   fish_count=fish_count+8;

  --左上
  start_pos.x = kFishHeight/2
  start_pos.y = 0
  target_pos.x = screen_width
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)
  ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
   fish_count=fish_count+8;

  start_pos.x = 0
  start_pos.y = kFishHeight/2
  target_pos.x = screen_width - kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end

   ---------------------------------------------------------------------------------------------------------------------
   --[[
  --输出路径文件
   local file = io.open("h:\\scene_kind_4_trace_.lua", "w");
  file:write("cc.exports.scene_kind_4_trace_={ \n");
  file:write(" mov_type=0 \n");
  file:write(" mov_tspeed=60 \n");
  local i=0;
  local  fish_table=self.scene_kind_4_trace_[0];
  local string_data2=string.format("[0]={{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
  file:write(string_data2);
  for i=1,#self.scene_kind_4_trace_,1 do
      local  fish_table=self.scene_kind_4_trace_[i];
      local string_data2=string.format(",{{%d,%d},{%d,%d}}\n",fish_table[0].x,fish_table[0].y,fish_table[1].x,fish_table[1].y);  
       file:write(string_data2);
  end-- for i=0,fish_count ,1 do

   file:write("};\n");
   file:close();
   --]]
   ----------------------------------------------------------------------------------------------------------------------


end


function scene_fish_trace:BuildSceneKind1TraceEx()
  cclog(" scene_fish_trace:BuildSceneKind1Trace0");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local fish_count = 0;
  local kVScale = screen_height / 768;
  local kRadius = (screen_height - (240 * kVScale)) / 2;
  local kSpeed = 1.5* screen_width / 1366;
  local center = cc.p(screen_width + kRadius+50, kRadius + 120 * kVScale)
  local center1 =  self:ChangToGLPos(cc.p(screen_width + kRadius+50, kRadius + 120 * kVScale))
  local fish_pos = self:BuildCircle(center1.x,center1.y, kRadius, 100)
  for i=0,99 do
    local init_={};
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+100;
 -- cclog(" scene_fish_trace:BuildSceneKind1Trace2");
  local kRotateRadian1 = 45 * math.pi / 180;
  local kRotateRadian2 = 135 * math.pi / 180;
  local kRadiusSmall = kRadius / 2;
  local kRadiusSmall1 = kRadius / 3;
  local center_small = {}
  center_small[0] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian2), center.y + kRadiusSmall * math.sin(-kRotateRadian2)))
  center_small[1] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(-kRotateRadian1), center.y + kRadiusSmall * math.sin(-kRotateRadian1)))
  center_small[2] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian2), center.y + kRadiusSmall * math.sin(kRotateRadian2)))
  center_small[3] =  self:ChangToGLPos(cc.p(center.x + kRadiusSmall * math.cos(kRotateRadian1), center.y + kRadiusSmall * math.sin(kRotateRadian1)))
  center_small[0]=self:ChangToGLPos(center_small[0]);
  center_small[1]=self:ChangToGLPos(center_small[1]);
  center_small[2]=self:ChangToGLPos(center_small[2]);
  center_small[3]=self:ChangToGLPos(center_small[3]);
  local fish_pos =self:BuildCircle(center_small[0].x, center_small[0].y, kRadiusSmall1, 17); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
  for i=0,16 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    --table.insert(scene_kind_1_trace_, {sp, ep})
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  --cclog(" scene_fish_trace:BuildSceneKind1Trace3");
  fish_count =fish_count+17;
  local fish_pos =self:BuildCircle(center_small[1].x, center_small[1].y, kRadiusSmall1, 17); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
  for i=0,16 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    --table.insert(scene_kind_1_trace_, {sp, ep})
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end

   fish_count=fish_count+17;
   local fish_pos =self:BuildCircle(center_small[2].x, center_small[2].y, kRadiusSmall1, 30); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
   for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count =fish_count+30;

   local fish_pos =self:BuildCircle(center_small[3].x, center_small[3].y, kRadiusSmall1, 30); --math.buildCircleStatic(center_small[1], kRadiusSmall1, 17)
   for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count =fish_count+30;

  center1=center;
  center1=self:ChangToGLPos(center1);
  local fish_pos =self:BuildCircle(center1.x, center1.y, kRadiusSmall / 2, 15);
   for i=0,14 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    local init_= {[0]=sp,ep}
    self.scene_kind_1_trace_[fish_count +i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
  fish_count=fish_count+15;

  local sp = center;
  local ep = cc.p(-2*kRadius, sp.y);
  local init_= {[0]=sp,ep}

  
 self.scene_kind_1_trace_[fish_count]=self:BuildLinear_xya(init_, 2,  kSpeed);
     local file = io.open("c:\\scene_kind_1_trace_.lua", "w");
  --输出文件
   file:write("cc.exports.scene_kind_1_trace_={ \n");
  local i=0;
  local n=0;
  for i=0,fish_count,1 do
     local string_data1=string.format("[%d]={ ",i);  
     file:write(string_data1);
      local  fish_table=self.scene_kind_1_trace_[i];
      local  array_count=#fish_table;   
     for n=1,array_count-1 do
         cclog("Get [%d][%d]=(%d,%d,%d)",i,n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
          -- trace_vector[teace_index]={x=point.x,y=point.y,angle=angle_;};
          if(n==1) then 
            local string_data2=string.format("[%d]={%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         else 
            local string_data2=string.format("{%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         end
     end-- for n=0,array_count-2,1 do
     n=array_count;
     local string_data3=string.format("{%d,%d,%f} }\n",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
     file:write(string_data3);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
end

function scene_fish_trace:BuildSceneKind3TraceEx()
  cclog(" scene_fish_trace:BuildSceneKind3Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kRadius = (screen_height-(240*kVScale))/2
  local kSpeed = 1.5 * screen_width / kRESOLUTIONWIDTH
  local center = cc.p(screen_width+kRadius, kRadius+120*kVScale)
  local fish_count=0;
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius, 50);
 -- scene_kind_3_trace_.speed = kSpeed*30
  for i=0,49 do
    local sp = cc.p(fish_pos[i].x,fish_pos[i].y);
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
    self.scene_kind_3_trace_[i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    --scene_kind_3_trace_[i] = {sp, ep}
  end
  fish_count = fish_count+50;--50
 local fish_pos = self:BuildCircle(center.x, center.y, kRadius * 40 / 50, 40);
  for i=0,39,1 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    --table.insert(scene_kind_3_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count + i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
   fish_count = fish_count+40;--90
  --fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius * 30 / 50, 30);
  for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(-2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
   -- table.insert(scene_kind_3_trace_, {sp, ep})
     local init_={[0]=sp,ep};
      self.scene_kind_3_trace_[fish_count + i]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end 
  fish_count =fish_count+30;--120
  if(1) then 
     local sp = cc.p(center.x,center.y);
    local ep = cc.p(-2*kRadius, sp.y)
    --
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
    --cclog(" scene_fish_trace:BuildSceneKind3Trace111 sp(%f,%f) ep(%f,%f) fish_count=%d",sp.x,sp.y,ep.x,ep.y,fish_count);
   -- table.insert(scene_kind_3_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count]=self:BuildLinear_xya(init_, 2,  kSpeed);
      -- cclog(" scene_fish_trace:scene_kind_3_trace_ pos0(%f,%f) ",self.scene_kind_3_trace_[fish_count][0].x,self.scene_kind_3_trace_[fish_count][0].y);
       fish_count=fish_count+1;
  end
 
  --fish_pos = math.buildCircleStatic(center, kRadius, 50)
  local center = cc.p( -kRadius, kRadius+120*kVScale)
 -- center.x = -kRadius;
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius , 50);
  for i=0,49 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    --table.insert(scene_kind_3_trace_, {sp, ep})
  end
  fish_count=fish_count+50;--170

  --fish_pos = math.buildCircleStatic(center, kRadius*40/50, 40)
  local fish_pos = self:BuildCircle(center.x, center.y, kRadius*40/50 , 40);
  for i=0,39 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    --table.insert(scene_kind_3_trace_, {sp, ep})
  end
  fish_count=fish_count+40;
  --fish_pos = math.buildCircleStatic(center, kRadius*30/50, 30)
   local fish_pos = self:BuildCircle(center.x, center.y, kRadius*30/50 , 30);
  for i=0,29 do
    local sp = fish_pos[i]
    local ep = cc.p(screen_width + 2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp)
    ep =  self:ChangToGLPos(ep)
    local init_={[0]=sp,ep};
     self.scene_kind_3_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    --table.insert(scene_kind_3_trace_, {sp, ep})
  end
  fish_count=fish_count+30;
  if(1) then 
     local sp = cc.p(center.x,center.y);
    local ep = cc.p(screen_width+2*kRadius, sp.y)
    sp =  self:ChangToGLPos(sp);
    ep =  self:ChangToGLPos(ep);
   -- table.insert(scene_kind_3_trace_, {sp, ep})
     local init_={[0]=sp,ep};
      self.scene_kind_3_trace_[fish_count]=self:BuildLinear_xya(init_, 2,  kSpeed);
  end
 -- table.insert(scene_kind_3_trace_, {ChangToGLPos(center), ChangToGLPos(cc.p(screen_width+2*kRadius, center.y))})


     ----------------------------------------------------------------------------------------
  --输出文件
   local file = io.open("h:\\scene_kind_3_trace_.lua", "w");
   file:write("cc.exports.scene_kind_3_trace_={ \n");
  local i=0;
  local n=0;
  for i=0,#self.scene_kind_3_trace_-1,1 do
     local string_data1=string.format("[%d]={ ",i);  
     file:write(string_data1);
      local  fish_table=self.scene_kind_3_trace_[i];
      local  array_count=#fish_table;   
     for n=1,array_count-1 do
         cclog("Get [%d][%d]=(%d,%d,%d)",i,n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
          -- trace_vector[teace_index]={x=point.x,y=point.y,angle=angle_;};
          if(n==1) then 
            local string_data2=string.format("[%d]={%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         else 
            local string_data2=string.format("{%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         end
     end-- for n=0,array_count-2,1 do
     n=array_count;
     local string_data3=string.format("{%d,%d,%f} }\n",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
     file:write(string_data3);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
   ----------------------------------------------------------------------------------------------------------
end

function scene_fish_trace:BuildSceneKind4TraceEx()
  cclog(" scene_fish_trace:BuildSceneKind4Trace");
  local screen_width, screen_height=0,0;
  local t_winsize=cc.Director:getInstance():getWinSize();
  screen_width=t_winsize.width;
  screen_height=t_winsize.height;
  local kHScale = screen_width/kRESOLUTIONWIDTH
  local kVScale = screen_height/kRESOLUTIONHEIGHT
  local kSpeed = 3*kHScale
  self.scene_kind_4_trace_.speed = kSpeed*30
  local kFishWidth = 512*kHScale
  local kFishHeight = 304*kVScale
  --左下
  local start_pos = cc.p(0, screen_height - kFishHeight/2)
  local target_pos = cc.p(screen_width - kFishHeight/2, 0)
  local angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  local radius = kFishWidth*4
  local length = radius + kFishWidth/2
  local center_pos = cc.p(-length*math.cos(angle), start_pos.y + length*math.sin(angle))

  local ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))
  local fish_count=0;
  local sp
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp =  self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
      self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
     radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = screen_width
  target_pos.y = kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)
  ep =  self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y - kFishHeight))

  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    end
    sp =  self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  --右下
  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = screen_height
  target_pos.x = 0
  target_pos.y = kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)
  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
   local init_={[0]=sp,ep};
    self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = screen_width
  start_pos.y = screen_height - kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = 0
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y + length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y - kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(angle+math.pi), center_pos.y + radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(angle), center_pos.y - radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
   fish_count=fish_count+8;

  --右上
  start_pos.x = screen_width
  start_pos.y = kFishHeight/2
  target_pos.x = kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
  fish_count=fish_count+8;

  start_pos.x = screen_width - kFishHeight/2
  start_pos.y = 0
  target_pos.x = 0
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((start_pos.x - target_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x + length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x - kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x + radius*math.cos(-angle-math.pi), center_pos.y + radius*math.sin(-angle-math.pi))
    else
      sp = cc.p(center_pos.x - radius*math.cos(-angle), center_pos.y - radius*math.sin(-angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end  
   fish_count=fish_count+8;

  --左上
  start_pos.x = kFishHeight/2
  start_pos.y = 0
  target_pos.x = screen_width
  target_pos.y = screen_height - kFishHeight/2
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)
  ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
    --table.insert(scene_kind_4_trace_, {sp, ep})
     local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
   fish_count=fish_count+8;

  start_pos.x = 0
  start_pos.y = kFishHeight/2
  target_pos.x = screen_width - kFishHeight/2
  target_pos.y = screen_height
  angle = math.acos((target_pos.x - start_pos.x)/cc.pGetDistance(start_pos, target_pos))
  radius = kFishWidth*4
  length = radius + kFishWidth/2
  center_pos.x = start_pos.x - length*math.cos(angle)
  center_pos.y = start_pos.y - length*math.sin(angle)

  ep = self:ChangToGLPos(cc.p(target_pos.x + kFishWidth, target_pos.y + kFishHeight))
  for i=0,7 do
    if radius < 0 then
      sp = cc.p(center_pos.x - radius*math.cos(angle+math.pi), center_pos.y - radius*math.sin(angle+math.pi))
    else
      sp = cc.p(center_pos.x + radius*math.cos(angle), center_pos.y + radius*math.sin(angle))
    end
    sp = self:ChangToGLPos(sp)
    --ep = ChangToGLPos(ep)
   -- table.insert(scene_kind_4_trace_, {sp, ep})
    local init_={[0]=sp,ep};
     self.scene_kind_4_trace_[fish_count+i]=self:BuildLinear_xya(init_, 2,  kSpeed);
    radius = radius - kFishWidth
  end
       ----------------------------------------------------------------------------------------
  --输出文件
   local file = io.open("h:\\scene_kind_4_trace_.lua", "w");
   file:write("cc.exports.scene_kind_4_trace_={ \n");
  local i=0;
  local n=0;
  for i=0,#self.scene_kind_4_trace_-1,1 do
     local string_data1=string.format("[%d]={ ",i);  
     file:write(string_data1);
      local  fish_table=self.scene_kind_4_trace_[i];
      local  array_count=#fish_table;   
     for n=1,array_count-1 do
         cclog("Get [%d][%d]=(%d,%d,%d)",i,n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
          -- trace_vector[teace_index]={x=point.x,y=point.y,angle=angle_;};
          if(n==1) then 
            local string_data2=string.format("[%d]={%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         else 
            local string_data2=string.format("{%d,%d,%f},",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);  
            file:write(string_data2);
         end
     end-- for n=0,array_count-2,1 do
     n=array_count;
     local string_data3=string.format("{%d,%d,%f} }\n",n-1,fish_table[n].x,fish_table[n].y,fish_table[n].angle);
     file:write(string_data3);
  end-- for i=0,fish_count ,1 do
   file:write("};\n");
   file:close();
   ----------------------------------------------------------------------------------------------------------


end


function scene_fish_trace:BuildCircleEx( center_x,  center_y,  radius,  fish_count,  rotate, rotate_speed)
  	if (fish_count <= 0) then  return; end
	 local  cell_radian = 2 * 3.141592653 / fish_count;
     local fish_pos={[0]={x=0,y=0,angle=0}};
     for  i = 0, fish_count,1 do 
         local last_pos=cc.p(0,0);
         last_pos.x = center_x + radius * math.cos(i * cell_radian + rotate - rotate_speed);
		 last_pos.y = center_y + radius * math.sin(i * cell_radian + rotate - rotate_speed);
         local t_pos_i={x=0,y=0,angle=0}
         t_pos_i.x = center_x + radius * math.cos(i * cell_radian + rotate);
		 t_pos_i.y = center_y + radius * math.sin(i * cell_radian + rotate);
		 t_pos_i.angle= math.atan2(t_pos_i.x-last_pos.x,t_pos_i.y-last_pos.y);
         fish_pos[i]={};
         fish_pos[i]=t_pos_i;
     end
     return fish_pos;
end 

function scene_fish_trace:angle_range( angle)

	while (angle <= -6.283185307)  do	
		angle =angle+ 6.283185307;
	end
	if (angle < 0.0) then angle =angle+ 6.283185307; end
	while (angle >= 6.283185307) do
		angle = angle -6.2831853072;
	end
	return angle;
end


function scene_fish_trace:GetTargetPoint( screen_width,  screen_height,  src_x_pos,  src_y_pos,  angle)
   local target_x_pos,target_y_pos=0,0;
	angle = self:angle_range(angle);
	if (angle > 0.0 and angle < M_PI_2) 
	then 
		target_x_pos = screen_width + 300;
		target_y_pos = src_y_pos + (screen_width - src_x_pos + 300) * math.tan(angle);
	
	elseif (angle >= M_PI_2 and angle < M_PI) then
		target_x_pos = -300;
		target_y_pos = src_y_pos - (src_x_pos + 300) *  math.tan(angle);
	elseif (angle >= M_PI and angle < 3 * M_PI / 2.0) then
		target_x_pos = -300;
		target_y_pos = src_y_pos - (src_x_pos + 300) *  math.tan(angle);
	else
		target_x_pos = screen_width + 300;
		target_y_pos = src_y_pos + (screen_width - src_x_pos + 300) *  math.tan(angle);
	end
end

return scene_fish_trace;
--endregion

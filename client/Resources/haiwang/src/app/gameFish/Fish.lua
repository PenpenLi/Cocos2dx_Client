--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/4/15
--此文件由[BabeLua]插件自动生成

local Fish = class("Fish",
 function()
	return cc.Node:create()
end
)
local M_PI_VALUE=3.1415926;
function Fish:Init()
   self.scene_mov_trace_flag=0;
   self.scene_kind_index=0;
   self.scene_Index=0;
   self.active_=0;
   self.fish_status_=0;
   self.m_moveKind=0;
    self.trace_index_ = 0;
    self.m_nFishDieCount=0;
    self.trace_vector_=nil;
    self.valid_=false;
    self.m_connect_Stop_Flag=0;
    self.m_broach_cut_flag=-1;
    self.stop_index_=0;
    self.stop_count_=0;
    self.m_fish_Check_Angle=0;
    self.current_stop_count_=0;
    self.m_fish_mov_by_actionFlag=0;
    self.m_moveKind=0;
    self.m_nFishDieCount=0;
    self.m_mov_timer=0;
    self.m_catch_type=0;
    self.m_catchEffect_step=0;
	self.m_fish_runState=0;
    self.m_fish_by_configList=nil; --鱼的游泳状态
	self.fis_node=nil;
    self.baseAngle=0;
	self.m_fish_mov_point_total=0;
    self.m_fish_mov_point_index=0;
    self.m_no_catch_flag=0;
    self.m_connect_Stop_Flag=0;
    self.m_fish_die_action_EndFlag=0;
	self.m_mov_delay_timer=0;
    self.m_mov_timer = 0;
	self.m_speed_x=0;
	self.m_speed_y=0;
	self.m_mov_timer_ex = 0;
	self.m_mov_speed_ex = 0;
	self.m_chainLink_main_id=0;
	self.m_chainLink_Next_id=0;
	self.m_start_in_win_flag =false;
	self.m_connect_length_Max_S=0;
	self.m_connect_start_Flag = 0;
	self.m_connect_length_index = 0;
	self.m_chainLink_Mul=0;
	self.m_chainLink_Index=0;
    self.m_fish_mov_point_index=0;
     self.m_fish_mov_point_total=1;
     self.box_width = 10;
    self.box_height = 10;
    self.d_min=10;
    self.d_max=10;
    self.alive_timer=0;
    self.check_timer=0;
end
function  Fish:SetBroachCut( chairID) self.m_broach_cut_flag = chairID; end; --;//标记被穿甲弹碰撞过
function  Fish:getBroachCut() return self.m_broach_cut_flag; end;
function  Fish:set_trace_type( trace_type)  trace_type_ = trace_type; end;
function  Fish:trace_type()   return trace_type_;  end
function  Fish:mm_getAngle(beginPoint, endPoint)
	local len_y = endPoint.y - beginPoint.y;
	local len_x = endPoint.x - beginPoint.x;
	if (len_y >= -0.00001 and len_y<=0.00001)
	then
		if (len_x < 0)	then return 270;
		else
          if (len_x > 0)then	return 90; end
        end
		return 0;
	end
	if (len_x >= -0.00001  and len_x <= 0.00001) then
		if (len_y >= 0) then
          return 0;
		else
          if (len_y < 0) then  return 180; end
        end
	end
	return math.atan2(len_x,len_y) * 180 / math.pi;
end
function Fish:setscene_fish_flag()
   self.scene_fish_flag=1;
end
function Fish:ctor(fish_kind, fish_id, fish_multiple, fish_speed, bounding_box_width, bounding_box_height, hit_radius, startpos, delay)
  --[[
  cclog("Fish:ctor( fish_kind=%d,  fish_id=%d,  fish_multiple=%d,  fish_speed=%d,  bounding_box_width=%d,  bounding_box_height=%d,  hit_radius=%d,  startpos(%f,%f), delay=%d )"
            ,fish_kind,  fish_id,  fish_multiple,  fish_speed,  bounding_box_width,  bounding_box_height,  hit_radius,  startpos.x,startpos.y,   delay);]]
---初始化
    self.scene_fish_flag=0;
    self.alive_limi_time=0;
    self:Init();
    self.m_chainLink_Next_pos=cc.p(0,0);
    self.m_mov_delay_timer = delay;
	self.m_xuanfeng_catch_score = 0;
	self.m_xuanfeng_catch_chair_id = 0;
	self.fish_kind_ = fish_kind;
	self.fish_id_ = fish_id;
	self.fish_multiple_ = fish_multiple;
	self.fish_speed_ = fish_speed;
	self.bounding_box_width_ =cc.exports.game_fish_width[fish_kind];-- bounding_box_width;--
	self.bounding_box_height_ =cc.exports.game_fish_height[fish_kind];-- bounding_box_height;--

   -- cclog("self.bounding_box_width_ =%d,self.bounding_box_height_=%d,",self.bounding_box_width_,self.bounding_box_height_);
    self.box_width = bounding_box_width / 2;
    self.box_height = bounding_box_height / 2;
    self.d_min=math.min(bounding_box_width,bounding_box_height);
    self.d_max=math.max(bounding_box_width,bounding_box_height);
    --self.d_min=self.d_min*self.d_min;
    --self.d_max=self.d_max*self.d_max;
	self.hit_radius_ = hit_radius;
	self.m_catch_chairID=0;
	self.m_catch_mul=0;
    self.m_catch_bullet_mul=0;
	self.m_catch_score=0;
    self.baseAngle =math.pi/2;
    self.m_mov_position=cc.p(-1000,-1000);
	self.fis_node = cc.Sprite:createWithSpriteFrameName("fish_empty.png");--CCSprite::createWithSpriteFrameName("fish_empty.png");// CCNode::create();
    if (self.fis_node) then
                if (self.fish_kind_ < 22)then
				        self:CreateSmall_fish(self.fish_kind_, game_fish_PlaySpdChange[self.fish_kind_+1], 0,0);
	           end
				self.fis_node:setPosition(startpos);
				self.fis_node:setVisible(false);
				if (self.fish_kind_ < 22 )then self.fis_node:setScale(1.0);
                elseif(self.fish_kind_>34) then self.fis_node:setScale(1.0);
				else self.fis_node:setScale(1.6);
                end
				self:addChild(self.fis_node);
  end
   local fish_body_node_=cc.Node:create();

    local body = cc.PhysicsBody:createBox(cc.size(self.bounding_box_width_, self.bounding_box_height_));
    body:setGroup(2);
    body:setDynamic(false);
    body:setGravityEnable(false);
    body:setContactTestBitmask(1);
    fish_body_node_:setPhysicsBody(body);
   self.fis_node:addChild(fish_body_node_,0,7758258);
     --[[
      local function handler(interval)
            self:update(interval);
       end
      self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
      --]]
 -- cclog("Fish:ctor end");
end
function  Fish:update(delta)
           --if(delta>0.04) then delta=0.04; end;
          self:OnFrame(delta);
end
function  Fish:CreateSmall_fish(kindNum,state_num , run_state , delay)
   --cclog("Fish:CreateSmall_fish(kindNum=%d,state_num=%d , run_state=%d , delay=%d)",kindNum,state_num , run_state , delay);
    if (self.fis_node) then
         local oo_fish=self.fis_node:getChildByTag(10086);
         if(oo_fish~=nil) then self.fis_node:removeChild(oo_fish); end
         --self.fis_node:removeChildByTag(10086);
     end

    local spriteFrame  = cc.SpriteFrameCache:getInstance();
	local readIndex = 0;
	local t_fish_kind = kindNum;
	if (kindNum == 19) then t_fish_kind = 3;end
	if (kindNum == 20) then t_fish_kind = 6;end
	if (kindNum == 21) then t_fish_kind = 7;end
    local _sprite=nil;
    local animation = cc.Animation:create();
     for i=0, 70,1 do
        local path_str="";
     	if (run_state == 0) then path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
		else  path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, run_state,i); end
         local blinkFrame = spriteFrame:getSpriteFrame(path_str) ;
         if(blinkFrame) then
            --校对中心
            local offset_name="";
            if (run_state == 0) then offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
		   else  offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, run_state, i); end
          if (cc.exports.g_offsetmap_InitFlag[t_fish_kind] <0.111) then --cc.exports.g_offsetmap_InitFlag
             --cc.exports.OffsetPointMap[offset_name].initFlag = 1;
             local t_offset_ = cc.p(0, 0);
             local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
              --cclog("t_offect_str=%s",t_offect_str);
             local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
             local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
             local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
             --cclog("t_offect_str=%s,t_x=%s,t_y=%s",t_offect_str,t_x,t_y);
             local t_offeset_pos=cc.p(0,0);
             local t_offset_0 = blinkFrame:getOffsetInPixels();
             t_offset_.x =t_x*0.68;--t_offset_.x * 10/ 20;
		 	 t_offset_.y = -t_y*0.68;--t_offset_.y * 10/ 20;
             blinkFrame:setOffsetInPixels(t_offset_);
             end
             if(_sprite==nil) then _sprite=cc.Sprite:createWithSpriteFrameName(path_str) ;end
            readIndex=readIndex+1;
            animation:addSpriteFrame(blinkFrame);
             --cclog(" Fish:CreateSmall_fish add   animation:addSpriteFrame(blinkFrame); readIndex=%d-------",readIndex);
         end
     end
       if(readIndex>0) then
            cc.exports.g_offsetmap_InitFlag[t_fish_kind]=1;
            --cclog(" Fish:CreateSmall_fish add   animation:addSpriteFrame(blinkFrame); readIndex=%d",readIndex);
           animation:setDelayPerUnit(cc.exports.game_fish_frame_Speed[t_fish_kind+1]);--1/24.0);--cc.exports.game_fish_frame_Speed[t_fish_kind]);            --设置两个帧播放时间

           local action =cc.Animate:create(animation);
            _sprite:runAction(cc.RepeatForever:create(action));
            _sprite:setScale( cc.exports.game_fish_frame_Scale[kindNum]);
      end
      if(_sprite)  then  self.fis_node:addChild(_sprite, 0, 10086); end
end
function  Fish:CreateSmall_fishDead( kindNum)
    local spriteFrame  = cc.SpriteFrameCache:getInstance();
	local readIndex = 0;
	local t_fish_kind = kindNum;
	if (kindNum == 19) then t_fish_kind = 3;end
	if (kindNum == 20) then t_fish_kind = 6;end
	if (kindNum == 21) then t_fish_kind = 7;end
    local _sprite=nil;
    local animation = cc.Animation:create();
     for i=0, 40,1 do
        local path_str="";
        if (kindNum==18 or kindNum==17) then path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
		else   path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, 1, i); end
         local blinkFrame = spriteFrame:getSpriteFrame(path_str) ;
         if(blinkFrame) then  --校对中心
            local offset_name="";
             if (kindNum==18 or kindNum==17) then offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
	    	else   offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, 1, i); end
          --if ((kindNum<17 or kindNum>18) and cc.exports.g_offsetmap_InitFlag_D[t_fish_kind] <0.111) then --cc.exports.g_offsetmap_InitFlag
            local t_offset_ = cc.p(0, 0);
             local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
             local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
             local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
             local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
             local t_offeset_pos=cc.p(0,0);
             local t_offset_0 = blinkFrame:getOffsetInPixels();
             t_offset_.x =t_x*0.68;--t_offset_.x * 10/ 20;
		 	 t_offset_.y = -t_y*0.68;--t_offset_.y * 10/ 20;
             blinkFrame:setOffsetInPixels(t_offset_);
            -- end
             if(_sprite==nil) then _sprite=cc.Sprite:createWithSpriteFrameName(path_str) ;end
            readIndex=readIndex+1;
            animation:addSpriteFrame(blinkFrame);
         end
     end
       if(readIndex>0) then
          local function  die_callBack_ex()
              self:Fish_Die_ActionCallback();
          end
            cc.exports.g_offsetmap_InitFlag_D[t_fish_kind]=1;
            local t_run_time = 48 / readIndex;
			if (t_run_time < 1) then t_run_time = 1; end
           animation:setDelayPerUnit(cc.exports.game_fish_frame_Speed[t_fish_kind]);            --设置两个帧播放时间
           local action =cc.Animate:create(animation);
           local t_rep_action=cc.Repeat:create(action,t_run_time);--
           local  fadeout = cc.FadeOut:create(0.3);
		   local  funcall = cc.CallFunc:create(die_callBack_ex);
		   local  seq = cc.Sequence:create(t_rep_action, fadeout, funcall, nil);
            _sprite:runAction(seq);
            _sprite:setScale( cc.exports.game_fish_frame_Scale[kindNum]);
      end
      return _sprite;
--       local t_deiNode = cc.Node:create();
--	  local t_CCRotateBy = cc.RotateBy:create(2, 360);
--	  local t_rep = cc.RepeatForever:create(t_CCRotateBy);
--	  t_deiNode:runAction(t_rep);
--      return t_deiNode;
end
function  Fish:CreateSmall_fishDeadEx( kindNum)
    local spriteFrame  = cc.SpriteFrameCache:getInstance();
	local readIndex = 0;
	local t_fish_kind = kindNum;
	if (kindNum == 19) then t_fish_kind = 3;end
	if (kindNum == 20) then t_fish_kind = 6;end
	if (kindNum == 21) then t_fish_kind = 7;end
    local _sprite=nil;
    local animation = cc.Animation:create();
     for i=0, 40,1 do
        local path_str="";
        if (kindNum==18 or kindNum==17) then path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
		else   path_str=string.format("~fish%02d_%03d_%03d.png", t_fish_kind + 1, 1, i); end
         local blinkFrame = spriteFrame:getSpriteFrame(path_str) ;
         if(blinkFrame) then  --校对中心
          if (cc.exports.g_offsetmap_InitFlag_D[t_fish_kind] <0.111) then --cc.exports.g_offsetmap_InitFlag
             local offset_name="";
              if (kindNum==18 or kindNum==17) then offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, 0, i);
		     else                    offset_name=string.format("fish%02d_%03d_%03d.png", t_fish_kind + 1, 1, i); end
             local t_offset_ = cc.p(0, 0);
             local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
             local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
             local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
             local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
             local t_offeset_pos=cc.p(0,0);
             local t_offset_0 = blinkFrame:getOffsetInPixels();
             t_offset_.x =t_x*0.68;--t_offset_.x * 10/ 20;
		 	 t_offset_.y = -t_y*0.68;--t_offset_.y * 10/ 20;
             blinkFrame:setOffsetInPixels(t_offset_);
             end
             if(_sprite==nil) then _sprite=cc.Sprite:createWithSpriteFrameName(path_str) ;end
            readIndex=readIndex+1;
            animation:addSpriteFrame(blinkFrame);
         end
     end
       if(readIndex>0) then
         --cclog("Fish:CreateSmall_fishDeadEx readIndex=%d",readIndex)
          local function  die_callBack_ex()
              self:Fish_Die_ActionCallback();
          end
           local function  die_callBack_ex1()
              self:CatchScore_callback();
           end
            cc.exports.g_offsetmap_InitFlag_D[t_fish_kind]=1;
            local t_run_time = 48 / readIndex;
			if (t_run_time < 1) then t_run_time = 1; end
           animation:setDelayPerUnit(cc.exports.game_fish_frame_Speed[t_fish_kind]);            --设置两个帧播放时间
           local action =cc.Animate:create(animation);
           local t_rep_action=cc.Repeat:create(action,t_run_time);--
           local  fadeout = cc.FadeOut:create(0.3);
		   local  funcall = cc.CallFunc:create(die_callBack_ex);
		   local  funcall_score = cc.CallFunc:create(die_callBack_ex1);
		   local  seq = cc.Sequence:create(t_rep_action, funcall_score, fadeout, funcall, nil);
            --_sprite:runAction(seq);
             _sprite:runAction(seq);
            _sprite:setScale( cc.exports.game_fish_frame_Scale[kindNum]);
      end
      --if(_sprite)  then  self.fis_node:addChild(_sprite, 0, 10086); end
     local t_deiNode = cc.Node:create();
	  local t_CCRotateBy = cc.RotateBy:create(2, 360);
	  local t_rep = cc.RepeatForever:create(t_CCRotateBy);
	  t_deiNode:runAction(t_rep);
      t_deiNode:addChild(_sprite);
	  self.fis_node:addChild(t_deiNode, 1, 10086);
end
function  Fish:CatchScore_callback()
	--cclog("Fish::CatchScore_callback m_catch_score=%dself.fish_multiple_=%d", self.m_catch_score,self.fish_multiple_);
	self.fis_node:removeChildByTag(99996);
	if (self.m_catch_score > 0)then
         local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_catch_score);
         cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		 cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_catch_score, self.fish_multiple_);
	end
end

function Fish:SetFishStop(stop_index,stop_count)
	self.stop_index_ = stop_index;
	self.stop_count_ = stop_count;
	self.current_stop_count_ = 0;
end
function  Fish:Fish_Die_ActionCallback()
     	self.m_fish_die_action_EndFlag = 1;
		self.fis_node:removeAllChildren();
end

function  Fish:CheckValid()
    local x,y=0,0;
    local winSize     = cc.Director:getInstance():getWinSize();
    x=self.m_mov_position.x;
    y=self.m_mov_position.y;
    if (x > 0.0 and x < winSize.width and  y > 0.0 and y < winSize.height) then
      self.valid_ = true;
      return true;
    end --屏幕内
    local headPos =  cc.p(x,y);
	local TrailPos =  cc.p(x,y);
    if(self.fish_kind_>10) then
         local sin_t= math.sin(self.m_fish_Check_Angle);
         local cos_t= math.cos(self.m_fish_Check_Angle);
		 headPos.x=headPos.x+self.bounding_box_width_*cos_t*0.35;
	     headPos.y=headPos.y+self.bounding_box_width_*sin_t*0.35;
          if (headPos.x > 0.0 and headPos.x < winSize.width and  headPos.y > 0.0 and headPos.y < winSize.height) then
            self.valid_ = true;
             return true;end --屏幕内
         TrailPos.x=TrailPos.x-self.bounding_box_width_*cos_t*0.65;
	     TrailPos.y=TrailPos.y-self.bounding_box_width_*sin_t*0.65;
          if (TrailPos.x > 0.0 and TrailPos.x < winSize.width and  TrailPos.y > 0.0 and TrailPos.y < winSize.height) then
            self.valid_ = true;
            return true;
         end --屏幕内
	end
    self.valid_ = false;
    return false;
end
function  Fish:set_active( active) self.active_ = active;end
function  Fish:active()   return self.active_; end
function  Fish:fish_kind() return self.fish_kind_; end
function  Fish:fish_status()   return self.fish_status_; end
function  Fish:getcatch_flag()return self.m_no_catch_flag;end
function  Fish:Set_fish_status(state)  self.fish_status_=state; end
function  Fish:setMovKind( movKind)  self.m_moveKind = movKind; end
function  Fish:get_fish_mulriple() return self.fish_multiple_; end
function  Fish:ChainLindFishUpdate(delta_time)end
function  Fish:rot_end()m_rot_flag = 0;end
function  Fish:fish_id() return self.fish_id_; end;
function Fish:MovToNextIndex()
	if (self.m_fish_mov_point_index < (self.m_fish_mov_point_total-1))then
	     	local  t_angle_ =self.m_fish_by_configList[self.m_fish_mov_point_index].x;
	    	local  t_angle_a = math.rad(t_angle_);--*0.01745329252;--MySriteCache::GetRadianForAngle(t_angle_);
		    self.m_speed_x = math.sin(t_angle_a);
	     	self.m_speed_y = math.cos(t_angle_a);
		    self.m_mov_timer_ex = 0;
             --cclog(" Fish:MovToNextIndex m_speed_x=%f,m_speed_y=%f,t_angle_a=%f",self.m_speed_x,self.m_speed_y,t_angle_a);
             self.m_speed_x=self.m_mov_speed_ex* self.m_speed_x;
             self.m_speed_y=self.m_mov_speed_ex* self.m_speed_y;
			 self.show_angle = t_angle_a - self.baseAngle;
			 self.m_fish_Check_Angle = t_angle_a
			 t_angle_ = math.deg(self.show_angle);--*57.29577951308;	--MySriteCache::GetAngleForRadian(show_angle);
           -- cclog(" Fish:MovToNextIndex show_angle=%f,t_angle_a=%f",self.show_angle,t_angle_);
			 if (self.m_fish_mov_point_index == 0)then
				 self.fis_node:setRotation(t_angle_);
			 else
             -- self.fis_node:setRotation(t_angle_);
				 if (self.m_rot_speed_ < 2)then self.m_rot_speed_ = 2; end
				 local t_rot_timer = t_angle_ / self.m_rot_speed_;
				 if (t_rot_timer < 0) then t_rot_timer = -t_rot_timer; end
				 local t_rotto = cc.RotateTo:create(t_rot_timer, t_angle_);
				 local t_rot_end = cc.CallFunc:create(self.rot_end);
                 local t_seq=cc.Sequence:create(t_rotto, t_rot_end,nil);
				 self.fis_node:runAction(t_seq);--(CCSequence::create(t_rotto, t_rot_end,NULL));
                 --]]
				 m_rot_flag = 1;
			 end
			 local Show_R = bounding_box_width_;
			 --if (Show_R > bounding_box_height_) then Show_R = bounding_box_height_; end
			-- Show_R = Show_R*0.5;
	    	 self.m_fish_mov_point_index=self.m_fish_mov_point_index+1;
	end
end
function  Fish:MovByList(mov_list,pointNum,mov_speed_, _rot_speed)  --路径和点数
   -- cclog("MovByList(mov_list,pointNum=%d,mov_speed_=%d, _rot_speed=%d)",pointNum,mov_speed_,_rot_speed);
   	if (pointNum > 1)then
        if (pointNum > 10) then pointNum = 10; end
		self.m_moveKind = 2;
		self.m_fish_mov_point_index = 0;
		self.m_fish_mov_by_actionFlag = 0;
		self.m_rot_speed_ = _rot_speed;
		self.m_mov_speed_ex = mov_speed_;
		if (self.m_mov_speed_ex < 10) then  self.m_mov_speed_ex = 10; end
		self.m_mov_position = cc.p(mov_list[0].x, mov_list[0].y);
		self.fis_node:setPosition(self.m_mov_position);
		self.m_fish_by_configList ={[0]=cc.p(0,0)};-- new CCPoint[pointNum];
        local i=0;
		for i = 0, pointNum-2,1 do
			local  s_pos = cc.p(mov_list[i].x, mov_list[i].y);
			local  e_pos = cc.p(mov_list[i+1].x, mov_list[i+1].y);
			local t_dis_num = cc.pGetDistance(s_pos,e_pos);
			local  t_angle_ = self:mm_getAngle(s_pos, e_pos);
            --cclog("i=%d,s_pos (%f,%f),e_pos(%f,%f)t_angle_=%f",i,s_pos.x,s_pos.y,e_pos.x,e_pos.y,t_angle_);
            self.m_fish_by_configList[i]=cc.p(t_angle_,t_dis_num / (self.m_mov_speed_ex));
			--self.m_fish_by_configList[i].x = t_angle_;                                  --角度
			--self.m_fish_by_configList[i].y = t_dis_num / (self.m_mov_speed_ex);--时间
		end
		self.m_fish_by_configList[pointNum - 1] = self.m_fish_by_configList[pointNum - 2];
		self.m_fish_mov_point_total = pointNum;
		self:MovToNextIndex();
		if (self.fis_node:isVisible()==false)  then self.fis_node:setVisible(true); end
		self:set_active(true);
	end
end
function   Fish:Mov_by_List( delta_time)
		self.valid_ = true;
		self.m_mov_timer = self.m_mov_timer+delta_time;
		if (self.m_fish_mov_by_actionFlag == 0) then
				local  t_angle_ = self.fis_node:getRotation()+ self.baseAngle*57.29577951308; ----GetAngleForRadian(baseAngle);
				local  t_angle_a = t_angle_/57.29577951308;
				self.m_speed_x = self.m_mov_speed_ex*math.sin(t_angle_a);--                   ();
				self.m_speed_y = self.m_mov_speed_ex*math.cos(t_angle_a);
				self.show_angle = t_angle_a - self.baseAngle;
				self.m_fish_Check_Angle = t_angle_a;
			    self.m_mov_position.x = self.m_mov_position.x+self.m_speed_x*delta_time;
			    self.m_mov_position.y = self.m_mov_position.y+self.m_speed_y*delta_time;
		     	self.fis_node:setPosition(self.m_mov_position);
			    if (self.fis_node:isVisible()==false) then  self.fis_node:setVisible(true); end
			   if (self.m_fish_mov_point_index < self.m_fish_mov_point_total) then
				   self.m_mov_timer_ex = self.m_mov_timer_ex+delta_time;
				   if (self.m_mov_timer_ex>self.m_fish_by_configList[self.m_fish_mov_point_index].y) then self:MovToNextIndex();end
			  end
		end
		if (self.m_start_in_win_flag==true) then
			local  t_check_width = 500;
			if (self.fish_kind_< 9) then   t_check_width = 100;
			elseif (self.fish_kind_< 19) then t_check_width = 250; end
             local t_winSize_ =  cc.Director:getInstance():getWinSize() ;
			if (self.m_mov_position.x<-t_check_width
                or  self.m_mov_position.x>(t_winSize_.width + t_check_width)
                or self.m_mov_position.y<-t_check_width
                or self.m_mov_position.y>(t_winSize_.height + t_check_width))
                 then                return true; end
		else
          local t_winSize_ =  cc.Director:getInstance():getWinSize() ;
           --cclog(" Fish:Mov_by_List return true m_mov_position(%f,%f) t_winSize_(%f,%f)",self.m_mov_position.x,self.m_mov_position.y,t_winSize_.width,t_winSize_.height);
			if (
            self.m_mov_position.x>0
            and self.m_mov_position.x < t_winSize_.width
            and self.m_mov_position.y>0
            and self.m_mov_position.y < t_winSize_.height)
             then 	  self.m_start_in_win_flag = true;
            elseif(self.m_mov_position.x> (t_winSize_.width+1200)
            and self.m_mov_position.x < -1200
            and self.m_mov_position.y>(t_winSize_.height+1200)
            and self.m_mov_position.y < -1200) then return true;  end
         end
        return false;
end
function Fish:setFish_scene_trace(kind,index)
   self.scene_mov_trace_flag=1;
   self.scene_kind_index=kind;
   self.scene_Index=index;
end
function   Fish:setFish_mov_trace(mov_trace)
      self.trace_index_=0;
      self.m_mov_timer=0;
      self.trace_vector_=mov_trace;
end
function  Fish:OnFrame(delta_time)
  -- if(delta_time>0.04) then delta_time=0.04; end;
   --cclog(" Fish:OnFrame dt=%f",dt);
     if (self.m_moveKind == 0) then
         self.alive_timer= self.alive_timer+delta_time;
         if( self.alive_timer>90) then return true; end
      end
   if (self.active_==0) then return false;end
   if (self.fish_status_ == 0) then
   	    self.trace_index_ = 0;
	    self.m_nFishDieCount=0;
		self.fish_status_ = 1;
        if (self.m_moveKind == 0) then
             local fish_trace = self.trace_vector_[self.trace_index_];
             self.m_mov_position=cc.p(fish_trace[1], fish_trace[2]);
             self.fis_node:setPosition(cc.p(fish_trace[1], fish_trace[2]));
             self.fis_node:setVisible(true);
        end
        --self.fis_node:setVisible(t);
   end
   if (self.fish_status_ == 1)  then
       self.alive_limi_time=self.alive_limi_time+delta_time;
       if(self.alive_limi_time>70) then return  true end;
       if (self.m_mov_delay_timer > 0.0001) then
			self.m_mov_delay_timer=self.m_mov_delay_timer-delta_time;
			return false;
		end
         self:ChainLindFishUpdate(delta_time);
         if (self.m_connect_Stop_Flag == 0) then
             --按原路径移动
              if (self.m_moveKind < 2) then
                self.check_timer=self.check_timer+delta_time;
                if(  self.check_timer>0.15) then
                 self.check_timer=0;
				  self:CheckValid();
                end
                 self.m_mov_timer= self.m_mov_timer+delta_time;-- end
                 if ( self.m_mov_timer > 0.0333) then
                     local  Mov_Step =1
                     self.m_mov_timer = self.m_mov_timer -0.0333
                      if (self.m_mov_timer > 0.0333) then
                           self.m_mov_timer = 0;
                      end
                     if (self.stop_count_ > 0 and  self.trace_index_ == self.stop_index_ and self.current_stop_count_ < self.stop_count_) then
						      self.current_stop_count_ = self.current_stop_count_+Mov_Step;
						     if (self.current_stop_count_ >= self.stop_count_) then self:SetFishStop(0, 0);end
                       elseif (self.m_fish_mov_by_actionFlag == 0) then
                            self.trace_index_ = self.trace_index_ +Mov_Step;
						    if (self.trace_index_ >= #self.trace_vector_-2)  then return true;
                            else
							    local  fish_trace = self.trace_vector_[self.trace_index_];
                                local  t_mov_angle=0;
                                if(fish_trace[3]) then t_mov_angle=fish_trace[3]; end
                                t_mov_angle=t_mov_angle*0.01745329;
							    self.show_angle = t_mov_angle - self.baseAngle;
						    	self.m_fish_Check_Angle = self.show_angle;
						     	if (self.fis_node) then
							        	local rotation = self.show_angle*57.29577951308
					                   self.fis_node:setRotation(rotation)
					                   self.fis_node:setPosition(cc.p(fish_trace[1], fish_trace[2]))
                                       self.m_mov_position=cc.p(fish_trace[1], fish_trace[2]);
								       --if (self.fis_node:isVisible()==false) then self.fis_node:setVisible(true); end
							end--if (self.fis_node) then
						  end--if (self.trace_index_ >= #self.trace_vector_)  then return true;
					    end --   elseif (self.m_fish_mov_by_actionFlag == 0) then
					end  -- if ( self.m_mov_timer > 0.0333) then
              else   -- if (self.m_moveKind >2) then
               if(self.scene_fish_flag==0) then
                  if(self.alive_limi_time>30) then return  true end;
               else
                  if(self.alive_limi_time>60) then return  true end;
               end
               if(self:Mov_by_List(delta_time)==true) then return  true ;end  --新的路径移动
              end
         end
   else
       --if(self.alive_limi_time>20) then return  true end;
       if (self.m_fish_die_action_EndFlag>0) then return true; end
		self.m_mov_timer=self.m_mov_timer+delta_time;
		if(self.m_mov_timer>0.033) then --30fps
			self.m_mov_timer=self.m_mov_timer-0.033;
			self.m_nFishDieCount=self.m_nFishDieCount+1;
			if(self.m_nFishDieCount>180) then return true; end
		end
   end
   return false;
end
function   Fish:InsideScreen( x, y)
	local winSize     = cc.Director:getInstance():getWinSize();
	if (x > 0.0 and x < winSize.width and  y > 0.0 and y < winSize.height) then return true; end
	return false;
end
function  Fish:GetCurPos()
    local x,y=0,0;
    local winSize= cc.Director:getInstance():getWinSize();
	--if (self.fis_node) then x,y = self.fis_node:getPosition(); end
    x=self.m_mov_position.x;
    y=self.m_mov_position.y;
    if (x > 0.0 and x < winSize.width and  y > 0.0 and y < winSize.height) then return cc.p(x,y),true; end --屏幕内
    local pos = cc.p(x,y);
    local headPos = pos;
	local TrailPos = pos;
    if(self.fish_kind_<10) then return pos,false;
	else
         local sin_t= math.sin(self.m_fish_Check_Angle);
         local cos_t= math.cos(self.m_fish_Check_Angle);
		 headPos.x=headPos.x+self.bounding_box_width_*cos_t*0.35;
	     headPos.y=headPos.y+self.bounding_box_width_*sin_t*0.35;
          if (headPos.x > 0.0 and headPos.x < winSize.width and  headPos.y > 0.0 and headPos.y < winSize.height) then return headPos,true; end --屏幕内
         TrailPos.x=TrailPos.x-self.bounding_box_width_*cos_t*0.65;
	     TrailPos.y=TrailPos.y-self.bounding_box_width_*sin_t*0.65;
          if (TrailPos.x > 0.0 and TrailPos.x < winSize.width and  TrailPos.y > 0.0 and TrailPos.y < winSize.height) then return TrailPos,true; end --屏幕内
	end
	return pos,false;
end
function  Fish:GetFishPos()
    -- local x,y=0,0;
    -- if (self.fis_node) then x,y = self.fis_node:getPosition(); end
     return cc.p(self.m_mov_position.x,self.m_mov_position.y);
end
function Fish:GetFish_NodePos()
	 -- local x,y=0,0;
     --if (self.fis_node) then x,y = self.fis_node:getPosition(); end
     return cc.p(self.m_mov_position.x,self.m_mov_position.y);
end
function  Fish:CheckValidForLock()
    if (self.active_==false) then return false;end
	--if (self.valid_==false)  then return false;end
	if (self.m_no_catch_flag>0) then return false; end
	if (self.fish_status_~= 1) then  return false; end

   local x,y=0,0;
    local winSize     = cc.Director:getInstance():getWinSize();
    x=self.m_mov_position.x;
    y=self.m_mov_position.y;
    if (x > -10.0 and x < winSize.width and  y > -10.0 and y < winSize.height) then return true; end --屏幕内

    local pos = cc.p(x,y);
    local headPos = pos;
	local TrailPos = pos;
    if(self.fish_kind_<14) then return false;
	else
         local sin_t= math.sin(self.m_fish_Check_Angle);
         local cos_t= math.cos(self.m_fish_Check_Angle);
		 headPos.x=headPos.x+self.bounding_box_width_*cos_t*0.35;
	     headPos.y=headPos.y+self.bounding_box_width_*sin_t*0.35;
          if (headPos.x > 0.0 and headPos.x < winSize.width and  headPos.y > 0.0 and headPos.y < winSize.height) then return true; end --屏幕内
         TrailPos.x=TrailPos.x-self.bounding_box_width_*cos_t*0.65;
	     TrailPos.y=TrailPos.y-self.bounding_box_width_*sin_t*0.65;
          if (TrailPos.x > 0.0 and TrailPos.x < winSize.width and  TrailPos.y > 0.0 and TrailPos.y < winSize.height) then return true; end --屏幕内
	end
    --]]
	return false;
end
function Fish:GetFishccpPos() --获得可锁定位置
    local x,y=0,0;
    local winSize     = cc.Director:getInstance():getWinSize();
	--if (self.fis_node) then x,y = self.fis_node:getPosition(); end
    x=self.m_mov_position.x;
    y=self.m_mov_position.y;
    if (x > 0.0 and x < winSize.width and  y > 0.0 and y < winSize.height) then return cc.p(x,y); end --屏幕内
    local pos = cc.p(x,y);
    local headPos = pos;
	local TrailPos = pos;
    if(self.fish_kind_<10) then return pos;
	else
         local sin_t= math.sin(self.m_fish_Check_Angle);
         local cos_t= math.cos(self.m_fish_Check_Angle);
		 headPos.x=headPos.x+self.bounding_box_width_*cos_t*0.35;
	     headPos.y=headPos.y+self.bounding_box_width_*sin_t*0.35;
          if (headPos.x > 0.0 and headPos.x < winSize.width and  headPos.y > 0.0 and headPos.y < winSize.height) then return headPos; end --屏幕内
         TrailPos.x=TrailPos.x-self.bounding_box_width_*cos_t*0.65;
	     TrailPos.y=TrailPos.y-self.bounding_box_width_*sin_t*0.65;
          if (TrailPos.x > 0.0 and TrailPos.x < winSize.width and  TrailPos.y > 0.0 and TrailPos.y < winSize.height) then return TrailPos; end --屏幕内
	end
	return pos;
end

function Fish:IfCanCatchQuick_Ex()
    local t_winsize=cc.Director:getInstance():getWinSize();
    if (self.fish_status_~= 1) then  return false; end
    --if (self.active_==false) then return false;end
	--if (self.valid_==false)  then return false;end 允许屏幕外碰撞
	if (self.m_no_catch_flag>0) then return false; end


    return true;
end
function Fish:IfCanCatchQuick()
   local t_winsize=cc.Director:getInstance():getWinSize();
    if (self.active_==false) then return false;end
	if (self.valid_==false)  then return false;end
	if (self.m_no_catch_flag>0) then return false; end
	if (self.fish_status_~= 1) then  return false; end
    local x,y= 0,0;--self.fis_node:getPosition();
    x=self.m_mov_position.x;
    y=self.m_mov_position.y;
	if (x > -30 and x < (t_winsize.width+30) and y>-30 and y < (t_winsize.height+30)) then return true; end
    return false;
end

function Fish:ComputeCollision(x,y,r)
  if(r<=0) then r=1; end  --半径检测最低精度1
   --cc.PhysicsBody:
  --大圆检测
   local c_disx=self.m_mov_position.x-x;
   local c_disy=self.m_mov_position.y-y;
   local c_dis=(c_disx*c_disx)+(c_disy*c_disy);--math.sqrt((c_disx*c_disx)+(c_disy*c_disy));--math.sqrt()
   c_dis= math.sqrt(c_dis);
   --if(c_dis<r) then  return true;  end
   c_dis=c_dis-r;
   if(c_dis>self.d_max) then return false;
   elseif(c_dis<self.d_min)   then  return true;  end

   --两头检测
    local headPos =cc.p(self.m_mov_position.x,self.m_mov_position.y);
	local TrailPos =cc.p(self.m_mov_position.x,self.m_mov_position.y);
    local sin_t= math.sin(self.m_fish_Check_Angle);
    local cos_t= math.cos(self.m_fish_Check_Angle);
    local t_check_r=self.d_min+r;
    t_check_r=t_check_r*t_check_r;
     headPos.x=headPos.x+self.bounding_box_width_*cos_t*0.35;
	 headPos.y=headPos.y+self.bounding_box_width_*sin_t*0.35;
     c_disx=headPos.x-x;
     c_disy=headPos.y-y;
     local c_dis=(c_disx*c_disx)+(c_disy*c_disy);
     if(c_dis<t_check_r)then return true; end
     TrailPos.x=TrailPos.x-self.bounding_box_width_*cos_t*0.65;
	 TrailPos.y=TrailPos.y-self.bounding_box_width_*sin_t*0.65;
      c_disx=headPos.x-x;
     c_disy=headPos.y-y;
     if(c_dis<t_check_r)   then return true; end
     --]]
    return false;
end
function Fish:BulletHitTest(bullet)
   --cclog("Fish:BulletHitTest00");
   if (self.active_==false) then return false; end
   --cclog("Fish:BulletHitTest01");
	if (self.valid_==false) then  return false; end
   -- cclog("Fish:BulletHitTest02");
	if (self.m_no_catch_flag>0) then return false;end
    --cclog("Fish:BulletHitTest03");
	if (self.fish_status_ ~=1) then  return false end;
    --cclog("Fish:BulletHitTest04");
    local _HitFlag=false;
    local t_lock_id=bullet:lock_fishid();
	if ( t_lock_id> 0 and  t_lock_id ~= self.fish_id_) then  return false; end
    local point = bullet:get_mov_pos();
	local fish_Pos =cc.p(self.m_mov_position.x,self.m_mov_position.y); --self:GetFish_NodePos();
    local dis_x= fish_Pos.x-point.x;
     local dis_y= fish_Pos.y-point.y;
    if (t_lock_id== fish_id_)--锁定碰撞
	then
		if ((dis_x*dis_x+dis_y*dis_y) < 2500) then return true; end
		return false;
	end
   -- local  box=BoundingBox.new(self.bounding_box_width_, self.bounding_box_height_, fish_Pos.x, fish_Pos.y, self.m_fish_Check_Angle);
    --if (box:ComputeCollision(point.x, point.y,1)) then _HitFlag=true; end
    if(self:ComputeCollision(point.x, point.y,1)) then _HitFlag=true; end
    return _HitFlag;
    --return false;--
end
function Fish:GetFish_Catch_Mul()
     return 0;
end

function Fish:NetHitTest(bullet)
	return self:BulletHitTest(bullet);
end

function Fish:touch_Catch_fish_test( touch_pos,  touch_r,  lock_fishid)
  return  self:ComputeCollision(touch_pos.x,touch_pos.y,touch_r);
end

function Fish:CatchFish( chair_id,  score,  bulet_mul,  fish_mul,  bomFlag)
--[[   cclog(" Fish::CatchFish(chair_id=%d, score=%d, bulet_mul=%d,  fish_mul=%d,  bomFlag=%d )self.fish_kind_=%d", chair_id, score, bulet_mul, fish_mul, bomFlag,self.fish_kind_);]]
    self.fis_node:removeChildByTag(7758258);
	self.m_catch_chairID = chair_id;
    self.alive_limi_time=0;
	self.m_catch_mul = fish_mul;
	self.m_catch_bullet_mul = bulet_mul;
	self.m_mov_timer = 0;
	self.m_catch_score = score;
    --cc.Node.setLocalZOrder
	self:setLocalZOrder(30);
	if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
	self.fish_status_ = 2;
	if (self.fish_kind_>16) then  cc.exports.g_soundManager:PlayGameEffect("HitBigFish");
	else  cc.exports.g_soundManager:PlayGameEffect("FishDieSound"); end
	 cc.exports.g_soundManager:PlayFishEffect(self.fish_kind_);
	--_local_info_type t__local_info_type = _local_info_array_[GAME_RUN_TYPE][chair_id];
    --手机可以考虑只是把常规动作加速
	if(self.fis_node)
	then
		self.fis_node:removeChildByTag(10086);
       if (self.fish_kind_ <=21) then 	self:CreateSmall_fishDeadEx(self.fish_kind_);	end
	end
end
function Fish:TouchHitTest( x, y)

	if (self.active_==false)  then return false; end
	--if (self.valid_==false)  then return false; end
	if (self.m_no_catch_flag>0) then return false; end --//无法捕捉
	if (self.fish_status_ ~= 1) then  return false; end
	local pos = self:GetFish_NodePos();
    --cc.phys
	--local  box=BoundingBox.new(self.bounding_box_width_, self.bounding_box_height_, pos.x, pos.y, self.m_fish_Check_Angle);
	--if (box.ComputeCollision(x, y)) then return true;end
     --if(self:ComputeCollision(x, y,20)==true) then _HitFlag=true; end
	return self:ComputeCollision(x, y,20);--false;
end
-----------------------旋风鱼捕获----------------------
function Fish:xuanfengCatch( catch_pos,  chair_id,  mul)
    -- cclog("Fish:xuanfengCatch( catch_pos(%f,%f),  chair_id(%d),  mul(%d))........111.....",catch_pos.x,catch_pos.y,chair_id,mul);
	 cc.exports.g_soundManager:PlayGameEffect("SameKindFishDyingSound");
	if (self.m_no_catch_flag == 0) then
       self.fis_node:removeChildByTag(7758258);
		self:setLocalZOrder(100);
		self.m_no_catch_flag = 1;
		self.m_fish_mov_by_actionFlag = 1;
		self.m_xuanfeng_catch_score = mul*self.fish_multiple_;
		self.m_xuanfeng_catch_chair_id = chair_id;
	    local t_max_timer = 1.5;
		local speed = 1000.0/ t_max_timer;
        local t_dis_x= self.m_mov_position.x-catch_pos.x;
        local t_dis_y=self.m_mov_position.y-catch_pos.y;
	    local t_mov_timer = math.sqrt(t_dis_x*t_dis_x+t_dis_y*t_dis_y)/ speed;
		if (t_mov_timer > 2) then t_mov_timer = 2; end
		if (t_mov_timer > t_max_timer) then t_mov_timer = t_max_timer; end
		if (t_mov_timer < 0.3) then t_mov_timer = 0.3; end
		local moveTo = cc.MoveTo:create(t_mov_timer, catch_pos);
        self.m_mov_position.x=catch_pos.x;
         self.m_mov_position.y=catch_pos.y;
		self.fis_node:runAction(moveTo);
		self.m_moveKind = 1;
		self.m_fish_mov_by_actionFlag = 1;
		local t_spr = self.fis_node:getChildByTag(10086);
        -- cclog("Fish:xuanfengCatch( catch_pos(%f,%f),  chair_id(%d),  mul(%d))........22222.....",catch_pos.x,catch_pos.y,chair_id,mul);
		if (t_spr) then
				local rotateto = cc.RotateBy:create(2, 360);
				local repeatForever0 = cc.RepeatForever:create(rotateto);
				t_spr:runAction(repeatForever0);
	   end
	end
     --cclog("Fish:xuanfengCatch( catch_pos(%f,%f),  chair_id(%d),  mul(%d))........33333.....",catch_pos.x,catch_pos.y,chair_id,mul);
end
function  Fish:xuanfengActionEndCallBack()                    --动作结束回调
	self.fish_status_ = FISH_DIED;
	if (self.fis_node) then
		if (self.m_xuanfeng_catch_score> 0) then
             local t_ScoreAnimation=ScoreAnimation.new(self:GetFishccpPos(),self.fish_multiple_, self.m_catch_chairID, self.m_xuanfeng_catch_score);
             cc.exports.game_manager_:addChild(t_ScoreAnimation, 112);
		     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), self.m_catch_chairID, self.m_xuanfeng_catch_score, self.fish_multiple_);
		end
		--缩小  消失
		local scaleto = cc.ScaleBy:create(1, 0.01);
		local fadeout = cc.FadeOut:create(1);
		local rotateto = cc.RotateBy:create(1, 360);
		local spawn = cc.Spawn:create(scaleto, fadeout, rotateto, nil);
		self.fis_node:runAction(spawn);
	end
end
-----------------------------连环闪电------------------------------
function Fish:ChainLinkFishCatch( ChainLinkFishID, MovPos, mul, index)--   //闪电链捕获
    cclog("Fish:ChainLinkFishCatch ChainLinkFishID=%d, MovPos(%f,%f), mul=%d, index=%d",ChainLinkFishID, MovPos.x,MovPos.y, mul, index);
    self:setLocalZOrder(30);
	 cc.exports.g_soundManager:PlayGameEffect("NextChain");
    if (self.m_connect_start_Flag==0) then
        self.fis_node:removeChildByTag(7758258);
         self.m_connect_start_Flag = 1;
		 self.m_chainLink_main_id = ChainLinkFishID;
		 self.m_chainLink_Next_id=-1;
		 self.m_chainLink_Mul = mul;
		 self.m_chainLink_Index = index;
          local  tem_kind = self.fish_kind_;
		 if (tem_kind >=35 and tem_kind <= 39) then tem_kind = tem_kind-30;
		 elseif (tem_kind > 39 and tem_kind <= 49) then tem_kind = tem_kind-39;
		 elseif (tem_kind > 49 and tem_kind <= 59) then tem_kind = tem_kind-49; end
          cclog("Fish:ChainLinkFishCatch ChainLinkFishID=%d, MovPos(%f,%f), mul=%d, index=%daaaa",ChainLinkFishID, MovPos.x,MovPos.y, mul, index);
         if (self.fis_node) then
          cclog("Fish:ChainLinkFishCatch ChainLinkFishID=%d, MovPos(%f,%f), mul=%d, index=%d  bbbb",ChainLinkFishID, MovPos.x,MovPos.y, mul, index);
           local  tem_fish_width_max=self.bounding_box_width_;
            if(tem_fish_width_max<self.bounding_box_height_) then tem_fish_width_max=self.bounding_box_height_; end;
            local tem_bg_scale = tem_fish_width_max / 85.0;
            local file_name ="";
			local _sprite = nil;
			local readIndex = 0;
			local animation = cc.Animation:create();
            local i=0;

			for  i = 0,25,1 do
                file_name=string.format("~ChainShell_001_%03d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if (frame) then
						local offset_name=string.format("ChainShell_001_%03d.png", i);
						if (cc.exports.g_offsetmap_CL_pipeFlag<1) then
							local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	               t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;
                           frame:setOffsetInPixels(t_offset_);
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
                end
            end --for
            if (readIndex > 0)	then
               cc.exports.g_offsetmap_CL_pipeFlag=1;
			    animation:setDelayPerUnit(1/12.0);
				local action =cc.Animate:create(animation);
				_sprite:runAction(cc.RepeatForever:create(action));
			end
            _sprite:setScale(tem_bg_scale);
			self.fis_node:addChild(_sprite, 11, 99996);
            --添加数字和圆盘
            local t_FrontNode_ = cc.Node:create();
			if (t_FrontNode_) then
					local t_fish_id_t = cc.Sprite:createWithSpriteFrameName("~ChainFishId_000_000.png");
					if (t_fish_id_t) then t_FrontNode_:addChild(t_fish_id_t, -1); end
					local  tem_index = index + 1;
					if (tem_index < 10)then
						file_name= string.format("~ChainFishIdDigital_0%d.png", tem_index);
						local t_fish_id_t = cc.Sprite:createWithSpriteFrameName(file_name);
						if (t_fish_id_t) then t_FrontNode_:addChild(t_fish_id_t, 1); end
					else
						local  _head_num = (tem_index / 10) % 10;
						file_name=string.format("~ChainFishIdDigital_0%d.png", _head_num);
						local t_fish_id_1= cc.Sprite:createWithSpriteFrameName(file_name);
						if (t_fish_id_1)then
							t_FrontNode_:addChild(t_fish_id_1, 1);
							t_fish_id_1:setPosition(cc.p(-15, 0));
						end
						file_name=string.format("~ChainFishIdDigital_0%d.png", tem_index%10);
						local t_fish_id_2= cc.Sprite:createWithSpriteFrameName(file_name);
						if (t_fish_id_2)	then
							t_FrontNode_:addChild(t_fish_id_2, 1);
							t_fish_id_2:setPosition(cc.p(15, 0));
						end
					end--else
					self.fis_node:addChild(t_FrontNode_, 111, 99995);
			end --if (t_FrontNode_)
         end
    end -- if (self.m_connect_start_Flag==0) then
     cclog("Fish:ChainLinkFishCatch ChainLinkFishID=%d, MovPos(%f,%f), mul=%d, index=%d  ddddd",ChainLinkFishID, MovPos.x,MovPos.y, mul, index);
    --(旋转)移动到目标点
    local t_fish_spsr=self.fis_node:getChildByTag(10086);
    if (t_fish_spsr) then--旋转
			local rotateto =cc.RotateBy:create(2, 360);
			local repeatForever = cc.RepeatForever:create(rotateto);
			t_fish_spsr:runAction(repeatForever);
	end
    local function L_callback_()
       self:ChainLinkFishActionEndCallBack();
   end
    local  dx=self.m_mov_position.x-MovPos.x;
    local dy=self.m_mov_position.y-MovPos.y;
	local t_dis_length =math.sqrt(dx*dx+dy*dy); --self.getDistance(MovPos);
	local t_mov_timer = t_dis_length / 300.0;
	if (t_mov_timer < 1.0)then t_mov_timer = 1.0; end
	local moveBy = cc.MoveTo:create(t_mov_timer, MovPos);
	local funcall = cc.CallFunc:create(L_callback_);
	local seq = cc.Sequence:create(moveBy, funcall, nil);
     cclog("Fish:ChainLinkFishCatch ChainLinkFishID=%d, MovPos(%f,%f), mul=%d, index=%d  eeee",ChainLinkFishID, MovPos.x,MovPos.y, mul, index);
	self.fis_node:runAction(seq);
end
function Fish:ChainLinkFishCatchToNext(ChainLinkFishID, NextFishID)--  //捕获下一个

   cclog("Fish:ChainLinkFishCatchToNext(ChainLinkFishID=%d, NextFishID=%d)",ChainLinkFishID,NextFishID);
    cc.exports.g_soundManager:PlayGameEffect("ChainLinkStart");
	local t_ChainLinkFish =cc.exports.g_pFishGroup:GetFish(self.m_chainLink_main_id);
    self.m_chainLink_Next_id = NextFishID; --获取下个节点
    if (self.m_chainLink_Next_id >= 0) then
      local t_CCPoint = cc.p(0, 0);
      local file_name ="";
	  local _sprite = nil;
	  local readIndex = 0;
	 local animation = cc.Animation:create();
     local i=0;
	 for  i = 0,35, 1 do
         file_name=string.format("~ChainEff_000_%03d.png", i);
		local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
       if (frame) then
               local offset_name=string.format("ChainEff_000_%03d.png", i);
				if ( cc.exports.g_offset_ChainEff_Init<1) then
					local t_offset_ = cc.p(0, 0);
                    local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                    local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
                    local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                    local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                    local t_offeset_pos=cc.p(0,0);
                    local t_offset_0 = frame:getOffsetInPixels();
                    t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	        t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;
                    frame:setOffsetInPixels(t_offset_);
			 end
			 if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
			 readIndex=readIndex+1;
            animation:addSpriteFrame(frame);
       end
     end --end for --
     local function _l_endcallback()
       self:ChainLinkFishActionEndCallBack1();
     end
     if (readIndex > 0)	then
          cc.exports.g_offset_ChainEff_Init=1;
		 animation:setDelayPerUnit(1/12.0);
		_sprite:setOpacity(0);
		local action =cc.Animate:create(animation);
        local t_CCRepeat = cc.Repeat:create(action, 1);
        local funcall = cc.CallFunc:create(_l_endcallback);
        local  seq = cc.Sequence:create(t_CCRepeat, funcall, nil);
		_sprite:runAction(seq);
	end
	if (_sprite) then self:addChild(_sprite); end
    else  -- if (self.m_chainLink_Next_id >= 0) then
		self:removeChildByTag(99995);
		if (t_ChainLinkFish) then t_ChainLinkFish:End(); end
   end -- if (self.m_chainLink_Next_id >= 0) then
end
function  Fish:ChainLinkFishActionEndCallBack()--           ////移动到目标点动作结束回调
    cclog("Fish:ChainLinkFishActionEndCallBack");
	local t_ChainLinkFish = cc.exports.g_pFishGroup:GetFish(self.m_chainLink_main_id);
	if (t_ChainLinkFish)then
		 cc.exports.g_soundManager:PlayGameEffect("ChainEnd");
		t_ChainLinkFish:Goto_Next(self:fish_id());
	end
end
function  Fish:ChainLinkFishActionEndCallBack1()--          //更换播放特效结束动作结束回调
    cclog("Fish:ChainLinkFishActionEndCallBack1");
	if (cc.exports.g_pFishGroup and  self.fis_node)then
		self.fis_node:removeChildByTag(999998);
		self.fis_node:removeChildByTag(99995);
		local t_ChainLinkFish =cc.exports.g_pFishGroup:GetFish(self.m_chainLink_main_id);
        --cclog("Fish:ChainLinkFishActionEndCallBack100000000000000000");
		if (t_ChainLinkFish) then
            --cclog("Fish:ChainLinkFishActionEndCallBack11111111111111111111");
			local  t_next_fish_ID = t_ChainLinkFish:GetFishId(self.m_chainLink_Next_id);
			local t_Fish =cc.exports.g_pFishGroup:GetFish(t_next_fish_ID);
			if (t_Fish) then
              -- cclog("Fish:ChainLinkFishActionEndCallBacksssssssssssssssssssssssssss");
				self.m_connect_start_Flag = 2;
				local t_arm_fish_pos = t_Fish:GetFish_NodePos();
                local x,y=self.fis_node:getPosition();
                self.m_mov_position.x=x;
                self.m_mov_position.y=y;
                local dx=t_arm_fish_pos.x-x;
                 local dy=t_arm_fish_pos.y-y;
				self.m_connect_length_Max_S =  math.sqrt((dx*dx)+(dy*dy));
				self.m_connect_length_Max_S =self. m_connect_length_Max_S / 800;
				self.m_connect_length_index = 0;
		        --创建连接闪电精灵
               local file_name ="";
			   local _sprite = nil;
			   local readIndex = 0;
			   local animation = cc.Animation:create();
               local i=0;
			   for  i = 0,18, 1 do
                   file_name=string.format("~ChainRope_000_%03d.png", i);
				   local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				   if (frame) then
						local offset_name=string.format("ChainRope_000_%03d.png", i);
						if (cc.exports.g_offset_ChainRope_Init<1) then
							local t_offset_ = cc.p(0, 0);
                            local t_offect_str=cc.exports.OffsetPointMap[offset_name].Offset;
                            local t_s_sub_x,t_s_sub_y=string.find(t_offect_str,",");
                            local t_x=string.sub(t_offect_str, 0,t_s_sub_x-1);
                            local t_y=string.sub(t_offect_str, t_s_sub_y+1,#t_offect_str);
                            local t_offeset_pos=cc.p(0,0);
                            local t_offset_0 = frame:getOffsetInPixels();
                            t_offset_.x =t_x/2;--t_offset_.x * 10/ 20;
		 	               t_offset_.y = -t_y/2;--t_offset_.y * 10/ 20;
                           frame:setOffsetInPixels(t_offset_);
					end
					if (readIndex == 0)then 	_sprite=cc.Sprite:createWithSpriteFrameName(file_name) ;end
					readIndex=readIndex+1;
                   animation:addSpriteFrame(frame);
				end
            end
            if (readIndex > 0)	then
                --cclog("Fish:ChainLinkFishActionEndCallBack11111111111111111111readIndex=%d",readIndex);
                cc.exports.g_offset_ChainRope_Init=1;
			    animation:setDelayPerUnit(1/24.0);
				local action =cc.Animate:create(animation);
				_sprite:runAction(cc.RepeatForever:create(action));
                _sprite:setAnchorPoint(cc.p(0, 0.5));
				_sprite:setScaleY(0.4);
				_sprite:setScaleX(1);
				_sprite:setPosition(cc.p(self.m_mov_position.x,self.m_mov_position.y));
                self:addChild(_sprite,0, 999994);
			end
			local t_FrontNode_ = cc.Node:create();
			if (t_FrontNode_)	then
				   local t_fish_id_t = cc.Sprite:createWithSpriteFrameName("~ChainFishId_000_000.png");
				   if (t_fish_id_t) then  t_FrontNode_:addChild(t_fish_id_t, -1); end
			       file_name=string.format("~ChainFishIdDigital_0%d.png", (self.m_chainLink_Index + 2) % 10);
				  local  t_fish_id_t = cc.Sprite:createWithSpriteFrameName(file_name);
				  if (t_fish_id_t) then t_FrontNode_:addChild(t_fish_id_t, 1); end
                  local x,y=self.fis_node:getPosition();
			    	t_FrontNode_:setPosition(ccp(x,y));
			    	self:removeChildByTag(99995);
			    	self:addChild(t_FrontNode_, 111, 99995);
                    local function _call_back_()
                        self:ChainLinkFishActionEndCallBack2();
                    end
			    	--执行移动动作
				   local moveBy = cc.MoveTo:create(0.6, t_arm_fish_pos);
				   local  funcall = cc.CallFunc:create(_call_back_);
				   local  seq = cc.Sequence:create(moveBy, funcall, nil);
				   t_FrontNode_:runAction(seq);
				   t_Fish:ChainLinkFish_lockStop();--锁定
				end --if (t_FrontNode_)	then
			else		--if (t_Fish)
				self:removeChildByTag(99995);
				if (t_ChainLinkFish) then t_ChainLinkFish:End(); end
			end
		end --if (t_ChainLinkFish) then
	end
end
function  Fish:ChainLinkFishActionEndCallBack2()--           //闪电连接完成回调  以一个节点回收
    cclog("Fish:ChainLinkFishActionEndCallBack2");
    self.m_connect_start_Flag = 3;
	self:removeChildByTag(99995);
    --激活节点
	local t_ChainLinkFish =cc.exports.g_pFishGroup:GetFish(self.m_chainLink_main_id);
	local  t_next_fish_ID = t_ChainLinkFish:GetFishId(self.m_chainLink_Next_id);
	local  t_Fish =cc.exports.g_pFishGroup:GetFish(t_next_fish_ID);
	if (t_Fish  and t_ChainLinkFish) then
			local t_arm_fish_pos = t_Fish:GetFish_NodePos();
            local x,y= self.fis_node:getPosition();
			local t_end_pos =t_ChainLinkFish:GetNextPosition(self.m_chainLink_Next_id,cc.p(x,y), t_arm_fish_pos, self.fish_kind_, t_Fish:fish_kind());
			self.m_chainLink_Next_pos = t_end_pos;
             local t_FrontNode_ = cc.Node:create();
             if(t_FrontNode_) then --执行回收动作
                      local  dx=t_arm_fish_pos.x-t_end_pos.x;
                      local dy=t_arm_fish_pos.y-t_end_pos.y;
	                  local t_dis_length =math.sqrt(dx*dx+dy*dy); --self.getDistance(MovPos);
	                  local t_mov_timer = t_dis_length / 300.0;
                      if (t_mov_timer < 1.0)then t_mov_timer = 1.0; end
                      local function _mov_back_callback()
                          self:removeChildByTag(99995);
                          self.m_connect_start_Flag = 4;
                      end
                      t_FrontNode_:setPosition(cc.p(t_arm_fish_pos.x,t_arm_fish_pos.y))
                      local t_move_to=cc.MoveTo:create(t_mov_timer,cc.p(t_end_pos.x,t_end_pos.y));
                       local  funcall = cc.CallFunc:create(_mov_back_callback);
				       local  seq = cc.Sequence:create(t_move_to, funcall, nil);
                        t_FrontNode_:runAction(seq);
                       self:addChild(t_FrontNode_, 111, 99995);
             end
             --]]
            --cclog("Fish:ChainLinkFishActionEndCallBack2 t_end_pos(%f,%f)-------------------------------------------------------------------- ",t_end_pos.x,t_end_pos.y);
			--激活下个节点
			t_Fish:ChainLinkFishCatch(self.m_chainLink_main_id, t_end_pos, self.m_chainLink_Mul, self.m_chainLink_Index+1);
            local dx=t_arm_fish_pos.x-x;
            local dy=t_arm_fish_pos.y-y;
			self.m_connect_length_Max_S = math.sqrt((dx*dx)+(dy*dy));   --t_arm_fish_pos.getDistance(self.fis_node:getPosition());
			self.m_connect_length_Max_S =self.m_connect_length_Max_S / 800;
	else
			self:removeChildByTag(99995);
			if (t_ChainLinkFish) then t_ChainLinkFish:End(); end
	end
end
function Fish:ChainLindFishUpdate(dt)
	if (self.m_connect_start_Flag>1) then
        local t_sp1_=self:getChildByTag(99995);
        local t_sp2_=self:getChildByTag(999994);
		if (self.m_connect_start_Flag == 2) then --链接
			if (t_sp1_)	then
				if (t_sp2_)then
                    local x,y=t_sp1_:getPosition();
                    local x1,y1=t_sp2_:getPosition();
					local  t_mov_pos =cc.p(x,y);-- t_sp1_:getPosition();
					local  t_start_pos =cc.p(x1,y1);-- t_sp2_:getPosition();
					local   t_rot_angle = self:mm_getAngle(t_start_pos, t_mov_pos);
                    x=x-x1;
                    y=y-y1;
					local  t_end_dis_num =  math.sqrt(x*x+y*y);---- t_start_pos.getDistance(t_mov_pos);
					t_sp2_:setScaleX(t_end_dis_num / 800);
					t_sp2_:setRotation(t_rot_angle-90);
				end		--if (t_sp2_)then
			end	        --if (t_sp1_)	then
		elseif (self.m_connect_start_Flag == 3) then --链接回收
            --cclog("elseif (self.m_connect_start_Flag == 3) then00  ");
			local t_ChainLinkFish =cc.exports.g_pFishGroup:GetFish(self.m_chainLink_main_id);
			if (t_ChainLinkFish) then
               -- cclog("elseif (self.m_connect_start_Flag == 3) then01  ");
				local  t_next_fish_ID = t_ChainLinkFish:GetFishId(self.m_chainLink_Next_id);
				local t_Fish =cc.exports.g_pFishGroup:GetFish(t_next_fish_ID);
				if (t_Fish) then
                   -- cclog("elseif (self.m_connect_start_Flag == 3) then02 ");
                    local x,y=self.fis_node:getPosition();
					local t_arm_fish_pos = t_Fish:GetFish_NodePos();
					local t_end_pos = self.m_chainLink_Next_pos;
                    local dx=t_end_pos.x-x;
                    local dy=t_end_pos.y-y;
					local t_end_dis_num = math.sqrt((dx*dx)+(dy*dy)); --t_end_pos.getDistance(t_arm_fish_pos);
                     dx=t_arm_fish_pos.x-x;
                     dy=t_arm_fish_pos.y-y;
					self.m_connect_length_index =math.sqrt((dx*dx)+(dy*dy)) --t_arm_fish_pos.getDistance();
					self.m_connect_length_index = self.m_connect_length_index / 800;
					if (t_end_dis_num > -2.0 and t_end_dis_num < 2.0)then self.m_connect_start_Flag = 4;end
                    local t_sp2_=self:getChildByTag(999994);
					if (t_sp2_)then t_sp2_:setScaleX(self.m_connect_length_index);	end
				end --if (t_Fish) then
			end   --if (t_ChainLinkFish) then  --]]
		 else--移除闪电
			self.m_connect_start_Flag = 0;
			self:removeChildByTag(999994);
		end
	end
end
function Fish:ChainLindFishExplor( score,  chair_id,  bulet_mul,  fish_mul)--                                   //引爆
   cclog("Fish:ChainLindFishExplor( score,  chair_id,  bulet_mul,  fish_mul)引爆");
--更新位置信息
   local x,y=self.fis_node:getPosition();
   self.m_mov_position.x=x;
   self.m_mov_position.y=y;
   if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
	local  t_score = bulet_mul*self:get_fish_mulriple();
	self:CatchFish(chair_id, t_score, bulet_mul, self:get_fish_mulriple(),1);
end
function  Fish:ChainLinkFish_lock() self.m_no_catch_flag = 2;  self.fis_node:removeChildByTag(7758258);end;--//闪电预订
function  Fish:ChainLinkFish_lockStop() self. m_connect_Stop_Flag = 1; self.fis_node:removeChildByTag(7758258);end ;--//闪电订制
return Fish;
--endregion
--region NewFile_1.lua
--Author : Administrator
--Date   : 2017/8/7
--此文件由[BabeLua]插件自动生成
local Fish = class("Fish",
 function()
	return cc.Node:create()
end
)

function Fish:ctor(cfish_kind, fish_id,fish_multiple,bounding_box_width,bounding_box_height,c_mov_list,c_mov_point_num,c_mov_speed,c_mov_delay)
     --cclog("function Fish:ctor cfish_kind=%d",cfish_kind);
	 self:Init();
     local t_fish_kind=cfish_kind;
     if(cfish_kind >= 30 and cfish_kind <= 39)then 
			t_fish_kind = cfish_kind - 30;
	 end

     local  t_char=string.format("a%d",t_fish_kind);
     local t_animal_data={};
     t_animal_data=cc.exports.g_animal_data[t_char];
     if(t_animal_data==nil)then return ; end
     local  t_Animal_scale =  t_animal_data["scale"];
	 local  t_Animal_angle =  t_animal_data["baseAngle"];
	 local  t_tex_width =     t_animal_data["RectWidth"];
	 local  t_tex_Height =    t_animal_data["RectHeight"];
	 --t_tex_width = t_tex_width*t_Animal_scale;
	 --t_tex_Height = t_tex_Height*t_Animal_scale;
     self.fish_kind_ = cfish_kind;
	 self.fish_id_ = fish_id;
     self.catch_mul=fish_multiple;
	 self.fish_multiple_ = fish_multiple;
	 self.bounding_box_width_ = t_tex_width;
	 self.bounding_box_height_ = t_tex_Height;
	 self.m_mov_Speed = game_fish_movSpeed[self.fish_kind_];
	 self.m_mov_delay = c_mov_delay;
	 self.m_mov_point_num = c_mov_point_num;
     self.m_mov_list=c_mov_list;
     self.m_Alive_Step =0;
     self.hit_radius_ = bounding_box_width;
	 if (self.hit_radius_ < bounding_box_height) then self.hit_radius_ = bounding_box_height; end
      --cclog("function Fish:ctor 1");
     self.fis_node = cc.Sprite:createWithSpriteFrameName("fish_empty.png");
	 self.fis_node:setScale(t_Animal_scale);
	 self.fis_node:setPosition(self.m_mov_list[0]);
     self.fis_node:setVisible(false);
	 self.m_last_ZNum =144-self.m_mov_list[0].y/5;
     self:addChild(self.fis_node,  self.m_last_ZNum, fish_id);
      --cclog("function Fish:ctor 2");
	 --
     self.m_mov_start_pos = self.m_mov_list[0];
	 self.m_mov_pos_ = self.m_mov_start_pos;
     self.m_pic_angle = t_Animal_angle;
      --cclog("function Fish:ctor 3");
     self:MovTo_Next();
      --cclog("function Fish:ctor 4");
     self:PlayWalkAction(10086);		

     --
     local fish_body_node_=cc.Node:create();
     local body = cc.PhysicsBody:createBox(cc.size(self.bounding_box_width_, self.bounding_box_height_));
     body:setGroup(2);
     body:setDynamic(false);
     body:setGravityEnable(false);
     body:setContactTestBitmask(1);
     fish_body_node_:setPhysicsBody(body);
     self.fis_node:addChild(fish_body_node_,0,7758258);
  
     local function handler()
        self:OnFrame(0.02,0)
       -- self:update(1/60);
     end
    
   
     local delay=cc.DelayTime:create(0.02);
     local call_func=cc.CallFunc:create(handler);
     local t_seq=cc.Sequence:create(delay,call_func,nil);
     local t_repeat=cc.RepeatForever:create(t_seq);
     self:runAction(t_repeat);
     

     --]]
     
--      self:scheduleUpdateWithPriorityLua(
--        function(dt)
--          self:OnFrame(dt,0)
--        end,0
--    )
    --]]
    -- self.update_func_=handler;
    -- self:scheduleUpdateWithPriorityLua(handler,0);--1/60.0);
   --self._scheduleId__=cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler, 1/60, false);
     --cclog("function Fish:ctor cfish_kind=%d   end",cfish_kind);
    -- cc.Director:getInstance():getScheduler():unscheduleScriptEntry(callbackEntry)
    --cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self._scheduleId__)
end;

function Fish:onExit()    
     if(self.scheduleId~=nil) then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId)   -- 取消定时器
     end
     self.scheduleId=nil;
end
--]]

function Fish:update(dt)
  -- self:OnFrame(dt, 0);
end
function Fish:exit_self()
  -- cclog("Fish:exit_self()");
   --if(self.scheduleId~=nil) then 
     -- cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduleId)   -- 取消定时器
    --  self.scheduleId=nil;
   --end
   --self:removeAllChildren();
   if(cc.exports.g_pFishGroup~=nil) then 
      cc.exports.g_pFishGroup:FreeFish(self);
   end
  
  --cclog("Fish:exit_self() end");
end
 function Fish:fish_status()
   return self.fish_status_ ;
 end

 function Fish:fish_kind()
 return self.fish_kind_;
 end
function Fish:fish_id()
   return self.fish_id_;
end
function Fish:mm_getAngle(beginPoint,endPoint)

	local len_y = endPoint.y - beginPoint.y;
	local len_x = endPoint.x - beginPoint.x;
	if (len_y >= -0.001 and len_y <= 0.001) then 	
		if (len_x < 0) then return 270;
		elseif(len_x > 0) then return 90; end		
		return 0;
	end
	if (len_x >= -0.001 and len_x <= 0.001) then 
		if (len_y >= 0) then 		
			return 0;
		elseif (len_y < 0) then return 180; end
        return 0;
	end
	return  math.atan2(len_x, len_y)*57.29578;
end

function Fish:Init()
	self.m_mov_delay=0;    --//移动延迟
	self.m_mov_Speed=0;   --//移动速度
	self.m_mov_list={[0]=cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0),cc.p(0,0)};
	self.m_mov_point_num=0;
	self.m_Alive_Step=0;
    self.m_Alive_Step =0;
	self.m_mov_index=0;
	self.m_mov_start_pos=cc.p(0,0);
	self.m_mov_pos_=cc.p(0,0);
	self.m_mov_dis=0;
	self.m_mov_dis_max=0;
	self.m_mov_sin_f=0;
	self.m_mov_cos_f=0;
	self.m_king_catch_delay=0;
	self.m_king_catch_score=0;
	self.m_king_catch_chair_id=0;
    self.m_miss_state=0;           --//逃脱状态
	self.m_miss_kind=0;            --//逃脱类型
	self.m_miss_timeLength=0;      --//逃脱时间
	self.m_miss_timer=0;           --//逃脱定时器
	self.m_miss_Data=0;            --//逃脱中介数据
    self.m_mov_direct_=0;
	self.m_fish_Check_Angle=0;
	self.fish_kind_=0;
	self.valid_=false;
	self.m_no_catch_flag=0;
	self.m_flip_l=0;
	self.fish_status_=0;

	self.fish_id_=0;
	self.m_if_have_tick=0;--//是否携带彩票
	self.fish_multiple_=0;
	self.m_nFishDieCount=0;
	self.bounding_box_width_=0;
	self.bounding_box_height_=0;
	self.hit_radius_=0;
	self.baseAngle=0;         --//基本角度 直接写死在客户端
	self.m_pic_angle=0;
	self.show_angle=0;
	self.m_last_ZNum=0;
    self.fis_node=nil;
    self.m_mov_timer=0;--//移动更新
end;

function Fish:MovTo_Next()
    --cclog("Fish:MovTo_Next()...........");
	self.m_mov_index=self.m_mov_index+1;
	if(self.m_mov_index<self.m_mov_point_num) then 
        local px,py=self.fis_node:getPosition();
		self.m_mov_start_pos =cc.p(px,py);-- self.fis_node:getPosition();
		local t_dis_x = self.m_mov_list[self.m_mov_index].x - self.m_mov_start_pos.x;
		local t_dis_y = self.m_mov_list[self.m_mov_index].y - self.m_mov_start_pos.y;
		local temp_angle = math.atan2(t_dis_x, t_dis_y);
        local t_flip_flag__ = 0;		
		self.m_mov_sin_f = math.sin(temp_angle);
		self.m_mov_cos_f = math.cos(temp_angle);
		self.m_mov_pos_ = self.m_mov_start_pos;
		self.m_mov_dis=0;
		self.m_mov_dis_max = math.sqrt((t_dis_x*t_dis_x) + (t_dis_y*t_dis_y));
		local t_fish_kind =  self.fish_kind_;
		if (t_fish_kind >= 30 and t_fish_kind <= 39) then t_fish_kind = t_fish_kind - FISH_KIND_31;end
		local t_mov_angle = math.atan2(t_dis_x, t_dis_y)*180.0 / 3.1415926;
		if (g_animal_direct_num[t_fish_kind] >2)then 
			t_dir_num__ = self:check_dir(t_mov_angle);
		   if (t_dir_num__ ~= self.m_mov_direct_) then self:changeDirect(t_dir_num__); end
		end		
        --cclog("  Fish:MovTo_Next()t_dis_x=%f  t_dis_y=%f",t_dis_x,t_dis_y);		
		if (t_dis_x > 0.0001) then 		
                --cclog("  Fish:MovTo_Next()  111111111111");				
				t_flip_flag__ = 1;
				if (self.m_pic_angle > 90) then t_flip_flag__ = 0; end
		elseif(t_dis_x < -0.0001) then 	
                --cclog("  Fish:MovTo_Next()  222222222222");			
				t_flip_flag__ = 0;
				if (self.m_pic_angle > 90) then t_flip_flag__ = 1; end
		end
	    local aliveSpr =self.fis_node:getChildByTag(10086);
	    if (aliveSpr~=nil) then 	
            --cclog("  Fish:MovTo_Next()  111111111111");	
             -- cclog("  Fish:MovTo_Next()self.m_pic_angle=%f t_dis_x=%f  t_dis_y=%f,t_flip_flag=%d(%d)",self.m_pic_angle,t_dis_x,t_dis_y,t_flip_flag__,self.m_flip_l);	
			if (t_flip_flag__~=self.m_flip_l) then 
                   -- cclog("  Fish:MovTo_Next() 22222222");		                  
					self.m_flip_l = t_flip_flag__;
                    if(self.m_flip_l>0) then 			
                        --cclog("  Fish:MovTo_Next() if(self.m_flip_l>0) then 	");	
						aliveSpr:setFlippedX(true);
						aliveSpr:setAnchorPoint(cc.p(1 -cc.exports.g_fish_offic_x[t_fish_kind], cc.exports.g_fish_offic_y[t_fish_kind]));		
					else	
                         -- cclog("  Fish:MovTo_Next() if(self.m_flip_l<=0) then 	");						
						aliveSpr:setFlippedX(false);
						aliveSpr:setAnchorPoint(cc.p(cc.exports.g_fish_offic_x[t_fish_kind], cc.exports.g_fish_offic_y[t_fish_kind]));
					end
				end
		end		--if (aliveSpr~=nil) then
        if (self.fis_node)then 
			  self.fis_node:setPosition(self.m_mov_pos_);
			  self:AddKind_Effect();
	    end
		return 1;
	else
         local x,y=self.fis_node:getPosition();
		self.m_mov_start_pos =cc.p(x,y)--//一直向前走
		self.m_mov_pos_ = self.m_mov_start_pos;
		self.m_mov_dis = 0;
		self.m_mov_dis_max = 2000;
		return 1;
	end

end

function Fish:CheckValidForLock()
	if(self.fis_node and self.fish_status_==1) then 
        local x,y=self.fis_node:getPosition();
        local t_pos_=cc.p(x,y); --//一直向前走
        if(t_pos_.x>0 and t_pos_.y>0 and t_pos_.x<1280 and t_pos_.y<720) then 
	 	return true;
        end
    end
	return false;
end

function Fish:King_catch(cchair_id, score)              --//被同类炸弹捕获
	if (self:IfCanCatchQuick(0) == false) then  cc.p(0, 0); end
	self.m_no_catch_flag = 1;
	self.m_king_catch_delay=0;
	self.m_king_catch_score = score;
	self.m_king_catch_chair_id = cchair_id;
	self:setLocalZOrder(1000);--//上浮
	local t_kind = self.fish_kind_;
	if(self.fish_kind_ >= 30 and self.fish_kind_ <= 39)  then  t_kind = self.fish_kind_ - 30; end
	local t_base = cc.Sprite:create("qj_animal/res/game_res/Animal/kingcatch_base.png");
	if (t_base) then 		
		t_base:setPosition(kind_effect_pos[t_kind]);
		t_base:setScale(kind_effect_scale[t_kind] or 1);
		self.fis_node:addChild(t_base, -12,775825);
	end	
    local x,y=self.fis_node:getPosition();	
	return cc.p(x,y);
end
function Fish:KingCatchFish()
 
	if(self.fish_status_ ==1) then
		self:CatchFish(self.m_king_catch_chair_id, self.m_king_catch_score,0,0);
	end
end
function Fish:active()
  if(self.fish_status_==1) then return true;
  else return false; end
end
function Fish:IfCanCatchQuick( enge_check)
    -- cclog("Fish:IfCanCatchQuick( enge_check)00");
	if(self.fish_status_ ~= 1)  then return false; end
    -- cclog("Fish:IfCanCatchQuick( enge_check)01");
	if (self.valid_==false) then return false; end
    -- cclog("Fish:IfCanCatchQuick( enge_check)02");
	if (self.m_no_catch_flag>0) then return false; end
    -- cclog("Fish:IfCanCatchQuick( enge_check)03");
	if(enge_check~=nil and enge_check>0)then 
    	local  t_winsize =cc.Director:getInstance():getWinSize();--:sharedDirector()->getWinSize();
        local px,py= self.fis_node:getPosition();
		local t_pos =cc.p(px,py);
		if (t_pos.x > 10 and t_pos.x < (t_winsize.width + 10) and t_pos.y>10 and t_pos.y < (t_winsize.height + 10)) then return true; end
		return false;
	end
    -- cclog("Fish:IfCanCatchQuick( enge_check)04");
	return true;
end
function  Fish:GetCurPos()
  local x,y=self.fis_node:getPosition();
  return  cc.p(x,y);
end
function Fish:GetFishccpPos()
   local x,y=self.fis_node:getPosition();
  return  cc.p(x,y);
 end
function Fish:CheckValid()
	local t_angle=self.show_angle;
    local x,y=self.fis_node:getPosition();
	local t_winSize = cc.Director:getInstance():getWinSize();--::sharedDirector()->getWinSize();
	t_winSize.width = t_winSize.width + 100;
	t_winSize.height = t_winSize.height + 100; 
    if(x>-100 and x<t_winSize.width and y>-100 and y<t_winSize.height)
	  then  self.valid_ = true;
	  else  self.valid_ = false;
    end
	return self.valid_;
end
function Fish:OnFrame(delta_time, lock) 

   -- cclog("Fish:OnFrame(fish_status_=%d, lock)",self.fish_status_);
   -- delta_time=cc.Director:getInstance():getDeltaTime();
    --if(delta_time>0.04) then delta_time=0.04; end;
	if (self.fish_status_== 0) then 	
		 self.m_nFishDieCount=0;
		self.fish_status_ = 1;
		self.fis_node:setPosition(cc.p(self.m_mov_list[0].x, self.m_mov_list[0].y));
		if (self.fis_node:isVisible()==false) then self.fis_node:setVisible(true); end
		self:CheckValid();
		return false;
	end
	if (self.fish_status_ == 1) 	then
		if(self.m_no_catch_flag>0) then 
		    self.m_king_catch_delay =self.m_king_catch_delay+delta_time;
			if (self.m_king_catch_delay > 10) then 		
				self:CatchFish(self.m_king_catch_chair_id,self.m_king_catch_score,0,0);
			end
			return false;
		end --if(self.m_no_catch_flag>0) then 
		local t_winSize =cc.Director:getInstance():getWinSize(); --cc.direcycc.Director:getWinSize();--::sharedDirector()->getWinSize();
        local x,y= self.fis_node:getPosition();
		local  t_pos =cc.p(x,y);
       -- cclog("function Fish:OnFrame(delta_time, lock) pos(%f,%f)-----",x,y);
		self:CheckValid();--//和屏幕碰撞半段	
		if (self.m_Alive_Step == 0) then --//只能一次进入屏幕	
			if (self.valid_==true) then  self.m_Alive_Step = 1; end
			if (t_pos.x<-1500 or t_pos.x>(t_winSize.width + 1500) or t_pos.y<-1500 or t_pos.y>(t_winSize.height + 1500)) then      
                self:exit_self();
                --cclog("function Fish:OnFrame(delta_time, lock) pos(%f,%f)---aaaaaaaaaaaaaa--",x,y);
                return true; 
             end	
		else		
			if(t_pos.x<-300 or t_pos.x>(t_winSize.width + 300) or t_pos.y<-300 or t_pos.y>(t_winSize.height + 300)) then 
                 self:exit_self();
                 --cclog("function Fish:OnFrame(delta_time, lock) pos(%f,%f)--bbbbbbbbbbb---",x,y);
                 return true;
             end
		end	
        --[[	
		if(self.m_miss_state>0) then 
			self.m_miss_timer = self.m_miss_timer+delta_time;
			if (self.m_miss_timer>self.m_miss_Data) then 		
				if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
				self.m_miss_state = 0;
			elseif(self.m_miss_timer < self.m_miss_timeLength) then 
					if (self.m_miss_kind == 0) then --//晕眩
						delta_time = 0;
						self.m_mov_timer = 0;	
					else
						delta_time = delta_time*5;
				    end
			 elseif (self.m_miss_state < 99) then self.m_miss_state = 99;
			  end
			end
		end
        --]]

		if (self.m_mov_delay > 0.0001) then		
			self.m_mov_delay =self.m_mov_delay- delta_time;
		else
			local t_mov_dis = self.m_mov_Speed * 30 * delta_time;			
			self.m_mov_dis =self.m_mov_dis+ t_mov_dis;
			if (self.m_mov_dis>self.m_mov_dis_max)then 
				if (self:MovTo_Next()<0)then           
                  self:exit_self();
                  return true;
                 end
			else			
				self.m_mov_pos_.x = self.m_mov_pos_.x+t_mov_dis*self.m_mov_sin_f;
				self.m_mov_pos_.y = self.m_mov_pos_.y+t_mov_dis*self.m_mov_cos_f;	   
				if (self.fis_node) then 				
					self.fis_node:setPosition(self.m_mov_pos_);
					local t_last_ZNum =  144-self.m_mov_pos_.y /5;
					if (t_last_ZNum ~= self.m_last_ZNum)then
						self:setLocalZOrder(t_last_ZNum);
						self.m_last_ZNum = t_last_ZNum;
					end
				end
				
			end
		end
	else 
		self.m_mov_timer=self.m_mov_timer+delta_time;
		if(self.m_mov_timer>0.0333334)then
			self.m_mov_timer=self.m_mov_timer-0.0333334;
			self.m_nFishDieCount=self.m_nFishDieCount+1;
			if(self.m_nFishDieCount>=50)	 then         
              self:exit_self();

              return true; 
             end
		end
	end
	return false;
end

function Fish:AddWin_Effect(local_chairID,score,end_pos)
    --("Fish:AddWin_Effect00 end_pos(%f,%f)",end_pos.x,end_pos.y);
	--//中奖名称显示
    local t_fish_kind = self.fish_kind_;
	if(self.fish_kind_ >= 30 and self.fish_kind_ <= 39)  then  t_kind = self.fish_kind_ - 30; end
	local file_name=string.format("a%d", t_fish_kind);

    --cclog(" Fish:AddWin_Effect file_name=%s",file_name);
    if(cc.exports.g_animal_data[file_name]==nil) then return ; end
    --[[
    local t_path=cc.exports.g_animal_data[file_name]["name_path"];   
	local t_Win_name =cc.Sprite:create(t_path);
	if(t_Win_name) then 	
        local x,y= self.fis_node:getPosition();
		local t_win_pos =cc.p(x,y);
        -- cclog("Fish:AddWin_Effect01a");
		cc.exports.game_manager_:addChild(t_Win_name,10000);
		t_Win_name:setPosition(t_win_pos);
		t_Win_name:setScale(0.01);
        -- cclog("Fish:AddWin_Effect01b");
		local fadein = cc.FadeIn:create(0.1);
		local jumpby = cc.JumpBy:create(0.2, cc.p(0, 30), 50, 1);
		local scaleto = cc.ScaleTo:create(0.2, 1);
        -- cclog("Fish:AddWin_Effect01bb");
		local spawn = cc.Spawn:create(fadein,jumpby, scaleto);
		--cclog("Fish:AddWin_Effect01c");
		local scaleto1 = cc.ScaleTo:create(0.08, 0.9);--缩小
		local scaleto2 = cc.ScaleTo:create(0.08, 1.1);--放大
		local seq1 = cc.Sequence:create(scaleto1, scaleto2, nil);
		local t_repeat = cc.Repeat:create(seq1, 2);
		
		local delaytime = cc.DelayTime:create(0.5);--//停顿 
		local fadeout = cc.FadeOut:create(0.2);    --              //消失
        local function removecall_back(args)
            t_Win_name:removeFromParent();
        end
        --cclog("Fish:AddWin_Effect01d");
		local funcall = cc.CallFunc:create(removecall_back);	
		local seq = cc.Sequence:create(spawn, t_repeat, delaytime,  fadeout, funcall, nil);
        --cclog("Fish:AddWin_Effect02");
		t_Win_name:runAction(seq);
        -- cclog("Fish:AddWin_Effect03");
	end
    --]]
     cc.exports.g_soundManager:PlayAnimalEffect(self.fish_kind_);
     cc.exports.g_CoinManager:BuildCoin(self:GetFishccpPos(), local_chairID, score, self.catch_mul);
    local t_ani_score_ = cc.LabelAtlas:_create(score, "qj_animal/res/game_res/Animal/win_num1.png", 54, 62,48);	
	if (t_ani_score_) then 
        local win_size=cc.Director:getInstance():getWinSize();
        local x,y=	self.fis_node:getPosition();
        if(x<40) then x=40; 
        elseif(x>(win_size.width-40)) then x=win_size.width-40; end
        if(y<70) then y=70; 
        elseif(y>(win_size.height-40)) then y=win_size.height-40; end 
		local t_win_pos =cc.p(x,y);     
		t_win_pos.y =t_win_pos.y -60;

		cc.exports.game_manager_:addChild(t_ani_score_, 10020);
        t_ani_score_:setAnchorPoint(cc.p(0.5,0.5));
		t_ani_score_:setPosition(t_win_pos);      
		local function org_remove()
           t_ani_score_:removeFromParent();
        end

		local fadein = cc.FadeIn:create(0.3);
		local jumpby = cc.JumpBy:create(0.2, cc.p(0, 30), 150, 1);
		local scaleto = cc.ScaleTo:create(1.0, 1);
		local spawn = cc.Spawn:create(jumpby, scaleto, fadein);
		
		local delaytime = cc.DelayTime:create(0.5);--//停顿 
		--local moveBy = cc.MoveTo:create(t_timer, end_pos);--//返回
		local fadeout = cc.FadeOut:create(0.2);                  -- //消失
		local funcall = cc.CallFunc:create(org_remove);
		local seq = cc.Sequence:create(spawn, delaytime, fadeout, funcall, nil);
		t_ani_score_:runAction(seq);
	end	
    --cclog("Fish:AddWin_Effect   end");
end

function Fish:CatchFish(chair_id,score,bulet_mul,fish_mul,bomFlag)
    --cclog(" Fish:CatchFish(chair_id=%d,score=%d,bulet_mul=%d,fish_mul=%d,bomFlag)",chair_id,score,bulet_mul,fish_mul);

	self.fis_node:removeChildByTag(7758258);
	self.fis_node:removeChildByTag(8888);
	self.fis_node:removeChildByTag(775825);
	self.fish_status_ = 2;
	self.m_mov_timer = 0;
    self.catch_mul=fish_mul;
	self.m_nFishDieCount = 0;
     cc.exports.g_soundManager:PlayGameEffect("effect_catch");
     local x,y=self.fis_node:getPosition();
    if(fish_mul and fish_mul>15) then  cc.exports.Action:crDsBoom(cc.p(x,y)); end
     --cc.exports.g_soundManager:PlayGameEffect("effect_catch");
	--SoundManager::GetInstance().PlayGameEffect(CATCH);
	--SoundManager::GetInstance().PlayFishEffect(fish_kind_);
	local t__local_info_type = cc.exports._local_info_array_[chair_id];
	local t_fish_kind = self.fish_kind_;
	if (self.fish_kind_ >= 30 and self.fish_kind_ <= 39)	then 
		t_fish_kind = self.fish_kind_ - 30;
	end
	if (g_animal_action_num[t_fish_kind]>1) then 
			if (self.fis_node)	then 		
				self.fis_node:removeAllChildren();
            end
			self:PlayDieAction(10086);
	else
		local aliveSpr = self.fis_node:getChildByTag(10086);
		if (aliveSpr) then 
			local t_delay = cc.DelayTime:create(0.4);
			local t_fadeout =cc.FadeOut:create(0.3);
			local t_seq = cc.Sequence:create(t_delay, t_fadeout, nil);
			aliveSpr:runAction(t_seq);
		end
	end	
	local cannon_pos =cc.exports.g_cannon_manager:GetCannonPos(chair_id,0);
	self:AddWin_Effect(chair_id, score,cannon_pos);
end
function Fish:removeCP()
    if(self.fis_node) then self.fis_node:removeChildByTag(7758258); end
end
function Fish:addBoEffect()
            local fish_spr=nil;
            local file_name ="";
		    local readIndex = 0;
		    local animFrames = cc.Animation:create();
            local i=0;
	        for  i = 0,12, 1 do
                file_name=string.format("qipao2_%d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if(frame) then		
                    if(readIndex == 0)then 	fish_spr=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
                end
            end --for i
            if(readIndex > 0) then 		
                 local function remove_func()
                      fish_spr:removeFromParent();
                 end
                 animFrames:setDelayPerUnit(1/10);
				local animation = cc.Animate:create(animFrames);
				local t_CCRepeat =cc.Repeat:create(animation,1);
                local t_ccremove=cc.CallFunc:create(remove_func);
                local t_fadeout=cc.FadeOut:create(0.2);
                local t_seq=cc.Sequence:create(t_CCRepeat,t_fadeout,t_ccremove);
                fish_spr:runAction(t_seq);		
                self.fis_node:addChild(fish_spr,50);                
          end	--	if (readIndex > 0) then			
end
function Fish:AddKind_Effect( force )
      local add_force=0;
     if(force~=nil and force>0) then add_force=1; end;
	if ((self.fish_kind_ >= 30 and self.fish_kind_ <= 39) or add_force>0) then 
    	local t_kind = self.fish_kind_ - 30;
		local fish_spr =self.fis_node:getChildByTag(1001);
		if (fish_spr == nil) then 	
			--fish_spr = MySriteCache::CreateSpriteByFrameCache(UDXmlRoot, "Animal", "Kind_Effect",-1,0,1);
            local file_name ="";
		    local readIndex = 0;
		    local animFrames = cc.Animation:create();
            local i=0;
	        for  i = 0,25, 1 do
                file_name=string.format("baohuzao_%05d.png", i);
				local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
				if(frame) then		
                    if(readIndex == 0)then 	fish_spr=cc.Sprite:createWithSpriteFrame(frame) ;end
					readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
                end
            end --for i
            if(readIndex > 0) then 		
                 animFrames:setDelayPerUnit(1/10);
				local animation = cc.Animate:create(animFrames);
				local t_CCRepeat =cc.RepeatForever:create(animation);
                self.fis_node:addChild(fish_spr,50, 1001);
                if(t_kind~=1 or  t_kind~=2) then 
                    fish_spr:setAnchorPoint(cc.p(0.5,0.32));
                end
			    fish_spr:setScale(kind_effect_scale[t_kind] or 1);
		        fish_spr:setPosition(kind_effect_pos[t_kind]);
                fish_spr:runAction(t_CCRepeat);		
          end	--	if (readIndex > 0) then			
			
		end
	end
end
function Fish:GetFish_Catch_Mul()
 return 0;
end
function Fish:changeDirect( dir)
    local aliveSpr=nil;
	local t_fish_kind = self.fish_kind_;
	if (self.fish_kind_ >= 30 and self.fish_kind_ <= 39) then 
		t_fish_kind = self.fish_kind_ - 30;
	end
	if (self.fis_node:getChildByTag(10086)) then self.fis_node:removeChildByTag(10086); end
	local  readIndex = 0;
	self.m_mov_direct_ = dir;
    local i=0;
    local animFrames = cc.Animation:create();
	for i = 0, 40, 1 do		
		file_name=string.format("animal%d_%02d_%02d.png", t_fish_kind, self.m_mov_direct_, i);	
		local frame =cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
		if (frame) then 	
			if (readIndex == 0) then 			
				aliveSpr = cc.Sprite:createWithSpriteFrame(frame);
			end
			readIndex=readIndex+1;    
            animFrames:addSpriteFrame(frame);
		end
	end
	if (readIndex > 0 and aliveSpr) then 
		self.baseAngle = 0;
		local t_frame_sapeed = game_fish_frame_Speed[t_fish_kind];
         animFrames:setDelayPerUnit(t_frame_sapeed);
		local animation = cc.Animate:create(animFrames);
		local t_repeat = cc.RepeatForever:create(animation);
		aliveSpr:runAction(t_repeat);
		self.fis_node:addChild(aliveSpr, 0, 10086);
		aliveSpr:setAnchorPoint(cc.p(g_fish_offic_x[t_fish_kind], g_fish_offic_y[t_fish_kind]));
		self.m_flip_l = 0;
		self.baseAngle = 0;
	end
	return aliveSpr;
end
function  Fish:check_dir( c_angle)
	local t_dir = 11;
	while (c_angle < 0) do c_angle = c_angle+360; end
	while (c_angle > 360) do c_angle = c_angle-360;end
	if (c_angle > 80 and c_angle < 100) then t_dir = 10; 
	elseif (c_angle > 260 and c_angle < 280) then t_dir = 10;
	elseif (c_angle >=100 and c_angle <=260) then t_dir = 0;
    end
	return t_dir;
end
function Fish:PlayWalkAction(tag)
	local t_fish_kind = self.fish_kind_;
	if (self.fish_kind_ >= 30 and self.fish_kind_ <= 39)then 
		t_fish_kind = self.fish_kind_ - 30;
	end
    local x,y=self.fis_node:getPosition();
	local t_fish_pos =cc.p(x,y);--self.fis_node:getPosition();
	local dis_x = 0;		
	local dis_y = 0;		
	local t_mov_angle = 0;
	if(self.m_mov_index <self.m_mov_point_num)	then 
		dis_x = self.m_mov_list[self.m_mov_index].x - t_fish_pos.x;		
		dis_y = self.m_mov_list[self.m_mov_index].y - t_fish_pos.y;		
		t_mov_angle = math.atan2(dis_x, dis_y)*180.0/3.1415926;
        -- cclog(" Fish:PlayWalkAction..dis_x=%f,dis_y=%f  aaaa",dis_x,dis_y);
	end				
	local  readIndex = 0;
	if (g_animal_direct_num[t_fish_kind] < 3) then --//只有一个方向 只判断左右		
		self.m_mov_direct_ = 0;		
	else
		self.m_mov_direct_ = self:check_dir(t_mov_angle);
	end
    
	local aliveSpr= self:changeDirect(self.m_mov_direct_);
	if (aliveSpr~=nil) then 
        --cclog(" Fish:PlayWalkAction..dis_x=%f,dis_y=%f",dis_x,dis_y);
		local t_flip_flag = 0;
		if (dis_x > 0.0001) then 
           -- cclog(" Fish:PlayWalkAction..dis_x=%f,dis_y=%f aaa",dis_x,dis_y);
			t_flip_flag = 1;
			if (self.m_pic_angle > 90) then t_flip_flag = 0; end	
		elseif (dis_x < -0.0001) then 
             --cclog(" Fish:PlayWalkAction..dis_x=%f,dis_y=%f bbb",dis_x,dis_y);
			t_flip_flag = 0;
		    if (self.m_pic_angle > 90) then t_flip_flag = 1; end
         end
		--if (t_flip_flag~= self.m_flip_l) then 
		self.m_flip_l = t_flip_flag;
        --cclog(" Fish:PlayWalkAction dis_x=%f,dis_y=%f t_flip_flag=%d",dis_x,dis_y,t_flip_flag);
		if (self.m_flip_l>0) then                    
             --cclog("if (self.m_flip_l>0) then .............");
			  aliveSpr:setFlippedX(true);
			  aliveSpr:setAnchorPoint(cc.p(1 - g_fish_offic_x[t_fish_kind], g_fish_offic_y[t_fish_kind]));
		  else	
                --cclog("if (self.m_flip_l==0) then .............");				
				aliveSpr:setFlippedX(false);
				aliveSpr:setAnchorPoint(cc.p(g_fish_offic_x[t_fish_kind], g_fish_offic_y[t_fish_kind]));
			end
         end	       						
	-- end
	self:AddKind_Effect();
end

function Fish:PlayRunAction(tag)--//播放跑步动作

end
function Fish:PlayDizzAction(tag)--//播放晕眩动作

end
function Fish:PlayDieAction(tag )--//播放死亡动作
	local t_fish_kind = self.fish_kind_;
	if (self.fish_kind_ >= 30 and self.fish_kind_ <= 39) then t_fish_kind = self.fish_kind_ - 30; end
	if (g_animal_action_num[t_fish_kind]>1) then 
		if (self.fis_node:getChildByTag(10086)) then self.fis_node:removeChildByTag(10086); end
		local aliveSpr = NULL;
		local animFrames = cc.Animation:create();
		local readIndex = 0;
        local i=0;
		for i = 0, 40, 1 do		
			local file_name=string.format("animal%d_%d1_%02d.png", t_fish_kind, 0, i);
			local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			if (frame) then 
				if (readIndex == 0) then aliveSpr =cc.Sprite:createWithSpriteFrame(frame); end
				readIndex=readIndex+1;    
                animFrames:addSpriteFrame(frame);
			end
		end
		if (readIndex > 0 and aliveSpr~=nil) then 		
			self.baseAngle= 0;
			local t_frame_sapeed = game_fish_frame_Speed[t_fish_kind];
             animFrames:setDelayPerUnit(t_frame_sapeed);
			local animation =cc.Animate:create(animFrames);
			local t_repeat = cc.RepeatForever:create(animation);
			aliveSpr:runAction(t_repeat);
			self.fis_node:addChild(aliveSpr, 0, tag);
			if (self.m_flip_l==true) then 		
				aliveSpr:setFlippedX(true);
				aliveSpr:setAnchorPoint(cc.p(1-g_fish_offic_x[t_fish_kind], g_fish_offic_y[t_fish_kind]));
			else		
				aliveSpr:setFlippedX(false);
				aliveSpr:setAnchorPoint(cc.p(g_fish_offic_x[t_fish_kind], g_fish_offic_y[t_fish_kind]));
			end	            	
		end		
	end
end
function Fish:Hit_Miss()--//被打中但没死亡  晕眩 逃脱效果
	if (self.m_miss_state == 0) then 
		self.m_miss_Data = 2;
		self.m_miss_timer = 0;
		self.m_miss_kind = 0;
		local t_get_rand_num =  rand() % 100;
		if (t_get_rand_num <70) then 		
			self.m_miss_kind = 0;       
			self.m_miss_Data = 1;
			self.m_miss_timeLength = 1;
			--//添加晕眩特效
            local aliveSpr = NULL;
		    local animFrames = cc.Animation:create();
		    local readIndex = 0;
            local i=0;
		    for i = 0, 40, 1 do		
			   local file_name=string.format("animal%d_%d1_%02d.png", t_fish_kind, 0, i);
			   local frame = cc.SpriteFrameCache:getInstance():getSpriteFrame(file_name);
			   if (frame) then 
				   if (readIndex == 0) then aliveSpr =cc.Sprite:createWithSpriteFrame(frame); end
				   readIndex=readIndex+1;    
                   animFrames:addSpriteFrame(frame);
			   end
		    end
            if (readIndex > 0 and aliveSpr) then 		
			    self.baseAngle= 0;
			    local t_frame_sapeed = game_fish_frame_Speed[t_fish_kind];
                 animFrames:setDelayPerUnit(t_frame_sapeed);
			    local animation =cc.Animate:create(animFrames);
			    local t_repeat = cc.RepeatForever:create(animation);
			    aliveSpr:runAction(t_repeat);
		    end			
			if (aliveSpr)then 
				if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
				self.fis_node:addChild(aliveSpr, 111, 8888);
				aliveSpr:setPosition(cc.p(0, 40));--//上提一点点
			end
			--//更换为眩晕动作
			self:PlayDizzAction();
			self.m_miss_state = 1;
		else  
			self.m_miss_kind = 1;--//加速逃窜
			self.m_miss_Data = 1;
			self.m_miss_timeLength = 0.2;
			--//添加吐槽
			--CCSprite *t_ani_fish_yx_ = MySriteCache::CreateSpriteByFrameCache(UDXmlRoot, "Fishes", "Fish_Word0");
            local t_ani_fish_yx_ =cc.Sprite:create("qj_animal/res/game_res/haoxian.png");
			if (t_ani_fish_yx_) then 	
				t_ani_fish_yx_:setAnchorPoint(cc.p(0.5, 0));
				if (self.fis_node:getChildByTag(8888)) then self.fis_node:removeChildByTag(8888); end
				self.fis_node:addChild(t_ani_fish_yx_, 111, 8888);
				t_ani_fish_yx_:setPosition(ccp(0, 40));--//上提一点点
			end
			--//更换为跑步动作
			self:PlayRunAction();
			self.m_miss_state = 1;
		end	
	end    
end
function  Fish:GetHit_disRMin()
    local dis_r_Min = self.bounding_box_height_;
	if (dis_r_Min < self.bounding_box_width_) then 	
		dis_r_Min = self.bounding_box_width_;
	end
    dis_r_Min=dis_r_Min*0.4;
    if(dis_r_Min<100) then dis_r_Min=100; end
    return dis_r_Min;
end
function Fish:touch_Catch_fish_test(touch_pos,touch_r,lock_fishid)
    --cclog("Fish:touch_Catch_fish_test-----------------------------------");
    --cclog("Fish:touch_Catch_fish_test(touch_pos(%f,%f),touch_r=%f)-----------------------",touch_pos.x,touch_pos.y,touch_r);
	--if (self.m_Alive_Step==0) then  return false; end
	if(self.valid_==false)  then return false; end
	if (self.fish_status_ ~= 1) then return false; end
    --cclog("Fish:touch_Catch_fish_test-----------------------------------111");
	--if (lock_fishid> 0 and lock_fishid ~= self.fish_id_)  then return false; 
	--elseif (lock_fishid > 0 and lock_fishid == self.fish_id_) then touch_r =touch_r+50; end
	local m_HitFlag = 0;
	local point=cc.p(0,0);
	local dis_r = 0.0;
	--local dis_r_Max = self.bounding_box_width_;
	local dis_r_Min = self.bounding_box_height_;
	if (dis_r_Min > self.bounding_box_width_) then 	
		-- = self.bounding_box_height_;
		dis_r_Min = self.bounding_box_width_;
	end
	--dis_r_Max = dis_r_Max*0.5;
	dis_r_Min = dis_r_Min*0.5;
	--dis_r_Max = dis_r_Max+touch_r;
	dis_r_Min = dis_r_Min+dis_r_Min;
    --dis_r_Max=dis_r_Max*dis_r_Max;
    dis_r_Min=dis_r_Min*dis_r_Min;
	point.x = touch_pos.x;
	point.y = touch_pos.y;
    local t_disx=point.x-self.m_mov_pos_.x;
	local t_disy=point.y-self.m_mov_pos_.y;
    local t_dis_RR=(t_disx*t_disx)+(t_disy*t_disy);	
	--if (t_dis_RR<dis_r_Max) then 
	if(t_dis_RR<dis_r_Min) then
    --cclog("Fish:touch_Catch_fish_test-----------------------------9999999999999999999999999999999999999999------");
     return true; 
     end
	--end
    --cclog("Fish:touch_Catch_fish_test--------------------------000000000000---------");
	return false;
end



function  Fish:touch_Catch_fish_( _chair_id,  local_chair_id,  bullet_ID,  bullet_Kind,  mul_num,  touch_pos,  touch_r,  lock_fishid)

	if (self:touch_Catch_fish_test(touch_pos, touch_r, lock_fishid))	then return true; end
	return false;
end

function Fish:TouchHitTest( x,  y)
	local t_CCPoint = cc.p(x, y);
	if (self:touch_Catch_fish_test(t_CCPoint, 80, -1)) then return true;end
	return false;
end
return Fish;
--endregion

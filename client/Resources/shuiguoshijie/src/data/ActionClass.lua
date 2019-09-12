ActionClass = class("ActionClass")
function ActionClass:ctor( ... )	
end

function ActionClass:setParent(parent)
	self.parent_ = parent
end

function ActionClass:starBlink(starTab,index,num)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")
	starTab[index]:setVisible(true)
	for i = 1,num do
		if index + i > 23 then
			starTab[index+i-24]:setVisible(true)
		else
			starTab[index+i]:setVisible(true)
		end 
	end 
	if index == 0 then
		starTab[23]:setVisible(false)
	else
		starTab[index-1]:setVisible(false)
	end 
end
function ActionClass:starBlink1(starTab,index,num)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")
	if index + num > 23 then
		starTab[index+num-24]:setVisible(true)
	else
		starTab[index+num]:setVisible(true)
	end 
	if index == 0 then
		starTab[23]:setVisible(false)
	else
		starTab[index-1]:setVisible(false)
	end
end
function ActionClass:starBlink2(starTab,index)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")
	if index == 0 then
		starTab[0]:setVisible(true)
		for i = 1,23 do
			starTab[i]:setVisible(false)
		end 
	else   
		starTab[index]:setVisible(true)
		starTab[index-1]:setVisible(false)
	end 
end
function ActionClass:WinningBlink(spectab,index,centerimag)
	
	self:HistorySpr(index)
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()            
	self:WinTex(self.parent_.centerimag,index) 
    -- 恢复目标  
	pDirector:getActionManager():resumeTarget(self.parent_.light) 
	spectab[index]:setVisible(true)
   
	local defen = self.parent_.defen --中奖类型   
	if defen >= 1 and defen <= 13 then
		AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_music_congratulations.mp3")
	end
	if defen ~= 13 then  --//小猫变身 2倍西瓜变身 2倍。。。。
		self:Calculfra(index)
	end 
	local action1 = cc.DelayTime:create(0.05)
	local function enkback1()   
		spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_blue.png")
	end
	local funcall1 = cc.CallFunc:create(enkback1)
	local action2 = cc.DelayTime:create(0.05)
	local function enkback2()
		spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_green.png")
	end
	local funcall2 = cc.CallFunc:create(enkback2)
	local action3 = cc.DelayTime:create(0.05)
	local function enkback3()
		spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_red.png")
	end
	local funcall3 = cc.CallFunc:create(enkback3)
    local seq1 = cc.Sequence:create(action1,funcall1,action2,funcall2,action3,funcall3)--闪灯
    local repeatAction = nil 
    --if index ~= 9 and index ~= 21 and self.parent_.bolactor == false and index ~= 13 then
     if defen==0 and index ~= 9 and index ~= 21 and index ~= 3  and self.parent_.bolactor == false then
    	local function endsc( ... )
    		local numdd = math.random(1,8)
    		local music = "shuiguoshijie/res/sound/apple"..numdd..".mp3"
			AudioEngine.stopMusic(true)
			AudioEngine.playMusic(music, true)
    	end
    	local funcall4 = cc.CallFunc:create(endsc)
		local actioad = cc.Repeat:create(seq1,200) --
		repeatAction = cc.Sequence:create(seq1,funcall4,actioad)
	else
		repeatAction = cc.Repeat:create(seq1,30)
	end
    local function edkback()
        
    	if defen == 0 then
    		self.parent_.bolspec = true  	
    	end 
    	pDirector:getActionManager():pauseTarget(self.parent_.light)
    	self.parent_.light:setTexture("shuiguoshijie/res/new/back/twin1.png")
    	self.parent_.blinklight:stopAllActions()
    	spectab[index]:setVisible(false)
    	if defen == 1 or defen == 2 then
    		if #self.parent_.indextab > 0 then
    			self.parent_:Runninglights()
    		end 
		elseif defen >= 4 and defen <= 12 then
			self.parent_:goodLuck(defen)
		elseif defen == 13 then
			if self.parent_.catCount > 0 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_cattrans.mp3")
				self:KittyCat()
			else
				self.parent_.bolspec = true 
			end 
        elseif defen == 3 then       
           self.parent_.bolspec = true     
        else
          self.parent_.bolspec = true      
		end 
    end
    local funca = cc.CallFunc:create(edkback)
 	
     if(index==3) then  --显示彩金数字
        local t_delay=cc.DelayTime:create(20);
        local seq2 = cc.Sequence:create(repeatAction,t_delay,funca)
 	    spectab[index]:runAction(seq2)
    else 
       local seq2 = cc.Sequence:create(repeatAction,funca)
       spectab[index]:runAction(seq2)
    end
    if(index==3) then  --显示彩金数字
       AudioEngine.stopMusic();
       AudioEngine.playMusic("shuiguoshijie/res/sound/JP_Award.wav",true);
       --显示彩金数字
       local t_score_numStr = string.format("%d", self.parent_.caijinScore)
       local t_cj_score_spr=cc.LabelAtlas:_create(t_score_numStr,"shuiguoshijie/res/new/JP_num.png", 55, 75, string.byte("0"))
       self.parent_.centerimag:addChild(t_cj_score_spr, 11999, 11999);
       t_cj_score_spr:setPosition(cc.p(0, -100));
       	local t_remov_func = function ()
			t_cj_score_spr:removeFromParent()
		end
       --数字动作
       local t_rot_to0 = cc.RotateTo:create(0.2, 30);
	   local t_rot_to1 = cc.RotateTo:create(0.2, 0);
	   local t_rot_to2 = cc.RotateTo:create(0.2, -30);
	   local t_rot_to3 = cc.RotateTo:create(0.2, 0);
	   local t_seq = cc.Sequence:create(t_rot_to0, t_rot_to1, t_rot_to2, t_rot_to3);
	   local t_repeat = cc.Repeat:create(t_seq, 20);
	   local t_remov = cc.CallFunc:create(t_remov_func);
	   local t_seq2 = cc.Sequence:create(t_repeat, t_remov);
	   t_cj_score_spr:setAnchorPoint(cc.p(0.5, 0.5));
	   t_cj_score_spr:runAction(t_seq2);
    end	
end
function ActionClass:goodlockBlink(goodtab,num,atect)
	for i = 0,23 do
		local rad = math.random(1,3)
		goodtab[rad][i]:setVisible(true)
		if rad == 1 then
			goodtab[2][i]:setVisible(false)
			goodtab[3][i]:setVisible(false)
		elseif rad == 2 then
			goodtab[1][i]:setVisible(false)
			goodtab[3][i]:setVisible(false)
		else
			goodtab[1][i]:setVisible(false)
			goodtab[2][i]:setVisible(false)
		end 
	end
	local ac = num % 9 + 1 
	local tect = ac..ac..ac..ac..ac
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	self.parent_.timertext:setString(tect)
	if atect ~= nil then
		if num > 60 and ac == atect then
			AudioEngine.stopMusic(true)

			for m = 0,23 do
				goodtab[1][m]:setVisible(false)
				goodtab[2][m]:setVisible(false)
				goodtab[3][m]:setVisible(false)
			end 
			if self.parent_.scheduler2 ~= nil then
				cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.parent_.scheduler2)
			end 

			if atect == 1 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_paohuoche.mp3")
			elseif atect == 2 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/qingtingduizhang.mp3")
			elseif atect == 3 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_music_congratulations_e.mp3")
			elseif atect == 4 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_zhonghngsihai.mp3")
			elseif atect == 5 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_bigfour.mp3")
			elseif atect == 6 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_tinythree.mp3")
			elseif atect == 7 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_bigthree.mp3")
			elseif atect == 8 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_jiulianbaodeng.mp3")
			elseif atect == 9 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_damanguan.mp3")
			elseif atect == 10 then
				AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_muisc_award_cattrans.mp3")
			end

			if atect == 3 then
				self.parent_:RunNei()
			elseif atect == 1 then
				self.parent_:Runtrain()
			else
				self.parent_:Runninglights()
			end 	

		end 
	end 
end
function ActionClass:WinTex(spri,index)
	self:HideNei()
	local frameName1 = nil
	local frameName2 = nil       
	if index ==  0 or index == 11 or index == 12 then 
		frameName1 = "shuiguoshijie/res/new/spec/fruit11_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit11_2.png"
	elseif index == 1 or index == 13 or index == 23 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit4_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit4_2.png"
	elseif index == 2 or index == 4 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit3_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit3_2.png"
	elseif index == 3 then
		frameName1 = "shuiguoshijie/res/new/spec/jp_ani_0.png"
		frameName2 = "shuiguoshijie/res/new/spec/jp_ani_1.png"
	elseif index == 5 or index == 10 or index == 15 or index == 22 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit2_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit2_2.png"
	elseif index == 6 or index == 17 or index == 18 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit10_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit10_2.png"
	elseif index == 7 or index == 8 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit15_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit15_2.png"
	elseif index == 9 or index == 21 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit8_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit8_2.png"
	elseif index == 14 or index == 16 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit1_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit1_2.png"
	elseif index == 19 or index == 20 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit12_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit12_2.png"
	end 
	local animation = cc.Animation:create()  
 	animation:addSpriteFrameWithFile(frameName1)
  	animation:addSpriteFrameWithFile(frameName2)
    animation:setDelayPerUnit(0.15)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)   
    local WinSpri = cc.Sprite:create(frameName1)
    local repeatAction = nil
    if index == 3 then  
         cclog(" if index == 3 then  ");
        repeatAction = cc.Repeat:create(animate,80)    
    else 
        repeatAction = cc.Repeat:create(animate,15)
    end 
    
    local function edbck( ... )
    	WinSpri:removeFromParent()
        self:newNei()
    end
    local funca = cc.CallFunc:create(edbck)
    local equ = cc.Sequence:create(repeatAction,funca)
    spri:addChild(WinSpri,20)
    WinSpri:setName("400")
    WinSpri:runAction(equ)
    --]]
end
function ActionClass:HistorySpr(index)
	self:addTabhisnum(index)
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local histab = self.parent_.historyTab
	local sumtable = self.parent_.hisnum
	for i = 1,6 do
		if sumtable[i] ~= nil then             
			local fina = "shuiguoshijie/res/new/hestor/fruit_record_"..sumtable[i]..".png"
			histab[i]:setVisible(true)
			histab[i]:loadTexture(fina)
		end 
	end 
end    
function ActionClass:addTabhisnum(index)
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	self.parent_.frenum = self.parent_.frenum + 1
	local num = 0
	local sumtable = self.parent_.hisnum
	local bolsu = true
	if index == 0 or index == 12 then
		num = 10
	elseif index == 1 or index == 13 then
		num = 12
	elseif index == 2 then
		num = 8
	elseif index == 3 then
		num = 19
	elseif index == 4 then
		num = 16
	elseif index == 5 or index == 10 or index == 15 or index == 22 then
		num = 9
	elseif index == 6 or index == 18 then
		num = 11 
	elseif index ==  7 then
		num = 13 
	elseif index == 8 then
		num = 5
	elseif index == 9 then
		num = 17
	elseif index == 11 then
		num = 2 
	elseif index == 14 then
		num = 7 
	elseif index == 16 then
		num = 15
	elseif index == 17 then
		num = 3
	elseif index == 19 then
		num = 14
	elseif index == 20 then
		num = 6
	elseif index == 21 then
		num = 18 
	elseif index == 23 then
		num = 4 
	end 
	sumtable[6] = nil
	table.insert(sumtable,1,num)
end
function ActionClass:RunningClockwise(index,num)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local tabbb = self.parent_.starfurttab[num]
	tabbb[index]:setVisible(true)
	if index == 0 then
		tabbb[23]:setVisible(false)
	else
		tabbb[index-1]:setVisible(false)
	end 
end
function ActionClass:RunningAnticlockwise(index,num)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")
	local  pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local tabbb = self.parent_.starfurttab[num]
	tabbb[index]:setVisible(true)
	if index == 23 then
		tabbb[0]:setVisible(false)
	else
		tabbb[index+1]:setVisible(false)
	end 
end
function ActionClass:Blink(index,num)
	self:Calculfra(index)
	local pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local spectab = self.parent_.speceffredtab
	spectab[index]:setVisible(true)
	if index == num then  
		local action1 = cc.DelayTime:create(0.05)
		local function enkback1()   
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_blue.png")
		end
		local funcall1 = cc.CallFunc:create(enkback1)
		local action2 = cc.DelayTime:create(0.05)
		local function enkback2()
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_green.png")
		end
		local funcall2 = cc.CallFunc:create(enkback2)
		local action3 = cc.DelayTime:create(0.05)
		local function enkback3()
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_red.png")
		end
		local funcall3 = cc.CallFunc:create(enkback3)
		local seq1 = cc.Sequence:create(action1,funcall1,action2,funcall2,action3,funcall3)
		local repeatAction = cc.Repeat:create(seq1,10)
		local function endbac()

			self.parent_.bolspec = true
			self.parent_.bolrand = true
			if self.parent_.centerimag:getChildByName("100") then
				self.parent_.centerimag:getChildByName("100"):removeFromParent()
			end
			local dddtab = self.parent_.speceffredtab
			for i = 0,#dddtab do
				dddtab[i]:stopAllActions()
				dddtab[i]:setVisible(false)
			end
		end
		local funca = cc.CallFunc:create(endbac)
 		local seq2 = cc.Sequence:create(repeatAction,funca)
 		spectab[index]:runAction(seq2)
	else
		local action1 = cc.DelayTime:create(0.05)               
		local function enkback1()   
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_blue.png")
		end
		local funcall1 = cc.CallFunc:create(enkback1)
		local action2 = cc.DelayTime:create(0.05)
		local function enkback2()              
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_green.png")
		end
		local funcall2 = cc.CallFunc:create(enkback2)
		local action3 = cc.DelayTime:create(0.05)
		local function enkback3()
			spectab[index]:loadTexture("shuiguoshijie/res/new/spec/fruit_b_red.png")
		end
		local funcall3 = cc.CallFunc:create(enkback3)
		local seq1 = cc.Sequence:create(action1,funcall1,action2,funcall2,action3,funcall3)
		local repeatAction = cc.Repeat:create(seq1,30000000)
		spectab[index]:runAction(repeatAction)
	end 
end
function ActionClass:king(num)
	self:HideNei()
	local pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local frameName1 = nil
	local frameName2 = nil
	if num == 2 then  --大四喜
		frameName1 = "shuiguoshijie/res/new/spec/fruit5_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit5_2.png"
	elseif num == 3 then   --大三元
		frameName1 = "shuiguoshijie/res/new/spec/fruit6_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit6_2.png"
	elseif num == 4 then   --小三元
		frameName1 = "shuiguoshijie/res/new/spec/fruit13_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit13_2.png"
	elseif num == 5 then   --跑火车
		frameName1 = "shuiguoshijie/res/new/spec/fruit14_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit14_2.png"
	elseif num == 6 then   ---蜻蜓队长
		frameName1 = "shuiguoshijie/res/new/spec/fruit18_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit18_2.png"
	elseif num == 7 then   --纵横四海
		frameName1 = "shuiguoshijie/res/new/spec/fruit19_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit19_2.png"
	elseif num == 8 then   --九莲宝灯
		frameName1 = "shuiguoshijie/res/new/spec/fruit17_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit17_2.png"
	elseif num == 9 then   --大满贯
		frameName1 = "shuiguoshijie/res/new/spec/fruit16_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit16_2.png"
	end 
	local animation = cc.Animation:create()  
 	animation:addSpriteFrameWithFile(frameName1)
  	animation:addSpriteFrameWithFile(frameName2)
    animation:setDelayPerUnit(1.5/10)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)
    local repeatAction = cc.Repeat:create(animate,10000000)
    local WinSpri = cc.Sprite:create(frameName1)
    local function edbck( ... )   	
    	WinSpri:removeFromParent()
	end 
    local funca = cc.CallFunc:create(edbck)
    local equ = cc.Sequence:create(repeatAction,funca)
    self.parent_.centerimag:addChild(WinSpri,20)
    WinSpri:setName("100")
    WinSpri:runAction(equ)
end
--小猫变身
function ActionClass:KittyCat()
	self:HideNei()
	self:CaCatScore()
	local pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local frameName1 = "shuiguoshijie/res/new/spec/fruit7_1.png"
	local frameName2 = "shuiguoshijie/res/new/spec/fruit7_2.png"
	local animation = cc.Animation:create()  
 	animation:addSpriteFrameWithFile(frameName1)
  	animation:addSpriteFrameWithFile(frameName2)
    animation:setDelayPerUnit(1.5/10)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)
    local repeatAction = cc.Repeat:create(animate,26)
    local WinSpri = cc.Sprite:create(frameName1)
    local function edbck(...)
    	self.parent_.bolspec = true
    	WinSpri:removeFromParent()
    end
    local funca = cc.CallFunc:create(edbck)
    local equ = cc.Sequence:create(repeatAction,funca)
    self.parent_.centerimag:addChild(WinSpri,20)
    WinSpri:setName("200")
    WinSpri:runAction(equ)	
end

--跑内圈
function ActionClass:RunNei(index)
	AudioEngine.playEffect("shuiguoshijie/res/sound/fruit_run1.mp3")

	local pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local fdnxe = index % 16 + 1
	local runneitab = self.parent_.runneitab
	runneitab[fdnxe]:setVisible(true)
	if fdnxe == 1 then
		runneitab[16]:setVisible(false)
	else
		runneitab[fdnxe-1]:setVisible(false)
	end 
end

local map_nei_sound = 
{
	[1] = "shuiguoshijie/res/sound/",
	[2] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[3] = "shuiguoshijie/res/sound/fruit_apple.mp3",
	[4] = "shuiguoshijie/res/sound/fruit_orange.mp3",
	[5] = "shuiguoshijie/res/sound/fruit_orange.mp3",
	[6] = "shuiguoshijie/res/sound/fruit_lenmon.mp3",
	[7] = "shuiguoshijie/res/sound/fruit_lenmon.mp3",
	[8] = "shuiguoshijie/res/sound/fruit_bell.mp3",
	[9] = "shuiguoshijie/res/sound/fruit_bell.mp3",
	[10] = "shuiguoshijie/res/sound/fruit_xigua.mp3",
	[11] = "shuiguoshijie/res/sound/fruit_xigua.mp3",
	[12] = "shuiguoshijie/res/sound/fruit_star.mp3",
	[13] = "shuiguoshijie/res/sound/fruit_star.mp3",
	[14] = "shuiguoshijie/res/sound/fruit_77.mp3",
	[15] = "shuiguoshijie/res/sound/fruit_77.mp3",
	--[16] = "",	
}

--中央闪烁
function ActionClass:NeiBlink(num)
	local sound = map_nei_sound[num]
	if sound then
		AudioEngine.playEffect(sound)
	end
	self:HideNei()
	self:CaNeiScore(num)
	local frameName1 = nil
	local frameName2 = nil   
	if num == 1 or num == 16 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit3_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit3_2.png"
	elseif num == 2 or num == 3 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit2_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit2_2.png"
	elseif num == 4 or num == 5 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit11_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit11_2.png"
	elseif num == 6 or num == 7 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit10_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit10_2.png"
	elseif num == 8 or num == 9 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit4_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit4_2.png"
	elseif num == 10 or num == 11 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit15_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit15_2.png"
	elseif num == 12 or num == 13 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit12_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit12_2.png"
	elseif num == 14 or num == 15 then
		frameName1 = "shuiguoshijie/res/new/spec/fruit1_1.png"
		frameName2 = "shuiguoshijie/res/new/spec/fruit1_2.png"
	end
	local pDirector = cc.Director:getInstance() 
	local running_scene = pDirector:getRunningScene()
	local animation = cc.Animation:create()  
 	animation:addSpriteFrameWithFile(frameName1)
  	animation:addSpriteFrameWithFile(frameName2)
    animation:setDelayPerUnit(1.5/10)
    animation:setRestoreOriginalFrame(true)
    local animate = cc.Animate:create(animation)
    local repeatAction = cc.Repeat:create(animate,18)
    local WinSpri = cc.Sprite:create(frameName1)
    local function edbck(...)
    	self.parent_.bolspec = true
    	WinSpri:removeFromParent()
    end
    local funca = cc.CallFunc:create(edbck)
    local equ = cc.Sequence:create(repeatAction,funca)
    self.parent_.centerimag:addChild(WinSpri,20)
    WinSpri:setName("300")
    WinSpri:runAction(equ)
end

function ActionClass:Calculfra(index)
	print("Calculfra="..index)
	local score = 0
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	if index == 0 or index == 12 then
		score = 10 * self.parent_.fruitBet[7]
	elseif index == 1 or index == 13 then
		score = 10 * self.parent_.fruitBet[5]
	elseif index == 6 or index == 18 then
		score = 10 * self.parent_.fruitBet[6]
    elseif index == 3 then
		score = self.parent_.caijinScore;
	elseif index == 9 or index == 21 then
		score = 0
	elseif index == 2 then
		score = 50 * self.parent_.fruitBet[1]
	elseif index == 4 then
		score = 100 * self.parent_.fruitBet[1]
	elseif index == 5 or index == 10 or index == 15 or index == 22 then
		score = 5 * self.parent_.fruitBet[8]
	elseif index == 7 then
		score = 20 * self.parent_.fruitBet[4]
	elseif index == 16 then
		score = 20 * self.parent_.fruitBet[2]
	elseif index == 19 then
		score = 20 * self.parent_.fruitBet[3]
	elseif index == 8 then
		score = 2 * self.parent_.fruitBet[4]
	elseif index == 11 then
		score = 2 * self.parent_.fruitBet[7]
	elseif index == 14 then
		score = 2 * self.parent_.fruitBet[2]
	elseif index == 17 then
		score = 2 * self.parent_.fruitBet[6]
	elseif index == 20 then
		score = 2 * self.parent_.fruitBet[3]
	elseif index == 23 then
		score = 2 * self.parent_.fruitBet[5]
	end 
	print("score="..score)
	self:upAScore(score)
end   

function ActionClass:CaNeiScore(num)
	print("CaNeiScore="..num)
	local score = 0
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	if num == 1 then
		score = 100 * self.parent_.fruitBet[1]
	elseif num == 16 then
		score = 50 * self.parent_.fruitBet[1]
	elseif num == 2 then
		score = 50 * self.parent_.fruitBet[8]
	elseif num == 3 then
		score = 100 * self.parent_.fruitBet[8]
	elseif num == 4 then
		score = 50 * self.parent_.fruitBet[7]
	elseif num == 5 then
		score = 100 * self.parent_.fruitBet[7]
	elseif num == 6 then
		score = 50 * self.parent_.fruitBet[6]
	elseif num == 7 then
		score = 100 * self.parent_.fruitBet[6]
	elseif num == 8 then
		score = 50 * self.parent_.fruitBet[5]
	elseif num == 9 then
		score = 100 * self.parent_.fruitBet[5]
	elseif num == 10 then
		score = 50 * self.parent_.fruitBet[4]
	elseif num == 11 then
		score = 100 * self.parent_.fruitBet[4]
	elseif num == 12 then
		score = 50 * self.parent_.fruitBet[3]
	elseif num == 13 then
		score = 100 * self.parent_.fruitBet[3]
	elseif num == 14 then
		score = 50 * self.parent_.fruitBet[2]
	elseif num == 15 then
		score = 100 * self.parent_.fruitBet[2]
	end
	self:upAScore(score)
end

function ActionClass:CaCatScore()
	local score = 0
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	local index = self.parent_.dicrun
	print("CaCatScore="..index)
	local n = self.parent_.catCount - 1
	if index == 8 then
		score = 20 * self.parent_.fruitBet[4] * math.pow(2,n)
	elseif index == 11 then
		score = 10 * self.parent_.fruitBet[7] * math.pow(2,n)
	elseif index == 14 then
		score = 20 * self.parent_.fruitBet[2] * math.pow(2,n)
	elseif index == 17 then
		score = 10 * self.parent_.fruitBet[6] * math.pow(2,n)
	elseif index == 20 then
		score = 20 * self.parent_.fruitBet[3] * math.pow(2,n)
	elseif index == 23 then
		score = 10 * self.parent_.fruitBet[5] * math.pow(2,n)
	end 
	self:upAScore(score)
end

function ActionClass:upAScore(score)
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	self.parent_.winscore = self.parent_.winscore + score
	print("upAScore="..score.."="..self.parent_.winscore)
	if(self.parent_.game_run_state==99) then 
		self.parent_.winscoretext:setString(tostring(self.parent_.winscore)) ;
	end
end
                         
--隐藏内圈
function ActionClass:HideNei()
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	local neitab = self.parent_.neiimagtab
	for m = 1,18 do
		neitab[m]:setVisible(false)
	end 
	self.parent_.blinkd:setOpacity(255)
end

function ActionClass:newNei()
	local pDirector = cc.Director:getInstance()
	local running_scene = pDirector:getRunningScene()
	local neitab = self.parent_.neiimagtab
	local cen = self.parent_.centerimag
	for m = 1,18 do
		neitab[m]:setVisible(true)
	end
	self.parent_.shblink:setOpacity(0) 
	self.parent_.blinkd:setOpacity(0)
end


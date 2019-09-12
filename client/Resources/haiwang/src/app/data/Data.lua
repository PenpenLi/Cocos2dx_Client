--head-------------------------------------------------------------


 cc.exports.M_PI=3.14159265358979323846;
cc.exports.M_PI_2=1.57079632679489661923;
cc.exports.M_PI_4=0.785398163397448309616;
cc.exports.M_1_PI=0.318309886183790671538;
cc.exports.M_2_PI=0.636619772367581343076;
cc.exports.G_FPS_TIME_STD=0.0333334
cc.exports.GAME_UIORDER_=2
cc.exports.PLAYER_CANNON_TAG=66
cc.exports.PLAYER_SPEC_TAG=77
cc.exports.PLAYER_CANNONNUM_TAG=4
cc.exports.PLAYER_SCORENUM_TAG=5
cc.exports.CANNON_VIRFIREPOINT_TAG=100
cc.exports.BULLETALIVEMAX=30; --最多子弹数量
cc.exports.k_scale_10_dis_ = 10;    --10人要进行缩放
cc.exports.screem_height_default = 720;
cc.exports.screem_width_default = 1280;
cc.exports.kBottomHeight = 47;
cc.exports.kTopHeight = cc.exports.screem_height_default - cc.exports.kBottomHeight;
cc.exports.kDis_Width = -86;
cc.exports.g_game_player_bullet_num_list={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0}
cc.exports._local_player_num_I=4;
--cc.exports.debug_text = nil;
cc.exports._local_info_array_=
{
        [0]={ x=340, y= cc.exports.kTopHeight,      default_angle=180, sceore_angle=180 },
		[1]={ x=960, y= cc.exports.kTopHeight,      default_angle=180, sceore_angle=180 },
		[2]={ x=940, y= cc.exports.kBottomHeight, default_angle=0,    sceore_angle=0 },
		[3]={ x=320, y= cc.exports.kBottomHeight, default_angle=0,    sceore_angle=0 },				
		[4]={ x=0, y=0, default_angle=0, sceore_angle=0 }, 
        [5]={ x=0, y=0, default_angle=0, sceore_angle=0 }, 
        [6]={ x=0, y=0, default_angle=0, sceore_angle=0 },
        [7]= { x=0, y=0, default_angle=0, sceore_angle=0}
  };
  cc.exports._local_info_array_6=
{
        [0]={ x=340, y= cc.exports.kTopHeight, default_angle=180, sceore_angle=180 },
		[1]={ x=960, y= cc.exports.kTopHeight, default_angle=180, sceore_angle=180 },
		[2]={ x=940, y= cc.exports.kBottomHeight, default_angle=0, sceore_angle=0 },
		[3]={ x=320, y= cc.exports.kBottomHeight, default_angle=0, sceore_angle=0 },	
		[4]={ x=cc.exports.kBottomHeight, y= 330,default_angle= 90, sceore_angle=90 },		
		[5]={ x=cc.exports.screem_width_default - cc.exports.kBottomHeight, y=390, default_angle=-90, sceore_angle=-90 },
        [6]={ x=0, y=0, default_angle=0, sceore_angle=0 },
        [7]={ x=0, y=0, default_angle=0, sceore_angle=0}
  };
  cc.exports._local_info_array_8=
{
       [0]={ x=240,  y=cc.exports.kTopHeight, default_angle=180, sceore_angle=0 },
	   [1]={ x=1140, y=cc.exports.kTopHeight, default_angle=180, sceore_angle=0 },
       [6]={ x=690,  y=cc.exports.kTopHeight, default_angle=180, sceore_angle=0 },	

       [2]={ x=1010, y=cc.exports.kBottomHeight, default_angle=0, sceore_angle=0 },
	   [3]={ x=150,  y=cc.exports.kBottomHeight, default_angle=0, sceore_angle=0 },
	   [7]={ x=580,  y=cc.exports.kBottomHeight, default_angle=0, sceore_angle=0 },
	  
       		
	   [5]={ x=cc.exports.screem_width_default - cc.exports.kBottomHeight, y=330, default_angle=-90, sceore_angle=-90 },
	   [4]={ x=cc.exports.kBottomHeight,  y=390, default_angle=90, sceore_angle=90 }, 				
  };
cc.exports.g_fish_queue_delay_ =
{
	[0]=0.2, 0.2, 0.2, 0.26, 0.25, 0.3, 0.3, 0.3, 0.3, 0.35,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
	0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25
};
--火龙
cc.exports.m_huolong_InitFlag=0;
cc.exports.game_Dragon_HitList_local =
		   {
			{{ 50, 80, 31 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--1
			{ { 40, 80, 30 }, { 70, 170, 45 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//2
			{ { 50, 100, 30 }, { 100, 200, 30 }, { 150, 300, 30 }, { 0, 0, 0 }, { -0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//3
			{ { 50, 150, 30 }, { 100, 250, 30 }, { 150, 340, 30 }, { 200, 355, 30 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { -0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//4
			{ { 50, 115, 30 }, { 100, 200, 23 }, { 150, 300, 25 }, { 200, 350, 25 }, { 250, 370, 58 }, { 0, 0, 0 }, { 0, 0 ,0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//5
			{ { 90, 180, 30 }, { 150, 320, 30 }, { 200, 350, 30 }, { 300, 350, 30 }, { 400, 290, 29 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//6
			{{ 50, 190, 30 }, { 180, 280, 30 }, { 200, 350, 30 }, { 300, 350, 29 }, { 400, 280, 40 }, { 500, 220, 34 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//7
			{ { 50, 150, 35 }, { 130, 340, 30 }, { 250, 360, 30 }, { 350, 330, 30 }, { 450, 280, 42 }, { 550, 180, 30 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//8
			{ { 100, 250, 34 }, { 250, 360, 68 }, { 400, 300, 53 }, { 500, 230, 37 }, { 600, 200, 62 }, { 750, 200, 23 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//9
			{ { 300, 350, 30 }, { 450, 260, 62 }, { 600, 200, 30 }, { 700, 230, 65 }, { 820, 350, 64 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//10
			{ { 400, 300, 34 }, { 550, 210, 29 }, { 700, 250, 59 }, { 800, 300, 33 }, { 850, 360, 23 }, { 900, 450, 45 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },--//11
			{ { 450, 250, 40 }, { 600, 250, 40 }, { 750, 270, 59 }, { 800, 400, 30 }, { 900, 460, 40 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },         --//12
			{ { 600, 220, 40 }, { 700, 280, 40 }, { 830, 400, 40 }, { 860, 450, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },                    --//13
			{ { 750, 260, 35 }, { 850, 400, 30 }, { 900, 480, 36 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },                           --//14
			{ { 750, 300, 30 }, { 850, 420, 30 }, { 900, 460, 45 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },                           --//15
			{ { 850, 360, 30 }, { 900, 480, 30 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },                                    -- //16
			{ { 900, 450, 59 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },
			{ { 940, 500, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 }, { 0, 0, 0 } },
		   };
--鳄鱼
--cc.exports.g_eyuMov_List =
--{
--	[0]={ [0]=cc.p(1580, -500), cc.p(340, cc.exports.kTopHeight) },
--	{ [0]=cc.p(-500, -500), cc.p(960, cc.exports.kTopHeight) },
--	{ [0]=cc.p(-500, 1200), cc.p(940, cc.exports.kBottomHeight) },
--	{ [0]=cc.p(1580, 1200), cc.p(320, cc.exports.kBottomHeight) },
--};
--帝王蟹
--根据位置取四个角落
cc.exports.g_fishSuperCrab_mov_pos = { 
[0]=cc.p(120, 360), 
[1]=cc.p(250, 550), 
[2]=cc.p(640, 650),
[3]=cc.p(1000,550),
[4]=cc.p(1100, 360), 
[5]=cc.p(950, 150), 
[6]=cc.p(640, 100), 
[7]=cc.p(250, 150) };
--大灯笼鱼

 cc.exports.g_soundManager=nil;
cc.exports.game_manager_=nil;--游戏场景类
cc.exports.g_pFishGroup=nil;--鱼管理工具
cc.exports.g_CoinManager=nil;--金币管理
cc.exports.g_BingoManager=nil;
cc.exports.g_cannon_manager=nil;
cc.exports.g_lock_fish_manager=nil;
--特殊子弹管理器
cc.exports.g_Bullet_Manager=nil;
cc.exports.g_Broach_Bullet_Manager=nil;
cc.exports.g_Dianci_Bullet_Manager=nil;
cc.exports.g_GuidedMissile_Bullet_Manager=nil;
cc.exports.g_Free_Bullet_Manager=nil;
cc.exports.g_My_Particle_manager=nil;

cc.exports.boodr = true       --定鱼
cc.exports.lock_fishid  = 0       --用于执行自动跟踪  锁定鱼的ID
cc.exports.lock_fish  = nil       --用于执行自动跟踪  锁定鱼的实体
cc.exports.ID = 0   --唯一标识
cc.exports.scheduler = cc.Director:getInstance():getScheduler()


cc.exports.veIDnum1 = 0  --子弹ID
cc.exports.veIDnum2 = 10000  --子弹ID
cc.exports.veIDnum3 = 20000  --子弹ID
cc.exports.veIDnum4 = 30000  --子弹ID

cc.exports.bulletMap = {} --子弹表
cc.exports.fishMap = {} --鱼表

cc.exports.SuoFishrectTable = {}
for i = 1,5 do
    for j = 1,8 do                	
        local a = cc.rect((j-1)*80,(i-1)*107,80,107)
        table.insert(SuoFishrectTable,a)                	      
    end
end


local fish1 = {}
for i = 1,3 do
	for j = 1,5 do
		if i == 3 and j == 5 then
			break
		else
			local a = cc.rect((j-1)*52,(i-1)*24,52,24)
			table.insert(fish1,a)
		end 
	end
end

local fish2 = {}
for i = 1,3 do
	for j = 1,6 do
		if i == 3 and j == 6 then
			break
		else
			local a = cc.rect((j-1)*66,(i-1)*45,66,45)
			table.insert(fish2,a)
		end 
	end
end 

local fish3 = {}
for i = 1,7 do 
	for j = 1,2 do
		local a = cc.rect((j-1)*101,(i-1)*56,101,56)
		table.insert(fish3,a)
	end 
end

local fish4 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*62,(i-1)*96,62,96)
		table.insert(fish4,a)
	end 
end 

local fish5 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*121,(i-1)*56,121,56)
		table.insert(fish5,a)
	end 
end 

local fish6 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*79,(i-1)*84,79,84)
		table.insert(fish6,a)
	end 
end 

local fish7 = {}
for i = 1,5 do
	for j = 1,6 do
		local a = cc.rect((j-1)*67,(i-1)*76,67,76)
		table.insert(fish7,a)
	end 
end 

local fish8 = {}
for i = 1,6 do
	for j = 1,5 do
		if i == 6 and j >= 5 then
			break
		else
			local a = cc.rect((j-1)*135,(i-1)*127,135,127)
			table.insert(fish8,a)
		end
	end 
end

local fish9 = {}
for i = 1,2 do
	for j = 1,7 do
		local a = cc.rect((j-1)*128,(i-1)*117,128,117)
		table.insert(fish9,a)
	end 
end

local fish10 = {}
for i = 1,7 do
	for j = 1,3 do
		local a = cc.rect((j-1)*114,(i-1)*94,114,94)
		table.insert(fish10,a)
	end 
end

local fish11 = {}
for i = 1,5 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123,(i-1)*103,123,103)
		table.insert(fish11,a)
	end 
end

local fish12 = {}
for i = 1,4 do
	for j = 1,5 do
		if i == 4 and j >= 5 then
			break
		else
			local a = cc.rect((j-1)*111.2,(i-1)*111.25,111.2,111.25)
			table.insert(fish12,a)
		end
	end 
end 

local fish13 = {}
for i = 1,3 do
	for j = 1,3 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*188.67,(i-1)*88,188.67,88)
			table.insert(fish13,a)
		end
	end 
end 

local fish14 = {}
for i = 1,6 do
	for j = 1,3 do
		if i == 6 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*180.33,(i-1)*166.17,180.33,166.17)
			table.insert(fish14,a)
		end
	end 
end 

local fish15 = {}
for i = 1,6 do
	for j = 1,3 do
		local a = cc.rect((j-1)*216,(i-1)*133,216,133)
		table.insert(fish15,a)
	end 
end

local fish16 = {}
for i = 1,6 do
	for j = 1,3 do
		local a = cc.rect((j-1)*288,(i-1)*148,288,148)
		table.insert(fish16,a)
	end 
end

local fish17 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*228,(i-1)*195,228,195)
		table.insert(fish17,a)
	end 
end 

local fish18 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*320,(i-1)*168,320,168)
		table.insert(fish18,a)
	end 
end

local fish19 = {}
for i = 1,6 do
	for j = 1,2 do
		local a = cc.rect((j-1)*297,(i-1)*172,297,172)
		table.insert(fish19,a)
	end 
end 

local fish20 = {}
for i = 1,3 do
	for j = 1,3 do
		local a = cc.rect((j-1)*368.33,(i-1)*167.67,368.33,167.67)
		table.insert(fish20,a)
	end 
end

local fish21 = {}
for i = 1,7 do
	for j = 1,2 do
		if i == 7 and j >= 2 then
			break
		else
			local a = cc.rect((j-1)*419.5,(i-1)*175,419.5,175)
			table.insert(fish21,a)
		end
	end 
end

local fish22 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*180,(i-1)*98,180,98)
		table.insert(fish22,a)
	end 
end

local fish23 = {}
for i = 1,3 do
	for j = 1,2 do
		local a = cc.rect((j-1)*103,(i-1)*145,103,145)
		table.insert(fish23,a)
	end 
end

cc.exports.FishCreateTable = {
	[0] = fish1,
	[1] = fish2,
	[2] = fish3,
	[3] = fish4,
	[4] = fish5,
	[5] = fish6,
	[6] = fish7,
	[7] = fish8,
	[8] = fish9,
	[9] = fish10,
	[10] = fish11,
	[11] = fish12,
	[12] = fish13,
	[13] = fish14,
	[14] = fish15,
	[15] = fish16,
	[16] = fish17,
	[17] = fish18,
	[18] = fish19,
	[19] = fish20,
	[20] = fish21,
	[21] = fish22,
	[22] = fish23,
}

local fishd1 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*70,(i-1)*31,70,31)
		table.insert(fishd1,a)
	end 
end 

local fishd2 = {}
for i = 1,2 do
	for j = 1,4 do
		local a = cc.rect((j-1)*62,(i-1)*37,62,37)
		table.insert(fishd2,a)
	end 
end

local fishd3 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*82,(i-1)*57,82,57)
		table.insert(fishd3,a)
	end 
end 

local fishd4 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*78,(i-1)*88,78,88)
		table.insert(fishd4,a)
	end 
end 

local fishd5 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*109,(i-1)*56,109,56)
		table.insert(fishd5,a)
	end 
end

local fishd6 = {}
for i = 1,2 do
	for j = 1,4 do
		if i == 2 and j == 4 then
			break
		else
			local a = cc.rect((j-1)*77,(i-1)*65,77,65)
			table.insert(fishd6,a)
		end 
	end
end

local fishd7 = {}
for i = 1,3 do
	for j = 1,6 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*67,(i-1)*76,67,76)
			table.insert(fishd7,a)
		end 
	end
end

local fishd8 = {}
for i = 1,3 do
	for j = 1,3 do
		local a = cc.rect((j-1)*124,(i-1)*100,124,100)
		table.insert(fishd8,a)
	end 
end

local fishd10 = {}
for i = 1,3 do
	local a = cc.rect((i-1)*110,0,110,90)
	table.insert(fishd10,a)
end 

local fishd11 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123,(i-1)*103,123,103)
		table.insert(fishd11,a)
	end 
end

local fishd12 = {}
for i = 1,2 do
	for j = 1,3 do
		local a = cc.rect((j-1)*123.33,(i-1)*101,123.33,101)
		table.insert(fishd12,a)
	end 
end

local fishd13 = {}
for i = 1,3 do
	for j = 1,3 do
		if i == 3 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*236,(i-1)*110,236,110)
			table.insert(fishd13,a)
		end
	end 
end

local fishd14 = {}
for i = 1,3 do
	for j = 1,2 do
		local a = cc.rect((j-1)*204.5,(i-1)*179,204.5,179)
		table.insert(fishd14,a)
	end 
end

local fishd15 = {}
for i = 1,2 do
	for j = 1,3 do
		if i == 2 and j >= 3 then
			break
		else
			local a = cc.rect((j-1)*221,(i-1)*134,221,134)
			table.insert(fishd15,a)
		end
	end 
end

local fishd16 = {}
for i = 1,4 do
	for j = 1,2 do
		local a = cc.rect((j-1)*293.5,(i-1)*125.5,293.5,125.5)
		table.insert(fishd16,a)
	end 
end

local fishd17 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*237,(i-1)*218,237,218)
		table.insert(fishd17,a)
	end 
end

local fishd18 = {}
for i = 1,6 do
	for j = 1,2 do
		local a = cc.rect((j-1)*319,(i-1)*193,319,193)
		table.insert(fishd18,a)
	end 
end

local fishd19 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*237,(i-1)*168,237,168)
		table.insert(fishd19,a)
	end 
end

local fishd20 = {}
for i = 1,4 do
	for j = 1,2 do
		if i == 4 and j >= 2 then
			break
		else
			local a = cc.rect((j-1)*390.5,(i-1)*207.5,390.5,207.5)
			table.insert(fishd20,a)
		end
	end 
end

local fishd21 = {}
for i = 1,5 do
	for j = 1,2 do
		local a = cc.rect((j-1)*428,(i-1)*222,428,222)
		table.insert(fishd21,a)
	end
end

cc.exports.FishDeathTable = {
	[0] = fishd1,
	[1] = fishd2,
	[2] = fishd3,
	[3] = fishd4,
	[4] = fishd5,
	[5] = fishd6,
	[6] = fishd7,
	[7] = fishd8,
	[9] = fishd10,
	[10] = fishd11,
	[11] = fishd12,
	[12] = fishd13,
	[13] = fishd14,
	[14] = fishd15,
	[15] = fishd16,
	[16] = fishd17,
	[17] = fishd18,
	[18] = fishd19,
	[19] = fishd20,
	[20] = fishd21,
}

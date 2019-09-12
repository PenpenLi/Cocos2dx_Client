cc.exports.boodr = true       --定鱼
cc.exports.lock_fishid  = 0       --用于执行自动跟踪  锁定鱼的ID
cc.exports.lock_fish  = nil       --用于执行自动跟踪  锁定鱼的实体
cc.exports.ID = 0   --唯一标识
--data
cc.exports.FISH_KIND_31=30;
cc.exports.FISH_KIND_40=39;
cc.exports.FISH_KIND_COUNT=40;
cc.exports.LOCKFISH_MIN=0;
cc.exports.scheduler = cc.Director:getInstance():getScheduler()
cc.exports.g_game_player_bullet_num_list={[0]=0,0,0,0,0,0,0,0,0,0,0,0,0}

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
--
--
--
--
--
--
--
cc.exports.game_manager_=nil;
cc.exports.fishlayer=nil;
 cc.exports.g_cannon_manager=nil;
--
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
cc.exports.kBottomHeight = 36;
cc.exports.kTopHeight = cc.exports.screem_height_default - cc.exports.kBottomHeight;
cc.exports.kDis_Width = -86;
cc.exports._local_player_num_I=4;
cc.exports.g_game_run_type=3;
cc.exports.GAME_PLAYER=8
cc.exports.CANNON_VIRFIREPOINT_TAG=100;
cc.exports._local_info_array_=
{
        [0]={ x=170, y= cc.exports.kBottomHeight,      default_angle=0, sceore_angle=0 },
		[1]={ x=490, y= cc.exports.kBottomHeight,      default_angle=0, sceore_angle=0 },
		[2]={ x=810, y= cc.exports.kBottomHeight,      default_angle=0,    sceore_angle=0 },
		[3]={ x=1130, y= cc.exports.kBottomHeight,     default_angle=0,    sceore_angle=0 },				
		[4]={ x=0, y=0, default_angle=0, sceore_angle=0 }, 
        [5]={ x=0, y=0, default_angle=0, sceore_angle=0 }, 
        [6]={ x=0, y=0, default_angle=0, sceore_angle=0 },
        [7]= { x=0, y=0, default_angle=0, sceore_angle=0}
  };
  
cc.exports.g_map0 =
{
	ccp(158, 180),
	ccp(159, 212),
	ccp(159, 252),
	ccp(159, 291),
	ccp(159, 326),
	ccp(159, 359),
	ccp(161, 396),
	ccp(162, 433),
	ccp(156, 468),
	ccp(194, 468),
	ccp(224, 467),
	ccp(253, 468),
	ccp(290, 466),
	ccp(322, 469),
	ccp(513, 179),
	ccp(478, 177),
	ccp(442, 177),
	ccp(413, 180),
	ccp(416, 214),
	ccp(416, 251),
	ccp(415, 289),
	ccp(415, 323),
	ccp(418, 364),
	ccp(416, 394),
	ccp(417, 431),
	ccp(413, 470),
	ccp(447, 472),
	ccp(476, 470),
	ccp(512, 466),
	ccp(544, 180),
	ccp(545, 217),
	ccp(544, 255),
	ccp(544, 288),
	ccp(543, 324),
	ccp(544, 358),
	ccp(547, 398),
	ccp(545, 434),
	ccp(545, 466),
	ccp(635, 181),
	ccp(646, 228),
	ccp(658, 275),
	ccp(675, 326),
	ccp(689, 373),
	ccp(707, 423),
	ccp(814, 180),
	ccp(798, 214),
	ccp(793, 248),
	ccp(780, 288),
	ccp(766, 335),
	ccp(755, 375),
	ccp(738, 421),
	ccp(721, 466),
	ccp(1023, 181),
	ccp(987, 180),
	ccp(952, 178),
	ccp(928, 177),
	ccp(899, 178),
	ccp(893, 214),
	ccp(898, 251),
	ccp(892, 289),
	ccp(898, 320),
	ccp(930, 319),
	ccp(968, 318),
	ccp(1002, 319),
	ccp(1031, 322),
	ccp(896, 361),
	ccp(896, 393),
	ccp(895, 435),
	ccp(896, 467),
	ccp(929, 469),
	ccp(959, 467),
	ccp(992, 468),
	ccp(1027, 468),
	ccp(1055, 467),
	ccp(160, 575),
	ccp(319, 576),
	ccp(416, 577),
	ccp(544, 573),
	ccp(671, 575),
	ccp(800, 577),
	ccp(896, 578),
	ccp(1057, 575)
};

cc.exports.g_map1 =
{
	ccp(698, 199),
	ccp(665, 204),
	ccp(633, 204),
	ccp(596, 231),
	ccp(561, 250),
	ccp(515, 251),
	ccp(474, 230),
	ccp(452, 204),
	ccp(407, 201),
	ccp(375, 203),
	ccp(341, 227),
	ccp(316, 249),
	ccp(302, 274),
	ccp(291, 301),
	ccp(293, 326),
	ccp(301, 347),
	ccp(317, 371),
	ccp(342, 396),
	ccp(350, 417),
	ccp(373, 440),
	ccp(395, 460),
	ccp(420, 484),
	ccp(440, 513),
	ccp(483, 537),
	ccp(515, 555),
	ccp(922, 230),
	ccp(886, 205),
	ccp(854, 185),
	ccp(813, 182),
	ccp(778, 182),
	ccp(745, 207),
	ccp(718, 225),
	ccp(710, 248),
	ccp(697, 276),
	ccp(700, 302),
	ccp(712, 325),
	ccp(722, 345),
	ccp(745, 366),
	ccp(762, 394),
	ccp(778, 418),
	ccp(805, 440),
	ccp(830, 463),
	ccp(855, 485),
	ccp(885, 506),
	ccp(924, 532),
	ccp(764, 250),
	ccp(772, 268),
	ccp(783, 292),
	ccp(793, 320),
	ccp(786, 344),
	ccp(774, 371),
	ccp(762, 395),
	ccp(749, 412),
	ccp(728, 437),
	ccp(705, 460),
	ccp(680, 485),
	ccp(642, 510),
	ccp(622, 527),
	ccp(588, 556),
	ccp(552, 578),
	ccp(968, 232),
	ccp(1000, 203),
	ccp(1038, 176),
	ccp(1071, 178),
	ccp(1105, 181),
	ccp(1128, 204),
	ccp(1162, 227),
	ccp(1178, 252),
	ccp(1194, 273),
	ccp(1201, 299),
	ccp(1197, 323),
	ccp(1183, 346),
	ccp(1170, 369),
	ccp(1160, 397),
	ccp(1135, 418),
	ccp(1115, 441),
	ccp(1094, 467),
	ccp(1057, 486),
	ccp(1034, 511),
	ccp(993, 538),
	ccp(961, 558),
	ccp(540, 369),
	ccp(965, 357)
};

cc.exports.g_map2=
{
	ccp(257, 210),
	ccp(241, 239),
	ccp(232, 263),
	ccp(221, 289),
	ccp(215, 310),
	ccp(206, 331),
	ccp(178, 330),
	ccp(154, 331),
	ccp(127, 331),
	ccp(96, 331),
	ccp(96, 351),
	ccp(120, 368),
	ccp(138, 384),
	ccp(161, 399),
	ccp(184, 416),
	ccp(177, 441),
	ccp(168, 468),
	ccp(160, 487),
	ccp(149, 514),
	ccp(239, 475),
	ccp(217, 493),
	ccp(195, 511),
	ccp(172, 531),
	ccp(149, 540),
	ccp(270, 228),
	ccp(281, 260),
	ccp(290, 287),
	ccp(297, 310),
	ccp(302, 331),
	ccp(325, 331),
	ccp(352, 333),
	ccp(376, 330),
	ccp(398, 331),
	ccp(423, 332),
	ccp(417, 353),
	ccp(395, 365),
	ccp(375, 384),
	ccp(351, 398),
	ccp(331, 414),
	ccp(340, 434),
	ccp(346, 458),
	ccp(352, 480),
	ccp(357, 497),
	ccp(361, 519),
	ccp(259, 468),
	ccp(278, 484),
	ccp(296, 497),
	ccp(317, 510),
	ccp(334, 527),
	ccp(356, 536),
	ccp(592, 28),
	ccp(576, 57),
	ccp(567, 81),
	ccp(556, 107),
	ccp(550, 128),
	ccp(541, 149),
	ccp(513, 148),
	ccp(489, 149),
	ccp(462, 149),
	ccp(431, 149),
	ccp(431, 169),
	ccp(455, 186),
	ccp(473, 202),
	ccp(496, 217),
	ccp(519, 234),
	ccp(512, 259),
	ccp(503, 286),
	ccp(495, 305),
	ccp(484, 332),
	ccp(574, 293),
	ccp(552, 311),
	ccp(530, 329),
	ccp(507, 349),
	ccp(484, 358),
	ccp(605, 46),
	ccp(616, 78),
	ccp(625, 105),
	ccp(632, 128),
	ccp(637, 149),
	ccp(660, 149),
	ccp(687, 151),
	ccp(711, 148),
	ccp(733, 149),
	ccp(758, 150),
	ccp(752, 171),
	ccp(730, 183),
	ccp(710, 202),
	ccp(686, 216),
	ccp(666, 232),
	ccp(675, 252),
	ccp(681, 276),
	ccp(687, 298),
	ccp(692, 315),
	ccp(696, 337),
	ccp(594, 286),
	ccp(613, 302),
	ccp(631, 315),
	ccp(652, 328),
	ccp(669, 345),
	ccp(691, 354),
	ccp(907, 229),
	ccp(891, 258),
	ccp(882, 282),
	ccp(871, 308),
	ccp(865, 329),
	ccp(856, 350),
	ccp(828, 349),
	ccp(804, 350),
	ccp(777, 350),
	ccp(746, 350),
	ccp(746, 370),
	ccp(770, 387),
	ccp(788, 403),
	ccp(811, 418),
	ccp(834, 435),
	ccp(827, 460),
	ccp(818, 487),
	ccp(810, 506),
	ccp(799, 533),
	ccp(889, 494),
	ccp(867, 512),
	ccp(845, 530),
	ccp(822, 550),
	ccp(799, 559),
	ccp(920, 247),
	ccp(931, 279),
	ccp(940, 306),
	ccp(947, 329),
	ccp(952, 350),
	ccp(975, 350),
	ccp(1002, 352),
	ccp(1026, 349),
	ccp(1048, 350),
	ccp(1073, 351),
	ccp(1067, 372),
	ccp(1045, 384),
	ccp(1025, 403),
	ccp(1001, 417),
	ccp(981, 433),
	ccp(990, 453),
	ccp(996, 477),
	ccp(1002, 499),
	ccp(1007, 516),
	ccp(1011, 538),
	ccp(909, 487),
	ccp(928, 503),
	ccp(946, 516),
	ccp(967, 529),
	ccp(984, 546),
	ccp(1006, 555)
};
--

cc.exports.game_tick_YPos=
{
	[0]=20, 100, 100, 120, 80, 100, 100, -30, -30,50,
	45, 80, 80, 100, 100, 150, 150, 150, 150, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

cc.exports.game_tick_scal =
{
	[0]=0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.6, 0.4, 0.4, 0.35,
	0.35, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
	0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5
};
cc.exports.game_fish_movSpeed = 
{ 
	[0]=4, 6, 6, 5, 5, 5, 5, 5, 5, 5,
    4, 4, 4, 4, 4, 3, 3, 3, 2, 1,
	2, 3, 3, 3, 4, 4, 4, 4, 4, 4, 
	5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 
};
--cc.exports.kind_effect_scale= { [0]=1.2, 3, 3, 1.5, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2 };
cc.exports.kind_effect_scale= { [0]=0.8, 1, 1,0.85,1,1, 1,1,2,1.2,1,1,1,1,1 };
cc.exports.kind_effect_pos_catch ={
[0]=cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),cc.p(0, 15),
     cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),cc.p(0, 30),
};
cc.exports.kind_effect_pos =
{
	[0]=cc.p(0, -30),
	cc.p(0, -30),
	cc.p(0, -30),
	cc.p(0, -25),
	cc.p(0, -45),
	cc.p(0, -40),

	cc.p(0, -45),
	cc.p(0, -45),
	cc.p(0, -100),
	cc.p(0, -50),
	cc.p(0, -30),
	cc.p(0, -30),
	cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
    cc.p(0, -30),
	cc.p(0, -30)
};
cc.exports.g_animal_action_num= { [0]=1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
cc.exports.g_animal_direct_num= { [0]=1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1,1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 };
cc.exports.game_fish_frame_Speed =
{
	[0]=1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0,
	1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0, 1 / 40.0,
	1 / 12.0, 1 / 12.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0,
	1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0, 1 / 10.0
};
cc.exports.g_fish_offic_x = { [0]=0.5, 0.5, 0.5, 0.5, 0.75, 0.72, 0.5, 0.5, 0.36, 0.5, 0.5, 0.5, 0.65, 0.66, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,0.5 };
cc.exports.g_fish_offic_y = { [0]=0.5, 0.5, 0.5, 0.5, 0.6, 0.55, 0.5, 0.5, 0.6, 0.5, 0.5, 0.5, 0.5, 0.7, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,0.5 };
cc.exports.M_PI_VALUE=3.1415926;
cc.exports.g_animal_data=
{
     ["a0"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/0.png",    ["RectWidth"]=60 ,["RectHeight"]=100 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a1"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/1.png",    ["RectWidth"]=180 ,["RectHeight"]=120 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a2"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/2.png",    ["RectWidth"]=180 ,["RectHeight"]=120 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a3"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/3.png",    ["RectWidth"]=80 ,["RectHeight"]=98 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a4"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/4.png",    ["RectWidth"]=60 ,["RectHeight"]=120 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a5"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/5.png",    ["RectWidth"]=70 ,["RectHeight"]=120 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a6"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/6.png",    ["RectWidth"]=90 ,["RectHeight"]=108 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a7"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/7.png",    ["RectWidth"]=70  ,["RectHeight"]=118 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a8"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/8.png",    ["RectWidth"]=150 ,["RectHeight"]=180 ,["baseAngle"]=1800 ,["scale"]=0.5,},
	 ["a9"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/9.png",    ["RectWidth"]=100 ,["RectHeight"]=142 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a10"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/10.png",  ["RectWidth"]=150 ,["RectHeight"]=140 ,["baseAngle"]=0 ,["scale"]=1,},		
	 ["a11"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/11.png",  ["RectWidth"]=140 ,["RectHeight"]=172 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a12"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/12.png",  ["RectWidth"]=127 ,["RectHeight"]=156 ,["baseAngle"]=0 ,["scale"]=1,},	
	 ["a13"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/13.png",  ["RectWidth"]=217 ,["RectHeight"]=200 ,["baseAngle"]=0 ,["scale"]=1,},	
	 ["a14"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/14.png",  ["RectWidth"]=162 ,["RectHeight"]=230 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a15"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/15.png",  ["RectWidth"]=248 ,["RectHeight"]=200 ,["baseAngle"]=0 ,["scale"]=1,},
	 ["a16"]={["name_path"]="qj_animal/res/game_res/Animal/name_ef/16.png",  ["RectWidth"]=500 ,["RectHeight"]=260 ,["baseAngle"]=0 ,["scale"]=1,},
	 
}


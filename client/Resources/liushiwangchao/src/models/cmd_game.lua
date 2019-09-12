--
-- Author: Tang
-- Date: 2016-12-08 15:41:53
--
local cmd = {}

--游戏标识
cmd.KIND_ID                 = 175

--游戏人数
cmd.GAME_PLAYER             = 100

--游戏版本
cmd.VERSION  			    =util:makeVersion(6, 7, 0, 1)
-- appdf.VersionValue(6,7,0,1)

--常量定义
cmd.BET_ITEM_KIND               =4                                   --投注项类型
cmd.BET_ITEM_COUNT              =12                                  --投注项数目
cmd.BET_ITEM_TOTAL_COUNT        =24                                  --投注项总数 
cmd.BET_ITEM_COUNT_PER_KIND     =3								     --每中类型投注项数目
cmd.BET_MAX_ROUTE               =8                                   --最大路单   
cmd.COLOR_LIGHT_GROUP_COUNT     =3                                   --彩灯组数 
cmd.COLOR_LIGHT_COUNT           =24                                  --彩灯数目
cmd.COLOR_LIGHT_KIND            =3                                   --彩灯类型  
cmd.MAX_GUN_COUNT               =9									 --最大枪数 
cmd.MAX_LIST_ITEM				=30									 --最大人数

--状态定义
cmd.GAME_STATUS_BET				=100								    --下注状态
cmd.GAME_STATUS_DRAW			=101									--开奖状态
cmd.GAME_STATUS_DRAW_RESULT     =102									--派彩结果

--时间器定义
cmd.IDI_GAME_FREE				=10									--游戏空闲
cmd.IDI_GAME_BET                =11							        --游戏下注
cmd.IDI_GAME_DRAW               =12								    --游戏开奖
cmd.IDI_GAME_DRAW_RESULT        =13									--游戏派彩
cmd.IDI_DRAW_RESULT_SOUND		=14									--开奖结果		

--闪电倍率
cmd.LEVIN_RATIO_MULTI2          =0x0100                              --2倍赔率
cmd.LEVIN_RATIO_MULTI3          =0x0200                              --3倍赔率

--掩码定义
cmd.BET_ITEM_TYPE_MASK          =0xff                                --动物类型
cmd.BET_ITEM_KIND_MASK          =0xff0000                            --动物种类  
cmd.LEVIN_RATIO_MASK            =0xff00                              --闪电倍数
cmd.SHOOT_COUNT_MASK            =0xff00                              --打枪枪数

--开奖定义
cmd.DRAW_RESULT_NONE            =0x00000000                          --开奖结果
cmd.DRAW_RESULT_LION            =0x00100000                          --开奖结果 狮子 1048576
cmd.DRAW_RESULT_PANDER          =0x00200000                          --开奖结果 熊猫 2097152
cmd.DRAW_RESULT_MONKEY          =0x00400000                          --开奖结果 猴子 4194304
cmd.DRAW_RESULT_RABBIT          =0x00800000                          --开奖结果 兔子 8388608
cmd.DRAW_RESULT_DSY             =0x01000000                          --开奖结果 大三元
cmd.DRAW_RESULT_DSX             =0x02000000                          --开奖结果 大四喜
cmd.DRAW_RESULT_LEVIN           =0x04000000                          --开奖结果 闪电
cmd.DRAW_RESULT_GUN             =0x08000000                          --开奖结果 送灯
cmd.DRAW_RESULT_GOLD            =0x10000000                          --开奖结果 彩金
 
--动画标识
cmd.ANIMATION_NONE              =0x0000                                
cmd.ANIMATION_DRAWALOTTERY      =0x0001                              --开奖动画
cmd.ANIMATION_FOCUSANIMAL       =0x0002                              --聚焦动物 
cmd.ANIMATION_MOVECAMARA        =0x0004                              --移动摄像机
cmd.ANIMATION_PAYOUTDSY         =0x0008                              --大三元动画
cmd.ANIMATION_PAYOUTDSX         =0x0010                              --大四喜动画
cmd.ANIMATION_PAYOUTSD          =0x0020                              --闪电动画
cmd.ANIMATION_PAYOUTGUN         =0x0040                              --打枪动画
cmd.ANIMATION_PAYOUTMGOLD       =0x0080                              --彩金动画


cmd.RESULT_DSY      = 28
cmd.RESULT_RED      = 25
cmd.RESULT_GREEN    = 26
cmd.RESULT_YELLOW	= 27

cmd.NormalPos 		 = 0
cmd.bottomHidden     = 1
cmd.hidden     		 = 2

cmd.RotateMin   	 = 0.3
cmd.RotateMax 	     = 10
cmd.ArrowRotateMax   = 8

cmd.applyNone        = 0
cmd.applyed          = 1
cmd.unApply			 = 2

cmd.Clock_Free = 0 --空闲时间
cmd.Clock_Place= 1 --下注时间
cmd.Clock_Reward=2 --开奖时间
cmd.Clock_Back  =3  --返回时间

cmd.Type_Free = 0--空闲时间
cmd.Type_Place= 1--下注时间
cmd.Type_Reward=2--开奖时间
cmd.Type_Back = 3 --返回时间

cmd.Stop        = 0 --静止
cmd.Speed       = 1--加速
cmd.ConSpeed    = 2 --匀速
cmd.SlowDown    = 3--减速
cmd.RightJust   = 4  --调整位置

cmd.Camera_Normal_Vec3 = cc.vec3(0, 30, -29) --常规摄像头位置
cmd.Camera_Rotate_Vec3 = cc.vec3(0, 28, -26) --旋转摄像头位置
cmd.Camera_Win_Vec3 = cc.vec3(0, 24, -18) --中奖摄像头位置

cmd.None    = 0
cmd.Jettons = 1
cmd.Continue= 2

--基本信息
cmd.CMD_S_Status_Base=
{
	--标识变量		
	{k="bAllowApplyBanker",t="bool"},				 --允许上庄	
  
	--时间变量
	{k="cbFreeTimeCount",t="byte"},--空闲时间
	{k="cbBetTimeCount",t="byte"},--下注时间
	{k="cbDrawTimeCount",t="byte"},--开奖时间
	{k="cbPayOutTimeCount",t="byte"}, --派彩时间
            
	--角度变量
	{k="nAnimalRotateAngle",t="int"},	--轮盘角度
	{k="nPointerRatateAngle",t="int"},	 --指针角度 
             
	--路单信息
	{k="cbRouteListCount",t="byte"},--路单数目  
	{k="dwRouteListData",t="int",l={cmd.BET_MAX_ROUTE}},--路单数据

	--彩灯信息
	{k="cbColorLightIndexList",t="byte",l={cmd.COLOR_LIGHT_COUNT}}, --彩灯索引

	--赔率信息
	{k="cbBetItemRatioList",t="byte",l={cmd.BET_ITEM_COUNT}},--赔率列表 

	--封顶变量
	{k="lItemBetTopLimit",t="score",l={cmd.BET_ITEM_COUNT}},--下注封顶
	{k="lUserItemBetTopLimit",t="score"},--投注封顶
	{k="lUserTotalBetTopLimit",t="score"},--投注封顶
		
	--上庄信息
	{k="cbBankerListMaxItem",t="byte"},--上庄上限
	{k="cbApplyBankerCount",t="byte"},--申请人数
	{k="cbBankerKeepCount",t="byte"},--连庄局数
	{k="cbCurrBankerKeepCount",t="byte"},--连庄局数
	{k="wBankerChairID",t="word"},--庄家方位
	{k="wApplyBankerList",t="word",l={cmd.MAX_LIST_ITEM}},--申请列表
	{k="lApplyBankerScore",t="score"},--上庄分数
	{k="lBankerGrade",t="score"},--庄家成绩
					
	--下注变量
	{k="lBetTotalCount",t="score",l={cmd.BET_ITEM_COUNT}} --下注金额
};

--命令定义
cmd.SUB_S_START_FREE            =1                                  --空闲时间
cmd.SUB_S_START_BET             =2                                  --开始下注
cmd.SUB_S_START_DRAW            =3                                  --开始开奖
cmd.SUB_S_DRAW_RESULT			=4                                  --派彩时间
cmd.SUB_S_BETCOUNT_CHANGE       =5                                  --下注额改变
cmd.SUB_S_USER_BET				=6								    --用户下注	
cmd.SUB_S_BET_FAILED            =7                                  --下注失败
cmd.SUB_S_SYSTEM_INFO			=8                                  --系统信息 
cmd.SUB_S_BET_INFO				=9                                  --下注信息
cmd.SUB_S_BANKER_OPERATE		=10								    --庄家操作
cmd.SUB_S_SWITCH_BANKER			=11								    --切换庄家
cmd.SUB_S_BANKERINFO_VARIATION  =12								    --信息更新	

--开始下注
cmd.CMD_S_Start_Free=
{
	{k="cbBetItemRatio",t="byte",l={cmd.BET_ITEM_COUNT}} --下注赔率
};

--开始下注
cmd.CMD_S_Start_Bet=
{
	{k="cbBetItemRatio",t="byte",l={cmd.BET_ITEM_COUNT}},--下注赔率
	{k="cbColorLightIndexList",t="byte",l={cmd.COLOR_LIGHT_COUNT}}--彩灯索引
};

--开始开奖
cmd.CMD_S_Start_Draw=
{
	--时间变量
	{k="cbDrawTimeCount",t="byte"},--开奖时间
	{k="cbPointerColor",t="byte"},--指针颜色	
			
	--角度变量
	{k="nCurrAnimalAngle",t="int"}, --动物角度
	{k="nCurrPointerAngle",t="int"},--指针角度
	{k="nAnimalAngle",t="int"},  --动物角度
	{k="nPointerAngle",t="int"},--指针角度
	{k="nShootItemAngle",t="int",l={cmd.MAX_GUN_COUNT}}, --打枪角度
	{k="nShootPointerAngle",t="int",l={cmd.MAX_GUN_COUNT}},--指针角度
	{k="nLevinMulti",t="int"},--闪电倍数
	{k="nShootCount",t="int"},--打枪次数
                      
	--彩金变量
	{k="lPayOutTotalCount",t="score"}, --彩金数目

	--动画标识
	{k="dwAnimationFlag",t="word"},--动画标识

	--变量定义
	{k="cbDrawResultCount",t="byte"},--中奖数目
	{k="cbDrawResultIndex",t="byte",l={10}},--中奖索引		
};

--系统信息
cmd.CMD_S_System_Info=
{
	--系统信息
	{k="lSystemEarnings",t="score"},--系统盈利
	{k="lCurrRepertory",t="score"},--当前库存	

	{k="lCurrMosaicGold",t="score"},--彩池彩金
	{k="lCurrRevenueCount",t="score"}, --抽水总量
	{k="lCurrChangeRepertory",t="score"},--库存变化
	{k="lSystemInitReper",t="score"},--系统初始库存
	{k="lInitMGold",t="score"}, --系统初始彩金
					  
	--比率信息
	{k="wDrawOutRatio",t="word"},--彩池抽取率
	{k="wPayoutInninggeRatio",t="word"},--派彩概率
	{k="wRevenueRatio",t="word"},--抽水概率
				   
	--上庄信息
	{k="lApplyBankerScore",t="score"},--上庄分数
	{k="cbBankerKeepCount",t="byte"},--连庄局数
	{k="cbPlayerWinMultiRatio",t="byte"},--赢利几率	
	{k="cbRobotWinMultiRatio",t="byte"},--赢利几率	
	{k="lUserScore",t="score",l={cmd.GAME_PLAYER}} --用户成绩	
};

--下注信息
cmd.CMD_S_Bet_Info=
{
	--下注信息
	{k="lUserBetInfo",t="score",l={cmd.GAME_PLAYER*cmd.BET_ITEM_COUNT}} --玩家下注
};

--结束开奖
cmd.CMD_S_Draw_Result=
{
	--开奖变量
	{k="cbDrawResultCount",t="byte"},--空闲时间
	{k="dwDrawBetItem",t="int"},--单选开奖
	{k="dwDrawWeaveItem",t="int"},--组合开奖
	{k="dwShootItem",t="int",l={cmd.MAX_GUN_COUNT}},--打枪子项
      
	--分数变量
	{k="lGameScore",t="score"},--游戏分数
	{k="lGameTax",t="score"}, --游戏税收
	{k="lBankerScore",t="score"},--庄家分数

	--中奖信息
	{k="bDrawItemIndex",t="bool",l={cmd.BET_ITEM_COUNT}},--中奖标识
	{k="bDrawMGold",t="bool"},--中奖标识                       
};

--下注额变化
cmd.CMD_S_BetCount_Change=
{
	{k="cbBetItemIndex",t="byte"},--下注项索引
	{k="lCurrBetCount",t="score"} --当前下注额                   
};

--玩家下注
cmd.CMD_S_User_Bet=
{
	{k="cbBetItemIndex",t="byte"}, --下注项索引
	{k="wChairID",t="word"}, 		--玩家方位
	{k="lBetCount",t="score"} 		--下注数目					  
};

--庄家操作
cmd.CMD_S_Banker_Operate=
{
	{k="bApplyBanker",t="bool"},--上庄标识
	{k="wChairID",t="word"} --玩家标识				  	
};

--下注失败
cmd.CMD_S_BetFailed=
{
	{k="cbBetItemIndex",t="byte"},--下注索引
	{k="lBetCount",t="score"}	  --下注金额                    
};

--切换庄家
cmd.CMD_S_Switch_Banker=
{
	{k="wBankerChairID",t="word"},--庄家标识
	{k="wPreBankerChairID",t="word"}--上个庄家			   
};

--庄家信息
cmd.CMD_S_BankerInfo_Variation=
{
	{k="lBankerGrade",t="score"},--庄家成绩
	{k="cbBankerKeepCount",t="byte"}--上庄局数			   
};
----------------------------------------------------------------------------------
--命令定义

cmd.SUB_C_CANCEL_BET            =100                                 --取消下注
cmd.SUB_C_USER_BET              =101                                 --用户下注
cmd.SUB_C_GET_SYSTEM_INFO       =102                                 --获取信息
cmd.SUB_C_EDIT_SYSTEM_INFO      =103                                 --修改参数
cmd.SUB_C_COMMIT_CONTROL        =104                                 --提交控制
cmd.SUB_C_CANCEL_CONTROL		=105                                 --取消控制 
cmd.SUB_C_BANKER_OPERATE		=106								 --庄家操作
cmd.SUB_C_EDIT_RATIO_INFO		=107                                 --修改参数
----------------------------------------------------------------------------------
--结构定义

--玩家下注
cmd.CMD_C_User_Bet=
{
	{k="cbBetItemIndex",t="byte"},--下注项索引
	{k="lBetCount",t="score"}--下注金额                   
};

--修改参数
--[[cmd.CMD_C_Edit_SystemInfo=
{
	LONGLONG						lCurrRepertory;					   --当前库存
	LONGLONG						lInitMGold;						   --初始彩金
};

--修改参数
cmd.CMD_C_Edit_RatioInfo=
{
	WORD							wDrawOutRatio;					   --彩池抽取率
	WORD							wPayoutInninggeRatio;              --派彩概率
	WORD							wRevenueRatio;					   --抽水概率
	LONGLONG						lApplyBankerScore;				   --上庄分数
	BYTE							cbBankerKeepCount;				   --连庄局数
	BYTE							cbPlayerWinMultiRatio;			   --赢利几率
	BYTE							cbRobotWinMultiRatio;			   --赢利几率
};	

--提交控制
cmd.CMD_C_Commit_Control=
{
	WORD							wControlCount;					   --控制局数
	DWORD                           dwDrawBetItem;                     --单选开奖
	DWORD                           dwDrawWeaveItem;                   --组合开奖
	DWORD                           dwShootItem[MAX_GUN_COUNT];        --打枪子项
	LONGLONG						lPayOutTotalCount;					   --彩金数目		
};

--庄家操作
cmd.CMD_C_Banker_Operate=
{
	bool							bApplyBanker;					   --上庄标识
	WORD							wChairID;						   --玩家标识	
};]]

print("load cmd............................................................")
return cmd
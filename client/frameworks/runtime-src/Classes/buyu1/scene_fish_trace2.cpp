
//#include "stdafx.h"
#include "scene_fish_trace2.h"
#include <math.h>
#include <iterator> 
#include "cocos2d.h"

static const float kResolutionWidth = 1366;
static const float kResolutionHeight = 768;
std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_index2_[200];
std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_count2_ = 0;
std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_index2_ = 0;
std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_count2_ = 0;
std::vector<FPointAngle> scene_kind_1_trace2_[SCENE_KIND_1_TRACNENUM2];
std::vector<FPointAngle> scene_kind_2_trace2_[SCENE_KIND_2_TRACNENUM2];
std::vector<FPointAngle> scene_kind_3_trace2_[SCENE_KIND_3_TRACNENUM2];
std::vector<FPointAngle> scene_kind_4_trace2_[SCENE_KIND_4_TRACNENUM2];
std::vector<FPointAngle> scene_kind_5_trace2_[SCENE_KIND_5_TRACNENUM2];



std::vector<FPointAngle> Quee_Fish_trace_0[36];
std::vector<FPointAngle> Quee_Fish_trace_1[36];
//
float SceneMovSpeed1 = 1;
float SceneMovSpeed2 = 1;
float SceneMovSpeed3 = 1;
float SceneMovSpeed4 = 1;
float SceneMovSpeed5 = 1;


static void ChangToGLPos(cocos2d::CCPoint *fpoint)
{
	cocos2d::CCPoint t_pos = cocos2d::CCDirector::sharedDirector()->convertToGL(cocos2d::CCPointMake(fpoint->x, fpoint->y));
	cocos2d::CCSize size = cocos2d::CCDirector::sharedDirector()->getVisibleSize();
	//x=t_pos.x;
	fpoint->x=t_pos.x;
	fpoint->y=t_pos.y;

}
static void ChangToGLPos(float&x, float &y)
{
	cocos2d::CCPoint t_pos = cocos2d::CCDirector::sharedDirector()->convertToGL(cocos2d::CCPointMake(x, y));
	//CSize size=CCDirector::sharedDirector()->getVisibleSize();
	//x=t_pos.x;
	x=t_pos.x;
	y=t_pos.y;

}


int  Build_Spec_Fish(float startx, float starty, float disx, float disy, int alivenum, int startIndex, FPoint *fish_pos)
{
	for (int i = 0; i<alivenum; i++)
	{
		fish_pos[startIndex].x = startx;
		fish_pos[startIndex].y = starty;
		startIndex++;
		startx += disx;
		starty += disy;
	}
	return alivenum;
}

int BuildSceneKind1Trace_yao(float start_x, float start_y, int index, FPoint *fish_pos) //118
{
	int t_fish_index = index;
	float t_start_x = 0;//生成起点
	float t_start_y = 0;
	float t_end_x = 0;//生成起点
	float t_end_y = 0;
	float t_dis_x = 0;
	float t_dis_y = 0;
	int   t_num = 0;
	//摇
	//横1
	t_start_x = 840;
	t_start_y = 524;
	t_end_x = 1020;//生成起点
	t_end_y = 0;
	t_dis_x = 20;
	t_dis_y = 0;
	//t_num=10;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//横2
	t_start_x = 1060;
	t_start_y = 490;
	t_end_x = 1220;//生成起点
	t_end_y = 0;
	t_dis_x = 20;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横3
	t_start_x = 1090;
	t_start_y = 420;
	t_end_x = 1220;//生成起点
	t_end_y = 0;
	t_dis_x = 20;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//横4
	t_start_x = 1050;
	t_start_y = 334;
	t_end_x = 1220;//生成起点
	t_end_y = 0;
	t_dis_x = 20;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//

	//竖0
	t_start_x = 950;
	t_start_y = 568;
	t_end_x = 0;//生成起点
	t_end_y = 300;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//竖1
	t_start_x = 1140;
	t_start_y = 480;
	t_end_x = 0;//生成起点
	t_end_y = 330;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//竖3
	t_start_x = 1050;
	t_start_y = 360;
	t_end_x = 0;//生成起点
	t_end_y = 310;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//竖4
	t_start_x = 1220;
	t_start_y = 360;
	t_end_x = 0;//生成起点
	t_end_y = 310;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//竖5
	t_start_x = 1140;
	t_start_y = 560;
	t_end_x = 0;//生成起点
	t_end_y = 510;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);


	////1
	t_start_x = 990;
	t_start_y = 490;
	t_end_x = 0;//生成起点
	t_end_y = 390;
	t_dis_x = -10;
	t_dis_y = 9;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//2
	t_start_x = 1060;
	t_start_y = 500;
	t_end_x = 0;//生成起点
	t_end_y = 410;
	t_dis_x = -5;
	t_dis_y = 9;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//3
	t_start_x = 1220;
	t_start_y = 560;
	t_end_x = 0;//生成起点
	t_end_y = 510;
	t_dis_x = -7;
	t_dis_y = 9;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//

	//4
	t_start_x = 1080;
	t_start_y = 578;
	t_end_x = 1220;//生成起点
	t_end_y = 600;
	t_dis_x = 20;
	t_dis_y = -4;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//\\1
	t_start_x = 1050;
	t_start_y = 564;
	t_end_x = 1090;//生成起点
	t_end_y = 510;
	t_dis_x = 7;
	t_dis_y = 9;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//\\1
	t_start_x = 884;
	t_start_y = 344;
	t_end_x = 900;//生成起点
	t_end_y = 320;
	t_dis_x = 20;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	return t_fish_index;

}

//
int BuildSceneKind1Trace_qian(float start_x, float start_y, int index, FPoint *fish_pos) //94
{
	int fish_count = 0;

	int t_fish_index = index;
	float t_start_x = 0;//生成起点
	float t_start_y = 0;

	float t_end_x = 0;//生成起点
	float t_end_y = 0;

	float t_dis_x = 0;
	float t_dis_y = 0;
	int   t_num = 0;
	t_start_x = 394;
	t_start_y = 450;
	t_end_x = 450;//生成起点
	t_end_y = 550;
	t_dis_x = 7;
	t_dis_y = -10;
	t_num = (t_end_y - t_start_y) / -t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	t_start_x = 470;
	t_start_y = 550;
	t_end_x = 580;//生成起点
	t_end_y = 440;
	t_dis_x = 10;
	t_dis_y = 12;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横1
	t_start_x = 460;
	t_start_y = 490;
	t_end_x = 514;//生成起点
	t_end_y = 490;
	t_dis_x = 15;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横2
	t_start_x = 446;
	t_start_y = 440;
	t_end_x = 526;//生成起点
	t_end_y = 440;
	t_dis_x = 16;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横3
	t_start_x = 570;
	t_start_y = 518;
	t_end_x = 734;//生成起点
	t_end_y = 518;
	t_dis_x = 16;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横4
	t_start_x = 610;
	t_start_y = 460;
	t_end_x = 744;//生成起点
	t_end_y = 460;
	t_dis_x = 16;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//竖
	t_start_x = 470;
	t_start_y = 480;
	t_end_x = 470;//生成起点
	t_end_y = 300;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//12
	t_start_x = 490;
	t_start_y = 320;
	t_end_x = 530;//生成起点
	t_end_y = 340;
	t_dis_x = 16;
	t_dis_y = -10;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//13
	t_start_x = 620;
	t_start_y = 580;
	t_end_x = 740;//生成起点
	t_end_y = 300;
	t_dis_x = 3;
	t_dis_y = 10;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//14
	t_start_x = 690;
	t_start_y = 570;
	t_end_x = 720;//生成起点
	t_end_y = 544;
	t_dis_x = 13;
	t_dis_y = 18;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	//24
	t_start_x = 620;
	t_start_y = 330;
	t_end_x = 760;//生成起点
	t_end_y = 450;
	t_dis_x = 10;
	t_dis_y = -13;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//
	return t_fish_index;

}

//
int BuildSceneKind1Trace_shu(float start_x, float start_y, int index, FPoint *fish_pos) //119
{
	int   t_fish_index = index;
	float t_start_x = 0;//生成起点
	float t_start_y = 0;

	float t_end_x = 0;//生成起点
	float t_end_y = 0;

	float t_dis_x = 0;
	float t_dis_y = 0;
	int   t_num = 0;
	//树
	//横1
	t_start_x = 440;
	t_start_y = 510;
	t_end_x = 600;//生成起点
	t_end_y = 510;
	t_dis_x = 15;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横2
	t_start_x = 720;
	t_start_y = 510;
	t_end_x = 890;//生成起点
	t_end_y = 510;
	t_dis_x = 15;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//横3
	t_start_x = 610;
	t_start_y = 470;
	t_end_x = 720;//生成起点
	t_end_y = 470;
	t_dis_x = 15;
	t_dis_y = 0;
	t_num = (t_end_x - t_start_x) / t_dis_x;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//竖1
	t_start_x = 510;
	t_start_y = 554;
	t_end_x = 510;//生成起点
	t_end_y = 300;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//竖2
	t_start_x = 840;
	t_start_y = 550;
	t_end_x = 840;//生成起点
	t_end_y = 300;
	t_dis_x = 0;
	t_dis_y = 12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//11
	t_start_x = 430;
	t_start_y = 394;
	t_end_x = 500;//生成起点
	t_end_y = 520;
	t_dis_x = 7;
	t_dis_y = -12;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//12

	t_start_x = 620;
	t_start_y = 340;
	t_end_x = 680;//生成起点
	t_end_y = 480;
	t_dis_x = 5;
	t_dis_y = -10;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);
	//*/
	//21
	t_start_x = 520;
	t_start_y = 495;
	t_end_x = 620;//生成起点
	t_end_y = 400;
	t_dis_x = 6;
	t_dis_y = 10;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//22
	t_start_x = 600;
	t_start_y = 470;
	t_end_x = 700;//生成起点
	t_end_y = 340;
	t_dis_x = 6;
	t_dis_y = 10;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//23
	t_start_x = 780;
	t_start_y = 460;
	t_end_x = 790;//生成起点
	t_end_y = 420;
	t_dis_x = 8;
	t_dis_y = 18;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);

	//24
	t_start_x = 800;
	t_start_y = 350;
	t_end_x = 790;//生成起点
	t_end_y = 320;
	t_dis_x = 10;
	t_dis_y = 13;
	t_num = (t_start_y - t_end_y) / t_dis_y;
	t_fish_index += Build_Spec_Fish(t_start_x + start_x, 768 - t_start_y + start_y, t_dis_x, t_dis_y, t_num, t_fish_index, fish_pos);


	//
	return t_fish_index;

}




void BuildSceneKind1Trace2(float screen_width, float screen_height)
{
	
	if (scene_kind_1_trace2_[0].size() > 0)return;
	int fish_count = 0;
	const float kVScale = screen_height / kResolutionHeight;
	const float kRadius = (screen_height - (240 * kVScale)) / 2;
	float kSpeed = 2.0f * screen_width / kResolutionWidth;
	float CHeight = float(screen_height - 768) / 2.0f;
	SceneMovSpeed1 = kSpeed;
	//kSpeed = 1;
	FPoint fish_pos[500];
	fish_count = BuildSceneKind1Trace_yao(100, 20, fish_count, fish_pos);
	fish_count = BuildSceneKind1Trace_qian(100, 20, fish_count, fish_pos);
	fish_count = BuildSceneKind1Trace_shu(-500, 20, fish_count, fish_pos);
	//340+6
	//金龟 21 
	fish_pos[fish_count].x = 1200;
	fish_pos[fish_count].y = 60;
	fish_count++;
	fish_pos[fish_count].x = 1200;
	fish_pos[fish_count].y = 640;
	fish_count++;

	//银龟 19
	fish_pos[fish_count].x = 670;
	fish_pos[fish_count].y = 60;
	fish_count++;
	fish_pos[fish_count].x = 670;
	fish_pos[fish_count].y = 640;
	fish_count++;
	//金鲨 17
	fish_pos[fish_count].x = 150;
	fish_pos[fish_count].y = 60;
	fish_count++;
	fish_pos[fish_count].x = 150;
	fish_pos[fish_count].y = 640;
	fish_count++;
	//printf("fish_count=%d ,CHeight=%f\n",fish_count,CHeight);
	if (fish_count>360)fish_count = 346;
	//显示测试
	// 	for(int i=0;i<fish_count;i++)
	// 	{
	// 		ani_fish_->Render(fish_pos[i].x,fish_pos[i].y+CHeight);
	// 	}
	//
	float init_x[2], init_y[2];
	//float fish_index=0;
	for (int i = 0; i < 340; ++i)
	{
		init_x[0] = fish_pos[i].x - 1366;
		init_y[0] = fish_pos[i].y;
		init_x[1] = screen_width + 40;
		init_y[1] = fish_pos[i].y;
		ChangToGLPos(init_x[0], init_y[0]);
		ChangToGLPos(init_x[1], init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[i], kSpeed);
	}
	for (int i = 340; i < 346; ++i)
	{
		init_x[0] = fish_pos[i].x - 1366;
		init_y[0] = fish_pos[i].y;
		init_x[1] = screen_width + 170;
		init_y[1] = fish_pos[i].y;
		ChangToGLPos(init_x[0], init_y[0]);
		ChangToGLPos(init_x[1], init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[i], kSpeed);
	}



	/*int fish_count = 0;
	const float kVScale = screen_height / kResolutionHeight;
	const float kRadius = (screen_height - (240 * kVScale)) / 2;
	const float kSpeed = 1.5f * screen_width / kResolutionWidth;
	FPoint fish_pos[100];
	FPoint center;
	FPoint center1;
	center.x = screen_width + kRadius+50;
	center.y = kRadius + 120 * kVScale;
	center1=center;
	ChangToGLPos(center1.x, center1.y);
	MathAide::BuildCircle(center1.x, center1.y, kRadius, fish_pos, 100);
	float init_x[2], init_y[2];
	for (int i = 0; i < 100; ++i)
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = -2 * kRadius;
		init_y[1] = init_y[0];
        ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[i], kSpeed);
	}
	fish_count += 100;*/

	//const float kRotateRadian1 = 45 * M_PI / 180;
	//const float kRotateRadian2 = 135 * M_PI / 180;
	//const float kRadiusSmall = kRadius / 2;
	//const float kRadiusSmall1 = kRadius / 3;
	//FPoint center_small[4];
	//center_small[0].x = center.x + kRadiusSmall * cosf(-kRotateRadian2);
	//center_small[0].y = center.y + kRadiusSmall * sinf(-kRotateRadian2);
	//center_small[1].x = center.x + kRadiusSmall * cosf(-kRotateRadian1);
	//center_small[1].y = center.y + kRadiusSmall * sinf(-kRotateRadian1);
	//center_small[2].x = center.x + kRadiusSmall * cosf(kRotateRadian2);
	//center_small[2].y = center.y + kRadiusSmall * sinf(kRotateRadian2);
	//center_small[3].x = center.x + kRadiusSmall * cosf(kRotateRadian1);
	//center_small[3].y = center.y + kRadiusSmall * sinf(kRotateRadian1);
	//ChangToGLPos(center_small[0].x, center_small[0].y);
	//MathAide::BuildCircle(center_small[0].x, center_small[0].y, kRadiusSmall1, fish_pos, 17);
	//for (int i = 0; i < 17; ++i)
	//{
	//	init_x[0] = fish_pos[i].x;
	//	init_y[0] = fish_pos[i].y;
	//	init_x[1] = -2 * kRadius;
	//	init_y[1] = init_y[0];
	//	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count + i], kSpeed);
	//}
	//fish_count += 17;
	//ChangToGLPos(center_small[1].x, center_small[1].y);
	//MathAide::BuildCircle(center_small[1].x, center_small[1].y, kRadiusSmall1, fish_pos, 17);
	//for (int i = 0; i < 17; ++i)
	//{
	//	init_x[0] = fish_pos[i].x;
	//	init_y[0] = fish_pos[i].y;
	//	init_x[1] = -2 * kRadius;
	//	init_y[1] = init_y[0];
	//	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count + i], kSpeed);
	//}
	//fish_count += 17;
	//ChangToGLPos(center_small[2].x, center_small[2].y);
	//MathAide::BuildCircle(center_small[2].x, center_small[2].y, kRadiusSmall1, fish_pos, 30);
	//for (int i = 0; i < 30; ++i)
	//{
	//	init_x[0] = fish_pos[i].x;
	//	init_y[0] = fish_pos[i].y;
	//	init_x[1] = -2 * kRadius;
	//	init_y[1] = init_y[0];
	//	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count + i], kSpeed);
	//}
	//fish_count += 30;
	//ChangToGLPos(center_small[3].x, center_small[3].y);
	//MathAide::BuildCircle(center_small[3].x, center_small[3].y, kRadiusSmall1, fish_pos, 30);
	//for (int i = 0; i < 30; ++i)
	//{
	//	init_x[0] = fish_pos[i].x;
	//	init_y[0] = fish_pos[i].y;
	//	init_x[1] = -2 * kRadius;
	//	init_y[1] = init_y[0];
	//	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count + i], kSpeed);
	//}
	//fish_count += 30;
	//center1=center;
	//ChangToGLPos(center1.x, center1.y);
	//MathAide::BuildCircle(center1.x, center1.y, kRadiusSmall / 2, fish_pos, 15);
	//for (int i = 0; i < 15; ++i)
	//{
	//	init_x[0] = fish_pos[i].x;
	//	init_y[0] = fish_pos[i].y;
	//	init_x[1] = -2 * kRadius;
	//	init_y[1] = init_y[0];
	//	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count + i], kSpeed);
	//}
	//fish_count += 15;

	//init_x[0] = center.x;
	//init_y[0] = center.y;
	//init_x[1] = -2 * kRadius;
	//init_y[1] = init_y[0];
	//MathAide::BuildLinear(init_x, init_y, 2, scene_kind_1_trace2_[fish_count], kSpeed);
	//for (TraceVector::iterator iter = scene_kind_1_trace2_[fish_count].begin(); iter != scene_kind_1_trace2_[fish_count].end(); ++iter) {
	//	(*iter).angle = -M_PI_2;//.f;
	//}
	//fish_count += 1;
}

void BuildSceneKind2Trace2(float screen_width, float screen_height) {
	if (scene_kind_2_trace2_[0].size() > 0)return;
	const float kHScale = screen_width / kResolutionWidth;
	const float kVScale = screen_height / kResolutionHeight;
	const float kStopExcursion = 180.f * kVScale;
	const float kHExcursion = 27.f * kHScale / 2;
	const float kSmallFishInterval = (screen_width - kHExcursion * 2) / 100;
	float kSmallFishHeight = 65.f * kVScale;
	const float kSpeed = 3.f * kHScale;

	int fish_count = 0;
	float init_x[2], init_y[2];
	int small_height = (int)kSmallFishHeight * 3;
	for (int i = 0; i < 200; ++i)
	{
		init_x[0] = init_x[1] = kHExcursion + (i % 100) * kSmallFishInterval;
		int excursion = rand() % small_height;
		/*if (i < 100) {
		init_y[0] = -kSmallFishHeight - excursion;
		init_y[1] = screen_height + kSmallFishHeight;
		} else {
		init_y[0] = screen_height + kSmallFishHeight + excursion;
		init_y[1] = -kSmallFishHeight;
		}*/
		// 这个地方如果写成上方注释的那样（也就是kSmallFishHeight这个值）,后面的BuildLinear只能生成2个也就是init_x,init_y这2个点的值 写成65.f * kVScale也是一样
		// 只能写成下面的65.f的这个具体数字才正常,而且这种情况只出现在release的情况下,DEBUG下上面那样写是正常的.可能是VS2003的BUG? 因为我用VS2008测试release情况
		// 也是没问题的,或者是其他原因???
		if (i<100)//上排
		{
			init_y[0] = -65.f - excursion;
			init_y[1] = screen_height + 65.f;
		}
		else //下排
		{
			init_y[0] = screen_height + 65.f + excursion;
			init_y[1] = -65.f;
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_2_trace2_[i], kSpeed);
	}
	fish_count += 200;
	//大鱼
	float big_fish_width[7] = { 270 * kHScale, 226 * kHScale, 375 * kHScale, 420 * kHScale, 540 * kHScale, 454 * kHScale, 600 * kHScale };
	float big_fish_excursion[7];
	for (int i = 0; i < 7; ++i) 
	{
		big_fish_excursion[i] = big_fish_width[i];
		for (int j = 0; j < i; ++j) 
		{
			big_fish_excursion[i] += big_fish_width[j];
		}
	}
	float y_excursoin = 250 * kVScale / 2;

	for (int i = 0; i < 14; ++i) 
	{
		if (i < 7) 
		{
			init_y[0] = init_y[1] = screen_height / 2 - y_excursoin;
			init_x[0] = -big_fish_excursion[i % 7];
			init_x[1] = screen_width + big_fish_width[i % 7];
			ChangToGLPos(init_x[0],init_y[0]);
			ChangToGLPos(init_x[1],init_y[1]);
			MathAide::BuildLinear(init_x, init_y, 2, scene_kind_2_trace2_[fish_count + i], kSpeed);
		}
		else
		{
			init_y[0] = init_y[1] = screen_height / 2 + y_excursoin;
			init_x[0] = screen_width + big_fish_excursion[i % 7];
			init_x[1] = -big_fish_width[i % 7];
			ChangToGLPos(init_x[0],init_y[0]);
			ChangToGLPos(init_x[1],init_y[1]);
			MathAide::BuildLinear(init_x, init_y, 2, scene_kind_2_trace2_[fish_count + i], kSpeed);
		}
	}

	std::vector<FPointAngle> small_fish_trace;
	init_x[0] = init_x[1] = 0.f;
	init_y[0] = -2 * kSmallFishHeight;
	init_y[1] = kStopExcursion;
	ChangToGLPos(init_x[0],init_y[0]);
	ChangToGLPos(init_x[1],init_y[1]);
	MathAide::BuildLinear(init_x, init_y, 2, small_fish_trace, kSpeed);

	std::vector<FPointAngle> big_fish_trace;
	init_y[0] = init_y[1] = 0.f;
	init_x[0] = -big_fish_excursion[6];
	init_x[1] = screen_width + big_fish_width[6];
	ChangToGLPos(init_x[0],init_y[0]);
	ChangToGLPos(init_x[1],init_y[1]);
	MathAide::BuildLinear(init_x, init_y, 2, big_fish_trace, kSpeed);
	//小鱼调整
	std::vector<FPointAngle>::size_type big_stop_count = 0;
	for (int i = 0; i < 200; ++i)
	{
		for (std::vector<FPointAngle>::size_type j = 0; j < scene_kind_2_trace2_[i].size(); ++j)
		{
			FPointAngle& pos = scene_kind_2_trace2_[i][j];
			//和PC坐标反向
			if (i > 100) 
			{
				if (pos.y >= kStopExcursion)//停止点
				{
					scene_kind_2_small_fish_stop_index2_[i] = j;
					if (big_stop_count == 0) big_stop_count = j;
					else if (big_stop_count < j) big_stop_count = j;
					break;
				}
			}
			else
			{
				if (pos.y < screen_height - kStopExcursion) 
{
					scene_kind_2_small_fish_stop_index2_[i] = j;
					if (big_stop_count == 0) big_stop_count = j;
					else if (big_stop_count < j) big_stop_count = j;
					break;
				}
			}
		}
	}

	scene_kind_2_small_fish_stop_count2_ = big_fish_trace.size();
	scene_kind_2_big_fish_stop_index2_ = 0;
	scene_kind_2_big_fish_stop_count2_ = big_stop_count + 1;
}

void BuildSceneKind3Trace2(float screen_width, float screen_height) {
	if (scene_kind_3_trace2_[0].size() > 0)return;
	int fish_count = 0;
	const float kVScale = screen_height / kResolutionHeight;
	const float kRadius = (screen_height - (240 * kVScale)) / 2;
	const float kSpeed = 1.5f * screen_width / kResolutionWidth;
	FPoint fish_pos[100];
	FPoint center;
	center.x = screen_width + kRadius;
	center.y = kRadius + 120 * kVScale;
	MathAide::BuildCircle(center.x, center.y, kRadius, fish_pos, 50);
	float init_x[2], init_y[2];
	for (int i = 0; i < 50; ++i) 
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = -2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[i], kSpeed);
	}
	fish_count += 50;

	MathAide::BuildCircle(center.x, center.y, kRadius * 40 / 50, fish_pos, 40);
	for (int i = 0; i < 40; ++i) 
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = -2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count + i], kSpeed);
	}
	fish_count += 40;

	MathAide::BuildCircle(center.x, center.y, kRadius * 30 / 50, fish_pos, 30);
	for (int i = 0; i < 30; ++i)
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = -2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count + i], kSpeed);
	}
	fish_count += 30;

	init_x[0] = center.x;
	init_y[0] = center.y;
	init_x[1] = -2 * kRadius;
	init_y[1] = init_y[0];
	ChangToGLPos(init_x[0],init_y[0]);
	ChangToGLPos(init_x[1],init_y[1]);
	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count], kSpeed);
	fish_count += 1;

	center.x = -kRadius;
	MathAide::BuildCircle(center.x, center.y, kRadius, fish_pos, 50);
	for (int i = 0; i < 50; ++i) 
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = screen_width + 2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count + i], kSpeed);
	}
	fish_count += 50;

	MathAide::BuildCircle(center.x, center.y, kRadius * 40 / 50, fish_pos, 40);
	for (int i = 0; i < 40; ++i)
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = screen_width + 2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count + i], kSpeed);
	}
	fish_count += 40;

	MathAide::BuildCircle(center.x, center.y, kRadius * 30 / 50, fish_pos, 30);
	for (int i = 0; i < 30; ++i)
	{
		init_x[0] = fish_pos[i].x;
		init_y[0] = fish_pos[i].y;
		init_x[1] = screen_width + 2 * kRadius;
		init_y[1] = init_y[0];
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count + i], kSpeed);
	}
	fish_count += 30;

	init_x[0] = center.x;
	init_y[0] = center.y;
	init_x[1] = screen_width + 2 * kRadius;
	init_y[1] = init_y[0];
	ChangToGLPos(init_x[0],init_y[0]);
	ChangToGLPos(init_x[1],init_y[1]);
	MathAide::BuildLinear(init_x, init_y, 2, scene_kind_3_trace2_[fish_count], kSpeed);
	fish_count += 1;
}

void BuildSceneKind4Trace2(float screen_width, float screen_height)
{
	if (scene_kind_4_trace2_[0].size() > 0)return;
	const float kHScale = screen_width / kResolutionWidth;
	const float kVScale = screen_height / kResolutionHeight;
	const float kSpeed = 3.f * kHScale;
	const float kFishWidth = 512 * kHScale;
	const float kFishHeight = 304 * kVScale;
	int fish_count = 0;
	float init_x[2], init_y[2];
	// 左下
	FPoint start_pos = { 0.f, screen_height - kFishHeight / 2 };
	FPoint target_pos = { screen_width - kFishHeight / 2, 0.f };
	float angle = acosf((target_pos.x - start_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	float radius = kFishWidth * 4;
	float length = radius + kFishWidth / 2.f;
	FPoint center_pos;
	center_pos.x = -length * cosf(angle);
	center_pos.y = start_pos.y + length * sinf(angle);
	init_x[1] = target_pos.x + kFishWidth;
	init_y[1] = target_pos.y - kFishHeight;
	for (int i = 0; i < 8; ++i)
	{
		if (radius < 0.f)
		{
			init_x[0] = center_pos.x + radius * cosf(angle);
			init_y[0] = center_pos.y - radius * sinf(angle);
		} 
		else 
		{
			init_x[0] = center_pos.x - radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y + radius * sinf(angle + M_PI);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;
	start_pos.x = kFishHeight / 2;
	start_pos.y = screen_height;
	target_pos.x = screen_width;
	target_pos.y = kFishHeight / 2;
	angle = acosf((target_pos.x - start_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x - length * cosf(angle);
	center_pos.y = start_pos.y + length * sinf(angle);
	init_x[1] = target_pos.x + kFishWidth;
	init_y[1] = target_pos.y - kFishHeight;
	for (int i = 0; i < 8; ++i) 
	{
		if (radius < 0.f)
		{
			init_x[0] = center_pos.x + radius * cosf(angle);
			init_y[0] = center_pos.y - radius * sinf(angle);
		} 
		else 
		{
			init_x[0] = center_pos.x - radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y + radius * sinf(angle + M_PI);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	// 右下
	start_pos.x = screen_width - kFishHeight / 2;
	start_pos.y = screen_height;
	target_pos.x = 0.f;
	target_pos.y = kFishHeight / 2;
	angle = acosf((start_pos.x - target_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x + length * cosf(angle);
	center_pos.y = start_pos.y + length * sinf(angle);
	init_x[1] = target_pos.x - kFishWidth;
	init_y[1] = target_pos.y - kFishHeight;
	for (int i = 0; i < 8; ++i)
	{
		if (radius < 0.f) 
		{
			init_x[0] = center_pos.x - radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y - radius * sinf(angle + M_PI);
		} else {
			init_x[0] = center_pos.x - radius * cosf(angle);
			init_y[0] = center_pos.y - radius * sinf(angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	start_pos.x = screen_width;
	start_pos.y = screen_height - kFishHeight / 2;
	target_pos.x = kFishHeight / 2;
	target_pos.y = 0.f;
	angle = acosf((start_pos.x - target_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x + length * cosf(angle);
	center_pos.y = start_pos.y + length * sinf(angle);
	init_x[1] = target_pos.x - kFishWidth;
	init_y[1] = target_pos.y - kFishHeight;
	for (int i = 0; i < 8; ++i) 
	{
		if (radius < 0.f)
		{
			init_x[0] = center_pos.x - radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y - radius * sinf(angle + M_PI);
		} 
		else
		{
			init_x[0] = center_pos.x - radius * cosf(angle);
			init_y[0] = center_pos.y - radius * sinf(angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	// 右上
	start_pos.x = screen_width;
	start_pos.y = kFishHeight / 2;
	target_pos.x = kFishHeight / 2;
	target_pos.y = screen_height;
	angle = acosf((start_pos.x - target_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x + length * cosf(angle);
	center_pos.y = start_pos.y - length * sinf(angle);
	init_x[1] = target_pos.x - kFishWidth;
	init_y[1] = target_pos.y + kFishHeight;
	for (int i = 0; i < 8; ++i)
	{
		if (radius < 0.f) 
		{
			init_x[0] = center_pos.x - radius * cosf(-angle - M_PI);
			init_y[0] = center_pos.y - radius * sinf(-angle - M_PI);
		} 
		else 
		{
			init_x[0] = center_pos.x - radius * cosf(-angle);
			init_y[0] = center_pos.y - radius * sinf(-angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	start_pos.x = screen_width - kFishHeight / 2;
	start_pos.y = 0.f;
	target_pos.x = 0.f;
	target_pos.y = screen_height - kFishHeight / 2;
	angle = acosf((start_pos.x - target_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x + length * cosf(angle);
	center_pos.y = start_pos.y - length * sinf(angle);
	init_x[1] = target_pos.x - kFishWidth;
	init_y[1] = target_pos.y + kFishHeight;
	for (int i = 0; i < 8; ++i) 
	{
		if (radius < 0.f)
		{
			init_x[0] = center_pos.x - radius * cosf(-angle - M_PI);
			init_y[0] = center_pos.y - radius * sinf(-angle - M_PI);
		} else {
			init_x[0] = center_pos.x - radius * cosf(-angle);
			init_y[0] = center_pos.y - radius * sinf(-angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	// 左上
	start_pos.x = kFishHeight / 2;
	start_pos.y = 0.f;
	target_pos.x = screen_width;
	target_pos.y = screen_height - kFishHeight / 2;
	angle = acosf((target_pos.x - start_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x - length * cosf(angle);
	center_pos.y = start_pos.y - length * sinf(angle);
	init_x[1] = target_pos.x + kFishWidth;
	init_y[1] = target_pos.y + kFishHeight;
	for (int i = 0; i < 8; ++i) 
	{
		if (radius < 0.f) 
		{
			init_x[0] = center_pos.x + radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y + radius * sinf(angle + M_PI);
		} 
		else
		{
			init_x[0] = center_pos.x + radius * cosf(angle);
			init_y[0] = center_pos.y + radius * sinf(angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;

	start_pos.x = 0.f;
	start_pos.y = kFishHeight / 2;
	target_pos.x = screen_width - kFishHeight / 2;
	target_pos.y = screen_height;
	angle = acosf((target_pos.x - start_pos.x) / MathAide::CalcDistance(target_pos.x, target_pos.y, start_pos.x, start_pos.y));
	radius = kFishWidth * 4;
	length = radius + kFishWidth / 2.f;
	center_pos.x = start_pos.x - length * cosf(angle);
	center_pos.y = start_pos.y - length * sinf(angle);
	init_x[1] = target_pos.x + kFishWidth;
	init_y[1] = target_pos.y + kFishHeight;
	for (int i = 0; i < 8; ++i)
	{
		if (radius < 0.f) 
		{
			init_x[0] = center_pos.x + radius * cosf(angle + M_PI);
			init_y[0] = center_pos.y + radius * sinf(angle + M_PI);
		}
		else
		{
			init_x[0] = center_pos.x + radius * cosf(angle);
			init_y[0] = center_pos.y + radius * sinf(angle);
		}
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, scene_kind_4_trace2_[fish_count + i], kSpeed);
		radius -= kFishWidth;
	}
	fish_count += 8;
}

static float angle_range(float angle)
{
	while (angle <= -M_PI * 2) 
	{
		angle += M_PI * 2;
	}
	if (angle < 0.f) angle += M_PI * 2;
	while (angle >= M_PI * 2)
	{
		angle -= M_PI * 2;
	}
	return angle;
}

static void GetTargetPoint(float screen_width, float screen_height, float src_x_pos, float src_y_pos, float angle, float& target_x_pos, float& target_y_pos)
{
	//300 160
	angle = angle_range(angle);
	if (angle > 0.f && angle < M_PI_2) 
	{
		target_x_pos = screen_width + 300;
		target_y_pos = src_y_pos + (screen_width - src_x_pos + 300) * tanf(angle);
	}
	else if (angle >= M_PI_2 && angle < M_PI)
	{
		target_x_pos = -300;
		target_y_pos = src_y_pos - (src_x_pos + 300) * tanf(angle);
	} 
	else if (angle >= M_PI && angle < 3 * M_PI / 2.f)
	{
		target_x_pos = -300;
		target_y_pos = src_y_pos - (src_x_pos + 300) * tanf(angle);
	} 
	else
	{
		target_x_pos = screen_width + 300;
		target_y_pos = src_y_pos + (screen_width - src_x_pos + 300) * tanf(angle);
	}
}

void BuildSceneKind5Trace2(float screen_width, float screen_height)
{
	if (scene_kind_5_trace2_[0].size() > 0)return;
	int fish_count = 0;
	const float kVScale = screen_height / kResolutionHeight;
	const float kRadius = (screen_height - (200 * kVScale)) / 2;
	const float kRotateSpeed = 1.5f * M_PI / 180;
	const float kSpeed = 5.f * screen_width / kResolutionWidth;
	FPointAngle fish_pos[100];
	FPoint center[2];
	FPoint center1[2];
	center[0].x = screen_width / 4.f;
	center[0].y = kRadius + 100 * kVScale;
	center[1].x = screen_width - screen_width / 4.f;
	center[1].y = kRadius + 100 * kVScale;
	
	const float kLFish1Rotate = 720.f * M_PI / 180.f;
	const float kRFish2Rotate = (720.f + 90.f) * M_PI / 180.f;
	const float kRFish5Rotate = (720.f + 180.f) * M_PI / 180.f;
	const float kLFish3Rotate = (720.f + 180.f + 45.f) * M_PI / 180.f;
	const float kLFish4Rotate = (720.f + 180.f + 90.f) * M_PI / 180.f;
	const float kRFish6Rotate = (720.f + 180.f + 90.f + 30.f) * M_PI / 180.f;
	const float kRFish7Rotate = (720.f + 180.f + 90.f + 60.f) * M_PI / 180.f;
	const float kLFish6Rotate = (720.f + 180.f + 90.f + 60.f + 30.f) * M_PI / 180.f;
	const float kLFish18Rotate = (720.f + 180.f + 90.f + 60.f + 60.f) * M_PI / 180.f;
	const float kRFish17Rotate = (720.f + 180.f + 90.f + 60.f + 60.f + 30.f) * M_PI / 180.f;
	for (float rotate = 0.f; rotate <= kLFish1Rotate; rotate += kRotateSpeed) 
	{
		center1[0]=center[0];
		//center1[1]=center[1];
		ChangToGLPos(center1[0].x, center1[0].y);
		MathAide::BuildCircle(center1[0].x, center1[0].y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for (int j = 0; j < 40; ++j)
		{
			scene_kind_5_trace2_[j].push_back(fish_pos[j]);
		}
	}
	fish_count += 40;
	for (float rotate = 0.f; rotate <= kRFish2Rotate; rotate += kRotateSpeed)
	{
		//center1[0]=center[0];
		center1[1]=center[1];
		ChangToGLPos(center1[1].x, center1[1].y);
		MathAide::BuildCircle(center1[1].x, center1[1].y, kRadius, fish_pos, 40, rotate, kRotateSpeed);
		for (int j = 0; j < 40; ++j) 
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 40;

	for (float rotate = 0.f; rotate <= kRFish5Rotate; rotate += kRotateSpeed)
	{
		//center1[0]=center[0];
		center1[1]=center[1];
		ChangToGLPos(center1[1].x, center1[1].y);
		MathAide::BuildCircle(center1[1].x, center1[1].y, kRadius - 34.5f * kVScale, fish_pos, 40, rotate, kRotateSpeed);
		for (int j = 0; j < 40; ++j) 
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 40;
	for (float rotate = 0.f; rotate <= kLFish3Rotate; rotate += kRotateSpeed)
	{
		center1[0]=center[0];
		//center1[1]=center[1];
		ChangToGLPos(center1[0].x, center1[0].y);
		MathAide::BuildCircle(center1[0].x, center1[0].y, kRadius - 36.f * kVScale, fish_pos, 40, rotate, kRotateSpeed);
		for (int j = 0; j < 40; ++j)
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 40;

	for (float rotate = 0.f; rotate <= kLFish4Rotate; rotate += kRotateSpeed) 
	{
		center1[0]=center[0];
		//center1[1]=center[1];
		ChangToGLPos(center1[0].x, center1[0].y);
		MathAide::BuildCircle(center1[0].x, center1[0].y, kRadius - 36.f * kVScale - 56.f * kVScale, fish_pos, 24, rotate, kRotateSpeed);
		for (int j = 0; j < 24; ++j)
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 24;
	for (float rotate = 0.f; rotate <= kRFish6Rotate; rotate += kRotateSpeed) 
	{
		//center1[0]=center[0];
		center1[1]=center[1];
		ChangToGLPos(center1[1].x, center1[1].y);
		MathAide::BuildCircle(center1[1].x, center1[1].y, kRadius - 34.5f * kVScale - 58.5f * kVScale, fish_pos, 24, rotate, kRotateSpeed);
		for (int j = 0; j < 24; ++j) 
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 24;

	for (float rotate = 0.f; rotate <= kRFish7Rotate; rotate += kRotateSpeed) 
	{
		//center1[0]=center[0];
		center1[1]=center[1];
		ChangToGLPos(center1[1].x, center1[1].y);
		MathAide::BuildCircle(center1[1].x, center1[1].y, kRadius - 34.5f * kVScale - 58.5f * kVScale - 65.f * kVScale, fish_pos, 13, rotate, kRotateSpeed);
		for (int j = 0; j < 13; ++j) 
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 13;
	for (float rotate = 0.f; rotate <= kLFish6Rotate; rotate += kRotateSpeed)
	{
		center1[0]=center[0];
		//center1[1]=center[1];
		ChangToGLPos(center1[0].x, center1[0].y);
		MathAide::BuildCircle(center1[0].x, center1[0].y, kRadius - 36.f * kVScale - 56.f * kVScale - 68.f * kVScale, fish_pos, 13, rotate, kRotateSpeed);
		for (int j = 0; j < 13; ++j) 
		{
			scene_kind_5_trace2_[fish_count + j].push_back(fish_pos[j]);
		}
	}
	fish_count += 13;
	//大鱼
	for (float rotate = 0.f; rotate <= kLFish18Rotate; rotate += kRotateSpeed)
	{
		center1[0]=center[0];
		ChangToGLPos(center1[0].x, center1[0].y);
		fish_pos[0].x = center1[0].x;
		fish_pos[0].y = center1[0].y;
		fish_pos[0].angle = -M_PI_2 + rotate;
		scene_kind_5_trace2_[fish_count].push_back(fish_pos[0]);
	}
	fish_count += 1;

	for (float rotate = 0.f; rotate <= kRFish17Rotate; rotate += kRotateSpeed)
	{
		center1[1]=center[1];
		ChangToGLPos(center1[1].x, center1[1].y);
		fish_pos[0].x = center1[1].x;
		fish_pos[0].y = center1[1].y;
		fish_pos[0].angle = -M_PI_2 + rotate;
		scene_kind_5_trace2_[fish_count].push_back(fish_pos[0]);
	}
	fish_count += 1;
	//assert(fish_count == arraysize(scene_kind_5_trace2_));
	//离开
	float init_x[2], init_y[2];
	std::vector<FPointAngle> temp_vector;
	for (int i = 0; i < 236; ++i) 
	{
		FPointAngle& pos = scene_kind_5_trace2_[i].back();
		init_x[0] = pos.x;
		init_y[0] = pos.y;
		cocos2d::CCPoint t_pos = cocos2d::CCDirector::sharedDirector()->convertToUI(cocos2d::CCPointMake(init_x[0], init_y[0]));
		//CSize size=CCDirector::sharedDirector()->getVisibleSize();
		//x=t_pos.x;
		init_x[0]=t_pos.x;
		init_y[0]=t_pos.y;
		GetTargetPoint(screen_width, screen_height, t_pos.x, t_pos.y, pos.angle, init_x[1], init_y[1]);
		ChangToGLPos(init_x[0],init_y[0]);
		ChangToGLPos(init_x[1],init_y[1]);
		MathAide::BuildLinear(init_x, init_y, 2, temp_vector, kSpeed);
		temp_vector[0].angle = pos.angle;
		temp_vector[1].angle = pos.angle;
		std::copy(temp_vector.begin(), temp_vector.end(), std::back_inserter(scene_kind_5_trace2_[i]));
	}
}

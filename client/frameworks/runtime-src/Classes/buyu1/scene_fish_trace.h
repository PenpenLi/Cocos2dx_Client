
#ifndef SCENE_FISH_TRACE_H_
#define SCENE_FISH_TRACE_H_
#pragma once
#include <vector>
#include "math_aide.h"

const int  SCENE_KIND_1_TRACNENUM=210;
const int  SCENE_KIND_2_TRACNENUM = 200 + 7 * 2;
const int  SCENE_KIND_3_TRACNENUM = (50 + 40 + 30 + 1) * 2;
const int  SCENE_KIND_4_TRACNENUM = 8 * 8;
const int  SCENE_KIND_5_TRACNENUM = (40 + 40 + 24 + 13 + 1) * 2;

extern std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_index_[200];
extern std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_count_;
extern std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_index_;
extern std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_count_;
extern std::vector<FPointAngle> scene_kind_1_trace_[SCENE_KIND_1_TRACNENUM];
extern std::vector<FPointAngle> scene_kind_2_trace_[SCENE_KIND_2_TRACNENUM];
extern std::vector<FPointAngle> scene_kind_3_trace_[SCENE_KIND_3_TRACNENUM];
extern std::vector<FPointAngle> scene_kind_4_trace_[SCENE_KIND_4_TRACNENUM];
extern std::vector<FPointAngle> scene_kind_5_trace_[SCENE_KIND_5_TRACNENUM];

// 场景7.jpg
void BuildSceneKind1Trace(float screen_width, float screen_height);
// 场景5.jpg
void BuildSceneKind2Trace(float screen_width, float screen_height);
// 场景1.jpg
void BuildSceneKind3Trace(float screen_width, float screen_height);
// 场景6.jpg
void BuildSceneKind4Trace(float screen_width, float screen_height);
// 场景3.jpg
void BuildSceneKind5Trace(float screen_width, float screen_height);

#endif  // SCENE_FISH_TRACE_H_

#ifndef SCENE_FISH_TRACE2_H_
#define SCENE_FISH_TRACE2_H_
#pragma once
#include "math_aide.h"
#include <vector>

const int  SCENE_KIND_1_TRACNENUM2 = 346;
const int  SCENE_KIND_2_TRACNENUM2 = 200 + 7 * 2;
const int  SCENE_KIND_3_TRACNENUM2 = (50 + 40 + 30 + 1) * 2;
const int  SCENE_KIND_4_TRACNENUM2 = 8 * 8;
const int  SCENE_KIND_5_TRACNENUM2 = (40 + 40 + 24 + 13 + 1) * 2;

extern std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_index2_[200];
extern std::vector<FPointAngle>::size_type scene_kind_2_small_fish_stop_count2_;
extern std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_index2_;
extern std::vector<FPointAngle>::size_type scene_kind_2_big_fish_stop_count2_;
extern std::vector<FPointAngle> scene_kind_1_trace2_[SCENE_KIND_1_TRACNENUM2];
extern std::vector<FPointAngle> scene_kind_2_trace2_[SCENE_KIND_2_TRACNENUM2];
extern std::vector<FPointAngle> scene_kind_3_trace2_[SCENE_KIND_3_TRACNENUM2];
extern std::vector<FPointAngle> scene_kind_4_trace2_[SCENE_KIND_4_TRACNENUM2];
extern std::vector<FPointAngle> scene_kind_5_trace2_[SCENE_KIND_5_TRACNENUM2];

// ≥°æ∞7.jpg
void BuildSceneKind1Trace2(float screen_width, float screen_height);
// ≥°æ∞5.jpg
void BuildSceneKind2Trace2(float screen_width, float screen_height);
// ≥°æ∞1.jpg
void BuildSceneKind3Trace2(float screen_width, float screen_height);
// ≥°æ∞6.jpg
void BuildSceneKind4Trace2(float screen_width, float screen_height);
// ≥°æ∞3.jpg
void BuildSceneKind5Trace2(float screen_width, float screen_height);

void BuildQueeFishTrace0(float screen_width, float screen_height);
//’Ê“°«Æ ˜”„’ÛπÏº£1
void BuildQueeFishTrace1(float screen_width, float screen_height);
//
void BuildSceneKind1Trace_YQS(float screen_width, float screen_height);

#endif  // SCENE_FISH_TRACE2_H_
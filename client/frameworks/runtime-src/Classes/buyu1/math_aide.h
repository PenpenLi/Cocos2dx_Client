
#ifndef MATH_AIDE_H_
#define MATH_AIDE_H_
#pragma once

#include <vector>

struct FPoint {
	float x;
	float y;
};

struct FPointAngle {
	float x;
	float y;
	float angle;
};


class TraceVector{
public:
	TraceVector(std::vector<FPointAngle>* v) :m_trace(v){}
	~TraceVector(){ delete m_trace; }
	FPointAngle& Index(int i){ return (*m_trace)[i]; }
	int Size(){ return m_trace->size(); }
private:
	std::vector<FPointAngle>* m_trace;
};

class PointVector{
public:
	PointVector(std::vector<FPoint>* v) :m_trace(v){}
	~PointVector(){ delete m_trace; }
	FPoint& Index(int i){ return (*m_trace)[i]; }
	int Size(){ return m_trace->size(); }
private:
	std::vector<FPoint>* m_trace;
};

class MathAide
{
private:
  MathAide();

public:
  static void GetTargetPoint(float src_x_pos, float src_y_pos, float angle, float& target_x_pos, float& target_y_pos);
  static void GetReboundTargetPoint(float src_x_pos, float src_y_pos, float angle, float& target_x_pos, float& target_y_pos, int direction);
  static int Factorial(int number);
  static int Combination(int count, int r);
  static float CalcDistance(float x1, float y1, float x2, float y2);
  static float CalcAngle(float x1, float y1, float x2, float y2);
  static void BuildLinear(float init_x[], float init_y[], int init_count, std::vector<FPoint>& trace_vector, float distance);
  static void BuildLinear(float init_x[], float init_y[], int init_count, std::vector<FPointAngle>& trace_vector, float distance);
  static void BuildBezier(float init_x[], float init_y[], int init_count, std::vector<FPoint>& trace_vector, float distance);
  static void BuildBezierFast(float init_x[], float init_y[], int init_count, std::vector<FPoint>& trace_vector, float distance);
  static void BuildBezier(float init_x[], float init_y[], int init_count, std::vector<FPointAngle>& trace_vector, float distance);
  static void BuildCircle(float center_x, float center_y, float radius, FPoint* fish_pos, int fish_count);
  static void BuildCircle(float center_x, float center_y, float radius, FPointAngle* fish_pos, int fish_count, float rotate = 0.f, float rotate_speed = 0.f);
};

#endif // MATH_AIDE_H_

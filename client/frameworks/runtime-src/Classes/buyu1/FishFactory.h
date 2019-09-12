#pragma once

#include <queue>
#include "lock.h"
#include "math_aide.h"
#include "cocos2d.h"

using namespace std;

struct FishInfo{
	int fishkind;
	int fishid;
	float fishspeed;
	float init_x_pos[3];
	float init_y_pos[3];
	int init_count;
	int trace_type;
};

struct TraceInfo{
	int fishkind;
	int fishid;
	TraceVector* trace;

	~TraceInfo(){ if (trace) delete trace; }
};

typedef queue<FishInfo*>  NET_FISHINFO_QUEUE;
typedef queue<TraceInfo*>  NET_TRACEINFO_QUEUE;

class FishFactory : public cocos2d::Ref
{
public:
	FishFactory(){
		memset(&m_ThreadId, 0, sizeof(m_ThreadId));
		m_pSendQueue = NULL;
		m_pRecvQueue = NULL;
		bStart = false;
		m_luaCbFun = -1;
	}

	static FishFactory *m_pFactory;
	static FishFactory *getInstance();

	void Start();
	void Stop();

	/*! 供消费者使用的接口 */
	NET_FISHINFO_QUEUE* get_send_queue_ptr();
	NET_TRACEINFO_QUEUE* get_recv_queue_ptr();

	/*! 供供给生产者使用的接口 */
	void    add_to_send_queue(FishInfo *);
	void    add_to_recv_queue(TraceInfo *);

	void    set_lua_cbfun(int funId);

	void onHandler(float dt);
private:
	pthread_t m_ThreadId;
	bool bStart;

	CMutex       m_startMtx;

	//收发数据的队列
	NET_FISHINFO_QUEUE      *m_pSendQueue;
	NET_TRACEINFO_QUEUE      *m_pRecvQueue;
	CMutex              m_sendMtx;
	CMutex              m_recvMtx;
	int             m_luaCbFun;

	static void *start_thread(void *);

	void reset_recv_queue();
	void reset_send_queue();
};


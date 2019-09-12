#include "FishFactory.h"
#include "scripting/lua-bindings/manual/CCLuaEngine.h"

#ifndef WIN32
#include <unistd.h>
#endif

// add support for android
#if defined(ANDROID)

#include "stdio.h"
#include "sys/types.h"
#include "sys/socket.h"

#endif

FishFactory *FishFactory::m_pFactory;
FishFactory *FishFactory::getInstance(){
	if (!m_pFactory) {
		m_pFactory = new FishFactory();
	}

	return m_pFactory;
}

void FishFactory::Start(){
	reset_recv_queue();
	reset_send_queue();
	bStart = true;
	pthread_create(&m_ThreadId, NULL, start_thread, this);
	cocos2d::Scheduler *pScheduler = cocos2d::Director::getInstance()->getScheduler();
	pScheduler->schedule(CC_SCHEDULE_SELECTOR(FishFactory::onHandler), this, 0, false);
}

void FishFactory::Stop(){
	bStart = false;
	cocos2d::Scheduler *pScheduler = cocos2d::Director::getInstance()->getScheduler();
	pScheduler->unschedule(CC_SCHEDULE_SELECTOR(FishFactory::onHandler), this);
}

void *FishFactory::start_thread(void *pArg){
	FishFactory *pThis = (FishFactory*)pArg;
	CAutolock lock(&pThis->m_startMtx);

	NET_FISHINFO_QUEUE*  pQueue = NULL;
	FishInfo *pFishInfo = NULL;

	while (pThis->bStart)
	{
		pQueue = pThis->get_send_queue_ptr();
		if (!pQueue){
#ifdef WIN32
			Sleep(16);
#else
			usleep(16000);
#endif
			continue;
		}

		while (!pQueue->empty() && pThis->bStart) {
			pFishInfo = (FishInfo*)pQueue->front();
			pQueue->pop();

			std::vector<FPointAngle>* trace = new std::vector<FPointAngle>();
			TraceInfo* ti = new TraceInfo();
			ti->trace = new TraceVector(trace);
			ti->fishid = pFishInfo->fishid;
			ti->fishkind = pFishInfo->fishkind;
			if (pFishInfo->trace_type == 0)
			{
				MathAide::BuildLinear(pFishInfo->init_x_pos, pFishInfo->init_y_pos, pFishInfo->init_count, *trace, pFishInfo->fishspeed);
			}
			else
			{
				MathAide::BuildBezier(pFishInfo->init_x_pos, pFishInfo->init_y_pos, pFishInfo->init_count, *trace, pFishInfo->fishspeed);
			}
			pThis->add_to_recv_queue(ti);
			delete pFishInfo;
		}

		while (!pQueue->empty())
		{
			pFishInfo = (FishInfo*)pQueue->front();
			pQueue->pop();
			delete pFishInfo;
		}
		delete pQueue;
	}

	return NULL;
}

void FishFactory::onHandler(float dt){
	static queue<TraceInfo*>* pQueue;
	if (!pQueue) {
		pQueue = get_recv_queue_ptr();
	}

	if (!pQueue) {
		return;
	}

	TraceInfo *pTraceInfo = NULL;
	while (!pQueue->empty()){
		pTraceInfo = (TraceInfo*)pQueue->front();
		//回调LUA
		cocos2d::LuaEngine::getInstance()->executeFishTraceFun(m_luaCbFun, pTraceInfo->fishkind, pTraceInfo->fishid, pTraceInfo->trace);
		pQueue->pop();
		pTraceInfo->trace = NULL;
		CC_SAFE_DELETE(pTraceInfo);
	}

	if (pQueue->empty()) {
		CC_SAFE_DELETE(pQueue);
	}
}

/*! 供消费者使用的接口 */
NET_FISHINFO_QUEUE* FishFactory::get_send_queue_ptr(){
	CAutolock lock(&m_sendMtx);
	if (!m_pSendQueue) {
		return NULL;
	}

	NET_FISHINFO_QUEUE* pRet = NULL;
	if (!m_pSendQueue->empty()) {
		pRet = m_pSendQueue;
		m_pSendQueue = new NET_FISHINFO_QUEUE;
	}

	return pRet;
}

NET_TRACEINFO_QUEUE* FishFactory::get_recv_queue_ptr(){
	CAutolock lock(&m_recvMtx);
	if (!m_pRecvQueue) {
		return NULL;
	}

	NET_TRACEINFO_QUEUE* pRet = NULL;
	if (!m_pRecvQueue->empty()) {
		pRet = m_pRecvQueue;
		m_pRecvQueue = new NET_TRACEINFO_QUEUE;
	}

	return pRet;
}

/*! 供供给生产者使用的接口 */
void    FishFactory::add_to_send_queue(FishInfo *sb){
	if (bStart == false) {
		delete sb;
		return;
	}
	CAutolock lock(&m_sendMtx);
	m_pSendQueue->push(sb);
}

void    FishFactory::add_to_recv_queue(TraceInfo *sb){
	CAutolock lock(&m_recvMtx);
	m_pRecvQueue->push(sb);
}

void    FishFactory::reset_send_queue()
{
	CAutolock lock(&m_sendMtx);
	if (m_pSendQueue) {
		while (!m_pSendQueue->empty()) {
			delete m_pSendQueue->front();
			m_pSendQueue->pop();
		}
		delete m_pSendQueue;
	}
	m_pSendQueue = new NET_FISHINFO_QUEUE;
}

void    FishFactory::reset_recv_queue()
{
	CAutolock lock(&m_recvMtx);
	if (m_pRecvQueue) {
		while (!m_pRecvQueue->empty()) {
			delete m_pRecvQueue->front();
			m_pRecvQueue->pop();
		}
		delete m_pRecvQueue;
	}
	m_pRecvQueue = new NET_TRACEINFO_QUEUE;
}

void    FishFactory::set_lua_cbfun(int funId){
	if (m_luaCbFun != -1)
		cocos2d::ScriptEngineManager::getInstance()->getScriptEngine()->removeScriptHandler(m_luaCbFun);
	m_luaCbFun = funId;
}

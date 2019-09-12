#include "lock.h"

CMutex::CMutex()
{
    pthread_mutex_init( &m_mutex, NULL );
}

CMutex::~CMutex()
{
    pthread_mutex_destroy( &m_mutex );
}

void CMutex::Lock() 
{
    pthread_mutex_lock( &m_mutex );
}

void CMutex::Unlock() 
{
    pthread_mutex_unlock( &m_mutex );
}

CAutolock::CAutolock(CMutex* m)
{
  m_plock = m;
  m_plock->Lock();
}

CAutolock::~CAutolock()
{
  m_plock->Unlock();
}
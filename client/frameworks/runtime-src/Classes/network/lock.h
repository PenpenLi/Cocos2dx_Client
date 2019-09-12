#ifndef __LOCK_HEADER__
#define __LOCK_HEADER__

#include <pthread.h>

class CMutex{
    public:
        CMutex();
        ~CMutex();

        void Lock() ;
        void Unlock() ;

    private:
        pthread_mutex_t m_mutex;
};


class CAutolock
{
    private:
        CMutex *m_plock;
    public:
        CAutolock(CMutex *);
        ~CAutolock();
};

#endif

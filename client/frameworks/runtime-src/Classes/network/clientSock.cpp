#include "clientSock.h"
#include "errno.h"
#include "assert.h"
#include <string.h>
#include "cocos2d.h"
#include "MapCoding.h"

#ifndef WIN32
#include <unistd.h>
#include "netdb.h"
#include <sys/ioctl.h>
#include "sys/types.h"
#include "sys/socket.h"
#else
#define ioctl ioctlsocket
#endif

#include "stdio.h"

#define OUTPUT_FUN CCLOG

clientSock* clientSock::m_pGtSock = new clientSock;
clientSock* clientSock::m_pGsSock = new clientSock;

char* clientSock::getIpByDomain(const char* domain)
{
	hostent* ht = gethostbyname(domain);
	char* pszIp = (char*)inet_ntoa(*(struct in_addr*)(ht->h_addr));

	return pszIp;
}

int clientSock::recv_len( int sock, char *recv_buf, int len )
{
    int need_len = len;
    int add_len = 0;
    char *p_buf = recv_buf;
    int ret = 1;
    while( true ) {
        add_len = recv( sock, p_buf, need_len, 0);
        //OUTPUT_FUN("[NET] recv leng:%d,need leng:%d\n",add_len,need_len);
        if( add_len <= 0 ){
            //OUTPUT_FUN("[NET] recv error: %s\r\n", strerror( errno ) );
            break;
        }
        need_len = need_len - add_len;
        p_buf += add_len;
        if( need_len == 0 ) {
            ret = 0;
            break;
        }
    }

    return ret;
}


NET_SEND_QUEUE*  clientSock::get_send_queue_ptr(){
    CAutolock lock(&m_sendMtx);
    if( !m_pSendQueue ) {
        return NULL;
    }
    
    NET_SEND_QUEUE* pRet = NULL;
    if( !m_pSendQueue->empty() ) {
        pRet = m_pSendQueue;
        m_pSendQueue = new NET_SEND_QUEUE;
    }
    
    return pRet;
}

NET_RECV_QUEUE*  clientSock::get_recv_queue_ptr(){
    CAutolock lock(&m_recvMtx);
    if( !m_pRecvQueue ) {
        return NULL;
    }
    
    NET_RECV_QUEUE* pRet = NULL;
    if( !m_pRecvQueue->empty() ) {
        pRet = m_pRecvQueue;
        m_pRecvQueue = new NET_RECV_QUEUE;
    }
    
    return pRet;
}

void    clientSock::add_to_send_queue( sendBuff *sb )
{
    //assert( is_conn() );
    ///*
    if( is_conn() == false ) {
        delete sb ;
        return;
    }
    //*/
    
    CAutolock lock(&m_sendMtx);
    m_pSendQueue->push( sb );
}

void    clientSock::reset_send_queue()
{
    CAutolock lock(&m_sendMtx);
    if( m_pSendQueue ) {
        while(!m_pSendQueue->empty()) {
            delete m_pSendQueue->front();
            m_pSendQueue->pop();
        }
        delete m_pSendQueue;
    }
    m_pSendQueue = new NET_SEND_QUEUE;
}

void    clientSock::add_to_recv_queue( recvBuff *sb )
{
    CAutolock lock(&m_recvMtx);
    m_pRecvQueue->push( sb );
}

void    clientSock::reset_recv_queue()
{
    CAutolock lock(&m_recvMtx);
    if( m_pRecvQueue ) {
        while(!m_pRecvQueue->empty()) {
            delete m_pRecvQueue->front();
            m_pRecvQueue->pop();
        }
        delete m_pRecvQueue;
    }
    m_pRecvQueue = new NET_RECV_QUEUE;
}

int clientSock::init( const char* ip, int port ){
	m_mapCode.Reset();

    memset( m_ip, 0, 32 );
    memcpy( m_ip, ip, strlen(ip) );
    m_port = port;
  
	memset(&m_sendThreadId, 0, sizeof(m_sendThreadId));
	memset(&m_recvThreadId, 0, sizeof(m_recvThreadId));
    
    pthread_t tid;
    pthread_create( &tid, NULL, start_thread, this );
    
    return 0;
}

void clientSock::close_socket(){
    shutdown(m_sock, 2);   
#ifdef WIN32
	closesocket(m_sock);
#else
	close(m_sock);
#endif
}

void clientSock::add_lost_recvbuf()
{
    recvBuff *pBuff = recvBuff::createLostRecvBuff();
    this->add_to_recv_queue( pBuff );
}


void clientSock::add_connfail_recvbuf()
{
    recvBuff *pBuff = recvBuff::createConnfailRecvBuff();
    this->add_to_recv_queue( pBuff );
}

void clientSock::add_connsucc_recvbuf()
{
    recvBuff *pBuff = recvBuff::createConnsuccRecvBuff();
    this->add_to_recv_queue( pBuff );
}

void setKeepAlive(int s)
{
	struct timeval tv;
	tv.tv_sec = 10;
	tv.tv_usec = 100000; // 0.1 sec
	setsockopt(s, SOL_SOCKET, SO_SNDTIMEO, (const char*)&tv, sizeof(tv));

#ifdef WIN32
	int keepalive = 1;
	int keepidle = 1;
	setsockopt(s, SOL_SOCKET, SO_KEEPALIVE, (const char*)&keepalive, sizeof(keepalive));

	tcp_keepalive alive_in = { 0 };
	tcp_keepalive alive_out = { 0 };
	alive_in.keepalivetime = 1000;
	alive_in.keepaliveinterval = 1000;
	alive_in.onoff = true;
	unsigned long ulBytesReturn = 0;
	
	WSAIoctl(s, SIO_KEEPALIVE_VALS, &alive_in, sizeof(alive_in), &alive_out, sizeof(alive_out), &ulBytesReturn, NULL, NULL);
#else
	int keepAlive = 1;
	int keepIdle = 1;
	int keepInterval = 1;
	int keepCount = 5;

	setsockopt(s, SOL_SOCKET, SO_KEEPALIVE, (void*)&keepAlive, sizeof(keepAlive));
#if defined(__APPLE__)
	setsockopt(s, IPPROTO_TCP, TCP_KEEPALIVE, (void*)&keepIdle, sizeof(keepIdle));
	setsockopt(s, IPPROTO_TCP, TCP_KEEPINTVL, (void*)&keepInterval, sizeof(keepInterval));
	setsockopt(s, IPPROTO_TCP, TCP_KEEPCNT, (void*)&keepCount, sizeof(keepCount));
#else
	setsockopt(s, SOL_TCP, TCP_KEEPIDLE, (void*)&keepIdle, sizeof(keepIdle));
	setsockopt(s, SOL_TCP, TCP_KEEPINTVL, (void*)&keepInterval, sizeof(keepInterval));
	setsockopt(s, SOL_TCP, TCP_KEEPCNT, (void*)&keepCount, sizeof(keepCount));
#endif
#endif
}

void* clientSock::start_thread( void* pArg ){
    OUTPUT_FUN("[NET] start_thread");
    clientSock *pThis = (clientSock*) pArg;
    CAutolock lock(&pThis->m_startMtx);
    if( pThis->b_Conn ) {
        return NULL;
    }

	pThis->reset_send_queue();
	pThis->reset_recv_queue();

	struct addrinfo *answer, hint;
	memset(&hint, 0, sizeof(hint));
	hint.ai_family = AF_UNSPEC;
	hint.ai_socktype = SOCK_STREAM;

	int ret = getaddrinfo(pThis->m_ip, NULL, &hint, &answer);
	if (ret != 0) {
		return NULL;
	}

	int ipv_family = 0;
	for (struct addrinfo *curr = answer; curr != NULL; curr = curr->ai_next) {
		if (curr->ai_family == AF_INET)
		{
			ipv_family = AF_INET;
		}
		else if (curr->ai_family == AF_INET6)
		{
			memset(pThis->m_ip, 0, sizeof(pThis->m_ip));

			struct sockaddr_in6* addr6 = (struct sockaddr_in6*)curr->ai_addr;
			inet_ntop(AF_INET6, &addr6->sin6_addr, pThis->m_ip, sizeof(pThis->m_ip));

			ipv_family = AF_INET6;
		}
	}
	freeaddrinfo(answer);

	unsigned long ul = 1;

	if (ipv_family == AF_INET)
	{
		//ipv4
		pThis->m_sock = socket(AF_INET, SOCK_STREAM, 0);
		if (pThis->m_sock < 0) {
			OUTPUT_FUN("[NET] create socket error:%s\r\n", strerror(errno));
			return NULL;
		}

		setKeepAlive(pThis->m_sock);

		struct sockaddr_in serv_addr;
		serv_addr.sin_family = AF_INET;
		serv_addr.sin_port = htons(pThis->m_port);
		serv_addr.sin_addr.s_addr = inet_addr(pThis->m_ip);

		ioctl(pThis->m_sock, FIONBIO, &ul);

		ret = connect(pThis->m_sock, (struct sockaddr*)&serv_addr, sizeof(struct sockaddr_in));
	}
	else if (ipv_family == AF_INET6)
	{
		//ipv6
		pThis->m_sock = socket(AF_INET6, SOCK_STREAM, 0);
		if (pThis->m_sock < 0) {
			OUTPUT_FUN("[NET] create socket error:%s\r\n", strerror(errno));
			return NULL;
		}

		setKeepAlive(pThis->m_sock);

		struct sockaddr_in6 serv_addr;
		memset(&serv_addr, 0, sizeof(serv_addr));
		serv_addr.sin6_family = AF_INET6;
		serv_addr.sin6_port = htons(pThis->m_port);
		if (inet_pton(AF_INET6, pThis->m_ip, &serv_addr.sin6_addr) < 0)
		{
			OUTPUT_FUN("[NET]ipv6 error addr!\n");
			return NULL;
		}

		ioctl(pThis->m_sock, FIONBIO, &ul);

		ret = connect(pThis->m_sock, (struct sockaddr*)&serv_addr, sizeof(struct sockaddr_in6));
	}

	bool success = false;
	if (ret == -1)
	{
		struct timeval tm;
		tm.tv_sec = 3;
		tm.tv_usec = 0;
		fd_set set;
		FD_ZERO(&set);
		FD_SET(pThis->m_sock, &set);
		if (select(pThis->m_sock + 1, NULL, &set, NULL, &tm) > 0)
		{
			int error = 0;
			int len = sizeof(int);
			getsockopt(pThis->m_sock, SOL_SOCKET, SO_ERROR, (char*)&error, (socklen_t *)&len);
			if (0 == error) success = true;
		}
		else
			success = false;
	}

	ul = 0;
	ioctl(pThis->m_sock, FIONBIO, &ul);

	if (success){
		OUTPUT_FUN("[NET] Connect Server Success [ip:%s:%d]!\n", pThis->m_ip, pThis->m_port);

		pThis->b_Conn = true;
		pThis->add_connsucc_recvbuf();
		ret = pthread_create( &pThis->m_sendThreadId, NULL, send_thread, pThis);
		ret = pthread_create( &pThis->m_recvThreadId, NULL, recv_thread, pThis);
        return NULL;
    }else {
		OUTPUT_FUN("[NET] Connect Server Fail [ip:%s:%d]!\n", pThis->m_ip, pThis->m_port);

		pThis->add_connfail_recvbuf();
		pThis->close_socket();
		return NULL;
    }
}

void*   clientSock::send_thread(void *pArg){
    clientSock *pClient = (clientSock*)pArg;
    //*
    //OUTPUT_FUN("[NET] clientSocket send thread start m_sock: %d threadid: 0x%08x self: 0x%08x", pClient->m_sock, pClient->m_sendThreadId, pthread_self());
    //*/
    
    NET_SEND_QUEUE*  pQueue = NULL;
    sendBuff *pBuff = NULL;
    char* pMem = NULL;
    int sendSize = 0;
    while( true ){
        
        if( !pClient->is_conn() ){
            goto t_exit_send;
        }
        
        pQueue = pClient->get_send_queue_ptr();
        if( !pQueue ){
#ifdef WIN32
			Sleep(100);
#else
            usleep(100000);
#endif
            continue;
        }

        while(!pQueue->empty()) {
            
            if( !pClient->is_conn() ){
                goto t_exit_send;
            }
            
            pBuff = (sendBuff*) pQueue->front();
            pQueue->pop();
            pBuff->get_mem( pMem, sendSize );

			const char* pSendData = (const char*)pClient->m_mapCode.Pack(pBuff->getMainCmd(), pBuff->getSubCmd(), (byte*)pMem, sendSize);
			TCP_Head* pHead = (TCP_Head *)pSendData;
			sendSize = pHead->TCPInfo.wPacketSize;

            int already_send = 0;
            int ret;
            while (already_send < sendSize) {
				ret = send(pClient->m_sock, pSendData + already_send, sendSize - already_send, 0);
                if( ret <=0 ){
                    OUTPUT_FUN("[NET] [ERROR] cient send thread error [%d]\n", ret);
                    if(pBuff){
                        delete pBuff;
                        pBuff = NULL;
                    }
                    goto t_exit_send;
                }
                already_send += ret;
            }
            if(pBuff){
                delete pBuff;
                pBuff = NULL;
            }
			if (pSendData){
				delete pSendData;
				pSendData = NULL;
			}
        }

        if(pQueue){
            delete pQueue;
            pQueue = NULL;
        }
    }

t_exit_send:
    pClient->on_lost( elostType_send );
    OUTPUT_FUN("[NET] clientSocket send thread exit\n");
    return NULL;
}

void*   clientSock::recv_thread(void *pArg){
    clientSock *pClient = (clientSock*)pArg;
    //*
    OUTPUT_FUN("[NET] clientSocket recv thread start m_sock: %d threadid: 0x%08x self: 0x%08x", pClient->m_sock, pClient->m_recvThreadId, pthread_self());
    //*/
    int len = 0;
    int real_len = 0;
	char* tmp_buff = NULL;
    recvBuff* sock_buff = NULL;

    while(1){
		char recv_buff[SOCKET_BUFFER];

		if (1 == recv_len(pClient->m_sock, (char*)recv_buff, sizeof(TCP_Head))) {
            OUTPUT_FUN("[NET] [ERROR] client recv thread error read head\n");
            break;
        }
		TCP_Head* head = (TCP_Head*)recv_buff;
		len = head->TCPInfo.wPacketSize;
		real_len = head->TCPInfo.wPacketSize - sizeof(TCP_Head);
		
		if (real_len > 0) {
			if (1 == recv_len(pClient->m_sock, (char*)recv_buff + sizeof(TCP_Head), real_len)) {
				OUTPUT_FUN("[NET] [ERROR] client recv thread error read custom data\n");
				//delete sock_buff;
				break;
			}
		}

		pClient->m_mapCode.UnPack((BYTE*)recv_buff, (WORD&)len);

		sock_buff = new recvBuff(real_len);
		sock_buff->setMainCmd(head->CommandInfo.wMainCmdID);
		sock_buff->setSubCmd(head->CommandInfo.wSubCmdID);
		char* pMen = NULL;
		sock_buff->getMem(pMen);
		memcpy(pMen, recv_buff + sizeof(TCP_Head), real_len);

		//OUTPUT_FUN("[NET] recv len: %d MainCmd: %d SubCmd: %d \r\n", len, sock_buff->getMainCmd(), sock_buff->getSubCmd());
        
        pClient->add_to_recv_queue( sock_buff );

    }

t_exit_recv:
    pClient->on_lost( elostType_recv );
    OUTPUT_FUN("[NET] clientSocket recv thread exit\r\n");
    return NULL;
}

void clientSock::on_lost( elostType type )
{
    CAutolock lock(&m_lostMtx);
    if( !b_Conn ){
        return;
    }
    
    b_Conn = false;
    
    if( type == elostType_send ) {
        
        int ret = pthread_kill( m_recvThreadId, 0 );
        if( ret!=0 ){
            ret = pthread_kill( m_recvThreadId, 9 );
        }

		memset(&m_recvThreadId, 0, sizeof(m_recvThreadId));
        
    } else {
        
        int ret = pthread_kill( m_sendThreadId, 0 );
        if( ret!=0 ){
            ret = pthread_kill( m_sendThreadId, 9 );
        }

        memset(&m_sendThreadId, 0, sizeof(m_sendThreadId));
    }
    add_lost_recvbuf();
}

int clientSock::set_lua_cbfun( int funId )
{
    m_luaCbFun = funId;
    return 0;
}

int clientSock::get_lua_cbfun() const {
    return m_luaCbFun;
}

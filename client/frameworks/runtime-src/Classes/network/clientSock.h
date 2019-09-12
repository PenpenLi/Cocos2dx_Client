#ifndef __HEADER_CLIENT_NET_
#define __HEADER_CLIENT_NET_

#include <queue>
#include "lock.h"
#include "sendBuff.h"
#include "recvBuff.h"
#include "MapCoding.h"
#ifdef WIN32
#include <WinSock2.h>
#include <ws2tcpip.h>
#include <mstcpip.h>
#else
#include <arpa/inet.h>
#include <netinet/tcp.h>
#endif

using namespace std;

typedef queue<sendBuff*>  NET_SEND_QUEUE;
typedef queue<recvBuff*>  NET_RECV_QUEUE;

enum elostType {
    elostType_send,
    elostType_recv,
};

class clientSock{
    
private:
    
    int m_sock;
    char m_ip[32];
    int m_port;
    
    char mem_check_a[512];
    pthread_t m_sendThreadId;
    pthread_t m_recvThreadId;
    char mem_check_b[512];
    
    int             m_luaCbFun;
    
    NET_SEND_QUEUE      *m_pSendQueue;
    NET_RECV_QUEUE      *m_pRecvQueue;
    CMutex              m_sendMtx;
    CMutex              m_recvMtx;
    
    
    CMutex       m_startMtx;
    CMutex       m_lostMtx;
 
    bool    b_Conn;
    
    void add_lost_recvbuf();
    void add_connfail_recvbuf();
    void add_connsucc_recvbuf();
public:
	MapCoding	m_mapCode;

public:
	void reset_recv_queue();
	void reset_send_queue();

    clientSock(){
#ifdef WIN32
		WSADATA wsaData;
        WSAStartup(MAKEWORD(2, 2),&wsaData);
#endif
		memset(&m_sendThreadId, 0, sizeof(m_sendThreadId));
		memset(&m_recvThreadId, 0, sizeof(m_recvThreadId));
        m_pSendQueue = NULL;
        m_pRecvQueue = NULL;
        b_Conn = false;
        for(int i=0;i<512; i++){
            mem_check_a[i] = 0;
            mem_check_b[i] = 0;
        }
    }
    
	static clientSock *m_pGtSock;
    static clientSock *m_pGsSock;
    
    int init(const char* ip, int port);
    void close_socket();
    static void *send_thread(void *);
    static void *recv_thread(void *);
    static void *start_thread(void *);
    static int recv_len( int sock, char* recv_buf, int len );

	static char* getIpByDomain(const char* domain);
    
    NET_SEND_QUEUE* get_send_queue_ptr();
    NET_RECV_QUEUE* get_recv_queue_ptr();
    
    void    add_to_send_queue( sendBuff *);
    void    add_to_recv_queue( recvBuff *);
    
    void    on_lost( elostType type );
    bool    is_conn()const{ return b_Conn; }
    
    int    set_lua_cbfun( int funId );
    int    get_lua_cbfun() const;
    
};


#endif

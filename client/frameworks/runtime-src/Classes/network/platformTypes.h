#ifndef __PLATFORM_TYPES_H__
#define __PLATFORM_TYPES_H__

#ifndef WIN32
typedef unsigned char 	BYTE;
typedef unsigned short 	WORD;
typedef unsigned int	UING;
typedef unsigned int 	DWORD;
typedef char			TCHAR;
typedef long			LONG;
//typedef int				BOOL;
typedef long long		__int64;
typedef DWORD			COLORREF;
typedef __int64			INT_PTR;
typedef unsigned int	DWORD_PTR;
typedef unsigned char byte;
#define AFX_INLINE		inline
#define interface       struct
#define FALSE			false
#define TRUE			true

#else
//warning C4005:
//#include <winsock2.h>

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif	//WIN32_LEAN_AND_MEAN

#include<windows.h>
//#pragma comment(lib,"pthreadcc//lib//x86//pthreadVCE2.lib")
//#pragma comment(lib,"websockets.lib")
//pthreadVCE2.lib
//
//
#endif	//WIN32
#define SOCKET_PACKAGE					65535
#define SOCKET_BUFFER					(16+SOCKET_PACKAGE)

#define SOCKET_TCP_BUFFER			SOCKET_PACKAGE
#define SOCKET_TCP_PACKET			(SOCKET_TCP_BUFFER-sizeof(TCP_Head))
typedef unsigned char byte;

struct TCP_Command
{
	WORD							wMainCmdID;
	WORD							wSubCmdID;
};

struct TCP_Info
{
	BYTE							cbDataKind;
	BYTE							cbCheckCode;
	WORD							wPacketSize;
};

struct TCP_Head
{
	TCP_Info				TCPInfo;
	TCP_Command				CommandInfo;
};

struct TCP_Buffer
{
	TCP_Head						Head;
	BYTE							cbBuffer[SOCKET_TCP_PACKET];
};
#endif
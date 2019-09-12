#include "sendBuff.h"
#include <string.h>
#include <stdio.h>
#include <string>
#include <stdlib.h>
#include <zlib.h>
#include "IconvString.h"
#include "cocos2d.h"

#ifdef WIN32
#include <WinSock2.h>
#else
#include <arpa/inet.h>
#endif

#define OUTPUT_FUN printf

sendBuff::sendBuff()
:m_bCanWrite(true)
{
    memset( m_pMem, 0, DEFAULT_MEM_SIZE );
    m_pBuffer = m_pMem;
    m_iBuffSize = DEFAULT_MEM_SIZE;
    m_pPointer = m_pMem;
}

sendBuff::~sendBuff(){
    if(m_pBuffer && m_pBuffer != m_pMem){
        //printf("==============> delete pmem addr: 0x%08x\r\n", m_pBuffer );
        delete[] m_pBuffer;
        m_pBuffer = NULL;
    }
}

void sendBuff::check_mem(int add_size){
    if( (m_pPointer + add_size) < (m_pBuffer + m_iBuffSize) ){
        return;
    }

    m_iBuffSize = m_iBuffSize*2 + add_size;
    char *m_new= new char[m_iBuffSize];
    memset( m_new, 0, m_iBuffSize );
    memcpy( m_new, m_pBuffer, m_pPointer-m_pBuffer ); 
    if( m_pBuffer != m_pMem ) {
        delete[] m_pBuffer;
    }else{
        memset( m_pBuffer, 0, DEFAULT_MEM_SIZE );
    }
    m_pPointer = m_new + (m_pPointer-m_pBuffer);
    m_pBuffer = m_new;
}

void    sendBuff::get_mem( char* &pMem, int& size )
{
    size = m_pPointer - m_pBuffer;
    pMem = m_pBuffer;
}

void    sendBuff::writeChar(const char val)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
    
	check_mem(sizeof(char));
	memcpy(m_pPointer, &val, sizeof(char));
	m_pPointer += sizeof(char);
}

void    sendBuff::writeShort(const short val)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
    
	check_mem(sizeof(short));
	memcpy(m_pPointer, &val, sizeof(short));
	m_pPointer += sizeof(short);
}

void    sendBuff::writeInt(const int val)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
    
	check_mem(sizeof(int));
	memcpy(m_pPointer, &val, sizeof(int));
	m_pPointer += sizeof(int);
}

void	sendBuff::writeInt64(const double val)
{
	if (!m_bCanWrite){
		//*
		OUTPUT_FUN("[NET] clientSocket can't write after pack!");
		return;
	}

	check_mem(8);
	//int rval = val;
	//memcpy(m_pPointer, &rval, sizeof(int));

	unsigned int top = val / 4294967296;
	unsigned int low = val - top * 4294967296;

	writeInt(low);
	writeInt(top);
    
    //m_pPointer += 8;
}

void    sendBuff::writeString(char* pStr, short len)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
	int realLen = strlen(pStr);
	char* ch = new char[len];
	memset(ch, 0, len);
	//convert("UTF-8", "UCS-2-INTERNAL", pStr, realLen, ch, len);
	UTF8_2_UCS2((unsigned char*)pStr, (unsigned short*)ch);

    check_mem( len );
	memcpy(m_pPointer, ch, len);
    m_pPointer += len;

	delete[] ch;
}

void	sendBuff::writeFile(const char* path)
{
	
	FILE* f = fopen(path, "rb");
	fseek(f, 0, SEEK_END);
	int fileSize = ftell(f);
	char* pData = new char[fileSize];
	rewind(f);
	fread(pData, fileSize, 1, f);
	fclose(f);

	if (!m_bCanWrite){
		//*
		OUTPUT_FUN("[NET] clientSocket can't write after pack!");
		return;
	}
	check_mem(fileSize);
	memcpy(m_pPointer, pData, fileSize);
	m_pPointer += fileSize;

	delete[] pData;
}

void	sendBuff::writeFloat(const float val)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
    
    check_mem(sizeof(float));
    float rval = val;
    memcpy(m_pPointer, &rval, sizeof(float));
    m_pPointer += sizeof(float);
}

void	sendBuff::writeDouble(const double val)
{
    if (!m_bCanWrite){
        //*
        OUTPUT_FUN("[NET] clientSocket can't write after pack!");
        return;
    }
    
    check_mem(8);
    memcpy(m_pPointer, &val, 8);
    m_pPointer += 8;
}
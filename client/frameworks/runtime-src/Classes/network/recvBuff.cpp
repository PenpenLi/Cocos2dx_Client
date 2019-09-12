#include "recvBuff.h"
#include <string.h>
#include <stdio.h>
#include <assert.h>
#include <zlib.h>
#include <string>
#include "cocos2d.h"
#include "IconvString.h"

#ifdef WIN32
#include <WinSock2.h>
#else
#include <arpa/inet.h>
#endif

#define OUTPUT_FUN printf

recvBuff::~recvBuff(){
    memset( m_pMem, 0, DEFAULT_RECV_SIZE );
    if(m_pBuffer != m_pMem){
        delete[] m_pBuffer;
        m_pBuffer = NULL;
    }
}

recvBuff::recvBuff(int size){
	m_bCanUnPack = true;
    memset( m_pMem, 0, DEFAULT_RECV_SIZE );
    if( size > DEFAULT_RECV_SIZE )
    {
        m_pBuffer = new char[size];
    }else{
        m_pBuffer = m_pMem;
    }
    m_iBuffSize = size;
    m_pPointer = m_pBuffer;
    m_eType = eRecvType_data;
}

void    recvBuff::getMem( char* &pMem ) const
{
    pMem = m_pBuffer;
}


char    recvBuff::readChar()
{
    m_bCanUnPack = false;
	assert(m_pPointer + sizeof(char) <= m_pBuffer + m_iBuffSize);
	char *bret = (char*)m_pPointer;
	m_pPointer += sizeof(char);
    return *bret;
}

short   recvBuff::readShort()
{
	assert(m_pPointer + sizeof(short) <= m_pBuffer + m_iBuffSize);
	short *bret = (short*)m_pPointer;
	m_pPointer += sizeof(short);
    return *bret;
}

unsigned short recvBuff::readUShort()
{
	assert(m_pPointer + sizeof(unsigned short) <= m_pBuffer + m_iBuffSize);
	unsigned short *bret = (unsigned short*)m_pPointer;
	m_pPointer += sizeof(unsigned short);
	return *bret;
}

double recvBuff::readInt64()
{
    assert(m_pPointer + 8 <= m_pBuffer + m_iBuffSize);
    unsigned int low = readInt();
	unsigned int high = readInt();

	double val = high * 4294967296 + low;
    
	return val;
}

int recvBuff::readInt()
{
	assert(m_pPointer + sizeof(int) <= m_pBuffer + m_iBuffSize);
	int *bret = (int*)m_pPointer;
	m_pPointer += sizeof(int);
    return *bret;
}

char*	recvBuff::readString(short len)
{
	assert(m_pPointer + len <= m_pBuffer + m_iBuffSize);

	char* chSrc = new char[len];
	memset(chSrc, 0, len);
	memcpy(chSrc, m_pPointer, len);

	int maxLen = len * 6 + 1;
	char* chDst = new char[maxLen];
	memset(chDst, 0, maxLen);

	UCS2_2_UTF8((unsigned short*)chSrc, (unsigned char*)chDst);

	//convert("UCS-2-INTERNAL", "UTF-8", chSrc, len, chDst, len * 4);

	delete[] chSrc;

	m_pPointer += len;
	return chDst;
}

char*	recvBuff::readFile(char* path, int len)
{
	assert(m_pPointer + len <= m_pBuffer + m_iBuffSize);

	char* pData = new char[len];
	memcpy(pData, m_pPointer, len);
	m_pPointer += len;

	std::string pathStr(path);
	std::string relPathStr = pathStr.substr(0, pathStr.find_last_of("/")) + "/";
	cocos2d::FileUtils::getInstance()->createDirectory(relPathStr);

	FILE *out = fopen(path, "wb");
	fwrite(pData, len, 1, out);
	fclose(out);

	delete[] pData;

	return path;
}

float recvBuff::readFloat()
{
    assert(m_pPointer + sizeof(float) <= m_pBuffer + m_iBuffSize);
    float *bret = (float*)m_pPointer;
    m_pPointer += sizeof(float);
    return *bret;
}

double	recvBuff::readDouble()
{
    assert(m_pPointer + 8 <= m_pBuffer + m_iBuffSize);
	double *bret = (double*)m_pPointer;
    
    m_pPointer += 8;
	return *bret;
}

int recvBuff::getLength()
{
	return m_iBuffSize;
}
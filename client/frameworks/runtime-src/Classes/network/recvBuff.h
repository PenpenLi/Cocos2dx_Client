#ifndef __HEADER_RECV_BUFFER__
#define __HEADER_RECV_BUFFER__

#define DEFAULT_RECV_SIZE 512

enum eRecvType {
    eRecvType_lost = 0,
    eRecvType_connsucc,
    eRecvType_connfail,
    eRecvType_data,
};

class recvBuff  {
    private:
        char    m_pMem[ DEFAULT_RECV_SIZE ];
        char*   m_pBuffer;
		int     m_iBuffSize;
        char*   m_pPointer;
        bool    m_bCanUnPack;

		short	m_mainCmd;
		short	m_subCmd;

    public:
        ~recvBuff();
		recvBuff(int size);
    
        eRecvType m_eType;

        void    getMem( char* &pMem ) const;
    
		char    readChar();
		short   readShort();
		unsigned short readUShort();
		int     readInt();
        float   readFloat();
        double	readDouble();
        double  readInt64();
        //int     readString( char* &pStr);
		char*	readString(short len);
		char*	readFile(char* path, int len);

		void	setMainCmd(const short cmd){ m_mainCmd = cmd; };
		void	setSubCmd(const short cmd){ m_subCmd = cmd; };
		const short	getMainCmd(){ return m_mainCmd; };
		const short getSubCmd(){ return m_subCmd; };
		int		getLength();
    
    static recvBuff* createLostRecvBuff() {
        recvBuff *pBuff = new recvBuff( 0 );
        pBuff->m_eType = eRecvType_lost;
        return pBuff;
    }
    
    static recvBuff* createConnfailRecvBuff() {
        recvBuff *pBuff = new recvBuff( 0 );
        pBuff->m_eType = eRecvType_connfail;
        return pBuff;
    }
    
    static recvBuff* createConnsuccRecvBuff() {
        recvBuff *pBuff = new recvBuff( 0 );
        pBuff->m_eType = eRecvType_connsucc;
        return pBuff;
    }

    
};


#endif

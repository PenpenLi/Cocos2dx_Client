#ifndef __HEADER_SEND_BUFFER__
#define __HEADER_SEND_BUFFER__

#define DEFAULT_MEM_SIZE 512

class sendBuff {
    private:
        char    m_pMem[ DEFAULT_MEM_SIZE ];
        char*   m_pBuffer;
        int     m_iBuffSize;
        char*   m_pPointer;
        bool    m_bCanWrite;
		short	m_mainCmd;
		short	m_subCmd;
        //short   m_iPt;
		void    check_mem(int add_size);

    public:
        ~sendBuff();
        sendBuff();
    
        void    get_mem( char* &pMem, int& size );
        void    writeChar( const char val );
		void    writeShort(const short val);
		void    writeInt(const int val);
        void 	writeFloat(const float val);
        void	writeDouble(const double val);
		void	writeInt64(const double val);
		void    writeString(char* pStr, short len);
		void	writeFile(const char* path);
		//void	writeMD5(char* pStr, short len);

		void	setMainCmd(const short cmd){ m_mainCmd = cmd; };
		void	setSubCmd(const short cmd){ m_subCmd = cmd; };
		const short	getMainCmd(){ return m_mainCmd; };
		const short getSubCmd(){ return m_subCmd; };
};


#endif



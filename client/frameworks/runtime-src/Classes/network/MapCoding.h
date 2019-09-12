#ifndef __MAPCODING_HEADER__H_
#define __MAPCODING_HEADER__H_

#include "platformTypes.h"

class MapCoding
{
public:
	MapCoding();
	~MapCoding();

	BYTE MapSendByte(BYTE cbData);
	BYTE MapRecvByte(BYTE cbData);

private:
	int m_cbSendRound = 0;
	int m_cbRecvRound = 0;
	int m_dwSendXorKey = 0x12345678;
	int m_dwRecvXorKey = 0x12345678;

	int m_dwSendPacketCount = 0;
	int m_dwRecvPacketCount = 0;

public:
	void Reset();
	WORD EncryptBuffer(BYTE* pcbDataBuffer, WORD wDataSize, WORD wBufferSize);
	WORD CrevasseBuffer(BYTE* pcbDataBuffer, WORD wDataSize);
	byte *Pack(int maincmd, int subcmd, byte* data, int datasize);
	WORD UnPack(BYTE* pcbDataBuffer, WORD &wDataSize);
};

#endif

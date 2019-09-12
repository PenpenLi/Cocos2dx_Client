#include "scripting/lua-bindings/manual/CCLuaEngine.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"
extern "C"
{
#include "md5.h"
#include "qrencode.h"
}
#include "storage/local-storage/LocalStorage.h"
#include "clientSock.h"
#include "cocos2d.h"
#include "AppDelegate.h"
#if (CC_TARGET_PLATFORM==CC_PLATFORM_ANDROID)
#include "platform/android/jni/JniHelper.h"
#endif

//捕鱼
#include "math_aide.h"
#include "scene_fish_trace.h"
#include "scene_fish_trace2.h"
#include "FishFactory.h"

static int tolua_util_secondNow(lua_State *L)
{
    struct timeval now;
    
    gettimeofday(&now, nullptr);
    
    tolua_pushnumber(L, (now.tv_sec + (double)now.tv_usec / 1000000));
    
    return 1;
}

static int tolua_util_MessageBox(lua_State *L)
{
    const char* msg = (const char*) tolua_tostring(L, 2, "");
    const char* title = (const char*) tolua_tostring(L, 3, "");
    cocos2d::MessageBox(msg, title);
    
    return 0;
}

static int tolua_util_makeTag(lua_State *L)
{
    int a = tolua_tonumber(L, 2, 0);
    int b = tolua_tonumber(L, 3, 0);
    
    int c = ((int)(((unsigned short)(((unsigned int)(a)) & 0xffff)) | ((unsigned int)((unsigned short)(((unsigned int)(b)) & 0xffff))) << 16));
    
    tolua_pushnumber(L, c);
    
    return 1;
}

int factorial(int value)
{
	int ret = 1;
	for (int i = 2; i <= value; i++)
	{
		ret *= i;
	}
	return ret;
}

int combination(int m, int n)
{
	if (n == 0) return 1;

	return factorial(m) / (factorial(n) * factorial(m - n));
}

static int tolua_util_powf(lua_State* L)
{
	const float x = (const float)tolua_tonumber(L, 2, 0);
	const int y = (const float)tolua_tonumber(L, 3, 0);

	float ret = powf(x, y);

	lua_pushnumber(L, ret);
	return 1;
}

static int tolua_util_calcBezierTime(lua_State *L)
{
	std::vector<Vec2> array;
	luaval_to_std_vector_vec2(L, 2, &array);
	const float speedSec = (const float)tolua_tonumber(L, 3, 0);
	const float precision = (const float)tolua_tonumber(L, 4, 0);

	int count = array.size() - 1;
	float distance = 0.0f;
	float value;
	Vec2* start = &array.at(0);
	Vec2 next;
	Vec2 previous(start->x, start->y);
	float t = precision;
	while (!(t>1))
	{
		next.x = 0;
		next.y = 0;
		for (int j = 0; j <= count; j++)
		{
			Vec2* pv = &array.at(j);
			value = powf(t, j) * powf(1 - t, count - j) * combination(count, j);
			next.x = next.x + pv->x * value;
			next.y = next.y + pv->y * value;
		}

		distance += next.distance(previous);
		previous.set(next);

		t += precision;
	}
	array.clear();

	float ret = distance / speedSec;
	tolua_pushnumber(L, ret);

	return 1;
}

static int tolua_util_calcBezierPoint(lua_State* L)
{
	std::vector<Vec2> points;
	luaval_to_std_vector_vec2(L, 2, &points);
	const float time = (const float)tolua_tonumber(L, 3, 0);

	Vec2 next(0, 0);
	float value;
	int count = points.size() - 1;
	for (int j = 0; j <= count; j++)
	{
		Vec2* pv = &points.at(j);
		value = powf(time, j) * powf(1 - time, count - j) * combination(count, j);
		next.x = next.x + pv->x * value;
		next.y = next.y + pv->y * value;
	}

	vec2_to_luaval(L, next);

	return 1;
}

static int tolua_util_calcLinearTime(lua_State* L)
{
	Vec2 pSrc;
	Vec2 pDst;
	luaval_to_vec2(L, 2, &pSrc, "calcLinearTime");
	luaval_to_vec2(L, 3, &pDst, "calcLinearTime");

	const float speedSec = (const float)tolua_tonumber(L, 4, 0);

	const float distance = pDst.distance(pSrc);
	float ret = distance / speedSec;

	lua_pushnumber(L, ret);

	return 1;
}

static int tolua_util_calcLinearPoint(lua_State* L)
{
	Vec2 pSrc;
	Vec2 pDst;
	luaval_to_vec2(L, 2, &pSrc, "calcLinearPoint");
	luaval_to_vec2(L, 3, &pDst, "calcLinearPoint");
	
	Vec2 delta = pDst - pSrc;

	const float time = (const float)tolua_tonumber(L, 4, 0);
	Vec2 ret = pSrc + delta * time;
	vec2_to_luaval(L, ret);

	return 1;
}

const float pi_div_180 = M_PI / 180;
const float pi_mul_180 = M_PI * 180;

float angle2radian(float angle)
{
	return angle * pi_div_180;
}

float radian2angle(float radian)
{
	return radian / pi_mul_180;
}

static int tolua_util_calcCircleTime(lua_State* L)
{
	const float startAngle = (const float)tolua_tonumber(L, 2, 0);
	const float endAngle = (const float)tolua_tonumber(L, 3, 0);
	const float radius = (const float)tolua_tonumber(L, 4, 0);
	const float speedSec = (const float)tolua_tonumber(L, 5, 0);
	const float precision = (const float)tolua_tonumber(L, 6, 0);

	const float startRadian = angle2radian(startAngle);
	const float endRadian = angle2radian(endAngle);
	const float deltaRadian = endRadian - startRadian;

	float full_round = 2 * M_PI * radius;
	float delta_rate = deltaRadian / (2 * M_PI);
	float distance = full_round * delta_rate;

	float ret = distance / speedSec;
	lua_pushnumber(L, ret);

	return 1;
}

static int tolua_util_calcCirclePoint(lua_State* L)
{
	Vec2 pCenter;
	luaval_to_vec2(L, 2, &pCenter, "calcCirclePoint");
	const float startAngle = (const float)tolua_tonumber(L, 3, 0);
	const float endAngle = (const float)tolua_tonumber(L, 4, 0);
	const float radius = (const float)tolua_tonumber(L, 5, 0);
	const float time = (const float)tolua_tonumber(L, 6, 0);

	const float startRadian = angle2radian(startAngle);
	const float endRadian = angle2radian(endAngle);
	const float deltaRadian = endRadian - startRadian;

	const float t = time * deltaRadian;

	Vec2 next;
	next.x = radius * cosf(startRadian + t);
	next.y = radius * sinf(startRadian + t);

	Vec2 ret = next + pCenter;
	vec2_to_luaval(L, ret);

	return 1;
}

static int tolua_util_createQRSprite(lua_State* L)
{
	const char* value = (const char*)tolua_tostring(L, 2, "");
	const int size = (const int)tolua_tonumber(L, 3, 0);
	const int gap = (const int)tolua_tonumber(L, 4, 0);

	QRcode* qrcode = QRcode_encodeString(value, 0, QR_ECLEVEL_H, QR_MODE_8, 1);
	float scale = qrcode->width / (float)size;
	int len = size * size;
	char* ch = new char[len];
	memset(ch, 0, len);

	for (int i = 0; i < size; i++)
	{
		int sx = floor(i * scale);
		for (int j = 0; j < size; j++)
		{
			int sy = floor(j * scale);
			if ((qrcode->data[sx * qrcode->width + sy] & 1) == 1)
			{
				ch[i * size + j] = 255;
			}
			else
			{
				ch[i * size + j] = 0;
			}
		}
	}
	QRcode_free(qrcode);

	Size sz(size, size);
	Texture2D* tx = new Texture2D;
	tx->initWithData(ch, len, Texture2D::PixelFormat::A8, size, size, sz);

	const int GAP = 20;
	Size sl(size + gap * 2, size + gap * 2);
	Sprite* rq = Sprite::createWithTexture(tx);
	rq->setPosition(sl.width / 2, sl.height / 2);
	Color4B clr(255, 255, 255, 255);
	LayerColor* ret = LayerColor::create(clr, sl.width, sl.height);
	ret->addChild(rq);

	int ID = ret ? (int)(ret->_ID) : -1;
	int* luaID = ret ? &(ret->_luaID) : nullptr;
	toluafix_pushusertype_ccobject(L, ID, luaID, (void*)ret, "cc.LayerColor");

	delete ch;

	return 1;
}

static int tolua_util_saveQRImageFile(lua_State* L)
{
	const char* value = (const char*)tolua_tostring(L, 2, "");
	const int size = (const int)tolua_tonumber(L, 3, 0);
	const char* filename = (const char*)tolua_tostring(L, 4, "");

	QRcode* qrcode = QRcode_encodeString(value, 0, QR_ECLEVEL_H, QR_MODE_8, 1);
	float scale = qrcode->width / (float)size;
	int len = size * size;
	unsigned int* pixels = new unsigned int[len];

	for (int i = 0; i < size; i++)
	{
		int sx = floor(i * scale);
		for (int j = 0; j < size; j++)
		{
			int sy = floor(j * scale);
			if ((qrcode->data[sx * qrcode->width + sy] & 1) == 1)
			{
				pixels[i * size + j] = 0xFF000000;
			}
			else
			{
				pixels[i * size + j] = 0xFFFFFFFF;
			}
		}
	}
	QRcode_free(qrcode);

	Image* im = new Image;
	im->initWithRawData((const unsigned char*)pixels, len, size, size, 0);

	tolua_pushboolean(L, im->saveToFile(filename));

	delete pixels;

	return 1;
}

static int tolua_util_makeVersion(lua_State* L)
{
	const int productVer = (const int)tolua_tonumber(L, 2, 0);
	const int mainVer = (const int)tolua_tonumber(L, 3, 0);
	const int subVer = (const int)tolua_tonumber(L, 4, 0);
	const int buildVer = (const int)tolua_tonumber(L, 5, 0);

	unsigned int ret = ((unsigned int)(((unsigned char)(productVer)) << 24) | (((unsigned char)(mainVer)) << 16) | (((unsigned char)(subVer)) << 8) | ((unsigned char)(buildVer)));
	tolua_pushnumber(L, ret);

	return 1;
}

#ifdef WIN32

#define LEN_NETWORK_ID 13

//状态信息
struct tagAstatInfo
{
	ADAPTER_STATUS				AdapterStatus;						//网卡状态
	NAME_BUFFER					NameBuff[16];						//名字缓冲
};

//网卡地址
bool getWinMachineId(char* szMachineId)
{
	//变量定义
	HINSTANCE hInstance = NULL;

	//执行逻辑
	__try
	{
		//加载 DLL
		hInstance = LoadLibrary(TEXT("netapi32.dll"));
		if (hInstance == NULL) __leave;

		//获取函数
		typedef BYTE __stdcall NetBiosProc(NCB * Ncb);
		NetBiosProc * pNetBiosProc = (NetBiosProc *)GetProcAddress(hInstance, "Netbios");
		if (pNetBiosProc == NULL) __leave;

		//变量定义
		NCB Ncb;
		LANA_ENUM LanaEnum;
		ZeroMemory(&Ncb, sizeof(Ncb));
		ZeroMemory(&LanaEnum, sizeof(LanaEnum));

		//枚举网卡
		Ncb.ncb_command = NCBENUM;
		Ncb.ncb_length = sizeof(LanaEnum);
		Ncb.ncb_buffer = (BYTE *)&LanaEnum;
		if ((pNetBiosProc(&Ncb) != NRC_GOODRET) || (LanaEnum.length == 0)) __leave;

		//获取地址
		if (LanaEnum.length>0)
		{
			//变量定义
			tagAstatInfo Adapter;
			ZeroMemory(&Adapter, sizeof(Adapter));

			//重置网卡
			Ncb.ncb_command = NCBRESET;
			Ncb.ncb_lana_num = LanaEnum.lana[0];
			if (pNetBiosProc(&Ncb) != NRC_GOODRET) __leave;

			//获取状态
			Ncb.ncb_command = NCBASTAT;
			Ncb.ncb_length = sizeof(Adapter);
			Ncb.ncb_buffer = (BYTE *)&Adapter;
			Ncb.ncb_lana_num = LanaEnum.lana[0];
			strcpy((char *)Ncb.ncb_callname, "*");
			if (pNetBiosProc(&Ncb) != NRC_GOODRET) __leave;

			//获取地址
			for (int i = 0; i < 6; i++)
			{
				assert((i * 2)<LEN_NETWORK_ID);
				sprintf(&szMachineId[i * 2], "%02X", Adapter.AdapterStatus.adapter_address[i]);
			}
		}
	}

	//结束清理
	__finally
	{
		//释放资源
		if (hInstance != NULL)
		{
			FreeLibrary(hInstance);
			hInstance = NULL;
		}

		//错误断言
		if (AbnormalTermination() == TRUE)
		{
			assert(FALSE);
		}
	}

	return true;
}

static int tolua_util_getMachineId(lua_State* L)
{
	char szMachineId[255] = { 0 };
	bool ret = getWinMachineId(szMachineId);
	
	tolua_pushstring(L, szMachineId);
	return 1;
}

#endif

static int tolua_clientsock_getgt(lua_State *L)
{
	tolua_pushusertype(L, (void*)clientSock::m_pGtSock, "clientSock");
	return 1;
}

static int tolua_clientsock_getgs(lua_State *L)
{
	tolua_pushusertype(L, (void*)clientSock::m_pGsSock, "clientSock");
	return 1;
}

static int tolua_clientsock_init(lua_State *L)
{
	clientSock* self = (clientSock*)tolua_tousertype(L, 1, NULL);
	const char* def_ip = "";
	const char* ip = (const char*)tolua_tostring(L, 2, def_ip);
	const int   port = (const int)tolua_tonumber(L, 3, 0);
	int ret = self->init(ip, port);
	tolua_pushnumber(L, ret);
	return 1;
}

static int tolua_clientsock_setcbfun(lua_State *L)
{
	clientSock* self = (clientSock*)tolua_tousertype(L, 1, NULL);
	cocos2d::LUA_FUNCTION funId = (toluafix_ref_function(L, 2, 0));
	int ret = self->set_lua_cbfun(funId);
	tolua_pushnumber(L, ret);
	return 1;
}

static int tolua_clientsock_sendbuff(lua_State *L)
{
	clientSock *self = (clientSock*)tolua_tousertype(L, 1, NULL);
	sendBuff *buf = (sendBuff*)tolua_tousertype(L, 2, NULL);
	self->add_to_send_queue(buf);
	return 0;
}

static int tolua_clientsock_closesocket(lua_State *L)
{
	clientSock *self = (clientSock*)tolua_tousertype(L, 1, NULL);
	self->close_socket();
	return 0;
}

static int tolua_reset_recv_queue(lua_State *L)
{
	clientSock *self = (clientSock*)tolua_tousertype(L, 1, NULL);
	self->reset_recv_queue();
	return 0;
}

static int tolua_reset_send_queue(lua_State *L)
{
	clientSock *self = (clientSock*)tolua_tousertype(L, 1, NULL);
	self->reset_send_queue();
	return 0;
}


static int tolua_recvbuff_readchar(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const char val = pBuff->readChar();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readshort(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short val = pBuff->readShort();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readushort(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const unsigned short val = (const unsigned short)pBuff->readShort();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readint(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const int val = pBuff->readInt();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readfloat(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const float val = pBuff->readFloat();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readint64(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const double  val = pBuff->readInt64();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvbuff_readstring(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short len = (const short)tolua_tonumber(L, 2, 0);

	char *pString = pBuff->readString(len);
	tolua_pushstring(L, pString);
	delete[] pString;
	return 1;
}

static int tolua_recvbuff_getLength(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	int len = pBuff->getLength();

	tolua_pushnumber(L, len);
	return 1;
}

static int tolua_recvbuff_gettype(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	tolua_pushnumber(L, pBuff->m_eType);
	return 1;
}

static int tolua_recvBuff_getMaincmd(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short val = pBuff->getMainCmd();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvBuff_getSubcmd(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short val = pBuff->getSubCmd();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_recvBuff_setMaincmd(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short val = (const short)tolua_tonumber(L, 2, 0);
	pBuff->setMainCmd(val);
	return 0;
}

static int tolua_recvBuff_setSubcmd(lua_State *L)
{
	recvBuff *pBuff = (recvBuff*)tolua_tousertype(L, 1, NULL);
	const short val = (const short)tolua_tonumber(L, 2, 0);
	pBuff->setSubCmd(val);
	return 0;
}

static int tolua_sendbuff_new(lua_State *L)
{
	sendBuff *pBuff = new sendBuff;
	tolua_pushusertype(L, (void*)pBuff, "sendBuff");
	return 1;
}

static int tolua_sendbuff_writechar(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const char val = (const char)tolua_tonumber(L, 2, 0);
	pBuff->writeChar(val);
	return 0;
}

static int tolua_sendbuff_writeshort(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const short val = (const short)tolua_tonumber(L, 2, 0);
	pBuff->writeShort(val);
	return 0;
}

static int tolua_sendbuff_writeint(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const int val = (const int)tolua_tonumber(L, 2, 0);
	pBuff->writeInt(val);
	return 0;
}

static int tolua_sendbuff_writefloat(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const float val = (const float)tolua_tonumber(L, 2, 0);
	pBuff->writeFloat(val);
	return 0;
}

static int tolua_sendbuff_writeint64(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const double  val = (const double )tolua_tonumber(L, 2, 0);
	pBuff->writeInt64(val);
	return 0;
}

static int tolua_sendbuff_writestring(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	char* pStr = (char*)tolua_tostring(L, 2, 0);
	short len = (short)tolua_tonumber(L, 3, 0);

	pBuff->writeString(pStr, len);
	return 0;
}

static int tolua_sendbuff_writeMD5(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	char* pStr = (char*)tolua_tostring(L, 2, 0);
	short len = (short)tolua_tonumber(L, 3, 0);

	char* md5Str = MD5String(pStr);
	int md5len = strlen(md5Str);
	for (int i = 0; i < md5len; i++)
	{
		if (md5Str[i] >= 'a'&&md5Str[i] <= 'z')
			md5Str[i] -= 32;
	}

	pBuff->writeString(md5Str, len);
	return 0;
}

static int tolua_sendbuff_getMaincmd(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const short val = pBuff->getMainCmd();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_sendbuff_getSubcmd(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const short val = pBuff->getSubCmd();
	tolua_pushnumber(L, val);
	return 1;
}

static int tolua_sendbuff_setMaincmd(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const short val = (const short)tolua_tonumber(L, 2, 0);
	pBuff->setMainCmd(val);
	return 0;
}

static int tolua_sendbuff_setSubcmd(lua_State *L)
{
	sendBuff *pBuff = (sendBuff*)tolua_tousertype(L, 1, NULL);
	const short val = (const short)tolua_tonumber(L, 2, 0);
	pBuff->setSubCmd(val);
	return 0;
}

static int tolua_TraceVector_Release(lua_State* L)
{
	TraceVector* self = (TraceVector*)tolua_tousertype(L, 1, 0);
	Mtolua_delete(self);
	return 0;
}

static int tolua_TraceVector_Index(lua_State *L)
{
	TraceVector *self = (TraceVector*)tolua_tousertype(L, 1, NULL);
	const int index = (const int)tolua_tonumber(L, 2, 0);
	FPointAngle& t = self->Index(index);

	tolua_pushnumber(L, t.x);
	tolua_pushnumber(L, t.y);
	tolua_pushnumber(L, t.angle);

	return 3;
}

static int tolua_PointVector_Size(lua_State *L)
{
	PointVector *self = (PointVector*)tolua_tousertype(L, 1, NULL);

	tolua_pushnumber(L, self->Size());

	return 1;
}

static int tolua_PointVector_Release(lua_State* L)
{
	PointVector* self = (PointVector*)tolua_tousertype(L, 1, 0);
	Mtolua_delete(self);
	return 0;
}

static int tolua_PointVector_Index(lua_State *L)
{
	PointVector *self = (PointVector*)tolua_tousertype(L, 1, NULL);
	const int index = (const int)tolua_tonumber(L, 2, 0);
	FPoint& t = self->Index(index);

	tolua_pushnumber(L, t.x);
	tolua_pushnumber(L, t.y);

	return 2;
}

static int tolua_TraceVector_Size(lua_State *L)
{
	TraceVector *self = (TraceVector*)tolua_tousertype(L, 1, NULL);

	tolua_pushnumber(L, self->Size());

	return 1;
}

static int tolua_FishFactory_getInstance(lua_State *L)
{
	tolua_pushusertype(L, (void*)FishFactory::getInstance(), "FishFactory");
	return 1;
}

static int tolua_FishFactory_setcbfun(lua_State *L)
{
	FishFactory* self = (FishFactory*)tolua_tousertype(L, 1, NULL);
	cocos2d::LUA_FUNCTION funId = (toluafix_ref_function(L, 2, 0));
	self->set_lua_cbfun(funId);
	return 0;
}

static void show_debug(Scene*Main_Node, char *debug_str, CCPoint pos)
{
	if (Main_Node)
	{

		cocos2d::CCLabelTTF *text = cocos2d::CCLabelTTF::create(debug_str, "Arial", 40);;    //
		if (text)
		{
			text->setPosition(pos);
			DelayTime *t_delay = DelayTime::create(10);
			FadeOut   *t_fadeout = FadeOut::create(0.2f);
			CCSequence *t_seq = CCSequence::create(t_delay, t_fadeout, NULL);
			text->runAction(t_seq);
			Main_Node->addChild(text, 1111111);
		}

	}

}

static int tolua_FishFactory_createFish(lua_State *L)
{
	FishFactory* self = (FishFactory*)tolua_tousertype(L, 1, NULL);

	FishInfo* fi = new FishInfo;
	fi->fishkind = tolua_tonumber(L, 2, 0);
	fi->fishid = tolua_tonumber(L, 3, 0);
	fi->fishspeed = tolua_tonumber(L, 4, 0);
	fi->init_x_pos[0] = tolua_tonumber(L, 5, 0);
	fi->init_x_pos[1] = tolua_tonumber(L, 6, 0);
	fi->init_x_pos[2] = tolua_tonumber(L, 7, 0);
	fi->init_y_pos[0] = tolua_tonumber(L, 8, 0);
	fi->init_y_pos[1] = tolua_tonumber(L, 9, 0);
	fi->init_y_pos[2] = tolua_tonumber(L, 10, 0);
	fi->init_count = tolua_tonumber(L, 11, 0);
	fi->trace_type = tolua_tonumber(L, 12, 0);

	self->add_to_send_queue(fi);

	return 0;
}

static int tolua_FishFactory_Start(lua_State *L)
{
	FishFactory* self = (FishFactory*)tolua_tousertype(L, 1, NULL);
	self->Start();
	return 0;
}

static int tolua_FishFactory_Stop(lua_State *L)
{
	FishFactory* self = (FishFactory*)tolua_tousertype(L, 1, NULL);
	self->Stop();
	return 0;
}

static int tolua_FishFactory_build_scene_fish_trace(lua_State *L)
{
	//捕鱼
	BuildSceneKind1Trace(1280, 720);
	BuildSceneKind2Trace(1280, 720);
	BuildSceneKind3Trace(1280, 720);
	BuildSceneKind4Trace(1280, 720);
	BuildSceneKind5Trace(1280, 720);

	return 0;
}

static int tolua_FishFactory_get_scene_fish_trace(lua_State *L)
{

	int scene = tolua_tonumber(L, 2, 0);
	int index = tolua_tonumber(L, 3, 0);
	std::vector<FPointAngle>* v = new std::vector<FPointAngle>();
	TraceVector* tv = new TraceVector(v);

	switch (scene)
	{
		case 0:
		std::copy(scene_kind_1_trace_[index].begin(), scene_kind_1_trace_[index].end(), std::back_inserter(*v));
		break;
		case 1:
		std::copy(scene_kind_2_trace_[index].begin(), scene_kind_2_trace_[index].end(), std::back_inserter(*v));
		break;
		case 2:
		std::copy(scene_kind_3_trace_[index].begin(), scene_kind_3_trace_[index].end(), std::back_inserter(*v));
		break;
		case 3:
		std::copy(scene_kind_4_trace_[index].begin(), scene_kind_4_trace_[index].end(), std::back_inserter(*v));
		break;
		case 4:
		std::copy(scene_kind_5_trace_[index].begin(), scene_kind_5_trace_[index].end(), std::back_inserter(*v));
		break;
	}

	tolua_pushusertype(L, tv, "TraceVector");

	return 1;
}

static int tolua_FishFactory_get_scene2_small_fish_stop(lua_State *L)
{

	int index = tolua_tonumber(L, 2, 0);

	tolua_pushnumber(L, scene_kind_2_small_fish_stop_index_[index]);
	tolua_pushnumber(L, scene_kind_2_small_fish_stop_count_);

	return 2;
}

static int tolua_FishFactory_get_scene2_big_fish_stop(lua_State *L)
{

	tolua_pushnumber(L, scene_kind_2_big_fish_stop_index_);
	tolua_pushnumber(L, scene_kind_2_big_fish_stop_count_);

	return 2;
}

static int tolua_FishFactory_build_scene_fish_trace2(lua_State *L)
{
	//捕鱼
	BuildSceneKind1Trace2(1280, 720);
	BuildSceneKind2Trace2(1280, 720);
	BuildSceneKind3Trace2(1280, 720);
	BuildSceneKind4Trace2(1280, 720);
	BuildSceneKind5Trace2(1280, 720);

	return 0;
}

static int tolua_FishFactory_get_scene_fish_trace2(lua_State *L)
{

	int scene = tolua_tonumber(L, 2, 0);
	int index = tolua_tonumber(L, 3, 0);
	std::vector<FPointAngle>* v = new std::vector<FPointAngle>();
	TraceVector* tv = new TraceVector(v);

	switch (scene)
	{
	case 0:
		std::copy(scene_kind_1_trace2_[index].begin(), scene_kind_1_trace2_[index].end(), std::back_inserter(*v));
		break;
	case 1:
		std::copy(scene_kind_2_trace2_[index].begin(), scene_kind_2_trace2_[index].end(), std::back_inserter(*v));
		break;
	case 2:
		std::copy(scene_kind_3_trace2_[index].begin(), scene_kind_3_trace2_[index].end(), std::back_inserter(*v));
		break;
	case 3:
		std::copy(scene_kind_4_trace2_[index].begin(), scene_kind_4_trace2_[index].end(), std::back_inserter(*v));
		break;
	case 4:
		std::copy(scene_kind_5_trace2_[index].begin(), scene_kind_5_trace2_[index].end(), std::back_inserter(*v));
		break;
	}

	tolua_pushusertype(L, tv, "TraceVector");

	return 1;
}

static int tolua_FishFactory_get_scene2_small_fish_stop2(lua_State *L)
{

	int index = tolua_tonumber(L, 2, 0);

	tolua_pushnumber(L, scene_kind_2_small_fish_stop_index2_[index]);
	tolua_pushnumber(L, scene_kind_2_small_fish_stop_count2_);

	return 2;
}

static int tolua_FishFactory_get_scene2_big_fish_stop2(lua_State *L)
{

	tolua_pushnumber(L, scene_kind_2_big_fish_stop_index2_);
	tolua_pushnumber(L, scene_kind_2_big_fish_stop_count2_);

	return 2;
}

static int tolua_MathAide_CalcAngle(lua_State* L)
{
	float x1 = tolua_tonumber(L, 2, 0);
	float y1 = tolua_tonumber(L, 3, 0);
	float x2 = tolua_tonumber(L, 4, 0);
	float y2 = tolua_tonumber(L, 5, 0);

	float angle = MathAide::CalcAngle(x1, y1, x2, y2);

	tolua_pushnumber(L, angle);

	return 1;
}

static int tolua_MathAide_BuildLinear(lua_State *L)
{
	float init_x[2];
	float init_y[2];
	float distance;
	std::vector<FPoint>* v = new std::vector<FPoint>();
	PointVector* pv = new PointVector(v);

	init_x[0] = tolua_tonumber(L, 2, 0);
	init_x[1] = tolua_tonumber(L, 3, 0);
	init_y[0] = tolua_tonumber(L, 4, 0);
	init_y[1] = tolua_tonumber(L, 5, 0);
	distance = tolua_tonumber(L, 6, 0);

	MathAide::BuildLinear(init_x, init_y, 2, *v, distance);

	tolua_pushusertype(L, pv, "PointVector");

	return 1;
}

static int tolua_MathAide_GetTargetPoint(lua_State *L)
{
	float src_x_pos = tolua_tonumber(L, 2, 0);
	float src_y_pos = tolua_tonumber(L, 3, 0);
	float angle = tolua_tonumber(L, 4, 0);
	float target_x_pos;
	float target_y_pos;

	MathAide::GetTargetPoint(src_x_pos, src_y_pos, angle, target_x_pos, target_y_pos);

	tolua_pushnumber(L, target_x_pos);
	tolua_pushnumber(L, target_y_pos);

	return 2;
}

static int tolua_MathAide_GetReboundTargetPoint(lua_State *L)
{
	float src_x_pos = tolua_tonumber(L, 2, 0);
	float src_y_pos = tolua_tonumber(L, 3, 0);
	float angle = tolua_tonumber(L, 4, 0);
	int direction = tolua_tonumber(L, 5, 0);
	float target_x_pos;
	float target_y_pos;

	MathAide::GetReboundTargetPoint(src_x_pos, src_y_pos, angle, target_x_pos, target_y_pos, direction);

	tolua_pushnumber(L, target_x_pos);
	tolua_pushnumber(L, target_y_pos);

	return 2;
}

static int tolua_cocosext_LocalStorage_localStorageInit(lua_State*L)
{
	const char* dbPath = (const char*)tolua_tostring(L, 2, "");
	localStorageInit(dbPath);
	return 0;
}

static int tolua_cocosext_LocalStorage_localStorageFree(lua_State*L)
{
	localStorageFree();
	return 0;
}

static int tolua_cocosext_LocalStorage_localStorageSetItem(lua_State*L)
{
	const char* key = (const char*)tolua_tostring(L, 2, "");
	const char* value = (const char*)tolua_tostring(L, 3, "");
	localStorageSetItem(key, value);
	return 0;
}

static int tolua_cocosext_LocalStorage_localStorageGetItem(lua_State*L)
{
	const char* key = (const char*)tolua_tostring(L, 2, "");
	std::string value = "";
	localStorageGetItem(key, &value);
	tolua_pushstring(L, value.c_str());

	return 1;
}

static int tolua_cocosext_LocalStorage_localStorageRemoveItem(lua_State*L)
{
	const char* key = (const char*)tolua_tostring(L, 2, "");
	localStorageRemoveItem(key);
	return 0;
}

static int lua_register_cocosd_ex(lua_State* tolua_S)
{
	std::string typeName;

    tolua_open(tolua_S);
    tolua_module(tolua_S, "util", 0);
    tolua_beginmodule(tolua_S,"util");
    tolua_function( tolua_S, "secondNow", tolua_util_secondNow );
    tolua_function( tolua_S, "MessageBox", tolua_util_MessageBox );
    tolua_function( tolua_S, "makeTag", tolua_util_makeTag );
	tolua_function(tolua_S, "powf", tolua_util_powf);
	tolua_function(tolua_S, "calcBezierTime", tolua_util_calcBezierTime);
	tolua_function(tolua_S, "calcBezierPoint", tolua_util_calcBezierPoint);
	tolua_function(tolua_S, "calcLinearTime", tolua_util_calcLinearTime);
	tolua_function(tolua_S, "calcLinearPoint", tolua_util_calcLinearPoint);
	tolua_function(tolua_S, "calcCircleTime", tolua_util_calcCircleTime);
	tolua_function(tolua_S, "calcCirclePoint", tolua_util_calcCirclePoint);
	tolua_function(tolua_S, "createQRSprite", tolua_util_createQRSprite);
	tolua_function(tolua_S, "saveQRImageFile", tolua_util_saveQRImageFile);
	tolua_function(tolua_S, "makeVersion", tolua_util_makeVersion);
#ifdef WIN32
	tolua_function(tolua_S, "getMachineId", tolua_util_getMachineId);
#endif
    tolua_endmodule(tolua_S);

	tolua_usertype(tolua_S, "clientSock");
	tolua_cclass(tolua_S, "clientSock", "clientSock", "clientSock", NULL);
	tolua_beginmodule(tolua_S, "clientSock");
	tolua_function(tolua_S, "getGtInstance", tolua_clientsock_getgt);
	tolua_function(tolua_S, "getGsInstance", tolua_clientsock_getgs);
	tolua_function(tolua_S, "connect", tolua_clientsock_init);
	tolua_function(tolua_S, "setLuaFunc", tolua_clientsock_setcbfun);
	tolua_function(tolua_S, "sendData", tolua_clientsock_sendbuff);
	tolua_function(tolua_S, "close", tolua_clientsock_closesocket); 
	tolua_function(tolua_S, "reset_recv_queue", tolua_reset_recv_queue);
	tolua_function(tolua_S, "reset_send_queue", tolua_reset_send_queue);
	tolua_endmodule(tolua_S);
	typeName = typeid(clientSock).name();
	g_luaType[typeName] = "clientSock";
	g_typeCast["clientSock"] = "clientSock";

	tolua_usertype(tolua_S, "recvBuff");
	tolua_cclass(tolua_S, "recvBuff", "recvBuff", "recvBuff", NULL);
	tolua_beginmodule(tolua_S, "recvBuff");
	tolua_function(tolua_S, "readChar", tolua_recvbuff_readchar);
	tolua_function(tolua_S, "readShort", tolua_recvbuff_readshort);
	tolua_function(tolua_S, "readUShort", tolua_recvbuff_readushort);
	tolua_function(tolua_S, "readInt", tolua_recvbuff_readint);
	tolua_function(tolua_S, "readFloat", tolua_recvbuff_readfloat);
	tolua_function(tolua_S, "readInt64", tolua_recvbuff_readint64);
	tolua_function(tolua_S, "readString", tolua_recvbuff_readstring);
	tolua_function(tolua_S, "getLength", tolua_recvbuff_getLength);
	tolua_function(tolua_S, "getMainCmd", tolua_recvBuff_getMaincmd);
	tolua_function(tolua_S, "getSubCmd", tolua_recvBuff_getSubcmd);
	tolua_function(tolua_S, "setMainCmd", tolua_recvBuff_setMaincmd);
	tolua_function(tolua_S, "setSubCmd", tolua_recvBuff_setSubcmd);
	tolua_function(tolua_S, "getType", tolua_recvbuff_gettype);
	tolua_constant(tolua_S, "eRecvType_lost", eRecvType_lost);
	tolua_constant(tolua_S, "eRecvType_connsucc", eRecvType_connsucc);
	tolua_constant(tolua_S, "eRecvType_connfail", eRecvType_connfail);
	tolua_constant(tolua_S, "eRecvType_data", eRecvType_data);
	tolua_endmodule(tolua_S);
	typeName = typeid(recvBuff).name();
	g_luaType[typeName] = "recvBuff";
	g_typeCast["recvBuff"] = "recvBuff";

	tolua_usertype(tolua_S, "sendBuff");
	tolua_cclass(tolua_S, "sendBuff", "sendBuff", "sendBuff", NULL);
	tolua_beginmodule(tolua_S, "sendBuff");
	tolua_function(tolua_S, "new", tolua_sendbuff_new);
	tolua_function(tolua_S, "writeChar", tolua_sendbuff_writechar);
	tolua_function(tolua_S, "writeShort", tolua_sendbuff_writeshort);
	tolua_function(tolua_S, "writeInt", tolua_sendbuff_writeint);
	tolua_function(tolua_S, "writeFloat", tolua_sendbuff_writefloat);
	tolua_function(tolua_S, "writeInt64", tolua_sendbuff_writeint64);
	tolua_function(tolua_S, "writeString", tolua_sendbuff_writestring);
	tolua_function(tolua_S, "writeMD5", tolua_sendbuff_writeMD5);
	tolua_function(tolua_S, "getMainCmd", tolua_sendbuff_getMaincmd);
	tolua_function(tolua_S, "getSubCmd", tolua_sendbuff_getSubcmd);
	tolua_function(tolua_S, "setMainCmd", tolua_sendbuff_setMaincmd);
	tolua_function(tolua_S, "setSubCmd", tolua_sendbuff_setSubcmd);
	tolua_endmodule(tolua_S);
	typeName = typeid(sendBuff).name();
	g_luaType[typeName] = "sendBuff";
	g_typeCast["sendBuff"] = "sendBuff";

	//捕鱼
	tolua_usertype(tolua_S, "TraceVector");
	tolua_cclass(tolua_S, "TraceVector", "TraceVector", "", NULL);
	tolua_beginmodule(tolua_S, "TraceVector");
	tolua_function(tolua_S, "Index", tolua_TraceVector_Index);
	tolua_function(tolua_S, "Size", tolua_TraceVector_Size);
	tolua_function(tolua_S, "Release", tolua_TraceVector_Release);
	tolua_endmodule(tolua_S);
	typeName = typeid(TraceVector).name();
	g_luaType[typeName] = "TraceVector";
	g_typeCast["TraceVector"] = "TraceVector";

	tolua_usertype(tolua_S, "PointVector");
	tolua_cclass(tolua_S, "PointVector", "PointVector", "", NULL);
	tolua_beginmodule(tolua_S, "PointVector");
	tolua_function(tolua_S, "Index", tolua_PointVector_Index);
	tolua_function(tolua_S, "Size", tolua_PointVector_Size);
	tolua_function(tolua_S, "Release", tolua_PointVector_Release);
	tolua_endmodule(tolua_S);
	typeName = typeid(PointVector).name();
	g_luaType[typeName] = "PointVector";
	g_typeCast["PointVector"] = "PointVector";

	tolua_usertype(tolua_S, "FishFactory");
	tolua_cclass(tolua_S, "FishFactory", "FishFactory", "", NULL);
	tolua_beginmodule(tolua_S, "FishFactory");
	tolua_function(tolua_S, "getInstance", tolua_FishFactory_getInstance);
	tolua_function(tolua_S, "setLuaFunc", tolua_FishFactory_setcbfun);
	tolua_function(tolua_S, "createFish", tolua_FishFactory_createFish);
	tolua_function(tolua_S, "Start", tolua_FishFactory_Start);
	tolua_function(tolua_S, "Stop", tolua_FishFactory_Stop);
	tolua_function(tolua_S, "build_scene_fish_trace", tolua_FishFactory_build_scene_fish_trace);
	tolua_function(tolua_S, "get_scene_fish_trace", tolua_FishFactory_get_scene_fish_trace);
	tolua_function(tolua_S, "get_scene2_small_fish_stop", tolua_FishFactory_get_scene2_small_fish_stop);
	tolua_function(tolua_S, "get_scene2_big_fish_stop", tolua_FishFactory_get_scene2_big_fish_stop);
	tolua_function(tolua_S, "build_scene_fish_trace2", tolua_FishFactory_build_scene_fish_trace2);
	tolua_function(tolua_S, "get_scene_fish_trace2", tolua_FishFactory_get_scene_fish_trace2);
	tolua_function(tolua_S, "get_scene2_small_fish_stop2", tolua_FishFactory_get_scene2_small_fish_stop2);
	tolua_function(tolua_S, "get_scene2_big_fish_stop2", tolua_FishFactory_get_scene2_big_fish_stop2);
	tolua_endmodule(tolua_S);
	typeName = typeid(FishFactory).name();
	g_luaType[typeName] = "FishFactory";
	g_typeCast["FishFactory"] = "FishFactory";

	tolua_usertype(tolua_S, "MathAide");
	tolua_cclass(tolua_S, "MathAide", "MathAide", "", NULL);
	tolua_beginmodule(tolua_S, "MathAide");	
	tolua_function(tolua_S, "CalcAngle", tolua_MathAide_CalcAngle);
	tolua_function(tolua_S, "BuildLinear", tolua_MathAide_BuildLinear); 
	tolua_function(tolua_S, "GetTargetPoint", tolua_MathAide_GetTargetPoint);
	tolua_function(tolua_S, "GetReboundTargetPoint", tolua_MathAide_GetReboundTargetPoint);
	tolua_endmodule(tolua_S);
	typeName = typeid(MathAide).name();
	g_luaType[typeName] = "MathAide";
	g_typeCast["MathAide"] = "MathAide";

	tolua_module(tolua_S, "LocalStorage", 0);
	tolua_beginmodule(tolua_S, "LocalStorage");
	tolua_function(tolua_S, "localStorageInit", tolua_cocosext_LocalStorage_localStorageInit);
	tolua_function(tolua_S, "localStorageFree", tolua_cocosext_LocalStorage_localStorageFree);
	tolua_function(tolua_S, "localStorageSetItem", tolua_cocosext_LocalStorage_localStorageSetItem);
	tolua_function(tolua_S, "localStorageGetItem", tolua_cocosext_LocalStorage_localStorageGetItem);
	tolua_function(tolua_S, "localStorageRemoveItem", tolua_cocosext_LocalStorage_localStorageRemoveItem);
	tolua_endmodule(tolua_S);

    return 1;
}

extern int register_cocosd_ex(lua_State* L)
{
    lua_getglobal(L, "_G");
    if (lua_istable(L,-1))//stack:...,_G,
    {
        lua_register_cocosd_ex(L);
    }
    lua_pop(L, 1);
    return 1;
}

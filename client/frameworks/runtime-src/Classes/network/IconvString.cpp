#include "IconvString.h"

bool UTF8_2_UCS2(unsigned char* utf8_code, unsigned short* ucs2_code)
{

	unsigned short temp1, temp2;
	bool is_unrecognized = false;
	unsigned char* in = (unsigned char*)utf8_code;

	if (!utf8_code || !ucs2_code)
	{
		return is_unrecognized;
	}

	while (*in != 0)
	{
		//1字节 0xxxxxxx
		//0x80=1000,0000，判断最高位是否为0，如果为0，那么是ASCII字符
		//不需要处理，直接拷贝即可
		if (0x00 == (*in & 0x80))
		{
			/* 1 byte UTF-8 Charater.*/
			*ucs2_code = *in;
			is_unrecognized = true;
			in += 1;
		}
		//2字节 110xxxxx 10xxxxxx 
		//0xe0=1110,0000
		//0xc0=1100,0000
		else if (0xc0 == (*in & 0xe0) && 0x80 == (*(in + 1) & 0xc0))
		{
			/* 2 bytes UTF-8 Charater.*/
			//0x1f=0001,1111，获得第一个字节的后5位
			temp1 = (unsigned short)(*in & 0x1f);

			//左移6位
			temp1 <<= 6;

			//0x3f=0011,1111，获得第二个字节的后6位
			//加上上面的5位一共有11位
			temp1 |= (unsigned short)(*(in + 1) & 0x3f);

			*ucs2_code = temp1;

			is_unrecognized = true;

			in += 2;
		}
		//3字节 1110xxxx 10xxxxxx 10xxxxxx
		//中文要进入这一个分支
		else if (0xe0 == (*in & 0xf0) &&
			0x80 == (*(in + 1) & 0xc0) &&
			0x80 == (*(in + 2) & 0xc0)
			)
		{
			/* 3bytes UTF-8 Charater.*/
			//0x0f=0000,1111
			//取出第一个字节的低4位
			temp1 = (unsigned short)(*in & 0x0f);
			temp1 <<= 12;

			//0x3f=0011,1111
			//取得第二个字节的低6位
			temp2 = (unsigned short)(*(in + 1) & 0x3F);
			temp2 <<= 6;

			//取得第三个字节的低6位，最后组成16位
			temp1 = temp1 | temp2 | (unsigned short)(*(in + 2) & 0x3F);
			*ucs2_code = temp1;

			//移动到下一个字符
			in += 3;
			is_unrecognized = true;
		}
		else
		{
			/* unrecognize byte. */
			*ucs2_code = 0x22e0;
			is_unrecognized = false;

			//直接退出循环
			break;
		}

		ucs2_code += 1;
	}

	return is_unrecognized;

}

bool UCS2_2_UTF8(unsigned short* ucs2_code, unsigned char* utf8_code)
{

	unsigned char* out = utf8_code;

	if (!utf8_code)
	{
		return false;
	}

	while (*ucs2_code != 0)
	{
		if (0x0080 > *ucs2_code)
		{
			/* 1 byte UTF-8 Character.*/
			*out = (unsigned char)*ucs2_code;
			++out;
		}
		else if (0x0800 > *ucs2_code)
		{
			/*2 bytes UTF-8 Character.*/
			*out = ((unsigned char)(*ucs2_code >> 6)) | 0xc0;
			*(out + 1) = ((unsigned char)(*ucs2_code & 0x003F)) | 0x80;
			out += 2;
		}
		else
		{
			/* 3 bytes UTF-8 Character .*/
			*out = ((unsigned char)(*ucs2_code >> 12)) | 0xE0;
			*(out + 1) = ((unsigned char)((*ucs2_code & 0x0FC0) >> 6)) | 0x80;
			*(out + 2) = ((unsigned char)(*ucs2_code & 0x003F)) | 0x80;
			out += 3;
		}

		//挪动两个字节
		++ucs2_code;
	}

	return true;

}
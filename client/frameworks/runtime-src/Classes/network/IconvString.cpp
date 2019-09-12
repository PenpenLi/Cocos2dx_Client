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
		//1�ֽ� 0xxxxxxx
		//0x80=1000,0000���ж����λ�Ƿ�Ϊ0�����Ϊ0����ô��ASCII�ַ�
		//����Ҫ����ֱ�ӿ�������
		if (0x00 == (*in & 0x80))
		{
			/* 1 byte UTF-8 Charater.*/
			*ucs2_code = *in;
			is_unrecognized = true;
			in += 1;
		}
		//2�ֽ� 110xxxxx 10xxxxxx 
		//0xe0=1110,0000
		//0xc0=1100,0000
		else if (0xc0 == (*in & 0xe0) && 0x80 == (*(in + 1) & 0xc0))
		{
			/* 2 bytes UTF-8 Charater.*/
			//0x1f=0001,1111����õ�һ���ֽڵĺ�5λ
			temp1 = (unsigned short)(*in & 0x1f);

			//����6λ
			temp1 <<= 6;

			//0x3f=0011,1111����õڶ����ֽڵĺ�6λ
			//���������5λһ����11λ
			temp1 |= (unsigned short)(*(in + 1) & 0x3f);

			*ucs2_code = temp1;

			is_unrecognized = true;

			in += 2;
		}
		//3�ֽ� 1110xxxx 10xxxxxx 10xxxxxx
		//����Ҫ������һ����֧
		else if (0xe0 == (*in & 0xf0) &&
			0x80 == (*(in + 1) & 0xc0) &&
			0x80 == (*(in + 2) & 0xc0)
			)
		{
			/* 3bytes UTF-8 Charater.*/
			//0x0f=0000,1111
			//ȡ����һ���ֽڵĵ�4λ
			temp1 = (unsigned short)(*in & 0x0f);
			temp1 <<= 12;

			//0x3f=0011,1111
			//ȡ�õڶ����ֽڵĵ�6λ
			temp2 = (unsigned short)(*(in + 1) & 0x3F);
			temp2 <<= 6;

			//ȡ�õ������ֽڵĵ�6λ��������16λ
			temp1 = temp1 | temp2 | (unsigned short)(*(in + 2) & 0x3F);
			*ucs2_code = temp1;

			//�ƶ�����һ���ַ�
			in += 3;
			is_unrecognized = true;
		}
		else
		{
			/* unrecognize byte. */
			*ucs2_code = 0x22e0;
			is_unrecognized = false;

			//ֱ���˳�ѭ��
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

		//Ų�������ֽ�
		++ucs2_code;
	}

	return true;

}
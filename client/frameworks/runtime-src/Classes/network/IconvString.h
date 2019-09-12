#ifndef ICONV_STRING_H
#define ICONV_STRING_H

bool UTF8_2_UCS2(unsigned char* utf8_code, unsigned short* ucs2_code);
bool UCS2_2_UTF8(unsigned short* ucs2_code, unsigned char* utf8_code);
#endif

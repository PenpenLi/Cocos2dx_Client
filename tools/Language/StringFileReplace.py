#!/usr/bin/python
#coding=utf-8

import os
import sys
import json

ESCAPE_CHARACTERS = [
	{"origin":'\a', "target":r'\a'},
	{"origin":'\b', "target":r'\b'},
	{"origin":'\f', "target":r'\f'},
	{"origin":'\n', "target":r'\n'},
	{"origin":'\r', "target":r'\r'},
	{"origin":'\t', "target":r'\t'},
	{"origin":'\v', "target":r'\v'},
	# {"origin":'\\', "target":r'\\'},
	{"origin":'\'', "target":r'\''},
	{"origin":'\"', "target":r'\"'}
]

config = None

def json_load_byteified(file_handle):
  return _byteify(
    json.load(file_handle, object_hook=_byteify),
    ignore_dicts=True
  )

def json_loads_byteified(json_text):
  return _byteify(
    json.loads(json_text, object_hook=_byteify),
    ignore_dicts=True
  )

def _byteify(data, ignore_dicts = False):
  if isinstance(data, unicode):
    return data.encode('utf-8')
  if isinstance(data, list):
    return [ _byteify(item, ignore_dicts=True) for item in data ]
  if isinstance(data, dict) and not ignore_dicts:
    return {
      _byteify(key, ignore_dicts=True): _byteify(value, ignore_dicts=True)
      for key, value in data.iteritems()
    }
  return data

def loadConfig():
  global config
  path = os.path.join(os.getcwd(), "LanguageSupport", "vn.json")
  f = open(path)
  config = json_load_byteified(f)

def normalizeString(originString):
	for value in ESCAPE_CHARACTERS:
		originString = originString.replace(value["origin"], value["target"])
	return originString

if __name__ == '__main__':
	if len(sys.argv) < 3:
		print u"请输入完整参数:\n    参数1.文件夹路径\n    参数2.文件后缀名"
	else:
		loadConfig()

		path = sys.argv[1]
		ext = sys.argv[2]

		for root, dirs, files in os.walk(path):
			for filename in files:
				extname = os.path.splitext(filename)[1]
				if ext == extname:
					fullname = '%s/%s' % (root, filename)
					try:
						fr = open(fullname,'rb')
						content = fr.read()
						fr.close()
						for key in config:
							value = normalizeString(config[key])
							findValue = "\"%s\""%(value)
							ret = content.find(findValue)
							if ret != -1:
								content = content.replace(findValue, "LocalLanguage:getLanguageString(\"%s\")"%(key))
						fw = open(fullname,'wb')
						fw.write(content)
						fw.close()
					except Exception, e:
						print "%s open failed!"%fullname
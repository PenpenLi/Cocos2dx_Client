#!/usr/bin/python
#coding=utf-8

import os
import sys
import json
import re
import hashlib

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

def hash4string(content):
	return hashlib.md5(content).hexdigest()[8:-8]

def loadConfig():
  global config
  f = open('StringExtract.json')
  config = json_load_byteified(f)

if __name__ == '__main__':
	if len(sys.argv) < 3:
		print u"请输入完整参数:\n    参数1.文件夹路径\n    参数2.文件后缀名"
	else:
		loadConfig()

		path = sys.argv[1]
		ext = sys.argv[2]

		matchDic = {}
		filters = config["filters"]
		patterns = config["patterns"]
		pathOut = os.path.join(os.getcwd(), "fileout.txt")
		fileout = open(pathOut,'wb')

		for root, dirs, files in os.walk(path):
			for filename in files:
				extname = os.path.splitext(filename)[1]
				if ext == extname:
					fullname = '%s/%s' % (root, filename)
					try:
						file = open(fullname,'rb')
						content = file.read()
						file.close()
						itr = re.finditer(r'\"(.+?)\"', content, re.I|re.M)
						for match in itr:
							bFilter = False
							bParrern = False
							matchString = match.group(1)
							for filterString in filters:
								ret = matchString.find(filterString)
								if ret != -1:
									bFilter = True
									break
							for patString in patterns:
								pattern = re.compile(patString)
								ret = pattern.search(matchString)
								if ret:
									bParrern = True
									break
							if (not bFilter) and (not bParrern):
								hashstr = hash4string(matchString)
								matchDic[hashstr] = matchString
					except Exception, e:
						print "%s open failed!"%fullname

		for key in matchDic:
			fileout.write("%s|%s\n"%(key,matchDic[key]))

		fileout.close()
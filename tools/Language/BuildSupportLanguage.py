#!/usr/bin/python
#coding=utf-8

import os
import xlrd

if __name__ == '__main__':
	pathExcel = os.path.join(os.getcwd(), "Language.xlsx")
	wb = xlrd.open_workbook(pathExcel)
	sheet = wb.sheet_by_index(0)
	for x in range(1, sheet.ncols):
		languageList = []
		for y in range(1, sheet.nrows):
			key = sheet.cell(y, 0).value
			value = sheet.cell(y, x).value.encode("utf-8")
			languageList.append({"id":key, "value":value})

		lenList = len(languageList)
		languageName = sheet.cell(0, x).value
		filename = os.path.join(os.getcwd(), "LanguageSupport", "%s.json"%(languageName))
		file = open(filename, 'wb')
		file.write("{\n")
		for index in range(lenList):
			data = languageList[index]
			if index < lenList - 1:
				file.write("\"L_%s\":"%(data["id"]))
				file.write("\"")
				file.write(data["value"])
				file.write("\",\n")
			else:
				file.write("\"L_%s\":"%(data["id"]))
				file.write("\"")
				file.write(data["value"])
				file.write("\"\n")
		file.write("}")
		file.close()
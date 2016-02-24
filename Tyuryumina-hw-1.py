import argparse
import csv
import imp
import math
import os
import sys
import string
import stdin

inputFileName = sys.argv[1]
outputFileName = sys.argv[2]

myDictionary = {}

if len(sys.argv) > 3:
    myFunction = sys.argv[3]
    if myFunction[-3:] == '.py':
        myFunction = myFunction[:-3]
# begin of copyright
# from
# http://stackoverflow.com/questions/19009932/import-abitrary-python-source-file-python-3-3
        openfile, pathname, description = imp.find_module(myFunction)
        myFunction = imp.load_module(
            myFunction, openfile, pathname, description)
        myDictionary.update(myFunction.__dict__)
# end of copyrigth

readedInputFile = csv.reader(open(inputFileName, "rb"))

myDataTable = []

for row in readedInputFile:
    myDataTable.append(row)


def touch(path):
    with open(path, outputFileName):
        os.utime(path, None)


wroteOutputFile = csv.writer(open(outputFileName, "wb"))

ns = vars(math).copy()
ns['__builtins__'] = None

i = 0
dataRows = []

for row in myDataTable:
    j = 0
    dataRows.append([])
    for cellInRow in row:
        j += 1
        try:
            if cellInRow[0] != "=":
                try:
                    myDictionary[chr(j + 64) + str(i + 1)] = eval(cellInRow)
                    dataRows[i].append(eval(cellInRow))
                except SyntaxError:
                    myDictionary[chr(j + 64) + str(i + 1)] = cellInRow
                    dataRows[i].append(cellInRow)
                except NameError:
                    dataRows[i].append("[X]ERROR")
            else:
                dataRows[i].append(0)
        except IndexError:
            myDataTable[i][j - 1] = '0'
            myDictionary[chr(j + 64) + str(i + 1)] = 0
            dataRows[i].append(0)
    i += 1

i = 0
for row in myDataTable:
    j = 0
    for cellInRow in row:
        if cellInRow[0] == "=":
            try:
                dataRows[i][j] = eval(cellInRow[1:], ns, myDictionary)
            except NameError:
                try:
                    dataRows[i][j] = eval(cellInRow[1:], myDictionary)
                except NameError:
                    dataRows[i][j] = "[X]ERROR"
            j += 1
        else:
            j += 1
    i += 1

wroteOutputFile.writerows(dataRows)

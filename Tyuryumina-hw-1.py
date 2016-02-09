import csv, math, os

readedInputFile = csv.reader(open("0.7-CustomScript-input.csv","rb"))

myDataTable = []

for row in readedInputFile:
      myDataTable.append(row)

def touch(path):
    with open(path, 'output.csv'):
        os.utime(path, None)
wroteOutputFile = csv.writer(open("output.csv", "wb"))

ns = vars(math).copy()
ns['__builtins__'] = None

def myF(s1, s2, repeat):
        return (s1 + ", " + s2 + "!") * repeat
      
i = 0
myDictionary = {}
dataRows = []

for row in myDataTable:
      j  = 0
      dataRows.append([])
      for cellInRow in row:
            j+=1
            try:
                  if cellInRow[0] != "=":
                        try:
                              myDictionary[chr(j+64) + str(i+1)] = eval(cellInRow)
                              dataRows[i].append(eval(cellInRow))
                        except SyntaxError:
                              myDictionary[chr(j+64) + str(i+1)] = cellInRow
                              dataRows[i].append(cellInRow)
                  else:
                        dataRows[i].append(0)
            except IndexError:
                  myDataTable[i][j-1] = '0' 
                  myDictionary[chr(j+64) + str(i+1)] = 0
                  dataRows[i].append(0)
      i += 1

i = 0
for row in myDataTable:
      j  = 0
      for cellInRow in row:
            if cellInRow[0] == "=":
                  try:
                        dataRows[i][j] = eval(cellInRow[1:], ns, myDictionary)
                  except NameError:
                        dataRows[i][j] = eval(cellInRow[1:], globals(), myDictionary)
                  j+=1
            else:
                  j+=1           
      i += 1

wroteOutputFile.writerows(dataRows)

 
  
    
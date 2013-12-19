import lib
import reader
import tablestr
import random

def uxvals(tables, x, b):
    rows = lib.indexes(tables['0'].data[0])
    s = int(len(rows)/b)
    uxvaltables = {}
    for i in range(x):      # x times
        random.shuffle(rows)
        for b1 in range(b): # b bins
            obj = uxval(b1*s, (b1+1)*s, rows, tables)
            uxvaltables[i*x+b1+1] = obj
    return uxvaltables
     
       
def uxval(start, stop, rows, tables):
    testT = tablestr.Table()
    trainT = tablestr.Table()
    reader.makeTable(tables['0'].name, testT)
    reader.makeTable(tables['0'].name, trainT)
    for r in range(len(rows)):
        d = rows[r]
        a = []
        for j in range(len(tables['0'].order)):
            a.append(tables['0'].data[j][d])        
        if r >= start and r < stop: #belonging to testing data set
            reader.addRow(a, testT)
        else:
            reader.addRow(a, trainT)
    test = {}
    train = {}
    test['0'] = testT
    train['0'] = trainT
    tables = {}
    tables['train'] = train
    tables['test'] = test
    return tables
    
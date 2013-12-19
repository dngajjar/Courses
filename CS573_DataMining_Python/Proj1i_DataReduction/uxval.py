import lib
import reader
import tablestr
import random

def uxvals(table, x, b):
    rows = lib.indexes(table.data[0])
    s = int(len(rows)/b)
    uxvaltables, xvaltables = {}, {}
    #uxvaltables = {}
    for i in range(x):      # x times
        random.shuffle(rows)
        for b1 in range(b): # b bins
            obj1 = uxval(b1*s, (b1+1)*s, rows, table)
            obj2 = xval(b1*s, (b1+1)*s, rows, table)
            uxvaltables[i*x+b1+1] = obj1
            xvaltables[i*x+b1+1] = obj2
    #tablestr.tableprint(uxvaltables[1]['test']['0'])
    #tablestr.tableprint(xvaltables[1]['test']['all'])
    #tablestr.tableprint(xvaltables[1]['test']['0'])
    return uxvaltables, xvaltables

def xval(start, stop, rows, tables):
    testT = tablestr.Table()
    trainT = tablestr.Table()
    reader.makeTable(tables.name, testT)
    reader.makeTable(tables.name, trainT)
    for r in range(len(rows)):
        d = rows[r]
        a = []
        for j in range(len(tables.order)):
            a.append(tables.data[j][d])        
        if r >= start and r < stop: #belonging to testing data set
            reader.addRow(a, testT)
        else:
            reader.addRow(a, trainT)
    testT = reader.klasses(testT)
    trainT = reader.klasses(trainT)
    tables = {}
    tables['train'] = trainT
    tables['test'] = testT
    return tables    
       
def uxval(start, stop, rows, table):
    testT = tablestr.Table()
    trainT = tablestr.Table()
    reader.makeTable(table.name, testT)
    reader.makeTable(table.name, trainT)
    for r in range(len(rows)):
        d = rows[r]
        a = []
        for j in range(len(table.order)):
            a.append(table.data[j][d])        
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
    
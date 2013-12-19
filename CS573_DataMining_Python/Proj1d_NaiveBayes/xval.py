import lib 
import tablestr 
import reader 
import random

def xvals(tables, x, b):
    k = tables['0'].order.index(tables['0'].klass[0]) 
    rows = lib.indexes(tables['0'].data[k])
    s = int(len(rows)/b)
    xvaltables = {}
    #xvaltables['0'] = tables['0']
    #xvaltables['names'] = tables['names']
    for i in range(x):      # x times
        random.shuffle(rows)
        for b1 in range(b): # b bins
            obj = xval(b1*s, (b1+1)*s, rows, tables)
            xvaltables[i*x+b1+1] = obj
    return xvaltables
     
       
def xval(start, stop, rows, tables):
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
    testT = reader.klasses(testT)
    trainT = reader.klasses(trainT)
    tables = {}
    tables['train'] = trainT
    tables['test'] = testT
    return tables
    
    
            
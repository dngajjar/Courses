import reader
import dist
import xval
import lib
import tablestr

def knn(testT, trainT, tables, kn):
    tablestr.tableprint(trainT['0'])
    k = testT['0'].klass[0]
    acc = 0.0
    for d in range(len(testT['0'].data[0])):
        want = testT['0'].data[k][d]
        row = [testT['0'].data[s][d] for s in range(len(testT['0'].data))]        
        got = knn1(row, trainT, tables, kn)
        acc += want == got
        print 'want:', want, ' got:', got
    return 100 * float(acc/len(testT['0'].data[0]))
    
def knn1(this, trainT, tables, kn):
    kmax = neighbors(this, trainT, tables)
    print '\n>Test Case: ' + lib.rowprint(this, 5)
    for k in range(len(kmax)):
        that = [trainT['0'].data[s][int(kmax[k][0])] for s in range(len(trainT['0'].data))]
        print k+1, tables['0'].CONVFMT%float(kmax[k][1]), lib.rowprint(that, 5)
    seen = nearestk(this, kn, trainT, kmax)
    return mostSeen(seen)
    
def neighbors(this, trainT, tables):
    lst = {}
    for d in range(len(trainT['0'].data[0])):
        that = [trainT['0'].data[s][d] for s in range(len(trainT['0'].data))]
        lst[d] = dist.dist(this, that, range(len(trainT['0'].data)-1), tables['0'])
    return sorted(lst.items(), key=lambda d:d[1])
        
def nearestk(this, kn, trainT, lst):
    k = trainT['0'].klass[0]  # get index for class
    seen = {}    
    for i in range(kn):
        that = int(lst[i][0])
        got = trainT['0'].data[k][that]  
        if got in seen.keys():  seen[got] += 1
        else: seen[got] = 0
    return seen
     
def mostSeen(seen):
    maxval = 0
    out = seen.keys()[0]
    for s in seen.keys():
        if seen[s] > maxval: maxval = seen[s]; out = s
    return out
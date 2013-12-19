import reader
import dist
import xval
import lib
import tablestr

def knn(testT, trainT, kn):
    k = testT['0'].klass[0]
    acc = 0.0
    TN = FN = FP = TP = float(lib.PINCH)
    for d in range(len(testT['0'].data[0])):
        want = int(testT['0'].data[k][d])
        row = [testT['0'].data[s][d] for s in range(len(testT['0'].data))]        
        got = int(knn1(row, trainT, kn))
        if want == got:
            acc += want == got
            if want == 0: TN += 1
            else: TP += 1
        else:
            if want == 0: FP += 1
            else: FN += 1
    try: 
        prec = TP/ (TP + FP + lib.PINCH)
    except:
        prec = lib.PINCH
    try:
        pd = TP/(TP+FN+lib.PINCH)
    except:
        pd = lib.PINCH
    try:
        f = (2*pd*prec)/(pd+prec+lib.PINCH)
    except:
        f = lib.PINCH
    return 100 * float(acc/len(testT['0'].data[0])), f, prec, pd
    
def knn1(this, trainT, kn):
    kmax = neighbors(this, trainT )
    seen = nearestk(this, kn, trainT, kmax)
    return mostSeen(seen)
    
def neighbors(this, trainT):
    lst = {}
    for d in range(len(trainT['0'].data[0])):
        that = [trainT['0'].data[s][d] for s in range(len(trainT['0'].data))]
        lst[d] = dist.dist(this, that, range(len(trainT['0'].data)-1), trainT['0'])
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
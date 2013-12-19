import dist
import lib
import tablestr
def knn(testT, trainT, kn, thresh):
    k = testT.klass[0]
    acc = 0.0
    TN = FN = FP = TP = float(lib.PINCH)
    #if len(trainT.data) < 15: tablestr.tableprint(trainT)
    for d in range(len(testT.data[0])):
        want = int(testT.data[k][d])
        row = [testT.data[s][d] for s in range(len(testT.data))]        
        got = knn1(row, trainT, kn)
        got = 1 if got >= thresh else 0
        if want == got:
            acc += want == got
            if want == 0:TN += 1
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

    return 100 * float(acc/len(testT.data[0])), f, prec, pd
    
def knn1(this, trainT, kn):
    kmax = neighbors(this, trainT)
    """
    print '\n>Test Case: ' + lib.rowprint(this, 5)
    for k in range(len(kmax)):
        that = [trainT.data[s][int(kmax[k][0])] for s in range(len(trainT.data))]
        print k+1, trainT.CONVFMT%float(kmax[k][1]), lib.rowprint(that, 5)
    """
    seen = nearestk(this, kn, trainT, kmax)
    return aved_defect_rate(seen)
    
def neighbors(this, trainT):
    lst, newlst, t = {}, {}, 0
    for d in range(len(trainT.data[0])):
        that = [trainT.data[s][d] for s in range(trainT.klass[0])]
        xx = trainT.name.index('$_XX') 
        lst[d] = dist.dist(this, that, [xx, xx+1], trainT)
    while(len(lst.keys())):
        minv = min(lst.values())
        for i in lst.keys():
            if minv == lst[i]: 
                ind = i; break
        newlst[t] = [i, minv]
        lst.pop(ind)
        t += 1    
    return newlst
        
def nearestk(this, kn, trainT, lst):
    k = trainT.name.index('$_Hell')  # get index for class
    seen = {} 
    for i in range(kn):
        that = int(lst[i][0])
        got = trainT.data[k][that]
        seen[i] = [float(lst[i][1]), float(got)]
    return seen
     
def aved_defect_rate(seen):
    k = len(seen) 
    sumv, totalv = 0.0, 0.0
    for i in range(k):
        sumv += seen[i][1]/(seen[i][0]+10**-7)
        totalv += 1/(seen[i][0]+10**-7)
    return sumv/totalv
    
def mostSeen(seen):
    maxval = 0
    out = seen.keys()[0]
    for s in seen.keys():
        if seen[s] > maxval: maxval = seen[s]; out = s
    return out
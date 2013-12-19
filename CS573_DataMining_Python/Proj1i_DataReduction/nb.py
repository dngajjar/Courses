import lib
import math
def nb(testT, trainT, hypotheses, k, m):
    ck = testT['all'].klass[0] #locate the index for class col
    #print len(testT['all'].data[0]), len(trainT['all'].data[0])
    total = acc = 0.0    
    total += len(trainT['all'].data[ck])
    TN = FN = FP = TP = float(lib.PINCH)
    #print len(testT['all'].data[ck])
    for t in range(len(testT['all'].data[ck])):
        want = int(testT['all'].data[ck][t])
        row = []
        for i in range(len(testT['all'].data)):
            row += [testT['all'].data[i][t]]
        got = int(likelihood(row, trainT, total, hypotheses, k, m))
        #print 'want=', want, ' got=', got
        if want == got:
            acc += 1
            if want == 0: TN += 1
            else: TP += 1
        else:
            if want == 0: FP += 1
            else: FN += 1
    #print 'TN =', TN, 'TP =', TP, 'FN =', FN, 'FP =', FP
    try: 
        prec = TP/ (TP + FP)
    except:
        prec = lib.PINCH
    try:
        pd = TP/(TP+FN)
    except:
        pd = lib.PINCH
    try:
        f = (2*pd*prec)/(pd+prec)
    except:
        f = lib.PINCH
    #print 'prec= ', prec, ' pd= ', pd, ' f= ', f
    return 100 * acc/len(testT['all'].data[ck]), f, prec, pd
    
def likelihood(row, trainT, total, hypotheses, k, m):
    like = lib.NINF
    total += k * len(hypotheses)
    best = ''
    for h in hypotheses:
        nh = len(trainT[h].data[trainT['all'].klass[0]])
        prior = float(nh + k)/total
        tmp = prior
        for c in trainT[h].nump:
            i = trainT[h].nump.index(c)
            x = row[c]
            if x == "?": continue
            y = lib.norm(float(x), float(trainT[h].mu[i]), float(trainT[h].sd[i]))
            tmp *= y
        for c in trainT[h].term:
            x = row[c]
            if x == "?": continue
            y = 0.0
            for i in range(len(trainT[h].data[c])):
                if trainT[h].data[c][i] == x: y+= 1
            tmp *= (y + m*prior) / (nh +m)
        #print 'h =', h,' tmp=', tmp
        if tmp >= like: 
            like = tmp
            best = h
        """
        # log version
        tmp = math.log(prior)
        for c in trainT[h].num:
            x = row[c]
            if x == "?": continue
            y = lib.norm(float(x), float(trainT[h].mu[c]), float(trainT[h].sd[c]))
            tmp += math.log(y)
        for c in trainT[h].term:
            x = row[c]
            if x == "?": continue
            y = 0.0
            for i in range(len(trainT[h].data[c])):
                if trainT[h].data[c][i] == x: y+= 1
            tmp += math.log((y + m*prior) / (nh +m))
        if tmp >= like: 
            like = tmp
            best = h
        """
    return best
            
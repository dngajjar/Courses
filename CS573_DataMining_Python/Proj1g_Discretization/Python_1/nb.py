import lib

def nb(testT, trainT, hypotheses, k, m):
    ck = testT['0'].klass[0] #locate the index for class col
    total = acc = 0.0    
    total += len(trainT['0'].data[ck])
    for t in range(len(testT['0'].data[ck])):
        want = testT['0'].data[ck][t]
        row = []
        for i in range(len(testT['0'].data)):
            row += [testT['0'].data[i][t]]
        got = likelihood(row, trainT, total, hypotheses, k, m)
        acc += want == got
    return 100 * acc/len(testT['0'].data[ck])
    
def likelihood(row, trainT, total, hypotheses, k, m):
    like = lib.NINF
    total += k * len(hypotheses)
    best = ''
    for h in hypotheses:
        nh = len(trainT[h].data[trainT['0'].klass[0]])
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
        if tmp >= like: 
            like = tmp
            best = h
        """
        # log version
        tmp = math.log(prior)
        for c in trainT[h].num:
            x = row[c]
            if x == "?": continue
            y = lib.norm(x, trainT[h].mu[c], trainT[h].sd[c])
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
            
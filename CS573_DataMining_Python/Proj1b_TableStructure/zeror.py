def zeror(testT, trainT, hypotheses):
    k = testT['0'].klass[0]
    most = 0
    for h in hypotheses:
        these = len(trainT[h].data[k]) if h in trainT['names'] else 0
        if these > most:
            most = these
            got = h
    print "#got", got
    acc = len(testT[got].data[k]) if got in testT['names'] else 0
    num = 0
    for h in hypotheses: num += len(testT[h].data[k]) if h in testT['names'] else 0
    print 'Accuracy:'+ str(100*float(acc)/num)
            
    
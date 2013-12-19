import lib

def dist(this, that, lst, table, normF = True):
    sum = 0.0    
    for k in lst:
        v1 = this[k]
        v2 = that[k]
        if v1 == '?' and v2 == '?': sum += 1
        elif k in table.nump:            
            i = table.nump.index(k)
            mid = (float(table.hi[i]) - float(table.lo[i]))/2
            aLittle = 10**-7
            if v1 == '?': 
                if normF: v1 = 1.0 if v2 < mid else 0.0  
                else: v1 = table.hi[i] if v2 < mid else table.lo[i]
            else: 
                v1 = (float(v1) - float(table.lo[i]))/(float(table.hi[i]) - float(table.lo[i]) + aLittle)
            if v2 == '?': 
                if normF: v2 = 1.0 if v1 < mid else 0.0
                else: v2 = table.hi[i] if v1 < mid else table.lo[i]
            else:
                v2 = (float(v2) - float(table.lo[i]))/(float(table.hi[i]) - float(table.lo[i]) + aLittle)
            sum += (float(v2) -float(v1))**2
        else:
            if v1 == '?': sum += 1.0
            elif v2 == '?': sum += 1.0
            elif v1 != v2: sum +=1.0
            else: sum += 0.0
    return sum**0.5/len(lst)**0.5
    
def closest(i, table):
    minval = lib.INF
    this = [table.data[s][i] for s in range(len(table.data))]
    for j in range(len(table.data[0])):
        if i == j: continue
        that = [table.data[s][j] for s in range(len(table.data))]
        d = dist(this, that, table.indep, table)
        if d < minval: minval = d; out = j  
    row = []
    row = [table.data[s][out] for s in range(len(table.data))]
    return row, out
    
def furthest(i, table):
    maxval = lib.NINF
    this = [table.data[s][i] for s in range(len(table.data))]
    for j in range(len(table.data[0])):
        if i == j: continue
        that = [table.data[s][j] for s in range(len(table.data))]
        d = dist(this, that, table.indep, table)
        if d > maxval: maxval = d; out = j
    row = []
    row = [table.data[s][out] for s in range(len(table.data))]
    return row, out
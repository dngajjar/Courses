import lib

def dist(this, that, lst, table):
    sum = 0.0    
    for k in lst:
        v1 = this[k]
        v2 = that[k]
        if v1 == '?' and v2 == '?': sum += 1
        elif k in table.nump:            
            i = table.nump.index(k)
            #print table.lo[i], table.hi[i]
            aLittle = 10**-7
            if v1 == '?': v1 = 1.0 if v2 < 0.5 else 0.0             
            else: 
                v1 = (float(v1) - float(table.lo[i]))/(float(table.hi[i]) - float(table.lo[i]) + aLittle)
            if v2 == '?': v2 = 1.0 if v1 < 0.5 else 0.0
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
    this = [table.data[i][s] for s in range(len(table.data))]
    for j in range(len(table.data[0])):
        if i == j: continue
        that = [table.data[j][s] for s in range(len(table.data))]
        d = dist(this, that, table.indep, table)
        if d < minval: minval = d; out = j      
    return out
    
def furthest(i, table):
    maxval = lib.NINF
    this = [table.data[i][s] for s in range(len(table.data))]
    for j in range(len(table.data[0])):
        if i == j: continue
        that = [table.data[j][s] for s in range(len(table.data))]
        d = dist(this, that, table.indep, table)
        if d > maxval: maxval = d; out = j      
    return out
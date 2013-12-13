def indexes(data):
    rows = []   #get the indexes for the data
    for i in range(len(data)):
        rows.append(i)
    return rows

def rowprint(a):
    max = len(a)
    line = ''
    for j in range(max):
        line += (a[j] + ',').rjust(15)
    return line
    
def maybeInt(x):
    return int(x) if x % 1 == 0.0 else float(x)
    
    
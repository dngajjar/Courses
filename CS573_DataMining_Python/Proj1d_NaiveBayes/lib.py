import math
inf = 10^17
NINF = -1 * inf
PINCH = 1 / inf
PI = 3.1415926535
EE = 2.7182818284

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
    
def norm(x, m, s):
    s += PINCH
    return 1/math.sqrt(2*PI*s**2.0)*EE^(-1*(x-m)**2.0/(2*s**2.0))
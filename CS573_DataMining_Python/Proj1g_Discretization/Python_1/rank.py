import math
import lib
class Num:
    def __init__(i):
        i.mu = {}
        i.sum = {}
        i.m2 = {}
        i.var = {}
        i.n = {}
        i.x = {}
        i.label = {}
        i.name = []
    
class Div:
    def __init__(i):
        i.total = []
        i.cohen = []
        i.mittas = []
        i.a12 = []
        i.order = {}
        i.level = 0
        
def ranks(filename, a):
    print "\n----|", filename,"|---------------------"
    f = open(filename)
    _Nums = Num()
    _Div = Div()
    obs(f,0,_Nums,_Div)
    rank(0,_Nums,_Div,a)
    maxv = len(_Div.order.keys())
    for i in range(maxv): 
        i = i+ 1
        k = _Div.order[i]['=']
        print k, ':mu', _Nums.mu[k], ':rank', _Nums.label[k]
     
def obs(f, all, _Nums, _Div):
    now = all
    line = f.readline()
    while line:
        line = line.split()
        for i in line:
            if i[0].isdigit(): 
                v = float(i)
                inc(v, now, _Nums)
                inc(v, all, _Nums)
            else: now = i
        line = f.readline()
    f.close()

    for i in _Nums.name:
        if i != all:
            temp={}
            temp['='] = i
            temp['x'] = _Nums.mu[i]
            _Div.order[i] = temp
    s = 0
    norder = {}
    while s < len(_Nums.name)-1:
        tmp = 10**17
        ind = 0
        s = s+1
        norder[s] = {}
        for i in _Div.order.keys():
            if tmp > _Div.order[i]['x']: 
                tmp = _Div.order[i]['x']
                ind = i
        norder[s]['='] = _Div.order[ind]['=']
        norder[s]['x'] = _Div.order[ind]['x']
        del _Div.order[ind]        
    _Div.order = norder              
def inc(v, k, nums):   
    nums.label[k] = 0
    if k not in nums.name:
        nums.name += [k]
        nums.n[k] = 0
        all = nums.n[k] = nums.n[k] + 1
        nums.x[k] = []
        nums.sum[k] = v
        delta = float(v)
        nums.mu[k] = float(delta/all)
        nums.m2[k] = 0
        nums.var[k] = 0
    else:
        all = nums.n[k] = nums.n[k] + 1
        nums.sum[k] = nums.sum[k] + v
        delta = v - nums.mu[k]
        nums.mu[k] = nums.mu[k] + delta/all
        nums.m2[k] = nums.m2[k] + float(delta*(v-nums.mu[k]))
        nums.var[k] = float(nums.m2[k])/float(all - 1 + lib.PINCH) 
    nums.x[k] += [v]   
    
def rank(all,nums,div,a):
     div.cohen  = float(a["-cohen"])*math.sqrt(nums.var[all])
     div.mittas = a["--mittas"]
     div.a12    = a["-a12"]
     div.level  = 0
     div.total  = nums.n[all]
     rdiv(1,len(div.order.keys()),1,nums, div)


def rdiv(lo, hi, c, nums, div):
    cut = divm(lo, hi, nums, div)
    if cut:
        div.level = div.level + 1
        c = rdiv(lo, cut-1, c, nums, div) + 1
        c = rdiv(cut, hi, c, nums, div)
    else:
        for i in range(lo, hi+1): nums.label[div.order[i]['=']] = c
    return c

def divInits(lo,hi,nums,div,num0,num1):
    b= div.order[lo]["="]; 
    num0.n[lo]= nums.n[b]; 
    num0.sum[lo]= nums.sum[b]
    b= div.order[hi]["="]; 
    num1.n[hi]= nums.n[b]; 
    num1.sum[hi]= nums.sum[b]
    for i in range(hi-1, lo-1, -1):
        b = div.order[i]['=']
        num1.n[i] = num1.n[i+1] + nums.n[b]
        num1.sum[i] = num1.sum[i+1] + nums.sum[b]
    return num1.sum[lo]/num1.n[lo]


def divm(lo, hi, nums, div):
   num0 = Num()
   num1 = Num()
   muAll = divInits(lo,hi,nums, div, num0, num1)
   maxv   = -1
   cut = None
   for i in range(lo+1, hi+1):
       b = div.order[i]['=']
       num0.n[i] = num0.n[i-1] + nums.n[b]
       num0.sum[i] = num0.sum[i-1] + nums.sum[b]
       left = num0.n[i]
       muLeft = num0.sum[i]/left
       right = num1.n[i]
       muRight = num1.sum[i]/right
       e = errDiff(muAll, left, muLeft, right, muRight)
       if div.cohen:
           if abs(muLeft - muRight) <= float(div.cohen): continue
       if div.mittas:
           if e < maxv:continue
       if div.a12:
           if bigger(lo, i, hi, nums, div) < float(div.a12):continue
       maxv = e
       cut = i   
   return cut 

def errDiff(mu, n0, mu0, n1, mu1):
    return n0*(mu - mu0)**2.0 + n1*(mu - mu1)**2.0
    
def bigger(lo, mid, hi, nums, div):
    below = values(lo, mid-1, nums, div)
    above = values(mid, hi, nums, div)
    return a12statistic(below, above)
    
def values(i, j, nums, div):
    out = []
    for k in range(i, j+1):
        b = div.order[k]['=']
        out += nums.x[b]
    return out

def a12statistic(below, above):
    comparisons = more = same = 0  
    for j in range(len(above)):
        for i in range(len(below)):
            comparisons = comparisons + 1
            more = more + 1 if above[j] > below[i] else more
            same = same + 1 if above[j] == below[i] else more
    return (more + 0.5*same)/comparisons


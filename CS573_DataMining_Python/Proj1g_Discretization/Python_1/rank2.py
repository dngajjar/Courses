import lib
class Num:
    def __init__(i):
        i.mu = []
        i.sum = []
        i.m2 = []
        i.var = []
        i.n = []
        i.x = {}
        i.label = []
        i.name = []
    
class Div:
    def __init__(i):
        i.total = []
        i.cohen = []
        i.mittas = []
        i.a12 = []
        i.order = {}
        i.level = []
        
def ranks(filename, a):
    print "\n----|", filename,"|---------------------"
    f = open(filename)
    _Nums = Num()
    _Div = Div()
    obs(f,0,_Nums,_Div)
 #   rank(0,_Nums,_Div,a)

def obs(f, all, _Nums, _Div):
    now = all
    line = f.readline()
    while line:
        line = line.split()
        for i in line:
            if ~i[0].isdigit(): now = i
            else:
                v = float(i)
                inc(v, now, _Nums)
                inc(v, all, _Nums)
        line = f.readline()
    f.close()
    for i in _Nums.name:
        if i != all:
            temp={}
            temp['='] = i
            temp['x'] = _Nums.mu[i]
            _Div.order[i] = temp
    
def inc(v, k, nums):
    if k not in nums.name: nums.name += [k] 
    nums.label[k] = 0
    nums.n[k] = 0 if k not in nums.n.keys() else int(nums.n[k]) + 1
    nums.x[k] += [v]
    nums.sum[k] = v if k not in nums.sum.keys() else float(nums.sum[k]) + v
    delta = v if k not in nums.mu.keys() else v - float(nums.mu[k])
    nums.mu[k] = float(delta/all) if k not in nums.mu.keys() else float(nums.mu[k]) + float(delta/all)
    nums.m2[k] = float(delta*(v-nums.mu[k])) if k not in nums.m2.keys() else float(nums.m2[k]) + float(delta*(v-nums.mu[k]))
    nums.var[k] = float(nums.m2[k]/(all - 1 + lib.PINCH))    
   


    
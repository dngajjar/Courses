def ptile(lst, chops, width, form, lo, hi):
    lo = 0 if lo == '' else lo
    hi = 100 if hi == '' else hi
    form = '%3.0f' if form == '' else form
    width = 50 if width == '' else width
    bar = '|'
    out = []
    for i in range(width):
        out += [' ']
    nlst = sorted(lst) if type(lst) == list else sorted(lst.values())
    n = len(lst)
    who = {}
    where0 = {}
    for p in chops.keys():
        who[p] = float(nlst[int(float(p)*n)])
        where = int(width*(float(who[p]) - lo)/(hi - lo))
        tmp = {}
        tmp['x'] = where
        tmp['*'] = chops[p]
        where0[p] = tmp
    w = len(where0.keys())
    wheres = {}
    for i in range(w): wheres[i] = where0[sorted(where0.keys())[i]]
    for i in range(w):
        start = wheres[i]['x']
        stop = width if i == w-1 else wheres[i+1]['x']
        for j in range(start, stop):out[j] = wheres[i]['*']
    out[int(width/2)] = bar
    median = float(nlst[int(0.5*n)])
    spread = float(nlst[int(0.75*n)]) - float(nlst[int(0.25*n)])
    maxv = float(nlst[n-1])
    where = int(width*(median - lo)/(hi - lo))
    out[where] = '*'
    out = ' >,'+''.join(out)[:]+',< ,'+' ,'.join([form%who[s] for s in sorted(who.keys())])\
    +', |, '+form%(float(median)) +', '+form%(spread)+' ,'+ form%(maxv)
    return out
        
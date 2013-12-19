import math
import lib
import tablestr
import reader
def attrselect(table, num):
    label = table.data[table.klass[0]]  # assume only one class col
    types = {}
    for i in label:
        types[i] = types[i]+ 1 if i in types.keys() else 1
    entropy = 0.0
    for keys in types.keys():
        entropy += -types[keys]/float(sum(types.values()))*math.log(types[keys]/float(sum(types.values())), 2) 
    lst = []
    for ind in range(len(table.term)):
        data = table.data[ind]
        lst += [inforgain(data, label)]
    enlst, indlst = lib.sort(lst)
    namelst = []
    namelst += [table.name[i] for i in indlst];
    #print namelst, enlst
    attrlst = []
    inforlst = []
    for i in range(int(num*len(table.data))): 
        attrlst += [table.name[indlst[i]]]
        inforlst += [entropy - enlst[i]]
    #print attrlst, inforlst
    return attrlst, inforlst
    
def inforgain(data, label):
    types = {}
    num = len(data) # number of instances
    for i in range(len(data)):
        key = data[i]
        value = label[i]
        if key in types.keys():           
            types[key][value] = types[key][value] + 1 if value in types[key].keys() else 1
        else:
            types[key] = {}
            types[key][value] = 1
    sumval = 0.0
    for keys, values in types.items():
        l = []
        l += [invalues for inkeys, invalues in values.items()]
        total = float(sum(l))
        tmp = 0.0
        for i in l: tmp += -i/total*math.log(i/total, 2)
        sumval += total/num*tmp
    return sumval
                
def attrtable(table, attrlst):
    lst, name, row = [], [], []
    for s in range(len(table.name)):
        if table.name[s][1:] in attrlst or table.name[s] in attrlst:
            lst += [s]
    lst += [table.klass[0]]
    name = [table.name[i] for i in lst]
    ntable = tablestr.Table()
    reader.makeTable(name, ntable)
    for s in range(len(table.data[0])):
        row = [table.data[k][s] for k in lst]
        reader.addRow(row, ntable)
    return ntable

import lib
import reader
import dist
import tablestr

def project(table):
    d = lib.anyi(len(table.data[0]))
    east, eid = dist.furthest(d, table)
    west, wid = dist.furthest(eid, table)
    x = []
    y = []
    x,y = project0(east, west, table, x, y)
    return widen(table, x, y)

    
def project0(east, west, table, x, y):
    some = 0.000001 # handles a tedious div/zero error
    # compute the dist between the independent variables
    c = dist.dist(east, west, table.indep, table, False) 
    for s in range(len(table.data[0])):
        row = [table.data[k][s] for k in range(len(table.data))]
        a = dist.dist(east, row, table.indep, table, False)
        b = dist.dist(west, row, table.indep, table, False)
        if a > c: x = []; y = []; return project0(east, row, table, x, y)
        if b > c: x = []; y = []; return project0(row, west, table, x, y)
        else:
            temp = (a**2 + c**2 - b**2) / (2*c + some)
            x += [str('%.3f'%temp)]
            y += [str('%.3f'%((a**2 -temp**2)**0.5))]
    return x, y
                
def widen(table, x, y):
    adds = table.name[:]
    adds += ['$_XX']
    adds += ['$_YY']
    adds += ['$_Hell']
    adds += ['_ZZ']
    ntable = tablestr.Table()
    reader.makeTable(adds, ntable)
    for s in range(len(table.data[0])):
        row = [table.data[k][s] for k in range(len(table.data))]
        tmp = row[:]
        row += [x[s]]
        row += [y[s]]
        row += [str('%.3f'%tablestr.fromHell(tmp, table))]
        row += [str(0)]
        reader.addRow(row, ntable)
    return ntable
    
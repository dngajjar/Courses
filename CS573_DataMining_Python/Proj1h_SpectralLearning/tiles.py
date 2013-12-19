import project
import math
import tablestr
import reader
import copy
import lib
class Tile:
    def __init__(i):
        i.tiny = 4
        i.big = 0
        i.pre = ''
        i.xs = []
        i.ys = []
        i.header = []
        i.watch = 1
        i.centers = ''
        
def tiles(table):
    ntable = project.project(table)
    tile = Tile()
    tile.tiny = 4 # the minimum instance num to assign a leaf
    tile.pre = ''
    tile.m = len(table.data[0])  # num of instances have
    tile.big = 2 * math.sqrt(tile.m)
    c1 = 1
    tile.watch = 1
    tile.centers = 'centroids'
    centable = {}  # dictinary to store all the splitted tables including the center table
    centable0 = tablestr.Table()
    reader.makeTable(ntable.name, centable0)
    centable[0] = centable0
    tiles0(ntable, tile)
    pre = tile.pre
    tiles4(1, tile.m, 1, tile.m, ntable, tile, centable, c1, pre)
    centable['project'] = ntable
    return centable
    
def tiles0(ntable, tile):
    x = ntable.name.index('$_XX')
    y = ntable.name.index('$_YY')
    #z = ntable.name.index('_ZZ')
    at = []
    for d in range(len(ntable.data[0])):
        tmp = {}
        tmp['d'] = d
        tmp['x'] = float(ntable.data[x][d])
        tmp['y'] = float(ntable.data[y][d])
        at += [tmp]
    asort(at, 'x', tile)
    asort(at, 'y', tile)
    
def asort(at, label, tile):
    # func to sort the list based on the label
    att = copy.copy(at)
    while len(att):
        minv = lib.inf; ind = 0 
        tmp = {}
        for i in range(len(att)):
            if att[i][label] < minv: 
                minv = att[i][label]; ind = i
        tmp = att[ind]
        if label == 'x': tile.xs += [tmp]
        else: tile.ys += [tmp]
        att.pop(ind)
    
def tiles4(x0, x2, y0, y2, ntable, tile, centable, c1, pre):
    x = x0 + int((x2 - x0)/2)
    y = y0 + int((y2 - y0)/2)
    c1 = tile1(x0, x, y0, y, ntable, tile, centable, c1, pre)
    c1 = tile1(x0, x, y+1, y2, ntable, tile, centable, c1, pre)
    c1 = tile1(x+1, x2, y0, y, ntable, tile, centable, c1, pre)
    c1 = tile1(x+1, x2, y+1, y2, ntable, tile, centable, c1, pre)
    return c1

def tile1(x0, x2, y0, y2, table, tile, centable, c1, pre):
    has = []
    for x in range(x0, x2+1):
        for y in range(y0, y2+1):
            if tile.xs[x-1]['d'] == tile.ys[y-1]['d']:
                has += [tile.xs[x-1]['d']]
    # debug info 
    if tile.watch: print '%3s:  '%c1, pre, x0, x2, y0, y2, '#', len(has)
    # recurse: when there is enough data
    if len(has) >= tile.big:
        pre = pre + '|..'
        return tiles4(x0, x2, y0, y2, table, tile, centable,c1, pre)
    # otherwise, new cluster: make a new leaf, only when there is enough data
    if len(has) > tile.tiny:
        # make a new cluster
        makeNewTable(has, c1, table, tile, centable)
        c1 += 1
    #keep track of the num of leaf clusters 
    return c1
    
def makeNewTable(has, c1, table, tile, centable):
    c1 = c1 * 100
    z = table.name.index('_ZZ')
    newtable = tablestr.Table()
    reader.makeTable(table.name, newtable)
    for one in range(len(has)):
        d = has[one]
        row1 = [table.data[s][d] for s in range(len(table.data))]
        row1[z] = str(c1)
        reader.addRow(row1, newtable)
    centers = tablestr.centroid(newtable) #centers[0] is mu or mode
    centers[0][z] = str(c1)
    reader.addRow(centers[0], centable[0])
    centable[c1/100] = newtable
            
    
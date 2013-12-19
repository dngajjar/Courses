import lib
import reader
import dist

def project(table):
    d = lib.anyi(len(table.data[0]))
    east = dist.furthest(d, table)
    west = dist.furthest(east, table)
    x,y = project0(east, west, table)
    #return widen(table, x, y)
    print d
    print east
    print west
    
def project0(east, west, table):
    print '+'
    some = 0.000001 # handles a tedious div/zero error
    c = dist.dist(east, west)

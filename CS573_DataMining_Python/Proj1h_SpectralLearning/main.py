import reader
import tablestr
import tiles
import math
if __name__ == "__main__":      
    filename = 'data/nasa93dem.csv'   
    table = tablestr.Table()
    reader.readcsv(filename, table) 
    tables = tiles.tiles(table)
    ntable = tables['project']
    print '# $_XX'.ljust(8), '$_YY'.ljust(8), 'log(-effort)'.ljust(8)
    for i in range(len(ntable.data[0])):
       print ntable.data[27][i].ljust(8), ntable.data[28][i].ljust(8), str(math.log(float(ntable.data[24][i]))).ljust(8)        
    print '# $_XX'.ljust(8), '$_YY'.ljust(8), 'log($_ZZ)'.ljust(8)
    for i in range(len(tables[0].data[0])):
        print tables[0].data[27][i].ljust(8), tables[0].data[28][i].ljust(8), str(math.log(float(tables[0].data[30][i]))).ljust(8)
    for k, v in tables.items():
        print '*'*20
        print 'CLASS LABEL: ', k
        tablestr.tableprint(v)
        

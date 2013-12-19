import pca
#import lda
import numpy
import tablestr
import reader
def projections(table, numdim):
    matrix = []
    for i in range(len(table.data[0])):
        tmp = []
        for j in range(len(table.name)-1):
            #print tables[ite][1][0].data[j][i]
            tmp += [float(table.data[j][i])]
        matrix += [tmp] 
    M = numpy.matrix(matrix)
    #C = table.data[table.klass[0]]
    px, py = pca.pca(M, numdim) # generated projected numdim of dimensionality from PCA
    #LDAM = lda.lda(M, C, numdim)
    return widen(table, px, py)  
  
    
def widen(table, x, y):
    adds = table.name[:]
    adds += ['$_XX']
    adds += ['$_YY']
    adds += ['$_Hell']
    adds += ['$_ZZ']
    ntable = tablestr.Table()
    reader.makeTable(adds, ntable)
    for s in range(len(table.data[0])):
        row = [table.data[k][s] for k in range(len(table.data))]
        #tmp = row[:]
        row += [x[s]]
        row += [y[s]]
        row += [table.data[table.klass[0]][s]]
        row += [str(0)]
        reader.addRow(row, ntable)
    return ntable

import math
import tablestr
def projectwrite(outfile1, ntable, tables):
    ind_xx = ntable.name.index('$_XX')
    ind_yy = ntable.name.index('$_YY')
    ind_hell = ntable.name.index('$_Hell')
    ind_zz = ntable.name.index('$_ZZ')
    #outfile1.write('# $_XX'.ljust(8)+'$_YY'.ljust(8)+'log(-effort)'.ljust(8))
    #for i in range(len(ntable.data[0])):
    #    outfile1.write(ntable.data[ind_xx][i].ljust(8)+ntable.data[ind_yy][i].ljust(8)+str(math.log(float(ntable.data[24][i]))).ljust(8))       
    outfile1.write('# $_XX'.ljust(15)+ '$_YY'.ljust(15)+ 'Class Label'.ljust(15)+'\n')
    for i in range(len(tables[0].data[0])):
        outfile1.write(tables[0].data[ind_xx][i].ljust(15)+tables[0].data[ind_yy][i].ljust(15)+ tables[0].data[ind_hell][i].ljust(15)+'\n')

def tablewrite(outfile0, tables, table, ntable):
     ## print the tables on the txt file
    outfile0.write('\nDiscretization Table\n')
    tablestr.tableprint_txt(table, outfile0)
    outfile0.write('\nProjected Table\n')
    tablestr.tableprint_txt(ntable, outfile0)
    outfile0.write('\nTiles Tables\n')     
    for k, v in tables.items():
        outfile0.write('\n'+'*'*30+'\n')
        outfile0.write('CLASS LABEL: '+str(k)+'\n') if k!= 0 else outfile0.write('CLASS LABEL: Centroids Table'+'\n') 
        tablestr.tableprint_txt(v, outfile0)

def projectwrite2(outfile1, ntable):
    ind_xx = ntable.name.index('$_XX')
    ind_yy = ntable.name.index('$_YY')
    ind_hell = ntable.name.index('$_Hell')
    ind_zz = ntable.name.index('$_ZZ')
    #outfile1.write('# $_XX'.ljust(8)+'$_YY'.ljust(8)+'log(-effort)'.ljust(8))
    #for i in range(len(ntable.data[0])):
    #    outfile1.write(ntable.data[ind_xx][i].ljust(8)+ntable.data[ind_yy][i].ljust(8)+str(math.log(float(ntable.data[24][i]))).ljust(8))       
    outfile1.write('# $_XX'.ljust(15)+ '$_YY'.ljust(15)+ 'Class Label'.ljust(15)+'\n')
    for i in range(len(ntable.data[0])):
        outfile1.write(ntable.data[ind_xx][i].ljust(15)+ntable.data[ind_yy][i].ljust(15)+ ntable.data[ind_hell][i].ljust(15)+'\n')

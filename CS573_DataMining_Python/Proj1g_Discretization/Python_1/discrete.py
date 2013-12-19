import labels
import reader
import tablestr

def discrete(table, t, bins):
    tables = {}
    #breaks = labels.ewdbreaks; label = labels.ewdlablef
    breaks = labels.gbreaks; label = labels.globalf 
    b = {}  
    breaks(b)
    newNames = labels.discreteNames(table.name, table.num)
    ntable = tablestr.Table()
    reader.makeTable(newNames, ntable)
    discrete1(table, ntable, bins, b[bins], label)
    print 'b[1]=', b[3][0]
    print 'b[2]=', b[3][1]
    tables[0] = table
    t1 = 'D_'+ str(t)
    tables[t1] = ntable    
    return tables
    
def discrete1(table, ntable, bins, b, label):
    for d in range(len(table.data[0])):
        a = []
        for k in range(len(table.data)):          
            val = table.data[k][d]
            if val != '?':
                if k in table.num: 
                    k = table.num.index(k)
                    val = label(k, float(val), bins, b, table)
            a += [str(val)]
        reader.addRow(a, ntable)
            
    

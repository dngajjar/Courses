import re
import tablestr
def readcsv(filename, table):
    "read in data from csv and create a table"
    FS = ','                     #define field separator
    f = open(filename)
    seen  = 0
    while True:
        str = line(f)
        if str == -1:
            if seen == 0: print("WARNING: empty or missing file")
            return -1
        a = str.split(FS)        #compute the number of attributes in table
        if len(a) > 1:
            if seen: addRow(a, table)
            else: makeTable(a, table)
            seen += 1
    
def line(f):
    "get one line data (without comments and whitespace)"
    str = f.readline()
    if not str: return -1             #readline finds nothing, output error
    else:
        str = "".join(str.split())    #kill whitespace
        str = re.sub(r'#.*','',str)   #kill comments    
        if len(str) >= 1 and str[-1] == ',': return str + line(f)
        else: return str
            
def makeTable(a, table):
    "read table titles and set all corresponding parameters"
    c = 0
    for ite in range(len(a)):
        if a[ite][0] == '?': continue  #the col with '?' is ignored    
        table.order.append(ite)
        x = a[ite]
        table.name.append(x)
        isNum = 1
        if x.find('=') != -1:
            table.dep.append(c)
            table.klass.append(c)
            isNum = 0
        elif x.find('+') != -1:           
            table.dep.append(c)
            table.more.append(c)
        elif x.find('-') != -1:           
            table.dep.append(c)
            table.less.append(c)
        elif x.find('$') != -1:           
            table.indep.append(c)
            table.num.append(c)
        else:
            table.indep.append(c)
            table.term.append(c)
            isNum = 0
        table.n.append('0')
        if isNum:
            table.nump.append(c)
            table.hi.append(-1*10**32)
            table.lo.append(10**32)
            table.mu.append(0)
            table.m2.append(0)
            table.sd.append(0)
        else:
            table.wordp.append(c)
            table.most.append(0)
            table.count.append({})
            table.mode.append('')   
        c += 1 
    for i in range(c): table.data.append([])     
    
def addRow(a, table):
    "add a row of data to the table"
    for c in range(len(table.name)):
        f = table.order[c]
        x = a[f]
        table.data[c].append(x)
        if x.find('?') == -1:
            table.n[c] = int(table.n[c]) + 1
            if c in table.wordp:
                k = table.wordp.index(c)
                if table.count[k].has_key(x): table.count[k][x] += 1
                else: table.count[k][x] = 1
                new = table.count[k][x] 
                if new > table.most[k]:
                    table.mode[k] = x
                    table.most[k] = new
            else:
                k = table.nump.index(c)
                if float(x) > float(table.hi[k]): table.hi[k] = x
                if float(x) < float(table.lo[k]): table.lo[k] = x
                delta = float(x) - table.mu[k]
                table.mu[k] += delta/table.n[c]
                table.m2[k] += delta*(float(x) - table.mu[k])
                if table.n[c] > 1:
                    table.sd[k] = (table.m2[k]/(table.n[c] - 1))**0.5
            c += 1 
            
def klasses(table):
    "generate a set of tables based on different classes"
    if len(table.klass) == 0:
        print "No labeled classes in the given data set"
        return -1
    # assume there is only one class feature in the data set
    data = table.data[table.klass[0]]
    classnames = []
    for s in data:
        if s not in classnames:
            classnames.append(s)
    tables = klass1(table, classnames, data)
    tables['0'] = table
    tables['names'] = classnames
    return tables
    
def klass1(table, classnames, data):
    tables = {}
    for s in classnames:
        tables[s] = tablestr.Table()
        makeTable(table.name, tables[s])
        for i in range(len(data)):
            if s == data[i]:
                a = []
                for j in range(len(table.order)):
                    a.append(table.data[j][i])
                addRow(a, tables[s])
    return tables
                
    

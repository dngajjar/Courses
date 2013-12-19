import lib 
class Table:
    def __init__(self):
        self.data = []     #data[[col1,...],[col2,...]]
        self.name = []     #name of i-th column
        self.order = []    #order of the col
        self.nump = []     #is i-th column numeric?
        self.wordp = []    #is i-th column non-numeric?
        self.indep = []    #list of indep columns
        self.dep = []      #list of dep columns
        self.less = []     #numeric goal to be minimized
        self.more = []     #numeric goal to be maximized
        self.klass = []    #non-numeric goal
        self.term = []     #non-numeric non-goal
        self.num = []      #numeric non-goal
        # for all cols
        self.n = []        #count of things in this col
        # for wordp columns:
        self.count = []    #count of each word
        self.mode = []     #most common word
        self.most = []     #count of most common word
        # for nump columns:
        self.hi = []       #upper bound
        self.lo = []       #lower bound
        self.mu = []       #mean
        self.m2 = []       #sum of all nums
        self.sd = []       #standard deviation# -*- coding: utf-8 -*-
        # table printing format
        self.CONVFMT = '%4.2f'  
     
def centroid(table):
    "update the mode and most values for wordp type cols or update the mean and sd values for nump cols"
    rows = [[],[]]
    for c in range(len(table.name)):
        s = table.mode[table.wordp.index(c)] if c in table.wordp else table.CONVFMT%table.mu[table.nump.index(c)]
        rows[0].append(str(s))
        if table.n[c] == '0':
            s = 0.0
        else:
            s = float(table.most[table.wordp.index(c)])/table.n[c] if c in table.wordp else table.sd[table.nump.index(c)]
        rows[1].append(str(table.CONVFMT%s))
    return rows
        
def tableprint(table, stats=''):
    "print table on the console"
    print ' '
    if stats != '': table.CONVFMT = stats 
    print(' ' + lib.rowprint(table.name)+ '  # notes'.ljust(10))
    print('#' + lib.rowprint(centroid(table)[0]) + '  # expected'.ljust(10))
    print('#' + lib.rowprint(centroid(table)[1]) + '  # certainty'.ljust(10))    
    for j in range(len(table.data[0])):
        line = []
        for i in range(len(table.data)):
            line.append(table.data[i][j])
        print(' ' + lib.rowprint(line)+ '  #'.ljust(10))

def tableprint_txt(table, f, stats=''):
    "print table on the indicated txt file with table name"
    f.write('\n')
    #f.write('\n' +tablename + '\n'*2)
    if stats != '': table.CONVFMT = stats 
    f.write(' ' + lib.rowprint(table.name)+ '  # notes'.ljust(10) + '\n')
    f.write('#' + lib.rowprint(centroid(table)[0]) + '  # expected'.ljust(10) + '\n')
    f.write('#' + lib.rowprint(centroid(table)[1]) + '  # certainty'.ljust(10) + '\n')    
    for j in range(len(table.data[0])):
        line = []
        for i in range(len(table.data)):
            line.append(table.data[i][j])
        f.write(' ' + lib.rowprint(line)+ '  #'.ljust(10) + '\n')
    

    
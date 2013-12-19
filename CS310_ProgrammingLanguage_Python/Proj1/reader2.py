from structure import *
import re
mySyms=list("0123456789abcdefghojklmnopqrstuvwzyz=?+*-@$:;ABCDEFGHIJKLMNOPQRSTUVWYZ")

def graph(f, o):
    graph = Graph()
    "read in data from csv and create a table"  # define field separator
    seen  = 0            # count the number of nodes
    p = False        # label whether it is the starting for the paragraph
    while True:
        line = f.readline()
        if line == -1 and seen == 0: print("WARNING: empty or missing file"); return -1
        if line == '\n' or line.find('#') != -1 or line.find('>') != -1: p = True; continue
        if len(line) == 0: break                # the end of the file       
        if p:                               # starting line for a paragraph
            seen += 1
            node = graph.node(line[:-1])
            if len(graph.nodes) == 1: node.start = True; start = node.name
            line = f.readline()
            s = f.readline()
            if len(line) != 0 and len(s) != 0:
                while s.find('>') == -1 and s != -1: line += s; s = f.readline()
                node.also(line[:-1] + '\nWhat to do next?')                     # get the discription for the
                p = False     
            elif len(line) != 0 and len(s) == 0:
                node.also(line[:-1])
                break
            else: break
    node.end = True                             # label the end node   
    stop = node.name   
    f.seek(0)         
    max = len(graph.nodes)    
    edges = {}
    s = f.readline()
    while max > 0:
        n = s
        while n[:-1] not in graph.keys.keys(): 
            if len(n) != 0: n = f.readline()
            elif n == '\n' or line.find('#') != -1: n = f.readline()
            else: break      
        here = graph.keys[n[:-1]]
        max -= 1        
        s = f.readline()
        while s.find('>') == -1: 
            if len(s) == 0: break
            s = f.readline()
        while s.find('>') != -1 :
            lst = s.split()
            sub = lst[1]
            txt = s[s.find(lst[2]):-1]
            name = partialmatch2(graph.keys.keys(), sub, s)
            if name == -1: 
                node = graph.node(sub)
                name = sub
            there = graph.keys[name]
            if here != there:
                edge = Edge(here, there, txt)
                if here.name not in edges.keys(): edges[here.name] = []                
                edges[here.name] += [edge]
            s = f.readline()    
    graph.m = adjacencymatrix(graph, edges, start, stop)     # generate adjacency matrix
    graph.mPrime = transitiveclosure(graph.m, graph, start, stop) # generate transitive closure matrix
    Flag, mIsland = checkmatrix(graph.m, graph.mPrime)    
    o.write("Adjacency Matrix\n")    
    printmatrix_txt(graph.m, o)
    o.write("Transitive Closure\n")
    printmatrix_txt(graph.mPrime, o)    
    o.write("Island Matrix\n")
    printmatrix_txt(mIsland, o)   
    o.close()
    f.close()
    return graph, edges, Flag   
      
def partialmatch(lst, name):
    while True:    
        pattern = name[:] + '.*'   # define the regular expression maching rule
        k = [re.match(pattern, s).group(0) for s in lst if re.match(pattern, s)]
        if len(k) == 1: break
        elif len(k) > 1: 
            print 'WARNING: Find multiple partial matching node name', k
            name = raw_input('Please enter the node name again > ')
            continue
        else: 
            print "WARNING: Find none partial matching node name"
            name = raw_input('Please enter the node name again > ')
            continue
    return k[0]              

    
def partialmatch2(lst, name, line):
    while True:
        pattern = name[:] + '.*'   # define the regular expression maching rule
        k = [re.match(pattern, s).group(0) for s in lst if re.match(pattern, s)]
        if len(k) == 1: break
        elif len(k) > 1: 
            print 'WARNING: Find multiple partial matching node name\n'
            print 'Edge Dsecription:  "'+line[:-1] + '"  cannot decide which node '+'"'+name+'"' +' represents.'
            print "Please enter the more specific node name", k
            name = raw_input()
            print "Your input is:" + name +'\n'
            continue
        else: return -1
    return k[0]              

def adjacencymatrix(graph, edges, start, stop):
    max = len(graph.nodes)     # the number of nodes in the graph
    m = {}
    for i in range(max):
        if i == graph.keys[start].id: ind = '!'+mySym(i)
        elif i == graph.keys[stop].id: ind = '.'+mySym(i)
        else: ind = mySym(i)
        m[ind] = []
        for j in range(max):
            m[ind] += ['']     
    for num in range(max):         # iterate through all nodes
        node1 = graph.nodes[num]   # graph.nodes are stored in creation order      
        p1 = mySym(node1.id)       
        if node1.name == start: p1 = '!'+ p1
        if node1.name == stop: p1 = '.' + p1
        if len(node1.out) != 0:
            for s in range(len(node1.out)):
                node2 = node1.out[s].there
                m[p1][node2.id] = 1
    return m
    
def transitiveclosure(M, graph, start, stop):
    n = len(M)
    for k in range(n):
        node1 = graph.nodes[k]
        pk = mySym(node1.id)
        if node1.name == start: pk = '!'+ pk
        if node1.name == stop: pk = '.' + pk
        for i in M.keys():
            for j in range(n):
                M[i][j] = M[i][j] or (M[i][k] and M[pk][j])                
    return M
    
def mySym(n) :
    return mySyms[n% len(mySyms)]
    
def checkmatrix(m, M):
    label = True
    n = len(m)
    #printmatrix(m)
    # checking the number of start nodes and end nodes
    stop = start = 0
    stoplst = []
    startlst = []
    for i in m.keys():
        if 1 not in m[i]: stop += 1; stoplst += [i]  
    for j in range(n):
        flag = True
        for i in m.keys():
            if m[i][j] == 1: flag = False; break  
        if flag:   
            for s in m.keys():
                if s[-1] == mySym(j): k = s
            start += 1; startlst += [k]
    if stop == 0: print 'WARNING: There is no stop node\n'; label = False
    elif stop > 1: print 'WARNING: There is more than one stop node\n'; label = False
    if start == 0: print 'WARNING: There is no start node\n'; label = False
    elif start > 1: print 'WARNING:There is more than one start node\n'; label = False
    
    # checking whether all nodes connect downstream to the stop node
    for i in M.keys():
        num = 0
        for s in stoplst:
            k = mySyms.index(s[-1])
            if M[i][k] == 1: continue
            elif M[i][k] == '' and s !=  i: num += 1
        if num == len(stoplst): 
            print 'WARNING: Not all nodes connecte downstream to the stop node\n'; label = False
            k =  mySyms.index(s[-1])          
            print 'The node id is: ', k
            
    # checking whether the start node connect to all other nodes        
    for s in startlst:
        k = mySyms.index(s[-1])
        zeron = 0
        for i in range(n):
            if M[s][i] == '': zeron += 1
        if zeron > 1 and M[s][k] == '': 
            print 'WARNING: The start node "'+ s+ "\" dosen't connect to all other nodes\n"
            label = False
    
    # checking the number of islands exists in the graph
    mIsland = m    
    if start > 1 and stop > 1:
        for s in stoplst:
            island = True
            k = mySyms.index(s[-1])
            for i in M.keys():
                if m[i][k] == 1:
                    for s2 in stoplst:
                        if s == s2: continue
                        k2 = mySyms.index(s2[-1])
                        if M[i][k2] == 1: island = False; break
                if ~island: break
        if island: 
            print 'WARNING: There exits more than one island\n'
            label = False
            mIsland = islandmatrix(m, M, stoplst)
    return label, mIsland

def islandmatrix(m, M, stoplst):
    label = 2
    for s in stoplst:
        island = True
        if s[0] == '.': continue
        k = mySyms.index(s[-1])
        for i in M.keys():
            if m[i][k] == 1:
                for s2 in stoplst:
                    if s == s2: continue
                    k2 = mySyms.index(s2[-1])
                    if M[i][k2] == 1: island = False; break
                if island == False: break
                for l in range(len(m)):
                    if m[i][l] == 1: m[i][l] = label
        if island: label += 1
    printmatrix(m)
    return m
        
def printmatrix_txt(m, out):
    for s in m.keys():
        row = []
        for k in m[s]:
            if k == '': row +=[ 0]
            else: row += [ k]
        if len(s) == 1: out.write('('+s+' ) '+ str(row)+'\n')  
        else: out.write('('+s+') '+ str(row)+'\n')  

def printmatrix(m):
    for s in m.keys():
        row = []
        for k in m[s]:
            if k == '': row +=[ 0]
            else: row += [ k]
        if len(s) == 1: print '('+s+' ) ',row
        else: print '('+s+') ',row 
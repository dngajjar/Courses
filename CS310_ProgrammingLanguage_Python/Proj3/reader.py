from structure import *
import re
import copy
mySyms=list("0123456789abcdefghijklmnopqrstuvwxyz=?+*-@$:;ABCDEFGHIJKLMNOPQRSTUVWYZ")

def graph(f, o, env):
    g,e = Graph(),{}
    # first read-in all the paragraphs and create all the listed nodes
    for para in paras(f):        
        lines = para.split('\n')

        here = g.node(lines[0])
        if len(g.nodes) == 1: here.start = True; start = here.name       
        for s in lines[1:]:
            if re.search('^[ \t]*:', s) != None:
                if s.find('OnEntry'):  here.onEntry = Code(s[s.find('OnEntry')+7:], env)
                elif s.find('OnExit'): here.onExit = Code(s[s.find('OnExit')+6:], env)
                elif s.find('When'):   here.when = Code(ls[s.find('When')+4:], env)
            elif s.find('>') == -1:    here.also(s+'\nWhat will you do next?')
                    
    here.stop = True; stop = here.name
    i = here.description.find('\nWhat will you do next?')
    here.description = here.description[:i]
    # relocate to the start of the file and build all the edges
    f.seek(0) 
    for para in paras(f): 
        lines = para.split('\n')
        for s in lines[1:]:
            if s.find('>') != -1:
                words = s.split()
                des = words[1]
                #print words
                txt = s[s.find(words[2]):]        
                #print g.keys.keys()
                name = partialmatch2(g.keys.keys(), des, s)
                #print 'des:', des, ' name:', name
                if name == -1: name = des
                there = g.node(name) 
                ind = txt.find(':'); 
                newtxt = txt[:] if ind == -1 else txt[:ind]
                edge = Edge(g.keys[lines[0]], there, newtxt)   
                if ind != -1:
                    tmp = txt[txt.find('('):txt.rfind(')')+1]
                    if txt.find('if', ind, ind +10) != -1:
                        edge.ifval = Code(tmp, env)
                    elif txt.find('OnExit', ind, ind+10) != -1:
                        edge.onExit = Code(tmp, env)
                if lines[0] not in e.keys(): e[lines[0]] = []  
                e[lines[0]] += [edge]
    g.m = adjacencymatrix(g, e, start, stop)     # generate adjacency matrix    
    tmpm = copy.deepcopy(g.m)
    g.mPrime = transitiveclosure(tmpm, g, start, stop) # generate transitive closure matrix
    tmpM = copy.deepcopy(g.mPrime)  
    Flag, mIsland = checkmatrix(tmpm, tmpM,g)   
    
    o.write("Adjacency Matrix\n")    
    printmatrix_txt(g.m, o)
    o.write("Transitive Closure\n")
    printmatrix_txt(g.mPrime, o)    
    o.write("Island Matrix\n")
    printmatrix_txt(mIsland, o)   

    o.close()
    f.close()
    return g, e, Flag

    

def paras(f):
    para = "";
    for line in f: #loop through file
        #print len(line), "=>", line
        curLine = re.sub('#+.*', "", line); #replaces # and anything past it with nothing      
        #print curLine        
        if para != '' and (line == '\n' or line == '\n\n'):     
            #print para.strip()
            yield para.strip()
            para = "";   #reset para
        if curLine.strip() != '':
            para += curLine.strip() +"\n"   # add line to para      

            
     
def partialmatch(lst, name):
    while True:    
        pattern = name[:] + '[a-z]*'   # define the regular expression maching rule
        #k = [re.match(pattern, s, re.IGNORECASE).group(0) for s in lst if re.match(pattern, s, re.IGNORECASE)]
        k = [s for s in lst if re.match(pattern, s, re.IGNORECASE)]      
        if len(k) == 1: break
        elif len(k) > 1: 
            print 'WARNING: Found multiple matches', k
            name = raw_input('Please enter your selection again with more letters > ')
            continue
        else: 
            print "WARNING: There are no matches to your selection"
            name = raw_input('Please enter your selection again > ')
            continue
    return k[0]              

    
def partialmatch2(lst, name, line):
    while True:
        pattern = name[:] + '[a-z]*'   # define the regular expression maching rule
        #k = [re.match(pattern, s).group(0) for s in lst if re.match(pattern, s)]
        k = [s for s in lst if re.match(pattern, s, re.IGNORECASE)]
        if len(k) == 1: break
        elif len(k) > 1: 
            print 'WARNING: Found multiple matches\n'
            print 'Edge Dsecription:  "'+line + '"  cannot decide which node '+'"'+name+'"' +' represents.'
            print "Please enter the more specific selection", k
            name = raw_input()
            print "Your input is:" + name +'\n'
            continue
        else: return -1
    return k[0]              

def adjacencymatrix(graph, edges, start, stop):
    maxv = len(graph.nodes)     # the number of nodes in the graph  
    m = {}
    for i in range(maxv):
        #print 'i:', i
        if i == graph.keys[start].id: ind = '!'+mySym(i)#; print 'start:', mySym(i)
        elif i == graph.keys[stop].id: ind = '.'+mySym(i)#; print 'stop:', mySym(i)
        else: ind = mySym(i)
        m[ind] = []
        for j in range(maxv): m[ind] += ['']     
    for num in range(maxv):         # iterate through all nodes
        node1 = graph.nodes[num]   # graph.nodes are stored in creation order      
        p1 = mySym(node1.id)       
        if node1.name == start: p1 = '!'+ p1
        if node1.name == stop: p1 = '.' + p1
        if len(node1.out) != 0:
            for s in range(len(node1.out)):
                node2 = node1.out[s].there
                if node2 == node1 and node2.name == stop: continue
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

def idtoname(i, graph):
    for s in graph.keys.keys():
        node = graph.keys[s]
        if i == node.id: return node.name
    
def checkmatrix(m, M,g):
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
    elif start > 1: print 'WARNING: There is more than one start node\n'; label = False
    
    # checking whether all nodes connect downstream to the stop node
    for i in M.keys():
        num = 0
        for s in stoplst:
            k = mySyms.index(s[-1])
            if M[i][k] == 1: continue
            elif M[i][k] == '' and s !=  i: num += 1
        if num == len(stoplst): 
            print 'WARNING: Not all nodes connect downstream to the stop node\n'; label = False
            k =  mySyms.index(s[-1])          
            print 'The node id is: ', idtoname(k, g)
            
    # checking whether the start node connect to all other nodes        
    for s in startlst:
        k = mySyms.index(s[-1])
        zeron = 0
        for i in range(n):
            if M[s][i] == '': zeron += 1
        if zeron > 1 and M[s][k] == '': 
            print 'WARNING: The start node "'+ idtoname(k,g)+ "\" dosen't connect to all other nodes\n"
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
            print 'WARNING: There exists more than one island\n'
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
    for s in range(len(m.keys())):
        out.write(mySym(s))
    out.write("\n")
    for s in m.keys():
        row = []
        for k in m[s]:
            if k == '': out.write(".")
            else: out.write(str(k))
        out.write(" "+s+"\n")

def printmatrix(m):
    for s in m.keys():
        row = []
        for k in m[s]:
            if k == '': row +=[ 0]
            else: row += [ k]
        if len(s) == 1: print '('+s+' ) ',row
        else: print '('+s+') ',row 


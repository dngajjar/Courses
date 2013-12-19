from reader import *
from structure import *
from lisp2 import *

def walker(f, o):
    env = global_env
    g, e, flag = graph(f, o, env)
    lisp = Lisp(env)
    if flag == False: print "WARNING: The input txt file includes the above errors!\n", '= '*25
    print "="*45, "\nCongratulations! Your game has started! ^Q^ \n", "="*45, "\n"
    
    for s in g.keys.keys():
        if g.keys[s].start: start = g.keys[s]
        if g.keys[s].stop: stop = g.keys[s]
    node = start
    while True: 
        lisp.perform(node.onEntry.perform())  # conduct the onEntry code
        print '\n'+"*"*20+"\n"+node.name+"\n"+lisp.perform(node.description)+'\n'
        if node.name != stop.name:
            #print len(node.out)
            lst = []
            for s in node.out:
                #print s
                #print 'if-', s.ifval.perform(), ' value =', lisp.perform(s.ifval.perform())
                #print 'onExit-', s.onExit.perform()
                lisp.perform(s.onExit.perform())
                #print s.ifval.perform()
                #print lisp.perform(s.ifval.perform())
                if lisp.perform(s.ifval.perform()) == 'True':
                    lst += [s.there.name]
                    print "> "+s.there.name.ljust(15) + " :: "+lisp.perform(s.description)
            #print 'lst:', lst
            command = raw_input('\nYour Choice ===> ')
            node = g.keys[partialmatch(lst, command)]
        else:
            if node.out: print lisp.perform(node.out[0].description)
            print "\nUnfortunately! Game Over!"
            break

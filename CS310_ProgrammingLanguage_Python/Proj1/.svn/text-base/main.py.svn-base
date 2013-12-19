from structure import *
from reader import *

if __name__ == "__main__": 
    filename = raw_input('Input the file path for the stage text: ')
    f = open(filename, 'rb')
    o = open(filename + '.out', 'a')
    graph, edges, flag = graph(f, o)
    
    if flag == False: print "WARNING: The input txt file includes the above errors!\n", '= '*25
    # the scripts for playing the game
    print "\nCongratulations! Your game has started!"
    # find the start and end node
    track = []
    inventory = []
    for s in graph.keys.keys():
        if graph.keys[s].start: start = graph.keys[s]
        if graph.keys[s].stop: stop = graph.keys[s]
    node = start
    while True: 
        print '\n'+"*"*50+"\n"+node.name+"\n"+node.description+'\n'
        track += [node.name]
        if node.name != stop.name:
            inventory.extend(node.contents)
            print "Inventory: " + str(inventory) #delete
            for s in node.out: print "> "+s.there.name.ljust(10) + "  "+s.description
            command = raw_input('\n Your Choice ===>  ')
            lst = []            
            lst += [s.there.name for s in node.out]      
            node = graph.keys[partialmatch(lst, command)]
        else:
            if node.out: print node.out[0].description
            print '\nYour choices were:', track,"\n\nGame Over!"
            break
        
        

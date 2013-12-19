import re
from structure import* #wouldn't work the normal way for some reason

f = "input/1a.txt"

def paras(fileName):
    f = open(fileName,'r')
    para = "";
    for line in f: #loop through file
        curLine = re.sub('#+.*', "", line); #replaces # and anything past it with nothing
        if curLine.strip() != "" : #if the line isn't empty
             para += curLine.strip() +"\n"   # add line to para
        if para != "" and curLine.strip() == "":  # if para is not empty and line is empty
            yield para.strip()
            para = "";   #reset para


def graph(f) :
  g = Graph()
  for para in paras(f):
    lines = para.split("\n")  # split para into lines
    here  = g.node(lines[0])                     # the current node
    lines[0] = ""
    for l in lines:   # for all the other lines
      if not l.startswith(">"):
        here.description += l              # update heres' description
      else:
        words       = l.split(None, 2)           # split a goto line
        destination = words[1]           # where is the pointyLine sayign is our destination
        txt         = words[2]          # what is the explanation text on the line
        there       = g.node(destination)           # where are we going?
        Edge(here,there,txt)          # connect here to there
  return g

"""
def _parser():
  n= 0
  for para in paras(f):
    print "\n--|",n,"|----------------------"
    print para
    print "<end>"
    n += 1
"""

def gprint(f):
    g=graph(f)
    for state in g.nodes:
        print "\n", state

def nprint(n):
    options = ""
    for op in n.out:
        options += str(op) +"\n"
    print n.name + "\n" + n.description + \
          "\n" + options

def partial(curNode, uinput):
    for e in curNode.out:
        if (re.match(uinput,e.there.name)):
            return e.there
    print ("No valid match")

def walk(g):
    start = g.nodes[0]
    stop = None
    for node in g.nodes:
        if node.start: start = node
        if node.stop: stop = node
    currentNode = start
   
    while  (currentNode.name != stop):
        nprint(currentNode)
        if (currentNode.name == "Dead"):#  Hard coded stop condition
            break
        uinput = raw_input()
        currentNode = partial(currentNode, uinput)
        print "\n"
    print "Game Over"
        

walk(graph(f))


from lisp2 import *

# Define Edge Structure
class Edge:
    def __init__(self,here,there,txt):
      self.description = txt     # why am i making this jump? 
      self.here        = here    # where do i start (node object)
      self.there       = there   # where to i end (node object)
      self.here.out   += [self]  # btw, tell here that they can go there (here node linked edges)
      self.ifval       = Code('True')
      self.onExit      = Code('')
    def __repr__(self):
      return "E(" + self.here.name + " > " + self.there.name + ">about: " + self.description+ " >ifval: " +self.ifval.perform()+")" 
      
# Define Node Structure
class Node:
  end   = "."
  start = "!"

  def __init__(self,g,id,name,stop=False,start=False):
      self.id = id            # order of created node
      self.graph = g          # where do i live?
      self.name = name        # what is my name?
      self.description = ""   # tell me about myself
      self.stop = stop        # am i a stop node?
      self.start = start      # am i a start node?
      self.out = []           # where do i connect to (edge)
      self.onEntry = Code('')
      self.onExit = Code('')
      self.when = Code('')
      
  def also(self,txt):
      "adds text to description"
      sep = "\n" if self.description else ""
      self.description += sep + txt

  def __repr__(self):
      return "N( :id: " + str(self.id) + \
             "\n   :name: " + self.name + \
             "\n   :about: '" + self.description + "'" + \
             "\n   :out: " + str(self.out) + \
             "\n   :onEntry: " + str(self.onEntry.perform())+\
             "\n   :onExit: " + str(self.onExit.perform()) +\
             "\n   :When: " + str(self.when.perform()) +")"

# Define Graph Strcuture
class Graph:
    def __init__(self):
      self.nodes = []    # nodes, stored in creation order
      self.keys  = {}    # nodes indexed by name
      self.m = None      # adjacency matrix
      self.mPrime = None # transitive closure matrix

    def node(self,name):
      "returns a old node from cache or a new node"
      if not name in self.keys:
          self.keys[name] = self.newNode(name)
      return self.keys[name]

    def newNode(self,name):
      " create a new node"
      id = len(self.nodes) 
      tmp = Node(self,id,name)
      #print Node.start, Node.start in name
      #tmp.start = Node.start in name
      #tmp.end   = Node.end   in name
      #print 'node:', name, ' start:', tmp.start
      self.nodes += [tmp]
      return tmp

class Code:
    def __init__(self, txt = '', env = global_env):
        self.env = env
        self.txt = txt
        self.action = lambda env: self.noop(env, self.txt)
    def perform(self):
        return self.action(self.env)
    def noop(self, env, txt):
        return txt

class Lisp:
    def __init__(self, env = global_env):
        self.env = env
    def perform(self, txt = ''):
        if txt.find('(') != -1 and txt.rfind(')') != -1:
             value = eval(parse(txt[txt.find('('):txt.rfind(')')+1]), self.env)
             if value == None: value = ''
             return txt[:txt.find('(')]+str(value)+txt[txt.rfind(')')+1:]
        return txt



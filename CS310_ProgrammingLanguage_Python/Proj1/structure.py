# Define Edge Structure
class Edge:
    def __init__(self,here,there,txt):
      self.description = txt     # why am i making this jump? 
      self.here        = here    # where do i start (node object)
      self.there       = there   # where to i end (node object)
      self.here.out   += [self]  # btw, tell here that they can go there (here node linked edges)

    def __repr__(self):
      return "E(" + self.here.name + " > " + self.there.name + ">about: " + self.description+")"
      
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
      self.contents = []      # items obtained from nodes
      self.preq = []          # items required for node

  def also(self,txt):
      "adds text to description"
      sep = "\n" if self.description else ""
      self.description += sep + txt

  def __repr__(self):
      return "N( :id " + str(self.id) + \
             "\n   :name " + self.name + \
             "\n   :about '" + self.description + "'" + \
             "\n   :out " + str(self.out) + ") "

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
      tmp.start = Node.start in name
      tmp.end   = Node.end   in name
      self.nodes += [tmp]
      return tmp

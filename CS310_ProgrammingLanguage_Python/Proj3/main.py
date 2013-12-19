from structure import *
from reader import *
from Tkinter import *
from FileDialog import *
from walker import *
if __name__ == "__main__": 

    fd = LoadFileDialog(Tk())
    filename = fd.go()
    #filename = 'sample2.txt'
    f = open(filename, 'rb')
    o = open(filename + '_out', 'a')
    walker(f, o)
      

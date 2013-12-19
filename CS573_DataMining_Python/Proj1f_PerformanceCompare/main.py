import lib
import ptile
import random

if __name__ == "__main__":      
    lst = []
    lst4 = []
    f = '%3.2f'
    #for i in range(1000): lst += [random.random()**2]    
    #for i in range(1000): lst4 += [random.random()**0.5]
    lst = [0.28,0.28,0.28,0.29,0.29,0.31,0.31,0.32,0.32,0.32]
    lst4 = [0.78,0.78,0.79,0.79,0.80,0.80,0.81,0.81,0.82,0.82]
    chops1 = lib.pairs('0.1,-,0.2,-,0.3, ,0.4, ,0.5, ,0.6, ,0.7,-,0.8,-,0.9, ')
    chops2 = lib.pairs('0.25,-,0.5,-,0.75, ')
    print chops1    
    out1 = ptile.ptile(lst, chops1, 20, f, 0, 1)
    out4 = ptile.ptile(lst4, chops1, 20, f, 0, 1)
    print "square,    ", out1
    print "squareRoot,", out4
    """
    lst2 = lib.pairs('1,0.51,2,0.49,3,0.48,4,0.52,5,0.25,6,0.48,7,0.49,8,0.51,9,0.52,10,0.48')
    lst3 = lib.pairs('1,0.81,2,0.82,3,0.80,4,0.79,5,0.78,6,0.8,7,0.81,8,0.82,9,0.79,10,0.78')
    out2 = ptile.ptile(lst2, chops2, 40, f, 0.45,0.85)    
    out3 = ptile.ptile(lst3, chops2, 40, f, 0.45,0.85)   
    print "rx4, ", out2
    print "rx5, ", out3
    """
import rank
import lib
import os
if __name__ == "__main__":     
    re = 'output_1/'
    dest = re+"results/rank_data/"   
    outfile = open(re+'results/rank_results.txt', 'w')
    for root, dirs, files in os.walk( dest ):
        for infile in files :
            if infile.find( r'.txt' ) == -1 : continue 
            a = lib.pairs("-cohen,0.3,--mittas,1,-a12,0.6")
            print root+infile
            rank.ranks(root+infile, a, outfile)

   
           
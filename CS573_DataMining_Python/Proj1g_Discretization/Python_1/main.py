import reader
import tablestr
import discrete
import os

if __name__ == "__main__":    
    dest = "data/"
    outfile = open( "output/result.txt", "w" )
    for root, dirs, files in os.walk( dest ):
        for filename in files :
            print filename
            if filename.find( '*.csv' ) == -1 :
                continue
            filename = join( root, OneFileName )
            print filename
    """
    filenames = {0:'data/ant-1.7.csv', 1: 'data/ivy-1.1.csv', 2: 'data/jedit-4.1.csv', 3: 'data/log4j-1.1.csv',
                 4: 'data/lucene-2.4.csv', 5: 'data/poi-3.0.csv', 6: 'data/synapse-1.2.csv', 7: 'data/velocity-1.6.csv',
                 8: 'data/xalan-2.6.csv', 9: 'data/xerces-1.4.csv'}

    filename = data/*.csv
    open(filename)
    filename = 'data/weather2.csv'   
    table = tablestr.Table()             #create raw data structure
    reader.readcsv(filename,table )      #read the .csv data set
    f = '%4.2f'                          #set the formatting for the output  
    #tables = reader.klasses(table)
    #tablestr.tableprint(tables['0'], f)
    bins = 9
    t = 0
    tables = discrete.discrete(table, t, bins)
    tablestr.tableprint(tables[0], f)
    tablestr.tableprint(tables['D_'+str(t)], f)
    """
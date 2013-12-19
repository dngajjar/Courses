import reader
import tablestr
import zeror
import xval 
import nb
if __name__ == "__main__":      
    filename = 'data/soybean.csv'   
    table = tablestr.Table()             #create raw data structure
    reader.readcsv(filename,table )      #read the .csv data set
    f = '%4.2f'                          #set the formatting for the output
    tables = reader.klasses(table)
    b = x = 5
    k = 1
    m = 2
    xvaltables = xval.xvals(tables, x, b) #generate the cross validation tables
    re_zeror = []
    re_nb = [] 
    for s in range(x*b):
       s += 1
       got, acc_zeror = zeror.zeror(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'])
       acc_nb = nb.nb(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'], k, m)
       re_zeror += [str(f%acc_zeror)]
       re_nb += [str(f%acc_nb)]
    print 'zeror = ', re_zeror
    print 'nb = ', re_nb

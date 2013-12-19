import reader
import tablestr
import zeror
import xval 
import nb
import knn
import uxval

if __name__ == "__main__":      
    filename = 'data/weather2.csv'   
    table = tablestr.Table()             #create raw data structure
    reader.readcsv(filename,table )      #read the .csv data set
    f = '%4.2f'                          #set the formatting for the output 
    tables = reader.klasses(table)
    b = x = 2
    kn = 5
    k = 1
    m = 2
    uxvaltables = uxval.uxvals(tables, x, b)
    knn_acc = []
    nb_acc = []    
    for s in range(b*x):
        s += 1
        acc = knn.knn(uxvaltables[s]['test'], uxvaltables[s]['train'], tables, kn)
        #acc2 = nb.nb(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'], k, m)        
        knn_acc += [f%acc]
        #nb_acc += [f%acc2]
    print 'knn_acc =', knn_acc
    #print 'nb_acc =', nb_acc


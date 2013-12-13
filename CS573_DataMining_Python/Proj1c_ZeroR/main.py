import reader
import tablestr
import zeror
import xval 
if __name__ == "__main__":      
    filename = 'data/soybean.csv'   
    table = tablestr.Table()             #create raw data structure
    reader.readcsv(filename,table )      #read the .csv data set
    f = '%4.2f'                          #set the formatting for the output
    filename = 'output/table_xval_zeror_soy.txt'    
    out = file(filename, 'w')    
    tables = reader.klasses(table)
    #tablestr.tableprint(tables['0'], f)
    print tables['0'].klass
    b = x = 2
    xvaltables = xval.xvals(tables, x, b) #generate the cross validation tables
      
    for s in range(x*b):
       s += 1
       print('='*80+'\n')
       print('Group:'+ str(s) +'\n')
       print('Training Set \n')
       for h in xvaltables[s]['train']['names']:
          tablestr.tableprint(xvaltables[s]['train'][h], f)
       out.write('Testing Set \n')
       #for h in xvaltables[s]['test']['names']:   
        #   tablestr.tableprint(xvaltables[s]['test'][h],  f)
       got, acc = zeror.zeror(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'])
       print('#Got: ' + got +'\n')
       print('#Accuracy: ' + acc+'\n')
    
    out.close()

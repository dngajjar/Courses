import reader
import tablestr
import zeror
import xval

try: 
    if __name__ == "__main__":      
        filename = 'data/weather1.csv'   
        table = tablestr.Table()             #create raw data structure
        reader.readcsv(filename,table )      #read the .csv data set
        f = '%4.2f'                          #set the formatting for the output
        filename = 'output/table1.txt'    
        out = file(filename, 'w')    
        tables = reader.klasses(table)
        tablestr.tableprint(tables['0'], f)
        """
        tablestr.tableprint_txt(tables['0'], out, "weather1.csv/Table['0']", f)  
        for h in tables['names']:
            tablestr.tableprint(tables[h], f)
            tablestr.tableprint_txt(tables[h], out, "weather1.csv/Table['"+h+"']", f)  
        zeror.zeror(tables, tables, tables['names'])
        """
        x = 2
        b = 2
        xvaltables = xval.xvals(tables, x, b)
        for s in range(x*b):
            s += 1
            print s
            for h in xvaltables[s]['train']['names']:
                tablestr.tableprint(xvaltables[s]['train'][h], f)
            print '=================================================='
            for h in xvaltables[s]['test']['names']:   
                tablestr.tableprint(xvaltables[s]['test'][h], f)
            print '=================================================='
            zeror.zeror(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'])
        out.close()
except Exception, ex:
    print Exception,":",ex
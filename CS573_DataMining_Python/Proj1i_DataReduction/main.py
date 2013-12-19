import reader
import tablestr
import discrete
import os
import attrselect
import tiles
import uxval
import newknn
import nb
import lib
import knn
import projections
if __name__ == "__main__":       
    dest = "data/"
    #outfile1 = open('output/projections.txt','w')
    ite = 0       # num of dataset readin
    alltables = {}   # structures stored all the readin datasets
    numdim = 2    # num of target dimensionality that produced
    pattr = 0.25  # percentage of target attributes produced
    k, m, bins, f, kn, threshold = 5, 5, 10, '%4.2f', 2, 0.5        
    re = 'output_2/'; os.mkdir(re); os.mkdir(re+'results'); os.mkdir(re+'results/rank_data')
    for root, dirs, files in os.walk( dest ):
        for infile in files :
            if infile.find( r'.csv' ) == -1 : continue
            ite += 1
            outfile0 = open(re+'result_'+infile+'.txt', 'w')
            outfile1 = open(re+infile+'_project.dat', 'w')
            outfile = open( re+"results/acc_"+infile+".txt", "w" )
            outfile0.write(infile+'\n')
            table = tablestr.Table()
            reader.readcsv(root+infile, table)
            uxvaltables, xvaltables = uxval.uxvals(table, k, m)  #cross-validation
                    
            #xvaltables = xval.xvals(table, k, m)
            #print len(xvaltables[1]['test']['0'].data[20]), len(xvaltables[1]['test']['1'].data[20]), len(xvaltables[1]['test']['all'].data[20])
            #print len(uxvaltables[1]['test']['0'].data[20]), len(uxvaltables[1]['train']['0'].data[20])
            
            #tablestr.tableprint(xvaltables[1]['train']['0'])
            #tablestr.tableprint(xvaltables[1]['train']['1'])
            acc_pcaT_all, acc_pcaT_infogain, acc_nb, acc_knn, acc_fastT_all, acc_fastT_infogain = [], [], [], [], [], []
            f_pcaT_all, f_pcaT_infogain, f_nb, f_knn, f_fastT_all, f_fastT_infogain = [], [], [], [], [], []
            prec_pcaT_all, prec_pcaT_infogain, prec_nb, prec_knn, prec_fastT_all, prec_fastT_infogain = [], [], [], [], [], []
            pd_pcaT_all, pd_pcaT_infogain, pd_nb, pd_knn, pd_fastT_all, pd_fastT_infogain = [], [], [], [], [], []
            pcaT_all_cen, pcaT_info_cen, fastT_info_cen = [], [], []
            print 'Processing '+ infile+'\n'
            #k = m = 1
            for s in range(k*m):
                s += 1; print 'Complete:'+str(s)+' of '+ str(k*m) + ';'      
                train_table = uxvaltables[s]['train']['0']; test_table = uxvaltables[s]['test']['0']               
                
                discrete_table = discrete.discrete(train_table, bins)  #discrete_table[0]: original; discrete_table['d']: discrete table
                attrlst, inforgain = attrselect.attrselect(discrete_table['d'], pattr)     #select attributes    
                # tables after feature selection                
                attrtable_train = attrselect.attrtable(train_table, attrlst)                
                attrtable_test = attrselect.attrtable(test_table, attrlst)
                
                
                #test_table = projections.projections(uxvaltables[s]['test'])
                pcaT_all,tmp1 = tiles.tiles(table, numdim, outfile0)  #pca projection and clustering
                pcaT_info, tmp2 = tiles.tiles(attrtable_train, numdim, outfile0)
                #fastT_all = tiles.tilesv2(table, numdim, outfile0)
                fastT_info, tmp3 = tiles.tilesv2(attrtable_train, numdim, outfile0)     
                
                pcaT_all_cen += [tmp1]; pcaT_info_cen += [tmp2]; fastT_info_cen += [tmp3]

                #tablestr.tableprint(centroid_attr)
                tables = reader.klasses(table)
                kt = 1; mt = 2
                acc1, f1, prec1, pd1 = nb.nb(xvaltables[s]['test'], xvaltables[s]['train'], tables['names'], kt, mt)
                acc2, f2, prec2, pd2 = knn.knn(uxvaltables[s]['test'], uxvaltables[s]['train'], kn)
                # PCA Infer Methods
                acc3, f3, prec3, pd3 = newknn.knn(test_table, pcaT_all[0], kn, threshold)
                acc4, f4, prec4, pd4 = newknn.knn(attrtable_test, pcaT_info[0], kn, threshold)

                # Fastmap Infer Methods
                #acc5, f5, prec5, pd5 = newknn.knn(test_table, fastT_all[0], kn, threshold)
                acc6, f6, prec6, pd6 = newknn.knn(attrtable_test, fastT_info[0], kn, threshold)
                break
                acc_pcaT_all += [acc3]
                acc_pcaT_infogain += [acc4] 
                acc_nb += [acc1]
                acc_knn += [acc2]
                #acc_fastT_all += [acc5]
                acc_fastT_infogain += [acc6]    
                
                f_pcaT_all += [f3]
                f_pcaT_infogain += [f4] 
                f_nb += [f1]
                f_knn += [f2]
                #f_fastT_all += [f5]
                f_fastT_infogain += [f6]  
                
                prec_pcaT_all += [prec3]
                prec_pcaT_infogain += [prec4] 
                prec_nb += [prec1]
                prec_knn += [prec2]
                #prec_fastT_all += [prec5]
                prec_fastT_infogain += [prec6] 
                
                pd_pcaT_all += [pd3]
                pd_pcaT_infogain += [pd4] 
                pd_nb += [pd1]
                pd_knn += [pd2]
                #pd_fastT_all += [pd5]
                pd_fastT_infogain += [pd6] 
                
                """
                tables = project_table; ntable = tables['project']
                tablewrite.projectwrite(outfile1, ntable, tables)
                tablewrite.projectwrite2(outfile1, ntable) 
                
                tables = project_table_attr; ntable = tables['project']
                tablewrite.projectwrite(outfile1, ntable, tables)
                tablewrite.projectwrite2(outfile1, ntable) 
                
                tablewrite.tablewrite(outfile0, tables, discrete_table['d'], ntable)
                """
            outfile0.write('PCA All:\n');  outfile0.write('%4.0f'%(sum(pcaT_all_cen)/len(pcaT_all_cen)))
            outfile0.write('\nPCA Info:\n'); outfile0.write('%4.0f'%(sum(pcaT_info_cen)/len(pcaT_info_cen)))
            outfile0.write('\nFast Info:\n'); outfile0.write('%4.0f'%(sum(fastT_info_cen)/len(fastT_info_cen)))
            
            outfile.write('*'*60 + '\n'+infile+'\n')
            outfile.write('\nAccuracy Results:\n')
            outfile.write('NB:'+ lib.rowprint(sorted(acc_nb))+'\n'); 
            outfile.write('KNN:'+ lib.rowprint(sorted(acc_knn))+'\n'); 
            outfile.write('PCA_Infogain:' + lib.rowprint(sorted(acc_pcaT_infogain))+'\n')
            outfile.write('PCA_All:' + lib.rowprint(sorted(acc_pcaT_all))+'\n')
            outfile.write('FastMap_Infogain:' + lib.rowprint(sorted(acc_fastT_infogain))+'\n')
            #outfile.write('FastMap_All:' + lib.rowprint(sorted(acc_fastT_all))+'\n')
            
            outfile.write('\nF-Measure Results:\n')
            outfile.write('NB:'+ lib.rowprint(sorted(f_nb))+'\n'); 
            outfile.write('KNN:'+ lib.rowprint(sorted(f_knn))+'\n'); 
            outfile.write('PCA_Infogain:' + lib.rowprint(sorted(f_pcaT_infogain))+'\n')
            outfile.write('PCA_All:' + lib.rowprint(sorted(f_pcaT_all))+'\n')
            outfile.write('FastMap_Infogain:' + lib.rowprint(sorted(f_fastT_infogain))+'\n')
            #outfile.write('FastMap_All:' + lib.rowprint(sorted(f_fastT_all))+'\n')
           
            outfile.write('\nPrecision Results:\n')
            outfile.write('NB:'+ lib.rowprint(sorted(prec_nb))+'\n'); 
            outfile.write('KNN:'+ lib.rowprint(sorted(prec_knn))+'\n'); 
            outfile.write('PCA_Infogain:' + lib.rowprint(sorted(prec_pcaT_infogain))+'\n')
            outfile.write('PCA_All:' + lib.rowprint(sorted(prec_pcaT_all))+'\n')
            outfile.write('FastMap_Infogain:' + lib.rowprint(sorted(prec_fastT_infogain))+'\n')
            #outfile.write('FastMap_All:' + lib.rowprint(sorted(prec_fastT_all))+'\n')
            
            outfile.write('\nRecall Results:\n')
            outfile.write('NB:'+ lib.rowprint(sorted(pd_nb))+'\n'); 
            outfile.write('KNN:'+ lib.rowprint(sorted(pd_knn))+'\n'); 
            outfile.write('PCA_Infogain:' + lib.rowprint(sorted(pd_pcaT_infogain))+'\n')
            outfile.write('PCA_All:' + lib.rowprint(sorted(pd_pcaT_all))+'\n')
            outfile.write('FastMap_Infogain:' + lib.rowprint(sorted(pd_fastT_infogain))+'\n')
            #outfile.write('FastMap_All:' + lib.rowprint(sorted(pd_fastT_all))+'\n')     
            
            outfile.write('\nSummary:\n')
            outfile.write('NB:'+ '%4.2f'%(sum(acc_nb)/(k*m))+','+ '%4.2f'%(sum(prec_nb)/(k*m))+',' '%4.2f'%(sum(pd_nb)/(k*m))+',' '%4.2f'%(sum(f_nb)/(k*m))+'\n')
            outfile.write('KNN:'+ '%4.2f'%(sum(acc_knn)/(k*m))+','+ '%4.2f'%(sum(prec_knn)/(k*m))+',' '%4.2f'%(sum(pd_knn)/(k*m))+',' '%4.2f'%(sum(f_knn)/(k*m))+'\n')
            outfile.write('PCA_Infogain:'+ '%4.2f'%(sum(acc_pcaT_infogain)/(k*m))+','+ '%4.2f'%(sum(prec_pcaT_infogain)/(k*m))+',' '%4.2f'%(sum(pd_pcaT_infogain)/(k*m))+',' '%4.2f'%(sum(f_pcaT_infogain)/(k*m))+'\n')
            outfile.write('PCA_All:'+ '%4.2f'%(sum(acc_pcaT_all)/(k*m))+','+ '%4.2f'%(sum(prec_pcaT_all)/(k*m))+',' '%4.2f'%(sum(pd_pcaT_all)/(k*m))+',' '%4.2f'%(sum(f_pcaT_all)/(k*m))+'\n')
            outfile.write('FastMap_Infogain:'+ '%4.2f'%(sum(acc_fastT_infogain)/(k*m))+','+ '%4.2f'%(sum(prec_fastT_infogain)/(k*m))+',' '%4.2f'%(sum(pd_fastT_infogain)/(k*m))+',' '%4.2f'%(sum(f_fastT_infogain)/(k*m))+'\n')
            #outfile.write('FastMap_all:'+ '%4.2f'%(sum(acc_fastT_all)/(k*m))+','+ '%4.2f'%(sum(prec_fastT_all)/(k*m))+',' '%4.2f'%(sum(pd_fastT_all)/(k*m))+',' '%4.2f'%(sum(f_fastT_all)/(k*m))+'\n')
            
            temp1 = open(re+"results/rank_data/acc_"+infile+".txt", "w" )
            temp2 = open(re+"results/rank_data/f_"+infile+".txt", "w" )
            temp1.write('NB  '+ lib.rowprint(sorted(acc_nb))+'\n'); 
            temp1.write('KNN  '+ lib.rowprint(sorted(acc_knn))+'\n'); 
            temp1.write('PCA_Infogain  ' + lib.rowprint(sorted(acc_pcaT_infogain))+'\n')
            temp1.write('PCA_All  ' + lib.rowprint(sorted(acc_pcaT_all))+'\n')
            temp1.write('FastMap_Infogain  ' + lib.rowprint(sorted(acc_fastT_infogain))+'\n')
         
            temp2.write('NB  '+ lib.rowprint(sorted(f_nb))+'\n'); 
            temp2.write('KNN  '+ lib.rowprint(sorted(f_knn))+'\n'); 
            temp2.write('PCA_Infogain  ' + lib.rowprint(sorted(f_pcaT_infogain))+'\n')
            temp2.write('PCA_All  ' + lib.rowprint(sorted(f_pcaT_all))+'\n')
            temp2.write('FastMap_Infogain  ' + lib.rowprint(sorted(f_fastT_infogain))+'\n')
            outfile.close()
            outfile1.close()
            outfile0.close()
            temp1.close()
            temp2.close()
            break
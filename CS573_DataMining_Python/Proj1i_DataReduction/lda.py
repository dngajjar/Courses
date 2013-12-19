import numpy as np
import lib
#import scipy as sp
import scipy.linalg as linalg
#import operator

def lda(X,Z, numdim):
    datanum,dim = X.shape
    totalMean = np.mean(X,0)
    Y = [int(i) for i in Z] # change class label into numeric type
    classLabels = np.unique(Y)
    #classNum = len(classLabels)
    partition = [np.where(Y==label)[0] for label in classLabels]
    classMean = [(np.mean(X[idx],0),len(idx)) for idx in partition]
    

    #compute the within-class scatter matrix
    W = np.zeros((dim,dim))
    for idx in partition:
        W += np.cov(X[idx],rowvar=0)*len(idx)
    #compute the between-class scatter matrix
    B = np.zeros((dim,dim))
    for mu,class_size in classMean:
        offset = mu - totalMean
        B += np.outer(offset,offset)*class_size

    #solve the generalized eigenvalue problem for discriminant directions
    ew, ev = linalg.eig(B,W+B)
    #sorted_pairs = sorted(enumerate(ew), key=operator.itemgetter(1), reverse=True)
    #selected_ind = [ind for ind,val in sorted_pairs[:classNum-1]]
    discriminant_vector = newev
    # project the mean vectors of each class onto the LDA space
    #projected_centroid = [np.dot(mu,discriminant_vector) for mu,class_size in classMean]
    projected_data  = np.dot(X,discriminant_vector)
    print 'LDA Projection Finished.'
    return projected_data
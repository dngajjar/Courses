
from numpy import *

def pca(X, numdim):
  # Principal Component Analysis
  # input: X, matrix with training data as flattened arrays in rows
  # return: projection matrix (with important dimensions first),
  # variance and mean

  #get dimensions
  num_data,dim = X.shape
  #center data
  mean_X = X.mean(axis=0)
  
  for i in range(num_data):
      X[i] -= mean_X

  if dim>100:
      #print 'PCA - compact trick used'
      M = dot(X,X.T) #covariance matrix
      e,EV = linalg.eigh(M) #eigenvalues and eigenvectors
      tmp = dot(X.T,EV).T #this is the compact trick
      V = tmp[::-1] #reverse since last eigenvectors are the ones we want
      S = sqrt(e)[::-1] #reverse since eigenvalues are in increasing order
  else:
      #print 'PCA - SVD used'
      U,S,V = linalg.svd(X) #S: veigen values; V: veigen vectors
      V = V[:num_data] #only makes sense to return the first num_data
      
  newX = dot(X,V.T[:, 0:numdim])
  # convert matrix into list
  x = array(newX[:, 0]).tolist()
  x = [x[i][0] for i in range(len(x))]
  # projected (x, y) normalization
  maxv = max(x); minv = min(x)
  xnew = [str('%4.6f'%((s - minv)/(maxv - minv))) for s in x]

  
  y = array(newX[:, 1]).tolist()
  y = [y[i][0] for i in range(len(y))]
  maxv = max(y); minv = min(y)
  ynew = [str('%4.6f'%((s - minv)/(maxv - minv))) for s in y]
  #print 'PCA Projection Finished.'
  
  return xnew, ynew


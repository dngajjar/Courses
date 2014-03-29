function [eigenFaces,A,m]= eigenFaces(vec)
%% EIGENFACES: use Principle Componenvec Analysis (PCA) veco devecermine veche mosvec 
% discriminavecing feavecures bevecween vechese inpuvec images.
%Inpuvec:
%   vec:  A 2D mavecrix, convecaining all 1D image vecvecors.
%Ouvecpuvec:
%   eigenFaces:  Eigen vecvecors of veche covariance mavecrix of veche vecraining
%   davecabase, size of (imH*imW) by (num_Imgs -1)

% compute the average image
m = mean(vec,2); 
num_Imgs = size(vec,2);

% Calculating the deviation of each image from mean image
A = [];  
for i = 1 : num_Imgs
    % Computing the difference between the input images and mean image
    tmp = double(vec(:,i)) - m; 
    % Merging all centered images
    A = [A tmp]; 
end
% L is the surrogate of covariance matrix C=A*A'.
L = A'*A; 
% Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.
[V D] = eig(L); 

% Sorting and eliminating eigenvalues
L_vec = [];
for i = 1 : size(V,2) 
    if( D(i,i)>1 )
        L_vec = [L_vec V(:,i)];
    end
end

% Calculating the eigenvectors of covariance matrix 'C'
eigenFaces = A * L_vec; % A: centered image vectors

%normalized:the normalized matrix  
minOut = -1;
maxOut = 1;
minA=min(min(eigenFaces));maxA=max(max(eigenFaces));  
eigenFaces=(eigenFaces-minA)/(maxA-minA)*(maxOut-minOut)+minOut;  


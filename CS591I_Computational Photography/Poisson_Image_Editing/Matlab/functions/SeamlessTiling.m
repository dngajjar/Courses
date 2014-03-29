function imNew = SeamlessTiling(imSrc, imB)
%% SEAMLESSTILING Function: tile two 
%Input:
%   imSrc: the source image
%   imB: the source image with the modified border
%Output:
%   imNew: the generated new image

%% Main Function

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
% conduct the laplacian operator on the source image
imLaplacian = conv2(imSrc, laplacian, 'same');
[imH, imW] = size(imSrc);
imDest = imB;
x0 = 2;
y0 = 2;
w0 = imW-2;
h0 = imH-2;
xd = 1;
yd = 1;

% allocate the sparse matrix
M = sparse(w0*h0, w0*h0, 5*w0*h0);
B = zeros(1,w0*h0);

count = 1;
for y = 1:h0
    for x = 1:w0
       % index of M matrix
       i = (y-1)*w0+x;
       % detect if it is the boundary
       
        % check the top boundary condition
        if y~= 1
            M(count,i-w0) = -1;
        else
            B(count) = B(count)+ imDest(y+yd-1, x+xd);           
        end
        
        % check the bottom boundary condition
        if y~=h0
            M(count, i+w0) = -1;
        else
            B(count) = B(count) + imDest(y+yd+1, x+xd);
        end
        
        % check the left boundary condition
        if x~=1
            M(count, i-1) = -1;
        else
            B(count) = B(count) + imDest(y+yd, x+xd-1);
        end
        
        % check the right boundary condition
        if x~=w0
            M(count, i+1) = -1; 
        else
            B(count) = B(count) + imDest(y+yd, x+xd+1);
        end
        
        M(count, i) = 4;
        
        %construct the guidance field
        xV = x + x0-1;
        yV = y + y0-1;
        v = imLaplacian(yV, xV);
        B(count) = B(count)+v;
        count = count + 1;  
    end
    
end
% solve the sparse matrix M using BiConjugate Gradients Method
fDest = bicg(M, B', [], 400);
imROI = reshape(fDest, w0, h0);
imROI = imROI';

% paste the generated ROI to the destination image
imNew = imDest;
imNew(yd+1:yd+h0, xd+1:xd+w0) = imROI;
end


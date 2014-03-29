function imNew = SeamlessCloning(imSrc, imDest, ROIsrc, ROIdest)
%SEAMLESSCLONING: using poisson solver to paste the square contaning the
%target object to the destination image
%Input:
%   imSrc: the source image
%   imDest: the destination image
%   ROIsrc: a vector [x, y, w, h] define the square containing the object
%   ROI dest: a vector [x, y] define the point that the ROIsrc pasting on
%   the destination image

%%


% get the size of the chosen ROI region
x0 = ROIsrc(1);
y0 = ROIsrc(2);
w0 = ROIsrc(3);
h0 = ROIsrc(4);

% check for the B condition: that the location of the destination 
% image adding the ROI source image should not exceed the B of the 
% destination image
sizeDest = size(imDest);
sizeSrc = size(imSrc);
width = ROIdest(1)+w0;
height = ROIdest(2)+h0;
if width>=sizeDest(2) | height>=sizeDest(1)| x0<=1 |y0<=1 | ROIdest(1)<=1 | ROIdest(2)<=1
   %fprintf('Error definition of the ROI or destination location point'); 
    if width>=sizeDest(2)
        ROIdest(1) = sizeDest(2) - w0-1;
    end
    if height>=sizeDest(1)
        ROIdest(2) = sizeDest(1) - h0-1;
    end
end

% define the gradient image as |gradient(p)| = 4*Bp - Bq1 - Bq2 - Bq3 - Bq4
laplacian = [0 -1 0; -1 4 -1; 0 -1 0];

% allocate sparse matrix
n = h0*w0;
M = spalloc(n, n, 5*n);

% get the B condition for equation M*X=B
B = zeros(1,n);

% conduct the laplacian operator on the source image
imLaplacian = conv2(imSrc, laplacian, 'same');
% imLaplacian = abs(imLaplacian);
% figure, imshow(mat2gray(imLaplacian));
count = 1;
for y = 1:h0
    for x = 1:w0
        % index for the source ROI gradient column vector (1~n)
        i = (y-1)*w0+x;
        % detect if it is the boundary
        % check the top boundary condition
        if y~= 1
            M(count,i-w0) = -1;
        else
            B(count) = B(count)+ imDest(ROIdest(2)+y-1, ROIdest(1)+x);           
        end
        
        % check the bottom boundary condition
        if y~=h0
            M(count, i+w0) = -1;
        else
            B(count) = B(count) + imDest(ROIdest(2)+y+1, ROIdest(1)+x);
        end
        
        % check the left boundary condition
        if x~=1
            M(count, i-1) = -1;
        else
            B(count) = B(count) + imDest(ROIdest(2)+y, ROIdest(1)+x-1);
        end
        
        % check the right boundary condition
        if x~=w0
            M(count, i+1) = -1; 
        else
            B(count) = B(count) + imDest(ROIdest(2)+y, ROIdest(1)+x+1);
        end
        
        M(count, i) = 4;
        
        %construct the guidance field
        xV = x + x0;
        yV = y + y0;
        
        v = imLaplacian(yV, xV);
        B(count) = B(count) + v;
        count = count + 1;
    end
end

% solve the sparse matrix M using BiConjugate Gradients Method

fDest = bicg(M, B', [], 300);
imROI = reshape(fDest, w0, h0);
imROI = imROI';

% paste the generated ROI to the destination image
imNew = imDest;
imNew(ROIdest(2)+1:ROIdest(2)+h0, ROIdest(1)+1:ROIdest(1)+w0) = imROI;



end


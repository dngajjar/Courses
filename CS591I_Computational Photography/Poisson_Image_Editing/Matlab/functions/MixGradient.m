function [imROI, imNew] = MixGradient(imSrc, imDest, ROIsrc, ROIdest)
%MIXGRADIENT: using poisson solver to paste the square contaning the
%target object with holes to the destination image
%Input:
%   imSrc: the source image
%   imDest: the destination image
%   ROIsrc: a vector [x, y, w, h] define the square containing the object
%   ROI dest: a vector [x, y] define the point that the ROIsrc pasting on
%   the destination image
%Output:
%   imROI: the ROI region of generated image

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
   fprintf('Error definition of the ROI or destination location point'); 
end

% allocate sparse matrix
n = h0*w0;
M = spalloc(n, n, 5*n);

% get the B condition for equation M*X=B
B = zeros(1,n);

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
        
        % determine the location on the source image
        xSrc = x + x0;
        ySrc = y + y0;
        % determine the location on the destination image
        xDest = x + ROIdest(1);
        yDest = y + ROIdest(2);
        % the source gradients
        Gpq1 = imSrc(ySrc, xSrc) - imSrc(ySrc-1, xSrc);
        Gpq2 = imSrc(ySrc, xSrc) - imSrc(ySrc+1, xSrc);
        Gpq3 = imSrc(ySrc, xSrc) - imSrc(ySrc, xSrc-1);
        Gpq4 = imSrc(ySrc, xSrc) - imSrc(ySrc, xSrc+1);
        % the destination gradients
        Fpq1 = imDest(yDest, xDest) - imDest(yDest-1, xDest);
        Fpq2 = imDest(yDest, xDest) - imDest(yDest+1, xDest);
        Fpq3 = imDest(yDest, xDest) - imDest(yDest, xDest-1);
        Fpq4 = imDest(yDest, xDest) - imDest(yDest, xDest+1);
        
        % Select stronger one from source and destination gradients:
        v = 0;
        if abs(Gpq1)<abs(Fpq1)
            v = v + Fpq1;
        else 
            v = v + Gpq1;
        end
        
       if abs(Gpq2)<abs(Fpq2)
            v = v + Fpq2;
        else 
            v = v + Gpq2;
       end
       
        if abs(Gpq3)<abs(Fpq3)
            v = v + Fpq3;
        else 
            v = v + Gpq3;
        end
        
        if abs(Gpq4)<abs(Fpq4)
            v = v + Fpq4;
        else 
            v = v + Gpq4;
        end
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


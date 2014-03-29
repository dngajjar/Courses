function imNew = SeamlessCloning_mask(imSrc, imDest, imMask, locationDest)
%SEAMLESSCLONING_MASK: get the seamless cloning image using mask
%Input
%   imSrc: source image
%   imDest: destination image
%   imMask: binary image to indicate the region of interest in source image
%   locationDest: the location on the destination image to paste the ROI

% define the gradient image as |gradient(p)| = 4*Bp - Bq1 - Bq2 - Bq3 - Bq4
laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
sizeSrc = size(imSrc);
sizeDest = size(imDest);
sizeMask = size(imMask);

% check for the boundary condition: that the location of the destination 
% image adding the ROI source image should not exceed the boundary of the 
% destination image
if sizeMask(2)>=sizeDest(2) | sizeMask(1)>=sizeDest(1)| sizeMask(2)~= sizeSrc(2) | sizeMask(1)~=sizeSrc(1)
   fprintf('Error: the size of the mask image is too big.'); 
   return;
end

% the location on the destination image to paste the ROI
% locationDest(1) = vecSrc(1) - vecDest(1);
% locationDest(2) = vecSrc(2) - vecDest(2);
xOff = locationDest(1);
yOff = locationDest(2);

% calculate the total number of pixels that are 1 for sparse matrix (valid pixels in ROI)
% allocation and create the sparse matrix
n = size(find(imMask),1);
M = spalloc(n, n, 5*n);

% get the boundary condition for equation M*X=B
B = zeros(1,n);

% temporary indext matrix of indicating the pasted ROI on the destination
% image
imIndex = zeros(sizeDest(1), sizeDest(2));

count = 0;
% set the indices in the imIndex matrix of labling the ROI with integers
for y = 1:sizeSrc(1)
    for x = 1:sizeSrc(2)
        if imMask(y, x) ~= 0
            count = count + 1;
            % the convertion of point from source image to destination image
            % locationDest(1) = vecSrc(1) - vecDest(1);
            % locationDest(2) = vecSrc(2) - vecDest(2);
            yDest = y - yOff;
            xDest = x - xOff;
            imIndex(yDest, xDest) = count;
        end
    end
end


% get the gradient for the source image
imLaplacian = conv2(imSrc, laplacian, 'same');
%figure, imshow(mat2gray(imLaplacian));
count = 0;
for y = 2:sizeSrc(1)
    for x = 2:sizeSrc(2)
        if imMask(y, x) ~= 0
            count = count + 1;
            
            % the corresponding position in the destination image
            yDest = y - yOff;
            xDest = x - xOff;
            
            % if on the top
            if imMask(y-1, x) ~= 0
                M(count, imIndex(yDest-1, xDest)) = -1;
            else
                B(count) = B(count) + imDest(yDest-1, xDest);
            end
            % if on the left
            if imMask(y, x-1) ~= 0
                M(count, imIndex(yDest, xDest-1)) = -1;
            else
                B(count) = B(count)+imDest(yDest, xDest-1);
            end
            % in on the bottom
            if imMask(y+1, x) ~= 0
                M(count, imIndex(yDest+1, xDest)) = -1;
            else
                B(count) = B(count)+imDest(yDest+1, xDest);
            end
            % if on the right
            if imMask(y, x+1) ~= 0
                M(count, imIndex(yDest, xDest+1)) = -1;
            else
                B(count) = B(count)+imDest(yDest, xDest+1);
            end
            
            M(count, count) = 4;
            
            % get the guidance field
            v = imLaplacian(y, x);
            B(count) = B(count)+v;
        end
    end
end


solution = bicg(M, B', [],300);

imNew = imDest;
for y = 1:sizeDest(1)
    for x = 1:sizeDest(2)
        if y+yOff>=1&&y+yOff<=sizeSrc(1)&&x+xOff>=1&&x+xOff<=sizeSrc(2)
            if imMask(y+yOff, x+xOff) ~= 0
                index = imIndex(y, x);
                imNew(y, x) = solution(index);
            end     
        end
    end
end

end


function imNew = TextureFlattening(imSrc, srcName, resultsDir,ROIsrc)
%% TextureFlattening: using poisson solver to flatten the texture of the
%given area in the source image and generate the output image
%Input:
%   imSrc: the source image
%   ROIsrc: a vector [x, y, w, h] define the square containing the target
%   area to flatten
%Output:
%   imNew: the output image with the flattening target area

%% Main Function

[imH, imW, ~] = size(imSrc);
imDest = imSrc;
x0 = ROIsrc(1);
y0 = ROIsrc(2);
w0 = ROIsrc(3);
h0 = ROIsrc(4);

% get the edges of the source image and save the edge image
imEdge = edge(imSrc, 'canny');
[path, name, ext] = fileparts(srcName);
name = [name '_edge.jpg'];
name = fullfile(resultsDir, name);
imwrite(imEdge, name, 'jpg');
%figure, imshow(imEdge);


% check the boundary conditions
if(x0<=1 || y0<=1 || w0 >= imW || h0 >= imH)
    fprintf('Error definition of the ROI region!.\n');
end

% allocate sparse matrix
n = h0*w0;
M = spalloc(n, n, 5*n);

% get the B condition for equation M*X=B
B = zeros(1,n);

count = 1;
for y = 1: h0
    for x = 1:w0
        % index for the source ROI gradient column vector (1~n)
        i = (y-1)*w0+x;
        
        % check if it the boundary condition
        % check the top boundary condition
        if y~= 1
            M(count,i-w0) = -1;
        else
            B(count) = B(count)+ imDest(ROIsrc(2)+y-1, ROIsrc(1)+x);           
        end
        
        % check the bottom boundary condition
        if y~=h0
            M(count, i+w0) = -1;
        else
            B(count) = B(count) + imDest(ROIsrc(2)+y+1, ROIsrc(1)+x);
        end
        
        % check the left boundary condition
        if x~=1
            M(count, i-1) = -1;
        else
            B(count) = B(count) + imDest(ROIsrc(2)+y, ROIsrc(1)+x-1);
        end
        
        % check the right boundary condition
        if x~=w0
            M(count, i+1) = -1; 
        else
            B(count) = B(count) + imDest(ROIsrc(2)+y, ROIsrc(1)+x+1);
        end
        M(count, i) = 4; 
        
         % determine the location on the source image
         xs = x0+x-1;
         ys = y0+y-1;
         %*********************************************
         % check if an edge lies between p and q;
         %*********************************************
         % check the top edge
         if (imEdge(ys, xs) == 1 && imEdge(ys-1, xs) == 0 ||...
                 imEdge(ys-1, xs) == 1 && imEdge(ys, xs) == 0)
             vpq1 = imSrc(ys, xs) - imSrc(ys-1, xs);
         else
             vpq1 = 0;
         end
         
         % check the bottom edge
         if (imEdge(ys, xs) == 1 && imEdge(ys+1, xs) == 0 ||...
                 imEdge(ys+1, xs) == 1 && imEdge(ys, xs) == 0)
             vpq2 = imSrc(ys, xs) - imSrc(ys+1, xs);
         else
             vpq2 = 0;
         end
         
         % check the right edge
         if (imEdge(ys, xs) == 1 && imEdge(ys, xs+1) == 0 ||...
                 imEdge(ys, xs+1) == 1 && imEdge(ys, xs) == 0)
             vpq3 = imSrc(ys, xs) - imSrc(ys, xs+1);
         else
             vpq3 = 0;
         end
         
         % check the left edge
         if (imEdge(ys, xs) == 1 && imEdge(ys, xs-1) == 0 ||...
                 imEdge(ys, xs-1) == 1 && imEdge(ys, xs) == 0)
             vpq4 = imSrc(ys, xs) - imSrc(ys, xs-1);
         else
             vpq4 = 0;
         end
         
         
         v = vpq1+vpq2+vpq3+vpq4;
         B(count) = B(count) + v;
         count = count + 1;
    end
end
fDest = bicg(M, B', [], 300);
imROI = reshape(fDest, w0, h0);
imROI = imROI';

% paste the generated ROI to the destination image
imNew = imDest;
imNew(ROIsrc(2)+1:ROIsrc(2)+h0, ROIsrc(1)+1:ROIsrc(1)+w0) = imROI;


end


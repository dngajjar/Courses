function imNew = IlluminationChanges(imSrc,ROIsrc, alpha, beta, extra)
%% ILLUMINATIONCHANGES Function: correct an under-exposed object of ROI or 
%  reduce specular reflections
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

% check the boundary conditions
if(x0<=1 || y0<=1 || w0 >= imW || h0 >= imH)
    fprintf('Error definition of the ROI region!.\n');
end

% allocate sparse matrix
n = h0*w0;
M = spalloc(n, n, 5*n);

% get the B condition for equation M*X=B
B = zeros(1,n);
% compute the average gradient norm of the given ROI region
norm = GradientNorm(imSrc, ROIsrc);
alpha = alpha*norm;

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
         xs = x0+x;
         ys = y0+y;

         % define the guide domain
         pq1 = imSrc(ys, xs)-imSrc(ys-1, xs)+ extra;
         pq2 = imSrc(ys, xs)-imSrc(ys+1, xs)+ extra;
         pq3 = imSrc(ys, xs)-imSrc(ys, xs-1)+ extra;
         pq4 = imSrc(ys, xs)-imSrc(ys, xs+1)+ extra;
         
         vpq1 = alpha^beta*(abs(pq1))^(-beta)*pq1;
         vpq2 = alpha^beta*(abs(pq2))^(-beta)*pq2;
         vpq3 = alpha^beta*(abs(pq3))^(-beta)*pq3;
         vpq4 = alpha^beta*(abs(pq4))^(-beta)*pq4;
         
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


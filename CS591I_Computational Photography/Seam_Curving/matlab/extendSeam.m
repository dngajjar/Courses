function outImg = extendSeam(image, k, type, energyfunc)
%% Function extendSeam to enlarge an outImg by inserting k seams of the average value pixel
%  Input:
%       outImg: original outImg required to be enlarge
%       k: add k length to the vertial or horizontal direction
%       type: indicate the direction
%  Output: 
%       im: the modified outImg

% To find the seam vector
[seamVector, im_resize] = removalMap(image, k, type, energyfunc);

 im_mark = showSeam(image, seamVector, type);
 
 figure, imshow(im_mark); title('The detected seams');
   % sort the elements in each row of the seam vector from small to large
   sortVector = sort(seamVector, 2);

if size(size(image),2) == 3 %color outImg
   [imgH, imgw, imgD] = size(image); % get the size of the original outImg
   %[OimgH, Oimgw+k-1, OimgD] = size(outImg); % get the size of the output outImg
   %[VimH, VimW, VimD] = size(seamVector); % get the size of the determined seam vector
   
   if strcmp(type, 'vertical')
       % Resize the output outImg
        [vh, vw] = size(sortVector);
        d = zeros(vh, vw, 3);
        outImg = [image d]; %horizontal connection

        % vertical direction insertion
        for l = 1:k % for each columns in seam vector
            for i = 1: imgH % for the element in each column in seam vector
               num = sortVector(i, l);
                for j = imgw+l-1:-1:num
                   outImg(i, j+1, 1) = outImg(i, j, 1);
                   outImg(i, j+1, 2) = outImg(i, j, 2);
                   outImg(i, j+1, 3) = outImg(i, j, 3);
                end
            end
        end
   else
        % horizontal direction insertion
        % Resize the output outImg
        [vh, vw] = size(seamVector);
        d = zeros(vw, vh, 3);
        outImg = [image;d]; % vertical connection

         for l = 1:k % for each columns in seam vector
            for j = 1: imgw % for the element in each column in seam vector
               num = sortVector(j, l);
                for i = imgH+l-1:-1:num
                   outImg(i+1, j, 1) = outImg(i, j, 1);
                   outImg(i+1, j, 2) = outImg(i, j, 2);
                   outImg(i+1, j, 3) = outImg(i, j, 3);
                end
            end
        end
   end
else %gray outImg
    [imgH, imgw] = size(image); % get the size of the original outImg
    if strcmp(type, 'vertical')
        % Resize the output outImg
        [vh, vw] = size(sortVector);
        d = zeros(vh, vw);
        outImg = [image d]; %horizontal connection
        % vertical direction insertion
        for l = 1:k % for each columns in seam vector
            for i = 1: imgH % for the element in each column in seam vector
               num = seamVector(i, l);
                for j = imgw+l-1:-1:num
                   outImg(i, j+1) = outImg(i, j);
               end
            end
        end
   else
        % horizontal direction insertion

        % Resize the output outImg
        [vh, vw] = size(sortVector);
        d = zeros(vw, vh);
        outImg = [image;d]; % vertical connection
         for l = 1:k % for each columns in seam vector
            for j = 1: imgw% for the element in each column in seam vector
               num = seamVector(j, l);
                for i = imgH+l-1:-1:num
                   outImg(i+1, j) = outImg(i, j);
               end
            end
        end
   end
end
end


function im= removeSeam(image, seam, type)
%% Function removeSeam: resize the image by removing the seam in specific direction
%  Input:
%       image: the target image required to be modified
%       seam: the determined path with the current lowest energy
%       type: indicate the direction of the seam ('horizontal' or 'vertical')
%  Output:
%       im: the modified image without the seam


    im = image;
    [imgH, imgW, imgD] = size(image);
    % remove the vertical seam
    if strcmp(type, 'vertical')
        for i = 1: imgH %go through each element in seam vector
            for j = seam(i):(imgW-1) 
                 if size(size(im),2) == 2 %gray image  
                     im(i, j) = im(i, j+1);
                 else  %color image
                     im(i, j, 1) = im(i, j+1, 1);
                     im(i, j, 2) = im(i, j+1, 2);
                     im(i, j, 3) = im(i, j+1, 3);
                 end
            end
        end
        % delete the last column
        im(:, imgW, :) = [];
    % remove the horizontal seam
    elseif strcmp(type, 'horizontal')
        for j = 1: imgW %go through each element in seam vector
            for i = seam(j):(imgH-1) 
                 if size(size(im),2) == 2  % gray image 
                     im(i, j) = im(i+1, j);
                 else %color image
                     im(i, j, 1) = im(i+1, j, 1);
                     im(i, j, 2) = im(i+1, j, 2);
                     im(i, j, 3) = im(i+1, j, 3);
                 end
            end
        end
        % delete the last row
        im(imgH, :, :) = [];
    end


end


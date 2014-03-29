function [image] = showSeam(image, seam, type)
%%Function showSeam: to show the determined seam in the given color
% Input:
%   image: on which to draw the color lines representing the seams
%   seam: 1D matrix of storing the determined seams from the
%   findSeam_horizontal.m and the findSeam_vertical.m
%   type: indicate the seams' tye (horizontal or vertical)

[height, width] = size(seam);
Dim = size(image);
if strcmp(type, 'horizontal')
    % Draw the horizontal seams on the image
    for k=1:width
        for i=1:height
            if size(size(image),2) == 2 
                image(seam(i,k),i) = 0; % mark the seam in black color for gray image
            else
                image(seam(i, k), i, 1) = 0; % mark the seam in green color for color image
                image(seam(i, k), i, 2) = 255;
                image(seam(i, k), i, 3) = 0;   
            end
        end
    end
    
elseif strcmp(type, 'vertical')
    % Draw the vertical seam on the image
    for k=1:width
        for i=1:height
            if size(size(image),2) == 2 
                image(seam(i,k), i) = 0; % mark the seam in black color for gray image
            else
                image(i, seam(i, k), 1) = 0; % mark the seam in green color for color image
                image(i, seam(i, k), 2) = 255;
                image(i, seam(i, k), 3) = 0;
            end
        end
    end
end


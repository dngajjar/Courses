function region = GetROI(im)
%GETROI: to get the region of interest in square shape
% Input:
%    im: the original image to define the ROI
% Output:
%    region: vetor store the region of ROI [x,y,w,h]
%       (x,y) the left corner of the square, w is the width and h is the
%       height of the square

%% define the vectors to store the pairs of points
    region = zeros(1, 4);
    figure(1), hold off, imagesc(im), axis image, colormap gray;
    disp('Select 4 points in image to define the ROI');
    [x,y] = ginput(4);
    x_min = round(min(x));
    x_max = round(max(x));
    y_min = round(min(y));
    y_max = round(max(y));
    region(1) = x_min;
    region(2) = y_min;
    region(3) = x_max - x_min;
    region(4) = y_max - y_min;
end



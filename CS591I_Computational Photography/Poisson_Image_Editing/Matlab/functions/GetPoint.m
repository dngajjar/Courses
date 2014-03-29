function vector = GetPoint(im)
%GETPOINT: get the location (one point) to paste the ROI of source image

vector = zeros(1,2);

figure(1), hold off, imagesc(im), axis image, colormap gray;
disp('Select 1 points in image to define left corner location of the ROI');
[x,y] = ginput(1);
vector(1) = round(x);
vector(2) = round(y);
end


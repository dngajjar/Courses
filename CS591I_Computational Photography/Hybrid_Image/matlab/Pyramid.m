
function Pyramid(im12, num_levels)
% To generate the gaussian and laplacian pyramids
% Usage: <im12>: hybrid images; <num_levels>: number of levels in Gaussian
% and Laplacian Pyramid
%% Convert the type of the image
im12 = double(rgb2gray(im12));
ha = tight_subplot(2,num_levels,[0.001 0.001],[0.001 0.001],[0.001 0.001]);
sigma = 10;
hsize = 10;
% generate Gaussian Kernel
k = fspecial('gaussian', [hsize hsize], sigma);

% initial the first level of Gaussian Pyramid
gaussian = im12;

% generate num_levels Gaussian Pyramid and Laplacian Pyramid
for i = 1:num_levels
    % generate the title for each image
    name = num2str(i);
    name1 = [name, ' Level of Gaussian Pyramid'];
    name2 = [name, ' Level of Laplacian Pyramid'];
    
    % display (i)th level of Gaussian Pyramid 
    axes(ha(i));
    imagesc(gaussian);
    axis off
    axis image
    axis tight
    truesize
    colormap(gray)
    
    % get (i+1)th level of Gaussian Pyramid 
    gaussian_filtered = imfilter(gaussian, k, 'symmetric','same','conv');
   
    % get (i)th level of Laplacian Pyramid
    laplacian = gaussian - gaussian_filtered;
   
    
    % sub-sample the (i+1)the level of Gaussian Pyramid
    size_img = size(gaussian_filtered);
    gaussian_filtered = gaussian_filtered(1:2:size_img(1),1:2:size_img(2));
   
   % display (i)th level of Laplacian Pyramid
    axes(ha(num_levels+i));
    imagesc(laplacian);
    axis off
    axis image
    axis tight
    truesize
    colormap(gray)
    
    gaussian = gaussian_filtered;
end
end


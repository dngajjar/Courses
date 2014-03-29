function [im1_filtered,im2_filtered,im12]=hybridImage_combo_lowgray(im1,im2,cutoff_low,cutoff_high)
% Generate Hybrid Image(low-pass filtered image is gay; high-pass filtered image is color)
% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>, 
% <High-pass filter frequency>)
% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybrid
% image>]

close all; 
im1 = rgb2gray(im1); 

% align the two images (e.g., by the eyes) and crop them to be of same size
[im1, im2] = align_images(im1, im2);

% get the size of gaussian filters
[im1H,im1W] = size(im1);
[im2H,im2W] = size(im2);

% define gaussian filter
k1 = fspecial('gaussian', [50,50], cutoff_low);
k2 = fspecial('gaussian', [50,50], cutoff_high);

% apply gaussian filter (low-pass filter) to image1
im1_filtered= imfilter(im1, k1);

% apply high-pass filter to image2
for colorI = 1:3
    im2_tmp(:,:,colorI) = imfilter(im2(:,:,colorI), k2);
    im2_filtered(:,:,colorI) = im2(:,:,colorI) - im2_tmp(:,:,colorI);
end
im12(:,:,1) = im1_filtered + im2_filtered(:,:,1);
im12(:,:,2) = im1_filtered + im2_filtered(:,:,2);
im12(:,:,3) = im1_filtered + im2_filtered(:,:,3);
% save the images
imwrite(im1_filtered, 'im1_lowfrequency_gray.jpg');
imwrite(im2_filtered, 'im2_highfrequency_color.jpg');
imwrite(im12, 'hybridImage_lowgray.jpg');
end


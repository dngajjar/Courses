function [im1_filtered,im2_filtered,im12]=hybridImage_combo_highgray(im1,im2,cutoff_low,cutoff_high)
% Generate Hybrid Image(low-pass filtered image is color; high-pass filtered image is gray)
% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>, 
% <High-pass filter frequency>)
% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybrid
% image>]

close all; 
% convert image2 to gray-level
im2 = rgb2gray(im2); 

% align the two images (e.g., by the eyes) and crop them to be of same size
[im1, im2] = align_images(im1, im2);

% get the size of gaussian filters
[im1H,im1W] = size(im1);
[im2H,im2W] = size(im2);

% define gaussian filter
k1 = fspecial('gaussian', [50,50], cutoff_low);
k2 = fspecial('gaussian', [50,50], cutoff_high);

% apply gaussian filter (low-pass filter) to image2
im2_filtered= imfilter(im2, k2);
im2_filtered= im2-im2_filtered;
% apply high-pass filter to image2
for colorI = 1:3
    im1_filtered(:,:,colorI) = imfilter(im1(:,:,colorI), k1);
end
im12(:,:,1) = im2_filtered + im1_filtered(:,:,1);
im12(:,:,2) = im2_filtered + im1_filtered(:,:,2);
im12(:,:,3) = im2_filtered + im1_filtered(:,:,3);
% save the images
imwrite(im1_filtered, 'im1_lowfrequency_color.jpg');
imwrite(im2_filtered, 'im2_highfrequency_gray.jpg');
imwrite(im12, 'hybridImage_highgray.jpg');
end


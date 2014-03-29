function [im1_filtered, im2_filtered, im12] = hybridImage_gray(im1, im2, cutoff_low, cutoff_high)
% Generate Hybrid Image
% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>, 
% <High-pass filter frequency>)
close all; 

% convert to grayscale
im1 = rgb2gray(im1); 
im2 = rgb2gray(im2);

% align the two images (e.g., by the eyes) and crop them to be of same size
[im1, im2] = align_images(im1, im2);

% define the size of kernel
[img1H, img1W] = size(im1);
[img2H, img2W] = size(im2);

% define gaussian filter
k1 = fspecial('gaussian', [img1H, img1W], cutoff_low);
k2 = fspecial('gaussian', [img2H, img2W], cutoff_high);

% apply gaussian filter (low-pass filter) to image1
im1_filtered= imfilter(im1, k1);

% apply high-pass filter to image2
im2_ = imfilter(im2, k2);
im2_filtered = im2 - im2_;

% generate hybrid image
im12 = im1_filtered + im2_filtered;

% save the intermediate images
%imwrite(im1_filtered, 'images/im1_lowfrequency_gray.jpg');
%imwrite(im2_filtered, 'images/im2_highfrequency_gray.jpg');
%imwrite(im12, 'images/hybridImage_gray.jpg');

end


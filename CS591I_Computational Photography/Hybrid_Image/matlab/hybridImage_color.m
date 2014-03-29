function [im1_filtered,im2_filtered,im12]=hybridImage_color(im1,im2,cutoff_low,cutoff_high)
% Generate Hybrid Image
% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>, 
% <High-pass filter frequency>)
% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybrid
% image>]

close all; 

% align the two images (e.g., by the eyes) and crop them to be of same size
[im1, im2] = align_images(im1, im2);

% get the size of gaussian filters
ksize = 30;

% define gaussian filter
k1 = fspecial('gaussian', [ksize ksize], cutoff_low);
k2 = fspecial('gaussian', [ksize ksize], cutoff_high);

% generate hybrid image
for colorI = 1:3
    im1_filtered(:,:,colorI) = imfilter(im1(:,:,colorI), k1,'symmetric','same','conv');
    im2_tmp(:,:,colorI) = imfilter(im2(:,:,colorI), k2,'symmetric','same','conv');
    im2_filtered(:,:,colorI) = im2(:,:,colorI) - im2_tmp(:,:,colorI);
    im12(:,:,colorI) = im1_filtered(:,:,colorI) + im2_filtered(:,:,colorI);
end

figure, imshow(im1_filtered); title('Low-Pass Filtered Image');
figure, imshow(im2_filtered); title('High-Pass Filtered Image');
figure, imshow(im12); title('Hybrid Image');

% save the images
%imwrite(im1_filtered, 'images/im1_lowfrequency_color.jpg');
%imwrite(im2_filtered, 'imagesim2_highfrequency_color.jpg');
%imwrite(im12, 'images/hybridImage_color.jpg');
end


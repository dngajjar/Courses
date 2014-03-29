%% Get input images 
im1 = im2single(imread('images/im1.jpg'));
im2 = im2single(imread('images/im2.jpg'));

%% Generate the corresponding hybrid images
[im1_filtered,im2_filtered,im12] = hybridImage_color(im1, im2,10,10);


%% Crop resulting image (optional)
figure(1), hold off, imshow(im12), axis image, colormap gray
disp('input crop points');
[x, y] = ginput(2);  x = round(x); y = round(y);
im12 = im12(min(y):max(y), min(x):max(x), :);
figure(1), hold off, imshow(im12), axis image, colormap gray

%% Show images
figure, imshow(im1_filtered); title('Low-Pass Filtered Image');
figure, imshow(im2_filtered); title('High-Pass Filtered Image');
figure, imshow(im12); title('Hybrid Image');

%% Store the cropped image
imwrite(im12, 'CroppedHybridImage.jpg');

%% Employ frequency analysis
frequencyAnalysis(im1, im2, im1_filtered, im2_filtered, im12);

warning off all;
I = imread('images/butter.jpg');
figure, imshow(I);title('Original Image');
[imgH, imgW, imgD] = size(I);
%H = removalMap(rgb2gray(I)); %compute the horizontal seams
%show(I,H); %visualize results in interactive viewer
%% Get the energy function
im_size1 = I; %for resizing the image
im_mark1 = I; % for marking the seams in the image
energyfunc1 = @energyFunction1;
energyfunc2 = @energyFunction2;

%% Get horizontal/vertical seams and shink the image
%*************************************************************************%

type = 'horizontal';
[seamVector1, im_size1] = removalMap(im_size1, 100, type, energyfunc1);
figure, imshow(im_size1);

im_mark1 = showSeam(im_mark1, seamVector1, type);
figure, imshow(im_mark1);

im_size2 = I;
im_mark2 = I;
[seamVector2, im_size2] = removalMap(im_size2, 100, type, energyfunc2);
figure, imshow(im_size2);

% to draw each seam on the image
im_mark2 = showSeam(im_mark2, seamVector2, type);
figure, imshow(im_mark2);

% original image's information
fprintf('Original Image: 1. ');
fprintf('Height: %1.0f', size(I, 1));
fprintf('  2. Width: %1.0f\n', size(I,2));

% resized image's information
fprintf('Resized Image: 1. ');
fprintf('Height: %1.0f', size(im_size2, 1));
fprintf('  2. Width: %1.0f\n', size(im_size2,2));
%show(I, seamVector);



%% Enlarge an image by inserting seams with lowest energy
%*************************************************************************%
%{
type = 'vertical';
outImg1 = extendSeam(I, 50, type, energyfunc1);
figure, imshow(outImg1);

%}


%% Retargeting image with optimal seams-order
%*************************************************************************%

[value, im_size, M] = optimalDiagonal(I,100, 90, energyfunc2);

figure, imshow(im_size);
figure, imshow(M);
% original image's information
fprintf('Original Image: 1. ');
fprintf('Height: %1.0f', size(I, 1));
fprintf('  2. Width: %1.0f\n', size(I,2));

% resized image's information
fprintf('Resized Image: 1. ');
fprintf('Height: %1.0f', size(im_size, 1));
fprintf('  2. Width: %1.0f\n', size(im_size,2));


%% Object Removal
%*************************************************************************%
%{
im_size = objectRemoval(I, energyfunc1, 'vertical');
% original image's information
fprintf('Original Image: 1. ');
fprintf('Height: %1.0f', size(I, 1));
fprintf('  2. Width: %1.0f\n', size(I,2));

% resized image's information
fprintf('Resized Image: 1. ');
fprintf('Height: %1.0f', size(im_size, 1));
fprintf('  2. Width: %1.0f\n', size(im_size,2));
%}

clear
clc
addpath('functions');

%% ************************************************************************
% Seamless Tiling
% *************************************************************************

dataDir9 = './Input Images/Seamless Tiling/Source Images';
resultDir9 = './Input Images/Seamless Tiling/Results';
mkdir(resultDir9);

srcName = fullfile(dataDir9, 'src1.jpg');
imSrc = imread(srcName);

% decompose the image into RGB channels
[imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

% get the border conditions
imBR = BorderManipulation(imSrcR);
imBG = BorderManipulation(imSrcG);
imBB = BorderManipulation(imSrcB);

% conduct the seamless tiling
imR = SeamlessTiling(imSrcR, imBR);
imG = SeamlessTiling(imSrcG, imBG);
imB = SeamlessTiling(imSrcB, imBB);
imNew = composeRGB(imR, imG, imB);

% show and save the generated single image
figure, imshow(uint8(imNew));
title('Generated Single with Border Manipulation.');
[path, name, ext] = fileparts(srcName);
name1 = [name '_SeamlessTiling_single.jpg'];
name1 = fullfile(resultDir9, name1);
imwrite(uint8(imNew), name1, 'jpg');

nheight = 2;
nwidth = 3;

imTiling_old = zeros(nheight*size(imSrc, 1), nwidth*size(imSrc, 2), 3);
imTiling_new = imTiling_old;

for i=1:nheight
    for j=1:nwidth
        x0 = (j-1)*size(imSrc, 2)+1;
        x1 = j*size(imSrc, 2);
        y0 = (i-1)*size(imSrc, 1)+1;
        y1 = i*size(imSrc, 1);
        
        imTiling_old(y0:y1, x0:x1, :) = imSrc;
        imTiling_new(y0:y1, x0:x1, :) = imNew;
    end
end

figure, imshow(uint8(imTiling_old)); title('Simple Combile Images');
figure, imshow(uint8(imTiling_new)); title('Seamless Tiling Images');
name2 = fullfile(resultDir9, [name '_SeamlessTiling.jpg']);
name3 = fullfile(resultDir9, [name '_SimpleCombining.jpg']);
imwrite(uint8(imTiling_old), name3, 'jpg');
imwrite(uint8(imTiling_new), name2, 'jpg');
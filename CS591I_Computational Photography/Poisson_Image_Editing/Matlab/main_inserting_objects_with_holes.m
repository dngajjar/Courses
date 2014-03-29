clear
clc
addpath('functions');

%% ************************************************************************
% Mix Gradient - insert objects with holes
% *************************************************************************
dataDir3 = './Input Images/Inserting Objects with Holes/Source Images';
destinationDir3 = './Input Images/Inserting Objects with Holes/Destination Images';
resultDir3 = './Input Images/Inserting Objects with Holes/Results';
mkdir(resultDir3);

destName = fullfile(destinationDir3, 'dest1.jpg');
srcName = fullfile(dataDir3, 'src1.jpg');
imSrc = imread(srcName);
imDest = imread(destName);

% decompose the image into RGB channels
[imDestR imDestG imDestB] = decomposeRGB(double(imDest));
[imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

% get the ROI from the source image 
ROIsrc = GetROI(imSrc);
% get the point for the destination image to paste the ROI
ROIdest = GetPoint(imDest);

imTemp = imDest;
imTemp(ROIdest(2):ROIdest(2)+ROIsrc(4),ROIdest(1):ROIdest(1)+ROIsrc(3),:) = imSrc(ROIsrc(2):ROIsrc(2)+ROIsrc(4),ROIsrc(1):ROIsrc(1)+ROIsrc(3),:);
figure, imshow(imTemp);title('Simple Cuting and Pasting.');

% get the seamless cloning for each channel
[imROIR, imR] = MixGradient(imSrcR, imDestR, ROIsrc, ROIdest);
[imROIG, imG] = MixGradient(imSrcG, imDestG, ROIsrc, ROIdest);
[imROIB, imB] = MixGradient(imSrcB, imDestB, ROIsrc, ROIdest);

% compose the new image
imNew = composeRGB(imR, imG, imB);
figure, imshow(uint8(imNew));title('Mixing Gradient.');
[pathS, nameS, ~] = fileparts(srcName);
[pahtD, nameD, ~] = fileparts(destName);
outName = fullfile(resultDir3, ['InsertHoleObject_Src_' nameS '_Dest_' nameD '_.jpg']);
imwrite(uint8(imNew), outName, 'jpg');
%{
imnew = imDest;
imnew(ROIdest(2)+1:ROIdest(2)+ROIsrc(4), ROIdest(1)+1:ROIdest(1)+ROIsrc(3), :) = imROI(:,:,:);
figure, imshow(uint8(imnew));

%}
clear
clc
addpath('functions');
%% ************************************************************************
% seamless cloning -- square
% *************************************************************************

dataDir1 = './Input Images/Seamless Cloning/Source Images';
destinationDir1 = './Input Images/Seamless Cloning/Destination Images';
resultDir1 = './Input Images/Seamless Cloning/Results';
mkdir(resultDir1);

destName = fullfile(destinationDir1, 'dest1.jpg');
srcName = fullfile(dataDir1, 'src1.jpg');
imSrc = imread(srcName);
imDest = imread(destName);
% decompose the image into RGB channels
[imDestR imDestG imDestB] = decomposeRGB(imDest);
[imSrcR imSrcG imSrcB] = decomposeRGB(imSrc);

% get the ROI from the source image 
ROIsrc = GetROI(imSrc);
% get the point for the destination image to paste the ROI
ROIdest = GetPoint(imDest);

imTemp = imDest;
imTemp(ROIdest(2):ROIdest(2)+ROIsrc(4),ROIdest(1):ROIdest(1)+ROIsrc(3),:) = imSrc(ROIsrc(2):ROIsrc(2)+ROIsrc(4),ROIsrc(1):ROIsrc(1)+ROIsrc(3),:);
figure, imshow(imTemp);title('Simple Cuting and Pasting Image Result');

% get the seamless cloning for each channel
imNewR = SeamlessCloning(imSrcR, imDestR, ROIsrc, ROIdest);
imNewG = SeamlessCloning(imSrcG, imDestG, ROIsrc, ROIdest);
imNewB = SeamlessCloning(imSrcB, imDestB, ROIsrc, ROIdest);

% compose the new image
imNew = composeRGB(imNewR, imNewG, imNewB);

figure, imshow(uint8(imNew));title('The Seamless Cloning Result');
[pathS, nameS, ~] = fileparts(srcName);
[pahtD, nameD, ~] = fileparts(destName);
outName = fullfile(resultDir1, ['SeamlessCloning_Src_' nameS '_Dest_' nameD '_.jpg']);
imwrite(uint8(imNew), outName, 'jpg');


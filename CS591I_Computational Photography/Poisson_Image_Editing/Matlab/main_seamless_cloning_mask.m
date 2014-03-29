clear
clc
addpath('functions');
%% ************************************************************************
% seamless cloning -- mask
% *************************************************************************

dataDir2 = './Input Images/Seamless Cloning with Mask/Source Images';
destDir2 = './Input Images/Seamless Cloning with Mask/Destination Images';
resultDir2 = './Input Images/Seamless Cloning with Mask/Results';
mkdir(resultDir2);

destName = fullfile(destDir2, 'dest1.jpg');
srcName = fullfile(dataDir2, 'src1.jpg');
[path, name, ext] = fileparts(srcName);
maskName = fullfile(dataDir2, [name '_mask.jpg']);

imDest = imread(destName);
imSrc = imread(srcName);
imMask = imread(maskName);
imMask = colorToBinary(imMask,10);

% decompose the image into RGB channels
[imDestR imDestG imDestB] = decomposeRGB(imDest);
[imSrcR imSrcG imSrcB] = decomposeRGB(imSrc);

vecSrc = GetPoint(imMask);
vecDest = GetPoint(imDest);

offset = zeros(1,2);
offset(1) = vecSrc(1) - vecDest(1);
offset(2) = vecSrc(2) - vecDest(2);

imNewR = SeamlessCloning_mask(imSrcR, imDestR, imMask, offset);
imNewG = SeamlessCloning_mask(imSrcG, imDestG, imMask, offset);
imNewB = SeamlessCloning_mask(imSrcB, imDestB, imMask, offset);

imNew= composeRGB(imNewR, imNewG, imNewB);
imTemp = imDest;
for y = 1:size(imSrc, 1)
    for x = 1:size(imSrc, 2)
        if imMask(y, x) ~= 0
            yDest = y - offset(2);
            xDest = x - offset(1);
            imTemp(yDest, xDest,:) = imSrc(y, x,:);
        end
    end
end
figure, imshow(imTemp);title('Simple Cuting and Pating Image Result');
figure,imshow(uint8(imNew));title('Seamless Cloning with Mask Result');
[pathS, nameS, ~] = fileparts(srcName);
[pahtD, nameD, ~] = fileparts(destName);
outName = fullfile(resultDir2, ['SeamlessCloningMask_Src_' nameS '_Dest_' nameD '_.jpg']);
imwrite(uint8(imNew), outName, 'jpg');

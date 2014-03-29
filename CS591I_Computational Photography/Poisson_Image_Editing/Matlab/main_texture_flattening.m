clear
clc
addpath('functions');

%% ************************************************************************
% Selection Editing
% *************************************************************************

dataDir5 = './Input Images/Texture Flattening/Source Images';
resultDir5 = './Input Images/Texture Flattening/Results';
mkdir(resultDir5);

srcName = fullfile(dataDir5, 'src1.jpg');
imSrc = imread(srcName);
% decompose the image into RGB channels
[imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

% get the ROI from the source image 
ROIsrc = GetROI(imSrc);

% get the seamless cloning for each channel
imR = TextureFlattening(imSrcR, srcName,resultDir5, ROIsrc);
imG = TextureFlattening(imSrcG, srcName,resultDir5, ROIsrc);
imB = TextureFlattening(imSrcB, srcName,resultDir5, ROIsrc);

% compose the new image
imNew = composeRGB(imR, imG, imB);
figure, imshow(uint8(imNew));title('Texture Flattened Image');
[path, name, ext] = fileparts(srcName);

% save the labeled ROI image
imLabel = imSrc;
figure, imshow(imLabel);title('Original Image with Labeled Target Area');
hold on;
plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)],'r-');
plot([ROIsrc(1);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2)+ROIsrc(4);ROIsrc(2)+ROIsrc(4)],'r-');
plot([ROIsrc(1);ROIsrc(1)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
plot([ROIsrc(1)+ROIsrc(3);ROIsrc(1)+ROIsrc(3)],[ROIsrc(2);ROIsrc(2)+ROIsrc(4)],'r-');
name0 = [name '_labeledROI.jpg'];
name0 = fullfile(resultDir5, name0);
saveas(gcf,name0,'jpg');

name1 = [name '_flattening.jpg'];
name1 = fullfile(resultDir5, name1);
imwrite(uint8(imNew), name1, 'jpg');


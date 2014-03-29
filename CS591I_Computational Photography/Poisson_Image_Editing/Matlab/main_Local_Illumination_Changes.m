clear
clc
addpath('functions');


%% ************************************************************************
% Local illumination changes
% *************************************************************************
dataDir7 = './Input Images/Local Illumination Changes/Source Images';
resultDir7 = './Input Images/Local Illumination Changes/Results';
mkdir(resultDir7);

srcName = fullfile(dataDir7, 'src1.jpg');
imSrc = imread(srcName);
% decompose the image into RGB channels
[imSrcR imSrcG imSrcB] = decomposeRGB(double(imSrc));

% get the ROI from the source image 
ROIsrc = GetROI(imSrc);
alpha = 0.2;
beta =  0.4;
extra = 0.0001;
imR = IlluminationChanges(imSrcR, ROIsrc, alpha, beta, extra);
imG = IlluminationChanges(imSrcG, ROIsrc, alpha, beta, extra);
imB = IlluminationChanges(imSrcB, ROIsrc, alpha, beta, extra);

% compose the new image
imNew = composeRGB(imR, imG, imB);
figure, imshow(uint8(imNew));title('Illumination Changed Image');
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
name0 = fullfile(resultDir7, name0);
saveas(gcf,name0,'jpg');

name1 = [name '_IlluminationChanges_alpha_' num2str(alpha) '_beta_' num2str(beta) '.jpg'];
name1 = fullfile(resultDir7, name1);
imwrite(uint8(imNew), name1, 'jpg');
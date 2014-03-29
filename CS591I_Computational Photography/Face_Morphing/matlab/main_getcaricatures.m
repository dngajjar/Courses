dataDir = './images/group7/originalImgs';
resultsDir = './images/group7/results';
txtDir = './images/group7/txt';
mkdir(resultsDir);

%% set the parameters
numImgs = 17;
numImgs_F=4;
numImgs_M=13;
numPoints = 43;

%% get the pairs of corresponding points on two images

[~, meanvec] = getPoints_txt(dataDir, txtDir, numPoints, numImgs,resultsDir);
for j = 1:17
%j = 16;
% read image
name = [num2str(j) '.txt'];
fullname = fullfile(txtDir, name);
vec = load(fullname, '-ascii');
tri = getTriangulations(meanvec, vec, dataDir, resultsDir);

% difference
m = vec - meanvec;
name = [num2str(j) '.jpg'];
fullName = fullfile(dataDir, name);
im = imread(fullName);
tmp = meanvec;
morphedImg = morph(im, vec, tri,tmp);
figure, imshow(morphedImg);

name = [num2str(j) '_average.jpg'];
fullName = fullfile(resultsDir, name);
imwrite(morphedImg, fullName);
end
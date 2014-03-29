dataDir = './images/group5/originalImgs';
resultsDir = './images/group5/results';

mkdir(resultsDir);

%% read input images

inFile1 = fullfile(dataDir,'1.jpg');
inFile2 = fullfile(dataDir, '4.jpg');
image1 = imread(inFile1);
image2 = imread(inFile2);

%% get the pairs of corresponding points on two images
%{
[vec1, vec2, meanvec] = getPoints_2images(image1, image2, 43, resultsDir);
tri = getTriangulation(meanvec, vec1, vec2, image1, image2, resultsDir);
process(image1, image2, vec1, vec2, tri,1, resultsDir);

%im = addMorphedImg(image1, image2, vec1, vec2, tri,0.5, 0.5);

%imshow(im);

%}

getCaricatures(image1, image2, resultsDir,70);
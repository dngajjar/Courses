dataDir = './images/group4/originalImgs';
resultsDir = './images/group4/results';
txtDir = './images/group4/txt';
mkdir(resultsDir);

%% set the parameters
numImgs = 17;
numImgs_F=4;
numImgs_M=13;
numPoints = 43;

%% get the pairs of corresponding points on two images
%[vec, meanvec] = getPoints_nimages(dataDir,numImgs, numPoints, resultsDir);
[vec, meanvec] = getPoints_txt(dataDir, txtDir, numPoints, numImgs,resultsDir);

tri = getTriangulations(meanvec, vec, dataDir, resultsDir);
%meanImg = getMeanFace(dataDir, resultsDir, numImgs, vec, tri);
meanImg = getMeanFace_weighted(dataDir, resultsDir, numImgs_F, numImgs_M, vec, tri);
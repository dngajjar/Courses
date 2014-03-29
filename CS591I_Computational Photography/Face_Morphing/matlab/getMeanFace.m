function meanImg = getMeanFace(dataDir, resultsDir, numImgs, vec, tri)
%GETMEANFACE: to generate the mean face based on all the input images



warp_frac = 1/numImgs;
dissolve_frac = 1/numImgs;
temp = zeros(size(vec, 1), 2);
temp(:, 1) = sum(vec(:, 1, :), 3).*warp_frac;
temp(:, 2) = sum(vec(:, 2, :), 3).*warp_frac;
% get the first image
name = [num2str(1) '.jpg'];
fullName = fullfile(dataDir, name);
im = imread(fullName);
morphedImg=repmat(im, [1 1 1 numImgs]);
meanImg = im;
for i = 1:numImgs
    name = [num2str(i) '.jpg'];
    fullName = fullfile(dataDir, name);
    im = imread(fullName);
    morphedImg(:,:,:,i) = morph(im, vec(:,:,i), tri,temp);
    %figure, imshow(morphedImg(:,:,:,i));
end
meanImg(:,:,1) = sum(morphedImg(:,:,1,:), 4).*dissolve_frac;
meanImg(:,:,2) = sum(morphedImg(:,:,2,:), 4).*dissolve_frac;
meanImg(:,:,3) = sum(morphedImg(:,:,3,:), 4).*dissolve_frac;
resultsDir = [resultsDir '/meanface.jpg'];
figure, imshow(meanImg);
imwrite(meanImg, resultsDir, 'jpg');
end


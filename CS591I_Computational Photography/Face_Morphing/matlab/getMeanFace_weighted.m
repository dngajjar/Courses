function meanImg = getMeanFace_weighted(dataDir, resultsDir, numImgs_F, numImgs_M, vec, tri)
%GETMEANFACE: to generate the mean face based on all the input images


numImgs = numImgs_F+numImgs_M;
warp_frac_f = 1/numImgs_F*0.0;
warp_frac_m = 1/numImgs_M*1;
dissolve_frac_f = 1/numImgs_F*0.0;
dissolve_frac_m = 1/numImgs_M*1;
temp = zeros(size(vec, 1), 2);
temp(:,1) = sum(vec(:, 1, :), 3)-vec(:,1,1)-vec(:,1,10)-vec(:,1,14)-vec(:,1,16);
temp(:,1) = temp(:,1).*warp_frac_m;
temp(:,1) = temp(:,1)+(vec(:,1,1)+vec(:,1,10)+vec(:,1,14)+vec(:,1,16)).*warp_frac_f;
temp(:,2) = sum(vec(:, 2, :), 3)-vec(:,2,1)-vec(:,2,10)-vec(:,2,14)-vec(:,2,16);
temp(:,2) = temp(:,2).*warp_frac_m;
temp(:,2) = temp(:,2)+(vec(:,2,1)+vec(:,2,10)+vec(:,2,14)+vec(:,2,16)).*warp_frac_f;
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
    if i==1||i==10||i==14||i==16
         morphedImg(:,:,:,i) =  morphedImg(:,:,:,i).*dissolve_frac_f;
    else
         morphedImg(:,:,:,i) =  morphedImg(:,:,:,i).*dissolve_frac_m;
    end
    %figure, imshow(morphedImg(:,:,:,i));
end
meanImg(:,:,1) = sum(morphedImg(:,:,1,:), 4);
meanImg(:,:,2) = sum(morphedImg(:,:,2,:), 4);
meanImg(:,:,3) = sum(morphedImg(:,:,3,:), 4);

resultsDir = [resultsDir '/meanface.jpg'];
figure, imshow(meanImg);
imwrite(meanImg, resultsDir, 'jpg');
end



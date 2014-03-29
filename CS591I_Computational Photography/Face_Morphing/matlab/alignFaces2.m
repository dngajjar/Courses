function alignFaces2(dataDir,txtDir, num_Imgs,numPoints)
%ALIGNFACES Summary of this function goes here
%   Detailed explanation goes here
name1 = [dataDir '\1.jpg'];
im1 = imread(name1);
resultsDir = './images/group6/alignImgs2';
mkdir(resultsDir);

vec = zeros(numPoints, 2, num_Imgs);

  
        for j = 1: num_Imgs
            % read image
            name = [num2str(j) '.txt'];
            fullname = fullfile(txtDir, name);
            vec(:,:,j) = load(fullname, '-ascii');
        end
        meanvec(:, 1) = sum(vec(:, 1, :), 3)/num_Imgs;
        meanvec(:, 2) = sum(vec(:, 2, :), 3)/num_Imgs;

Base = [meanvec(:,1)';meanvec(:,2)';ones(1, numPoints)];
A = zeros(3,3,num_Imgs-1);
for l = 1:num_Imgs
    name = [dataDir '\' num2str(l) '.jpg'];
    im = imread(name);


    Curr = [vec(:,1,l)';vec(:,2,l)';ones(1, numPoints)];
    A(:,:,l) = Base/Curr;

    [imH, imW, ~] = size(im1);
    X0 = zeros(imH*imW, 1);
    Y0 = X0;
    for i = 1:imH
        for j = 1:imW
            X0((i-1)*imW+j) = j;
            Y0((i-1)*imW+j) = i;
        end
    end
    X1 = X0;
    Y1 = Y0;
    % compute the corresponding points in original image
    for i = 1:size(X0,1)

      B = inv(A(:,:,l));
      X0(i) = B(1,:)*[X1(i);Y1(i);1];
      Y0(i) = B(2,:)*[X1(i);Y1(i);1];            

    end


X0 = reshape(X0,imW, imH); X0 = X0';
Y0 = reshape(Y0,imW, imH); Y0 = Y0';
tmp = im1;
% generate the morphed image 1
tmp(:,:,1) = interp2(double(im(:,:,1)),X0,Y0,'nearest');
tmp(:,:,2) = interp2(double(im(:,:,2)),X0,Y0,'nearest');
tmp(:,:,3) = interp2(double(im(:,:,3)),X0,Y0,'nearest');
name = [resultsDir '\' num2str(l) '.jpg'];
imwrite(tmp, name);
end
figure,imshow(tmp);
end



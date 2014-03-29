function [vec, meanvec] = getPoints_nimages(dataDir, numImg, numPoints, resultsDir)

%%GETPOINTS_nimages: to get the corresponding points on the n images by
%   picking out the feature points on each image
% Input: 
%   dataDir: original images' reading path
%   numImg: number of images to import
%   numImg: 
% Output:
%   vec1,vec2: stores the locations for the corresponding points in each
%   input image
    
    % define the vectors to store the pairs of points
    vec = zeros(numPoints, 2, numImg);
    meanvec = zeros(numPoints, 2); % vector for the average position 
    
    % get copies of the original input images

    disp('Select points from each image define the pair of corresonding points')
    for i = 1:numPoints
        for j = 1: numImg
            % read image
            name = [num2str(j) '.jpg'];
            fullname = fullfile(dataDir, name);
            im = imread(fullname);
            % displays image1
            figure(1), hold off, imagesc(im), axis image, colormap gray
            % gets points from the user on image1
            [vec(i, 1, j), vec(i, 2, j)] = ginput(1);
        end
        meanvec(i, 1) = sum(vec(i, 1, :))/numImg;
        meanvec(i, 2) = sum(vec(i, 2, :))/numImg;
    end
    % display and save the labeled images
    resultsDir = [resultsDir '\labels'];
    mkdir(resultsDir);
    for i = 1: numImg
        % read image
        name = [num2str(i) '.jpg'];
        fullname = fullfile(dataDir, name);
        im = imread(fullname);
        figure, imshow(im,[]); hold on; plot(round(vec(:,1,i)), round(vec(:,2,i)), 'r+');
        
        name = fullfile(resultsDir, ['im' num2str(i) '_label.jpg']);
        print(gcf,'-djpeg',name);
    end
    
end


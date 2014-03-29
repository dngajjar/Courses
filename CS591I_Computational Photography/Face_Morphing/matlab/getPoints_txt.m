function [vec, meanvec] = getPoints_txt(dataDir, txtDir, numPoints, numImg,resultsDir)
%GETPOINTS_TXT Summary of this function goes here
%   Detailed explanation goes here

    % define the vectors to store the pairs of points
    vec = zeros(numPoints, 2, numImg);
    meanvec = zeros(numPoints, 2); % vector for the average position 
    
  
        for j = 1: numImg
            % read image
            name = [num2str(j) '.txt'];
            fullname = fullfile(txtDir, name);
            vec(:,:,j) = load(fullname, '-ascii');
        end
        meanvec(:, 1) = sum(vec(:, 1, :), 3)/numImg;
        meanvec(:, 2) = sum(vec(:, 2, :), 3)/numImg;

    % display and save the labeled images
    %{
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
    %}
end


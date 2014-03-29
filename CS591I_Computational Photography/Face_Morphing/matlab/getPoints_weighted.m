function [vec, meanvec] = getPoints_weighted(dataDir, txtDir, numPoints, numImg,resultsDir)
% getPoints_weighted: get the equally averaged female and male face


    % define the vectors to store the pairs of points
    vec = zeros(numPoints, 2, numImg);
    meanvec = zeros(numPoints, 2); % vector for the average position 
    
  
        for j = 1: numImg
            % read image
            name = [num2str(j) '.txt'];
            fullname = fullfile(txtDir, name);
            vec(:,:,j) = load(fullname, '-ascii');
        end
        % sum the male' points
        meanvec(:, 1) = sum(vec(:, 1, :), 3)-vec(:, 1, 1)-vec(:, 1, 10)-vec(:, 1, 14)-vec(:, 1, 16);
        meanvec(:, 1) = meanvec(:, 1)./(13);
        meanvec(:, 2) = sum(vec(:, 2, :), 3)-vec(:, 2, 1)-vec(:, 2, 10)-vec(:, 2, 14)-vec(:, 2, 16);
        meanvec(:, 2) = meanvec(:, 2)./(13);
        % sum the males' points and average
        meanvec(:, 1) = meanvec(:, 1)+(vec(:, 1, 1)+vec(:, 1, 10)+vec(:, 1, 14)+vec(:, 1, 16))./4;
        meanvec(:, 1) = meanvec(:, 1)./2;
        
        meanvec(:, 2) = meanvec(:, 2)+(vec(:, 2, 1)+vec(:, 2, 10)+vec(:, 2, 14)+vec(:, 2, 16))./4;
        meanvec(:, 2) = meanvec(:, 2)./2;
        
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



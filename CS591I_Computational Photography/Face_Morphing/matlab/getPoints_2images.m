function [vec1, vec2, meanvec] = getPoints_2images(im1, im2, n, resultsDir)

%%GETPOINTS: to get the pairs of corresponding points on the two images by hand
% Input: 
%   im1, im2: original images to figure out the corresponding points
%   n: number of pairs of corresponding points on two target images
% Output:
%   vec1,vec2: stores the locations for the corresponding points in each
%   input image
    
    % define the vectors to store the pairs of points
    vec1 = zeros(n, 2);     % vector for points' position on image1
    vec2 = zeros(n, 2);     % vector for points' position on image2
    meanvec = zeros(n, 2); % vector for the average position 
    
    % get copies of the original input images
    im1_pts = im1;
    im2_pts = im2;
    disp('Select points from each image define the pair of corresonding points')
    for i = 1:n
        % displays image1
        figure(1), hold off, imagesc(im1), axis image, colormap gray
        % gets points from the user on image1
        [vec1(i, 1), vec1(i, 2)] = ginput(1);
        
        % dsplay2 image2
        figure(1), hold off, imagesc(im2), axis image, colormap gray
        % gets points from the user on image2
        [vec2(i, 1), vec2(i, 2)] = ginput(1);
        % gets the mean pixel values
        meanvec(:,1) = (vec1(:, 1)+ vec2(:, 1))./2;
        meanvec(:,2) = (vec1(:, 2)+ vec2(:, 2))./2;
    end
    % display the labeled images
    figure, imshow(im1_pts,[]); hold on; plot(round(vec1(:,1)), round(vec1(:,2)), 'r+');
    name1 = fullfile(resultsDir, 'im1_label.jpg');
    print(gcf,'-djpeg',name1);
    figure, imshow(im2_pts,[]); hold on; plot(round(vec2(:,1)), round(vec2(:,2)), 'r+');
    name2 = fullfile(resultsDir, 'im2_label.jpg');
    print(gcf,'-djpeg',name2);
    
end


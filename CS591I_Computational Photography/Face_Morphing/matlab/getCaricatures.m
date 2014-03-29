function getCaricatures(im1, im2, resultsDir, numPoints)
%GETCARICATURES Summary of this function goes here
%   Detailed explanation goes here
   
    n = numPoints;
    vec1 = zeros(n, 2);     % vector for points' position on image1
    vec2 = zeros(n, 2);     % vector for points' position on image1
    disp('Select points from each image define the pair of corresonding points')
    for i = 1:n
        % displays image1
        figure(1), hold off, imagesc(im1), axis image, colormap gray
        % gets points from the user on image1
        [vec1(i, 1), vec1(i, 2)] = ginput(1);
        
        % displays image1
        figure(1), hold off, imagesc(im2), axis image, colormap gray
        % gets points from the user on image1
        [vec2(i, 1), vec2(i, 2)] = ginput(1);
       
    end
    % display the labeled images
    figure, imshow(im1,[]); hold on; plot(round(vec1(:,1)), round(vec1(:,2)), 'r+');
    name1 = fullfile(resultsDir, 'im1_label.jpg');
    print(gcf,'-djpeg',name1);
    % display the labeled images
    figure, imshow(im2,[]); hold on; plot(round(vec2(:,1)), round(vec2(:,2)), 'r+');
    name2 = fullfile(resultsDir, 'im2_label.jpg');
    print(gcf,'-djpeg',name2);
    
    % get triangulation for the target image
    tri = getTriangulation(vec2, vec1, vec2, im1, im2, resultsDir);
    morphedIm1= morph(im1, vec1, tri,vec2);
    figure,imshow(morphedIm1);
    resultsDir = [resultsDir 'caricature.jpg'];
    imwrite(morphedIm1, resultsDir);
end


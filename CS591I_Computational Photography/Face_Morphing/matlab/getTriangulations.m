function tri = getTriangulations(meanvec, vec, dataDir, resultsDir)
%% GETTRIANGULATIONS: get the triangulation based on the input vector of
%points
%  Input:
%    meanvec: the n by 2 vector that contains the (x,y) position for each
%    points
%  Output:
%    tri: the output triangulation structure

    tri = delaunay(meanvec(:,1), meanvec(:,2)); 
    n = size(tri, 1); % get the number of computed triangulations
    % create the file to store the generated triangulation images
    resultsDir = [resultsDir '\triangulations'];
    mkdir(resultsDir);
    % display each image's original delaunay triangulation
    for i = 1: size(vec,3)
        name = [num2str(i) '.jpg'];
        fullName = fullfile(dataDir, name);
        im = imread(fullName);
        figure, imshow(im,[]);
        hold on;
        for j = 1:n
            a = tri(j, 1);
            b = tri(j, 2);
            c = tri(j, 3);   
            x1 = round(vec(a, 1, i));    y1 = round(vec(a, 2, i)); 
            x2 = round(vec(b, 1, i));    y2 = round(vec(b, 2, i)); 
            x3 = round(vec(c, 1, i));    y3 = round(vec(c, 2, i)); 
            %plot([x1,x2],[y1,y2], 'r-');
            %plot([x1,x3],[y1,y3], 'r-');
            %plot([x2,x3],[y2,y3], 'r-');
        end
        %{
        plot(round(vec(:,1, i)), round(vec(:,2, i)), 'r*','linewidth',2);
        % save labeled image1
        name = fullfile(resultsDir, ['im' num2str(i) '_triangulation.jpg']);
        print(gcf,'-djpeg',name);
        %}
    end
end


function tri = getTriangulation(meanvec, vec1, vec2, im1, im2, resultsDir)
%% GETTRIANGULATION: get the triangulation based on the input vector of
%points
%  Input:
%    meanvec: the n by 2 vector that contains the (x,y) position for each
%    points
%  Output:
%    tri: the output triangulation structure

tri = delaunay(meanvec(:,1), meanvec(:,2)); 
n = size(tri, 1); % get the number of computed triangulations

% draw the computed triangulation on image1 
figure,imshow(im1,[]);   
hold on;
for i = 1:n
    a = tri(i, 1);
    b = tri(i, 2);
    c = tri(i, 3);   
    x1 = round(vec1(a, 1));    y1 = round(vec1(a, 2)); 
    x2 = round(vec1(b, 1));    y2 = round(vec1(b, 2)); 
    x3 = round(vec1(c, 1));    y3 = round(vec1(c, 2)); 
    plot([x1,x2],[y1,y2], 'r-');
    plot([x1,x3],[y1,y3], 'r-');
    plot([x2,x3],[y2,y3], 'r-');
end
    plot(round(vec1(:,1)), round(vec1(:,2)), 'r*','linewidth',2);
    % save labeled image1
    name1 = fullfile(resultsDir, 'im1_triangulation.jpg');
    print(gcf,'-djpeg',name1);
    
    % draw the computed triangulation on image2 
figure,imshow(im2,[]);   
hold on;
for i = 1:n
    a = tri(i, 1);
    b = tri(i, 2);
    c = tri(i, 3);   
    x1 = round(vec2(a, 1));    y1 = round(vec2(a, 2)); 
    x2 = round(vec2(b, 1));    y2 = round(vec2(b, 2)); 
    x3 = round(vec2(c, 1));    y3 = round(vec2(c, 2)); 
    plot([x1,x2],[y1,y2], 'r-');
    plot([x1,x3],[y1,y3], 'r-');
    plot([x2,x3],[y2,y3], 'r-');
end
    plot(round(vec2(:,1)), round(vec2(:,2)), 'r*','linewidth',2);
    % save labeled image2
    name2 = fullfile(resultsDir, 'im2_triangulation.jpg');
    print(gcf,'-djpeg',name2);
end


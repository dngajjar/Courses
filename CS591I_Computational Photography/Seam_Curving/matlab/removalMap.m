function [seamVector,im_resize] = removalMap(image, k, type, energyFunction)
%%Function removalMap: to get a seam matrix storing the k seams of
%%indicated type (horizon or vertical)

[imgH, imgW, imgD] = size(image); 

im_resize = image; % image for resizing the seams
im_mark = image;   % image for marking the seams

if strcmp(type, 'vertical')
    seamVector = zeros(imgH, min(k, imgW-1));
    seamValueVector = zeros(imgH, min(k, imgW-1));
    n = 2;
    for i = 1:min(k, imgW-1) % make sure that keep a column of pixels at least
        G = energyFunction(im_resize);  % get the energy image using the given energy function
        [min_energy, seam] = findSeam_vertical(G);
        %{
        %label the seam in the image and store the image
        im = im_resize;
        im = showSeam(im, seam, type);
        figure, imshow(im); 
        name = num2str(n);
        name = ['move/group3/', name, '.jpg'];
        imwrite(im, name);
        n = n+1;
        %}
        im_resize = removeSeam(im_resize, seam, type);
        seamVector(:, i) = seam;
    end
else strcmp(type, 'horizontal')
    seamVector = zeros(imgW, min(k, imgH-1));
    seamValueVector = zeros(imgW, min(k, imgH-1));
    n = 2;
    for i = 1:min(k, imgH-1) % make sure that keep a column of pixels at least
        G = energyFunction(im_resize);  % get the energy image using the given energy function
        [min_energy, seam] = findSeam_horizontal(G);
        
        %{
        %label the seam in the image and store the image
        im = im_resize;
        im = showSeam(im, seam, type);
        figure, imshow(im); 
        name = num2str(n);
        name = ['move/group2/', name, '.jpg'];
        imwrite(im, name);
        n = n+1;
        %}
        
        im_resize = removeSeam(im_resize, seam, type);
        seamVector(:, i) = seam;

    end
    
end



end


function im_size = objectRemoval(im, energyfunc, type)
%% Functon objectRemoval to remove the object that user indicate in the original image
%  Input:
%     im: original image
%     energyfunc: energy function used
%     type: indicate to use which type of seam cut: vetical or horizontal
%  Output?
%     im_size?the output image without the object


% get image sizes
[h1, w1, b1] = size(im);

% displays image
figure(1), hold off, imagesc(im), axis image, colormap gray

% gets four points from the user
disp('Select four points from the image including the object required to be removed')
[x, y] = ginput(4);

x_min = round(min(x));
x_max = round(max(x));
y_min = round(min(y));
y_max = round(max(y));

% get the energy for the original image
% set the region in the energy map where the object required to remove as 0
im_size = im;
im_mark1 = im;
im_mark2 = im;
for j = x_min:x_max
    for i = y_min:y_max
        if j==x_min||j==x_max||i==y_min||i==y_max
            im_mark1(i,j,1) = 255;
            im_mark1(i,j,2) = 0;
            im_mark1(i,j,3) = 0;
        end
    end
end
figure, imshow(im_mark1);title('The selected region to remove in the original image');

% get the number of seams need to be removed
num_vert = abs(x_max-x_min);
num_horiz= abs(y_max-y_min);
[imgH, imgW, imgD] = size(im_size);

if strcmp(type, 'vertical')
    k = num_vert;
    %seamVector = zeros(imgH, min(k, imgW-1));
    for l = 1:min(k, imgW-1) % make sure that keep a column of pixels at least
        G = energyfunc(im_size);  % get the energy image using the given energy function
        %for j = x_min:x_max-l+1
        for i = y_min:y_max
           G(i, x_min)= -10000;
        end
        [min_energy, seam] = findSeam_vertical(G);
        im_size = removeSeam(im_size, seam, type);
        %seamVector(:, l) = seam;
    end  
else strcmp(type, 'horizontal')
    k = num_horiz;  
        %seamVector = zeros(imgH, min(k, imgW-1));
        n = 2;
    for l = 1:min(k, imgW-1) % make sure that keep a column of pixels at least
        G = energyfunc(im_size);  % get the energy image using the given energy function
        %for j = x_min:x_max-l+1
        for i = x_min:x_max
           G(y_min, i)= -10000;
        end
        [min_energy, seam] = findSeam_horizontal(G);
        %{
        %label the seam in the image and store the image
        im = im_size;
        im = showSeam(im, seam, type);
        figure, imshow(im); 
        name = num2str(n);
        name = ['move/group4/', name, '.jpg'];
        imwrite(im, name);
        n = n+1;
        %}
        im_size = removeSeam(im_size, seam, type);
        %seamVector(:, l) = seam;
    end  
end

figure, imshow(im_size); title('The resized image');


end

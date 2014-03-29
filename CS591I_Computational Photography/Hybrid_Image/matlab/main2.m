%% Read the hybrid image
im12= im2single(imread('images/im12.jpg'));

%% To get gaussian and laplacian pyramids
Pyramid(im12, 4);
dataDir = './images/group6/originalImgs';
txtDir = './images/group6/txt';
dataDir1 = './images/group6/alignImgs3';
resultsDir = './images/group6/results';
mkdir(resultsDir);
mkdir(dataDir1);
num_Imgs = 17;% set the number of input images
imW = 1200;   % set the width of input image
imH =1200;    % set the height of input image

% align the input images based on the distance of eye

%{
%alignFaces(dataDir, num_Imgs)
%alignFaces2(dataDir,txtDir, num_Imgs, 43)

% reshape input images to 1D vectors
vec = createImgVector(dataDir1, num_Imgs);
%vec = CreateDatabase(dataDir);
% compute the eigen faces for allimages
%[m, A, eigenFaces] = EigenfaceCore(vec);
[eigenFaces, A, m]= eigenFaces(vec);
% displace the eigenvalues
num = size(eigenFaces, 2);
%{
for i = 1:num
   im = eigenFaces(:,i);
   im = reshape(im, imW,imH); im = im';
   
   figure, imagesc(im); colormap(gray);
   %name = [resultsDir '\' num2str(i) '_eigen.jpg'];
end
%}
%}
%% Five Eigen Vectors
k = 5;

S = diag([1,1,1,1,1]);
U = eigenFaces(:,1:5);
A = double(vec(:,1));

im = reshape(vec(:,1), imW,imH); im = im';
figure, imagesc(im);colormap(gray);
%V = inv(S)*U'*A;
%S = 1.*S;
%B = U*S*V;
V = (A'/(U*S)')';
C = V'*(U*S)';
D = A';
S= 1.*S;
B = U*S*V;
im = reshape(B, imW,imH); im = im';
figure, imagesc(im);colormap(gray);



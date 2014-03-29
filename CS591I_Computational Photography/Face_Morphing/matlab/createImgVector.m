function  vec = createImgVector(dataDir, num_Imgs)

%% CREATEDATAVECTOR: reshape all input 2D images to 1D column vectors and
%combine all vectors to a 2D maxtrix
%Input:
%     dataDir: the path of storing the input images
%     num_imgs: the total number of input images
%Output:
%     vec: 2D matrix of size (imW*imH) by num_images that contains all the
%     images' column vectors
%TrainFiles = dir(dataDir);


%%%%%%%%%%%%%%%%%%%%%%%% Construction of 2D matrix from 1D image vectors
vec = [];
for i = 1 : num_Imgs
    
    % I have chosen the name of each image in databases as a corresponding
    % number. However, it is not mandatory!
    name = strcat('\',int2str(i),'.jpg');
    name = [dataDir,name];
    
    img = imread(name);
    img_gray = rgb2gray(img);
    
    [imH imW] = size(img_gray);
   
    temp = reshape(img_gray',imH*imW,1);   % Reshaping 2D images into 1D image vectors
    vec = [vec temp]; % 'T' grows after each turn                    
end
end


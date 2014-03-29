function hybridimg(ImgFile1, ImgFile2, ImgFileOut)
% Hybrid Image Generator
% Usage: hybridimg(<Img1 Filename>, <Img2 Filename>, <ImgOutput Filename>);
I1 = im2single(imread('images/group6/mu.jpg'));
I2 = im2single(imread('images/group6/hi.jpg'));
I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
    radius = 13;     % Param
                     % GaussianRadius
   % I1 = imread(ImgFile1); 
   % I2 = imread(ImgFile2);
    I1_ = fftshift(fft2(double(I1)));
    I2_ = fftshift(fft2(double(I2)));
    [m n z] = size(I1);
    h = fspecial('gaussian', [m n], radius);
    h = h./max(max(h));
    for colorI = 1:3
        J_ = I1_.*(1-h) + I2_.*h;
    end
    J = uint8(real(ifft2(ifftshift(J_))));
    imwrite(J, 'fft.jpg');
    figure, imshow(I1_); 
    figure, imshow(I2_); 
    figure, imagesc(J);colormap(gray); 
end

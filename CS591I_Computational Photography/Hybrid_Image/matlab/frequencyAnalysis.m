function frequencyAnalysis(im1, im2, im1_filtered, im2_filtered, im12)
% generate the Log Magnitude of Fourier Transform for images
% convert input images to gray-level images
im1_gray = rgb2gray(im1);
im2_gray = rgb2gray(im2);
im1_filtered_gray = rgb2gray(im1_filtered);
im2_filtered_gray = rgb2gray(im2_filtered);
im12_gray = rgb2gray(im12);

% compute the log magnitude of the FFT of input images
A_im1 = log(abs(fftshift(fft2(im1_gray))));
A_im2 = log(abs(fftshift(fft2(im2_gray))));
A_im1_filtered = log(abs(fftshift(fft2(im1_filtered_gray))));
A_im2_filtered = log(abs(fftshift(fft2(im2_filtered_gray))));
A_im12 = log(abs(fftshift(fft2(im12_gray))));
subplot(3, 2, 1); imagesc(A_im1);
title('Log Magnitude of FFT of Image1');
subplot(3, 2, 2); imagesc(A_im2);
title('Log Magnitude of FFT of Image2');
subplot(3, 2, 3); imagesc(A_im1_filtered);
title('Log Magnitude of FFT of Low-Pass Filtered Image1');
subplot(3, 2, 4); imagesc(A_im2_filtered);
title('Log Magnitude of FFT of High-Pass Filtered Image2');
subplot(3, 2, 5); imagesc(A_im12);
title('Log Magnitude of FFT of Hybrid Image');
% show the images
figure, imagesc(A_im1);
title('Log Magnitude of FFT of Image1');
figure, imagesc(A_im2);
title('Log Magnitude of FFT of Image2');
figure, imagesc(A_im1_filtered);
title('Log Magnitude of FFT of Low-Pass Filtered Image1');
figure, imagesc(A_im2_filtered);
title('Log Magnitude of FFT of High-Pass Filtered Image2');
figure, imagesc(A_im12);
title('Log Magnitude of FFT of Hybrid Image');
% save the images
%imwrite(A_im1, 'FFT_image1.jpg','jpg');
%imwrite(A_im2, 'FFT_image2.jpg');
%imwrite(A_im1_filtered, 'FFT_image1_lowpass.jpg');
%imwrite(A_im2_filtered, 'FFT_image2_highpass.jpg');
%imwrite(A_im12, 'FFT_hybridimg.jpg');
end
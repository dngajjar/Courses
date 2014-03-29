How to use codes:
1. Run main.m to create a hybrid image that both the input images are color and their images of log magnitude of the Fourier transform. 
   If you want to get gray-level hybrid images, use corresponding functions shown below from 1 to 4.

2. Run main2.m to generate a Gaussian and Laplacian Pyramid with appointed levels. 
   You can change the input hybrid image as well as the total number of levels of pyramids in the file.

Functions:

1. function [im1_filtered,im2_filtered,im12]=hybridImage_color(im1,im2,cutoff_low,cutoff_high)
	% Generate Hybrid Image for both color images
	% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>,<High-pass filter frequency>)
	% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybridimage>]

2. function [im1_filtered, im2_filtered, im12] = hybridImage_gray(im1, im2, cutoff_low, cutoff_high)
	% Generate Hybrid Image for both gray images
	% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>, <High-pass filter frequency>)
	% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybridimage>]

3. function [im1_filtered,im2_filtered,im12]=hybridImage_combo_highgray(im1,im2,cutoff_low,cutoff_high)
	% Generate Hybrid Image(low-pass filtered image is color; high-pass filtered image is gray)
	% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>,<High-pass filter frequency>)
	% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybridimage>]

4. function [im1_filtered,im2_filtered,im12]=hybridImage_combo_lowgray(im1,im2,cutoff_low,cutoff_high)
	% Generate Hybrid Image(low-pass filtered image is gay; high-pass filtered image is color)
	% Usage: hybridImage(<Image1>, <Image2>, <Low-pass filter frequency>,<High-pass filter frequency>)
	% Output: [<low-pass filtered image>,<high-pass filtered image>, <hybridimage>]

5. function frequencyAnalysis(im1, im2, im1_filtered, im2_filtered, im12)
	% generate the Log Magnitude of Fourier Transform for images

6. function Pyramid(im12, num_levels)
	% To generate the gaussian and laplacian pyramids with images shown in two rows of the same figure with same size
	% Usage: <im12>: hybrid images; <num_levels>: number of levels in Gaussian and Laplacian Pyramid

7. function Pyramid2(im12, num_levels)
	% To generate the gaussian and laplacian pyramids with images shown in different figures with original size
	% Usage: <im12>: hybrid images; <num_levels>: number of levels in Gaussian and Laplacian Pyramid

8. function [im1, im2] = align_images(im1, im2)
	% Aligns im1 and im2 (translation, scale, rotation) after getting two pairs
	% of points from the user.  In the output of im1 and im2, the two pairs of
	% points will have approximately the same coordinates.

9. function tight_subplot()
    	% To show the images in one row.
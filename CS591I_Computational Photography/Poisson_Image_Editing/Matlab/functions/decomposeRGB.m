function [imR imG imB] = decomposeRGB(im)
%DECOMPOSERGB: to get the RGB channel of the original image

imR = im(:,:,1);
imG = im(:,:,2);
imB = im(:,:,3);
end


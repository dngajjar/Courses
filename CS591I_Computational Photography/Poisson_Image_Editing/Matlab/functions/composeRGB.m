function imNew = composeRGB(imR, imG, imB)
%COMPOSERGB: compose the RGB channels into a 3-channel image


% check whether the 3 channel images have the same size
if size(imR,1) ~= size(imG,1) | size(imR,1)~=size(imB,1) | size(imR,2)~= size(imG,2)...
        | size(imR,2)~=size(imB,2)
    fprintf('Different size of 3 channels, error compose');
    
end

imNew = zeros(size(imR,1), size(imR,2), 3);
imNew(:,:,1) = imR;
imNew(:,:,2) = imG;
imNew(:,:,3) = imB;

end


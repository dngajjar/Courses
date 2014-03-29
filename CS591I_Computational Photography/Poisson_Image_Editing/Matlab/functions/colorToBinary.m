function im_gray = colorToBinary(im, threshold)
%% COLORTOBINARY: conver RGB image to Binary image
%  Input:
%       im: the input RGB image
%       threshold: the threshold (between 0~255)
   im_gray = rgb2gray(im);
   
   for j = 1:size(im_gray,1)
       for l = 1:size(im_gray,2)
            if im_gray(j, l) > threshold
                im_gray(j, l) = 255;
            else
                im_gray(j, l) = 0;
                
            end
       end
   end
end


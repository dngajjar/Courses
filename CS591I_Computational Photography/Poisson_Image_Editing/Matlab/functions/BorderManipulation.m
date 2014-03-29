function out = BorderManipulation(im)
%% BORDERMANIPULATION Function: deal with the borders of the image
%  Input:
%       im: the input image
%  Outpug:
%       out: the output image after conducting the borders' manipulation
[imH, imW] = size(im);
Btop = im(1, :);
Bbottom = im(imH,:);
Bleft = im(:,1);
Bright = im(:, imW);

out = zeros(imH, imW);
out(1, :) = (Btop+Bbottom)/2;
out(imH,:) = out(1, :);
out(:, 1) = (Bleft+Bright)/2;
out(:, imW) = out(:, 1);


end


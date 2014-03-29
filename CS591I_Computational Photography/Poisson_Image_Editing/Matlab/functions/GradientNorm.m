function out = GradientNorm(im, ROI)
%% GRADIENTNORM Function: compute the average gradient norm of the given ROI
%region of input image im

% Input:
%      im: the given input image
%      ROI:[x, y, w, h] define the region of ROI; (x, y) the left corner
%      point; w the width of ROI; h the height of ROI;
% Output:
%      out: the generate average gradient norm value

%% Main Function
[dx, dy] = gradient(im);
grad = abs(dx)+abs(dy);
out = sum(sum(abs(grad(ROI(1):ROI(1)+ROI(3), ROI(2):ROI(2)+ROI(4)))))/(ROI(3)*ROI(4));
end


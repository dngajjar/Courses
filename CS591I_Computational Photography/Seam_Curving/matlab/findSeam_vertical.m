function  [min_energy, seam] = findSeam_vertical(G)
%%FINDSEAM_vertical Summary of this function goes here
% According to the formula:
%   M(i,j) = e(i,j) + min(M(i-1,j-1), M(i,j-1),M(i+1,j-1));

[height, width] = size(G);
for h = 2: height
    for w = 1:width
       left = max(w-1, 1);
       right = min(w+1, width);
       minpath = min(G(h-1, left:right));
       G(h, w) = G(h, w) + minpath;
    end
end

% To find the minimal energy path at the bottom
[min_energy, index] = min(G(height, :));

% Set a vector to store to coordinates of the seam pixesl
seam = zeros(height,1);

% Backtrack through the modified energy matrix from the bottom to the top
for h = height-1:-1:1
    num = index;
    seam(h+1) = num;
    left = max(num-1, 1);
    right= min(num+1, width);
    [temp, index] = min(G(h,left:right));
    index = index + left -1; % get the precious index of the minimal value
end
seam(1) = index;
end

    
    





function A = computeAffine(tri1_pts, tri2_pts)
%% COMPUTEAFFINE: compute an affine transformation matrix A between two triangles given points in tri1_pts and tri2_pts
% Input:
%    tri1_pts, tri2_pts: 3 by 2 matrix that stores the (x,y) position for
%    each point in a triangular
% Output: 
%    A: the transformation matrix

% get the matrices represent the positions of points in each triangular
one = ones(3, 1);
X0 = [tri1_pts one]';
X1 = [tri2_pts one]';

A = X1 * inv(X0);
end


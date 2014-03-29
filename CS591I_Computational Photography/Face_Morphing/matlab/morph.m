function morphedIm1= morph(im1, vec1, tri,temp)
%% MORPH: produce a warp between im1 and im2 using point correspondences defined in vec1 and vec2 and the triangulation structure tri
%  Input:
%     warp_frac and dissolve_frac: control shape warping and cross-dissolve, respectively.

% compute the intermediate shape (the (x, y) positions of the
% corresponding points)

tri1_pts = zeros(3, 2);
tri2_pts = zeros(3, 2);
A(3, 3, size(tri,1)) = 0;

%% Compute the first morphed image 1
for i = 1:size(tri,1)
    a = tri(i, 1);
    b = tri(i, 2);
    c = tri(i, 3);
    tri1_pts(1, 1) = vec1(a, 1);
    tri1_pts(1, 2) = vec1(a, 2);
    tri1_pts(2, 1) = vec1(b, 1);
    tri1_pts(2, 2) = vec1(b, 2);
    tri1_pts(3, 1) = vec1(c, 1);
    tri1_pts(3, 2) = vec1(c, 2);
    
    tri2_pts(1, 1) = temp(a, 1);
    tri2_pts(1, 2) = temp(a, 2);
    tri2_pts(2, 1) = temp(b, 1);
    tri2_pts(2, 2) = temp(b, 2);
    tri2_pts(3, 1) = temp(c, 1);
    tri2_pts(3, 2) = temp(c, 2);
    
    % compute the affine matrix for these two triangular
    A(:,:,i) = computeAffine(tri1_pts, tri2_pts);

end

[imH, imW, imD] = size(im1);
X0 = zeros(imH*imW, 1);
Y0 = X0;
for i = 1:imH
    for j = 1:imW
        X0((i-1)*imW+j) = j;
        Y0((i-1)*imW+j) = i;
    end
end
X1 = X0;
Y1 = Y0;
t = mytsearch(temp(:,1), temp(:,2), tri, X1, Y1);
% compute the corresponding points in original image
for i = 1:size(X0,1)
    if isnan(t(i))
       %X0(i) = 1;
       %Y0(i) = 1;
        continue;
    else
        B = inv(A(:,:,t(i)));
        X0(i) = B(1,:)*[X1(i);Y1(i);1];
        Y0(i) = B(2,:)*[X1(i);Y1(i);1];            
    end
end


X0 = reshape(X0,imW, imH); X0 = X0';
Y0 = reshape(Y0,imW, imH); Y0 = Y0';
morphedIm1 = im1;
% generate the morphed image 1
morphedIm1(:,:,1) = interp2(double(im1(:,:,1)),X0,Y0,'nearest');
morphedIm1(:,:,2) = interp2(double(im1(:,:,2)),X0,Y0,'nearest');
morphedIm1(:,:,3) = interp2(double(im1(:,:,3)),X0,Y0,'nearest');

%figure, imshow(morphedIm1);
end


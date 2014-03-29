function morphed_im = addMorphedImg(im1, im2, vec1, vec2, tri, warp_frac, dissolve_frac )
%ADDMORPHEDIMG: to generate the morphed images

disp(warp_frac)
disp(dissolve_frac)
temp = zeros(size(vec1, 1), 2);
temp(:, 1) = vec1(:, 1).*(1 - warp_frac)+ vec2(:, 1 ).*warp_frac;
temp(:, 2) = vec1(:, 2).*(1 - warp_frac)+ vec2(:, 2 ).*warp_frac;
morphedIm1= morph(im1, vec1, tri,temp);
morphedIm2= morph(im2, vec2, tri,temp);

morphed_im = morphedIm1.*(1-dissolve_frac)+morphedIm2.*dissolve_frac;
%figure,imshow(morphed_im);
end


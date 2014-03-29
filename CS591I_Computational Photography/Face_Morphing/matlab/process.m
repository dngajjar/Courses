function process(im1, im2, vec1, vec2, tri, num_frames, resultsDir)
%% PROCESS: get the pointed number of frames of morphing process between im1 and im2
%  Input?
%    im1, im2: input target images
%    vec1, vec2: input corresponding pairs of points
%    tri: triangulation structure
%    num_frames: number of frames need to produce

t = 1/num_frames;

for i = 0:num_frames
    % generate the morphed image
    morphed_im = addMorphedImg(im1, im2, vec1, vec2, tri, t*i, t*i);
    % save the produced image
    name = fullfile(resultsDir, ['frame' num2str(i) '.jpg']);
    %figure, imshow(morphed_im);
    imwrite(morphed_im, name);
end
end


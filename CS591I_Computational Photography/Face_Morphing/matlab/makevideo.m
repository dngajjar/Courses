dataDir = './images/group0/results';

% set parameters for creating a video
num_frames = 60;
framerate =30;
outName = fullfile(dataDir,['MorphedFace-' num2str(num_frames+1) '-frames.avi']);

vidOut = VideoWriter(outName);
vidOut.FrameRate = framerate;
open(vidOut)

for i = 0:num_frames
   name = fullfile(dataDir, ['frame' num2str(i) '.jpg']); 
   im = imread(name);
   writeVideo(vidOut,im2uint8(im));
end

close(vidOut);
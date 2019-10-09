% Q3.3.1
clear all;
close all;

ar_src = loadVid('../data/ar_source.mov');
in = loadVid('../data/book.mov');
cv_img = imread('../data/cv_cover.jpg');

out = VideoWriter('../results/ar.avi');
open(out)

for i = 1:length(ar_src)
    disp(i);
    %% Extract features and match
    [locs1, locs2] = matchPics(cv_img, in(i).cdata);

    %% Compute homography using RANSAC
    [bestH2to1, ~] = computeH_ransac(locs1, locs2);
    
    %% Scale harry potter image to template size
    % Why is this is important?
    scaled_ar_img = imresize(ar_src(i).cdata, [size(cv_img,1) size(cv_img,2)]);

    %% Write composite image
    % imshow(compositeH(inv(bestH2to1), scaled_ar_img, in(1).cdata));
    writeVideo(out, compositeH(inv(bestH2to1), scaled_ar_img, in(i).cdata));
end
close(out)
% Q4.1x
clear all;
close all;

ar_src = loadVid('../data/ar_source.mov');
in = loadVid('../data/book.mov');
cv_img = imread('../data/cv_cover.jpg');
scale = 0.5;

cv_img_sm = imresize(cv_img, scale);
c1 = detectFASTFeatures(cv_img_sm);
[f1, vc1] = extractFeatures(cv_img_sm, c1.Location);

out = VideoWriter('../results/ar_ec.avi');
open(out)

for i = 1:length(ar_src)
    disp(i);
    %% Extract features and match
    [locs1, locs2] = matchPics_ec(f1, vc1, imresize(in(i).cdata, scale, 'nearest'));
    locs1 = locs1 ./ scale;
    locs2 = locs2 ./ scale;

    %% Compute homography using RANSAC
    [bestH2to1, ~] = computeH_ransac_ec(double(locs1), double(locs2));
    
    %% Scale harry potter image to template size
    % Why is this is important?
    scaled_ar_img = imresize(ar_src(i).cdata, [size(cv_img,1) size(cv_img,2)], 'nearest');

    %% Write composite image
    % imshow(compositeH(inv(bestH2to1), scaled_ar_img, in(1).cdata));
    writeVideo(out, compositeH_ec(inv(bestH2to1), scaled_ar_img, in(i).cdata));
end
close(out)
% Q4.1x
% PLEASE RUN THE CODE TWICE TO GET ACCURATE RESULT FOR FPS
% IN THE FIRST ITERATION THE INIT OF VIDEOPLAYER INTERFERES WITH THE TIMER
close all;

ar_src = loadVid('../data/ar_source.mov');
in = loadVid('../data/book.mov');
cv_img = imread('../data/cv_cover.jpg');
scale = 0.5;
cv_img_sm = imresize(cv_img, scale);
c1 = detectFASTFeatures(cv_img_sm);
[f1, vc1] = extractFeatures(cv_img_sm, c1.Location);

videoPlayer = vision.VideoPlayer;

tot_time = 0;
nextROI = [1 1; size(in(1).cdata, 1) size(in(1).cdata, 2)];
for i = 1:length(ar_src)
    tic
    %% Extract features and match
    if i == 1
        [locs1, locs2] = matchPics_ec(f1, vc1, imresize(in(i).cdata, scale, 'nearest'));
    else
        [locs1, locs2] = matchPics_ec(f1, vc1, ...
            imresize(in(i).cdata(nextROI(1,1):nextROI(2,1),nextROI(1,2):nextROI(2,2)), ...
            scale, 'nearest'));
    end
    
    %% Compute homography using RANSAC
    [bestH2to1, ~] = computeH_ransac_ec(double(locs1 ./ scale), ...
        double(locs2 ./ scale) + [nextROI(1,2) nextROI(1,1)] - 1);
   
    %% Scale harry potter image to template size
    % Why is this is important?
    scaled_ar_img = imresize(ar_src(i).cdata, [size(cv_img,1) size(cv_img,2)], 'nearest');
    
    %% Calculate composite image
    [img, nextROI] = compositeH_ec(inv(bestH2to1), scaled_ar_img, in(i).cdata);
    nextROI = [max(nextROI(1,:), 1); min(nextROI(2,:), [size(in(1).cdata, 1) size(in(1).cdata, 2)])];

    %% Display fps and frame number
    tot_time = tot_time + toc;
    disp([i, i/tot_time]);
    
    %% Show composite image
    % bbox = [nextROI(1,2) nextROI(1,1), nextROI(2,2)-nextROI(1,2) nextROI(2,1)-nextROI(1,1)];
    % img = insertObjectAnnotation(img,'rectangle',bbox,'Rectangle');
    videoPlayer(img);
end
release(videoPlayer);

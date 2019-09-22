%Q2.2.4
clear all;
close all;

cv_img = imread('../data/cv_cover.jpg');
desk_img = imread('../data/cv_desk.png');
hp_img = imread('../data/hp_cover.jpg');

%% Extract features and match
[locs1, locs2] = matchPics(cv_img, desk_img);

%% Compute homography using RANSAC
[bestH2to1, ~] = computeH_ransac(locs1, locs2);

%% Scale harry potter image to template size
% Why is this is important?
scaled_hp_img = imresize(hp_img, [size(cv_img,1) size(cv_img,2)]);

%% Display warped image.
imshow(warpH(scaled_hp_img, inv(bestH2to1), size(desk_img)));

%% Display composite image
imshow(compositeH(inv(bestH2to1), scaled_hp_img, desk_img));

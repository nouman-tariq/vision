% Q4.3x
clear all;
close all;

addpath('../matlab');

pano_left = imread('../data/pano_left.jpg');
pano_right = imread('../data/pano_right.jpg');
% TODO: Change to own images

% [moving, fixed] = cpselect(pano_right, pano_left, 'Wait', true);
% moving = [737.6280 567.1341; 443.5270 586.6408;...
%         706.1171 687.1753; 575.5723 436.5893];
% fixed = 1.0e+03 * [1.0497 0.5416; 0.7346 0.5611;...
%         0.9972 0.6707; 0.8637 0.4141];
% moving
% fixed
[fixedPoints, movingPoints] = matchPics(pano_left, pano_right);

H_move2fixed = computeH_ransac(fixedPoints, movingPoints);
disp(H_move2fixed)
imshow(imwarp(pano_right, affine2d([1 0 0; .5 1 0; 0 0 1])));
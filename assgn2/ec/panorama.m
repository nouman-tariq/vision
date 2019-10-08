% Q4.3x
clear all;

pano_left = imread('../data/pano_left.jpg');
pano_right = imread('../data/pano_right.jpg');
% TODO: Change to own images

locPairs = cpselect(pano_left, pano_right);
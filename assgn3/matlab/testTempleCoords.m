% A test script using templeCoords.mat
%
% Write your code here
%

%% 1. Load images and correspondences
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
corresp = load('../data/someCorresp.mat');

%% 2. Run eightpoint to compute fundamental matrix
F = eightpoint(corresp.pts1, corresp.pts2, corresp.M);
displayEpipolarF(im1, im2, F);

%% 8. Save computed rotation matrix and translation
% save extrinsic parameters for dense reconstruction
save('../data/extrinsics.mat', 'R1', 't1', 'R2', 't2');

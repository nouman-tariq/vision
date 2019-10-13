clear all ;
% Load image and paramters
im1 = imread('../data/im1.png');
im2 = imread('../data/im2.png');
im1 = rgb2gray(im1);
im2 = rgb2gray(im2);

load('../data/intrinsics.mat', 'K1', 'K2');

load('../data/extrinsics.mat', 'R1', 'R2', 't1', 't2');

% Rectify images
[M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = rectify_pair(K1, K2, R1, R2, t1, t2);

[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

% Save the rectification parameters
save('rectify.mat', 'M1', 'M2', 'K1n', 'K2n', 'R1n', 'R2n', 't1n', 't2n');

% Display
[rectIL, rectIR, bbL, bbR] = warp_stereo(im1, im2, M1, M2) ;

[nR nC] = size(rectIL) ;
rectImg = zeros(nR, 2*nC, 'uint8') ;
rectImg(:,1:nC) = rectIL ;
rectImg(:,nC+1:end) = rectIR ;

% load gt info.
load('../data/someCorresp.mat', 'pts1', 'pts2');
gtL = pts1(1:20:end, :)';
gtR = pts2(1:20:end, :)';

% warp left and right points
mlx = p2t(M1,gtL);
mrx = p2t(M2,gtR);
mrx(1,:) = mrx(1,:) + nC ;

hfig = figure; imshow(rectImg) ; hold on; 
plot(mlx(1,:)'-bbL(1),mlx(2,:)'-bbL(2), 'r*', 'MarkerSize', 10) ;
plot(mrx(1,:)'-bbR(1),mrx(2,:)'-bbR(2), 'b*', 'MarkerSize', 10) ;
line([ones(size(gtL,2),1) 2*nC*ones(size(gtL,2),1)]', [mlx(2,:)'-bbL(2) mlx(2,:)'-bbL(2)]') ;

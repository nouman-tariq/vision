% Q4.3x
close all;

%% Read files
addpath('../matlab');

% pano_left = imread('../data/pano_left.jpg');
% pano_right = imread('../data/pano_right.jpg');
pano_left = imread('american_diner_left.jpg');
pano_right = imread('american_diner_right.jpg');

%% Compute homography
[fixedPoints, movingPoints] = matchPics(pano_left, pano_right);

H_move2fixed = computeH_ransac(fixedPoints, movingPoints);
tforms(1) = projective2d(eye(3));
tforms(2) = projective2d(H_move2fixed');

%% Build panorama
imageSize = zeros(2, 2);
imageSize(1, :) = size(rgb2gray(pano_left));
imageSize(2, :) = size(rgb2gray(pano_right));
maxImageSize = max(imageSize);

[xlim(1, :), ylim(1, :)] = outputLimits(tforms(1), [1 imageSize(1, 2)], [1 imageSize(1, 1)]);
[xlim(2, :), ylim(2, :)] = outputLimits(tforms(2), [1 imageSize(2, 2)], [1 imageSize(2, 1)]);
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);
yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);
width = round(xMax - xMin);
height = round(yMax - yMin);

pano = zeros([height width 3], 'like', pano_left);
blender = vision.AlphaBlender('Operation', 'Binary mask', 'MaskSource', 'Input port');
panoramaView = imref2d([height width], [xMin xMax], [yMin yMax]);

%% Stitching
for i = 1:2
    if i == 1
        I = pano_left;
    else
        I = pano_right;
    end
    warped = imwarp(I, tforms(i), 'OutputView', panoramaView);
    mask = imwarp(true(size(I, 1), size(I, 2)), tforms(i), 'OutputView', panoramaView);
    pano = step(blender, pano, warped, mask);
end
imshow(pano);

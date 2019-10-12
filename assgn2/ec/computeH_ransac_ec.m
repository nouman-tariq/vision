function [ bestH2to1, inliers] = computeH_ransac_ec( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

%Q2.2.3
N = size(locs2, 1);
maxIter = 40;

%% Choose threshold 'd'
d = 10; %sqrt(3.84*mean(var(locs2 - mean(locs2))));

%% Prepare homogeneous coordinates
locs2homo = horzcat(locs2, ones(N, 1));

%% Loop
%%% Randomly sample 4 correspondences
%%% make homogeneous
%%% computeH_norm
%%% project data with 'H'
%%% make non-homogeneous
%%% compute norm between matched and projected
%%% count inliers wrt 'd'
%%% recalc H with max outliers

inliers = zeros(N, 1);

for i = 1:maxIter
   sample = randperm(N, 4);
   % Compute H under normalization with non-homogeneous samples
   H = computeH_norm_ec(locs1(sample, :), locs2(sample, :));
   locs2to1homo = (H * locs2homo')';
   % Convert scales to 1 so that homogeneous coordinates can be truncated
   % to non-homogenous coordinates
   diffs = vecnorm(locs2to1homo(:, 1:2) ./ locs2to1homo(:, 3) - locs1, 2, 2);
   inliers_i = (diffs <= d);
   if sum(inliers_i) > sum(inliers)
       inliers = inliers_i;
       %bestH2to1 = H;
   end
end

bestH2to1 = computeH_norm_ec(locs1(inliers, :), locs2(inliers, :));
end


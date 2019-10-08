function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

%Q2.2.3
N = size(locs2, 1);
maxIter = 500;
%% Fix values for deriving sample size and threshold
p = 0.99;    % fix the probability that a point be in the threshold
s = 4;       % minimum number of points to fit the model (solve H)

%% Find outlier ratio 'e'
% A point is marked as outlier if either x- or y- coordinate is an outlier
% itself among all x- and y- coordinates
e_mask = any(isoutlier(locs2), 2);
e = sum(e_mask)/N;

%% Choose sample size 'n'
n = ceil(log(1-p) / log(1-(1-e)^s));

%% Choose threshold 'd'
d = 10; %sqrt(3.84*mean(var(locs2 - mean(locs2))));

%% Prepare homogeneous coordinates
locs2homo = horzcat(locs2, ones(N, 1));

%% Loop
%%% Randomly sample 'n' correspondences
%%% make homogeneous
%%% computeH_norm
%%% project data with 'H'
%%% make non-homogeneous
%%% compute norm between matched and projected
%%% count inliers wrt 'd'
%%% keep H with max outliers
bestH2to1 = zeros(3, 3);
inliers = zeros(N, 1);
for i = 1:maxIter
   sample = randperm(N, n);
   % Compute H under normalization with non-homogeneous samples
   H = computeH_norm(locs1(sample, :), locs2(sample, :));
   locs2to1homo = (H * locs2homo')';
   % Convert scales to 1 so that homogeneous coordinates can be truncated
   % to non-homogenous coordinates
   locs2to1 = locs2to1homo(:, 1:2) ./ locs2to1homo(:, 3);
   diffs = vecnorm(locs2to1 - locs1, 2, 2);
   inliers_i = (diffs <= d);
   if sum(inliers_i) > sum(inliers)
       inliers = inliers_i;
       bestH2to1 = H;
   end
end
end


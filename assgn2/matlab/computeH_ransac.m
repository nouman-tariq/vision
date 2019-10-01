function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.
[N, ~] = size(locs2);
maxIter = 100;

%Q2.2.3
%% Fix values for deriving sample size and threshold
p = 0.95;    % fix the probability that a point be in the threshold
s = 4;       % minimum number of points to fit the model (solve H)

%% Find outlier ratio 'e'
% A point is marked as outlier if either x- or y- coordinate is an outlier
% itself among all x- and y- coordinates
e_mask = any(isoutlier(locs2), 2);
e = sum(e_mask)/N;

%% Choose sample size 'n'
n = ceil(log(1-p) / log(1-(1-e)^s));

%% Choose threshold 'd'
d = sqrt(3.84*mean(var(locs2 - mean(locs2))));
% how to choose?

%% Prepare homogeneous coordinates
locs2homo = horzcat(locs2, ones(N, 1));

%% Loop
%%% Randomly sample 'N' correspondences
%%% computeH_norm
%%% project data with 'H', compute norm between matched and projected
%%% count inliers wrt 'd'
%%% keep H with max outliers
bestH2to1 = zeros(3, 3);
inliers = zeros(N, 1);
for i = 1:maxIter
   sample = randperm(N, n);
   H = computeH_norm(locs1(sample, :), locs2(sample, :));
   proj2homo = H * locs2homo';
   proj2 = proj2homo(1:2, :);
   inliers_ = (vecnorm(proj2' - locs1, 2, 2) <= d);
   %disp(sum(inliers_));
   if sum(inliers_) > sum(inliers)
       inliers = inliers_;
       bestH2to1 = H;
   end
end
disp([N sum(inliers_)]);
%% Recompute H with inliners
% Needed?
end


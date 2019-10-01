function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = [mean(x1(:, 1)) mean(x1(:, 2))];
centroid2 = [mean(x2(:, 1)) mean(x2(:, 2))];

%% Shift the origin of the points to the centroid
% x1 = x1 - centroid1;
% x2 = x2 - centroid2;

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).
maxNorm1 = max(vecnorm(x1, 2, 2));
maxNorm2 = max(vecnorm(x2, 2, 2));

%% similarity transform 1
T1 = [  sqrt(2)/maxNorm1 0 -sqrt(2)/maxNorm1*centroid1(1);...
        0 sqrt(2)/maxNorm1 -sqrt(2)/maxNorm1*centroid1(2);...
        0 0 1   ];

%% similarity transform 2
T2 = [  sqrt(2)/maxNorm2 0 -sqrt(2)/maxNorm2*centroid2(1);...
        0 sqrt(2)/maxNorm2 -sqrt(2)/maxNorm2*centroid2(2);...
        0 0 1   ];

%% Compute Homography
[N, ~] = size(x1);
x1homo = horzcat(x1, ones(N, 1));
x2homo = horzcat(x2, ones(N, 1));
H = computeH(T1*x1homo', T2*x2homo');

%% Denormalization
H2to1 = inv(T1)*H*T2;
end
function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points
centroid1 = [mean(x1(:, 1)) mean(x1(:, 2))];
centroid2 = [mean(x2(:, 1)) mean(x2(:, 2))];

%% Shift the origin of the points to the centroid

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

%% similarity transform 1
scale1 = sqrt(2) / mean(vecnorm(x1, 2, 2));
T1 = diag([scale1 scale1 1]);
T1(1:2, 3) = -scale1*centroid1';

%% similarity transform 2
scale2 = sqrt(2) / mean(vecnorm(x2, 2, 2));
T2 = diag([scale2 scale2 1]);
T2(1:2, 3) = -scale2*centroid2';

%% Compute Homography
% Convert to Homogeneous coordinates to apply 'T1', 'T2'
x1(:, 3) = 1;
x2(:, 3) = 1;
x1n = (T1*x1')';
x2n = (T2*x2')';
% Convert back to non-Homogeneous coordinates for 'computeH'
H = computeH(x1n(:, 1:2), x2n(:, 1:2));

%% Denormalization
H2to1 = inv(T1)*H*T2;
end
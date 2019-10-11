function [H2to1] = computeH_norm(x1, x2)

%% Compute centroids of the points

%% Shift the origin of the points to the centroid

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

%% similarity transform 1
T1 = norm_transform(x1);

%% similarity transform 2
T2 = norm_transform(x2);

%% Compute Homography
% Convert to Homogeneous coordinates to apply 'T1', 'T2'
x1(:, 3) = 1;
x2(:, 3) = 1;
x1n = (T1*x1')';
x2n = (T2*x2')';
% disp('x1n'); disp(x1n);
% disp('x2n'); disp(x2n);
% Convert back to non-Homogeneous coordinates for 'computeH'
H = computeH(x1n(:, 1:2), x2n(:, 1:2));

%% Denormalization
H2to1 = (T1 \ H)*T2;
end

function [T] = norm_transform(x)
   centroid = [mean(x(:, 1)) mean(x(:, 2))];
   scale = sqrt(2) / mean(vecnorm(x, 2, 2));
   T = diag([scale scale 1]);
   T(1:2, 3) = -scale * centroid;
end
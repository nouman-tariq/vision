function [H2to1] = computeH_norm_ec(x1, x2)

%% Compute centroids of the points

%% Shift the origin of the points to the centroid

%% Normalize the points so that the average distance from the origin is equal to sqrt(2).

%% similarity transform 1
% Writing out mean like this is FASTER than mean itself.
scale = vecnorm(x1, 2, 2);
scale = sqrt(2) / ((scale(1) + scale(2) + scale(3) + scale(4) / 4));
T1 = [scale 0 0; 0 scale 0; 0 0 1];
T1(1:2, 3) = -scale * [(x1(1,1) + x1(2,1) + x1(3,1) + x1(4,1))/4 (x1(1,2) + x1(2,2) + x1(3,2) + x1(4,2))/4];
   
%% similarity transform 2
scale = vecnorm(x2, 2, 2);
scale = sqrt(2) / ((scale(1) + scale(2) + scale(3) + scale(4) / 4));
T2 = [scale 0 0; 0 scale 0; 0 0 1];
T2(1:2, 3) = -scale * [(x2(1,1) + x2(2,1) + x2(3,1) + x2(4,1))/4 (x2(1,2) + x2(2,2) + x2(3,2) + x2(4,2))/4];

%% Compute Homography
% Convert to Homogeneous coordinates to apply 'T1', 'T2'
x1(:, 3) = 1;
x2(:, 3) = 1;
x1n = x1*T1';
x2n = x2*T2';

% Convert back to non-Homogeneous coordinates for 'computeH'
H = computeH_ec(x1n(:, 1:2), x2n(:, 1:2));

%% Denormalization
H2to1 = (T1 \ H)*T2;
end

% Script for testing Pose Estimation part in the project 5
%
% Chen Kong.

% Random generate camera matrix
K = [1,0,1e2;0,1,1e2;0,0,1];

[R, ~, ~] = svd(randn(3));
t = randn(3, 1);

P = K*[R, t];

% Random generate 2D and 3D points
N = 10;
X = randn(3, N);
x = P*[X; ones(1, N)];
x(1, :) = x(1, :)./x(3, :);
x(2, :) = x(2, :)./x(3, :);
x = x(1:2, :);

% test
PClean = estimate_pose(x, X);

xProj = PClean*[X; ones(1, N)];
xProj(1, :) = xProj(1, :)./xProj(3, :);
xProj(2, :) = xProj(2, :)./xProj(3, :);
xProj = xProj(1:2, :);
fprintf('Reprojected Error with clean 2D points is %.4f\n', norm(xProj-x));
fprintf('Pose Error with clean 2D points is %.4f\n',...
    norm(PClean/PClean(end) - P/P(end)));


% Noise performance
% add some noise
xNoise = x + rand(size(x));

PNoisy = estimate_pose(xNoise, X);

xProj = PNoisy*[X; ones(1, N)];
xProj(1, :) = xProj(1, :)./xProj(3, :);
xProj(2, :) = xProj(2, :)./xProj(3, :);
xProj = xProj(1:2, :);
fprintf('------------------------------\n');
fprintf('Reprojected Error with noisy 2D points is %.4f\n', norm(xProj-x));
fprintf('Pose Error with noisy 2D points is %.4f\n',...
    norm(PNoisy/PNoisy(end) - P/P(end))/norm(P/P(end)));

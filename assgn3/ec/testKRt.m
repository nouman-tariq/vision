% Script for testing Pose Estimation
% Randomly generate camera matrix
K = [1,0,1e2;0,1,1e2;0,0,1];

[R, ~, ~] = svd(randn(3));
if det(R) < 0
    R = -R;
end
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
[KClean, RClean, tClean] = estimate_params(PClean);
fprintf('Intrinsic Error with clean 2D points is %.4f\n',...
    norm(KClean/KClean(end) - K/K(end)));
fprintf('Rotation Error with clean 2D points is %.4f\n',...
    norm(RClean - R));
fprintf('Translation Error with clean 2D points is %.4f\n', ...
    norm(tClean - t));


% Noise performance
% add some noise
xNoise = x + rand(size(x));
PNoisy = estimate_pose(xNoise, X);
[KNoisy, RNoisy, tNoisy] = estimate_params(PNoisy);
fprintf('------------------------------\n');
fprintf('Intrinsic Error with clean 2D points is %.4f\n',...
    norm(KNoisy/KNoisy(end) - K/K(end)));
fprintf('Rotation Error with clean 2D points is %.4f\n',...
    norm(RNoisy - R));
fprintf('Translation Error with clean 2D points is %.4f\n', ...
    norm(tNoisy - t));

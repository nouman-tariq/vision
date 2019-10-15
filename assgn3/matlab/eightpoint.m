function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'

N = size(pts1, 1);
%% Normalize points
T1 = norm_transform(pts1);
T2 = norm_transform(pts2);
% Convert to homogeneous coordinates
pts1n = [pts1(1:N, :), ones(N, 1)];
pts2n = [pts2(1:N, :), ones(N, 1)];
pts1n = (T1 * pts1n')';
pts2n = (T2 * pts2n')';
% Scale down by 'M'
pts1n = pts1n ./ M;
pts2n = pts2n ./ M;
% Convert back to non-homogeneous coordinates
pts1n = pts1n ./ pts1n(3, :);
pts2n = pts2n ./ pts2n(3, :);

%% Construct N-by-9 'A'
% Truncate to non-homogeneous coordinates
x1 = pts1n(:, 1);
y1 = pts1n(:, 2);
x2 = pts2n(:, 1);
y2 = pts2n(:, 2);
A = [x2.*x1, x2.*y1, x2, y2.*x1, y2.*y1, y2, x1, y1, ones(N, 1)];

%% Find SVD of 'A' to find 'F'
[~, ~, V_A] = svd(A);
% 'V' is returned transposed
F = reshape(V_A(:, 9), [3 3]);

%% Enforce rank 2 constraint on 'F'
[U, S, V] = svd(F);
S(end, end) = 0;
F = U*S*V';

%% Refine solution with local minimization
F = refineF(F, pts1, pts2);

%% Un-normalize 'F'
% scale back up to 'M'
F = F .* M;
F = T2' * F * T1;
end

function T = norm_transform(x)
centroid = [mean(x(:, 1)) mean(x(:, 2))];
scale = sqrt(2) / mean(vecnorm(x, 2, 2));
T = diag([scale scale 1]);
T(1:2, 3) = -scale * centroid;
end

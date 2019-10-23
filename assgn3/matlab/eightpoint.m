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
T = [1/M, 0, 0; 0, 1/M, 0; 0, 0, 1];
% Convert to homogeneous coordinates
pts1n = [pts1, ones(N, 1)];
pts2n = [pts2, ones(N, 1)];
% Scale down by 'M'
pts1n = (T * pts1n')';
pts2n = (T * pts2n')';

%% Construct N-by-9 'A'
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
F = refineF(F, pts1n(:, 1:2), pts2n(:, 1:2));

%% Un-normalize 'F'
% Scale up by 'M'
F = T' * F * T;

end

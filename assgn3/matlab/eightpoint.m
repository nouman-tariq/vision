function F = eightpoint(pts1, pts2, M)
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from correspondence '../data/some_corresp.mat'


%% Normalize points
pts1 = pts1 ./ M;
pts2 = pts2 ./ M;

%% Construct N-by-9 'A'
N = size(pts1, 1);
A = zeros(N, 9);
for i = 1:N
    A(i, :) = computeAi(pts1(i, :), pts2(i, :));
end

%% Find SVD of 'A' to find 'F'
[~, ~, V_A] = svd(A);
F = reshape(V_A(end, :), [3 3]);

%% Enforce rank 2 constraint on 'F'
[U, S, V] = svd(F);
S(end, end) = 0;
F = U*S*V';

%% Refine solution with local minimization
F = refineF(F, pts1, pts2);

%% Un-normalize 'F'
% scale back up .* M
F = F .* M;
end

function Ai = computeAi(pt1, pt2)
x = pt1(1); y = pt1(2);
x_ = pt2(1); y_ = pt2(2);
Ai = [x*x_ x*y_ x y*x_ y*y_ y x_ y_ 1];
end
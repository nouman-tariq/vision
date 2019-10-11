function [ H2to1 ] = computeH_ec( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
[N, ~] = size(x1);
A = zeros(2*N, 9);
for i = 1:N
    A(2*i-1, :) = [-x2(i, 1) -x2(i, 2) -1 0 0 0 x1(i,1)*x2(i,1) x1(i,1)*x2(i,2) x1(i,1)];
    A(2*i, :) = [ 0 0 0 -x2(i,1) -x2(i,2) -1 x2(i,1)*x1(i,2) x1(i,2)*x2(i,2) x1(i,2)];
end

[~, ~, V] = svd(A);

% unrolling is a bit quicker than calling reshape
H2to1 = [V(1,end) V(2,end) V(3,end); V(4,end) V(5,end) V(6,end); V(7,end) V(8,end) V(9,end)];

% [~, ~, v] = svds(A, 1, 'smallest');
% [Q, ~] = qr(A');

% H2to1 = reshape(v, [3 3])';
% H2to1 = reshape(Q(:, end), [3 3])';
end
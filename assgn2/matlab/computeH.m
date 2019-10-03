function [ H2to1 ] = computeH( x1, x2 )
%COMPUTEH Computes the homography between two sets of points
[N, ~] = size(x1);
A = [];
for i = 1:N
    A(2*i-1:2*i, :) = computeAi(x1(i, :), x2(i, :));
end
% A = zeros(2*N, 9);
% A(2*(1:N)-1:2*(1:N), :) = computeAi(x1(1:N, :), x2(1:N, :));
[~, S, V] = svd(A, 'econ');
disp('A'); disp(A); disp(A(2*(1:N)));
s = diag(S);
disp('S'); disp(s); disp(find(s)); disp(size(S)); disp(s(6:end));
disp('V'); disp(V); disp(size(V));
H2to1 = reshape(V(:, end), [3 3])';
end

function [A_i] = computeAi(p1, p2)
%COMPUTEAI Computes the direct linear transform matrix A_i
%from point p2 to point p1, each of size (2, 1)
A_i = [ -p2(1) -p2(2) -1 0 0 0 p1(1)*p2(1) p1(1)*p2(2) p1(1);...
        0 0 0 -p2(1) -p2(2) -1 p2(1)*p1(2) p1(2)*p2(2) p1(2)];
end
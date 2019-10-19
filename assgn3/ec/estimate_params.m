function [K, R, t] = estimate_params(P)
% ESTIMATE_PARAMS computes the intrinsic K, rotation R and translation t from
% given camera matrix P.

%% Camera center c
[~, ~, V] = svd(P);
c = V(:,end);
c = c(1:3) ./ c(end);

%% K and R
[K, R] = rq(P(:, 1:3));

%% t
t = -R*c;

end

function [R, Q] = rq(A)
perm = [0 0 1; 0 1 0; 1 0 0];
A = perm*A;
[Q, R] = qr(A');
Q = perm*Q';
R = perm*R'*perm;
neg = -any(R<0 & abs(R) > 1e-4);
neg(neg==0) = 1;
R = R * diag(neg);
Q = diag(neg) * Q;
if abs(det(Q)+1) < 1e-4
    Q = - Q;
end
end
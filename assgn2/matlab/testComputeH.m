function testComputeH(i)
% test the i'th point pair for 'x1_i = H * x2_i' up to a scale
% with H given by 'computeH_norm'
x1 = [501 500; 500 700; 600 600; 700 500; 700 700];
x2 = [500 500; 500 700; 600 600; 700 500; 700 700];
x1h1 = horzcat(x1(i, :), 1);
x2h1 = horzcat(x2(i, :), 1);

H2to1 = computeH_norm(x1, x2);
disp('h * x2');
x1h1_ = H2to1 * x2h1';
disp(H2to1 * x2h1');
disp('x1');
disp(x1h1');
disp('compare: test that they should share the same scalar scale');
disp(x1h1_ ./ x1h1');

% A = [];
% [N, ~] = size(x1);
% for i = 1:N
%     A = vertcat(A, computeAi(x1(i, :), x2(i, :)));
% end
% size(A)
% o = zeros(2*N, 1);
% h = A \ o;
% reshape(h, [3 3])
% x1h1_ = H2to1 * x2h1';
% disp(x1h1');
% disp(x1h1_);
% disp(x1h1' ./ x1h1_);

end
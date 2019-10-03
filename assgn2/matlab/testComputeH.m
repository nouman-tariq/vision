function testComputeH()

x1 = [333 484; 333 334; 709 334; 709 484];
% x1 = [0 0; 100 0; 100 200; 0 200];
% x2 = [332 343; 430 229; 712 477; 614 590];
theta = 45 * pi/180;
rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
rothomo = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
x2 = (rot * x1')';
disp('x2');
disp(x2)

x1homo = horzcat(x1, ones(size(x1, 1), 1));
x2homo = horzcat(x2, ones(size(x1, 1), 1));

H2to1 = computeH(x1, x2);
disp('H');
disp(H2to1);
disp('h * x2homo');
x1_ = H2to1 * x2homo';
disp(x1_);
disp('x1');
disp(x1homo');
disp('compare: test that they should share the same scalar scale');
scales = x1_ ./ x1homo';
disp(scales);
disp('max');
max_ = max(max(scales));
disp(max_);
disp('min');
min_ = min(min(scales));
disp(min_);
disp('diff');
disp(max_ - min_);
disp('h_ans/h2to1');
disp(inv(rothomo) ./ H2to1);

end
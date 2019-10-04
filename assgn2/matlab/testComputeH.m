function testComputeH()

x1 = [333 484; 333 334; 709 334; 709 484];

theta = 45 * pi/180;
rot = [cos(theta) -sin(theta); sin(theta) cos(theta)];
rothomo = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
x2 = (rot * x1')';

H2to1 = computeH_norm(x1, x2);

disp('H'); disp(H2to1);

% Sanity check: non-zero elements should be the same
disp('alpha'); disp(inv(rothomo) ./ H2to1);

end
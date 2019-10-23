%% 1. Load data
load('../data/PnP.mat', 'cad', 'image', 'x', 'X');

%% 2. Estimate parameters
P = estimate_pose(x, X);
[K, R, t] = estimate_params(P);

%% 3. Estimate x
X_homo = X;
X_homo(end+1, :) = 1;
x_est = P*X_homo;
x_est = x_est(1:2, :) ./ x_est(end, :);

%% 4. Plot x and x_est
figure; imshow(image); hold on; 
plot(x(1,:), x(2,:), 'go', 'LineWidth', 1, 'MarkerSize', 15);
plot(x_est(1, :), x_est(2, :), 'k.', 'LineWidth', 2, 'MarkerSize', 15);

%% 5. Rotate cad by R
cad_r = cad;
cad_r.vertices = (R*cad_r.vertices')';
figure; trimesh(cad_r.faces, cad_r.vertices(:,1), cad_r.vertices(:,2), cad_r.vertices(:,3))

%% 6. Project cad
cad_p = cad.vertices;
cad_p(:, end+1) = 1;
cad_p = (P*cad_p')';
cad_p = cad_p(:, 1:2) ./ cad_p(:, end);
figure; 
ax = axes;
imshow(image); hold on; patch(ax, 'Faces', cad_r.faces, 'Vertices', cad_p, 'FaceColor', 'red', 'FaceAlpha', .3, 'EdgeColor', 'none'); hold on;

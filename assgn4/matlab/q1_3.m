load('../data/bunny.mat', 'N');

figure; axis tight; 
quiver(N(:,:,1), N(:,:,2)); set(gca, 'YDir','reverse')
imwrite(getframe(gcf).cdata, '../results/q1_3_quiver.jpg');
[h, w, ~] = size(N);

rot_x = @(x) [1 0 0; 0 cosd(x) -sind(x); 0 sind(x) cosd(x)];
rot_y = @(x) [cosd(x) 0 sind(x); 0 1 0; -sind(x) 0 cosd(x)];

s = rot_x(-45)*[0;0;1];
imwrite(reshape(max(sum(reshape(N, [], 3) * s, 2), 0), h, w), '../results/q1_3_45u.jpg');

s = rot_y(45)*[0;0;1];
imwrite(reshape(max(sum(reshape(N, [], 3) * s, 2), 0), h, w), '../results/q1_3_45r.jpg');

s = rot_y(75)*[0;0;1];
imwrite(reshape(max(sum(reshape(N, [], 3) * s, 2), 0), h, w), '../results/q1_3_75r.jpg');
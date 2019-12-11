load('../data/PhotometricStereo/sources.mat', 'S');

for i=1:7
  img = imread(sprintf('../data/PhotometricStereo/female_%02d.tif', i));
  img = rgb2gray(img);
  img = im2double(img);
  if i==1
     [h, w] = size(img);
     I = zeros(h*w, 7);
  end
  I(:, i) = img(:);  
end

N = (S\I')';
N = reshape(N, h, w, 3);

figure; 
quiver(N(:,:,1), N(:,:,2)); set(gca, 'YDir','reverse'); axis square; 
imwrite(getframe(gcf).cdata, '../results/q1_4_quiver.jpg');

albedo = vecnorm(N, 2, 3);
imwrite(albedo, '../results/q1_4_albedo.jpg');

s = [0.58; -0.58; -0.58];
imwrite(reshape(max(sum(reshape(N, [], 3) * s, 2), 0), h, w), '../results/q1_4_render1.jpg');
s = [-0.58; -0.58; -0.58];
imwrite(reshape(max(sum(reshape(N, [], 3) * s, 2), 0), h, w), '../results/q1_4_render2.jpg');

z = integrate_frankot(N);
figure; 
surf(-z, zeros(h, w), 'LineStyle', 'none'); light; lighting gouraud;axis vis3d; 
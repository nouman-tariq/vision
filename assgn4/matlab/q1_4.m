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
albedo = vecnorm(N, 2, 3);
N = N ./ albedo;

figure; 
subplot(1,3,1);
quiver(N(:,:,1), N(:,:,2)); set(gca, 'YDir','reverse'); axis(gca, 'square'); title('Quiver x-y');

subplot(1,3,2);
quiver(N(:,:,1), N(:,:,3)); set(gca, 'YDir','reverse'); axis(gca, 'square'); title('Quiver x-z');


subplot(1,3,3);
quiver(N(:,:,2), N(:,:,3)); set(gca, 'YDir','reverse'); axis(gca, 'square'); title('Quiver y-z');

imwrite(albedo, '../results/q1_4_albedo.jpg');

s = [0.58; -0.58; -0.58];
imwrite(reshape(max(sum(reshape(N .* albedo, [], 3) * s, 2), 0), h, w), '../results/q1_4_render1.jpg');
s = [-0.58; -0.58; -0.58];
imwrite(reshape(max(sum(reshape(N .* albedo, [], 3) * s, 2), 0), h, w), '../results/q1_4_render2.jpg');

z = integrate_frankot(N);
figure; 
surf(-z, zeros(h, w), 'LineStyle', 'none'); light; lighting gouraud;axis vis3d; 
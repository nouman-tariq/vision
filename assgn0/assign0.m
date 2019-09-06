img = imread('data/banana_slug.tiff'); % read image

[Ysize, Xsize] = size(img); % size of image

fprintf('Size of image: [ ')
fprintf('%g ', size(img));
fprintf(']\n', size(img));
fprintf('Type of img: %s\n', class(img));

img = double(img); % converts to double

% clipping
img(img < 2047) = 2047;
img(img > 15000) = 15000;

% mapping to [0, 1]
img = (img - 2047) / (15000 - 2047);


% figure; imshow(min(1, img(1:10, 1:10) * 30));

% assume rggb
b = img(2:2:end, 2:2:end);
g1 = img(1:2:end, 2:2:end);
g2 = img(2:2:end, 1:2:end);
g = [g1(:), g2(:)];
r = img(1:2:end, 1:2:end);

% white balancing matrix, using white world assumption
wb_img = zeros(size(img));
wb_img(1:2:end, 1:2:end) = max(g, [], 'all')/max(r, [], 'all') * r;
wb_img(1:2:end, 2:2:end) = g1;
wb_img(2:2:end, 1:2:end) = g2;
wb_img(2:2:end, 2:2:end) = max(g, [], 'all')/max(b, [], 'all') * b;

img = wb_img;

% demosaic

b = img(2:2:end, 2:2:end);
g1 = img(1:2:end, 2:2:end);
g2 = img(2:2:end, 1:2:end);
r = img(1:2:end, 1:2:end);

% red channel

[Y, X] = meshgrid(1:2:Xsize, 1:2:Ysize);
r_dms = zeros(size(img));
r_dms(1:2:end, 1:2:end) = r;

[Yq, Xq] = meshgrid(1:2:Xsize, 2:2:Ysize);
r_dms(1:2:end, 2:2:end) = interp2(Y, X, r, Yq, Xq);
[Yq, Xq] = meshgrid(2:2:Xsize, 1:2:Ysize);
r_dms(2:2:end, 1:2:end) = interp2(Y, X, r, Yq, Xq);
[Yq, Xq] = meshgrid(2:2:Xsize, 2:2:Ysize);
r_dms(2:2:end, 2:2:end) = interp2(Y, X, r, Yq, Xq);

% blue channel

[Y, X] = meshgrid(2:2:Xsize, 2:2:Ysize);
b_dms = zeros(size(img));
b_dms(2:2:end, 2:2:end) = r;

[Yq, Xq] = meshgrid(1:2:Xsize, 2:2:Ysize);
b_dms(1:2:end, 2:2:end) = interp2(Y, X, b, Yq, Xq);
[Yq, Xq] = meshgrid(2:2:Xsize, 1:2:Ysize);
b_dms(2:2:end, 1:2:end) = interp2(Y, X, b, Yq, Xq);
[Yq, Xq] = meshgrid(1:2:Xsize, 1:2:Ysize);
b_dms(1:2:end, 1:2:end) = interp2(Y, X, b, Yq, Xq);

% green channel

[Y1, X1] = meshgrid(1:2:Xsize, 2:2:Ysize);
[Y2, X2] = meshgrid(2:2:Xsize, 1:2:Ysize);
g_dms = zeros(size(img));
g_dms(1:2:end, 2:2:end) = g1;
g_dms(2:2:end, 1:2:end) = g2;

[Yq, Xq] = meshgrid(1:2:Xsize, 1:2:Ysize);
g_dms(1:2:end, 1:2:end) = (interp2(Y1, X1, g1, Yq, Xq) + interp2(Y2, X2, g2, Yq, Xq)) / 2;
[Yq, Xq] = meshgrid(2:2:Xsize, 2:2:Ysize);
g_dms(2:2:end, 2:2:end) = (interp2(Y1, X1, g1, Yq, Xq) + interp2(Y2, X2, g2, Yq, Xq)) / 2;

% combination

img = cat(3, r_dms, g_dms, b_dms);

% brightening

img = img * 4 * max(rgb2gray(img), [], 'all');
ind = (img <= 0.0031308);
img(ind) = 12.92 * img(ind);
img(~ind) = (1+0.055) * img(~ind) .^ (1/2.4) - 0.055;

figure; imshow(img);

% compression

imwrite(img, 'image.png');
imwrite(img, 'image.jpg', 'Quality', 95);

imwrite(img, 'image-.jpg', 'Quality', 15); % barely indistinguisable. 

%% Initials

% load the image
raw = imread('data/banana_slug.tiff');

% print its size: 2856 x 4290
[Ysize, Xsize] = size(raw)

% print its data type: uint16, therefore 16 bits
class(raw)

% convert to double
raw = double(raw);

%% Linearization

% apply linear transform
black = 2047;
saturation = 15000;
lin_bayer = (raw - black) / (saturation - black);

% clip values outside of range
lin_bayer = max(0, min(lin_bayer, 1));

%% Identifying the correct Bayer pattern

% form quarter-resolution sub-images
im1 = lin_bayer(1:2:end, 1:2:end);
im2 = lin_bayer(1:2:end, 2:2:end);
im3 = lin_bayer(2:2:end, 1:2:end);
im4 = lin_bayer(2:2:end, 2:2:end);

% form quarter-resolution RGB images for each Bayer pattern type
im_grbg = cat(3, im2, im1, im3);
im_rggb = cat(3, im1, im2, im4);
im_bggr = cat(3, im4, im2, im1);
im_gbrg = cat(3, im3, im1, im2);

% display with some brightening, and choose the one that looks more natural
figure; imshow(im_grbg * 4); title('grbg');
figure; imshow(im_rggb * 4); title('rggb');
figure; imshow(im_bggr * 4); title('bggr');
figure; imshow(im_gbrg * 4); title('gbrg');

% rggb looks like the correct one, so we're keeping that

%% White balancing

% first, get the pixels of each color channel
red = lin_bayer(1:2:end, 1:2:end);
green1 = lin_bayer(1:2:end, 2:2:end);
green2 = lin_bayer(2:2:end, 1:2:end);
blue = lin_bayer(2:2:end, 2:2:end);

% white balancing under gray world assumption:
%	compute the means of each channel, note that for green we need to use
%	both green subimages
red_mean = mean(red(:));
green_mean = mean([green1(:); green2(:)]);
blue_mean = mean(blue(:));

%	create new image and assign white-balanced values
im_gw = zeros(size(lin_bayer));
im_gw(1:2:end, 1:2:end) = red * green_mean / red_mean;
im_gw(1:2:end, 2:2:end) = green1;
im_gw(2:2:end, 1:2:end) = green2;
im_gw(2:2:end, 2:2:end) = blue * green_mean / blue_mean;

% white balancing under white world assumption:
%	compute the means of each channel, note that for green we need to use
%	both green subimages
red_max = max(red(:));
green_max = max([green1(:); green2(:)]);
blue_max = max(blue(:));

%	create new image and assign white-balanced values
im_ww = zeros(size(lin_bayer));
im_ww(1:2:end, 1:2:end) = red * green_max / red_max;
im_ww(1:2:end, 2:2:end) = green1;
im_ww(2:2:end, 1:2:end) = green2;
im_ww(2:2:end, 2:2:end) = blue * green_max / blue_max;

%% Demosaicing

% select im to use for this part
im = im_ww;

% demosaic the red channel
[Y, X] = meshgrid(1:2:Xsize, 1:2:Ysize);
vals = im(1:2:end, 1:2:end);

dms = zeros(size(im));
dms(1:2:end, 1:2:end) = vals;

[Yin, Xin] = meshgrid(2:2:Xsize, 1:2:Ysize);
dms(2:2:end, 1:2:end) = interp2(Y, X, vals, Yin, Xin);
[Yin, Xin] = meshgrid(1:2:Xsize, 2:2:Ysize);
dms(1:2:end, 2:2:end) = interp2(Y, X, vals, Yin, Xin);
[Yin, Xin] = meshgrid(2:2:Xsize, 2:2:Ysize);
dms(2:2:end, 2:2:end) = interp2(Y, X, vals, Yin, Xin);

red_dms = dms;

% demosaic the blue channel
[Y, X] = meshgrid(2:2:Xsize, 2:2:Ysize);
vals = im(2:2:end, 2:2:end);

dms = zeros(size(im));
dms(1:2:end, 1:2:end) = vals;

[Yin, Xin] = meshgrid(1:2:Xsize, 1:2:Ysize);
dms(1:2:end, 1:2:end) = interp2(Y, X, vals, Yin, Xin);
[Yin, Xin] = meshgrid(1:2:Xsize, 2:2:Ysize);
dms(1:2:end, 2:2:end) = interp2(Y, X, vals, Yin, Xin);
[Yin, Xin] = meshgrid(2:2:Xsize, 1:2:Ysize);
dms(2:2:end, 1:2:end) = interp2(Y, X, vals, Yin, Xin);

blue_dms = dms;

% demosaic the green channel
[Y1, X1] = meshgrid(1:2:Xsize, 2:2:Ysize);
vals1 = im(1:2:end, 2:2:end);

[Y2, X2] = meshgrid(2:2:Xsize, 1:2:Ysize);
vals2 = im(2:2:end, 1:2:end);

dms = zeros(size(im));
dms(1:2:end, 2:2:end) = vals1;
dms(2:2:end, 1:2:end) = vals2;


[Yin, Xin] = meshgrid(1:2:Xsize, 1:2:Ysize);
dms(1:2:end, 1:2:end) = (interp2(Y1, X1, vals1, Yin, Xin)... 
						+ interp2(Y2, X2, vals2, Yin, Xin)) / 2;
[Yin, Xin] = meshgrid(2:2:Xsize, 2:2:Ysize);
dms(2:2:end, 2:2:end) = (interp2(Y1, X1, vals1, Yin, Xin)...
						+ interp2(Y2, X2, vals2, Yin, Xin)) / 2;

green_dms = dms;

im_rgb = cat(3, red_dms, green_dms, blue_dms);

%% Brightness adjustment and gamma correction

im_gray = rgb2gray(im_rgb);
percentage = 4;
im_rgb_brightened = im_rgb * percentage * max(im_gray(:));

im_final = zeros(size(im_rgb_brightened));
inds = (im_rgb_brightened <= 0.0031308);
im_final(inds) = 12.92 * im_rgb_brightened(inds);
im_final(~inds) = real(1.055 * im_rgb_brightened(~inds) .^ (1 / 2.4) - 0.055);

figure; imshow(im_final);
%% Parameters
alpha = 50;
k = 0.04;

%% Load image 1
img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');

%% getHarrisPoints
points = getHarrisPoints(double(rgb2gray(img)), alpha, k);
figure; imshow(img); hold on; plot(points(:, 2), points(:, 1), '*');

%% Load image 2
img = imread('../data/auditorium/sun_aadrvlcduunrbpul.jpg');

%% getHarrisPoints
points = getHarrisPoints(double(rgb2gray(img)), alpha, k);
figure; imshow(img); hold on; plot(points(:, 2), points(:, 1), '*');

%% Load image 3
img = imread('../data/bedroom/sun_aacyfyrluprisdrx.jpg');

%% getHarrisPoints
points = getHarrisPoints(double(rgb2gray(img)), alpha, k);
figure; imshow(img); hold on; plot(points(:, 2), points(:, 1), '*');
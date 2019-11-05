addpath('libsvm/matlab');

dataset = load('../data/traintest.mat');
cell_size = [4 4];
prepath = '../data/';

T1 = length(dataset.train_imagenames);  % training set size
K = 100;                                % keyword / feature size

%% Setup HOG bin boundaries and Features matrix
boundaries = zeros(K+1, 1);
for k = 2:K+1
    boundaries(k) = (k-1)/K;
end

%% Generate HOG features as normalized histograms
features = zeros(T1, K);
for i = 1:T1
    I = imread(strcat(prepath, dataset.train_imagenames{i}));
    features(i, :) = generateHOGFeature(I, boundaries, cell_size);
end

[acc] = eval_SVM(dataset, features, boundaries, cell_size, prepath, '-q -s 0 -t 3 -c 10000 -g 0.1')     % 52.5000

function [feature] = generateHOGFeature(I, boundaries, cell_size)
% A Forward pass to compute HOG features
K = size(boundaries, 1) - 1;
feature = zeros(K, 1);

if size(I, 3) == 3
    I = rgb2gray(I);
end
I = imbinarize(I);

hog = extractHOGFeatures(I, 'CellSize', cell_size);
for k = 1:K
    feature(k) = sum(boundaries(k) < hog & hog < boundaries(k+1));
end
feature = feature ./ sum(hog);
end

function [acc] = eval_SVM(dataset, features, boundaries, cell_size, prepath, options)
%% Train SVM
svm = svmtrain(dataset.train_labels', features, options);
disp('svm trained');

%% Generate features for test set
T2 = length(dataset.test_imagenames);
[~, K] = size(features);
hs = zeros(T2, K);
for i = 1:T2
    I = imread(strcat(prepath, dataset.test_imagenames{i}));
    hs(i, :) = generateHOGFeature(I, boundaries, cell_size);
end
disp('features generated');

%% Predict SVM
[~, acc, ~] = svmpredict(dataset.test_labels', hs, svm);
end
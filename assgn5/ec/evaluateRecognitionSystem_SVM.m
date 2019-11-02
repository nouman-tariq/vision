addpath('libsvm/matlab');

dataset = load('../data/traintest.mat');
vision_harris = load('../matlab/visionHarris.mat');

[acc_l, acc_r] = eval_SVM(dataset, vision_harris)

function [acc_l, acc_r] = eval_SVM(dataset, vision_method)
% Runs a recognition system evaulation using Support Vector Machine
% 
% dataset: dataset loaded from '../data/traintest.mat'
% vision_method: 'visionHarris.mat' or 'visionRandom.mat'
%
% Returns:
%   - acc_l: accuracy using linear kernel
%   - acc_r: accuracy using rbf (gaussian) kernel

T2 = length(dataset.test_imagenames);
[K, ~] = size(vision_method.dictionary);

hs = zeros([T2 K]);

svm_l = svmtrain(dataset.train_labels', vision_method.trainFeatures, '-t 0');
svm_r = svmtrain(dataset.train_labels', vision_method.trainFeatures, '-t 2');

for i = 1:T2
    I = imread(strcat('../data/', dataset.test_imagenames{i}));
    wordmap = getVisualWords(I, vision_method.filterBank, vision_method.dictionary);
    hs(i, :) = getImageFeatures(wordmap, K);
    fprintf('finished %d of %d\n', i, T2);
end

[~, acc_l, ~] = svmpredict(dataset.test_labels', hs, svm_l);
[~, acc_r, ~] = svmpredict(dataset.test_labels', hs, svm_r);
end
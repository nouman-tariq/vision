addpath('libsvm/matlab');
addpath('../matlab');

dataset = load('../data/traintest.mat');
load('../matlab/visionRandom.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');
save('visionSVM.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');
vision_svm = load('visionSVM.mat');

[acc_l, acc_r] = eval_SVM(dataset, vision_svm, '../data/random/')

function [acc_l, acc_r] = eval_SVM(dataset, vision_method, prepath)
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

svm_l = svmtrain(dataset.train_labels', vision_method.trainFeatures, '-s 1 -t 0');
svm_r = svmtrain(dataset.train_labels', vision_method.trainFeatures, '-s 1 -t 2');

for i = 1:T2
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    hs(i, :) = getImageFeatures(wordMap, K);
    fprintf('finished %d of %d\n', i, T2);
end

[~, acc_l, ~] = svmpredict(dataset.test_labels', hs, svm_l);
[~, acc_r, ~] = svmpredict(dataset.test_labels', hs, svm_r);
end
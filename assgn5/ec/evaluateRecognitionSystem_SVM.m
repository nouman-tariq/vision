addpath('libsvm/matlab');
addpath('../matlab');

dataset = load('../data/traintest.mat');
load('../matlab/visionRandom.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');
save('visionSVM.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');
vision_svm = load('visionSVM.mat');

[acc_linear] = eval_SVM(dataset, vision_svm, '../data/random/', '-q -s 0 -t 0 -c 10000 -g 0.1')
[acc_rbf] = eval_SVM(dataset, vision_svm, '../data/random/', '-q -s 0 -t 2 -c 10000 -g 0.1')

function [acc] = eval_SVM(dataset, vision_method, prepath, options)
% Runs a recognition system evaulation using Support Vector Machine
% 
% dataset: dataset loaded from '../data/traintest.mat'
% vision_method: 'visionHarris.mat' or 'visionRandom.mat' or 'visionSVM.mat'
% prepath: parent directory path of test images
% options: string for setting kernel and other hyperparameters in svmtrain
%
% Returns:
%   - acc: accuracy

T2 = length(dataset.test_imagenames);
[K, ~] = size(vision_method.dictionary);

hs = zeros([T2 K]);

svm = svmtrain(dataset.train_labels', vision_method.trainFeatures, options);

for i = 1:T2
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    hs(i, :) = getImageFeatures(wordMap, K);
    % fprintf('finished %d of %d\n', i, T2);
end

[~, acc, ~] = svmpredict(dataset.test_labels', hs, svm);
end
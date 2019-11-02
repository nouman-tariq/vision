dataset = load('../data/traintest.mat');
vision_harris = load('../matlab/visionHarris.mat');

[C_l, C_r, acc_l, acc_r] = eval_SVM(dataset, vision_harris)

function [C_l, C_r, acc_l, acc_r] = eval_SVM(dataset, vision_method)
% Runs a recognition system evaulation using Support Vector Machine
% 
% dataset: dataset loaded from '../data/traintest.mat'
% vision_method: 'visionHarris.mat' or 'visionRandom.mat'
%
% Returns:
%   - C_l: confusion matrix using linear kernel
%   - C_r: confusion matrix using rbf (gaussian) kernel
%   - acc_l: accuracy using linear kernel
%   - acc_r: accuracy using rbf (gaussian) kernel

num_classes = size(dataset.mapping, 2);
C_l = zeros(num_classes, num_classes);
C_r = zeros(num_classes, num_classes);
predictions_l = zeros(size(dataset.test_labels));
predictions_r = zeros(size(dataset.test_labels));

[K, ~] = size(vision_method.dictionary);
[~, T] = size(vision_method.trainLabels);
hs_trained = reshape(vision_method.trainFeatures, [K T]);

svm_l = fitcecoc(hs_trained', dataset.train_labels, ...
    'Learners', templateSVM('KernelFunction', 'linear'));
svm_r = fitcecoc(hs_trained', dataset.train_labels, ...
    'Learners', templateSVM('KernelFunction', 'rbf'));

for i = 1:length(dataset.test_imagenames)
    I = imread(strcat('../data/', dataset.test_imagenames{i}));
    wordmap = getVisualWords(I, vision_method.filterBank, vision_method.dictionary);
    h = getImageFeatures(wordmap, K);
    
    predictions_l(i) = predict(svm_l, h');
    predictions_r(i) = predict(svm_r, h');
    true_i = dataset.test_labels(i);
    C_l(true_i, predictions_l(i)) = C_l(true_i, predictions_l(i)) + 1;
    C_r(true_i, predictions_r(i)) = C_r(true_i, predictions_r(i)) + 1;
    
    fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc_l = mean(predictions_l == dataset.test_labels);
acc_r = mean(predictions_r == dataset.test_labels);
end
dataset = load('../data/traintest.mat');
vision_harris = load('visionHarris.mat');
vision_random = load('visionRandom.mat');

[Ch_e, Ch_c, acch_e, acch_c] = eval_NN(dataset, vision_harris, '../data/harris/')
[Cr_e, Cr_c, accr_e, accr_c] = eval_NN(dataset, vision_random, '../data/random/')

function [C_e, C_c, acc_e, acc_c] = eval_NN(dataset, vision_method, prepath)
% Runs a recognition system evaulation using Nearest Neighbors
% 
% dataset: dataset loaded from '../data/traintest.mat'
% vision_method: 'visionHarris.mat' or 'visionRandom.mat'
%
% Returns:
%   - C_e, acc_e: confusion matrix and accuracy for using euclidean metric
%   - C_c, acc_c: confusion matrix and accuracy for using chi2 metric

%dataset.test_labels = dataset.train_labels;
%dataset.test_imagenames = dataset.train_imagenames;

num_classes = size(dataset.mapping, 2);
C_e = zeros(num_classes, num_classes);
C_c = zeros(num_classes, num_classes);
predictions_e = zeros(size(dataset.test_labels));
predictions_c = zeros(size(dataset.test_labels));

[K, ~] = size(vision_method.dictionary);

for i = 1:length(dataset.test_imagenames)    
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    
    h = getImageFeatures(wordMap, K);
    
    % Euclidean
    dists = getImageDistance(h, vision_method.trainFeatures', 'euclidean');
    [~, nn_idx] = min(dists);
    predictions_e(i) = vision_method.trainLabels(nn_idx);
    true_i = dataset.test_labels(i);
    C_e(true_i, predictions_e(i)) = C_e(true_i, predictions_e(i)) + 1;
    
    % Chi2
    dists = getImageDistance(h, vision_method.trainFeatures', 'chi2');
    [~, nn_idx] = min(dists);
    predictions_c(i) = vision_method.trainLabels(nn_idx);
    true_i = dataset.test_labels(i);
    C_c(true_i, predictions_c(i)) = C_c(true_i, predictions_c(i)) + 1;

    %fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc_e = mean(predictions_e == dataset.test_labels);
acc_c = mean(predictions_c == dataset.test_labels);
end
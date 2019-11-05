dataset = load('../data/traintest.mat');
vision_random = load('../matlab/visionRandom.mat');
addpath('../matlab');

[K, ~] = size(vision_random.dictionary);
[~, T] = size(vision_random.trainLabels);

load('idf.mat', 'idf');

% [C, acc, ~, k_best] = eval_kNN(1:40, dataset, vision_harris, idf)
[C_NN, acc_NN] = eval_NN(dataset, vision_random, idf, '../data/random/')
[C_kNN, acc_kNN, acc_k_kNN, k_best] = eval_kNN(1:40, dataset, vision_random, idf, '../data/random/')


function [C, acc] = eval_NN(dataset, vision_method, idf, prepath)
num_classes = size(dataset.mapping, 2);
C = zeros(num_classes, num_classes);
predictions = zeros(size(dataset.test_labels));

[K, ~] = size(vision_method.dictionary);
hs_trained = vision_method.trainFeatures;
hs_weighted = hs_trained .* idf;

for i = 1:length(dataset.test_imagenames)
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    h = getImageFeatures(wordMap, K);
    h = idf' .* h;
    
    dists = getImageDistance(h, hs_weighted', 'chi2');
    [~, nn_idx] = min(dists);
    predictions(i) = vision_method.trainLabels(nn_idx);
    true_i = dataset.test_labels(i);
    C(true_i, predictions(i)) = C(true_i, predictions(i)) + 1;

    % fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc = mean(predictions == dataset.test_labels);
end

function [C, acc, acc_k, k_best] = eval_kNN(ks, dataset, vision_method, idf, prepath)
% Runs a recognition system evaulation using k-Nearest Neighbors
% 
% ks: array of number of neighbors 'k' to try
% dataset: dataset loaded from '../data/traintest.mat'
% vision_method: 'visionHarris.mat' or 'visionRandom.mat'
%
% Returns:
%   - C: confusion matrix of the best k
%   - acc: accuracy of the best k
%   - acc_k: accuracies of all k
%   - k_best: best k

num_classes = size(dataset.mapping, 2);
C = zeros(num_classes, num_classes);
C_k = zeros(length(ks), num_classes, num_classes);  % (length(ks), C , C)
predictions_k = zeros([length(ks) size(dataset.test_labels, 2)]);  % (length(ks), M)

[K, ~] = size(vision_method.dictionary);
hs_trained = vision_method.trainFeatures;
hs_weighted = hs_trained .* idf;

for i = 1:length(dataset.test_imagenames)
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    
    h = getImageFeatures(wordMap, K);
    h = idf' .* h;

    for k = ks
        % Chi2
        dists = getImageDistance(h, hs_weighted', 'chi2');
        [~, ascendingIdx] = sort(dists);
        predictions_k(k, i) = mode(vision_method.trainLabels(ascendingIdx(1:k)));
        true_i = dataset.test_labels(i);
        C_k(k, true_i, predictions_k(k, i)) = C_k(k, true_i, predictions_k(k, i)) + 1;

    end
    % fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc_k = mean(predictions_k == dataset.test_labels, 2);
[~, k_best] = max(acc_k);
acc = acc_k(k_best);
C(:, :) = C_k(k_best, :, :);
end
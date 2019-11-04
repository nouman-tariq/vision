dataset = load('../data/traintest.mat');
vision_random = load('visionRandom.mat');
ks = 1:40;

[C, acc, acc_k, k_best] = eval_kNN(ks, dataset, vision_random, '../data/random/')

figure
plot(ks, acc_k)
title('kNN accuracy across k')
xlabel('k')
ylabel('accuracy')

function [C, acc, acc_k, k_best] = eval_kNN(ks, dataset, vision_method, prepath)
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

for i = 1:length(dataset.test_imagenames)
    matname = strcat(prepath, dataset.test_imagenames{i});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    
    h = getImageFeatures(wordMap, K);

    for k = ks
        % Chi2
        dists = getImageDistance(h, vision_method.trainFeatures', 'chi2');
        [~, ascendingIdx] = sort(dists);
        predictions_k(k, i) = mode(vision_method.trainLabels(ascendingIdx(1:k)));
        true_i = dataset.test_labels(i);
        C_k(k, true_i, predictions_k(k, i)) = C_k(k, true_i, predictions_k(k, i)) + 1;

        % fprintf('Finished %d of %d, k = %d\n', i, length(dataset.test_imagenames), k);
    end
    %fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc_k = mean(predictions_k == dataset.test_labels, 2);
[~, k_best] = max(acc_k);
acc = acc_k(k_best);
C(:, :) = C_k(k_best, :, :);
end
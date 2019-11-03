dataset = load('../data/traintest.mat');
vision_harris = load('../matlab/visionHarris.mat');
addpath('../matlab');

[K, ~] = size(vision_harris.dictionary);
[~, T] = size(vision_harris.trainLabels);
% Ignoring the latter half of K (50-100th words) because they are merged in
% the K-Means step
hs_trained = vision_harris.trainFeatures(:, 1:K/2);

idf = log(T ./ (sum(hs_trained > 0, 1) + eps));
save('idf.mat', 'idf');

% [C, acc, ~, k_best] = eval_kNN(1:40, dataset, vision_harris, idf)
[C, acc] = eval_NN(dataset, vision_harris, idf)

function [C, acc] = eval_NN(dataset, vision_method, idf)
num_classes = size(dataset.mapping, 2);
C = zeros(num_classes, num_classes);
predictions = zeros(size(dataset.test_labels));

[K, ~] = size(vision_method.dictionary);
hs_trained = vision_method.trainFeatures(:, 1:K/2);
hs_weighted = hs_trained .* idf;

for i = 1:length(dataset.test_imagenames)
    I = imread(strcat('../data/', dataset.test_imagenames{i}));
    wordmap = getVisualWords(I, vision_method.filterBank, vision_method.dictionary);
    h = getImageFeatures(wordmap, K);
    h = idf' .* h(1:K/2);
    
    dists = getImageDistance(h, hs_weighted', 'chi2');
    [~, nn_idx] = min(dists);
    predictions(i) = vision_method.trainLabels(nn_idx);
    true_i = dataset.test_labels(i);
    C(true_i, predictions(i)) = C(true_i, predictions(i)) + 1;

    fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
end
acc = mean(predictions == dataset.test_labels);
end

% function [C, acc, acc_k, k_best] = eval_kNN(ks, dataset, vision_method, idf)
% num_classes = size(dataset.mapping, 2);
% C = zeros(num_classes, num_classes);
% C_k = zeros(length(ks), num_classes, num_classes);  % (length(ks), C , C)
% predictions_k = zeros([length(ks) size(dataset.test_labels, 2)]);  % (length(ks), M)
% 
% [K, ~] = size(vision_method.dictionary);
% hs_trained = vision_method.trainFeatures(:, 1:K/2);
% hs_weighted = hs_trained .* idf;
% 
% for i = 1:length(dataset.test_imagenames)
%     I = imread(strcat('../data/', dataset.test_imagenames{i}));
%     wordmap = getVisualWords(I, vision_method.filterBank, vision_method.dictionary);
%     h = getImageFeatures(wordmap, K);
%     h = idf' .* h(1:K/2);
% 
%     for k = ks
%         % Chi2
%         dists = getImageDistance(h, hs_weighted', 'chi2');
%         [~, ascendingIdx] = sort(dists);
%         predictions_k(k, i) = mode(vision_method.trainLabels(ascendingIdx(1:k)));
%         true_i = dataset.test_labels(i);
%         C_k(k, true_i, predictions_k(k, i)) = C_k(k, true_i, predictions_k(k, i)) + 1;
% 
%         % fprintf('Finished %d of %d, k = %d\n', i, length(dataset.test_imagenames), k);
%     end
%     fprintf('Finished %d of %d\n', i, length(dataset.test_imagenames));
% end
% acc_k = mean(predictions_k == dataset.test_labels, 2);
% [~, k_best] = max(acc_k);
% acc = acc_k(k_best);
% C(:, :) = C_k(k_best, :, :);
% end
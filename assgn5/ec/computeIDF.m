vision_random = load('../matlab/visionRandom.mat');
[~, T] = size(vision_random.trainLabels);
hs_trained = vision_random.trainFeatures;

idf = log(T ./ (sum(hs_trained > 0, 1) + eps));
save('idf.mat', 'idf');
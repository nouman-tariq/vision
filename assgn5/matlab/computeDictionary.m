%% Load image names
load('../data/traintest.mat', 'all_imagenames');

%% Parameters
alpha = 50;
K = 100;
filterBank = createFilterBank();

%% Using 'random' method
dictionary = getDictionary(all_imagenames, alpha, K, 'random');
save('../result/dictionaryRandom.mat', 'filterBank', 'dictionary');

%% Using 'random' method
dictionary = getDictionary(all_imagenames, alpha, K, 'harris');
save('../result/dictionaryHarris.mat', 'filterBank', 'dictionary');

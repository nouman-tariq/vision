%% Load image names
load('../data/traintest.mat', 'train_imagenames');

%% Parameters
alpha = 500;
K = 100;
filterBank = createFilterBank();

%% Using 'random' method
dictionary = getDictionary(train_imagenames, alpha, K, 'random');
save('dictionaryRandom.mat', 'filterBank', 'dictionary');

%% Using 'harris' method
dictionary = getDictionary(train_imagenames, alpha, K, 'harris');
save('dictionaryHarris.mat', 'filterBank', 'dictionary');

%% Training data
load('../data/traintest.mat', 'train_imagenames', 'train_labels');
trainLabels = train_labels;
datadir = '../data/';

%% Random
load('dictionaryRandom.mat', 'dictionary', 'filterBank');
trainFeatures = [];
for i = 1:length(train_imagenames)
    matname = strcat(datadir, train_imagenames{1});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    trainFeatures = [trainFeatures; getImageFeatures(wordMap, size(dictionary, 1))];
end
save('visionRandom.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');

%% Harris
load('dictionaryHarris.mat', 'dictionary', 'filterBank');
trainFeatures = [];
for i = 1:length(train_imagenames)
    matname = strcat(datadir, train_imagenames{1});
    matname = strrep(matname,'.jpg','.mat');
    load(matname, 'wordMap');
    trainFeatures = [trainFeatures; getImageFeatures(wordMap, size(dictionary, 1))];
end
save('visionHarris.mat', 'dictionary', 'filterBank', 'trainFeatures', 'trainLabels');

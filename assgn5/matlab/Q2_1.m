%% Load image 1
img = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');

%% Load filterbank and dictionary
load('../result/dictionaryHarris.mat', 'filterBank');
dict_random = load('../result/dictionaryRandom.mat').dictionary;
dict_harris = load('../result/dictionaryHarris.mat').dictionary;

%% Get Visual Words
wordMap = getVisualWords(img, filterBank, dict_random);
figure; imshow(label2rgb(wordMap));

wordMap = getVisualWords(img, filterBank, dict_harris);
figure; imshow(label2rgb(wordMap));

%% Load image 2
img = imread('../data/auditorium/sun_aadrvlcduunrbpul.jpg');

%% Get Visual Words
wordMap = getVisualWords(img, filterBank, dict_random);
figure; imshow(label2rgb(wordMap));

wordMap = getVisualWords(img, filterBank, dict_harris);
figure; imshow(label2rgb(wordMap));

%% Load image 3
img = imread('../data/bedroom/sun_aacyfyrluprisdrx.jpg');

%% Get Visual Words
wordMap = getVisualWords(img, filterBank, dict_random);
figure; imshow(label2rgb(wordMap));

wordMap = getVisualWords(img, filterBank, dict_harris);
figure; imshow(label2rgb(wordMap));
function batchToVisualWords(numCores) 

% Does parallel computation of the visual words 
%
% Input:
%   numCores - number of cores to use (default 2)

if nargin < 1
    %default to 2 cores
    numCores = 2;
end

% Close the pools, if any
try
    fprintf('Closing any pools...\n');
%     matlabpool close; 
    delete(gcp('nocreate'))
catch ME
    disp(ME.message);
end

fprintf('Starting a pool of workers with %d cores\n', numCores);
% matlabpool('local',numCores);
parpool('local', numCores);

%load the files and texton dictionary
load('../data/traintest.mat','all_imagenames','mapping');
dictsHarris = load('./dictionaryHarris.mat');
dictsRandom = load('./dictionaryRandom.mat');

source = '../data/';
targetHarris = '../data/harris/'; 
targetRandom = '../data/random/';

if ~exist(targetHarris,'dir')
    mkdir(targetHarris);
end
if ~exist(targetRandom,'dir')
    mkdir(targetRandom);
end


for category = mapping
    if ~exist([targetHarris,category{1}],'dir')
        mkdir([targetHarris,category{1}]);
    end
    if ~exist([targetRandom,category{1}],'dir')
        mkdir([targetRandom,category{1}]);
    end
end

%This is a peculiarity of loading inside of a function with parfor. We need to 
%tell MATLAB that these variables exist and should be passed to worker pools.
fbHarris = dictsHarris.filterBank;
fbRandom = dictsRandom.filterBank;
dictHarris = dictsHarris.dictionary;
dictRandom = dictsRandom.dictionary;
all_imagenames = all_imagenames;

%matlab can't save/load inside parfor; accumulate
%them and then do batch save
l = length(all_imagenames);

wordRepresentationHarris = cell(l,1);
wordRepresentationRandom = cell(l,1);
parfor i=1:l
    fprintf('Converting to visual words %s\n', all_imagenames{i});
    image = imread([source, all_imagenames{i}]);
    if length(size(image)) == 2
        image = image(:,:,[1 1 1])
    end
    wordRepresentationHarris{i} = getVisualWords(image, fbHarris, dictHarris);
    wordRepresentationRandom{i} = getVisualWords(image, fbRandom, dictRandom);
end

%dump the files
fprintf('Dumping the files\n');
for i=1:l
    wordMap = wordRepresentationHarris{i};
    save([targetHarris, strrep(all_imagenames{i},'.jpg','.mat')],'wordMap');
    wordMap = wordRepresentationRandom{i};
    save([targetRandom, strrep(all_imagenames{i},'.jpg','.mat')],'wordMap');
end

%close the pool
fprintf('Closing the pool\n');
%matlabpool close

end

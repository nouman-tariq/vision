% Your solution to Q2.1.5 goes here!

%% Define hist array
hist = zeros(1, 37);

%% Read the image and convert to grayscale, if necessary
cv_cover = imread('../data/cv_cover.jpg');
if ndims(cv_cover) == 3
    cv_cover = rgb2gray(cv_cover);
end

%% Compute the features and descriptors
c1 = detectSURFFeatures(cv_cover);
[f1, vc1] = computeBrief(cv_cover, c1.Location);
f1 = binaryFeatures(uint8(f1));

for i = 0:36
    %% Rotate image
    rot = imrotate(cv_cover, i*10);
    
    %% Compute features and descriptors
    c2 = detectSURFFeatures(rot);
    [f2, vc2] = computeBrief(rot, c2.Location);
    f2 = binaryFeatures(uint8(f2));
    
    %% Match features
    indexPairs = matchFeatures(f1, f2, 'MaxRatio', 0.7);
    noFeatures = size(indexPairs, 1);
    locs1 = vc1(indexPairs(:,1),:);
    locs2 = vc2(indexPairs(:,2),:);

    %% Update histogram
    hist(i+1) = noFeatures;
    
    %% Save matches
    H = showMatchedFeatures(cv_cover, rot, locs1, locs2, 'montage');
    saveas(H, sprintf('../results/q2_1_5/surf/rot%d.png', i));
    
end

%% Display histogram
plot(0:36, hist)
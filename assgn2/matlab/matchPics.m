function [ locs1, locs2] = matchPics( I1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if ndims(I1) == 3
    I1 = rgb2gray(I1);
end
if ndims(I2) == 3
    I2 = rgb2gray(I2);
end

%% Detect features in both images
c1 = detectFASTFeatures(I1);
c2 = detectFASTFeatures(I2);

%% Obtain descriptors for the computed feature locations
[f1, vc1] = computeBrief(I1, c1.Location);
[f2, vc2] = computeBrief(I2, c2.Location);
f1 = binaryFeatures(uint8(f1));
f2 = binaryFeatures(uint8(f2));


%% Match features using the descriptors
indexPairs = matchFeatures(f1, f2, 'MaxRatio', 0.7);
locs1 = vc1(indexPairs(:,1),:);
locs2 = vc2(indexPairs(:,2),:);

end


function [ locs1, locs2] = matchPics_ec( f1, vc1, I2 )
%MATCHPICS Extract features, obtain their descriptors, and match them!

%% Convert images to grayscale, if necessary
if ndims(I2) == 3
    I2 = rgb2gray(I2);
end

%% Detect features in both images
c2 = detectFASTFeatures(I2);


%% Obtain descriptors for the computed feature locations
[f2, vc2] = extractFeatures(I2, c2.Location, 'Upright', true);

%% Match features using the descriptors
indexPairs = matchFeatures(f1, f2, 'MaxRatio', 0.73, 'Method', 'Approximate');
locs1 = vc1(indexPairs(:,1),:);
locs2 = vc2(indexPairs(:,2),:);

end


function [desc, locs] = computeBrief(img, locs_in)
load('../data/brief-indices.mat');
img_width = size(img, 2);
img_height = size(img, 1);

half = floor(pattern_size/2);
halfup = ceil(pattern_size/2);

counter = 1;
locs = zeros(1, 2);
for i = 1:length(locs_in)
    x = locs_in(i, 1);
    y = locs_in(i, 2);
    
    % If the requested location is close to the edges, we may not have
    % be able to generate a descriptor for them. Skip this.
    if x <= pattern_size || x >= (img_width-pattern_size) || y <= pattern_size || y >= (img_height-pattern_size)
        continue;
    end
    
    locs(counter, :) = locs_in(i, :);
    counter = counter + 1;
end

n = 256;
desc = zeros(size(locs, 1), n);

% Approximate decimal feature locations. A more accurate version
% would use interp
locs = round(locs);

for i = 1:length(locs)
    x = locs(i, 1);
    y = locs(i, 2);
    
    patch = img(y-half:y+half, x-half:x+half);
    for j = 1:256
        val_x = patch(compareX(j));
        val_y = patch(compareY(j));
        bit_value = (val_x < val_y);
        
        desc(i, j) = bit_value;
    end
end
end
function [dictionary] = getDictionary(imgPaths, alpha, K, method)
% Generate dictionary from images as specified by imgPaths.

    datadir = '../data/';
    pixelResponses = [];
    
    filterBank = createFilterBank();
    for i = 1:length(imgPaths)
        imgname = strcat(datadir, imgPaths{1});
        img = imread(imgname);
        filterResponses = reshape(extractFilterResponses(img, filterBank), ...
                                    [], 2*length(filterBank));
        
        img_gray = double(rgb2gray(img)) / 255;
        if strcmp(method, 'random')
            points = getRandomPoints(img_gray, alpha);
        else
            points = getHarrisPoints(img_gray, alpha, 0.04);
        end
        points = sub2ind(size(img), points(:,1), points(:,2));
        pixelResponses = [pixelResponses; filterResponses(points, :)];                    
    end
    [~, dictionary] = kmeans(pixelResponses, K, 'EmptyAction', 'drop')
end
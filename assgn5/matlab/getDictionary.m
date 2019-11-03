function [dictionary] = getDictionary(imgPaths, alpha, K, method)
% Generate dictionary from images as specified by imgPaths.

    datadir = '../data/';   
    filterBank = createFilterBank();
    T = length(imgPaths);
    n = length(filterBank);
    pixelResponses = zeros(alpha*T, 3*n);
        
    for i = 1:T
        imgname = strcat(datadir, imgPaths{1});
        img = imread(imgname);
        filterResponses = reshape(extractFilterResponses(img, filterBank), ...
                                    [], 3*length(filterBank));
        
        img_gray = double(rgb2gray(img));
        if strcmp(method, 'random')
            points = getRandomPoints(img_gray, alpha);
        else
            points = getHarrisPoints(img_gray, alpha, 0.06);
        end
        points = sub2ind(size(img), points(:,1), points(:,2));
        pixelResponses(alpha*(i-1)+1:alpha*i,:) = filterResponses(points, :);
    end
    [~, dictionary] = kmeans(pixelResponses, K, 'EmptyAction', 'drop');
end
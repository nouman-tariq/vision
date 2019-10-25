function [h] = getImageFeatures(wordMap, dictionarySize)
% getImageFeatures return a histogram on wordMap of size K = dictionarySize
h = tabulate(wordMap(:));
h = h(:, 2);
if max(wordMap) ~= dictionarySize
    h = [h; zeros(dictionarySize-length(h),1)];
end
h = h / sum(h);
end
function [wordMap] = getVisualWords(I, filterbank, dictionary)
% getVisualWords map each pixel in image I to its closest word in
% dictionary.

[H, W, ~] = size(I);
filterResponses = reshape(extractFilterResponses(I, filterbank),H*W,[]);
dist = pdist2(filterResponses, dictionary); % shape (H*W, K)
[~, wordMap] = min(dist, [], 2);
wordMap = reshape(wordMap, H, W);

end
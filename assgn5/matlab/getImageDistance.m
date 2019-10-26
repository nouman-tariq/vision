function [dist] = getImageDistance(hist1, histSet, method)
% getImageDistance compute the distance of hist1 with the list of vectors
% in histSet using method (could be 'euclidean' or 'chi2')
%
% hist1: (K, 1); histSet: (K, n)

if strcmp(method, 'chi2')
    method = @chi2;
end
dist = pdist2(hist1', histSet', method); % (1, n)


end

function [dist] = chi2(h1, h2)
% chi2 calculates the chi-squared distance of two histograms using the
% formula d(x,y) = sum( (xi-yi)^2 / (xi+yi) ) / 2;
dist = sum( (h1-h2).^2 ./ (h1+h2+eps) ) / 2;
end
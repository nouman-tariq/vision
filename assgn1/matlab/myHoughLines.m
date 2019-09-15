function [rhos, thetas] = myHoughLines(H, nLines)
%Your implemention here

    filter = ones(7, 7);
    filter(4, 4) = 0;

    H = (H >= imdilate(H, filter)) .* H;
    
    [~, ind] = maxk(H(:), nLines);
    [rhos, thetas] = ind2sub(size(H), ind);
end
        
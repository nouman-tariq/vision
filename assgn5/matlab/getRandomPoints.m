function [points] = getRandomPoints(I, alpha)
% getRandomPoints return alpha random points from the grayscale image I.
    [H, W] = size(I);
    points = [randi(H, alpha, 1) randi(W, alpha, 1)];    
end
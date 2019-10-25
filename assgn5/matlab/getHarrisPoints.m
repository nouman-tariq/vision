function [points] = getHarrisPoints(I, alpha, k)
% getHarrisPoints returns alpha Harris Points from the grayscale image I
% using the response threshold k.
Isize = size(I);
[Ix, Iy] = gradient(I);
[Ixx, Ixy] = gradient(Ix);
[Iyx, Iyy] = gradient(Iy);
M(:,1,1) = reshape(conv2(Ixx, ones(5), 'same'), [], 1, 1);
M(:,1,2) = reshape(conv2(Ixy, ones(5), 'same'), [], 1, 1);
M(:,2,1) = reshape(conv2(Iyx, ones(5), 'same'), [], 1, 1);
M(:,2,2) = reshape(conv2(Iyy, ones(5), 'same'), [], 1, 1);
detM = M(:,1,1) .* M(:,2,2) - M(:,1,2) .* M(:,2,1);
trM = M(:,1,1) + M(:,2,2);
R = detM - k*trM.^2;
[~, sortedInds] = sort(R,'descend');
bestk = sortedInds(1:alpha);
[row, col] = ind2sub(Isize, bestk);
points = [row, col];
end
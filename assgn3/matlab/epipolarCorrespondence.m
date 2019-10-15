function [pts2] = epipolarCorrespondence(im1, im2, F, pts1)
% epipolarCorrespondence:
%   Args:
%       im1:    Image 1
%       im2:    Image 2
%       F:      Fundamental Matrix from im1 to im2
%       pts1:   coordinates of points in image 1
%   Returns:
%       pts2:   coordinates of points in image 2
%
N = size(pts1, 1);
pts1n = [pts1, ones(N, 1)];
for i = 1:size(pts1, 1)
    line = F * pts1n(i, :)';
end

end
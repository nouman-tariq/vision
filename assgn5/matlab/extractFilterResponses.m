function [filterResponses] = extractFilterResponses(I, filterbank)
% extractFilterResponses extracts filter responses from image 'I' using the
% each filter in the filterbank
%   Args:
%       I:  (H, W, 3) RGB image
%       filterbank: (N, 1) filters
%
%   Returns:
%       filterResponses:  (H, W, 3*N)
%
[H, W, ~] = size(I);
N = size(filterbank, 1);
filterResponses = zeros(H, W, 3*N);

% figure; imshow(I); hold on;
I = double(I);

[L, a, b] = RGB2Lab(I(:, :, 1), I(:, :, 2), I(:, :, 3));
for n = 1:N
    h = filterbank{n, 1};
    filterResponses(:, :, 3*(n-1)+1) = imfilter(L, h);
    filterResponses(:, :, 3*(n-1)+2) = imfilter(a, h);
    filterResponses(:, :, 3*(n-1)+3) = imfilter(b, h);
end

%% Show images and filtered images
% figure; imshow([L a b]); hold on;
% filterIdx = 2; % 1..4
% scaleIdx = 3; % 1..5
% showIdx = 5*(filterIdx-1) + scaleIdx;
% figure; imshow([filterResponses(:, :, 3*(showIdx-1)+1)...
%                 filterResponses(:, :, 3*(showIdx-1)+2)...
%                 filterResponses(:, :, 3*(showIdx-1)+3)]);
end
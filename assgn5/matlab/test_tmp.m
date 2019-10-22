%
% A test script that drives the testing of implemented functions
%

im = imread('../data/airport/sun_aerinlrdodkqnypz.jpg');

% 4 filters * (5 scales)
% gaussian, laplacian of gaussian, x-grad of gaussian, y-grad of gaussian
[filterbank] = createFilterBank();
[responses] = extractFilterResponses(im, filterbank);
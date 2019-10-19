function dispM = get_disparity(im1, im2, maxDisp, windowSize)
% GET_DISPARITY creates a disparity map from a pair of rectified images im1 and
%   im2, given the maximum disparity MAXDISP and the window size WINDOWSIZE.
dispM = zeros(size(im1)) + maxDisp;
disp_min = zeros(size(im1)) + inf;

im1 = im1 ./ 255;
im2 = im2 ./ 255;

for d = 0:maxDisp
   im2d = imtranslate(im2, [d 0], 'FillValues', inf); 
   disp = conv2(im1.*im1 - 2.*im1.*im2d + im2d.*im2d, ones(windowSize, windowSize), 'same');
   %dispM = min(dispM, disp);
   dispM(disp<disp_min) = d;
   disp_min = min(disp_min, disp);
end

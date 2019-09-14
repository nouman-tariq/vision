function [img1] = myImageFilter(img0, h)
  [Hi, Wi] = size(img0);
  [Hh, Wh] = size(h);
  % Hh and Wh shall be odd, but may not be square
  % find the padding sizes
  Hp = (Hh - 1) / 2;
  Wp = (Wh - 1) / 2;
  % prepare img1 sizes
  img1 = zeros(Hi, Wi);
  % pad with closest edge intensities
  img0 = padarray(img0, [Hp, Wp], 'replicate');
  % convolution
  img0_slices = im2col(img0, [Hh, Wh]);
  img1(:) = sum(img0_slices(:, 1:Hi*Wi) .* h(:));
end

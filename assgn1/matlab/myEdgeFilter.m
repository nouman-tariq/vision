function [img1] = myEdgeFilter(img0, sigma)
%Your implemention
  img1 = zeros(size(img0));
  hsize = 2 * ceil(3 * sigma) + 1;
  h_gau = fspecial('gaussian', hsize, sigma);
 
  h_sobelx = [-1 -2 -1; 0 0 0; 1 2 1];
  h_sobely = h_sobelx';
  
  img_smooth = myImageFilter(img0, h_gau);
  imgx = myImageFilter(img_smooth, h_sobelx);
  imgy = myImageFilter(img_smooth, h_sobely);
  
  % NMS
  angles = rad2deg(atan2(imgy, imgx));
  amplitudes = sqrt(imgx .^ 2 + imgy .^ 2);
  
  angles(angles < 0) = angles(angles < 0) + 360;
  
  angles((337.5 <= angles | angles < 22.5) | ...
    (157.5 <= angles & angles < 202.5)) = 0;

  angles((22.5 <= angles & angles < 67.5) | ...
    (202.5 <= angles & angles < 247.5)) = 45;

  angles((67.5 <= angles & angles < 112.5) | ...
    (247.5 <= angles & angles < 292.5) | ...
    isnan(angles)) = 90;

  angles((112.5 <= angles & angles < 157.5) | ...
    (292.5 <= angles & angles < 337.5)) = 135;
  
  amplitudes_slices = im2col(padarray(amplitudes, [1 1]), [3 3]);
  c = 5;  % center
  % for each (angle, first neighbouring position, second neighbouring position)
  % for angle_pos = [0 2 8; 45 3 7; 90 4 6; 135 1 9]'
  for angle_pos = [0 4 6; 45 1 9; 90 2 8; 135 3 7]'
    idx_angle = angles == angle_pos(1);
    %%% TODO: do not output as staright white lines, may have suppressed too much
    suppress = ...
      amplitudes_slices(c, idx_angle) <= amplitudes_slices(angle_pos(2), idx_angle) ...
      | amplitudes_slices(c, idx_angle) <= amplitudes_slices(angle_pos(3), idx_angle);
    img1(idx_angle) = ~suppress' .* amplitudes(idx_angle);
  end

  %%% debug
  % imshow([amplitudes, img1, edge(img0, 'sobel')]);
  % imwrite(img1, 'my_sobel.jpg');
  %%% debugend
end
    
                
        
        

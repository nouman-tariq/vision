function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
%H_template_to_img = inv(H2to1);

%% Create mask of same size as template
% Pixels with ones represent the pixels template is located
mask = ones(size(template));

%% Warp mask by appropriate homography
% Project mask to img such that only pixels representing the template has
% logical 1
mask = logical(warpH(mask, H2to1, size(img)));

%% Warp template by appropriate homography
% Prepare properly the template that properly warps to img
warped_template = warpH(template, H2to1, size(img));

%% Use mask to combine the warped template and the image
% Change only the template pixels to the warped template
composite_img = img;
composite_img(mask) = warped_template(mask);

end
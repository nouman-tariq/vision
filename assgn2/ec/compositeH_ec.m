function [ composite_img, nextROI ] = compositeH_ec( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
%H_template_to_img = inv(H2to1);

%% Create mask of same size as template
% Pixels with ones represent the pixels template is located
% mask = ones(size(template));

%% Warp mask by appropriate homography
% Project mask to img such that only pixels representing the template has
% logical 1
template(:,:,4) = 1;

%% Warp template by appropriate homography
% Prepare properly the template that properly warps to img
% warped_template = warpH_ec(template, H2to1, size(img), 0, 'nearest');

out_size = size(img);
warped_template = imwarp(template, projective2d(H2to1'), 'OutputView', ...
                    imref2d(out_size(1:2), [1 out_size(2)], [1 out_size(1)]), ...
                    'FillValues', 0, ...
                    'interp', 'nearest');

%warped_template_rgb = warped_template(:,:,1:3);
% maskIdx = find(warped_template(:,:,4));
[row, col] = find(warped_template(:,:,4));

maskIdx = (col-1)*size(img,1)+row;
[m,n,~] = size(warped_template);

nextROI = [min(row) col(1); max(row) col(end)];
maskIdx = [maskIdx; m*n+maskIdx; 2*m*n+maskIdx];

%% Use mask to combine the warped template and the image
% Change only the template pixels to the warped template
composite_img = img;
composite_img(maskIdx) = warped_template(maskIdx);
end
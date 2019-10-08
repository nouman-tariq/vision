function [ composite_img ] = compositeH( H2to1, template, img )
%COMPOSITE Create a composite image after warping the template image on top
%of the image using the homography

% Note that the homography we compute is from the image to the template;
% x_template = H2to1*x_photo
% For warping the template to the image, we need to invert it.
H_template_to_img = inv(H2to1);

% size(H2to1)     % erect template to warped cv_cover in img
% size(template) % hp_cover with cv_cover size
% size(img)       % destination img with warped cv_cover

%% Create mask of same size as template
[Ht, Wt] = size(template);
mask = zeros(Ht, Wt);

%% Warp mask by appropriate homography
% warp mask to warped-in-img
% as marker
[Yt, Xt] = meshgrid(1:Ht, 1:Wt);
coords = [Y(:) X(:) ones(Ht*Wt, 1)];
mask = (H_template_to_img * coords')';

%% Warp template by appropriate homography
% warp hp_cover to warped-in-img
%wrapH

%% Use mask to combine the warped template and the image
% overlay mask onto template
% apply mask to img
composite_img = img;
composite_img(mask) = template;

end
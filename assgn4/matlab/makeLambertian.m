function imout=makeLambertian(im, s)
[h, w, ~] = size(im);
im = reshape(im, [], 3);
im = im2double(im);

imout = vecnorm(im * null(s), 2, 2);

imout = reshape(imout, h, w);
end
im = imread('../data/fruitbowl.png');
s = [0.6257, 0.5678 0.5349];

imout = makeLambertian(im, s);

imwrite(imout ./ max(imout(:)), '../results/q1_5.jpg');

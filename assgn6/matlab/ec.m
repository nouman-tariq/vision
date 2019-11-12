% Predict handwriting from images
[p1, ~] = predict('../images/image1.JPG', 64);
figure; imshow(p1);
[p2, ~] = predict('../images/image2.JPG', 64);
figure; imshow(p2);
[p3, ~] = predict('../images/image3.png', 32);
figure; imshow(p3);
[p4, ~] = predict('../images/image4.jpg', 16);
figure; imshow(p4);


function [out_img, bboxes] = predict(path, fontsize)
% predict takes in the image specified in path to predict handwritten digits.
% Parameters:
%  path: image path
%  fontsize: how large to display the text in image
% Returns:
%  out_img: original image with prediction annotation.
%  bboxes: bounding boxes for each digit

    %% Network defintion
    layers = get_lenet();
    layers{1}.batch_size = 1;
    load('lenet.mat');

    %% Load image
    img = imread(path);
    if ndims(img) == 3
        img = rgb2gray(img);
    end
    img = imbinarize(img);

    out_img = double(img);

    %% Find connected component
    [L, n] = bwlabel(1.-img);
    bboxes = cell(1, n);
    for i=1:n
       % for each connected component
       [r, c] = find(L==i);
       bboxes{i} = img(min(r):max(r), min(c):max(c));
       mr = min(r);
       mc = min(c);
       [r, c] = size(bboxes{i});

       % heuristics for how much to dilate, small bwratio => thin digit
       bwratio = sum(bboxes{i}==0, 'all') / (r*c);
       
       % remove noisy components
       if r < 5 && c < 5
           continue
       end
       
       % pad white
       if r > c
          bboxes{i} = padarray(bboxes{i}, [0 floor((r-c)/2)], 1);
       else
          bboxes{i} = padarray(bboxes{i}, [floor((c-r)/2) 0], 1); 
       end

       % dilate if digit is thin
       if bwratio < 0.2
            bboxes{i} = logical(1.-imdilate(1.-bboxes{i}, strel('sphere', 3)));
       end
       
       % reshape to (28-2*rs , 28-2*rs), in a way provide padding
       % squeeze more if image is not square-ish => make it more square-ish
       if max([r, c]) > 100 && (r/c-1) > 0.5
           rs = 5;
       else
           if max([r, c]) > 100 
             rs = 4; 
           else % if original image too small => can't put it smaller
             rs = 0;
           end
       end
       
       bboxes{i} = imresize(bboxes{i}, [28-2*rs 28-2*rs], 'nearest')';
       bboxes{i} = padarray(bboxes{i}, [rs rs], 1);
       [~, P] = convnet_forward(params, layers, logical(1.-bboxes{i}(:)));
       [~, idx] = max(P);

       out_img = insertText(out_img, [mc mr], idx-1, 'FontSize', fontsize); 
    end

end



p1 = predict('../images/image1.JPG', 0.25, 3, 64);
figure; imshow(p1);
p2 = predict('../images/image2.JPG', 0.2, 3, 64);
figure; imshow(p2);
p3 = predict('../images/image3.png', 0.1, 3, 32);
figure; imshow(p3);
p4 = predict('../images/image4.jpg', 0.1, 0, 16);
figure; imshow(p4);


function [out_img] = predict(path, pad, dilate, fontsize)
% predict takes in the image specified in path to predict handwritten digits.
% Parameters:
%  pad: how much to zero-pad the image before resize
%  dilate: how much to dilate the image to make the digits thicker
%  fontsize: how large to display the text in image
% Returns:
%  out_img: original image with prediction annotation.

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

       % remove noisy components
       if r < 5 && c < 5
           continue
       end

       p = ceil(max([r c]) * pad);

       %pad white
       if r > c
          bboxes{i} = padarray(bboxes{i}, [p floor((r-c)/2)+p], 1);
       else
          bboxes{i} = padarray(bboxes{i}, [floor((c-r)/2)+p p], 1); 
       end

       % dilate if digit is thin
       if dilate > 0
            bboxes{i} = logical(1.-imdilate(1.-bboxes{i}, strel('sphere', dilate)));
       end
       % reshape
       bboxes{i} = imresize(bboxes{i}, [28 28])';
       [~, P] = convnet_forward(params, layers, logical(1.-bboxes{i}(:)));
       [~, idx] = max(P);

       out_img = insertText(out_img, [mc mr], idx-1, 'FontSize', fontsize); 

    end

end


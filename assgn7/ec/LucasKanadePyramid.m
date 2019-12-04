function [u,v] = LucasKanadePyramid(It, It1, rect)
% Improvement on LK tracker where it is tracked on image pyramid.
%
% Params:
%   It: Frame at time t
%   It1: Frame at time t+1
%   rect: Bounding box at time t, specified as [x, y, w, h]
% Returns:
%   (u, v): Parameters of transformation

% 1. Calculate the depth of pyramid assuming the smallest level has
% 128x128 image size.
max_levels = floor(log2(min(size(It)) / 128))+1;

% 2. For each level, compute pyramid with resized image.
pyramidt = cell(max_levels, 1); pyramidt1 = cell(max_levels, 1);
pyramidt{1} = It; pyramidt1{1} = It1;

for level=2:max_levels
    pyramidt{level} = impyramid(pyramidt{level-1}, 'reduce');
    pyramidt1{level} = impyramid(pyramidt1{level-1}, 'reduce');
end

% 3. For each level, run LucasKanade
old_rect = rect;
for level=max_levels:-1:1
    factor = 2^(level-1);
    [du, dv] = LucasKanadeFixedTemplate(pyramidt{level}, pyramidt1{level}, ...
                old_rect ./ [factor factor 1 1], rect ./ [factor factor 1 1]);
    rect(1) = rect(1) + du * factor; rect(2) = rect(2) + dv * factor;
end
u = rect(1) - old_rect(1); v = rect(2) - old_rect(2);
end


function [u,v] = LucasKanadeFixedTemplate(It, It1, trect, rect)
% Subroutine for LKPyramid with fixed template rect.
%
% Params:
%   It: Frame at time t
%   It1: Frame at time t+1
%   trect: Bounding box at time t, specified as [x, y, w, h]
%   rect: Currnet bounding box at time t+1, specified as [x, y, w, h]
% Returns:
%   (u, v): Parameters of transformation

u = 0; v = 0;
deltap = inf;

It = im2double(It);
It1 = im2double(It1);

x = trect(1); y = trect(2); w = trect(3); h = trect(4);
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(It, Xq, Yq);

[It1x, It1y] = gradient(It1);
n_iter = 0;

x = rect(1); y = rect(2); w = rect(3); h = rect(4);
while (norm(deltap) > 0.01) && (n_iter < 1000)

    % 1. Warp image
    [Xq, Yq] = meshgrid((x:x+w-1)+u, (y:y+h-1)+v);
    warpedI = interp2(It1, Xq, Yq);

    % 2. Compute error of images
    error = template - warpedI;
    % disp('error'); disp(norm(error));
    
    % 3. Compute gradient
    warpedIx = interp2(It1x, Xq, Yq);
    warpedIy = interp2(It1y, Xq, Yq);
    gradI = [warpedIx(:) warpedIy(:)];

    % 4. Compute Jacobian
    %    Since we are using a translation transformation, given by
    %                ⌈ 1  0  u ⌉ ⌈ x ⌉
    %     W(x; p) =  ⌊ 0  1  v ⌋ | y |
    %                            ⌊ 1 ⌋
    %    we have the Jacobian as
    %     dW(x; p)/dp =  ⌈ 1  0 ⌉ 
    %                    ⌊ 0  1 ⌋ 
    %    Hence, we can just omit it.

    % 5. Compute Hessian
    hessian = gradI' * gradI;

    % 6. Compute delta p
    deltap = gradI' * error(:);
    deltap = hessian \ deltap;
    
    % 7. Update p
    u = u + deltap(1); v = v + deltap(2);
    
    n_iter = n_iter + 1;
       
end
if isnan(u) || isnan(v)
    u = 0; v = 0;
end

end

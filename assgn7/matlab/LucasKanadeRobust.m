function [u,v] = LucasKanadeRobust(It, It1, rect)
% Improvement on LK tracker where the brightness of pixels in the tracked
% region stays the same as the average brightness of pixels in the
% template, and used Huber M-estimator as optimisation.
%
% Params:
%   It: Frame at time t
%   It1: Frame at time t+1
%   rect: Bounding box at time t, specified as [x, y, w, h]
% Returns:
%   (u, v): Parameters of transformation

u = 0; v = 0;
deltap = inf;

It = im2double(It);
It1 = im2double(It1);

x = rect(1); y = rect(2); w = rect(3); h = rect(4); M = w*h;
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(It, Xq, Yq);
templateB = mean(template(:));

[It1x, It1y] = gradient(It1);
n_iter = 0;

while (norm(deltap) > 0.01) && (n_iter < 1000)

    % 1. Warp image
    [Xq, Yq] = meshgrid((x:x+w-1)+u, (y:y+h-1)+v);
    warpedI = interp2(It1, Xq, Yq);

    % 1.5. Scale brightness
    warpedIB = mean(warpedI(:));
    warpedI = warpedI * templateB / warpedIB;
    
    % 2. Compute error of images
    error = template - warpedI;
    error = error(:);
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

    % 4.5. Compute weights using Huber M-estimator
    %      Denote e as the residue at a pixel, the Huber M-estimator
    %      specifies its weights to be:
    %      w(e) = 1      if |e| <= k;
    %      w(e) = k/|e|  if |e| >  k,
    %      where k = 1.345 sigma.
    %      Source: http://users.stat.umn.edu/~sandy/courses/8053/handouts/robust.pdf
    k = 1.345 * std(error);
    weights = ones(M, 1);
    weights(abs(error)>k) = k./abs(error(abs(error)>k));
    
    % 5. Compute (weighted) Hessian
    hessian = gradI' .* weights' * gradI;

    % 6. Compute delta p
    deltap = gradI' .* weights' * error;
    deltap = hessian \ deltap;
    
    % 7. Update p
    u = u + deltap(1); v = v + deltap(2);
    
    n_iter = n_iter + 1;
   
end
if isnan(u) || isnan(v)
    u = 0; v = 0;
end

end

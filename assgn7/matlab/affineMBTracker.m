function [Wout] = affineMBTracker(img, tmp, rect, Win, context)
% Params:
%   img: greyscale image of the current frame
%   tmp: template image
%   rect: bounding box specifying the template region to track
%   Win: warp matrix for previous frame
%   context: affineMBContext struct with precomputed jacobian and hessian
% Returns:
%   Wout: warp matrix for current frame

x = rect(1); y = rect(2); w = rect(3); h = rect(4);
img = im2double(img);
tmp = im2double(tmp);

img = img * 225;
tmp = tmp * 225;

[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
points = double([Xq(:), Yq(:), ones(prod(size(Xq)), 1)]);

dp = inf;
n_iters = 0;
while (norm(dp) >= 0.1) && (n_iters < 100)
    %disp('n_iters'); disp(n_iters);
    
    % 1. Warp image
    warped_img = imwarp(img, affine2d(Win'));
%     imshow(warped_img)
%     pause
    warped_points = Win * points';
    warped_Xq = reshape(warped_points(1, :), size(Xq));
    warped_Yq = reshape(warped_points(2, :), size(Yq));
    warped = interp2(warped_img, warped_Xq, warped_Yq);
    imshow(warped)
    idx = find(isnan(warped));
    if ~isempty(idx)
        warped(idx) = 0;
    end
    
    % 2. Compute error image
    error = (warped - tmp);
    
    % 6. Compute delta_p
    dp = context.invH * context.J' * error(:); % (6,6) * (m,6)' * (m,1)
    %disp('dp'); disp(dp');
    
    % 7. Update parameters
    W_dp = [ 1+dp(1)    dp(3)      dp(5);
             dp(2)      1+dp(4)    dp(6);
             0          0          1    ];
         
    Wout = Win * inv(W_dp);
    %Wout = Win / W_dp;
    %disp('Wout'); disp(Wout);
    
    n_iters = n_iters + 1;
    Win = Wout;
    
%     fprintf('n_iters %d: error %f; dp %f\n', n_iters, norm(error), norm(dp));
end
end
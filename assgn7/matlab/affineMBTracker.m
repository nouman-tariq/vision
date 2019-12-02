function [Wout] = affineMBTracker(img, tmp, rect, Win, context)
% Params:
%   img: greyscale image of the current frame
%   tmp: template image
%   rect: bounding box specifying the template region to track
%   Win: warp matrix for previous frame
%   context: affineMBContext struct with precomputed jacobian and hessian
% Returns:
%   Wout: warp matrix for current frame

rect = int16(rect);
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
img = im2double(img);
tmp = im2double(tmp);
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));

dp = inf;

% logging
error_norms = zeros(50, 1);
dp_norms = zeros(50, 1);

n_iters = 0;
while (norm(dp) > 0.01) && (n_iters < 50)
    %disp('n_iters'); disp(n_iters);
    
    % 1. Warp image
    warped_img = imwarp(img, affine2d(Win'));
    %imshow(warped_img)
    
    warped_img_cropped = interp2(warped_img, double(Xq), double(Yq));
    
    % 2. Compute error image
    % tuning the divider to 225 makes image too stable that tracker does
    % not move; to 1 makes tracker moves around and image shaky
    error_img = (double(warped_img_cropped) - double(tmp)) / 50;
    
    % 6. Compute delta_p
    dp = context.invH * context.J' * error_img(:); % (6,6) * (m,6)' * (m,1)
    %disp('dp'); disp(dp');
    
    % 7. Update parameters
    W_dp = [ 1+dp(1)    dp(3)      dp(5);
             dp(2)      1+dp(4)    dp(6);
             0          0          1    ];
         
    %Wout = Win * inv(W_dp);
    Wout = Win / W_dp;
    %disp('Wout'); disp(Wout);
    
    n_iters = n_iters + 1;
    Win = Wout;
    
    error_norms(n_iters) = norm(error_img);
    dp_norms(n_iters) = norm(dp);
end
% plot(dp_norms)
% plot(error_norms)
% pause
end
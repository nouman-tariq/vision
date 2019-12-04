function [affineMBContext] = initAffineMBTracker(img, rect)

x = rect(1); y = rect(2); w = rect(3); h = rect(4);

[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
tmp = interp2(im2double(img), double(Xq), double(Yq));
tmp = tmp * 225;

%% 3. Evaluate gradient of template
[Tx, Ty] = gradient(tmp);
grad_T = [Tx(:) Ty(:)]';

%% 4. Evaluate jacobian
xs = 0:w-1;
ys = 0:h-1;
m = w * h;

dW_dp = zeros(2*m, 6);
dW_dp(1:2:end, 1) = reshape(repmat(xs', 1, h)', [m 1]);
dW_dp(2:2:end, 2) = reshape(repmat(xs', 1, h)', [m 1]);
dW_dp(1:2:end, 3) = repmat(ys, 1, w);
dW_dp(2:2:end, 4) = repmat(ys, 1, w);
dW_dp(:, 5) = repmat([1 0], 1, m);
dW_dp(:, 6) = repmat([0 1], 1, m);

%% 5. Compute steepest image gradT_J
affineMBContext.gradT_J = zeros(m, 6);
for pixel = 1:m
    affineMBContext.gradT_J(pixel, :) = grad_T(:, pixel)' * dW_dp((2*pixel-1:2*pixel), :);
end

%% 6. Compute hessian and then inverse
affineMBContext.invH = inv(affineMBContext.gradT_J' * affineMBContext.gradT_J);
end
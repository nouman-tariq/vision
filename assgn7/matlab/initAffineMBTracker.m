function [affineMBContext] = initAffineMBTracker(img, rect)
% rect: tracking target
x = rect(1); y = rect(2); w = rect(3); h = rect(4);
m = w * h;
img = im2double(img);

% template
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(img, Xq, Yq);
[Tx, Ty] = gradient(template);
grad_T = [ Tx(:) Ty(:) ]';
% grad_T: (2, m)

xs = x:x+w-1;
ys = y:y+h-1;

dW_dp = zeros(2*m, 6);
dW_dp(1:2:end, 1) = reshape(repmat(xs', 1, h)', [m 1]);
dW_dp(2:2:end, 2) = reshape(repmat(xs', 1, h)', [m 1]);
dW_dp(1:2:end, 3) = repmat(ys, 1, w);
dW_dp(2:2:end, 4) = repmat(ys, 1, w);
dW_dp(:, 5) = repmat([1 0], 1, m);
dW_dp(:, 6) = repmat([0 1], 1, m);
% dW_dp = [i 0 j 0 1 0;
%          0 i 0 j 0 1];
% dW_dp: (2*m, 6)

%J = grad_T(:)' * dW_dp;                     % (1, 6)
affineMBContext.J = zeros(m, 6);             % (m, 6)
for pixel = 1:m
    affineMBContext.J(pixel, :) = grad_T(:, pixel)' * dW_dp((2*pixel-1:2*pixel), :);
end
affineMBContext.invH = inv(affineMBContext.J' * affineMBContext.J);

%disp(grad_T(:))
%disp(dW_dp)
%disp(affineMBContext.J)
%disp(affineMBContext.invH)

end
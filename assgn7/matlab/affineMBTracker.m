function [Wout] = affineMBTracker(img, tmp, rect, Win, context)

if ~isa(img, 'double')
	img = double(img);
end
% img = img * 255;
% 
% tmp = tmp * 225;

w = rect(3); h = rect(4);

warp_p = Win(1:2, :);
warp_p(1,1) = warp_p(1,1) - 1;
warp_p(2,2) = warp_p(2,2) - 1;

corners = [1 1; 1 h; w h; w 1]';

n_iters = 100;
for i = 1:n_iters
    %% 1. Warp I with W(x;p)
    warped = warp_img(img, warp_p, corners);
    warped = warped * mean(tmp(:)) / mean(warped(:));
    
    %% 2. Compute error image
	error_img = warped - tmp;
    
    %% 7-8. Compute delta_p
    delta_p = context.invH * context.gradT_J' * error_img(:); % (6,6) * (m,6)' * (m,1)
	delta_p = reshape(delta_p, [2 3]);
	
	%% 9. Update warp
	warp_p = update_warp(warp_p, delta_p);
    
    %% delta_p norm termination criterion
    if norm(delta_p) <= 0.01 
        break;
    end
end
Wout = [warp_p(1)+1, warp_p(3), warp_p(5);
        warp_p(2), warp_p(4)+1, warp_p(6);
        0           0           1           ];
end

function warped_img = warp_img(img, warp_p, corners)
% warp_p = [p1 p3 p5; p2 p4 p6]
Win =  [warp_p(1)+1, warp_p(3), warp_p(5);
        warp_p(2), warp_p(4)+1, warp_p(6);
        0           0           1           ];
maxWH = max(corners');
W = maxWH(1); H = maxWH(2);
[Xq, Yq] = meshgrid(1:W, 1:H);
points = [Xq(:), Yq(:)];
points = [points, ones(size(points, 1), 1)];

warped_points = Win * points';
Xw = reshape(warped_points(1, :), size(Xq));
Yw = reshape(warped_points(2, :), size(Yq));
warped_img = interp2(img, Xw, Yw, 'bilinear');

idx = find(isnan(warped_img));
if ~isempty(idx)
    warped_img(idx) = 0;
end
end

function warp_p_updated = update_warp(warp_p, delta_p)
W_p =  [warp_p(1)+1, warp_p(3), warp_p(5);
        warp_p(2), warp_p(4)+1, warp_p(6);
        0           0           1           ];

W_dp =  [delta_p(1)+1, delta_p(3), delta_p(5);
        delta_p(2), delta_p(4)+1, delta_p(6);
        0           0           1           ];

W_p_updated = W_p * inv(W_dp);
warp_p_updated = W_p_updated(1:2, :);
warp_p_updated(1,1) = warp_p_updated(1,1) - 1;
warp_p_updated(2,2) = warp_p_updated(2,2) - 1;
end

% function warp_p = update_step(warp_p, delta_p)
% % Compute and apply the update
% 
% delta_p = reshape(delta_p, 2, 3);
% 	
% % Convert affine notation into usual Matrix form - NB transposed
% delta_M = [delta_p; 0 0 1];	
% delta_M(1,1) = delta_M(1,1) + 1;
% delta_M(2,2) = delta_M(2,2) + 1;
% 
% % Invert compositional warp
% delta_M = inv(delta_M);
% 
% % Current warp
% warp_M = [warp_p; 0 0 1];	
% warp_M(1,1) = warp_M(1,1) + 1;
% warp_M(2,2) = warp_M(2,2) + 1;
% 
% % Compose
% comp_M = warp_M * delta_M;	
% warp_p = comp_M(1:2,:);
% warp_p(1,1) = warp_p(1,1) - 1;
% warp_p(2,2) = warp_p(2,2) - 1;
% end
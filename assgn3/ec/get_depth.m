function depthM = get_depth(dispM, K1, K2, R1, R2, t1, t2)
% GET_DEPTH creates a depth map from a disparity map (DISPM).

%% 1. Optical centers
c1 = -inv(K1 * R1) * (K1 * t1);
c2 = -inv(K2 * R2) * (K2 * t2);

%% 2. Baseline
b = norm(c1-c2);

%% 3. Focal length
f = K1(1,1);

%% 4. depthM
depthM = b*f./dispM;
depthM(dispM == 0) = 0;

end
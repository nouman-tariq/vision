tracker = [164 123 297-164 235-123];  %[178 174 274-178 222-174]; %[126 108 336-126 276-108];
x = tracker(1); y = tracker(2); w = tracker(3); h = tracker(4);

%% Initialize the tracker
% figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prepath = '../data/car/';
frames = dir(strcat(prepath, '*.jpg'));

prev_frame = imread(strcat(prepath, frames(1).name));

% Selecting tracker
%imshow(prev_frame)
%ginput(2)
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(im2double(prev_frame), double(Xq), double(Yq));
h = size(template, 1);
w = size(template, 2);
tmplt_pts = [1 1; 1 h; w h; w 1]';

vid = VideoWriter('mb_car_.avi');
open(vid);

%% Start tracking
% initially, W(x; 0) so p = 0 for every estimation of p per frame
% new_tracker = tracker;
Win = [ 1 0 x; 0 1 y; 0 0 1 ];
p_init = [0 0 164; 0 0 123];
for i = 2:length(frames)
    new_frame = imread(strcat(prepath, frames(i).name));
    
    
    [fit, warp_p] = affine_ic(im2double(new_frame)*255, template*255, p_init, 0, 0);
%     Wout = affineMBTracker(new_frame, template, tracker, Win, context);


    M = [warp_p; 0 0 1];
    M(1,1) = M(1,1) + 1;
    M(2,2) = M(2,2) + 1;
    warp_pts =  M * [tmplt_pts; ones(1, size(tmplt_pts,2))];

    % xy = Wout * [tracker(1), tracker(2), 1]';
    
    % p_init = Wout;
    
    % new_tracker = [ xy(1), xy(2), w, h ];
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
    % rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    hold on;
    plot([warp_pts(1,:) warp_pts(1,1)], [warp_pts(2,:) warp_pts(2,1)], 'r-');
    drawnow;

%     tracker = new_tracker;
% %     Win = Wout;

    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);


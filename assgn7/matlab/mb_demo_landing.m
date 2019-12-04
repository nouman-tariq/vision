tracker = [440 90 565-440 135-90];
x = tracker(1); y = tracker(2); w = tracker(3); h = tracker(4);

%% Initialize the tracker
% figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prepath = '../data/landing/';
frames = dir(strcat(prepath, '*.jpg'));

prev_frame = imread(strcat(prepath, frames(1).name));

% imshow(prev_frame)
% ginput(2)
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(im2double(prev_frame), double(Xq), double(Yq));
tmp_corners = [1 1; 1 h; w h; w 1]';

context = initAffineMBTracker(prev_frame, tracker);

vid = VideoWriter('mb_landing.avi');
open(vid);

%% Start tracking
% initially, W(x; 0) so p = 0 for every estimation of p per frame
Win = [ 1 0 x; 0 1 y; 0 0 1 ];
p_init = [0 0 x; 0 0 y];
for i = 2:length(frames)
    new_frame = imread(strcat(prepath, frames(i).name));
    
    Wout = affineMBTracker(new_frame, template, tracker, Win, context);
    
    warp_pts =  Wout * [tmp_corners; ones(1, size(tmp_corners, 2))];
    
    Win = Wout;
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
    hold on;
    plot([warp_pts(1,:) warp_pts(1,1)], [warp_pts(2,:) warp_pts(2,1)], 'r-');
    % Frame #
    % annotation('textbox', [0.5, 0.5, 0, 0], 'string', sprintf('frame #%d', i), 'Color', 'Red');
    drawnow;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);


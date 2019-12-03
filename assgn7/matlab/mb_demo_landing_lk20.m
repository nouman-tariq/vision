tracker = [440 90 565-440 135-90];    %[444 86 560-444 130-86]; %[508 112 524-508 128-112];
x = tracker(1); y = tracker(2); w = tracker(3); h = tracker(4);

%% Initialize the tracker
figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prepath = '../data/landing/';
frames = dir(strcat(prepath, '*.jpg'));

prev_frame = imread(strcat(prepath, frames(1).name));

% imshow(prev_frame)
% ginput(2)
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = interp2(im2double(prev_frame), double(Xq), double(Yq));
h = size(template, 1);
w = size(template, 2);
tmplt_pts = [1 1; 1 h; w h; w 1]';

% context = initAffineMBTracker(prev_frame, tracker);

vid = VideoWriter('mb_landing_.avi');
open(vid);

%% Start tracking
% initially, W(x; 0) so p = 0 for every estimation of p per frame
Win = [ 1 0 x; 0 1 y; 0 0 1 ];
p_init = [0 0 x; 0 0 y];
for i = 2:length(frames)
%     fprintf('frame %d\n', i);
    new_frame = imread(strcat(prepath, frames(i).name));
    
    
    [fit, warp_p] = affine_ic(im2double(new_frame)*255, template*255, p_init, 0, 0);
%     Wout = affineMBTracker(new_frame, template, tracker, Win, context);
    
    M = [warp_p; 0 0 1];
    M(1,1) = M(1,1) + 1;
    M(2,2) = M(2,2) + 1;
    warp_pts =  M * [tmplt_pts; ones(1, size(tmplt_pts,2))];
    
    p_init = warp_p;
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
%     rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    hold on;
    plot([warp_pts(1,:) warp_pts(1,1)], [warp_pts(2,:) warp_pts(2,1)], 'r-');
    annotation('textbox', [0.5, 0.5, 0, 0], 'string', sprintf('frame #%d', i), 'Color', 'Red');
    drawnow;
    
    
%     tracker = new_tracker;
%     Win = Wout;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);


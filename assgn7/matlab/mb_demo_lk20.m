tracker = [124 103 337-124 275-103];   %[178 174 274-178 222-174]; %[126 108 336-126 276-108];
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

vid = VideoWriter('mb_car_.avi');
open(vid);

%% Start tracking
% initially, W(x; 0) so p = 0 for every estimation of p per frame
% new_tracker = tracker;
Win = [ 1 0 x; 0 1 y; 0 0 1 ];
for i = 2:length(frames)
    new_frame = imread(strcat(prepath, frames(i).name));
    
    
    [fit, Wout] = affine_ic(im2double(new_frame)*255, template*255, [0 0 124; 0 0 103], 0, 0);
%     Wout = affineMBTracker(new_frame, template, tracker, Win, context);

    xy = Wout * [tracker(1), tracker(2), 1]';
    new_tracker = [ xy(1), xy(2), w, h ];
    
    clf;
    hold on;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    drawnow;

%     tracker = new_tracker;
% %     Win = Wout;

    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);

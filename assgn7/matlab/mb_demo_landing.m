tracker = [443 90 560-443 131-90];    %[444 86 560-444 130-86]; %[508 112 524-508 128-112];
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

context = initAffineMBTracker(prev_frame, tracker);

vid = VideoWriter('mb_landing.avi');
open(vid);

%% Start tracking
% initially, W(x; 0) so p = 0 for every estimation of p per frame
new_tracker = tracker;
Win = eye(3);
for i = 2:length(frames)
%     fprintf('frame %d\n', i);
    new_frame = imread(strcat(prepath, frames(i).name));
    Wout = affineMBTracker(new_frame, template, tracker, Win, context);
    
    xy = Wout * [new_tracker(1) + w/2, new_tracker(2) + h/2, 1]';
    new_tracker = [ xy(1)/xy(3) - w/2, xy(2)/xy(3) - h/2, w, h ];
    
    clf;
    hold on;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    drawnow;
    
%     tracker = new_tracker;
%     Win = Wout;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);


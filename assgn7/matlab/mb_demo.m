tracker = [164 134 298-164 262-134];%[178 174 274-178 222-174]; %[126 108 336-126 276-108];
x = tracker(1); y = tracker(2); w = tracker(3); h = tracker(4);

%% Initialize the tracker
figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prepath = '../data/car/';
frames = dir(strcat(prepath, '*.jpg'));

prev_frame = imread(strcat(prepath, frames(1).name));

% Selecting tracker
%imshow(prev_frame)
%ginput(2)
[Xq, Yq] = meshgrid((x:x+w-1), (y:y+h-1));
template = uint8(interp2(double(prev_frame), double(Xq), double(Yq)));

context = initAffineMBTracker(prev_frame, tracker);

vid = VideoWriter('mb_car.avi');
open(vid);

%% Start tracking
new_tracker = tracker;
% initially, W(x; 0) so p = 0 for every estimation of p per frame
Win = eye(3);
for i = 2:length(frames)
    new_frame = imread(strcat(prepath, frames(i).name));
    Wout = affineMBTracker(new_frame, template, tracker, Win, context);
    %disp('Wout'); disp(Wout);
    
    new_t = Wout * [new_tracker(1) new_tracker(2) 1]';
    new_tracker = [ new_t(1) new_t(2) w h ];
    %disp('new_tracker'); disp(new_tracker);
    
    clf;
    hold on;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    drawnow;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);
end

close(vid);


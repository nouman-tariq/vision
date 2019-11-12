tracker = [1 1 100 100]         % TODO Pick a bounding box in the format [x y w h]
% You can use ginput to get pixel coordinates

%% Initialize the tracker
figure;

prev_frame = imread('../data/car/frame001.png');

%% Start tracking
new_tracker = tracker;
for i = 2:145
    new_frame = imread(sprintf('../data/car/frame%03d.png', i));
    [u, v] = LucasKanade(prev_frame, new_frame, tracker);

    clf;
    hold on;
    imshow(new_frame);   
    rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    drawnow;

    prev_frame = new_frame;
    tracker(1) = tracker(1) + u;
    tracker(2) = tracker(2) + v;
end


tracker = [1 1 100 100]         % TODO Pick a bounding box in the format [x y w h]
% You can use ginput to get pixel coordinates

%% Initialize the tracker
figure;

% TODO run the Matthew-Baker alignment in both landing and car sequences
prev_frame = imread('../data/landing/frame001.png');
template = ?? % TODO

context = initAffineMBTracker(prev_frame, tracker);

%% Start tracking
new_tracker = tracker;
for i = 2:145
    im = imread(sprintf('../data/landing/frame%03d.png', i));
    Wout = affineMBTracker(img, template, tracker, Win, context)

    new_tracker = ?? % TODO calculate the new bounding rectangle
    
    clf;
    hold on;
    imshow(im);   
    rectangle('Position', new_tracker, 'EdgeColor', [1 1 0]);
    drawnow;

    prev_frame = new_frame;
    tracker = new_tracker;
end


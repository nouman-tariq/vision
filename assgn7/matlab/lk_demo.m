% tracker = [124 103 337-124 275-103];
tracker = [164 143 297-164 235-143];
% tracker = [407 156 534-407 236-156];

%% Initialize the tracker
figure;

prev_frame = imread('../data/car/frame0020.jpg');

vid = VideoWriter('lk_car.avi');
open(vid);

%% Start tracking
for i = 21:280
    new_frame = imread(sprintf('../data/car/frame%04d.jpg', i));
    [u, v] = LucasKanade(prev_frame, new_frame, tracker);

    tracker(1) = tracker(1) + u;
    tracker(2) = tracker(2) + v;
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', tracker, 'EdgeColor', [1 1 0]);
    drawnow;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);

    prev_frame = new_frame;

end

close(vid);

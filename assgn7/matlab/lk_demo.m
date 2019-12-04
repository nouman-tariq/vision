addpath('../ec/');

% tracker = [124 103 337-124 275-103];
tracker = [168 145 295-168 255-145];
% tracker = [407 156 534-407 236-156];

%% Initialize the tracker
figure;

prev_frame = imread('../data/car/frame0020.jpg');

vid = VideoWriter('lk_car.avi');
open(vid);

trackerLK = tracker;
trackerLKR = tracker;
%% Start tracking
for i = 21:280
    new_frame = imread(sprintf('../data/car/frame%04d.jpg', i));
    [u, v] = LucasKanade(prev_frame, new_frame, trackerLK);
    
    trackerLK(1) = trackerLK(1) + u;
    trackerLK(2) = trackerLK(2) + v;
    
    [u, v] = LucasKanadeRobust(prev_frame, new_frame, trackerLKR);

    trackerLKR(1) = trackerLKR(1) + u;
    trackerLKR(2) = trackerLKR(2) + v;
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', trackerLK, 'EdgeColor', [1 1 0], 'LineWidth', 2);
    rectangle('Position', trackerLKR, 'EdgeColor', [1 0 1], 'LineWidth', 2);
    text(trackerLK(1), trackerLK(2)-15, 'LK Standard', 'Color', [1 1 0], 'FontSize', 14, 'FontWeight', 'bold');
    text(trackerLKR(1), trackerLKR(2)+trackerLKR(4)+15, 'LK Robust', 'Color', [1 0 1], 'FontSize', 14, 'FontWeight', 'bold');
    drawnow;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);

    prev_frame = new_frame;

end

close(vid);

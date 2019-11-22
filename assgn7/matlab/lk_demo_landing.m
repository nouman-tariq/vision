tracker = [443 90 560-443 131-90];

%% Initialize the tracker
figure;

prev_frame = imread('../data/landing/frame0190_crop.jpg');

files = dir('../data/landing/*.jpg');

vid = VideoWriter('lk_landing.avi');
open(vid);

%% Start tracking
for i = 2:length(files) 
    new_frame = imread(sprintf(strcat('../data/landing/', files(i).name), i));
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

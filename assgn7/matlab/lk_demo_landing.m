tracker = [443 90 560-443 131-90];

%% Initialize the tracker
figure;

prev_frame = imread('../data/landing/frame0190_crop.jpg');

files = dir('../data/landing/*.jpg');

vid = VideoWriter('lk_landing.avi');
open(vid);

%% Start tracking
trackerLK = tracker;
trackerLKP = tracker;
tLK = 0; tLKP = 0;
for i = 2:length(files) 
    new_frame = imread(sprintf(strcat('../data/landing/', files(i).name), i));
    tic;
    [u, v] = LucasKanade(prev_frame, new_frame, trackerLK);
    tLK = tLK + toc;
    
    trackerLK(1) = trackerLK(1) + u;
    trackerLK(2) = trackerLK(2) + v;
    
    tic;
    [u, v] = LucasKanadePyramid(prev_frame, new_frame, trackerLKP);
    tLKP = tLKP + toc;
    
    trackerLKP(1) = trackerLKP(1) + u;
    trackerLKP(2) = trackerLKP(2) + v;
    
    clf;
    hold on;
    axis tight;
    imshow(new_frame, 'border', 'tight');   
    rectangle('Position', trackerLK, 'EdgeColor', [1 1 0], 'LineWidth', 2);
    rectangle('Position', trackerLKP, 'EdgeColor', [1 0 1], 'LineWidth', 2);
    text(trackerLK(1), trackerLK(2)-15, 'LK Standard', 'Color', [1 1 0], 'FontSize', 14, 'FontWeight', 'bold');
    text(trackerLKP(1), trackerLKP(2)+trackerLKP(4)+15, 'LK Pyramid', 'Color', [1 0 1], 'FontSize', 14, 'FontWeight', 'bold');
    drawnow;
    
    frame = getframe(gcf);
    writeVideo(vid, frame.cdata);

    prev_frame = new_frame;

end
fprintf('LK Standard uses %.2f seconds.\n', tLK);
fprintf('LK Pyramid uses %.2f seconds.\n', tLKP);
close(vid);

function [H, rhoScale, thetaScale] = myHoughTransform(Im, threshold, rhoRes, thetaRes)
%Your implementation here
   
    % threshold the image
    Im(Im < threshold) = 0;
    
    % create theta scale
    rhoScale = linspace(0, sum(size(Im), 'all'), sum(size(Im), 'all') / rhoRes);
    thetaScale = linspace(0, 2*pi, 2*pi / thetaRes);
    
    % generate rho-theta pairs
    [Y, X] = find(Im);
    for theta = thetaScale
        rho = X * cos(theta) + Y * sin(theta);
        tH = histcounts2(rho, ones(size(rho)) * theta, rhoScale, thetaScale);
        
        if exist('H', 'var'); H = H + tH; else H = tH; end
        
    end
       
end
        
        
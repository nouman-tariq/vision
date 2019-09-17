function [lines] = myHoughLineSegments(lineRho, lineTheta, Im)
% lineRho: [rhos, rhoScale]
% lineTheta: [thetas, thetaScale], in radians
% Im: Image grad

tmp.point1 = [0,0];
tmp.point2 = [0,0];
lines = repmat(tmp,1,0);

rhos = lineRho{1};
rhoScale = lineRho{2};
rhoSlope = (length(rhoScale) - 1)/rhoScale(end);
thetas = lineTheta{1};
thetaScale = lineTheta{2};

numlines = 0; 

[y, x] = find(Im);

% zero origin
x = x-1;
y = y-1;

for k = 1:size(thetas)

  theta = thetaScale(thetas(k));
  rho = x*cos(theta) + y*sin(theta);
  rho_idx = round(rhoSlope*rho + 1);
  idx = find(rho_idx == rhos(k));

  xy = [x(idx)+1, y(idx)+1];
  if isempty(xy) 
    continue 
  end
  
  % sq. distance of (x_t, y_t) with (x_{t-1}, y_{t-1})
  dist_sq = sum(diff(xy,1,1).^2, 2);
  
  % skip if sq. dist. is small
  keep_idx = find(dist_sq > 25);
  idx = [0; keep_idx; size(xy,1)];
  for p = 1:length(idx) - 1
    p1 = xy(idx(p) + 1,:);
    p2 = xy(idx(p + 1),:);

    linelength_sq = sum((p2-p1).^2);
    if linelength_sq >= 400
      numlines = numlines + 1;
      lines(numlines).point1 = p1;
      lines(numlines).point2 = p2;
    end
  end
end





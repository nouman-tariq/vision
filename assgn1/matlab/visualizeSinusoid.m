theta = 0:0.25*pi:2*pi;
f = figure;
hold on
xlabel('theta')
set(gca,'XTick', theta)
set(gca,'XTickLabel',{'0','\pi/4','\pi/2', '3\pi/4'})
ylabel('rho')
p1 = sinusoid(10, 10);
p2 = sinusoid(20, 20);
p3 = sinusoid(30, 30);
legend([p1; p2; p3], '(10, 10)', '(20, 20)', '(30, 30)');
saveas(gcf, '../results/theory-q4.png')
hold off

function [p] = sinusoid(x, y)
    theta = 0:pi/10:2*pi;
    rho = x * cos(theta) + y * sin(theta);
    p = plot(theta, rho);
end
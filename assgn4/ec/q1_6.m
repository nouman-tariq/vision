R = csvread('../data/ciexyz64_1.csv');
load('../data/bananas.mat', 'ripe', 'overripe');
R = R((400:10:700)-(400-41), 2:end);
Lf = ripe .* R;
Lg = overripe .* R;

T = metameric(Lf, Lg);
fprintf('Optimal temperature = %.4fK\n', T);
figure;
l = 0.01:10:4000;
plot(l, blackbody(T, l)); xline(400); xline(700); xlabel('Wavelength (nm)'); ylabel('Intensity');
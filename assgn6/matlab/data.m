rand('seed', 100000)
randn('seed', 100000)

%% Network defintion
layers = get_lenet();
layers{1}.batch_size = 1;

%% Loading data
fullset = false;
[~, ~, ~, ~, xtest, ~] = load_mnist(fullset);

% load the trained weights
load lenet.mat

%% Running the network
[output, P] = convnet_forward(params, layers, xtest(:, 1));

d = reshape(output{2}.data, output{2}.height, output{2}.width, output{2}.channel);

figure; imshow(reshape(xtest(:,1),28,28)');

figure;
for i=1:20
   subplot(4,5,i);
   imshow(d(:,:,i)');
end

d = reshape(output{3}.data, output{3}.height, output{3}.width, output{3}.channel);

figure;
for i=1:20
   subplot(4,5,i);
   imshow(d(:,:,i)');
end


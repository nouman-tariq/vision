clear
rand('seed', 100000)
randn('seed', 100000)

%% Network defintion
layers = get_lenet();

%% Loading data
fullset = false;
[xtrain, ytrain, xvalidate, yvalidate, xtest, ytest] = load_mnist(fullset);

xtrain = [xtrain, xvalidate];
ytrain = [ytrain, yvalidate];
m_train = size(xtrain, 2);
batch_size = 100;

%%Parameters initalization
% - inv: return base_lr * (1 + gamma * iter) ^ (- power)
mu = 0.9;
epsilon = 0.01;
gamma = 0.0001;
power = 0.75;
weight_decay = 0.0005;
w_lr = 1;
b_lr = 2;

test_interval = 500;
display_interval = 100;
snapshot = 500;
max_iter = 3000;
no_epochs = 100;

%% Use the following to train from scratch
params = init_convnet(layers);


%% Load the network
load lenet_pretrained.mat

param_winc = params;
for l_idx = 1:length(layers)-1
    param_winc{l_idx}.w = zeros(size(param_winc{l_idx}.w));
    param_winc{l_idx}.b = zeros(size(param_winc{l_idx}.b));
end

%% Training the network
new_order = randperm(m_train);
xtrain = xtrain(:, new_order);
ytrain = ytrain(:, new_order);

curr_batch = 1;

for iter = 1 : max_iter
    
    if (curr_batch > m_train) 
        new_order = randperm(m_train);
        xtrain = xtrain(:, new_order);
        ytrain = ytrain(:, new_order);
        curr_batch = 1;
    end
        
    x_batch = xtrain(:, curr_batch:(curr_batch+batch_size-1));
    y_batch = ytrain(:, curr_batch:(curr_batch+batch_size-1));
    curr_batch = curr_batch + batch_size;
    
    [cp, param_grad] = conv_net(params, layers, x_batch, y_batch);

    for l_idx = 1:length(layers)-1
	% We have different epsilons for w and b. Calling get_lr and sgd_momentum twice.
	w_rate = get_lr(iter, epsilon*w_lr, gamma, power);
	[w_params, w_params_winc] = sgd_momentum(w_rate, mu, weight_decay, params, param_winc, param_grad);        

	b_rate = get_lr(iter, epsilon*b_lr, gamma, power);
	[b_params, b_params_winc] = sgd_momentum(b_rate, mu, weight_decay, params, param_winc, param_grad);        
	
	params{l_idx}.w = w_params{l_idx}.w;
	params_winc{l_idx}.w = w_params_winc{l_idx}.w;
	params{l_idx}.b = b_params{l_idx}.b;
	params_winc{l_idx}.b = b_params_winc{l_idx}.b;
    end
    if mod(iter, display_interval) == 0
        fprintf('cost = %f training_percent = %f\n', cp.cost, cp.percent);
    end
    if mod(iter, test_interval) == 0
        layers{1}.batch_size = size(xtest, 2);
        [cptest] = conv_net(params, layers, xtest, ytest);
        layers{1}.batch_size = batch_size;
        fprintf('test accuracy: %f \n\n', cptest.percent);

    end
    if mod(iter, snapshot) == 0
        filename = 'lenet.mat';
        save(filename, 'params');
    end
end

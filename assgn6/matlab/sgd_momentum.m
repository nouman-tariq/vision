function [params, param_winc] = sgd_momentum(rate, mu, weight_decay, params, param_winc, param_grad)
% update the parameter with sgd with momentum

%% function input
% rate (scalar): learning rate at current step - eps
% mu (scalar): momentum- mu
% weight_decay (scalar): weigth decay of w
% params (cell array): original weight parameters
% param_winc (cell array): buffer to store history gradient accumulation
% param_grad (cell array): gradient of parameter

%% function output
% params (cell array): updated parameters
% param_winc (cell array): updated buffer

%% function
for l_idx = 1:length(params)
    param_winc{l_idx}.w = mu*param_winc{l_idx}.w + rate * (param_grad{l_idx}.w + weight_decay * params{l_idx}.w);
    param_winc{l_idx}.b = mu*param_winc{l_idx}.b + rate * (param_grad{l_idx}.b);
    params{l_idx}.w = params{l_idx}.w - param_winc{l_idx}.w;
    params{l_idx}.b = params{l_idx}.b - param_winc{l_idx}.b;
end
end

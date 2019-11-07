function lr_t = get_lr(iter, epsilon, gamma, power)
% get the learning rate at step iter

lr_t = epsilon / (1 + gamma * iter)^power;
end

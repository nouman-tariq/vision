function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
param_grad.w = output.diff * input.data';   % (n,k) * (d,k)' = (n,d)
param_grad.b = sum(output.diff, 2);  % sum across batch_size of (n,k) = (n,1)
input_od = param.w' * output.diff;   % (n,d) * (n,k) = (d,k)

end

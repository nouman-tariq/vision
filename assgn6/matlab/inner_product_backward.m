function [param_grad, input_od] = inner_product_backward(output, input, layer, param)

% Replace the following lines with your implementation.
param_grad.w = input.data * output.diff';   % (d,k) * (n,k)' = (d,n)
param_grad.b = sum(output.diff, 2)';  % sum across batch_size of (n,k) = (n,1)
input_od = param.w * output.diff;   % (d,n) * (n,k) = (d,k)

end

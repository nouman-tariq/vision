function [cp, param_grad] = conv_net(params, layers, data, labels)
    
    l = length(layers);
    batch_size = layers{1}.batch_size;
    %% Forward pass
    output = convnet_forward(params, layers, data);
    
    %% Loss layer
    i = l;
    assert(strcmp(layers{i}.type, 'LOSS') == 1, 'last layer must be loss layer');

    wb = [params{i-1}.w(:); params{i-1}.b(:)];
    [cost, grad, input_od, percent] = mlrloss(wb, output{i-1}.data, labels, layers{i}.num, 0, 1);
    
    %% Back prop
    if nargout >= 2
        param_grad{i-1}.w = reshape(grad(1:length(params{i-1}.w(:))), size(params{i-1}.w));
        param_grad{i-1}.b = reshape(grad(end - length(params{i-1}.b(:)) + 1 : end), size(params{i-1}.b));
        param_grad{i-1}.w = param_grad{i-1}.w / batch_size;
        param_grad{i-1}.b = param_grad{i-1}.b /batch_size;
    end

    cp.cost = cost/batch_size;
    cp.percent = percent;

    if nargout >= 2
        for i = l-1:-1:2
            switch layers{i}.type
                case 'CONV'
                    output{i}.diff = input_od;
                    [param_grad{i-1}, input_od] = conv_layer_backward(output{i}, output{i-1}, layers{i}, params{i-1});
                case 'POOLING'
                    output{i}.diff = input_od;
                    [input_od] = pooling_layer_backward(output{i}, output{i-1}, layers{i});
                    param_grad{i-1}.w = [];
                    param_grad{i-1}.b = [];
                case 'IP'
                    output{i}.diff = input_od;
                    [param_grad{i-1}, input_od] = inner_product_backward(output{i}, output{i-1}, layers{i}, params{i-1});
                case 'RELU'
                    output{i}.diff = input_od;
                    [input_od] = relu_backward(output{i}, output{i-1}, layers{i});
                    param_grad{i-1}.w = [];
                    param_grad{i-1}.b = [];
                case 'ELU'
                    output{i}.diff = input_od;
                    [input_od] = elu_backward(output{i}, output{i-1}, layers{i});
                    param_grad{i-1}.w = [];
                    param_grad{i-1}.b = [];
            end
            param_grad{i-1}.w = param_grad{i-1}.w / batch_size;
            param_grad{i-1}.b = param_grad{i-1}.b / batch_size;
        end
    end
end

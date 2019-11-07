function [output, P] = convnet_forward(params, layers, data)
    l = length(layers);
    %batch_size = layers{1}.batch_size;
    assert(strcmp(layers{1}.type, 'DATA') == 1, 'first layer must be data layer');
    output{1}.data = data;
    output{1}.height = layers{1}.height;
    output{1}.width = layers{1}.width;
    output{1}.channel = layers{1}.channel;
    output{1}.batch_size = layers{1}.batch_size;
    output{1}.diff = 0;
    for i = 2:l-1
        switch layers{i}.type
            case 'CONV'
                output{i} = conv_layer_forward(output{i-1}, layers{i}, params{i-1});
            case 'POOLING'
                output{i} = pooling_layer_forward(output{i-1}, layers{i});
            case 'IP'
                output{i} = inner_product_forward(output{i-1}, layers{i}, params{i-1});
            case 'RELU'
                output{i} = relu_forward(output{i-1});
            case 'ELU'
                output{i} = elu_forward(output{i-1}, layers{i});
        end
    end
    if nargout > 1
        W = bsxfun(@plus, params{l-1}.w * output{l-1}.data, params{l-1}.b);
        W = [W; zeros(1, size(W, 2))];
        W=bsxfun(@minus, W, max(W));
        W=exp(W);

        % Convert to Probabilities by normalizing
        P=bsxfun(@rdivide, W, sum(W));
    end
end
function [input_od] = pooling_layer_backward(output, input, layer)
    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    
    input_od = zeros(size(input.data));
    input_od = reshape(input_od, [h_in* w_in*c*batch_size, 1]);
    im_b = reshape(input.data, [h_in, w_in, c, batch_size]);
    im_b = padarray(im_b, [pad, pad], 0);
    diff = reshape(output.diff, [h_out*w_out, c*batch_size]);
    for h = 1:h_out
        for w = 1:w_out
            matrix_hw = im_b((h-1)*stride + 1 : (h-1)*stride + k, (w-1)*stride + 1 : (w-1)*stride + k, :, :);
            flat_matrix = reshape(matrix_hw, [ k*k, c*batch_size]);
            [~, i1] = max(flat_matrix);
            [R, C] = ind2sub(size(matrix_hw), i1);
            nR = (h-1)*stride + R;
            nC = (w-1)*stride + C;
            i2 = sub2ind([h_in,w_in], nR, nC);
            i4 = sub2ind([h_in*w_in, c*batch_size], i2, 1:c*batch_size);
            i3 = sub2ind([h_out, w_out], h, w);
            input_od(i4, :) = input_od(i4, :) + diff(i3, :)';
        end
    end
    input_od = reshape(input_od, [h_in*w_in, c*batch_size]);
    input_od = reshape(input_od, [h_in*w_in*c,batch_size]);
end

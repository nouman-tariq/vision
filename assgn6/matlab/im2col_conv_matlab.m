function col = im2col_conv_matlab(input_n, layer, h_out, w_out)
h_in = input_n.height;
w_in = input_n.width;
c = input_n.channel;
k = layer.k;
pad = layer.pad;
stride = layer.stride;

im = reshape(input_n.data, [h_in, w_in, c]);
im = padarray(im, [pad, pad], 0);
col = zeros(k*k*c, h_out*w_out);
for h = 1:h_out
    for w = 1:w_out
        matrix_hw = im((h-1)*stride + 1 : (h-1)*stride + k, (w-1)*stride + 1 : (w-1)*stride + k, :);
        col(:, h + (w-1)*h_out) = matrix_hw(:);
    end
end
col = col(:);
end

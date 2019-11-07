function layers = get_lenet()

    layers{1}.type = 'DATA';
    layers{1}.height = 28;
    layers{1}.width = 28;
    layers{1}.channel = 1;
    layers{1}.batch_size = 100;

    layers{2}.type = 'CONV';
    layers{2}.num = 20;
    layers{2}.k = 5;
    layers{2}.stride = 1;
    layers{2}.pad = 0;
    layers{2}.group = 1;

    layers{3}.type = 'RELU';

    layers{4}.type = 'POOLING';
    layers{4}.k = 2;
    layers{4}.stride = 2;
    layers{4}.pad = 0;


    layers{5}.type = 'CONV';
    layers{5}.k = 5;
    layers{5}.stride = 1;
    layers{5}.pad = 0;
    layers{5}.group = 1;
    layers{5}.num = 50;

    layers{6}.type = 'RELU';

    layers{7}.type = 'POOLING';
    layers{7}.k = 2;
    layers{7}.stride = 2;
    layers{7}.pad = 0;

    layers{8}.type = 'IP';
    layers{8}.num = 500;
    layers{8}.init_type = 'uniform';

    layers{9}.type = 'RELU';

    layers{10}.type = 'LOSS';
    layers{10}.num = 10;

end

close all; clear; clc;

%% Parameters
dist = 'hausdorff';

for m = 1 : 12
for number_of_cluster = 2 : 10

%% The aggregated series after clustering
path = ['../data/load_data_clustered/' dist '/' num2str(m) '_' num2str(number_of_cluster) '_lower.csv'];
lower = load(path);
path = ['../data/load_data_clustered/' dist '/' num2str(m) '_' num2str(number_of_cluster) '_upper.csv'];
upper = load(path);

%% Generate training sample
len = size(lower, 2);

for j = 1 : number_of_cluster
    % train sample
    train(j).xl = [];
    train(j).xu = [];
    train(j).yl = [];
    train(j).yu = [];
    
    for i = 169 : len-24
        train(j).yl = [train(j).yl; lower(j, i)];
        tmp = [lower(j, i-24:i-1) lower(j, i-168)];
        train(j).xl = [train(j).xl; tmp];
        
        train(j).yu = [train(j).yu; upper(j, i)];
        tmp = [upper(j, i-24:i-1) upper(j, i-168)];
        train(j).xu = [train(j).xu; tmp];
        
    end
    % test sample
    test(j).xl = [];
    test(j).xu = [];
    test(j).yl = [];
    test(j).yu = [];
    
    for i = len-23 : len
        test(j).yl = [test(j).yl; lower(j, i)];
        tmp = [lower(j, i-24:i-1) lower(j, i-168)];
        test(j).xl = [test(j).xl; tmp];
        
        test(j).yu = [test(j).yu; upper(j, i)];
        tmp = [upper(j, i-24:i-1) upper(j, i-168)];
        test(j).xu = [test(j).xu; tmp];
        
    end
    % break;
end

path = ['../data/load_data_for_model/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'train', 'test');
end
end

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
    
    maximum(j) = max([lower(j, :) upper(j, :)]);
    minimum(j) = min([lower(j, :) upper(j, :)]);
    lower(j, :) = (lower(j, :) - minimum(j)) / (maximum(j) - minimum(j));
    upper(j, :) = (upper(j, :) - minimum(j)) / (maximum(j) - minimum(j));
    
    % train sample
    train(j).xl = [];
    train(j).xu = [];
    train(j).yl = [];
    train(j).yu = [];
    
    for i = 73 : len-24        
        tmp = [lower(j, i-3:i-1) lower(j, i-26:i-24) lower(j, i-50:i-48)];
        train(j).xl = [train(j).xl; tmp];
        tmp = [upper(j, i-3:i-1) upper(j, i-26:i-24) upper(j, i-50:i-48)];
        train(j).xu = [train(j).xu; tmp];
        
        train(j).yl = [train(j).yl; lower(j, i)];
        train(j).yu = [train(j).yu; upper(j, i)];
        
    end
    % test sample
    test(j).xl = [];
    test(j).xu = [];
    test(j).yl = [];
    test(j).yu = [];
    
    for i = len-23 : len
        tmp = [lower(j, i-3:i-1) lower(j, i-26:i-24) lower(j, i-50:i-48)];
        test(j).xl = [test(j).xl; tmp];
        tmp = [upper(j, i-3:i-1) upper(j, i-26:i-24) upper(j, i-50:i-48)];
        test(j).xu = [test(j).xu; tmp];
        
        test(j).yl = [test(j).yl; lower(j, i)];
        test(j).yu = [test(j).yu; upper(j, i)];
        
    end
    
    % break;
end

path = ['../data/load_data_for_model/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'train', 'test', 'maximum', 'minimum');

end
end

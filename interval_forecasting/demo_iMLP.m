close all; clear; clc;

%% Load samples
dist = 'euclidean';
m = 1;
number_of_cluster = 2;

path = ['../data/load_data_for_model/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
load(path);

%% Train
tic;
for j = 1 : number_of_cluster
    
    [wih, who, acc, out(j)] = iMLPMain(train(j).xu, train(j).xl, train(j).yu, train(j).yl);

    % break;
end
path = ['./iMLP_result/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'out');
    
toc;
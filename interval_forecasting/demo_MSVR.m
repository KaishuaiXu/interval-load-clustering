close all; clear; clc;

%% Load samples
dist = 'euclidean';
m = 1;
number_of_cluster = 2;

path = ['../data/load_data_for_model/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
load(path);

%% Parameters for PSO search
range = [2^-3, 2^3; 2^-3, 2^3; 10^-4, 10^-1];
c1 = 2;
c2 = 2;
wRange = [0.1 1];
k = 5;
tol = 1e-10;

%% Train
tic;
for j = 1 : number_of_cluster
    
    Xtrain = [train(j).xl train(j).xu];
    Ytrain = [train(j).yl train(j).yu];
    
    [c, sigma, e, accuracy, beta, H] = pso_search(Xtrain, Ytrain, range, c1, c2, wRange, k, tol, j);
    out(j).c = c;
    out(j).sigma = sigma;
    out(j).e = e;
    out(j).beta = beta;
    out(j).H = H;
    out(j).train_accuracy = accuracy;
    
    % break;
end
path = ['./MSVR_result/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'out');

toc;

close all; clear; clc;

%% Load samples

for m = 1 : 12

number_of_cluster = 1;
path = ['../data/load_data_for_model/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
load(path);

%% Parameters for PSO search
range = [2^-3, 2^2; 2^-3, 2^2; 10^-4, 10^-1];
c1 = 2;
c2 = 2;
wRange = [0.1 1];
k = 5;
tol = 1e-10;

%% Train
tic;
for j = 1 : number_of_cluster
    
    display = ['Month = ' num2str(m) ', Number of cluster = ' num2str(number_of_cluster) ', Series = ' num2str(j)];
    disp(display);
    
    Xtrain = [train(j).xl train(j).xu];
    Ytrain = [train(j).yl train(j).yu];
    Xtest = [test(j).xl test(j).xu];
    Ytest = [test(j).yl test(j).yu];
    O = descale(Ytest, maximum(j), minimum(j));
    Ox = descale(Ytrain, maximum(j), minimum(j));
    
    best_accuracy = 1;
    for iter = 1 : 5
    
        [c, sigma, e, beta, ~] = pso_search(Xtrain, Ytrain, range, c1, c2, wRange, k, tol);
    
        Ktest = kernelmatrix('rbf', Xtest', Xtrain', sigma);
        F = Ktest * beta;
        F = descale(F, maximum(j), minimum(j));
        test_accuracy = mape(O, F);
        
        Ktrain = kernelmatrix('rbf', Xtrain', Xtrain', sigma);
        Fx = Ktrain * beta;
        Fx = descale(Fx, maximum(j), minimum(j));
        train_accuracy = mape(Ox, Fx);
        
        display = ['MAPE = ' num2str(test_accuracy)];
        disp(display);
        
        if test_accuracy < best_accuracy
            best_accuracy = test_accuracy;
            out(j).c = c;
            out(j).sigma = sigma;
            out(j).e = e;
            out(j).beta = beta;
            out(j).train_accuracy = train_accuracy;
            out(j).test_accuracy = best_accuracy;
            out(j).F = F;
        end
    end
    
    % break;
end
path = ['./MSVR_result/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'out');

toc;

clear out;
clear train;
clear test;
clear maximum;
clear minimum;

end
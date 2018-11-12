close all; clear; clc;

%% Load samples
dist = 'hausdorff';
for m = 8 : 8
for number_of_cluster = 9 : 10

path = ['../data/load_data_for_model/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
load(path);

%% Train
tic;
for j = 1 : number_of_cluster
    
    display = ['Month = ' num2str(m) ', Number of cluster = ' num2str(number_of_cluster) ', Series = ' num2str(j)];
    disp(display);
    
    best_accuracy = 1;
    for iter = 1 : 5
        
    [wih, who] = iMLPMain(train(j).xu, train(j).xl, train(j).yu, train(j).yl);
    
    xC=(test(j).xl + test(j).xu)/2;
    xR=(test(j).xu - test(j).xl)/2;
    
    xC = xC';
    xR = xR';

    [ni, N]=size(xC);

    hC = tansig(wih*[xC;ones(1,N)]);
    hR = tansig(wih*[xR;ones(1,N)]);
    yCt = tansig(who*[hC;ones(1,N)]);
    yRt = tansig(who*[hR;ones(1,N)]);
    
    F = [yCt',yRt'];
    F = iCR2Inter(F);
    O = [test(j).yl test(j).yu];
    F = descale(F, maximum(j), minimum(j));
    O = descale(O, maximum(j), minimum(j));
    
    acc = mape(O, F);
    display = ['MAPE = ' num2str(acc)];
    disp(display);
    
    if acc < best_accuracy
        best_accuracy = acc;
        out(j).wih = wih;
        out(j).who = who;
        out(j).F = F;
        out(j).test_accuracy = best_accuracy;
    end
    
    end
    % break;
end
path = ['./iMLP_result/' dist '/' num2str(m) '_' num2str(number_of_cluster) '.mat'];
save(path, 'out');

clear out;
clear train;
clear test;
clear maximum;
clear minimum;

toc;
end
end

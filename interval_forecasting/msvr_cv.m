function [mean_accuracy]=msvr_cv(x,y,ker,C,epsi,sigma,tol,k)

len = size(x,1);
indice = zeros(len,1);
indices = crossvalind('Kfold', indice, k);
mean_accuracy = 0;

for i=1 : k
    
    test = (indices==i);
    train = ~test;
    Xtrain = x(train, :);
    Xtest = x(test, :);
    Ytrain = y(train, :);
    Ytest = y(test, :);
    [Beta,~,~,~] = msvr(Xtrain,Ytrain,ker,C,epsi,sigma,tol);
    Ktest = kernelmatrix(ker,Xtest',Xtrain',sigma);
    Ypred = Ktest*Beta;

    [accuracy] = mape(Ytest,Ypred);
    mean_accuracy = mean_accuracy + accuracy;
    
end

mean_accuracy = mean_accuracy / k;
mean_accuracy = gather(mean_accuracy);
mean_accuracy = single(mean_accuracy);

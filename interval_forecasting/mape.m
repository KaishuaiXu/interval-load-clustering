function [accuracy] = mape(ytest, ypred)

accuracy = abs(ytest - ypred) ./ ytest;
accuracy = mean(mean(accuracy));

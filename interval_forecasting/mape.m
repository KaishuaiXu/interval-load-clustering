function [accuracy] = mape(ytest, ypred)

accuracy = abs(ytest - ypred) ./ ytest;

function [accuracy] = mape(ytest, ypred)

tmp = abs((ytest - ypred)./ytest);
[i,j] = find(tmp==Inf);

tmp(i,j) = ytest(i,j)-ypred(i,j);
accuracy = mean(mean(tmp));

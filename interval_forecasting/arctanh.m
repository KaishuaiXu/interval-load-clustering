function [tmp] = arctanh(x)
x = (1+x)./(1-x);
tmp = log(x)*0.5;
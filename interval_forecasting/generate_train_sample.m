close all; clear; clc;

dist = 'euclidean';
m = 1;
number_of_cluster = 2;
path = ['../data/load_data_clustered/' dist '/' num2str(m) '_' num2str(number_of_cluster) '_lower.csv'];

lower = load(path);
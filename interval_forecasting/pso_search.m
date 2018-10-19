function [bestC, bestG, bestE, accuracy, Beta, ker] = pso_search(trainX, trainY, range, c1, c2, wRange, k, tol, ser)
%parameters optimization by Particle Swarm Optimization.
%Input:
%   range:  the range of all parameters(each dimension of the particle)
%           %range structure
%               %param    min          max
%               % C-->     minC        maxC
%               % g-->  minGamma     maxGamma
%               % e-->  minEpsilon   maxEpsilon
%           range = [2^-3, 2^3;
%                  2^-3, 2^3;
%                  10^-4, 10^-1];
%           %%待寻优参数的范围,是一个particleSize行，2列的矩阵，其中，第一列为min，第二列为max。每行代表一个参数依次为C, Gamma, epsilon
%   c1,c2
%   wRange : the range of inertia weight w:
%           (1)a constant inertia weight : w = wMax = wMin	
%           (2)a time-varying inertia weight : w = wMin + (maxGen - i) * (wMax - wMin) / maxGen;
%   k : cv-CorssValidation
%   initialP : give the initial population of PSO, if not, if Initial is false.(default: ifInitial = false)
%Output:
%   bestC, bestG, bestE : best parameters by PSO
%   measure : measures of best parameters

%% initialize the parameters
vMax = ((range(:, 2)-range(:, 1))*1/2)';%1*dimension matrix
vMin = -vMax;
wMax = max(wRange);
wMin = min(wRange);

dimension = size(range, 1);%the dimension of particles

gBestFittness = 100000;
gBestPosition = zeros(1, dimension);

particleSize = 10;
maxGen = 50;%maximum iterations

fittness = zeros(particleSize, 1);%fittness of one iteration
fittness = single(fittness);
position = zeros(particleSize, dimension);%position of the particle swarm
velocity = zeros(particleSize, dimension);%velocity of the particle swarm
lBestFittness = zeros(particleSize, 1);%local best fittness
lBestPosition = zeros(particleSize, dimension);%local best position

fittnessAtGen = zeros(maxGen+1, 1);%全局适应度的收敛状况
results = zeros(particleSize*maxGen, 4);
%% 初始化粒子群
parfor i = 1:particleSize
    for j = 1: dimension %待寻参数
       
        position(i, j) = rand()*(range(j, 2)-range(j, 1))+range(j, 1);
        velocity(i, j) = rand()*vMax(j);
    end
    
end

for i = 1:particleSize
    % 计算初始适应�?
    %tic;
    fittness(i) = msvr_cv(trainX, trainY, 'rbf', position(i, 1), position(i, 3), position(i, 2), tol, k);
    %toc
    
end

for i = 1:particleSize
    results(i, 1:3) = position(i, 1:3);
    results(i, 4) = fittness(i);
end

lBestFittness = fittness; %
[gBestFittness, gIndex] = min(lBestFittness);
lBestPosition = position;
gBestPosition = lBestPosition(gIndex, :);
fittnessAtGen(1) = gBestFittness;
%% 粒子群的迭代进化
TC = 1;
% for i = 1:maxGen
i = 1;
while i <= maxGen %% TC <= 20
    for j = 1:particleSize

        w = wMin+(maxGen-i)*(wMax-wMin)/maxGen;
        %速率更新

        velocity(j, 1) = w*velocity(j, 1)+c1*rand()*(lBestPosition(j, 1)-position(j, 1))+c2*rand()*(gBestPosition(1)-position(j, 1));
        velocity(j, 2) = w*velocity(j, 2)+c1*rand()*(lBestPosition(j, 2)-position(j, 2))+c2*rand()*(gBestPosition(2)-position(j, 2));
        velocity(j, 3) = w*velocity(j, 3)+c1*rand()*(lBestPosition(j, 3)-position(j, 3))+c2*rand()*(gBestPosition(3)-position(j, 3));
        temp = find(vMax-velocity(j, :)<0); %找到超过vMax的
        if size(temp, 2)>0
            velocity(j, temp) = vMax(temp);
        end
        temp = find((-vMax)-velocity(j, :)>0); %找到超过-vMax的
        if size(temp, 2)>0
            velocity(j, temp) = -vMax(temp);
        end
        %位置更新
        position(j, :) = position(j, :)+velocity(j, :);
        temp = find(range(:, 2)'-position(j, :)<0); %找到超过range的
        if size(temp, 2)>0
            position(j, temp) = range(temp, 2);
        end
        temp = find(range(:, 1)'-position(j, :)>0); %找到超过range的
        if size(temp, 2)>0
            position(j, temp) = range(temp, 1);
        end
        
        % 计算适应�?
        
        fittness(j) = msvr_cv(trainX, trainY, 'rbf', position(j, 1), position(j, 3), position(j, 2), tol, k);
        
        results(i*particleSize+j, 1) = position(j, 1);
        results(i*particleSize+j, 2) = position(j, 2);
        results(i*particleSize+j, 3) = position(j, 3);
        results(i*particleSize+j, 4) = fittness(j);
        
        if fittness(j)<lBestFittness(j) %localBest
            lBestFittness(j) = fittness(j);
            lBestPosition(j, :) = position(j, :);%如果j粒子当前适应度达到自身最优，则更新localbest
        end
    end
    
    [gBest, gIndex] = min(lBestFittness);

    if gBest<gBestFittness %如果有更优的全局点，更新全局
        
        if gBestFittness-gBest <= 10^-6 %累积gBest下降小于10^-6
            TC = TC+1;
        else
            TC = 1;
        end
        
        gBestFittness = gBest;
        gBestPosition = lBestPosition(gIndex, :);

        show = ['Series: ' num2str(ser)  ', ' num2str(gBestFittness)];
        disp(show);
        
        
    else
        TC = TC+1;
    end
    fittnessAtGen(i+1) = gBestFittness;
    
    i = i+1;
end

%% forecast with the optimal parameters.
bestC = gBestPosition(1);
bestG = gBestPosition(2);
bestE = gBestPosition(3);

[Beta, ~, ~, ~] = msvr(trainX, trainY, 'rbf', bestC, bestE, bestG, tol);

Ktrain = kernelmatrix('rbf', trainX', trainX', bestG);
ker = Ktrain;
Ypred = Ktrain * Beta;
Ypred = gather(Ypred);
accuracy = mape(trainY, Ypred);

Beta = gather(Beta);
accuracy = gather(accuracy);



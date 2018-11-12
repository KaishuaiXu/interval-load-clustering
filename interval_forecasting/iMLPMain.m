%main function of iMLP
%Reference: Munoz SanRoque, A.,Mate, C.,Sarabia,A.,Arroyo,J. iMLP: Applying Multi-Layer Perceptrons to Interval-Valued Data. Neural Processing Letters (2007) 25:157�C169.

%Author: May, 2014, by Zhongyi Hu (huzhyi21@hust.edu.cn), Huazhong University of Science and Technology

function [wih, who] = iMLPMain(xu, xl, yu, yl)

global xC xR yC yR N ni no nh 

xC = (xl + xu) / 2;  %transform from interval-valued to center-radius value
xR = (xu - xl) / 2;
yC = (yl + yu) / 2;
yR = (yu - yl) / 2;

xC = xC';
xR = xR';
yC = yC';
yR = yR';

[ni N] = size(xC); %number of input (ni), number of output (no)
[no N] = size(yC);
nh = 4; %number of hidden

x = 1 * randn(1, nh * (ni + 1) + no * (nh + 1)); 

options = struct('GradObj', 'off', 'Display', 'off', 'LargeScale', 'off', 'HessUpdate', 'bfgs', 'InitialHessType', 'identity', 'GoalsExactAchieve', 1, 'GradConstr', false, 'TolFun', 1e-10, 'TolX', 1e-10);

[xOpt, fval] = fminlbfgs(@iMLPfitness, x, options); 

k = 1;
for i = 1:nh
    for j = 1:ni + 1
        wih(i, j) = xOpt(k);
        k = k + 1;
    end
end
for i = 1:no
    for j = 1:nh + 1
        who(i, j) = xOpt(k);
        k = k + 1;
    end
end

%hC = tansig(wih * [xC;ones(1, N)]);
%hR = tansig(wih * [xR;ones(1, N)]);
%yCt = tansig(who * [hC;ones(1, N)]);
%yRt = tansig(who * [hR;ones(1, N)]);

%Y = [yC', yR'];
%F = [yCt', yRt'];
%Y = iCR2Inter(Y);
%Fi = iCR2Inter(F);
% acc = mape(Y, Fi);


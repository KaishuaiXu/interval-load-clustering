function [delEclDis,grad]=IMLPfitness_cpu(x)
%interval Multi-Layer Perceptrons. (iMLP)
%Reference: 
%Munoz SanRoque,A.,Mate , C.,Sarabia,A.,Arroyo,J. iMLP: Applying Multi-Layer Perceptrons to Interval-Valued Data. Neural Processing Letters (2007) 25:157�C169.

%Author: May, 2014, by Zhongyi Hu (huzhyi21@hust.edu.cn), Huazhong University of Science and Technology


global xC xR yC yR N ni no nh;

% close all, clear all, clc
% 
% load('iDataTest.mat');
% 
% xC=(xl+xu)/2;
% xR=(xu-xl)/2;
% yC=(yl+yu)/2;
% yR=(yu-yl)/2;
% 
% xC=xC';
% xR=xR';
% yC=yC';
% yR=yR';
% 
% [ni N]=size(xC)
% [no N]=size(yC)
% nh=5 %number of hidden?
% 
% wih = 0.01*randn(nh,ni+1); %weight of input-hidden
% who = 0.01*randn(no,nh+1); %weight of hidden-output
% wihR = 0.01*randn(nh,ni+1); %weight of input-hidden
% whoR = 0.01*randn(no,nh+1); %weight of hidden-output

k=1;
for i=1:nh
    for j=1:ni+1
        wih(i,j)=x(k);
        k=k+1;
    end
end
for i=1:no
    for j=1:nh+1
        who(i,j)=x(k);
        k=k+1;
    end
end


delEclDis=0; % cost
delEoj=zeros(no,nh+1); 
delEh=zeros(nh,ni+1); %derivatives of the cost function with respect to hidden layer weights, Eq.(15)
%tic;
for t = 1:N
    %disp(t);
 
    netCj = single(zeros(1,nh));
    netRj = single(zeros(1,nh));
    outCj = single(zeros(1,nh));
    outRj = single(zeros(1,nh));
    for j = 1:nh %input to hidden,  j:number of hidden
        
        netCj(j) = wih(j,1:end-1)*xC(:,t)+wih(j,end);
        netRj(j) = abs(wih(j,1:end-1))*xR(:,t);
        
        nCR1 = netCj(j)+netRj(j);
        nCR2 = netCj(j)-netRj(j);
        atanh1 = arctanh(nCR1);
        atanh2 = arctanh(nCR2); 
        
        outCj(j) = ( tansig(nCR1) + tansig(nCR2) )/2;
        outRj(j) = ( tansig(nCR1) - tansig(nCR2) )/2;
        
        deYhCk = single(zeros(j,ni+1));
        deYhRk = single(zeros(j,ni+1));
       
        for i=1:ni 
            sw = sign(wih(j,i)).*xC(i,t);
            tmp1 = xC(i,t) + sw;
            tmp2 = xC(i,t) - sw;
            at1 = atanh1 .* tmp1/2;
            at2 = atanh2 .* tmp2/2;
            deYhCk(j,i)=at1 + at2;
            deYhRk(j,i)=at1 - at2;
        end
       
        i=ni+1;
        sw1 = ( 1 + sign(wih(j,i)).*1 );
        sw2 = ( 1 - sign(wih(j,i)).*1 );
        deYhCk(j,i)=atanh1 .* sw1/2 + atanh2.* sw2/2;
        deYhRk(j,i)=atanh1 .* sw1/2 - atanh2.* sw2/2;
    end
    
    for k = 1:no 
        netCk(k) = who(k,1:end-1)*outCj' +who(k,end);
        netRk(k) = abs(who(k,1:end-1))*outRj';
        
        outCk(k) = netCk(k); 
        outRk(k) = netRk(k);
        
        beta=0.5;
        delEclDis=delEclDis+beta*(outCk(k)-yC(t))^2+(1-beta)*(outRk(k)-yR(t))^2; % cost, Euclidean Distance
        
        deYhCj=who(k,1:end-1); deYhRj=abs(who(k,1:end-1)); 
    end
    
    %The derivatives
    deYoCj=[outCj,ones(1,1)]; %
    deYoRj=[sign(who(:,1:end-1)).*outRj,zeros(1,1)]; 
    delEoj=delEoj + beta*(outCk-yC(t))*deYoCj+(1-beta)*(outRk-yR(t))*deYoRj; 
    
    
    for j=1:nh 
        tmp1 = beta * (outCk-yC(t)) * deYhCj(j);
        tmp2 = (1-beta) * (outRk-yR(t)) * deYhRj(j);
        for i=1:ni+1
            
            delEh(j,i)= delEh(j,i) + tmp1 *deYhCk(j,i) - tmp2 *deYhRk(j,i);
            
        end
    end
    
end
%toc
delEclDis=delEclDis/N; 
delEoj=delEoj*2/N; 
delEh=delEh*2/N; 

grad=zeros(1,nh*(ni+1)+no*(nh+1));

k=1;
for i=1:nh
    for j=1:ni+1
        grad(k)=delEh(i,j);
        k=k+1;
    end
end
for i=1:no
%     for j=1:nh+1
        grad(k:end)=delEoj;
%         k=k+1;
%     end
end

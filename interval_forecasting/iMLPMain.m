%main function of iMLP
%Reference: Munoz SanRoque,A.,Mate, C.,Sarabia,A.,Arroyo,J. iMLP: Applying Multi-Layer Perceptrons to Interval-Valued Data. Neural Processing Letters (2007) 25:157�C169.

%Author: May, 2014, by Zhongyi Hu (huzhyi21@hust.edu.cn), Huazhong University of Science and Technology

function [wih, who, measure, acc, out] = iMLPMain(xu, xl, yu, yl)

global xC xR yC yR N ni no nh 

xC=(xl+xu)/2;  %transform from interval-valued to center-radius value
xR=(xu-xl)/2;
yC=(yl+yu)/2;
yR=(yu-yl)/2;

xC=xC';
xR=xR';
yC=yC';
yR=yR';

[ni N]=size(xC); %number of input (ni), number of output (no)
[no N]=size(yC);
nh=4; %number of hidden

% wih = 0.01*randn(nh,ni+1); %weight of input-hidden
% who = 0.01*randn(no,nh+1); %weight of hidden-output
% x=[-0.798163584564142,1.01868528212858,-0.133217479507735,-0.714530163787158,1.35138576842666,-0.224771056052584,-0.589029030720801,-0.293753597735416,-0.847926243637934,-1.12012830124373,2.52599969211831,1.65549759288735,0.307535159238252,-1.25711835935205,-0.865468030554804,-0.176534114231451,0.791416061628634,-1.33200442131525,-2.32986715580508,-1.44909729283874,0.333510833065806,0.391353604432901,0.451679418928238,-0.130284653145721,0.183689095861942,-0.476153016619074,0.862021611556922,-1.36169447087075,0.455029556444334,-0.848709379933659,-0.334886938964048,0.552783345944550,1.03909065350496,-1.11763868326521,1.26065870912090,0.660143141046978,-0.0678655535426873,-0.195221197898754,-0.217606350143192,-0.303107621351741,0.0230456244251053,0.0512903558487747,0.826062790211596,1.52697668673337,0.466914435684700,-0.209713338388737,0.625190357087626,0.183227263001437,-1.02976754356662,0.949221831131023,0.307061919146703;];
x=1*randn(1,nh*(ni+1)+no*(nh+1)); 

% options = optimset('GradObj','on');
% options = struct('GradObj','off','Display','iter','LargeScale','off','HessUpdate','bfgs','InitialHessType','identity','GoalsExactAchieve',1,'GradConstr',false);
options = struct('GradObj','off','Display','iter','LargeScale','off','HessUpdate','bfgs','InitialHessType','identity','GoalsExactAchieve',1,'GradConstr',false,'TolFun',1e-10,'TolX',1e-10);

[xOpt,fval] = fminlbfgs(@iMLPfitness_cpu,x,options); 

k=1;
for i=1:nh
    for j=1:ni+1
        wih(i,j)=xOpt(k);
        k=k+1;
    end
end
for i=1:no
    for j=1:nh+1
        who(i,j)=xOpt(k);
        k=k+1;
    end
end

hC = tansig(wih*[xC;ones(1,N)]);
hR = tansig(wih*[xR;ones(1,N)]);
yCt = tansig(who*[hC;ones(1,N)]);
yRt = (who*[hR;ones(1,N)]);

Y=[yC',yR'];
F=[yCt',yRt'];
Y=iCR2Inter(Y);
Fi=iCR2Inter(F);
measure = iErrorCompute(Y,Fi); %compute errors, iAVR, iUT
acc = mape(Y,Fi);

out.wih = wih;
out.who = who;
out.accuracy = measure;
out.mape = acc;

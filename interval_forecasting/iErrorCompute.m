function measure = iErrorCompute(original,forecast)
%original: interval TS=[min, max]
%forecast: prediction TS=[min,max]
%measure: [iARV,iUT];

% Reference:
%Maia, A.L.S., de Carvalho, F.D.A.T. Holt's exponential smoothing and neural network models for forecasting interval-valued time series. 
%International Journal of Forecasting, 27 (2011) 740¨C759.


[a1 a2] = size(original); %N*2
[b1,b2] = size(forecast);

%check the size of the input sample and turn them to n*2.
if a1 ~=b1 | a2 ~=b2
   error('Input sample must have the same dimension!')
elseif a1 ==2 
    original = original';
    forecast = forecast';
elseif a2 ==2 
    original = original;
    forecast = forecast;
else
    error('Input original sample must be 2*n or n*2£¡')
end

errors=(original-forecast);
errDistance= mean(sqrt(sum((errors').^2)));%error based on Euclidean distance;

meanOri=mean(original);%sample average interval of original ITS
meanOri=repmat(meanOri,a1,1); %repeat

meanErrors = original-meanOri;% the error matrix between original and its mean ,to be used for iARV...

%interval average relative variance (iARV), scaled by the average interval
iARV=sum(sum((errors(2:end,:)').^2))/sum(sum((meanErrors(2:end,:)').^2)); %interval average relative variance (ARVI)

%interval U of Theil statistics (iUT), scaled by the naive method
naiveFore=original(1:end-1,:); %naive forecasts
errorsNaive=original(2:end,:)-naiveFore;
iUT=sum(sum((errors(2:end,:)').^2))/sum(sum((errorsNaive').^2)); %interval U of Theil statistics (iUT)
iUT=sqrt(iUT);

%%
measure=[iARV,iUT];

disp(['iARV = ' num2str(iARV) ', iUT = ' num2str(iUT)])
% ErrorCompute(original(:,1),forecast(:,1)); %compute errors for low and upper series, separately.
% ErrorCompute(original(:,2),forecast(:,2));

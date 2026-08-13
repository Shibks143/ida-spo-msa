% This code is used to compare the covariance structure of the selected
% ground motions with the covariance structure provided by Baker and
% Jayaram (2008).
%
% Nirmal Jayaram, Ting Lin, Jack W. Baker
% Department of Civil and Environmental Engineering
% Stanford University
% Last Updated: 11 March 2010
%
% Reference manuscripts:
%
% J. W. Baker and Jayaram, N. (2008). Correlation of spectral acceleration 
% values from NGA ground motion models, Earthquake Spectra, 24 (1), 299-317

%% Estimate conditional covariances from the Baker and Jayaram (2008) model

% Modify perTgt to include T1
if ~any(perKnown == T1)
    perKnown1 = [perKnown(perKnown<T1) T1 perKnown(perKnown>T1)];
else
    perKnown1 = perKnown;
end

sigmaKnown = zeros(1,length(perKnown1));
for i = 1:length(perKnown1)
    if strcmp(GMPE, 'CB_2008_nga')
        [tmp, sigmaKnown(1,i)] = CB_2008_nga (M_bar, perKnown1(i), Rrup, Rjb, Ztor, delta, lambda, Vs30, Zvs, arb);
    elseif strcmp(GMPE, 'BA_2008_nga')
        [tmp, sigmaKnown(1,i)] = BA_2008_nga(M_bar, perKnown1(i), Rjb, Fault_Type, Vs30);
    else
        error('GMPE not in the list!')
    end
end


corrReq = zeros(length(perKnown1));
corrReqSamp = zeros(length(perKnown1));
for i=1:length(perKnown1)
    for j=1:length(perKnown1)
        
        Ta = perKnown1(i);
        Tb = perKnown1(j);
        
        rec = find(perKnown1 == T1);
% (8-5-16, PSB) replaced the following obsolete set of codes by one single line given by corresponding term in the equation (9)
% of Jayaram Lin Baker (2011) paper (first reference in this code)

%         var1 = sigmaKnown(i)^2;
%         var2 = sigmaKnown(j)^2;
%         varT = sigmaKnown(rec)^2;
%         
%         
%         sigma11 = [var1 baker_jayaram_correlation(Ta, Tb)*sqrt(var1*var2);baker_jayaram_correlation(Ta, Tb)*sqrt(var1*var2) var2];
%         sigma22 = varT;
%         sigma12 = [baker_jayaram_correlation(Ta, T1)*sqrt(var1*varT);baker_jayaram_correlation(T1, Tb)*sqrt(var2*varT)];
%         
%         sigmaCond = sigma11 - (1/sigma22)*(sigma12*sigma12');
%         
%         corrReq(i,j) = sigmaCond(1,2)/sqrt(sigmaCond(1,1)*sigmaCond(2,2));
        
% some simplification yields following
% 
%         sigmaCond(1,2) = baker_jayaram_correlation(Ta, Tb) * sqrt(var1*var2) - ...
%                          baker_jayaram_correlation(Ta, T1) * baker_jayaram_correlation(Tb, T1) * sqrt(var1*var2);
%         sigmaCond(1, 1) = var1 * (1 - baker_jayaram_correlation(Ta, T1)^2);
%         sigmaCond(2, 2) = var2 * (1 - baker_jayaram_correlation(Tb, T1)^2);
        
% some further simplification yields even simpler one line statement, where individual variance calculations are not even required
% 
    corrReq(i,j) = (step3a_baker_jayaram_correlation(Ta, Tb) - step3a_baker_jayaram_correlation(Ta, T1) * step3a_baker_jayaram_correlation(Tb, T1)) / ...
                   sqrt((1 - step3a_baker_jayaram_correlation(Ta, T1)^2) * (1 - step3a_baker_jayaram_correlation(Tb, T1)^2));
        
    end
end

figure
imagesc(perKnown1,perKnown1,corrReq)
title('Baker and Jayaram (2008) conditional correlations');
xlabel('T_1 (s)');
ylabel('T_2 (s)');
colorbar('YLim',[0 1]);

%% Observed correlations

sampleUse = [];
sampleUse = log(SaKnown(finalRecords,:).*repmat(finalScaleFactors,1,size(SaKnown,2)));
sampleUse = [sampleUse(:,perKnown<T1) interp1(perKnown,sampleUse',T1)' sampleUse(:,perKnown>T1)];

for i=1:length(perKnown1)
    for j=1:length(perKnown1)
        corrMatrix = corrcoef((sampleUse(:,i)),(sampleUse(:,j)));
        corrReqSamp(i,j) = corrMatrix(1,2);
    end
end
   
figure
imagesc(perKnown1,perKnown1,corrReqSamp)
title('Sample correlations');
xlabel('T_1 (s)');
ylabel('T_2 (s)');
colorbar('YLim',[0 1]);

%% Error

figure
imagesc(perKnown1,perKnown1,corrReqSamp-corrReq)
title('Difference in the correlation (sample-model)');
xlabel('T_1 (s)');
ylabel('T_2 (s)');
colorbar('YLim',[0 1]);

%% contour plot

figure(11)
contour(perKnown1, perKnown1, corrReqSamp);
set(gca,'yscale','log','xscale','log'); 
axis square;
xlabel('T_1');
ylabel('T_2');
title('Sample correlation contour');
xlabel('T_1')
ylabel('T_2')
% colorbar('YLim',[0 1]);
colorbar
caxis([0 1]);


figure(12)
contour(perKnown1, perKnown1, corrReq);
set(gca,'yscale','log','xscale','log'); 
axis square;
xlabel('T_1');
ylabel('T_2');
title('Baker and Jayaram (2008) conditional correlation contour');
xlabel('T_1')
ylabel('T_2')
% colorbar('YLim',[0 1]);
colorbar
caxis([0 1]);



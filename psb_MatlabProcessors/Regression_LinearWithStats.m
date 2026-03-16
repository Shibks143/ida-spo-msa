%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Regression_LinearWithStats.m
%
% This script performs a linear regression analysis, removes the outliers,
% then redoes the linear regression analysis.  This includes the constant
% term only if there is a leading column of ones in the predictor matrix.
%
% Curt Haselton & Abbie Liel
% Stanford University
% March 14, 2006; Updated June 27, 2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[B,BINT,R,RINT,STATS,isOutlier] = Regression_LinearWithStats(yVector, predictorMatrix)

disp('Starting the regression procedure...');

% Preliminary calculations
    numDataPoints = length(yVector);

% Do the first regression
    disp('Completing linear regression analysis with no outliers removed...');
    [B,BINT,R,RINT,STATS] = regress(yVector, predictorMatrix);
    B;
    %intercept = B(1);
    %slope_firstPred = B(2);
    STATS;
    pValue_fullModel = STATS(3);
    residuals = R;
    % Compute the standard deviation.  Create a new residual vector with
    % NAN's removed, then compute sigma.
    counter = 1;
    for i = 1:length(residuals)
       if(~isnan(residuals(i)))
           residuals_withNanRemoved(counter) = residuals(i);
           yVector_withNanRemoved(counter) = yVector(i);
           counter = counter + 1;
       end
    end
    SSE = sum(residuals_withNanRemoved .* residuals_withNanRemoved);
    numDataPoints = length(residuals_withNanRemoved);
    sigma = std(residuals_withNanRemoved);
    meanOfCalibratedData = mean(yVector_withNanRemoved);
    cov = sigma/meanOfCalibratedData;

% Remove outliers       
    yVector_withoutRemovingOutliers = yVector;  % Save the old vector for later plotting outliers
    yVector_length = length(yVector);
    isOutlier = zeros(yVector_length,1);
    for i = 1:yVector_length
        % If zero does not lie in the range of RINT(i,:), then the test
        % data point is an outlier at the 5% sigificance level (from
        % Matlab help information).  Zero is not in the range if the
        % sign is the same for both ends of the range
        if ((sign(RINT(i,1))) == (sign(RINT(i,2))))
            isOutlier(i) = 1;
            yVector(i) = nan;
        end
    end
    
    % Print to screen
    isOutlier_fromRegressProc = isOutlier;
        
% Redo the regression with outliers removed...
if(1==1)
    disp('Redoing the linear regression analysis with the outliers removed...');
    numOutliersBeingRemoved = sum(isOutlier);
    [B,BINT,R,RINT,STATS] = regress(yVector, predictorMatrix);
    B;
    BINT;
    %intercept = B(1);
    %slope_firstPred = B(2);
    STATS;
    pValue_fullModel = STATS(3);
    residuals = R;
    % Compute the standard deviation.  Create a new residual vector with
    % NAN's removed, then compute sigma.
    counter = 1;
    for i = 1:length(residuals)
       if(~isnan(residuals(i)))
           residuals_withNanRemoved(counter) = residuals(i);
           yVector_withNanRemoved(counter) = yVector(i);
           counter = counter + 1;
       end
    end
    SSE = sum(residuals_withNanRemoved .* residuals_withNanRemoved);
    numDataPoints = length(residuals_withNanRemoved);
    sigma = std(residuals_withNanRemoved);
    meanOfCalibratedData = mean(yVector_withNanRemoved);
    cov = sigma/meanOfCalibratedData;
end
        
   





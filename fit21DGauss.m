function [fitresult, gof, n] = fit21DGauss(data)
%FIT2DGauss(DATA)
%  This is a 2D Gaussian Fit for Intensities. Thus, the square of the
%  electric field. The resultant width is the width of a gaussian beam at
%  1/e^2 maximum value. If you want the width of a density distribution
%  beware that this CAN be defined differently, i.e. with 1/e maximum
%  value. This results in a smaller width: 2*sigma = wx_intensity.
%  Creates a 2D gaussian fit. The input data array "data" will be rescaled
%  to order of magnitude unity. This increases the fitting speed massively.
%  For scaling purposes the order of magnitude, used for scaling will be
%  returned via the variable n.
%  If the input parameter "offset" is set to 0 the fit will be forced to
%  have 0 offset. Otherwise the offset is a free parameter.
%
%  Data for fit:
%      Z Output: data
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.
%  Auto-generated by MATLAB on 17-Nov-2015 18:48:31

[sx, sy] = size(data);

%% Fit: fits two 1 dimensional gaussian

xx = sum(data,1);
xxx = 1:numel(xx);
yy = sum(data,2);
yyy = 1:numel(yy);

% try to find starting conditions
x0Init = xxx(xx == max(xx));
if abs(x0Init) > sx/2
    x0Init = sx/2;
end
y0Init = yyy(yy == max(yy));
if abs(y0Init) > sy/2
    y0Init = sy/2;
end
axInit = max(xx);
cxInit = min(xx);

% Set up fittype and options.
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
ft = fittype( 'c+A*exp(-2*((x-x0)/wx)^2)', 'independent', 'x', 'dependent', 'z' );
opts.StartPoint = [axInit cxInit 20 x0Init(1)];
opts.Lower = [0 0 0 1];
opts.upper = [1 1 size(data,2) size(data,2)];
% Fit model to data.
[frx, ~] = fit( xxx, xx, ft, opts );



function [ smoothedSeries ] = removeCyclicFlucts( timeSeries, period )
%removeCyclicFlucts.m
%   Removes cyclic fluctuations from a time series. For method, see 
%   http://www.mathworks.com/help/signal/examples/signal-smoothing.html
%Inputs:
%   timeSeries- data, formatted as [value; time] or just indexed values.
%   period- period of oscillations, either arbitrary units or time
%Outputs
%   smoothedSeries- data with oscillations removed.

MAcoeff = ones(1,period)/period;
smoothedSeries = filter(MAcoeff,1,timeSeries(1,:));
fdelay = (length(MAcoeff)-1)/2;

if size(timeSeries,1)>1
    smoothedSeries(2,:) = timeSeries(2,:)-fdelay;
else
    smoothedSeries(2,:) = (1:length(timeSeries))-fdelay;
end

end


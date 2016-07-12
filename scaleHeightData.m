function [ output_args ] = scaleHeightData( a0, a1, d2, z2, height, timepoint )
%UNTITLED Summary of this function goes here
%   For now, just do this at one time point. Later can think about how to
%   do it for more.

heightRange = numel(height);
numPoints = size(a0,1); %should be the same for all input parameters from getHeightFlucts

heightmat = repmat(height,numPoints,1);
a0mat = repmat(a0(:,timepoint,1),1,heightRange);
a1mat = repmat(a1(:,timepoint,1),1,heightRange);
d2mat = repmat(d2(:,timepoint,1),1,heightRange);
z2mat = repmat(z2(:,timepoint,1),1,heightRange);

test = erf((heightmat-z2mat)./d2mat)./a1mat-a0mat;

check = 1;

end


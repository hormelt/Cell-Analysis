function [ intLum ] = getImageIntensity( dataDir, channel, totFrames, rescale )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Inputs and Defaults Options

if ~exist('dataDir','var') || isempty(dataDir)
    dataDir = pwd;
end

if ~exist('channel','var') || isempty(channel)
    channel = 1;
end

if ~exist('rescale','var') || isempty(rescale)
    rescale = 1;
end

%% Load images

tifstruct = dir([pwd,'\*.tif']); %Only want .tifs from FIJI output
framepat = 't\d+'; %works for normal FIJI output

%since stacks can have a lot of images, initialize cell arrays for speed

frames = cell(numel(tifstruct),1);

for j = 1:numel(tifstruct)
    frames(j) = regexp(tifstruct(j).name,framepat,'match');
end

if ~exist('totFrames','var') || isempty(totFrames)
    totFrames = numel(unique(frames));
end

testLum = zeros(totFrames,1);
intLum = zeros(totFrames,1);

%% calcs 

h = waitbar(0,'Determining intensities...');

for j = 1:totFrames

im = loadTimeSeries( j, 1 )*rescale;

level = graythresh(im); %Threshhold to find pixels that actually contain mucin (Ohtsu)

im(im(:)<level)=0;

intLum(j) = sum(im(:));

waitbar(j / totFrames)

end
close(h)

% dataOut(:,:,1) = layerLum;
% dataOut(:,:,2) = intLum;

end


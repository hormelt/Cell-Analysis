function [ im ] = loadZSeriesWithChannels( goodFrames, goodz, goodchannels, dataDir )
%loadZSeriesWithChannels
%   Will load all images in a TIFFstack in to a single 5D variable, with
%   dimension 3 being frame-index, 4 is z-index, and 5 is channel-index.
%   INPUTS: dataDir- directory from which tiff series will be loaded. Will
%       attempt to load all tiffs in this directory, but they should be in the
%       form output by FIJI from an .nd image stack. Can leave empty to use
%       current directory.

%If the user doesn't specifiy a data directory, use .tifs from the current
%dirrectory
if ~exist('dataDir','var') || isempty(dataDir)
    dataDir = pwd;
end

tifstruct = dir([pwd,'\*.tif']); %Only want .tifs from FIJI output
framepat = 't\d+'; %works for normal FIJI output
zpat = 'z\d+';
channelpat = 'c\d+';

%since stacks can have a lot of images, initialize cell arrays for speed

frames = cell(numel(tifstruct),1);
z = cell(numel(tifstruct),1);
channels = cell(numel(tifstruct),1);

%using two for loops so I can initialize tiff; faster this way? Only slow
%part is loading the imload.

try
    for j = 1:numel(tifstruct)
        frames(j) = regexp(tifstruct(j).name,framepat,'match');
        z(j) = regexp(tifstruct(j).name,zpat,'match');
        channels(j) = regexp(tifstruct(j).name,channelpat,'match');
    end
catch err
    if isempty(regexp(tifstruct(j).name,framepat))
        errmsg = 'Data has wrong format.';
        disp(errmsg);
    end
end

%get max dimensions and construct indices

totFrames = numel(unique(frames));
zdepth = numel(unique(z));
numChannels = numel(unique(channels));
z = char(z);
frames = char(frames);
channels = char(channels);
z = str2num(z(:,2:end));
frames = str2num(frames(:,2:end));
channels = str2num(channels(:,2:end));

imtemp = imread(tifstruct(1).name);

goodinds = 1:numel(tifstruct);

if ~exist('goodFrames','var') || isempty(goodFrames)
    goodFrames = 1:max(frames);
end
if ~exist('goodz','var') || isempty(goodz)
    goodz = 1:max(z);
end
if ~exist('goodchannels','var') || isempty(goodchannels)
    goodchannels = 1:max(channels);
end

badFrames = ~ismember(frames,goodFrames);
badz = ~ismember(z,goodz);
badchannels = ~ismember(channels,goodchannels);

badinds = badFrames+badz+badchannels;
badinds = badinds>0;
goodinds(badinds) = [];

im = zeros(size(imtemp,1),size(imtemp,2),numel(goodFrames),numel(goodz),numel(goodchannels));

for j = 1:numel(goodinds)
    im(:,:,frames(goodinds(j))-min(goodFrames)+1,z(goodinds(j))-min(goodz)+1,channels(goodinds(j))-min(goodchannels)+1) = imread(tifstruct(goodinds(j)).name);
%     channelsOut(j) = channels(goodinds(j)); %For Debugging
%     zOut(j) = z(goodinds(j));
%     framesOut(j) = frames(goodinds(j));
end




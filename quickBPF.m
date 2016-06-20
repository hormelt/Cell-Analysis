function [ filtim ] = quickBPF( im, lpt, hpt, plotopt )
%Quick and dirty bandpass filter. Requirements: gaussianbpf. Still want to
%change this to use built in matlab functions eventually. Also note: would
%it make more sense to do this along a different dimension?

if ~exist('lpt','var') || isempty(lpt)
    lpt = 5;
end

if ~exist('hpt','var') || isempty(hpt)
    hpt = 20;
end

filtim = zeros(size(im));

for j = 1:size(im,3)
    for k = 1:size(im,4)
        for m = 1:size(im,5)
            filtim(:,:,j,k,m) = gaussianbpf(im(:,:,j,k,m),lpt,hpt);
        end
    end
end

if ~isempty(plotopt)
    figure; imagesc(filtim(:,:,plotopt(1),plotopt(2),plotopt(3))); colormap('gray');
end

filtim = squeeze(filtim);

end


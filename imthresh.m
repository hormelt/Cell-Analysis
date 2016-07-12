function [ threshim ] = imthresh( filtim, level, plotopt )
%Threshold image stack

threshim = zeros(size(filtim));

for j = 1:size(filtim,3)
    for k = 1:size(filtim,4)
        for m = 1:size(filtim,5)
            if ~exist('level','var') || isempty(level)
                level = graythresh(filtim(:,:,j,k,m));
            end
            bw = squeeze(im2bw(filtim(:,:,j,k,m),level));
            threshim(:,:,j,k,m) = medfilt2(bw);
        end
    end
end

if ~isempty(plotopt)
    figure; imshow(threshim(:,:,plotopt(1),plotopt(2),plotopt(3)));
end

threshim = squeeze(threshim);

end


function [ Rmat ] = levelPlane( im )
%Rotates microscope images so that coordinate axes are orientated with x-y
%in the plane of the microscope slide and z is perpendicular pointing up.
%   Inputs-
%       im: image stack output from LoadZSeriesWithChannels
%       
%General Strategy: find points in original z-stack with maximum intensity;
%these can correspond to something like a mucin layer. Fit resulting
%surface to a plane and rotate data so that it is oriented along this
%plane.

%Get brightest points- *should* lie in mucin plane?

[~, maxInt] = max(im,[],4);
maxInt = squeeze(maxInt(:,:,:,:,1));

lev = mean(maxInt);
[~, maxIntRest] = max(im(:,:,:,max([1,floor(lev-10)]):min([ceil(lev+10),size(im,4)]),1),[],4);
maxIntRest = squeeze(maxIntRest(:,:,:,:,1));

%Reshape for fitting and construct x-y coordinate arrays

[xinds, yinds] = ind2sub([size(maxIntRest,1), size(maxIntRest,2)],1:numel(maxIntRest));
maxIntRest = reshape(maxIntRest,size(maxIntRest,1)*size(maxIntRest,2),1);
maxInt = reshape(maxInt,size(maxInt,1)*size(maxInt,2),1);

%Fit to plane

sf = fit([xinds', yinds'],maxIntRest,'poly11');
% figure; plot(sf,[xinds(1:500:end)',yinds(1:500:end)'],maxIntRest(1:500:end)) %plot for sanity
% hold on
% plot(sf,[xinds(1:500:end)',yinds(1:500:end)'],maxInt(1:500:end))

%Construct rotation matrix- see wikipedia article

camNorm = [0 0 1];
slideNorm = [sf.p10 sf.p01 1];

c = camNorm*slideNorm'/norm(slideNorm); %some useful variables
ax = cross(camNorm,slideNorm)/norm(cross(camNorm,slideNorm));
s = sqrt(1-c*c);
C = 1-c;

Rmat = [ ax(1)*ax(1)*C+c, ax(1)*ax(2)*C-ax(3)*s, ax(1)*ax(3)*C+ax(2)*s;...
         ax(2)*ax(1)*C+ax(3)*s, ax(2)*ax(2)*C+c, ax(2)*ax(3)*C-ax(1)*s;...
         ax(3)*ax(1)*C-ax(2)*s, ax(3)*ax(2)*C+ax(1)*s, ax(3)*ax(3)*C+c];

     presize = numel([1:500:numel(maxInt)]);
     
     Rpoints = zeros(presize,3);
     
for j = 1:500:numel(maxInt)
Rpoints(j,:) = Rmat*[xinds(j);yinds(j);maxInt(j)];
end
     
sf2 = fit([Rpoints(:,1), Rpoints(:,2)],Rpoints(:,3),'poly11');

%      figure; plot(sf2,[Rpoints(:,1),Rpoints(:,2)],Rpoints(:,3));

     
     
end


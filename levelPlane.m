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
% 
%      rotatedStack = zeros(2*size(im,1),2*size(im,2),size(im,3),2*size(im,4),size(im,5));
%      
% for j = 1:size(im,3)
%     for k = 1:size(im,5)
%         thisFrame = squeeze(im(:,:,j,:,k));
%         
%         [I1, I2, I3] = ind2sub(size(thisFrame), 1:numel(thisFrame)); %one frame, channel at a time;
% 
% inds = [I1;I2;I3];
% 
% rotx = @(rotmat, I1)(rotmat(1,1)*inds(1,:)+rotmat(1,2)*inds(2,:)+rotmat(1,3)*inds(3,:));
% roty = @(rotmat, I2)(rotmat(2,1)*inds(1,:)+rotmat(2,2)*inds(2,:)+rotmat(2,3)*inds(3,:));
% rotz = @(rotmat, I3)(rotmat(3,1)*inds(1,:)+rotmat(3,2)*inds(2,:)+rotmat(3,3)*inds(3,:));
% 
% newx = rotx(Rmat,inds);
% newy = roty(Rmat,inds);
% newz = rotz(Rmat,inds); %these are the z heights in the rotated frame
% 
% rotatedFrame = zeros(2*size(im,1),2*size(im,2),2*size(im,4));
% 
% newxind = round(unique(newx));
% newyind = round(unique(newy));
% newzind = round(unique(newz));
% 
% for jj = 1:numel(newxind)
%     for kk = 1:numel(newyind)
%         for pp = 1:numel(newzind)
%             if newxind(jj)*newyind(kk)*newzind(pp)>0
%                 rotatedFrame(newxind(jj),newyind(kk),newzind(pp)) = thisFrame(jj,kk,pp);
%             end
%      
%      rotatedStack(:,:,j,:,k) = rotatedFrame;
%      
%         end
%     end
% end
% 
%     end
% end
% 
% rotatedFrame = rotatedFrame-1;
     
end


layer = [];

for j = 1:130
    im = loadZSeriesWithChannels( j, [], 1 );
    im = squeeze(permute(im,[4,2,1,3,5]));

%     filtim = quickBPF(im,3,20,[]);
%     filtim = bpass3D_TA(im,1,5);
filtim = im;
    threshim = imthresh(filtim,[],[]);
        voltemp = sum(sum(sum(threshim(:,:,:))));
    layer = [layer voltemp];
%     subplot(2,1,1); imagesc(im(:,:,200)); colormap('gray');
%     subplot(2,1,2); imagesc(threshim(:,:,200)); colormap('gray');
    j
%     pause
end
% % 
% layer = [];
% 
% for j = 1:130
%     im = squeeze(loadZSeriesWithChannels( j, 6:7, 1 ));
% %     im = squeeze(permute(im,[4,2,1,3,5]));
% 
% %     filtim = quickBPF(im,3,20,[]);
% %     filtim = bpass3D_TA(im,1,5);
% voltemp = mean(im(:));
% 
%     layer = [layer voltemp];
% %     subplot(2,1,1); imagesc(im(:,:,200)); colormap('gray');
% %     subplot(2,1,2); imagesc(threshim(:,:,200)); colormap('gray');
%     j
% %     pause
% end
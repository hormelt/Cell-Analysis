d0 = 5;
d1 = 20;

% filtim5 = zeros(512,512,10,97);
% 
% for j = 1:10
%     for k = 1:97
%         filtim5(:,:,j,k) = gaussianbpf(im(:,:,j,k,1),d0,d1);
%     end
%     j
% end

d0 = 3;
d1 = 20;

filtim3 = zeros(512,512,52,97);

for j = 1:52
    for k = 1:97
        filtim3(:,:,j,k) = gaussianbpf(im(:,:,j,k,1),d0,d1);
    end
    j
end
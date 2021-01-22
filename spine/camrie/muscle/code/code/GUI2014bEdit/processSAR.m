
%% SAR
clear kData geoDataID geoDataSAR geoDataRhoMass;
fid=fopen('D:\PSUdoMRI\GUI2012a\Protocols\testKTPts\testKTPts.sar');


[kData,cnt]=fread(fid,[5,inf],'float');
fclose(fid);

kData = kData';

xMin = min(kData(:,1));
xMax = max(kData(:,1));
yMin = min(kData(:,2));
yMax = max(kData(:,2));
zMin = min(kData(:,3));
zMax = max(kData(:,3));

geoDataID = zeros(xMax-xMin+1,yMax-yMin+1,zMax-zMin+1);
for n=1:length(kData)
    geoDataID(kData(n,1)-xMin+1,kData(n,2)-yMin+1,kData(n,3)-zMin+1) = kData(n,4);
end;

geoDataSAR = zeros(xMax-xMin+1,yMax-yMin+1,zMax-zMin+1);
for n=1:length(kData)
    geoDataSAR(kData(n,1)-xMin+1,kData(n,2)-yMin+1,kData(n,3)-zMin+1) = kData(n,5);
end;

% Display ID map.
figure(2);
imagesc((geoDataID(:,:,120-zMin+1)));
axis image off;
colormap jet2;

% Display Unaveraged SAR
% figure(3);
figure;
imagesc(rot90(geoDataSAR(:,:,120-zMin+1))); caxis([0,1]);
axis image off;
colormap hot;

%% Whole Head SAR
wholeSASR = sum(kData(:,5))/length(kData)

% 
% %%
% load tissueType.mat;
% geoDataRhoMass = zeros(xMax-xMin+1,yMax-yMin+1,zMax-zMin+1);
% for n=1:length(kData)
%     tempInd = (find(tissueType(:,1) == kData(n,4)));
%     geoDataRhoMass(kData(n,1)-xMin+1,kData(n,2)-yMin+1,kData(n,3)-zMin+1) = tissueType(tempInd,7);
% end;
% 
% % kData = sort(kData,5);
% [maxSAR, ind] = max(kData(:,5));
% kData(ind,1)-xMin+1
% kData(ind,2)-yMin+1
% kData(ind,3)-zMin+1
% maxSAR
% 
% SAR_10g_3D = SARavesphpar_np (geoDataRhoMass, geoDataSAR, 2/1000, 2/1000, 2/1000, 10);
% 
% % % Display 10g SAR
% % figure(5); imagesc(squeeze(SAR_10g_3D(120-zMin+1,:,:))); axis image off;
% 
% % Find Max 10g SAR
% [tempZ,tempY,tempX] = size(SAR_10g_3D);
% SAR_10g_1D = zeros(tempZ*tempY*tempX,4);
% n=0;
% for k=1:tempZ
%     for j=1:tempY
%         for i=1:tempX
%             n=n+1;
%             SAR_10g_1D(n,1) = i;
%             SAR_10g_1D(n,2) = j;
%             SAR_10g_1D(n,3) = k;
%             SAR_10g_1D(n,4) = SAR_10g_3D(k,j,i);
%         end;
%     end;
% end;
% [maxSAR_10g, ind] = max(SAR_10g_1D(:,4));
% 
% SAR_10g_1D(ind,1)
% SAR_10g_1D(ind,2)
% SAR_10g_1D(ind,3)
% SAR_10g_1D(ind,3)-1+zMin
% maxSAR_10g
% 
% SAR_10g_3D_final = permute(SAR_10g_3D,[3,2,1]);
% figure(5); imagesc(SAR_10g_3D_final(:,:,98-zMin+1)); axis image off; colormap jet2; caxis([0,2]);

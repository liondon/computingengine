%% kSpace & kNoise

% clear all;
clc;

Nx=128;
Ny=128;

fid=fopen('C:\Users\Zhipeng\Dropbox\Vanderbilt\MRF\GUI2014b\Protocols\MPF1\MPF111.ksig'); % kSpace

[kdata,cnt]=fread(fid,[2,inf],'float');
fclose(fid);

k_re=kdata(1,:);
k_im=kdata(2,:);
k_space_Raw=k_re+1i*k_im;

%-----------------------------------------------------

% fid=fopen('D:\PSUdoMRI\GUI2012a\Protocols\600Q\noiseSet1\600Q1.nois'); % kNoise
% 
% [kdata,cnt]=fread(fid,[2,inf],'float');
% fclose(fid);
% 
% k_re=kdata(1,:);
% k_im=kdata(2,:);
% k_noise_Raw = (k_re+1i*k_im) * (1.3^2);
% k_space_Raw = k_space_Raw + k_noise_Raw;

%-----------------------------------------------------

figure(3); plot(abs(k_space_Raw));
keyboard

k_space=reshape(k_space_Raw,Nx,Ny);

%-----------------------------------------------------

% % Down Sample
% for n=1:128/8
% k_space(8*n,:)=0;
% end;
% 
% EPI Flipping
for n=1:Ny
    if mod(n,2)==0
        k_space(:,n) = flipdim(k_space(:,n),1);
    end;
end;

%-----------------------------------------------------

imData1=ifftshift(ifft2(ifftshift(k_space(1:end,2:end))));

figure(1); imagesc(rot90(abs((imData1)))); axis image off; colormap gray; drawnow;
% figure(2); imagesc(rot90(abs((k_space(1:end,2:end))))); axis image off; colormap jet; drawnow;

%%
fid=fopen('C:\Users\Zhipeng\Dropbox\Vanderbilt\MRF\GUI2014b\Protocols\MPF1\kMap.bin'); % kSpace
% fid=fopen('C:\Users\Zhipeng\Dropbox\Vanderbilt\MRF\GUI2014b\Protocols\Test1\Test1.ktrj'); % kSpace
[kdata,cnt]=fread(fid,[3,inf],'float');
fclose(fid);

k_x = kdata(1,:);
k_y = kdata(2,:);
figure(5); plot(k_x,k_y);

clear all;
clc; 

Nx = 83; Ny = 109; Nz = 5;

flag = 3; % 1: Shim; 2: high SAR kT points; 3: low SAR kT points.

switch flag
    case 1
        dataRF = load([pwd,'\SetNew\Shim_RF.mat']);
        dataG  = load([pwd,'\SetNew\Shim_G.mat']);
    case 2
        dataRF = load([pwd,'\SetNew\OldKT_RF.mat']);
        dataG  = load([pwd,'\SetNew\OldKT_G.mat']);
    case 3
        dataRF = load([pwd,'\SetNew\NewKT_RF.mat']);
        dataG  = load([pwd,'\SetNew\NewKT_G.mat']);
end;

% ktRF = dataRF.Expression1;
rfMask = (abs(dataRF.Expression1) > 0);
ktRF = rfMask .* kron(normrnd(0,1,[1,5]), ones(8,100)) * 0.03;
figure(1); plot(1:500,ktRF);

% ktGrad = dataG.Expression1;
gMask = 1 - rfMask(1:3,:);
ktGrad = gMask .* kron( normrnd(0,1,[3,5]), ones(1,100)) * 1;
figure(2); plot(1:500,ktGrad);

data = load('300MHzDataforKTPoints.mat');

B1p = zeros(83,109,5,8);
B1p(:,:,:,1) = (data.geoData1) .* exp(1i*pi/4*1);
B1p(:,:,:,2) = (data.geoData2) .* exp(1i*pi/4*2);
B1p(:,:,:,3) = (data.geoData3) .* exp(1i*pi/4*3);
B1p(:,:,:,4) = (data.geoData4) .* exp(1i*pi/4*4);
B1p(:,:,:,5) = (data.geoData5) .* exp(1i*pi/4*5);
B1p(:,:,:,6) = (data.geoData6) .* exp(1i*pi/4*6);
B1p(:,:,:,7) = (data.geoData7) .* exp(1i*pi/4*7);
B1p(:,:,:,8) = (data.geoData8) .* exp(1i*pi/4*8);

% check RF shimming
B1pCombined = zeros(83,109,5);
for n=1:8
    B1pCombined = B1pCombined + B1p(:,:,:,n) .* ktRF(n,22);
end;
figure(1); imagesc(rot90( abs(squeeze(B1pCombined(:,:,3))))); axis image; colorbar; % caxis([0,1]);

clear data;

% keyboard;

M0 = 10;
mask = (abs(B1p(:,:,:,1)) > 0);
M = zeros(83,109,5,3); % M: (x,y,z,mag)
M(:,:,:,3) = mask * M0;

% keyboard;

% figure(1); imagesc(rot90( angle(B1p(:,:,1,1)))); axis image; colormap gray;
% figure(1); imagesc(rot90( abs(squeeze(B1p(:,:,3,1))))); axis image; colorbar;
% figure(1); imagesc(rot90( angle(squeeze(B1p(:,:,3,1)))/pi*180)); axis image; colorbar;
% figure(1); imagesc(rot90( squeeze(M(:,:,3,3)))); axis image;
% figure(1); imagesc(squeeze(M(:,:,3,3))); axis image;
% keyboard;

GridSize = 2.2/1000; % meter
% GridSize = 2/1000; % meter
[Gy,Gx,Gz] = meshgrid(1:Ny, 1:Nx, 1:Nz); % Weird Matlab Syntax
gradCtrX = 41.5; gradCtrY = 54.5; gradCtrZ = 2.5; % Original:(44,58,3) -> Martijn Version: (41.5,54.5,2.5)
% gradCtrX = 44; gradCtrY = 58; gradCtrZ = 3; % Original:(44,58,3) -> Martijn Version: (41.5,54.5,2.5)
Gx = (Gx-gradCtrX) .* GridSize;
Gy = (Gy-gradCtrY) .* GridSize;
Gz = (Gz-gradCtrZ) .* GridSize;
% figure(2); imagesc( rot90(Gz(:,:,3)) ); axis image; colorbar;

for idx = 1:size(ktRF,2)
    temp = zeros(83,109,5);
    for n=1:8
        temp = temp + B1p(:,:,:,n) .* ktRF(n,idx) .* 150;
    end;
    
    Beff(:,:,:,1) = real(temp);     % Beff_x
    Beff(:,:,:,2) = imag(temp);     % Beff_y
    
    tempGrad = 1/1000 * (Gx .* ktGrad(1,idx) + Gy .* ktGrad(2,idx) + Gz .* ktGrad(3,idx));
    Beff(:,:,:,3) = 2e-15 + tempGrad; % Beff_z, 2e-11 is a small value in case when Beff = 0;
    
    M = rotM(M,Beff,1e-6);
%     M = rotM(M,Beff / 5,1e-6 * 5);
end;

% % Reverse
% for idx = size(ktRF,2):-1:1
%     temp = zeros(83,109,5);
%     for n=1:8
%         temp = temp + B1p(:,:,:,n) .* ktRF(n,idx) .* 150;
%     end;
%     
%     Beff(:,:,:,1) = real(temp);     % Beff_x
%     Beff(:,:,:,2) = imag(temp);     % Beff_y
%     
%     tempGrad = 1/1000 * (Gx .* ktGrad(1,idx) + Gy .* ktGrad(2,idx) + Gz .* ktGrad(3,idx));
%     Beff(:,:,:,3) = 2e-15 + tempGrad; % Beff_z, 2e-11 is a small value in case when Beff = 0;
%     
%     M = rotM(M,-Beff,1e-6);
% %     M = rotM(M,Beff / 5,1e-6 * 5);
% end;

% |Mt|
figure(9);
for n=1:5
    subplot(2,3,n);
    imagesc( rot90( (abs(M(:,:,n,1) + 1i * M(:,:,n,2))) )); axis image; colorbar; % colormap jet2;
end;
% 
% % FA Map
% figure(10);
% for n=1:5
%     subplot(2,3,n);
%     imagesc( rot90( asin(abs(M(:,:,n,1) + 1i * M(:,:,n,2)) / M0)/pi*180 )); axis image; colorbar; % colormap jet2; % caxis([0,25]);
% end;
% 
% % Mt Phase
% figure(11);
% for n=1:5
%     subplot(2,3,n);
%     imagesc( rot90( angle(M(:,:,n,1) + 1i * M(:,:,n,2))/pi*180 )); axis image; colorbar; % colormap jet2; % caxis([0,25]);
% end;
% 

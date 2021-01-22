
gino = zeros(nf,np);
pino = gino;
pino2 = gino;
pino3 = gino;

pino(snr_row,snr_col) = 1;
figure; 
subplot(1,2,1)
imshow(pino)
title('PINO')
subplot(1,2,2)
imshow(snr_fov)
title('TARGET FOV')

for ix = 1:length(snr_row)
    pino2(snr_row(ix),snr_col(ix)) = 1;
end
figure; 
subplot(1,2,1)
imshow(pino2)
title('PINO 2')
subplot(1,2,2)
imshow(snr_fov)
title('TARGET FOV')

coordmine = find(snr_fov == 1);
pino3(coordmine) = 1;
figure; 
subplot(1,2,1)
imshow(pino3)
title('PINO 3')
subplot(1,2,2)
imshow(snr_fov)
title('TARGET FOV')


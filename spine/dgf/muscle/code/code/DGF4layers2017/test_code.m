figure;
subplot(1,2,1)
imshow(obj_fov,[]);
subplot(1,2,2)
imshow(obj_fov_scaled,[])

figure;
subplot(2,2,1);
imshow(scaledmask_reg4,[]);
subplot(2,2,2);
imshow(scaledmask_reg3,[]);
subplot(2,2,3);
imshow(scaledmask_reg2,[]);
subplot(2,2,4);
imshow(scaledmask_reg1,[]);

figure;
subplot(2,2,1);
imshow(output_values.mask_reg4,[]);
subplot(2,2,2);
imshow(output_values.mask_reg3 - output_values.mask_reg4,[]);
subplot(2,2,3);
imshow(output_values.mask_reg2 - output_values.mask_reg3,[]);
subplot(2,2,4);
imshow(output_values.mask_reg1,[]);

fov_reg4 = fullfov.*double(mask_reg4);
fov_reg3 = fullfov.*double(mask_reg3 - mask_reg4);
fov_reg2 = fullfov.*double(mask_reg2 - mask_reg3);
fov_reg1 = fullfov.*double(mask_reg1);

pino = output_values.efield_ult_set_fullfov;
for imode = 1:30
    pino2 = squeeze(pino(imode,:,:,:));
%     pino2magn = abs(sqrt(imresize(pino2(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
%         imresize(pino2(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
%         imresize(pino2(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
    pino2magn = abs(sqrt(pino2(:,:,1).^2 + pino2(:,:,2).^2 + pino2(:,:,3).^2));
    figure;
    imshow(pino2magn,[]);
    colormap(jet)
    imgui
end











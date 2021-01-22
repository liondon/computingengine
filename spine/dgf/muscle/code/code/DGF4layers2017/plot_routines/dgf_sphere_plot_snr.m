function [] = dgf_sphere_plot_snr(output_values,path_opts,plot_opts,snr_radius)

try
addpath(path_opts.commondir);
addpath(path_opts.plotdir);
catch
    display('MCR:)')
end
iptsetpref('ImshowInitialMagnification','fit');

x_fov = output_values.x_fov;
y_fov = output_values.y_fov;
z_fov = output_values.z_fov;

% display_range_coil = plot_opts.display_range_coil; % for fields plots
% display_range_ult = plot_opts.display_range_ult; % for fields plots

mask_snr = output_values.mask_snr;
snr_matrix_size = output_values.snr_matrix_size;

fieldstrength = output_values.fieldstrength;
acceleration = output_values.acceleration;

snr_ult = output_values.snr_ult;
snr_coil = output_values.snr_coil;

radius3 = output_values.g_opts.radius3;
radius2 = output_values.g_opts.radius2;
radius1 = output_values.g_opts.radius1;
currentradius = output_values.g_opts.currentradius;

plotlabel_ult = ['B_0 = ' num2str(fieldstrength) 'T, R = ' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
    ', radii = ' num2str(100*radius3) 'cm, ' num2str(100*radius2) 'cm, ' num2str(100*radius1) 'cm, and ' num2str(100*currentradius) 'cm, lmax= ' ...
    num2str(output_values.s_opts.lmax) ', whichcurrents=[' num2str(output_values.whichcurrents) ']'];

plotlabel_coil = [num2str(output_values.g_opts.ncoils) ' Circular Coils, B_0 = ' num2str(fieldstrength) 'T, R = ' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
    ', radii = ' num2str(100*radius3) 'cm, ' num2str(100*radius2) 'cm, ' num2str(100*radius1) 'cm, and ' num2str(100*currentradius) 'cm, lmax = ' num2str(output_values.s_opts.lmax)];

datelabel = ['      (' plot_opts.user_label ', '  datestr(now,0) ')'];

switch snr_radius
    case 1
        sphereradius = radius1;
    case 2
        sphereradius = radius2;
    case 3
        sphereradius = radius3;
end

if plot_opts.plot_coil_setup_flag
    figure;
    plot_geometry_sphere(sphereradius,output_values.g_opts.coil_radii,output_values.g_opts.coil_offsets,output_values.g_opts.coil_rotations,x_fov,y_fov,z_fov,3,'-',[1 0.46 0],0,plot_opts.plot_coil_number_flag)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    %
%       PLOT SNR AND  G-FACTOR       %
%                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x_fov) > 1,
    
    rho_fov = sqrt(x_fov.^2 + y_fov.^2 + z_fov.^2);
    costheta_fov = z_fov./rho_fov;
    costheta_fov(isnan(costheta_fov)) = 0;
    theta_fov = acos(costheta_fov);
    phi_fov = atan2(y_fov,x_fov);
    
    snr_ult(~output_values.mask_snr) = 0;
    snr_ult_max = max(real(snr_ult(output_values.mask_snr)));
    snr_ult_mean = mean(real(snr_ult(output_values.mask_snr)));
    
    snr_coil(~output_values.mask_snr) = 0;
    snr_coil_max = max(real(snr_coil(output_values.mask_snr)));
    snr_coil_mean = mean(real(snr_coil(output_values.mask_snr)));
    
    
    if (acceleration(1) > 1) || (acceleration(2) > 1)
        
        g_ult = output_values.g_ult;
        g_coil = output_values.g_coil;
        
        g_ult(~output_values.mask_snr) = 0;
        g_ult_max = max(real(g_ult(mask_snr)));
        g_ult_mean = mean(real(g_ult(mask_snr)));
        
        g_coil(~output_values.mask_snr) = 0;
        g_coil_max = max(real(g_coil(mask_snr)));
        g_coil_mean = mean(real(g_coil(mask_snr)));
    end
    
%     iptsetpref('ImshowInitialMagnification','fit');
    
    if plot_opts.plot_ultSNR,
        figure
        set(gcf,'name',plotlabel_ult);
        imshow(abs(snr_ult)',[]);
        colorbar
        title(['mean ult SNR = ' sprintf('%0.2f',snr_ult_mean) ', max ult SNR = ' sprintf('%0.2f',snr_ult_max)  datelabel])
        colormap(jet)
        if (acceleration(1) > 1) || (acceleration(2) > 1)
            figure
            set(gcf,'name',plotlabel_ult);
            imshow(real(g_ult)',[]);
            colorbar
            title(['mean ult g = ' sprintf('%0.2f',g_ult_mean) ', max ult g = ' sprintf('%0.2f',g_ult_max)  datelabel])
            colormap(jet)
        end
    end
    if plot_opts.plot_coilSNR,
        figure
        set(gcf,'name',plotlabel_coil);
        imshow(abs(snr_coil)',[]);
        colorbar
        title(['mean coil SNR = ' sprintf('%0.2f',snr_coil_mean) ', max coil SNR = ' sprintf('%0.2f',snr_coil_max)  datelabel])
        colormap(jet)
        if (acceleration(1) > 1) || (acceleration(2) > 1)
            figure
            set(gcf,'name',plotlabel_coil);
            imshow(real(g_coil)',[]);
            colorbar
            title(['mean coil g = ' sprintf('%0.2f',g_coil_mean) ', max coil g = ' sprintf('%0.2f',g_coil_max)  datelabel])
            colormap(jet)
        end
    end
    
else
    
    text_3 = ['B_0 = ' num2str(fieldstrength) 'T'];
    text_4 = ['Radii = ' num2str(100*radius3) 'cm, ' num2str(100*radius2) 'cm, ' num2str(100*radius1) 'cm, and ' num2str(100*currentradius) 'cm'];
    text_5 = ['lmax= ' num2str(output_values.s_opts.lmax) ', whichcurrents = [' num2str(output_values.whichcurrents) ']'];
    
    if plot_opts.plot_ultSNR,
        text_1 = ['Ult SNR at voxel (' num2str(100*x_fov) ',' num2str(100*y_fov) ',' num2str(100*z_fov) ') cm = ' num2str(abs(snr_ult)) ];
        text_2 = ['  '];
        
        msgHandle = msgbox({text_1,text_2,text_3,text_4,text_5},'Ultimate Intrinsic SNR');
        
        % get handles to the UIControls ([OK] PushButton) and Text
        kids0 = findobj( msgHandle, 'Type', 'UIControl' );
        kids1 = findobj( msgHandle, 'Type', 'Text' );
        
        set( msgHandle, 'Visible', 'off' );
        % change the fontsize
        extent0 = get( kids1, 'Extent' ); % text extent in old font
        set( [kids0, kids1], 'FontSize', plot_opts.plot_font_size);
        extent1 = get( kids1, 'Extent' ); % text extent in new font
        
        % need to resize the msgbox object to accommodate new FontName
        % and FontSize
        delta = extent1 - extent0; % change in extent
        pos = get( msgHandle, 'Position' ); % msgbox current position
        pos = pos + delta; % change size of msgbox
        set( msgHandle, 'Position', pos ); % set new position
        set( msgHandle, 'Visible', 'on' );
    end
    
    if plot_opts.plot_coilSNR,
        text_1 = ['Coil SNR at voxel (' num2str(100*x_fov) ',' num2str(100*y_fov) ',' num2str(100*z_fov) ') cm = ' num2str(abs(snr_coil)) ];
        text_2 = ['  '];
        
        msgHandle = msgbox({text_1,text_2,text_3,text_4,text_5},['SNR of the ' num2str(output_values.g_opts.ncoils) '-element coil array']);
        
        % get handles to the UIControls ([OK] PushButton) and Text
        kids0 = findobj( msgHandle, 'Type', 'UIControl' );
        kids1 = findobj( msgHandle, 'Type', 'Text' );
        
        set( msgHandle, 'Visible', 'off' );
        % change the fontsize
        extent0 = get( kids1, 'Extent' ); % text extent in old font
        set( [kids0, kids1], 'FontSize', plot_opts.plot_font_size);
        extent1 = get( kids1, 'Extent' ); % text extent in new font
        
        % need to resize the msgbox object to accommodate new FontName
        % and FontSize
        delta = extent1 - extent0; % change in extent
        pos = get( msgHandle, 'Position' ); % msgbox current position
        pos = pos + delta; % change size of msgbox
        set( msgHandle, 'Position', pos ); % set new position
        set( msgHandle, 'Visible', 'on' );
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%   PLOT COMBINATION WEIGHTS  %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_opts.plot_ult_current_weights && isempty(output_values.weights)
    disp('** Ultimate currents weights are not available')
    plot_opts.plot_ult_current_weights = 0;
end

if plot_opts.plot_ult_current_weights
    whichvoxelweights = output_values.whichvoxelweights;
    for iweights = 1:size(whichvoxelweights,1),
        xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        plotlabel_weights = char(...
            ['Ultimate combination weights (b=' num2str(100*currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        if length(output_values.whichcurrents) == 2
            figure;
            subplot(2,1,1)
            plot(abs(output_values.weights(:,1,iweights)));
            title(['Modes'' Combination Weights for Ultimate Intrinsic SNR (Magnetic-Dipole Type)']);
            subplot(2,1,2)
            plot(abs(output_values.weights(:,2,iweights)),'r');
            title(['Modes'' Combination Weights for Ultimate Intrinsic SNR (Electric-Dipole Type)']);
            set(gcf,'name',plotlabel_weights);
        else
            figure;
            plot(abs(output_values.weights(:,:,iweights)));
            if output_values.whichcurrents == 1
                title(['Modes'' Combination Weights for Ultimate Intrinsic SNR (Magnetic-Dipole Type)']);
            else
                title(['Modes'' Combination Weights for Ultimate Intrinsic SNR (Electric-Dipole Type)']);
            end
            set(gcf,'name',plotlabel_weights);
        end
    end
end

if plot_opts.plot_coil_current_weights && isempty(output_values.weights_coil)
    disp('** Coil currents weights are not available')
    plot_opts.plot_coil_current_weights = 0;
end

if plot_opts.plot_coil_current_weights
    whichvoxelweights = output_values.whichvoxelweights;
    for iweights = 1:size(whichvoxelweights,1),
        xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
        plotlabel_weights = char(...
            ['Coil combination weights (b=' num2str(100*currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        figure;
        plot(abs(output_values.weights_coil(:,iweights)));
        title(['Coils'' Combination Weights for Optimal SNR']);
        set(gcf,'name',plotlabel_weights);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%    PLOT CURRENT PATTERNS    %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_opts.plot_ult_current_patterns && isempty(output_values.currentpattern)
    disp('** Ultimate currents patterns are not available')
    plot_opts.plot_ult_current_patterns = 0;
end

if plot_opts.plot_ult_current_patterns,
    whichvoxels = output_values.whichvoxels;
    for ipatterns = 1:size(whichvoxels,1),
        xvox = x_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        yvox = y_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        zvox = z_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        plotlabel_ultcurr = char(...
            ['Ideal current patterns (b=' num2str(100*currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        plot_currentpatterns_sphere(1,fieldstrength,plot_opts,path_opts,...
            output_values.currentpattern(:,:,:,ipatterns),output_values.currentphi,output_values.currenttheta,plotlabel_ultcurr,[8 4])
    end
end

if plot_opts.plot_coil_current_patterns && isempty(output_values.currentpattern_coil)
    disp('** Coil currents patterns are not available')
    plot_opts.plot_coil_current_patterns = 0;
end

if plot_opts.plot_coil_current_patterns,
    whichvoxels = output_values.whichvoxels;
    for ipatterns = 1:size(whichvoxels,1),
        xvox = x_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        yvox = y_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        zvox = z_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        plotlabel_coilcurr = char(...
            ['Coil current patterns (b=' num2str(100*currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        plot_currentpatterns_sphere(2,fieldstrength,plot_opts,path_opts,...
            output_values.currentpattern_coil(:,:,:,ipatterns),output_values.currentphi,output_values.currenttheta,plotlabel_coilcurr,[8 4])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%    MOVIE CURRENT PATTERNS   %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_opts.movie_ult_current && isempty(output_values.currentpattern)
    disp('** Ultimate currents patterns are not available')
    plot_opts.movie_ult_current = 0;
end

if plot_opts.movie_ult_current,
    whichvoxels = output_values.whichvoxels;
    for ipatterns = 1:size(whichvoxels,1),
        xvox = x_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        yvox = y_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        zvox = z_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        plotlabel_ultcurr = char(...
            ['Ideal_current_patterns(b=' num2str(100*currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
            'T_voxel[x,y,z]=[' num2str(xvox*100,3) 'cm_' num2str(yvox*100,3) 'cm_' num2str(zvox*100,3) ...
            'cm]_whichcurrents=[' num2str(output_values.whichcurrents) ']_',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) 'accel)']);
        movie_currentpatterns_sphere(fieldstrength,plot_opts,output_values.g_opts,path_opts,...
            output_values.currentpattern(:,:,:,ipatterns),output_values.currentphi,output_values.currenttheta,plotlabel_ultcurr)
    end
end

if plot_opts.movie_coil_current && isempty(output_values.currentpattern_coil)
    disp('** Ultimate currents patterns are not available')
    plot_opts.movie_coil_current = 0;
end

if plot_opts.movie_coil_current,
    whichvoxels = output_values.whichvoxels;
    for ipatterns = 1:size(whichvoxels,1),
        xvox = x_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        yvox = y_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        zvox = z_fov(whichvoxels(ipatterns,1),whichvoxels(ipatterns,2));
        plotlabel_coilcurr = char(...
            ['Coil_current_patterns-' num2str(output_values.g_opts.ncoils) 'loops(b=' ...
            num2str(100*currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
            'T_voxel[x,y,z]=[' num2str(xvox*100,3) 'cm_' num2str(yvox*100,3) 'cm_' num2str(zvox*100,3) ...
            'cm]_whichcurrents=[' num2str(output_values.whichcurrents) ']_',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) 'accel)']);
        movie_currentpatterns_sphere(fieldstrength,plot_opts,output_values.g_opts,path_opts,...
            output_values.currentpattern_coil(:,:,:,ipatterns),output_values.currentphi,output_values.currenttheta,plotlabel_coilcurr)
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%     PLOT ELECTRIC FIELDS    %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (plot_opts.plot_efields_ult || plot_opts.plot_efields_coil || plot_opts.plot_bfields_ult || plot_opts.plot_bfields_coil)
        ix = size(x_fov,1)*plot_opts.scale_factor;
        iy = size(x_fov,2)*plot_opts.scale_factor;
        [xtemp,ytemp] = meshgrid(-((ix/2)-1):(ix/2),-((iy/2)-1):(iy/2));
        xtemp = xtemp - 1/2;
        ytemp = ytemp - 1/2;
%         scaledmask = ((xtemp.^2 + ytemp.^2) <= (ix/2)^2);
        [reg4x,reg4y] = find(output_values.mask_reg4 == 1);
        [reg3x,reg3y] = find(output_values.mask_reg3 == 1);
        [reg2x,reg2y] = find(output_values.mask_reg2 == 1);
        r4 = (max(reg4x(:))- min(reg4x(:)))*plot_opts.scale_factor;
        scaledmask_reg4 = ((xtemp.^2 + ytemp.^2) <= (r4/2)^2);
        r3 = (max(reg3x(:))- min(reg3x(:)))*plot_opts.scale_factor;
        scaledmask_reg3 = ((xtemp.^2 + ytemp.^2) <= (r3/2)^2) - scaledmask_reg4;
        r2 = (max(reg2x(:))- min(reg2x(:)))*plot_opts.scale_factor;
        scaledmask_reg2 = ((xtemp.^2 + ytemp.^2) <= (r2/2)^2) - ((xtemp.^2 + ytemp.^2) <= (r3/2)^2);
        scaledmask_reg1 = -((xtemp.^2 + ytemp.^2) <= (r2/2)^2);
        if 0
            % PLOT SCALED MASKS %
            figure;
            subplot(2,2,1);
            imshow(scaledmask_reg4,[]);
            subplot(2,2,2);
            imshow(scaledmask_reg3,[]);
            subplot(2,2,3);
            imshow(scaledmask_reg2,[]);
            subplot(2,2,4);
            imshow(scaledmask_reg1,[]);
            % ----------------- %
        end
end


% E field, ultimate case
if plot_opts.plot_efields_ult && isempty(output_values.efield_ult_set_fullfov)
    disp('** Modes'' electric fields are not available')
    plot_opts.plot_efields_ult = 0;
end
if plot_opts.plot_efields_ult && ((size(output_values.efield_ult_set_fullfov,2)==1)||(size(output_values.efield_ult_set_fullfov,3)==1))
    disp('** Modes'' electric fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_efields_ult = 0;
end
if plot_opts.plot_efields_ult && ((size(output_values.efield_ult_set_fullfov,2)>1)&&(size(output_values.efield_ult_set_fullfov,3)>1))
    % Object (ALL LAYERS)
    obj_fov = output_values.mask_reg2;
    obj_fov_scaled = scaledmask_reg4 + scaledmask_reg3 + scaledmask_reg2;
    mask_3d = repmat(obj_fov,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate Current weights are not available, unit weights combination for net electric field')
        efield_ult_net = mask_3d.*squeeze(sum(output_values.efield_ult_set_fullfov,1));
        efield_mag = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag(~obj_fov_scaled) = 0;
        figure;
        imshow(efield_mag,'DisplayRange',display_range_ult);
        colormap(jet)
        efield_label = ('Magnitude of the Net Electric Field (Ultimate Case, Unit-Weight Combination)');
        set(gcf,'name',efield_label);
        title('Net Electric Field  (Ultimate Case, Unit-Weight Combination)')
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,iweights),[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
            end
            
            efield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_ult_set_fullfov,1));
            efield_mag = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag(~obj_fov_scaled) = 0;
                          
            figure;
            imshow(efield_mag,'DisplayRange',display_range_ult);
            colormap(jet)
            efield_label = (['Magnitude of the Net Electric Field (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            title(['Net Electric Field  (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
        end
    end
    % SEPARATE REGIONS
    mask_3d_r4 = repmat(output_values.mask_reg4,[1 1 3]);
    mask_3d_r3 = repmat((output_values.mask_reg3 - output_values.mask_reg4),[1 1 3]);
    mask_3d_r2 = repmat((output_values.mask_reg2 - output_values.mask_reg3),[1 1 3]);
    mask_3d_r1 = repmat(output_values.mask_reg1,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate Current weights are not available, unit weights combination for net electric field')
        efield_ult_net = mask_3d_r4.*squeeze(sum(output_values.efield_ult_set_fullfov,1));
        efield_mag_r4 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r4(~scaledmask_reg4) = 0;
        efield_ult_net = mask_3d_r3.*squeeze(sum(output_values.efield_ult_set_fullfov,1));
        efield_mag_r3 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r3(~scaledmask_reg3) = 0;
        efield_ult_net = mask_3d_r2.*squeeze(sum(output_values.efield_ult_set_fullfov,1));
        efield_mag_r2 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r2(~scaledmask_reg2) = 0;
        efield_ult_net = mask_3d_r1.*squeeze(sum(output_values.efield_ult_set_fullfov,1));
        efield_mag_r1 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r1(~scaledmask_reg1) = 0;
        
        figure;
        subplot(2,2,1)
        imshow(efield_mag_r4,'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(efield_mag_r3,'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(efield_mag_r2,'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(efield_mag_r1,'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        efield_label = ('Magnitude of the Net Electric Field (Ultimate Case, Unit-Weight Combination)');
        set(gcf,'name',efield_label);
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,iweights),[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
            end
            
            efield_ult_net = mask_3d_r4.*squeeze(sum(weights_set.*output_values.efield_ult_set_fullfov,1));
            efield_mag_r4 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r4(~scaledmask_reg4) = 0;
            efield_ult_net = mask_3d_r3.*squeeze(sum(weights_set.*output_values.efield_ult_set_fullfov,1));
            efield_mag_r3 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r3(~scaledmask_reg3) = 0;
            efield_ult_net = mask_3d_r2.*squeeze(sum(weights_set.*output_values.efield_ult_set_fullfov,1));
            efield_mag_r2 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r2(~scaledmask_reg2) = 0;
            efield_ult_net = mask_3d_r1.*squeeze(sum(weights_set.*output_values.efield_ult_set_fullfov,1));
            efield_mag_r1 = sqrt(imresize(abs(efield_ult_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_ult_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_ult_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r1(~scaledmask_reg1) = 0;
            
            figure;
            subplot(2,2,1)
            imshow(efield_mag_r4,'DisplayRange',display_range_ult);
            title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
            subplot(2,2,2)
            imshow(efield_mag_r3,'DisplayRange',display_range_ult);
            title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
            subplot(2,2,3)
            imshow(efield_mag_r2,'DisplayRange',display_range_ult);
            title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            subplot(2,2,4)
            imshow(efield_mag_r1,'DisplayRange',display_range_ult);
            title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            axis square
            colormap(jet)
            efield_label = (['Magnitude of the Net Electric Field (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
        end
    end
end

% E field, coil case
if plot_opts.plot_efields_coil && isempty(output_values.efield_coil_set_fullfov)
    disp('** Coils'' electric fields are not available')
    plot_opts.plot_efields_coil = 0;
end
if plot_opts.plot_efields_coil && ((size(output_values.efield_coil_set_fullfov,2)==1)||(size(output_values.efield_coil_set_fullfov,3)==1))
    disp('** Coils'' electric fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_efields_ult = 0;
end

if plot_opts.plot_efields_coil && ((size(output_values.efield_coil_set_fullfov,2)>1)&&(size(output_values.efield_coil_set_fullfov,3)>1))
    % Object (ALL LAYERS)
    obj_fov = output_values.mask_reg2;
    obj_fov_scaled = scaledmask_reg4 + scaledmask_reg3 + scaledmask_reg2;
    mask_3d = repmat(obj_fov,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Coil Current weights are not available, unit weights combination for net electric field')
        efield_coil_net = mask_3d.*squeeze(sum(output_values.efield_coil_set_fullfov,1));
        efield_mag = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag(~obj_fov_scaled) = 0;
        figure;
        imshow(efield_mag,'DisplayRange',display_range_coil);
        colormap(jet)
        efield_label = ('Magnitude of the Net Electric Field (Coil Case, Unit-Weight Combination)');
        set(gcf,'name',efield_label);
        title('Net Electric Field  (Coil case, Unit-Weight Combination)')
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights_coil(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_coil_set_fullfov,2) size(output_values.efield_coil_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights_coil(:,:,iweights),[1 size(output_values.efield_coil_set_fullfov,2) size(output_values.efield_coil_set_fullfov,3) 3]);
            end
            
            efield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_coil_set_fullfov,1));
            
            efield_mag = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag(~obj_fov_scaled) = 0;
            
            figure;
            imshow(efield_mag,'DisplayRange',display_range_coil);
            colormap(jet)
            efield_label = (['Magnitude of the Net Electric Field (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            title(['Net Electric Field  (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
            
            efield_coils =  (weights_set.*output_values.efield_coil_set_fullfov);
            if output_values.g_opts.ncoils > 64
                plot_rows = 8;
                plot_col = floor(output_values.g_opts.ncoils/8) + mod(output_values.g_opts.ncoils,8);
            else
                plot_rows = 4;
                plot_col = floor(output_values.g_opts.ncoils/4) + mod(output_values.g_opts.ncoils,4);
            end
            figure;
            efield_label = (['Magnitude of the Coils'' Electric Field (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            for icoil = 1:output_values.g_opts.ncoils
                efield_temp =  mask_3d.*squeeze(efield_coils(icoil,:,:,:));
                efield_temp_mag = sqrt(imresize(abs(efield_temp(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                    imresize(abs(efield_temp(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                    imresize(abs(efield_temp(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
                efield_temp_mag(~obj_fov_scaled) = 0;
                subplot(plot_rows,plot_col,icoil);
                imshow(efield_temp_mag,'DisplayRange',display_range_coil);
                title(['Coil ' num2str(icoil)]);
            end
            colormap('jet')
        end
    end
    % SEPARATE REGIONS
    mask_3d_r4 = repmat(output_values.mask_reg4,[1 1 3]);
    mask_3d_r3 = repmat((output_values.mask_reg3 - output_values.mask_reg4),[1 1 3]);
    mask_3d_r2 = repmat((output_values.mask_reg2 - output_values.mask_reg3),[1 1 3]);
    mask_3d_r1 = repmat(output_values.mask_reg1,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Ultimate Current weights are not available, unit weights combination for net electric field')
        efield_coil_net = mask_3d_r4.*squeeze(sum(output_values.efield_coil_set_fullfov,1));
        efield_mag_r4 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r4(~scaledmask_reg4) = 0;
        efield_coil_net = mask_3d_r3.*squeeze(sum(output_values.efield_coil_set_fullfov,1));
        efield_mag_r3 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r3(~scaledmask_reg3) = 0;
        efield_coil_net = mask_3d_r2.*squeeze(sum(output_values.efield_coil_set_fullfov,1));
        efield_mag_r2 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r2(~scaledmask_reg2) = 0;
        efield_coil_net = mask_3d_r1.*squeeze(sum(output_values.efield_coil_set_fullfov,1));
        efield_mag_r1 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
        efield_mag_r1(~scaledmask_reg1) = 0;
        
        figure;
        subplot(2,2,1)
        imshow(efield_mag_r4,'DisplayRange',display_range_coil);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(efield_mag_r3,'DisplayRange',display_range_coil);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(efield_mag_r2,'DisplayRange',display_range_coil);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(efield_mag_r1,'DisplayRange',display_range_coil);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        efield_label = ('Magnitude of the Net Electric Field (Coil Case, Unit-Weight Combination)');
        set(gcf,'name',efield_label);
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights_coil(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights_coil(:,:,iweights),[1 size(output_values.efield_coil_set_fullfov,2) size(output_values.efield_coil_set_fullfov,3) 3]);
            end
            
            efield_coil_net = mask_3d_r4.*squeeze(sum(weights_set.*output_values.efield_coil_set_fullfov,1));
            efield_mag_r4 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r4(~scaledmask_reg4) = 0;
            efield_coil_net = mask_3d_r3.*squeeze(sum(weights_set.*output_values.efield_coil_set_fullfov,1));
            efield_mag_r3 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r3(~scaledmask_reg3) = 0;
            efield_coil_net = mask_3d_r2.*squeeze(sum(weights_set.*output_values.efield_coil_set_fullfov,1));
            efield_mag_r2 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r2(~scaledmask_reg2) = 0;
            efield_coil_net = mask_3d_r1.*squeeze(sum(weights_set.*output_values.efield_coil_set_fullfov,1));
            efield_mag_r1 = sqrt(imresize(abs(efield_coil_net(:,:,1)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(abs(efield_coil_net(:,:,2)).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(abs(efield_coil_net(:,:,3)).^2,plot_opts.scale_factor,plot_opts.interp_method));
            efield_mag_r1(~scaledmask_reg1) = 0;
            
            figure;
            subplot(2,2,1)
            imshow(efield_mag_r4,'DisplayRange',display_range_coil);
            title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
            subplot(2,2,2)
            imshow(efield_mag_r3,'DisplayRange',display_range_coil);
            title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
            subplot(2,2,3)
            imshow(efield_mag_r2,'DisplayRange',display_range_coil);
            title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            subplot(2,2,4)
            imshow(efield_mag_r1,'DisplayRange',display_range_coil);
            title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            axis square
            colormap(jet)
            efield_label = (['Magnitude of the Net Electric Field (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%     PLOT MAGNETIC FIELDS    %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% B field, ultimate case
if plot_opts.plot_bfields_ult && isempty(output_values.bfield_ult_set_fullfov)
    disp('** Modes'' magnetic fields are not available')
    plot_opts.plot_bfields_ult = 0;
end
if plot_opts.plot_bfields_ult && ((size(output_values.bfield_ult_set_fullfov,2)==1)||(size(output_values.bfield_ult_set_fullfov,3)==1))
    disp('** Modes'' magnetic fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_bfields_ult = 0;
end

if plot_opts.plot_bfields_ult && ((size(output_values.bfield_ult_set_fullfov,2)>1)&&(size(output_values.bfield_ult_set_fullfov,3)>1))
    obj_fov = output_values.mask_reg2;
    obj_fov_scaled = scaledmask_reg4 + scaledmask_reg3 + scaledmask_reg2;
%     figure; imshow(obj_fov,[]);
    mask_3d = repmat(obj_fov,[1 1 3]);
%     mask_3d = repmat(output_values.mask_snr,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate current weights are not available, unit weights combination for net magnetic field')
        bfield_ult_net = mask_3d.*squeeze(sum(output_values.bfield_ult_set_fullfov,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~obj_fov_scaled) = 0;
        
        figure;
        imshow(bfield_mag,'DisplayRange',display_range_ult);
        colormap(jet)
        bfield_label = ('Magnitude of the net magnetic field (ultimate case, unit-weight combination)');
        set(gcf,'name',bfield_label);
        title('Net Magnetic Field  (Ultimate case, unit-weight combination)')
        
        b1plus_net = imresize(bfield_ult_net(:,:,1) + 1i*bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        figure;
        subplot(1,2,1)
        imshow(abs(b1plus_net),'DisplayRange',display_range_ult);
        title('Magnitude of net B1+ (ultimate case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1plus_net),real(b1plus_net)),[]);
        title('Phase of net B1+ (ultimate case, unit-weight combination)');
        b1plus_label = ('Magnitude and phase of the net B1+ (ultimate case, unit-weight combination)');
        set(gcf,'name',b1plus_label);
        colormap(jet)

        b1minus_net = imresize(bfield_ult_net(:,:,1) - 1i*bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        figure;
        subplot(1,2,1)
        imshow(abs(b1minus_net),'DisplayRange',display_range_ult);
        title('Magnitude of net B1- (ultimate case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1minus_net),real(b1minus_net)),[]);
        title('Phase of net B1- (ultimate case, unit-weight combination)');
        b1minus_label = ('Magnitude and phase of the net B1- (ultimate case, unit-weight combination)');
        set(gcf,'name',b1minus_label);
        colormap(jet)
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.bfield_ult_set_fullfov,2) size(output_values.bfield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,iweights),[1 size(output_values.bfield_ult_set_fullfov,2) size(output_values.bfield_ult_set_fullfov,3) 3]);
            end
            
            bfield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_ult_set_fullfov,1));
             
            bfield_mag = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag(~obj_fov_scaled) = 0;
            
            figure;
            imshow(bfield_mag,[]);
            colormap(jet)
            bfield_label = (['Magnitude of the net magnetic field (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
            title('Net Magnetic Field  (Ultimate case)')
            
            b1plus_net = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_net(~obj_fov_scaled) = 0;
            
            figure;
            subplot(1,2,1)
            imshow(abs(b1plus_net),'DisplayRange',display_range_ult);
            title('Magnitude of net B1+ (Ultimate case)')
            subplot(1,2,2)
            imshow(atan2(imag(b1plus_net),real(b1plus_net)),[]);
            title('Phase of net B1+ (Ultimate case)')
            b1plus_label = (['Magnitude and phase of the net B1+ (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',b1plus_label);
            colormap(jet)
            
            b1minus_net = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_net(~obj_fov_scaled) = 0;
            
            figure;
            subplot(1,2,1)
            imshow(abs(b1minus_net),'DisplayRange',display_range_ult);
            title('Magnitude of net B1- (Ultimate case)')
            subplot(1,2,2)
            imshow(atan2(imag(b1minus_net),real(b1minus_net)),[]);
            title('Phase of net B1- (Ultimate case)')
            b1minus_label = (['Magnitude and phase of the net B1- (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',b1minus_label);
            colormap(jet)
        end
    end
    
    % SEPARATE REGIONS
    mask_3d_r4 = repmat(output_values.mask_reg4,[1 1 3]);
    mask_3d_r3 = repmat((output_values.mask_reg3 - output_values.mask_reg4),[1 1 3]);
    mask_3d_r2 = repmat((output_values.mask_reg2 - output_values.mask_reg3),[1 1 3]);
    mask_3d_r1 = repmat(output_values.mask_reg1,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate Current weights are not available, unit weights combination for net magnetic field')
        bfield_ult_net = mask_3d_r4.*squeeze(sum(output_values.bfield_ult_set_fullfov,1));
        bfield_mag_r4 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r4(~scaledmask_reg4) = 0;
        b1plus_r4 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r4(~scaledmask_reg4) = 0;
        b1minus_r4 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r4(~scaledmask_reg4) = 0;

        bfield_ult_net = mask_3d_r3.*squeeze(sum(output_values.bfield_ult_set_fullfov,1));
        bfield_mag_r3 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r3(~scaledmask_reg3) = 0;
        b1plus_r3 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r3(~scaledmask_reg3) = 0;
        b1minus_r3 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r3(~scaledmask_reg3) = 0;
        
        bfield_ult_net = mask_3d_r2.*squeeze(sum(output_values.bfield_ult_set_fullfov,1));
        bfield_mag_r2 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r2(~scaledmask_reg2) = 0;
        b1plus_r2 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r2(~scaledmask_reg2) = 0;
        b1minus_r2 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r2(~scaledmask_reg2) = 0;
        
        bfield_ult_net = mask_3d_r1.*squeeze(sum(output_values.bfield_ult_set_fullfov,1));
        bfield_mag_r1 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r1(~scaledmask_reg1) = 0;
        b1plus_r1 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r1(~scaledmask_reg2) = 0;
        b1minus_r1 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r1(~scaledmask_reg2) = 0;
        
        figure;
        subplot(2,2,1)
        imshow(bfield_mag_r4,'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(bfield_mag_r3,'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(bfield_mag_r2,'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(bfield_mag_r1,'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of the Net Magnetic Field (Ultimate Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
    
        figure;
        subplot(2,2,1)
        imshow(abs(b1plus_r4),'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1plus_r3),'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1plus_r2),'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1plus_r1),'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of net B1+ (Ultimate Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
    
        figure;
        subplot(2,2,1)
        imshow(abs(b1minus_r4),'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1minus_r3),'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1minus_r2),'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1minus_r1),'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of net B1- (Ultimate Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,iweights),[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
            end
            
            bfield_ult_net = mask_3d_r4.*squeeze(sum(weights_set.*output_values.bfield_ult_set_fullfov,1));
            bfield_mag_r4 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r4(~scaledmask_reg4) = 0;
            b1plus_r4 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r4(~scaledmask_reg4) = 0;
            b1minus_r4 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r4(~scaledmask_reg4) = 0;
            
            bfield_ult_net = mask_3d_r3.*squeeze(sum(weights_set.*output_values.bfield_ult_set_fullfov,1));
            bfield_mag_r3 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r3(~scaledmask_reg3) = 0;
            b1plus_r3 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r3(~scaledmask_reg3) = 0;
            b1minus_r3 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r3(~scaledmask_reg3) = 0;
            
            bfield_ult_net = mask_3d_r2.*squeeze(sum(weights_set.*output_values.bfield_ult_set_fullfov,1));
            bfield_mag_r2 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r2(~scaledmask_reg2) = 0;
            b1plus_r2 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r2(~scaledmask_reg2) = 0;
            b1minus_r2 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r2(~scaledmask_reg2) = 0;
            
            bfield_ult_net = mask_3d_r1.*squeeze(sum(weights_set.*output_values.bfield_ult_set_fullfov,1));
            bfield_mag_r1 = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r1(~scaledmask_reg1) = 0;
            b1plus_r1 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r1(~scaledmask_reg2) = 0;
            b1minus_r1 = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r1(~scaledmask_reg2) = 0;
        
        figure;
        subplot(2,2,1)
        imshow(bfield_mag_r4,'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(bfield_mag_r3,'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(bfield_mag_r2,'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(bfield_mag_r1,'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = (['Magnitude of the Net Magnetic Field (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
        set(gcf,'name',bfield_label);
    
        figure;
        subplot(2,2,1)
        imshow(abs(b1plus_r4),'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1plus_r3),'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1plus_r2),'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1plus_r1),'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = (['Magnitude of the Net B1+ (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
        set(gcf,'name',bfield_label);
    
        figure;
        subplot(2,2,1)
        imshow(abs(b1minus_r4),'DisplayRange',display_range_ult);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1minus_r3),'DisplayRange',display_range_ult);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1minus_r2),'DisplayRange',display_range_ult);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1minus_r1),'DisplayRange',display_range_ult);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = (['Magnitude of the Net B1- (Ultimate Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
        set(gcf,'name',bfield_label);
        end
    end
end

% B field, coil case
if plot_opts.plot_bfields_coil && isempty(output_values.bfield_coil_set_fullfov)
    disp('** Coils'' magnetic fields are not available')
    plot_opts.plot_bfields_coil = 0;
end
if plot_opts.plot_bfields_coil && ((size(output_values.bfield_coil_set_fullfov,2)==1)||(size(output_values.bfield_coil_set_fullfov,3)==1))
    disp('** Coils'' magnetic fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_bfields_coil = 0;
end

if plot_opts.plot_bfields_coil && ((size(output_values.bfield_coil_set_fullfov,2)>1)&&(size(output_values.bfield_coil_set_fullfov,3)>1))
    obj_fov = output_values.mask_reg2;
    obj_fov_scaled = scaledmask_reg4 + scaledmask_reg3 + scaledmask_reg2;
    mask_3d = repmat(obj_fov,[1 1 3]);
%     mask_3d = repmat(output_values.mask_snr,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Coil current weights are not available, unit weights combination for net magnetic field')
        bfield_coil_net = mask_3d.*squeeze(sum(output_values.bfield_coil_set_fullfov,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~obj_fov_scaled) = 0;
        
        figure;
        imshow(bfield_mag,'DisplayRange',display_range_coil);
        colormap(jet)
        bfield_label = ('Magnitude of the net magnetic field (coil case, unit-weight combination)');
        set(gcf,'name',bfield_label);
        title('Net Magnetic Field  (Coil case, unit-weight combination)')
        
        b1plus_coil_net = imresize(bfield_coil_net(:,:,1) + 1i*bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_coil_net(~obj_fov_scaled) = 0;
        figure;
        subplot(1,2,1)
        imshow(abs(b1plus_coil_net),'DisplayRange',display_range_coil);
        title('Magnitude of net B1+ (coil case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1plus_coil_net),real(b1plus_coil_net)),[]);
        title('Phase of net B1+ (coil case, unit-weight combination)');
        b1plus_label = ('Magnitude and phase of the net B1+ (coil case, unit-weight combination)');
        set(gcf,'name',b1plus_label);
        colormap(jet)

        b1minus_coil_net = imresize(bfield_coil_net(:,:,1) - 1i*bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_coil_net(~obj_fov_scaled) = 0;
        figure;
        subplot(1,2,1)
        imshow(abs(b1minus_coil_net),'DisplayRange',display_range_coil);
        title('Magnitude of net B1- (coil case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1minus_coil_net),real(b1minus_coil_net)),[]);
        title('Phase of net B1- (coil case, unit-weight combination)');
        b1minus_label = ('Magnitude and phase of the net B1- (coil case, unit-weight combination)');
        set(gcf,'name',b1minus_label);
        colormap(jet)
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights_coil(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.bfield_coil_set_fullfov,2) size(output_values.bfield_coil_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights_coil(:,:,iweights),[1 size(output_values.bfield_coil_set_fullfov,2) size(output_values.bfield_coil_set_fullfov,3) 3]);
            end
            
            bfield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_coil_set_fullfov,1)); % SIMPLE SUM OR SHOULD I DO SUM OF SQUARES???
            
            bfield_mag = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag(~obj_fov_scaled) = 0;
            
            figure;
            imshow(bfield_mag,'DisplayRange',display_range_coil);
            colormap(jet)
            bfield_label = (['Magnitude of the net magnetic field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
            title(['Net Magnetic Field  (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
            
            b1plus_coil_net = imresize(bfield_coil_net(:,:,1) + 1i*bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_coil_net(~obj_fov_scaled) = 0;
            figure;
            subplot(1,2,1)
            imshow(abs(b1plus_coil_net),'DisplayRange',display_range_coil);
            title('Magnitude of net B1+ (coil case, weighted combination)');
            subplot(1,2,2)
            imshow(atan2(imag(b1plus_coil_net),real(b1plus_coil_net)),[]);
            title('Phase of net B1+ (coil case, weighted combination)');
            b1plus_label = (['Magnitude and phase of net B1+ (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',b1plus_label);
            colormap(jet)
            
            b1minus_coil_net = imresize(bfield_coil_net(:,:,1) - 1i*bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_coil_net(~obj_fov_scaled) = 0;
            figure;
            subplot(1,2,1)
            imshow(abs(b1minus_coil_net),'DisplayRange',display_range_coil);
            title('Magnitude of net B1- (coil case, weighted combination)');
            subplot(1,2,2)
            imshow(atan2(imag(b1minus_coil_net),real(b1minus_coil_net)),[]);
            title('Phase of net B1- (coil case, weighted combination)');
            b1minus_label = (['Magnitude and phase of net B1- (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',b1minus_label);
            colormap(jet)
                
            if size(output_values.bfield_coil_set_fullfov,1) > 1
                % B1+ and B1- fields of individual coils
                bfield_coils =  (weights_set.*output_values.bfield_coil_set_fullfov);
                
                if output_values.g_opts.ncoils > 64
                    plot_rows = 8;
                    plot_col = floor(output_values.g_opts.ncoils/8) + mod(output_values.g_opts.ncoils,8);
                else
                    plot_rows = 4;
                    plot_col = floor(output_values.g_opts.ncoils/4) + mod(output_values.g_opts.ncoils,4);
                end
                
                b1plus_coils = bfield_coils(:,:,:,1) + 1i*bfield_coils(:,:,:,2);
                
                figure;
                bfield_label = (['Magnitude of the coils'' B1+ field (coil case, weights of voxel [' num2str(100*xvox) ...
                    ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
                set(gcf,'name',bfield_label);
                for icoil = 1:output_values.g_opts.ncoils
                    subplot(plot_rows,plot_col,icoil);
                    b1plus_temp = abs(squeeze(b1plus_coils(icoil,:,:)));
                    b1plus_temp = imresize(b1plus_temp,plot_opts.scale_factor,plot_opts.interp_method);
                    b1plus_temp(~obj_fov_scaled) = 0;
                    imshow(b1plus_temp,'DisplayRange',display_range_coil);
                    title(['Coil ' num2str(icoil)]);
                    colormap(jet)
                end
                colormap('jet')
                if plot_opts.plot_coil_b1plus_phase
                    figure;
                    bfield_label = (['Phase of the coils'' B1+ field (coil case, weights of voxel [' num2str(100*xvox) ...
                        ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
                    set(gcf,'name',bfield_label);
                    for icoil = 1:output_values.g_opts.ncoils
                        bfield_temp = squeeze(b1plus_coils(icoil,:,:));
                        bfield_temp = imresize(bfield_temp,plot_opts.scale_factor,plot_opts.interp_method);
                        bfield_temp(~obj_fov_scaled) = 0;
                        subplot(plot_rows,plot_col,icoil);
                        imshow(atan2(imag(bfield_temp),real(bfield_temp)),[]);
                        title(['Coil ' num2str(icoil)]);
                        colormap(jet)
                    end
                    colormap('jet')
                end
                
                b1minus_coils = bfield_coils(:,:,:,1) - 1i*bfield_coils(:,:,:,2);
                figure;
                bfield_label = (['Magnitude of the coils'' B1- field (coil case, weights of voxel [' num2str(100*xvox) ...
                    ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
                set(gcf,'name',bfield_label);
                for icoil = 1:output_values.g_opts.ncoils
                    subplot(plot_rows,plot_col,icoil);
                    b1minus_temp = abs(squeeze(b1minus_coils(icoil,:,:)));
                    b1minus_temp = imresize(b1minus_temp,plot_opts.scale_factor,plot_opts.interp_method);
                    b1minus_temp(~obj_fov_scaled) = 0;
                    imshow(b1minus_temp,'DisplayRange',display_range_coil);
                    title(['Coil ' num2str(icoil)]);
                    colormap(jet)
                end
                colormap('jet')
                if plot_opts.plot_coil_b1minus_phase
                    figure;
                    bfield_label = (['Phase of the coils'' B1- field (coil case, weights of voxel [' num2str(100*xvox) ...
                        ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
                    set(gcf,'name',bfield_label);
                    for icoil = 1:output_values.g_opts.ncoils
                        bfield_temp = squeeze(b1minus_coils(icoil,:,:));
                        bfield_temp = imresize(bfield_temp,plot_opts.scale_factor,plot_opts.interp_method);
                        bfield_temp(~obj_fov_scaled) = 0;
                        subplot(plot_rows,plot_col,icoil);
                        imshow(atan2(imag(bfield_temp),real(bfield_temp)),[]);
                        title(['Coil ' num2str(icoil)]);
                        colormap(jet)
                    end
                    colormap('jet')
                end
            end
        end
    end
    % SEPARATE REGIONS    
    mask_3d_r4 = repmat(output_values.mask_reg4,[1 1 3]);
    mask_3d_r3 = repmat((output_values.mask_reg3 - output_values.mask_reg4),[1 1 3]);
    mask_3d_r2 = repmat((output_values.mask_reg2 - output_values.mask_reg3),[1 1 3]);
    mask_3d_r1 = repmat(output_values.mask_reg1,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Ultimate Current weights are not available, unit weights combination for net electric field')
        bfield_coil_net = mask_3d_r4.*squeeze(sum(output_values.bfield_coil_set_fullfov,1));
        bfield_mag_r4 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r4(~scaledmask_reg4) = 0;
        b1plus_r4 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r4(~scaledmask_reg4) = 0;
        b1minus_r4 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r4(~scaledmask_reg4) = 0;
        
        bfield_coil_net = mask_3d_r3.*squeeze(sum(output_values.bfield_coil_set_fullfov,1));
        bfield_mag_r3 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r3(~scaledmask_reg3) = 0;
        b1plus_r3 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r3(~scaledmask_reg3) = 0;
        b1minus_r3 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r3(~scaledmask_reg3) = 0;
               
        bfield_coil_net = mask_3d_r2.*squeeze(sum(output_values.bfield_coil_set_fullfov,1));
        bfield_mag_r2 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r2(~scaledmask_reg2) = 0;
        b1plus_r2 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r2(~scaledmask_reg2) = 0;
        b1minus_r2 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r2(~scaledmask_reg2) = 0;
        
        bfield_coil_net = mask_3d_r1.*squeeze(sum(output_values.bfield_coil_set_fullfov,1));
        bfield_mag_r1 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag_r1(~scaledmask_reg1) = 0;
        b1plus_r1 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_r1(~scaledmask_reg1) = 0;
        b1minus_r1 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_r1(~scaledmask_reg1) = 0;
        
        figure;
        subplot(2,2,1)
        imshow(abs(bfield_mag_r4),'DisplayRange',display_range_coil);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(bfield_mag_r3),'DisplayRange',display_range_coil);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(bfield_mag_r2),'DisplayRange',display_range_coil);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(bfield_mag_r1),'DisplayRange',display_range_coil);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of the Net Magnetic Field (Coil Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
        
        figure;
        subplot(2,2,1)
        imshow(abs(b1plus_r4),'DisplayRange',display_range_coil);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1plus_r3),'DisplayRange',display_range_coil);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1plus_r2),'DisplayRange',display_range_coil);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1plus_r1),'DisplayRange',display_range_coil);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of the Net B1+ (Coil Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
        
        figure;
        subplot(2,2,1)
        imshow(abs(b1minus_r4),'DisplayRange',display_range_coil);
        title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
        subplot(2,2,2)
        imshow(abs(b1minus_r3),'DisplayRange',display_range_coil);
        title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
        subplot(2,2,3)
        imshow(abs(b1minus_r2),'DisplayRange',display_range_coil);
        title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        subplot(2,2,4)
        imshow(abs(b1minus_r1),'DisplayRange',display_range_coil);
        title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
        axis square
        colormap(jet)
        bfield_label = ('Magnitude of the Net B1- (Coil Case, Unit-Weight Combination)');
        set(gcf,'name',bfield_label);
    else
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights_coil(:,:,iweights);
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set_fullfov,2) size(output_values.efield_ult_set_fullfov,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights_coil(:,:,iweights),[1 size(output_values.efield_coil_set_fullfov,2) size(output_values.efield_coil_set_fullfov,3) 3]);
            end
            
            bfield_coil_net = mask_3d_r4.*squeeze(sum(weights_set.*output_values.bfield_coil_set_fullfov,1));
            bfield_mag_r4 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r4(~scaledmask_reg4) = 0;
            b1plus_r4 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r4(~scaledmask_reg4) = 0;
            b1minus_r4 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r4(~scaledmask_reg4) = 0;
            
            bfield_coil_net = mask_3d_r3.*squeeze(sum(weights_set.*output_values.bfield_coil_set_fullfov,1));
            bfield_mag_r3 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r3(~scaledmask_reg3) = 0;
            b1plus_r3 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r3(~scaledmask_reg3) = 0;
            b1minus_r3 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r3(~scaledmask_reg3) = 0;
            
            bfield_coil_net = mask_3d_r2.*squeeze(sum(weights_set.*output_values.bfield_coil_set_fullfov,1));
            bfield_mag_r2 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r2(~scaledmask_reg2) = 0;
            b1plus_r2 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r2(~scaledmask_reg2) = 0;
            b1minus_r2 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r2(~scaledmask_reg2) = 0;
            
            bfield_coil_net = mask_3d_r1.*squeeze(sum(weights_set.*output_values.bfield_coil_set_fullfov,1));
            bfield_mag_r1 = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag_r1(~scaledmask_reg1) = 0;
            b1plus_r1 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_r1(~scaledmask_reg1) = 0;
            b1minus_r1 = imresize(bfield_coil_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_coil_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_r1(~scaledmask_reg1) = 0;
            figure;
            subplot(2,2,1)
            imshow(abs(bfield_mag_r4),'DisplayRange',display_range_coil);
            title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
            subplot(2,2,2)
            imshow(abs(bfield_mag_r3),'DisplayRange',display_range_coil);
            title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
            subplot(2,2,3)
            imshow(abs(bfield_mag_r2),'DisplayRange',display_range_coil);
            title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            subplot(2,2,4)
            imshow(abs(bfield_mag_r1),'DisplayRange',display_range_coil);
            title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            axis square
            colormap(jet)
            bfield_label = (['Magnitude of the Net Magnetic Field (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
            
            figure;
            subplot(2,2,1)
            imshow(abs(b1plus_r4),'DisplayRange',display_range_coil);
            title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
            subplot(2,2,2)
            imshow(abs(b1plus_r3),'DisplayRange',display_range_coil);
            title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
            subplot(2,2,3)
            imshow(abs(b1plus_r2),'DisplayRange',display_range_coil);
            title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            subplot(2,2,4)
            imshow(abs(b1plus_r1),'DisplayRange',display_range_coil);
            title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            axis square
            colormap(jet)
            bfield_label = (['Magnitude of the Net B1+ (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
            
            figure;
            subplot(2,2,1)
            imshow(abs(b1minus_r4),'DisplayRange',display_range_coil);
            title(['Region 4 (INNERMOST): r < ' sprintf('%0.2f',100*radius3) ' cm'],'FontSize',14);
            subplot(2,2,2)
            imshow(abs(b1minus_r3),'DisplayRange',display_range_coil);
            title(['Region 3: r < ' sprintf('%0.2f',100*radius2) ' cm'],'FontSize',14);
            subplot(2,2,3)
            imshow(abs(b1minus_r2),'DisplayRange',display_range_coil);
            title(['Region 2: r < ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            subplot(2,2,4)
            imshow(abs(b1minus_r1),'DisplayRange',display_range_coil);
            title(['Region 1 (OUTERMOST): r > ' sprintf('%0.2f',100*radius1) ' cm'],'FontSize',14);
            axis square
            colormap(jet)
            bfield_label = (['Magnitude of the Net B1- (Coil Case, Weights of Voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
        end
    end
end



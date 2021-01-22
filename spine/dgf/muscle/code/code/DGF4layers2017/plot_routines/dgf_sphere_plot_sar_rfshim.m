function [] = dgf_sphere_plot_sar_rfshim(output_values,s_opts,g_opts,path_opts,plot_opts)

addpath(path_opts.commondir);
addpath(path_opts.plotdir);

iptsetpref('ImshowInitialMagnification','fit');

x_fov = output_values.x_fov;
y_fov = output_values.y_fov;
z_fov = output_values.z_fov;

mask = output_values.mask;
fieldstrength = output_values.fieldstrength;

matrix_size = size(x_fov);
nf = matrix_size(1);
np = matrix_size(2);

sar_global_ult = output_values.sar_global_ult_rfshim;
sar_global_coil = output_values.sar_global_coil_rfshim;

plotlabel_ult = ['B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*g_opts.sphereradius) 'cm, radius = ' num2str(100*g_opts.sphereradius) 'cm (IN) and ' num2str(100*g_opts.currentradius) 'cm (OUT), lmax= ' ...
    num2str(s_opts.lmax) ', whichcurrents=[' num2str(output_values.whichcurrents) ']'];

plotlabel_coil = [num2str(g_opts.ncoils) ' Circular Coils, B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*g_opts.sphereradius) 'cm, radius = ' num2str(100*g_opts.sphereradius) 'cm (IN) and ' num2str(100*g_opts.currentradius) 'cm (OUT), lmax= ' num2str(s_opts.lmax)];

datelabel = ['      (' plot_opts.user_label ', '  datestr(now,0) ')'];


if plot_opts.plot_coil_setup_flag
    figure;
    plot_geometry_sphere(g_opts.sphereradius,g_opts.coil_radii,g_opts.coil_offsets,g_opts.coil_rotations,x_fov,y_fov,z_fov,3,'-',[1 0.46 0],0,plot_opts.plot_coil_number_flag)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                 %
%   PLOT TARGET AND ACHIEVED EXCITATION PROFILE   %
%                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if plot_opts.plot_target_profile,
    figure;
    set(gcf,'name','Target Excitation Profile in 3D');
    surf(x_fov,y_fov,output_values.mu_profile);
    title(['Target Excitation Profile'])
    iptsetpref('ImshowInitialMagnification','fit');
    figure;
    set(gcf,'name','Target Excitation Profile');
    imshow(output_values.mu_profile,[]);
    title(['Target Excitation Profile'])
end

if plot_opts.plot_actual_profile,
    figure;
    set(gcf,'name','Actual Excited Profile in 3D - RF shimming - ultimate case');
    surf(x_fov,y_fov,real(output_values.actual_prof_rfshim_ult));
    title(['Actual Excited Profile'])
    iptsetpref('ImshowInitialMagnification','fit');
    figure;
    set(gcf,'name','Actual Excited Profile - RF shimming - ultimate case');
    imshow(real(output_values.actual_prof_rfshim_ult),[]);
    title(['Actual Excited Profile'])
    
    if ~isempty(output_values.weights_coil)
        figure;
        set(gcf,'name',['Actual Excited Profile in 3D - RF shimming - ' num2str(g_opts.ncoils) ' circular coils']);
        surf(x_fov,y_fov,real(output_values.actual_prof_rfshim_coil));
        title(['Actual Excited Profile'])
        iptsetpref('ImshowInitialMagnification','fit');
        figure;
        set(gcf,'name',['Actual Excited Profile - RF shimming - ' num2str(g_opts.ncoils) ' circular coils']);
        imshow(real(output_values.actual_prof_rfshim_coil),[]);
        title(['Actual Excited Profile'])
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
    plotlabel_weights = char(...
        ['Ultimate combination weights (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
        'T, whichcurrents=[' num2str(output_values.whichcurrents) ']']);
    if length(output_values.whichcurrents) == 2
        figure;
        subplot(2,1,1)
        plot(abs(output_values.weights));
        title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (RF shimming - Magnetic-Dipole Type)']);
        subplot(2,1,2)
        plot(abs(output_values.weights),'r');
        title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (RF shimming - Electric-Dipole Type)']);
        set(gcf,'name',plotlabel_weights);
    else
        figure;
        plot(abs(output_values.weights));
        if output_values.whichcurrents == 1
            title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (RF shimming - Magnetic-Dipole Type)']);
        else
            title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (RF shimming - Electric-Dipole Type)']);
        end
        set(gcf,'name',plotlabel_weights);
    end
end

if plot_opts.plot_coil_current_weights && isempty(output_values.weights_coil)
    disp('** Coil currents weights are not available')
    plot_opts.plot_coil_current_weights = 0;
end

if plot_opts.plot_coil_current_weights
    plotlabel_weights = char(...
        ['Coil combination weights (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
        'T], whichcurrents=[' num2str(output_values.whichcurrents) ']']);
    figure;
    plot(abs(output_values.weights_coil));
    title(['Coils'' Combination Weights for Optimal SAR (RF shimming)']);
    set(gcf,'name',plotlabel_weights);
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
    plotlabel_ultcurr = char(...
        ['Ideal current patterns (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
        'T], whichcurrents=[' num2str(output_values.whichcurrents) '] - RF Shimming']);
    plot_currentpatterns_sphere(1,fieldstrength,plot_opts,path_opts,...
        output_values.currentpattern,output_values.currentphi,output_values.currenttheta,plotlabel_ultcurr,[8 4])
end

if plot_opts.plot_coil_current_patterns && isempty(output_values.currentpattern_coil)
    disp('** Coil currents patterns are not available')
    plot_opts.plot_coil_current_patterns = 0;
end

if plot_opts.plot_coil_current_patterns,
    plotlabel_coilcurr = char(...
        ['Coil current patterns (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
        'T, whichcurrents=[' num2str(output_values.whichcurrents) '] - RF Shimming']);
    plot_currentpatterns_sphere(2,fieldstrength,plot_opts,path_opts,...
        output_values.currentpattern_coil,output_values.currentphi,output_values.currenttheta,plotlabel_coilcurr,[8 4])
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
    
    plotlabel_ultcurr = char(...
        ['Ideal_current_patterns(b=' num2str(100*g_opts.currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
        'T_whichcurrents=[' num2str(output_values.whichcurrents) ']-RF_Shimming']);
    movie_currentpatterns_sphere(fieldstrength,plot_opts,g_opts,path_opts,...
        output_values.currentpattern,output_values.currentphi,output_values.currenttheta,plotlabel_ultcurr)
end

if plot_opts.movie_coil_current && isempty(output_values.currentpattern_coil)
    disp('** Ultimate currents patterns are not available')
    plot_opts.movie_coil_current = 0;
end

if plot_opts.movie_coil_current,
    plotlabel_coilcurr = char(...
        ['Coil_current_patterns-' num2str(g_opts.ncoils) 'loops(b=' ...
        num2str(100*g_opts.currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
        'T_whichcurrents=[' num2str(output_values.whichcurrents) ']-RF_Shimming']);
    movie_currentpatterns_sphere(fieldstrength,plot_opts,g_opts,path_opts,...
        output_values.currentpattern_coil,output_values.currentphi,output_values.currenttheta,plotlabel_coilcurr)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%     PLOT ELECTRIC FIELDS    %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if (plot_opts.plot_efields_ult || plot_opts.plot_efields_coil || plot_opts.plot_bfields_ult || plot_opts.plot_bfields_coil)
    if plot_opts.scale_factor > 1
        ix = size(x_fov,1)*plot_opts.scale_factor;
        iy = size(x_fov,2)*plot_opts.scale_factor;
        [xtemp,ytemp] = meshgrid(-((ix/2)-1):(ix/2),-((iy/2)-1):(iy/2));
        xtemp = xtemp - 1/2;
        ytemp = ytemp - 1/2;
        scaledmask = ((xtemp.^2 + ytemp.^2) <= (ix/2)^2);
    else
        scaledmask = output_values.mask;
    end
end


% E field, ultimate case
if plot_opts.plot_efields_ult && isempty(output_values.efield_ult_set)
    disp('** Modes'' electric fields are not available')
    plot_opts.plot_efields_ult = 0;
end
if plot_opts.plot_efields_ult && ((size(output_values.efield_ult_set,2)==1)||(size(output_values.efield_ult_set,3)==1))
    disp('** Modes'' electric fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_efields_ult = 0;
end

if plot_opts.plot_efields_ult && ((size(output_values.efield_ult_set,2)>1)&&(size(output_values.efield_ult_set,3)>1))
    mask_3d = repmat(output_values.mask,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate Current weights are not available, unit weights combination for net electric field')
        efield_ult_net = mask_3d.*squeeze(sum(output_values.efield_ult_set,1));
        efield_mag = abs(sqrt(imresize(efield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(efield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(efield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        efield_mag(~scaledmask) = 0;
        figure;
        imshow(efield_mag,[]);
        colormap(jet)
        efield_label = ('Magnitude of the net electric field (ultimate case, unit-weight combination)');
        set(gcf,'name',efield_label);
        title('Net Electric Field  (Ultimate case, unit-weight combination)')
    else
        
        
        weights_set_temp = output_values.weights;
        if size(weights_set_temp,2) > 1
            weights_set = zeros(2*size(weights_set_temp,1),1);
            weights_set(1:2:end,1) = weights_set_temp(1:end,1);
            weights_set(2:2:end,1) = weights_set_temp(1:end,2);
            weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set,2) size(output_values.efield_ult_set,3) 3]);
            clear weights_set_temp
        else
            clear weights_set_temp
            weights_set = repmat(output_values.weights,[1 size(output_values.efield_ult_set,2) size(output_values.efield_ult_set,3) 3]);
        end
        
        efield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_ult_set,1));
        efield_mag = abs(sqrt(imresize(efield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(efield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(efield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        efield_mag(~scaledmask) = 0;
        
        %--- QUIVER PLOT (Just a Test) ---*
        if 0
            figure;
            efield_label = (['Net Electric Field (Ultimate case - RF shimming)']);
            set(gcf,'name',efield_label);
            quiver3(x_fov,y_fov,z_fov,real(efield_ult_net(:,:,1)),real(efield_ult_net(:,:,2)),real(efield_ult_net(:,:,3)),'LineWidth',1,'Color','r')
            title(['Net Electric Field  (Ultimate case - RF shimming)'])
            set(gca,'XLim',[-g_opts.sphereradius g_opts.sphereradius])
            set(gca,'YLim',[-g_opts.sphereradius g_opts.sphereradius])
            set(gca,'ZLim',[-g_opts.sphereradius g_opts.sphereradius])
            xlabel('X-axis')
            ylabel('Y-axis')
            zlabel('Z-axis')
            daspect([1 1 1])
            hold on
            plotplan_sphere(x_fov,y_fov,z_fov)
        end
        %----------------------------------*
        
        figure;
        imshow(efield_mag,[]);
        colormap(jet)
        efield_label = (['Magnitude of the net electric field (Ultimate case - RF shimming)']);
        set(gcf,'name',efield_label);
        title(['Net Electric Field (Ultimate case - RF shimming)'])
    end
end

% E field, coil case
if plot_opts.plot_efields_coil && isempty(output_values.efield_coil_set)
    disp('** Coils'' electric fields are not available')
    plot_opts.plot_efields_coil = 0;
end
if plot_opts.plot_efields_coil && ((size(output_values.efield_coil_set,2)==1)||(size(output_values.efield_coil_set,3)==1))
    disp('** Coils'' electric fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_efields_ult = 0;
end

if plot_opts.plot_efields_coil && ((size(output_values.efield_coil_set,2)>1)&&(size(output_values.efield_coil_set,3)>1))
    mask_3d = repmat(output_values.mask,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Coil current weights are not available, unit weights combination for net electric field')
        efield_coil_net = mask_3d.*squeeze(sum(output_values.efield_coil_set,1));
        
        efield_mag = abs(sqrt(imresize(efield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(efield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(efield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        efield_mag(~scaledmask) = 0;
        
        figure;
        imshow(efield_mag,[]);
        colormap(jet)
        efield_label = ('Magnitude of the net electric field (coil case, unit-weight combination)');
        set(gcf,'name',efield_label);
        title('Net Electric Field  (Coil case, unit-weight combination)')
    else
        weights_set = repmat(output_values.weights_coil,[1 size(output_values.efield_coil_set,2) size(output_values.efield_coil_set,3) 3]);
        
        efield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_coil_set,1));
        
        efield_mag = abs(sqrt(imresize(efield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(efield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(efield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        efield_mag(~scaledmask) = 0;
        
        figure;
        imshow(efield_mag,[]);
        colormap(jet)
        efield_label = (['Magnitude of the net electric field (Coil case - RF shimming)']);
        set(gcf,'name',efield_label);
        title(['Net Electric Field  (Coil case - RF shimming)'])
        
        efield_coils =  (weights_set.*output_values.efield_coil_set);
        if g_opts.ncoils > 64
            plot_rows = 8;
            plot_col = floor(g_opts.ncoils/8) + mod(g_opts.ncoils,8);
        else
            plot_rows = 4;
            plot_col = floor(g_opts.ncoils/4) + mod(g_opts.ncoils,4);
        end
        figure;
        efield_label = (['Magnitude of the coils'' electric field (Coil case - RF shimming)']);
        set(gcf,'name',efield_label);
        for icoil = 1:g_opts.ncoils
            efield_temp =  mask_3d.*squeeze(efield_coils(icoil,:,:,:));
            efield_temp_mag = abs(sqrt(imresize(efield_temp(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(efield_temp(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(efield_temp(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            efield_temp_mag(~scaledmask) = 0;
            subplot(plot_rows,plot_col,icoil);
            imshow(efield_temp_mag,[]);
            title(['Coil ' num2str(icoil)]);
        end
        colormap('jet')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%     PLOT MAGNETIC FIELDS    %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% B field, ultimate case
if plot_opts.plot_bfields_ult && isempty(output_values.bfield_ult_set)
    disp('** Modes'' magnetic fields are not available')
    plot_opts.plot_bfields_ult = 0;
end
if plot_opts.plot_bfields_ult && ((size(output_values.bfield_ult_set,2)==1)||(size(output_values.bfield_ult_set,3)==1))
    disp('** Modes'' magnetic fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_bfields_ult = 0;
end

if plot_opts.plot_bfields_ult && ((size(output_values.bfield_ult_set,2)>1)&&(size(output_values.bfield_ult_set,3)>1))
    mask_3d = repmat(output_values.mask,[1 1 3]);
    if isempty(output_values.weights)
        disp('** Ultimate current weights are not available, unit weights combination for net magnetic field')
        bfield_ult_net = mask_3d.*squeeze(sum(output_values.bfield_ult_set,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~scaledmask) = 0;
        
        figure;
        imshow(bfield_mag,[]);
        colormap(jet)
        bfield_label = ('Magnitude of the net magnetic field (ultimate case, unit-weight combination)');
        set(gcf,'name',bfield_label);
        title('Net Magnetic Field  (Ultimate case, unit-weight combination)')
        
        b1plus_net = bfield_ult_net(:,:,1) + 1i*bfield_ult_net(:,:,2);
        figure;
        subplot(1,2,1)
        imshow(abs(b1plus_net),[]);
        title('Magnitude of net B1+ (ultimate case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1plus_net),real(b1plus_net)),[]);
        title('Phase of net B1+ (ultimate case, unit-weight combination)');
        b1plus_label = ('Magnitude and phase of the net B1+ (ultimate case, unit-weight combination)');
        set(gcf,'name',b1plus_label);

        b1minus_net = bfield_ult_net(:,:,1) - 1i*bfield_ult_net(:,:,2);
        figure;
        subplot(1,2,1)
        imshow(abs(b1minus_net),[]);
        title('Magnitude of net B1- (ultimate case, unit-weight combination)');
        subplot(1,2,2)
        imshow(atan2(imag(b1minus_net),real(b1minus_net)),[]);
        title('Phase of net B1- (ultimate case, unit-weight combination)');
        b1minus_label = ('Magnitude and phase of the net B1- (ultimate case, unit-weight combination)');
        set(gcf,'name',b1minus_label);
        
    else
        weights_set_temp = output_values.weights;
        if size(weights_set_temp,2) > 1
            weights_set = zeros(2*size(weights_set_temp,1),1);
            weights_set(1:2:end,1) = weights_set_temp(1:end,1);
            weights_set(2:2:end,1) = weights_set_temp(1:end,2);
            weights_set = repmat(weights_set,[1 size(output_values.bfield_ult_set,2) size(output_values.bfield_ult_set,3) 3]);
            clear weights_set_temp
        else
            clear weights_set_temp
            weights_set = repmat(output_values.weights,[1 size(output_values.bfield_ult_set,2) size(output_values.bfield_ult_set,3) 3]);
        end
        
        bfield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_ult_set,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~scaledmask) = 0;
        
        figure;
        imshow(bfield_mag,[]);
        colormap(jet)
        bfield_label = (['Magnitude of the net magnetic field (Ultimate case - RF shimming)']);
        set(gcf,'name',bfield_label);
        title('Net Magnetic Field  (Ultimate case)')
        
        b1plus_net = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) + 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1plus_net(~scaledmask) = 0;
        
        figure;
        subplot(1,2,1)
        imshow(abs(b1plus_net),[]);
        title('Magnitude of net B1+ (Ultimate case)')
        subplot(1,2,2)
        imshow(atan2(imag(b1plus_net),real(b1plus_net)),[]);
        title('Phase of net B1+ (Ultimate case)')
        b1plus_label = (['Magnitude and phase of the net B1+ (Ultimate case - RF shimming)']);
        set(gcf,'name',b1plus_label);
        colormap(jet)
        
        b1minus_net = imresize(bfield_ult_net(:,:,1),plot_opts.scale_factor,plot_opts.interp_method) - 1i*imresize(bfield_ult_net(:,:,2),plot_opts.scale_factor,plot_opts.interp_method);
        b1minus_net(~scaledmask) = 0;
        
        figure;
        subplot(1,2,1)
        imshow(abs(b1minus_net),[]);
        title('Magnitude of net B1- (Ultimate case)')
        subplot(1,2,2)
        imshow(atan2(imag(b1minus_net),real(b1minus_net)),[]);
        title('Phase of net B1- (Ultimate case)')
        b1minus_label = (['Magnitude and phase of the net B1- (Ultimate case - RF shimming)']);
        set(gcf,'name',b1minus_label);
        colormap(jet)
    end
end

% B field, coil case
if plot_opts.plot_bfields_coil && isempty(output_values.bfield_coil_set)
    disp('** Coils'' magnetic fields are not available')
    plot_opts.plot_bfields_coil = 0;
end
if plot_opts.plot_bfields_coil && ((size(output_values.bfield_coil_set,2)==1)||(size(output_values.bfield_coil_set,3)==1))
    disp('** Coils'' magnetic fields are not plotted if matrix size is not at least 2x2')
    plot_opts.plot_efields_ult = 0;
end

if plot_opts.plot_bfields_coil && ((size(output_values.bfield_coil_set,2)>1)&&(size(output_values.bfield_coil_set,3)>1))
    mask_3d = repmat(output_values.mask,[1 1 3]);
    if isempty(output_values.weights_coil)
        disp('** Coil current weights are not available, unit weights combination for net magnetic field')
        bfield_coil_net = mask_3d.*squeeze(sum(output_values.bfield_coil_set,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~scaledmask) = 0;
        
        figure;
        imshow(bfield_mag,[]);
        colormap(jet)
        bfield_label = ('Magnitude of the net magnetic field (coil case, unit-weight combination)');
        set(gcf,'name',bfield_label);
        title('Net Magnetic Field  (Coil case, unit-weight combination)')
    else
        weights_set = repmat(output_values.weights_coil,[1 size(output_values.bfield_coil_set,2) size(output_values.bfield_coil_set,3) 3]);
        
        bfield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_coil_set,1));
        
        bfield_mag = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
            imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
            imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
        bfield_mag(~scaledmask) = 0;
        
        figure;
        imshow(bfield_mag,[]);
        colormap(jet)
        bfield_label = (['Magnitude of the net magnetic field (Coil case - RF shimming)']);
        set(gcf,'name',bfield_label);
        title(['Net Magnetic Field  (Coil case - RF shimming)'])
        
        bfield_coils =  (weights_set.*output_values.bfield_coil_set);
        if g_opts.ncoils > 64
            plot_rows = 8;
            plot_col = floor(g_opts.ncoils/8) + mod(g_opts.ncoils,8);
        else
            plot_rows = 4;
            plot_col = floor(g_opts.ncoils/4) + mod(g_opts.ncoils,4);
        end
        
        b1plus_coils = bfield_coils(:,:,:,1) + 1i*bfield_coils(:,:,:,2);
        
        figure;
        bfield_label = (['Magnitude of the coils'' B1+ field (Coil case - RF shimming)']);
        set(gcf,'name',bfield_label);
        for icoil = 1:g_opts.ncoils
            subplot(plot_rows,plot_col,icoil);
            
            b1plus_temp = abs(squeeze(b1plus_coils(icoil,:,:)));
            b1plus_temp = imresize(b1plus_temp,plot_opts.scale_factor,plot_opts.interp_method);
            b1plus_temp(~scaledmask) = 0;
            
            imshow(b1plus_temp,[]);
            title(['Coil ' num2str(icoil)]);
        end
        colormap('jet')
        if plot_opts.plot_coil_b1plus_phase
            figure;
            bfield_label = (['Phase of the coils'' B1+ field (Coil case - RF shimming)']);
            set(gcf,'name',bfield_label);
            for icoil = 1:g_opts.ncoils
                bfield_temp = squeeze(b1plus_coils(icoil,:,:));
                bfield_temp = imresize(bfield_temp,plot_opts.scale_factor,plot_opts.interp_method);
                bfield_temp(~scaledmask) = 0;
                subplot(plot_rows,plot_col,icoil);
                imshow(atan2(imag(bfield_temp),real(bfield_temp)),[]);
                title(['Coil ' num2str(icoil)]);
            end
            colormap('jet')
        end
        
        b1minus_coils = bfield_coils(:,:,:,1) - 1i*bfield_coils(:,:,:,2);
        figure;
        bfield_label = (['Magnitude of the coils'' B1- field (Coil case - RF shimming)']);
        set(gcf,'name',bfield_label);
        for icoil = 1:g_opts.ncoils
            subplot(plot_rows,plot_col,icoil);
            
            b1minus_temp = abs(squeeze(b1minus_coils(icoil,:,:)));
            b1minus_temp = imresize(b1minus_temp,plot_opts.scale_factor,plot_opts.interp_method);
            b1minus_temp(~scaledmask) = 0;
            
            imshow(b1minus_temp,[]);
            title(['Coil ' num2str(icoil)]);
        end
        colormap('jet')
        if plot_opts.plot_coil_b1minus_phase
            figure;
            bfield_label = (['Phase of the coils'' B1- field (Coil case - RF shimming)']);
            set(gcf,'name',bfield_label);
            for icoil = 1:g_opts.ncoils
                bfield_temp = squeeze(b1minus_coils(icoil,:,:));
                bfield_temp = imresize(bfield_temp,plot_opts.scale_factor,plot_opts.interp_method);
                bfield_temp(~scaledmask) = 0;
                subplot(plot_rows,plot_col,icoil);
                imshow(atan2(imag(bfield_temp),real(bfield_temp)),[]);
                title(['Coil ' num2str(icoil)]);
            end
            colormap('jet')
        end
    end
end



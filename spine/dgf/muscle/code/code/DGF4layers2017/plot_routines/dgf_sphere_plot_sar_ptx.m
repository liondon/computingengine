function [] = dgf_sphere_plot_sar_ptx(output_values,s_opts,g_opts,path_opts,plot_opts)

addpath(path_opts.commondir);
addpath(path_opts.plotdir);

iptsetpref('ImshowInitialMagnification','fit');

x_fov = output_values.x_fov;
y_fov = output_values.y_fov;
z_fov = output_values.z_fov;

mask = output_values.mask;

fieldstrength = output_values.fieldstrength;
acceleration = output_values.acceleration;

matrix_size = size(x_fov);
nf = matrix_size(1);
np = matrix_size(2);
true_nf = floor(nf/acceleration(1));
true_np = floor(np/acceleration(2));

sar_ult_ptx = output_values.sar_ult_ptx;
sar_coil_ptx = output_values.sar_coil_ptx;

plotlabel_ult = ['B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*g_opts.sphereradius) 'cm, R=' ...
    num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
    ', radius = ' num2str(100*g_opts.sphereradius) 'cm (IN) and ' num2str(100*g_opts.currentradius) 'cm (OUT), lmax= ' ...
    num2str(s_opts.lmax) ', whichcurrents=[' num2str(output_values.whichcurrents) ']'];

plotlabel_coil = [num2str(g_opts.ncoils) ' Circular Coils, B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*g_opts.sphereradius) 'cm, R=' ...
    num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
    ', radius = ' num2str(100*g_opts.sphereradius) 'cm (IN) and ' num2str(100*g_opts.currentradius) 'cm (OUT), lmax= ' num2str(s_opts.lmax)];

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
    set(gcf,'name','Actual Excited Profile in 3D - parallel Tx - ultimate case');
    surf(x_fov,y_fov,real(output_values.actual_profile_ptx_ult));
    title(['Actual Excited Profile'])
    iptsetpref('ImshowInitialMagnification','fit');
    figure;
    set(gcf,'name','Actual Excited Profile - parallel Tx - ultimate case');
    imshow(real(output_values.actual_profile_ptx_ult),[]);
    title(['Actual Excited Profile'])
    
    if ~isempty(output_values.weights_coil)
        figure;
        set(gcf,'name',['Actual Excited Profile in 3D - parallel Tx - ' num2str(g_opts.ncoils) ' circular coils']);
        surf(x_fov,y_fov,real(output_values.actual_profile_ptx_coil));
        title(['Actual Excited Profile'])
        iptsetpref('ImshowInitialMagnification','fit');
        figure;
        set(gcf,'name',['Actual Excited Profile - parallel Tx - ' num2str(g_opts.ncoils) ' circular coils']);
        imshow(real(output_values.actual_profile_ptx_coil),[]);
        title(['Actual Excited Profile'])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                    %
%   PLOT SAR AND TRANSMIT G-FACTOR   %
%                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(x_fov) > 1,
    
    rho_fov = sqrt(x_fov.^2 + y_fov.^2 + z_fov.^2);
    costheta_fov = z_fov./rho_fov;
    costheta_fov(isnan(costheta_fov)) = 0;
    theta_fov = acos(costheta_fov);
    phi_fov = atan2(y_fov,x_fov);
    
    sar_ult_ptx(~mask) = 0;
    sar_ult_max = max(real(sar_ult_ptx(mask)));
    sar_ult_mean = mean(real(sar_ult_ptx(mask)));
    
    sar_coil_ptx(~mask) = 0;
    sar_coil_max = max(real(sar_coil_ptx(mask)));
    sar_coil_mean = mean(real(sar_coil_ptx(mask)));
    
    
    if (acceleration(1) > 1) || (acceleration(2) > 1)
        
        g_ult_ptx = output_values.g_ult_ptx;
        g_coil_ptx = output_values.g_coil_ptx;
        
        g_ult_ptx(~mask) = 0;
        g_ult_max = max(real(g_ult_ptx(mask)));
        g_ult_mean = mean(real(g_ult_ptx(mask)));
        
        g_coil_ptx(~mask) = 0;
        g_coil_max = max(real(g_coil_ptx(mask)));
        g_coil_mean = mean(real(g_coil_ptx(mask)));
    end
        
    if plot_opts.plot_ultSAR,
        figure
        set(gcf,'name',plotlabel_ult);
        imshow(real(sar_ult_ptx)',[]);
        colorbar
        title(['mean ult SAR = ' sprintf('%0.2f',sar_ult_mean) ', max ult SAR = ' sprintf('%0.2f',sar_ult_max)  datelabel])
        colormap(jet)
        if (acceleration(1) > 1) || (acceleration(2) > 1)
            figure
            set(gcf,'name',plotlabel_ult);
            imshow(real(g_ult_ptx)',[]);
            colorbar
            title(['mean ult g = ' sprintf('%0.2f',g_ult_mean) ', max ult g = ' sprintf('%0.2f',g_ult_max)  datelabel])
            colormap(jet)
        end
    end
    if plot_opts.plot_coilSAR,
        figure
        set(gcf,'name',plotlabel_coil);
        imshow(real(sar_coil_ptx)',[]);
        colorbar
        title(['mean coil SAR = ' sprintf('%0.2f',sar_coil_mean) ', max coil SAR = ' sprintf('%0.2f',sar_coil_max)  datelabel])
        colormap(jet)
        if (acceleration(1) > 1) || (acceleration(2) > 1)
            figure
            set(gcf,'name',plotlabel_coil);
            imshow(real(g_coil_ptx)',[]);
            colorbar
            title(['mean coil g = ' sprintf('%0.2f',g_coil_mean) ', max coil g = ' sprintf('%0.2f',g_coil_max)  datelabel])
            colormap(jet)
        end
    end
    
else
    disp('Not plotting SAR because there is only one voxel');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             %
%       MOVIE LOCAL SAR       %
%                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_opts.movie_ultSAR_local || plot_opts.movie_coilSAR_local
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

if plot_opts.movie_ultSAR_local
    clear iframe F frame conto X Map mov moviefilename 
    if isempty(output_values.localsar_sequence)
        disp('-------------------------------------------------------');
        disp('**ERROR** local SAR for ultimate case is empty');
        disp('-------------------------------------------------------');
        return
    end
    h10 = warndlg('Don''t interact with the computer while the movie frames are recorded','** WARNING **');
    set( h10, 'Visible', 'off' );
    fontName = 'FixedWidth';
    fontSize = 16;
    % get handles to the UIControls ([OK] PushButton) and Text
    kids0 = findobj( h10, 'Type', 'UIControl' );
    kids1 = findobj( h10, 'Type', 'Text' );
    % change the font and fontsize
    extent0 = get( kids1, 'Extent' );       % text extent in old font
    set( [kids0, kids1], 'FontName', fontName, 'FontSize', fontSize );
    extent1 = get( kids1, 'Extent' );       % text extent in new font
    % need to resize the msgbox object to accommodate new FontName
    % and FontSize
    delta = extent1 - extent0;              % change in extent
    pos = get( h10, 'Position' );     % msgbox current position
    pos = pos + delta;                      % change size of msgbox
    set( h10, 'Position', pos );      % set new position
    set( h10, 'Visible', 'on' );
    uiwait(h10);

    kspace = zeros(nf,np);
    truetrajectory = zeros(nf,np);
    
    figure;
    pos = get(gcf,'position');
    set(gcf,'position',[pos(1) pos(2) pos(3)*plot_opts.movie_window_scaling pos(4)*plot_opts.movie_window_scaling]);
    set(gcf,'name','Local SAR (Ultimate Case)');

    iptsetpref('ImshowInitialMagnification','fit');
    for iframe = 1:(true_nf*true_np)
        myframe_temp = imresize(output_values.localsar_sequence(:,:,iframe),plot_opts.scale_factor,plot_opts.interp_method);
        myframe_temp(~scaledmask) = 0;
        myframe = log10(abs(myframe_temp));
        
%         myframe = log10(abs(output_values.localsar_sequence(:,:,iframe)));

%         if nf > np
%             myframe = myframe.';
%         end      
        h11 = subplot(2,1,1);
        set(gcf,'CurrentAxes',h11);
        imshow(myframe,[0 log10(output_values.peak_sar)]);
%         if nf > np
%             set(gca,'XLim',[0.5 nf+0.5],'YLim',[0.5 np+0.5]);
%         else
            set(gca,'XLim',[0.5 np*plot_opts.scale_factor+0.5],'YLim',[0.5 nf*plot_opts.scale_factor+0.5]);
%         end
        axis off
        colormap('jet');
        titlestring = (['Time Interval: ' sprintf('%0.0f',iframe)]);
        set(gca,'Title',text('String',titlestring,'FontSize', 12,'FontWeight','bold'));
        set(gca,'nextplot','replacechildren');
        set(gca,'Units','pixels')
        axisposition1 = get(gca,'Position');
        
        xlabelstring = ([sprintf('%0.0f',fieldstrength) 'T, Acc = ',sprintf('%0.0f',acceleration(1)) 'x',sprintf('%0.0f',acceleration(2))]);
        set(get(h11,'XLabel'), 'String',xlabelstring,'FontSize', 12,'FontWeight','bold','EdgeColor','r',...
            'LineWidth',2,'BackgroundColor','w','HorizontalAlignment','center','VerticalAlignment','bottom','Visible','on','Margin',4);

        h22 = subplot(2,1,2);
        warning off all
        imshow(kspace,[]);
        colormap('jet');
        set(h22,'Title',text('String','Excitation k-space','FontSize', 12,'FontWeight','bold'));
        set(h22,'XLim',[0.5 np+0.5],'YLim',[0.5 nf+0.5]);
        axis off
        set(gca,'Units','pixels')
        axisposition2 = get(gca,'Position');
        
        if iframe==1
            scalingunit = axisposition2(4)/nf;
            truewidth = np*scalingunit;
            deltawidth = (axisposition2(3)-truewidth)/2;
            frameleft = floor(axisposition1(1)+ deltawidth - 10);
            framebottom = floor(axisposition2(2) - 10);
            framewidth = floor(truewidth + 20);
            frameheight = floor((axisposition1(2)-axisposition2(2)) + axisposition1(4) + 40);
        end

        if rem(iframe,true_nf) == 0 % end of a column
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (true_nf - 1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
            else % even column
                ifreq = 1;
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
            end
            text(iphase, ifreq,'\rightarrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
        else
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (rem(iframe,true_nf)-1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
                text(iphase, ifreq,'\downarrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
            else % even column
                ifreq = 1 + (true_nf - 1)*acceleration(1) - (rem(iframe,true_nf)-1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
                text(iphase, ifreq,'\uparrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
            end
        end

        %         disp(['     pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        disp(['Frame = ' num2str(iframe)    ', pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        [freqlist phaselist] = find(truetrajectory == 1);
        text(phaselist, freqlist,'\bullet','FontSize',8*plot_opts.scale_factor,'FontWeight','bold',...
            'Color','r','HorizontalAlignment','center')
        %         text(freqlist, phaselist,'\bullet','FontSize',8,'FontWeight','bold',...
        %             'Color','r','HorizontalAlignment','center')

        truetrajectory(ifreq,iphase) = 1;
        F(iframe) = getframe(gcf,[frameleft framebottom framewidth frameheight]); % [left bottom width height]
    end
    disp('Start making movie...');
    conto = 0;
    for frame = 1:1:size(F,2)
        conto = conto + 1;
        [X(:,:,:,conto),Map] = frame2im(F(frame));
    end
    mov = immovie(X,Map);
    moviefilename = [path_opts.moviedir '/UltSAR_movie_matrix_' num2str(nf) 'x' num2str(np) '_' num2str(fieldstrength) 'T_acc' num2str(acceleration(1)) 'x' num2str(acceleration(2)) '.avi'];
    movie2avi(mov,moviefilename,'compression',plot_opts.movie_compression,'fps',plot_opts.movie_fps,'quality',100);
    disp('local SAR movie (ultimate case) saved.');
end

if plot_opts.movie_coilSAR_local
    clear iframe F frame conto X Map mov moviefilename 
    if isempty(output_values.localsar_sequence_coil)
        disp('-------------------------------------------------------');
        disp('**ERROR** local SAR for coil is empty');
        disp('-------------------------------------------------------');
        return
    end
    h10 = warndlg('Don''t interact with the computer while the movie frames are recorded','** WARNING **');
    set( h10, 'Visible', 'off' );
    fontName = 'FixedWidth';
    fontSize = 16;
    % get handles to the UIControls ([OK] PushButton) and Text
    kids0 = findobj( h10, 'Type', 'UIControl' );
    kids1 = findobj( h10, 'Type', 'Text' );
    % change the font and fontsize
    extent0 = get( kids1, 'Extent' );       % text extent in old font
    set( [kids0, kids1], 'FontName', fontName, 'FontSize', fontSize );
    extent1 = get( kids1, 'Extent' );       % text extent in new font
    % need to resize the msgbox object to accommodate new FontName
    % and FontSize
    delta = extent1 - extent0;              % change in extent
    pos = get( h10, 'Position' );     % msgbox current position
    pos = pos + delta;                      % change size of msgbox
    set( h10, 'Position', pos );      % set new position
    set( h10, 'Visible', 'on' );
    uiwait(h10);

    kspace = zeros(nf,np);
    truetrajectory = zeros(nf,np);
    
    figure;
    pos = get(gcf,'position');
    set(gcf,'position',[pos(1) pos(2) pos(3)*plot_opts.movie_window_scaling pos(4)*plot_opts.movie_window_scaling]);
    set(gcf,'name','Local SAR (Coil Case)');
    
    iptsetpref('ImshowInitialMagnification','fit');
    for iframe = 1:(true_nf*true_np)
        
        myframe_temp = imresize(output_values.localsar_sequence_coil(:,:,iframe),plot_opts.scale_factor,plot_opts.interp_method);
        myframe_temp(~scaledmask) = 0;
        myframe = log10(abs(myframe_temp));
        
%         myframe = log10(abs(output_values.localsar_sequence_coil(:,:,iframe)));

%         if nf > np
%             myframe = myframe.';
%         end      
        h11 = subplot(2,1,1);
        set(gcf,'CurrentAxes',h11);
        imshow(myframe,[0 log10(output_values.peak_sar_coil)]);
%         if nf > np
%             set(gca,'XLim',[0.5 nf+0.5],'YLim',[0.5 np+0.5]);
%         else
            set(gca,'XLim',[0.5 np*plot_opts.scale_factor+0.5],'YLim',[0.5 nf*plot_opts.scale_factor+0.5]);
%         end
        axis off
        colormap('jet');
        titlestring = (['Time Interval: ' sprintf('%0.0f',iframe)]);
        set(gca,'Title',text('String',titlestring,'FontSize', 12,'FontWeight','bold'));
        set(gca,'nextplot','replacechildren');
        set(gca,'Units','pixels')
        axisposition1 = get(gca,'Position');
        
        xlabelstring = ([sprintf('%0.0f',fieldstrength) 'T, Acc = ',sprintf('%0.0f',acceleration(1)) 'x',sprintf('%0.0f',acceleration(2))]);
        set(get(h11,'XLabel'), 'String',xlabelstring,'FontSize', 12,'FontWeight','bold','EdgeColor','r',...
            'LineWidth',2,'BackgroundColor','w','HorizontalAlignment','center','VerticalAlignment','bottom','Visible','on','Margin',4);

        h22 = subplot(2,1,2);
        warning off all
        imshow(kspace,[]);
        colormap('jet');
        set(h22,'Title',text('String','Excitation k-space','FontSize', 12,'FontWeight','bold'));
        set(h22,'XLim',[0.5 np+0.5],'YLim',[0.5 nf+0.5]);
        axis off
        set(gca,'Units','pixels')
        axisposition2 = get(gca,'Position');
        
        if iframe==1
            scalingunit = axisposition2(4)/nf;
            truewidth = np*scalingunit;
            deltawidth = (axisposition2(3)-truewidth)/2;
            frameleft = floor(axisposition1(1)+ deltawidth - 10);
            framebottom = floor(axisposition2(2) - 10);
            framewidth = floor(truewidth + 20);
            frameheight = floor((axisposition1(2)-axisposition2(2)) + axisposition1(4) + 40);
        end

        if rem(iframe,true_nf) == 0 % end of a column
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (true_nf - 1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
            else % even column
                ifreq = 1;
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
            end
            text(iphase, ifreq,'\rightarrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
        else
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (rem(iframe,true_nf)-1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
                text(iphase, ifreq,'\downarrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
            else % even column
                ifreq = 1 + (true_nf - 1)*acceleration(1) - (rem(iframe,true_nf)-1)*acceleration(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration(2);
                text(iphase, ifreq,'\uparrow','FontSize',12,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',4)
            end
        end

        %         disp(['     pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        disp(['Frame = ' num2str(iframe)    ', pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        [freqlist phaselist] = find(truetrajectory == 1);
        text(phaselist, freqlist,'\bullet','FontSize',8*plot_opts.scale_factor,'FontWeight','bold',...
            'Color','r','HorizontalAlignment','center')
        %         text(freqlist, phaselist,'\bullet','FontSize',8,'FontWeight','bold',...
        %             'Color','r','HorizontalAlignment','center')

        truetrajectory(ifreq,iphase) = 1;
        F(iframe) = getframe(gcf,[frameleft framebottom framewidth frameheight]); % [left bottom width height]
    end
    disp('Start making movie...');
    conto = 0;
    for frame = 1:1:size(F,2)
        conto = conto + 1;
        [X(:,:,:,conto),Map] = frame2im(F(frame));
    end
    mov = immovie(X,Map);
    moviefilename = [path_opts.moviedir '/CoilSAR_movie_matrix_' num2str(nf) 'x' num2str(np) '_' num2str(fieldstrength) 'T_acc' num2str(acceleration(1)) 'x' num2str(acceleration(2)) '.avi'];
    movie2avi(mov,moviefilename,'compression',plot_opts.movie_compression,'fps',plot_opts.movie_fps,'quality',100);
    disp('local SAR movie (coil case) saved.');
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
            ['Ultimate combination weights (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        if length(output_values.whichcurrents) == 2
            figure;
            subplot(2,1,1)
            plot(abs(output_values.weights(:,1,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2))));
            title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (Magnetic-Dipole Type)']);
            subplot(2,1,2)
            plot(abs(output_values.weights(:,2,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2))),'r');
            title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (Electric-Dipole Type)']);
            set(gcf,'name',plotlabel_weights);
        else
            figure;
            plot(abs(output_values.weights(:,:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2))));
            if output_values.whichcurrents == 1
                title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (Magnetic-Dipole Type)']);
            else
                title(['Modes'' Combination Weights for Ultimate Intrinsic SAR (Electric-Dipole Type)']);
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
            ['Coil combination weights (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [x,y,z]=[' num2str(xvox*100,3) 'cm,' num2str(yvox*100,3) 'cm,' num2str(zvox*100,3) ...
            'cm], whichcurrents=[' num2str(output_values.whichcurrents) '], ',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) ' accel)']);
        figure;
        plot(abs(output_values.weights_coil(:,iweights)));
        title(['Coils'' Combination Weights for Optimal SAR']);
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
            ['Ideal current patterns (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
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
            ['Coil current patterns (b=' num2str(100*g_opts.currentradius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
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
            ['Ideal_current_patterns(b=' num2str(100*g_opts.currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
            'T_voxel[x,y,z]=[' num2str(xvox*100,3) 'cm_' num2str(yvox*100,3) 'cm_' num2str(zvox*100,3) ...
            'cm]_whichcurrents=[' num2str(output_values.whichcurrents) ']_',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) 'accel)']);
        movie_currentpatterns_sphere(fieldstrength,plot_opts,g_opts,path_opts,...
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
            ['Coil_current_patterns-' num2str(g_opts.ncoils) 'loops(b=' ...
            num2str(100*g_opts.currentradius,2) 'cm_B_0=' num2str(fieldstrength,2) ...
            'T_voxel[x,y,z]=[' num2str(xvox*100,3) 'cm_' num2str(yvox*100,3) 'cm_' num2str(zvox*100,3) ...
            'cm]_whichcurrents=[' num2str(output_values.whichcurrents) ']_',...
            num2str(acceleration(1)) 'x' num2str(acceleration(2)) 'accel)']);
        movie_currentpatterns_sphere(fieldstrength,plot_opts,g_opts,path_opts,...
            output_values.currentpattern_coil(:,:,:,ipatterns),output_values.currentphi,output_values.currenttheta,plotlabel_coilcurr)
    end
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
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.efield_ult_set,2) size(output_values.efield_ult_set,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2)),[1 size(output_values.efield_ult_set,2) size(output_values.efield_ult_set,3) 3]);
            end
            
            efield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_ult_set,1));
            efield_mag = abs(sqrt(imresize(efield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(efield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(efield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            efield_mag(~scaledmask) = 0;
              
            %--- QUIVER PLOT (Just a Test) ---*
            if 0
            figure;
            efield_label = (['Net Electric Field (Ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            quiver3(x_fov,y_fov,z_fov,real(efield_ult_net(:,:,1)),real(efield_ult_net(:,:,2)),real(efield_ult_net(:,:,3)),'LineWidth',1,'Color','r')
            title(['Net Electric Field  (Ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
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
            efield_label = (['Magnitude of the net electric field (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            title(['Net Electric Field  (Ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
        end
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
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set = repmat(output_values.weights_coil(:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2)),[1 size(output_values.efield_coil_set,2) size(output_values.efield_coil_set,3) 3]);
            
            efield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.efield_coil_set,1));
              
            efield_mag = abs(sqrt(imresize(efield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(efield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(efield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            efield_mag(~scaledmask) = 0;
            
            figure;
            imshow(efield_mag,[]);
            colormap(jet)
            efield_label = (['Magnitude of the net electric field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',efield_label);
            title(['Net Electric Field  (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
            
            efield_coils =  (weights_set.*output_values.efield_coil_set);
            if g_opts.ncoils > 64
                plot_rows = 8;
                plot_col = floor(g_opts.ncoils/8) + mod(g_opts.ncoils,8);
            else
                plot_rows = 4;
                plot_col = floor(g_opts.ncoils/4) + mod(g_opts.ncoils,4);
            end
            figure;
            efield_label = (['Magnitude of the coils'' electric field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set_temp = output_values.weights(:,:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            if size(weights_set_temp,2) > 1
                weights_set = zeros(2*size(weights_set_temp,1),1);
                weights_set(1:2:end,1) = weights_set_temp(1:end,1);
                weights_set(2:2:end,1) = weights_set_temp(1:end,2);
                weights_set = repmat(weights_set,[1 size(output_values.bfield_ult_set,2) size(output_values.bfield_ult_set,3) 3]);
                clear weights_set_temp
            else
                clear weights_set_temp
                weights_set = repmat(output_values.weights(:,:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2)),[1 size(output_values.bfield_ult_set,2) size(output_values.bfield_ult_set,3) 3]);
            end
            
            bfield_ult_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_ult_set,1));
             
            bfield_mag = abs(sqrt(imresize(bfield_ult_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_ult_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_ult_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag(~scaledmask) = 0;
            
            figure;
            imshow(bfield_mag,[]);
            colormap(jet)
            bfield_label = (['Magnitude of the net magnetic field (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
            b1plus_label = (['Magnitude and phase of the net B1+ (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
            b1minus_label = (['Magnitude and phase of the net B1- (ultimate case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',b1minus_label);
            colormap(jet)
        end
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
        whichvoxelweights = output_values.whichvoxelweights;
        for iweights = 1:size(whichvoxelweights,1),
            xvox = x_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            yvox = y_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            zvox = z_fov(whichvoxelweights(iweights,1),whichvoxelweights(iweights,2));
            
            weights_set = repmat(output_values.weights_coil(:,whichvoxelweights(iweights,1),whichvoxelweights(iweights,2)),[1 size(output_values.bfield_coil_set,2) size(output_values.bfield_coil_set,3) 3]);
            
            bfield_coil_net = mask_3d.*squeeze(sum(weights_set.*output_values.bfield_coil_set,1));
            
            bfield_mag = abs(sqrt(imresize(bfield_coil_net(:,:,1).^2,plot_opts.scale_factor,plot_opts.interp_method) + ...
                imresize(bfield_coil_net(:,:,2).^2,plot_opts.scale_factor,plot_opts.interp_method) + ....
                imresize(bfield_coil_net(:,:,3).^2,plot_opts.scale_factor,plot_opts.interp_method)));
            bfield_mag(~scaledmask) = 0;
            
            figure;
            imshow(bfield_mag,[]);
            colormap(jet)
            bfield_label = (['Magnitude of the net magnetic field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
            set(gcf,'name',bfield_label);
            title(['Net Magnetic Field  (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])'])
           
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
            bfield_label = (['Magnitude of the coils'' B1+ field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
                bfield_label = (['Phase of the coils'' B1+ field (coil case, weights of voxel [' num2str(100*xvox) ...
                    ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
            bfield_label = (['Magnitude of the coils'' B1- field (coil case, weights of voxel [' num2str(100*xvox) ...
                ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
                bfield_label = (['Phase of the coils'' B1- field (coil case, weights of voxel [' num2str(100*xvox) ...
                    ',' num2str(100*yvox) ',' num2str(100*zvox) '])']);
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
end



function dgf_sphere_plot_ultSAR_parTx(sar,g,localsar,profile,globalsar,peaksar,...
    mask,currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,...
    whichvoxelpatterns,lmax,whichcurrents,...
    fovf,fovp,fieldstrength,acceleration_factor,sphereradius,outer_radius,...
    sigma_coil,plotsar,localsar_movie,plotcurrents,currents_plot_3D,currents_movie,...
    plotprofile,movie_compression,movie_fps,commondir,plotdir,moviedir,user_label)

% function dgf_sphere_plot_ultSAR_parTx(sar,g,localsar,profile,globalsar,peaksar,...
%     mask,currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,...
%     whichvoxelpatterns,lmax,whichcurrents,...
%     fovf,fovp,fieldstrength,acceleration_factor,sphereradius,outer_radius,...
%     sigma_coil,plotsar,localsar_movie,plotcurrents,currents_plot_3D,currents_movie,...
%     plotprofile,movie_compression,movie_fps,commondir,plotdir,moviedir,user_label)
% 
% Plot routines for ultimate SAR, ultimate transmit g-factor, optimal weights
% and current patterns in the case of parallel transmission.
%
% input:
% ------
%   sar: matrix_size(1) x matrix_size(2) array of SAR values
%   g: matrix_size(1) x matrix_size(2) array of transmit g-factor values
%   localsar: matrix_size(1) x matrix_size(2) x time_points array of local SAR values
%   profile: matrix_size(1) x matrix_size(2) array with the actual excited profile
%   globalsar: ultimate global SAR
%   peaksar: highest SAR value at any instant of the optimal excitation and at any position
%   mask: matrix_size(1) x matrix_size(2) binary mask showing object boundary
%   currentpattern: currentpatternmatrixsize(1) x currentpatternmatrixsize(2) x matrix_size(1) x matrix_size(2) array of current pattern values as a function of phi and z
%   currentphi: phi coordinates for current pattern plotting
%   currenttheta: theta coordinates for current pattern plotting
%   x_fov: x coordinates of chosen fov
%   y_fov: y coordinates of chosen fov
%   z_fov: z coordinates of chosen fov
%   whichvoxelpatterns: (number of chosen voxels x 2) array of voxel indices for which to save current patterns [default NaN --> save current patterns for all voxels]
%   lmax: vector containing choice of n for azimuthal current modes
%   whichcurrents: choice of current basis functions to include (1 = divergence-free mag dipole, 2 = curl-free electric dipole) [default [1 2] = both]
%	fovf: fov in the frequency-encoding direction
%	fovp: fov in the phase-encoding direction
%   fieldstrength: field strength (Tesla)
%   acceleration_factor: 1 x 2 vector containing acceleration factors in each of two dimensions
%   sphereradius: radius of dielectric cylinder (m)
%   outer_radius: radius of coil former (m)
%   sigma_coil: conductivity of coil material, for estimates of coil noise (Siemens/m)
%   plotsar: 1 --> plot snr
%   localsar_movie: 1 --> creates a movie with local SAR as a function of time
%   plotcurrents: 1 --> plot current patterns
%   currents_plot_3D: 1 --> display currents pattern on tridimensional surfaces  
%   currents_movie: 1 --> creates a movie with current patterns as a function of time
%   plotprofile: 1 --> plots the actual excited profile
%   movie_compression: specify the compression codec to use in converting Matlab movie to AVI movie
%   movie_fps: specify the speed of the AVI movie in frames per second (fps)
%   commondir: directory with general computation routines
%   plotdir: directory with general plotting routines
%   moviedir: directory in which movies are saved
%   user_label: initials of current user
%
% Riccardo Lattanzi, 10-24-07
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(commondir);
addpath(plotdir);

% To avoid OUT OF MEMORY errors
if plotcurrents & currents_movie
    plotcurrents = 0;
end
if currents_plot_3D & currents_movie
    currents_plot_3D = 0;
end

rho_fov = sqrt(x_fov.^2 + y_fov.^2 + z_fov.^2);
costheta_fov = z_fov./rho_fov;
costheta_fov(isnan(costheta_fov)) = 0;
theta_fov = acos(costheta_fov);
phi_fov = atan2(y_fov,x_fov);

g(~mask) = 0;
gmax = max(real(g(:)));
gmean = mean(real(g(:)));
sar(~mask) = 0;
sarmax = max(real(sar(:)));
sarmean = mean(real(sar(:)));

matrix_size = size(x_fov);
nf = matrix_size(1);
np = matrix_size(2);
true_nf = floor(nf/acceleration_factor(1));
true_np = floor(np/acceleration_factor(2));
ind_skip = floor(matrix_size./acceleration_factor);

% if isnan(whichvoxelweights),
%     [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
%     whichvoxelweights = [ind1(:) ind2(:)];
% end
if isnan(whichvoxelpatterns) | currents_movie,
    [ind1,ind2] = meshgrid(1:acceleration_factor(1):matrix_size(1),1:acceleration_factor(2):matrix_size(2));
    whichvoxelpatterns = [ind1(:) ind2(:)];
end
   
plotlabel = ['B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*fovf) 'cm x ' num2str(100*fovp) 'cm, R=' ...
    num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ...
    ', radius = ' num2str(100*sphereradius) 'cm (IN) and ' num2str(100*outer_radius) 'cm (OUT), lmax= ' ...
    num2str(lmax) ', whichcurrents=[' num2str(whichcurrents) ']'];
datelabel = ['      (' user_label ', '  datestr(now,0) ')'];

iptsetpref('ImshowInitialMagnification','fit');

if plotsar,
    figure
    set(gcf,'name',plotlabel);
    imshow(real(sar)',[]);
    colorbar
    title(['mean ult SAR = ' sprintf('%0.2f',sarmean) ', max ult SAR = ' sprintf('%0.2f',sarmax)  datelabel])
    colormap('jet');
    
    figure
    set(gcf,'name',plotlabel);
    imshow(real(g)',[]);
    colorbar
    title(['mean ult g = ' sprintf('%0.2f',gmean) ', max ult g = ' sprintf('%0.2f',gmax)  datelabel])
    colormap('jet');
end

if plotprofile,
    figure;
    set(gcf,'name','Actual Excited Profile in 3D - parallel Tx - ultimate case');
    surf(x_fov,y_fov,real(profile));
    title(['Actual Excited Profile'])
    iptsetpref('ImshowInitialMagnification','fit');
    figure;
    set(gcf,'name','Actual Excited Profile - parallel Tx - ultimate case');
    imshow(real(profile),[]);
    title(['Actual Excited Profile'])
end

if plotcurrents | currents_plot_3D,
    for ipatterns = 1:size(whichvoxelpatterns,1),
        xvox = x_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        yvox = y_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        zvox = z_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        rhovox = sqrt(xvox^2 + yvox^2 + zvox^2);
        costhetavox = zvox/yvox;
        costhetavox(isnan(costhetavox)) = 0;
        thetavox = (180/pi)*acos(costhetavox);
        phivox = (180/pi)*atan2(yvox,xvox);
        plotlabel_current = char(...
            ['Ideal current pattern for parallel Tx (b=' num2str(100*outer_radius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [\rho,\phi,\theta]=[' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) '\circ,' num2str(thetavox,3) '\circ], \sigma_{coil}=' num2str(sigma_coil,'%0.2g') ', whichcurrents=[' num2str(whichcurrents) '], ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel)'],...
            ['                              SAR = ' num2str(real(sar(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2))))]);
        plot_currentpatterns_sphere(plotcurrents,currents_plot_3D,currentpattern(:,:,:,ipatterns),currentphi,currenttheta,plotlabel_current,outer_radius,[8 4])
        set(gcf,'name',['Ideal current pattern for parallel Tx ' num2str(fieldstrength,2) 'T, b=' num2str(100*outer_radius,2) 'cm, (rho,phi,theta)=' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) 'deg,' num2str(thetavox,3) 'deg), ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel'])
        drawnow
    end
end

if currents_movie
    
    h0 = warndlg('Don''t interact with the computer while the movie frames are recorded','** WARNING **');
    uiwait(h0);

    kspace = zeros(nf,np);
    truetrajectory = zeros(nf,np);
    figure;
    iptsetpref('ImshowInitialMagnification','fit');

    [x,y,z] = sphere(size(currentphi,1) - 1);

    for iframe = 1:(true_nf*true_np)

        h2 = subplot(2,1,2);
        warning off all
        imshow(kspace,[]);
        colormap('jet');
        set(h2,'Title',text('String','Excitation k-space','FontSize', 12,'FontWeight','bold'));
        set(h2,'XLim',[0.5 np+0.5],'YLim',[0.5 nf+0.5]);
        axis off
        set(gca,'Units','pixels')
        axisposition2 = get(gca,'Position');

        if rem(iframe,true_nf) == 0 % end of a column
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (true_nf - 1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
            else % even column
                ifreq = 1;
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
            end
            text(iphase, ifreq,'\rightarrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
        else
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (rem(iframe,true_nf)-1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
                text(iphase, ifreq,'\downarrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
            else % even column
                ifreq = 1 + (true_nf - 1)*acceleration_factor(1) - (rem(iframe,true_nf)-1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
                text(iphase, ifreq,'\uparrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
            end
        end
        disp(['Frame = ' num2str(iframe)    ', pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        [freqlist phaselist] = find(truetrajectory == 1);
        text(phaselist, freqlist,'\bullet','FontSize',8,'FontWeight','bold',...
            'Color','r','HorizontalAlignment','center')
        truetrajectory(ifreq,iphase) = 1;

        % plot currents
        test_1 = (whichvoxelpatterns(:,1) == ifreq);
        test_2 = (whichvoxelpatterns(:,2) == iphase);  % @@ WHEN ACC IS IN 2ND DIRECTION SHOULD NOT WORKING!!@
%         disp(['find(test_1 & test_2) = ' num2str(find(test_1 & test_2))])
        mycurrent = real(currentpattern(:,:,:,find(test_1 & test_2)));
        
        h1 = subplot(2,1,1);
        set(gcf,'CurrentAxes',h1);

        current_x = cos(currentphi).*cos(currenttheta).*mycurrent(:,:,1) - sin(currentphi).*mycurrent(:,:,2);
        current_y = sin(currentphi).*cos(currenttheta).*mycurrent(:,:,1) + cos(currentphi).*mycurrent(:,:,2);
        current_z = -sin(currenttheta).*mycurrent(:,:,1);
        quiver3(x',y',z',current_x,current_y,current_z,3,'Color',[0 0 1],'LineWidth',1.1);
        hold on;
        s = surf(x,y,z);
        set(s,'erasemode','normal')
        set(s,'facecolor','interp')
        % set(s,'facecolor',[1 0.46 0])
        % set(s,'FaceAlpha',0.7);
        set(s,'facecolor',[0.9 1 1])
        set(s,'EdgeColor','none');
        axis equal
        axis tight
        axis off

        show_axes = 1;
        if show_axes
            plotlim = 1.4;
            axislc = 'k';
            axislw = 2;
            textfs = 14;
            textlc = 'k';
            hlz = line([0 plotlim],[0 0],[0 0],'linewidth',axislw,'color',axislc,'erasemode','normal');
            htz = text(0.74,0,0,'z','fontsize',textfs,'color',textlc);
            hly = line([0 0],[0 plotlim],[0 0],'linewidth',axislw,'color',axislc,'erasemode','normal');
            hty = text(0,0.66,0,'y','fontsize',textfs,'color',textlc);
            hlx = line([0 0],[0 0],[0 plotlim],'linewidth',axislw,'color',axislc,'erasemode','normal');
            htx = text(-0.035,0,0.29,'x','fontsize',textfs,'color',textlc);

            view(-37.5-180,10)
        end
        
        hold off
        titlestring = char(['Time Interval: ' sprintf('%0.0f',iframe)]);
        set(gca,'Title',text('String',titlestring,'FontSize', 12,'FontWeight','bold'));
        set(gca,'nextplot','replacechildren');
        set(gca,'Units','pixels')
        axisposition1 = get(gca,'Position');

        xlabelstring = ([sprintf('%0.0f',fieldstrength) 'T, Acc = ',sprintf('%0.0f',acceleration_factor(1)) 'x',sprintf('%0.0f',acceleration_factor(2))]);
        set(get(h1,'XLabel'), 'String',xlabelstring,'FontSize', 12,'FontWeight','bold','EdgeColor','r',...
            'LineWidth',2,'BackgroundColor','w','HorizontalAlignment','right','VerticalAlignment','bottom','Visible','on','Margin',2);

%         if iframe==1
%             frameleft = floor(axisposition1(1) + 5);
%             framebottom = floor(axisposition2(2) - 10);
%             framewidth = floor(axisposition1(3) - 10);
%             frameheight = floor((axisposition1(2)-axisposition2(2)) + axisposition1(4) + 40);
%         end
        
        if iframe==1
            scalingunit = axisposition2(4)/nf;
            truewidth = np*scalingunit;
            deltawidth = (axisposition2(3)-truewidth)/2;
            frameleft = floor(axisposition1(1)+ deltawidth - 10);
            framebottom = floor(axisposition2(2) - 10);
            framewidth = floor(truewidth + 20);
            frameheight = floor((axisposition1(2)-axisposition2(2)) + axisposition1(4) + 40);
        end


        % record frame
        F(iframe) = getframe(gcf,[frameleft framebottom framewidth frameheight]); % [left bottom width height]

    end
    disp('Start making movie...');
    conto = 0;
    for frame = 1:1:size(F,2)
        conto = conto + 1;
        [X(:,:,:,conto),Map] = frame2im(F(frame));
    end
    mov = immovie(X,Map);
    moviefilename = [moviedir '/Ult_current_movie_matrix' num2str(nf) 'x' num2str(np) '_' num2str(fieldstrength) 'T_acc' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) '.avi'];
    movie2avi(mov,moviefilename,'compression',movie_compression,'fps',movie_fps);
    disp('movie saved.');
end

if localsar_movie
    clear iframe F frame conto X Map mov moviefilename 
    if isempty(localsar)
        disp('-------------------------------------------------------');
        disp('**ERROR** local SAR is empty');
        disp('-------------------------------------------------------');
        return
    end
    h10 = warndlg('Don''t interact with the computer while the movie frames are recorded','** WARNING **');
    uiwait(h10);

    kspace = zeros(nf,np);
    truetrajectory = zeros(nf,np);
    
    figure;
    iptsetpref('ImshowInitialMagnification','fit');
    for iframe = 1:(true_nf*true_np)
        myframe = log10(abs(localsar(:,:,iframe)));
%         if nf > np
%             myframe = myframe.';
%         end      
        h11 = subplot(2,1,1);
        set(gcf,'CurrentAxes',h11);
        imshow(myframe,[0 log10(peaksar)]);
%         if nf > np
%             set(gca,'XLim',[0.5 nf+0.5],'YLim',[0.5 np+0.5]);
%         else
            set(gca,'XLim',[0.5 np+0.5],'YLim',[0.5 nf+0.5]);
%         end
        axis off
        colormap('jet');
        titlestring = (['Time Interval: ' sprintf('%0.0f',iframe)]);
        set(gca,'Title',text('String',titlestring,'FontSize', 12,'FontWeight','bold'));
        set(gca,'nextplot','replacechildren');
        set(gca,'Units','pixels')
        axisposition1 = get(gca,'Position');
        
        xlabelstring = ([sprintf('%0.0f',fieldstrength) 'T, Acc = ',sprintf('%0.0f',acceleration_factor(1)) 'x',sprintf('%0.0f',acceleration_factor(2))]);
        set(get(h11,'XLabel'), 'String',xlabelstring,'FontSize', 12,'FontWeight','bold','EdgeColor','r',...
            'LineWidth',2,'BackgroundColor','w','HorizontalAlignment','center','VerticalAlignment','bottom','Visible','on','Margin',2);

        h22 = subplot(2,1,2);
        warning off all
        imshow(kspace,[]);
        colormap('jet');
        set(h22,'Title',text('String','Excitation k-space','FontSize', 12,'FontWeight','bold'));
%         if nf > np
%             set(h22,'XLim',[0.5 nf+0.5],'YLim',[0.5 np+0.5]);
%         else
            set(h22,'XLim',[0.5 np+0.5],'YLim',[0.5 nf+0.5]);
%         end
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
                ifreq = 1 + (true_nf - 1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
            else % even column
                ifreq = 1;
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
            end
            text(iphase, ifreq,'\rightarrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
        else
            if rem(ceil(iframe/true_nf),2) == 1 % odd column
                ifreq = 1 + (rem(iframe,true_nf)-1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
                text(iphase, ifreq,'\downarrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
            else % even column
                ifreq = 1 + (true_nf - 1)*acceleration_factor(1) - (rem(iframe,true_nf)-1)*acceleration_factor(1);
                iphase = 1 + (ceil(iframe/true_nf) - 1)*acceleration_factor(2);
                text(iphase, ifreq,'\uparrow','FontSize',8,'FontWeight','bold','EdgeColor','red','LineWidth',2,...
                    'BackgroundColor','w','HorizontalAlignment','center','Margin',0.1)
            end
        end

        %         disp(['     pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        disp(['Frame = ' num2str(iframe)    ', pixel = (' num2str(ifreq) ',' num2str(iphase) ')']);
        [freqlist phaselist] = find(truetrajectory == 1);
        text(phaselist, freqlist,'\bullet','FontSize',8,'FontWeight','bold',...
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
    moviefilename = [moviedir '/UltSAR_movie_matrix_' num2str(nf) 'x' num2str(np) '_' num2str(fieldstrength) 'T_acc' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) '.avi'];
    movie2avi(mov,moviefilename,'compression',movie_compression,'fps',movie_fps,'quality',100);
    disp('movie saved.');
end



function dgf_sphere_plot_coilSNR(snr_coil,g_coil,mask,currentpattern_coil,currentphi,currenttheta,...
       x_fov,y_fov,z_fov,whichvoxelpatterns,lmax,...
       fieldstrength,acceleration_factor,sphereradius,outer_radius,matrix_size,...
       sigma_coil,d_coil,coil_radii,coil_offsets,coil_rotations,ncoils,plot_coil_setup_flag,plot_coil_number_flag,...
       plotsnr,plotcurrents,plot_3D,commondir,user_label);
       

% function dgf_sphere_plot_coilSNR(snr_coil,g_coil,mask,currentpattern_coil,currentphi,currenttheta,...
%        x_fov,y_fov,z_fov,whichvoxelpatterns,lmax,...
%        fieldstrength,acceleration_factor,sphereradius,outer_radius,matrix_size,...
%        sigma_coil,d_coil,coil_radii,coil_offsets,coil_rotations,ncoils,plot_coil_setup_flag,plot_coil_number_flag,...
%        plotsnr,plotcurrents,plot_3D,commondir,user_label);
%    
% Plot routines for coil SNR, coil g-factor, coil current weights
% and coil current patterns.
%
% input:
% ------
%   snr_coil: matrix_size(1) x matrix_size(2) array of SNR values
%   g_coil: matrix_size(1) x matrix_size(2) array of g-factor values
%   mask: matrix_size(1) x matrix_size(2) binary mask showing object boundary
%   currentpattern_coil: currentpatternmatrixsize(1) x
%   currentpatternmatrixsize(2) x matrix_size(1) x matrix_size(2) array of current pattern values as a function of phi and theta
%   currentphi: phi coordinates for current pattern plotting
%   currenttheta: theta coordinates for current pattern plotting
%   x_fov: x coordinates of chosen fov
%   y_fov: y coordinates of chosen fov
%   z_fov: z coordinates of chosen fov
%   whichvoxelpatterns: (number of chosen voxels x 2) array of voxel indices for which to save current patterns [default NaN --> save current patterns for all voxels]
%   lmax: vector containing choice of n for azimuthal current modes
%   fieldstrength: field strength (Tesla)
%   acceleration_factor: 1 x 2 vector containing acceleration factors in each of two dimensions
%   sphereradius: radius of dielectric cylinder (m)
%   outer_radius: radius of coil former (m)
%   matrix_size: 1 x 2 vector containing image matrix dimensions
%   sigma_coil: conductivity of coil material, for estimates of coil noise (Siemens/m)
%   d_coil: thickness of coil material, for estimates of coil noise (m)
%   coil_radii: ncoils x 1 array of radii of circular coils (m)
%   coil_offsets: ncoils x 1 array of displacements of coil center from sphere center (m)
%   coil_rotations: ncoils x 2 array of inclination and azimuth [theta=beta phi=alpha] of coil center (degrees)
%   ncoils: number of circular surface coils in the array
%   plot_coil_setup_flag: 1 --> create figure with sphere, coil geometry and FOV used in the simulation
%   plot_coil_number_flag: 1 --> add coil number next to coil geometry
%   plotsnr: 1 --> plot snr
%   plotcurrents: 1 --> plot current patterns
%   plot_3D: 1 --> display currents pattern on tridimensional surfaces
%   commondir: directory with general routines
%   user_label: initials of current user
%
% Riccardo Lattanzi, 10-24-07
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(commondir);

rho_fov = sqrt(x_fov.^2 + y_fov.^2 + z_fov.^2);
costheta_fov = z_fov./rho_fov;
costheta_fov(isnan(costheta_fov)) = 0;
theta_fov = acos(costheta_fov);
phi_fov = atan2(y_fov,x_fov);

g_coil(~mask) = 0;
snr_coil(~mask) = 0;
gmax_coil = max(real(g_coil(:)));
gmean_coil = mean(real(g_coil(:)));
snrmax_coil = max(real(snr_coil(:)));
snrmean_coil = mean(real(snr_coil(:)));


% if isnan(whichvoxelweights),
%     [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
%     whichvoxelweights = [ind1(:) ind2(:)];
% end
if isnan(whichvoxelpatterns),
    [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
    whichvoxelpatterns = [ind1(:) ind2(:)];
end


plotlabel = [num2str(ncoils) ' Circular Coils, B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*sphereradius) 'cm, R=' ...
    num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ...
    ', radius = ' num2str(100*sphereradius) 'cm (IN) and ' num2str(100*outer_radius) 'cm (OUT), lmax= '...
        num2str(lmax)];
datelabel = ['      (' user_label ', '  datestr(now,0) ')'];

iptsetpref('ImshowInitialMagnification','fit');

if plotsnr,
    if isnan(snrmean_coil)
        disp('*************************************')
        disp('coil SNR not available for plotting')
        disp('*************************************')
    else
        figure
        set(gcf,'name',plotlabel);
        imshow(real(snr_coil)',[]);
        colorbar
        title(['mean coil SNR = ' sprintf('%0.2f',snrmean_coil) ', max coil SNR = ' sprintf('%0.2f',snrmax_coil)  datelabel])

        figure
        set(gcf,'name',plotlabel);
        imshow(real(g_coil)',[]);
        colorbar
        title(['mean coil g = ' sprintf('%0.2f',gmean_coil) ', max coil g = ' sprintf('%0.2f',gmax_coil)  datelabel])
    end
end

if plot_coil_setup_flag
%     figure;
    plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,x_fov,y_fov,z_fov,3,'-',[1 0.46 0],0,plot_coil_number_flag);
end

if plotcurrents,
    for ipatterns = 1:size(whichvoxelpatterns,1),
        xvox = x_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        yvox = y_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        zvox = z_fov(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2));
        rhovox = sqrt(xvox^2 + yvox^2 + zvox^2);
        costhetavox = zvox/yvox;
        costhetavox(isnan(costhetavox)) = 0;
        thetavox = (180/pi)*acos(costhetavox);
        phivox = (180/pi)*atan2(yvox,xvox);
        plotlabel_current_coil = char(...
            [num2str(ncoils) ' circular surface coils array current pattern (b=' num2str(100*outer_radius,2) 'cm, B_0=' num2str(fieldstrength,2)...
            'T, at voxel [\rho,\phi,\theta]=[' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) '\circ,' num2str(thetavox,3) '\circ], \sigma_{coil}=' num2str(sigma_coil,'%0.2g') ', ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel)'],...
            ['              SNR = ' num2str(real(snr_coil(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2))))]);
        plot_currentpatterns_sphere(plotcurrents,plot_3D,currentpattern_coil(:,:,:,ipatterns),currentphi,currenttheta,plotlabel_current_coil,outer_radius,[8 8])
        set(gcf,'name',[num2str(ncoils) ' circular surface coils array current pattern ' num2str(fieldstrength,2) 'T, b=' num2str(100*outer_radius) 'cm, (rho,phi,theta)=' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) 'deg,' num2str(thetavox,3) 'deg), ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel'])
        drawnow
    end
end

 

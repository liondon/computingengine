function dgf_sphere_plot_coilSAR_rfshim(profile,sar_global,mask,...
            currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,lmax,whichcurrents,...
            fieldstrength,sphereradius,outer_radius,matrix_size,...
            sigma_coil,d_coil,coil_radii,coil_offsets,coil_rotations,ncoils,plot_coil_setup_flag,plot_coil_number_flag,...
            plotcurrents,currents_plot_3D,plotprofile,commondir,plotdir,user_label)


% dgf_sphere_plot_coilSAR_rfshim(profile,sar_global,mask,...
%     currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,lmax,whichcurrents,...
%     fieldstrength,sphereradius,outer_radius,matrix_size,...
%     sigma_coil,d_coil,coil_radii,coil_offsets,coil_rotations,ncoils,plot_coil_setup_flag,plot_coil_number_flag,...
%     plotcurrents,currents_plot_3D,plotprofile,commondir,plotdir,user_label)
% 
% Plot routines for actual excited profile and surface current patterns of circular coils in the case of RF shim.
%
% input:
% ------
%   profile: matrix_size(1) x matrix_size(2) array with the actual excited profile
%   sar_global: average global SAR
%   mask: matrix_size(1) x matrix_size(2) binary mask showing object boundary
%   currentpattern: currentpatternmatrixsize(1) x currentpatternmatrixsize(2) x matrix_size(1) x matrix_size(2) array of current pattern values as a function of phi and z
%   currentphi: phi coordinates for current pattern plotting
%   currenttheta: theta coordinates for current pattern plotting
%   x_fov: x coordinates of chosen fov
%   y_fov: y coordinates of chosen fov
%   z_fov: z coordinates of chosen fov
%   lmax: vector containing choice of n for azimuthal current modes
%   whichcurrents: choice of current basis functions to include (1 = divergence-free mag dipole, 2 = curl-free electric dipole) [default [1 2] = both]
%   fieldstrength: field strength (Tesla)
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
%   plotcurrents: 1 --> plot current patterns
%   currents_plot_3D: 1 --> display currents pattern on tridimensional surfaces  
%   plotprofile: 1 --> plots the actual excited profile
%   commondir: directory with general routines
%   plotdir: directory with general plotting routines
%   user_label: initials of current user
%
% Riccardo Lattanzi, 3-27-08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(commondir);
addpath(plotdir);

rho_fov = sqrt(x_fov.^2 + y_fov.^2 + z_fov.^2);
costheta_fov = z_fov./rho_fov;
costheta_fov(isnan(costheta_fov)) = 0;
theta_fov = acos(costheta_fov);
phi_fov = atan2(y_fov,x_fov);

plotlabel = [num2str(ncoils) ' Circular Coils, B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*sphereradius) 'cm' ...
    ', radius = ' num2str(100*sphereradius) 'cm (IN) and ' num2str(100*outer_radius) 'cm (OUT), lmax= ' ...
    num2str(lmax) ', whichcurrents=[' num2str(whichcurrents) ']'];
datelabel = ['      (' user_label ', '  datestr(now,0) ')'];

iptsetpref('ImshowInitialMagnification','fit');

if plot_coil_setup_flag
    plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,x_fov,y_fov,z_fov,3,'-',[1 0.46 0],0,plot_coil_number_flag);
end

if plotprofile,
    figure;
    set(gcf,'name',['Actual Excited Profile in 3D - RF shim - ' num2str(ncoils) ' circular coils']);
    surf(x_fov,y_fov,real(profile));
    title(['Actual Excited Profile'])
    iptsetpref('ImshowInitialMagnification','fit');
    figure;
    set(gcf,'name',['Actual Excited Profile - RF shim - ' num2str(ncoils) ' circular coils']);
    imshow(real(profile),[]);
    title(['Actual Excited Profile'])
end

if plotcurrents | currents_plot_3D,
        plotlabel_current = char(...
            ['Ideal current pattern for RF shim (b=' num2str(100*outer_radius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T,  \sigma_{coil}=' num2str(sigma_coil,'%0.2g') ', whichcurrents=[' num2str(whichcurrents) ']'],...
            ['                           global SAR = ' num2str(sar_global)]);
        plot_currentpatterns_sphere(plotcurrents,currents_plot_3D,currentpattern,currentphi,currenttheta,plotlabel_current,outer_radius,[8 4])
        set(gcf,'name',['Ideal current pattern for RF shim ' num2str(fieldstrength,2) 'T, b=' num2str(100*outer_radius,2) 'cm'])
        drawnow
end

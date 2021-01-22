function dgf_sphere_plot_ultSNR(snr,g,mask,currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,...
    whichvoxelpatterns,lmax,whichcurrents,...
    fieldstrength,acceleration_factor,sphereradius,outer_radius,matrix_size,...
    sigma_coil,plotsnr,plotcurrents,plot_3D,commondir,user_label)


% function dgf_sphere_plot_ultSNR(snr,g,mask,currentpattern,currentphi,currenttheta,x_fov,y_fov,z_fov,...
%     whichvoxelpatterns,lmax,whichcurrents,...
%     fieldstrength,acceleration_factor,sphereradius,outer_radius,matrix_size,...
%     sigma_coil,plotsnr,plotcurrents,commondir,user_label)
% 
% Plot routines for ultimate SNR, ultimate g-factor, optimal weights
% and current patterns.
%
% input:
% ------
%   snr: matrix_size(1) x matrix_size(2) array of SNR values
%   g: matrix_size(1) x matrix_size(2) array of g-factor values
%   mask: matrix_size(1) x matrix_size(2) binary mask showing object boundary
%   currentpattern: currentpatternmatrixsize(1) x
%   currentpatternmatrixsize(2) x matrix_size(1) x matrix_size(2) array of current pattern values as a function of phi and theta
%   currentphi: phi coordinates for current pattern plotting
%   currenttheta: theta coordinates for current pattern plotting
%   x_fov: x coordinates of chosen fov
%   y_fov: y coordinates of chosen fov
%   z_fov: z coordinates of chosen fov
%   whichvoxelpatterns: (number of chosen voxels x 2) array of voxel indices for which to save current patterns [default NaN --> save current patterns for all voxels]
%   lmax: vector containing choice of n for azimuthal current modes
%   whichcurrents: choice of current basis functions to include (1 = divergence-free mag dipole, 2 = curl-free electric dipole) [default [1 2] = both]
%   fieldstrength: field strength (Tesla)
%   acceleration_factor: 1 x 2 vector containing acceleration factors in each of two dimensions
%   sphereradius: radius of dielectric cylinder (m)
%   outer_radius: radius of coil former (m)
%   matrix_size: 1 x 2 vector containing image matrix dimensions
%   sigma_coil: conductivity of coil material, for estimates of coil noise (Siemens/m)
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

% g(~mask) = 0;
snr(~mask) = 0;
% gmax = max(real(g(:)));
% gmean = mean(real(g(:)));
gmax = max(real(g(mask)));
gmean = mean(real(g(mask)));
snrmax = max(real(snr(:)));
snrmean = mean(real(snr(:)));

% if isnan(whichvoxelweights),
%     [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
%     whichvoxelweights = [ind1(:) ind2(:)];
% end
if isnan(whichvoxelpatterns),
    [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
    whichvoxelpatterns = [ind1(:) ind2(:)];
end
   
plotlabel = ['B_0=' num2str(fieldstrength) 'T, FOV=' num2str(100*2*sphereradius) 'cm, R=' ...
    num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ...
    ', radius = ' num2str(100*sphereradius) 'cm (IN) and ' num2str(100*outer_radius) 'cm (OUT), lmax= ' ...
    num2str(lmax) ', whichcurrents=[' num2str(whichcurrents) ']'];
datelabel = ['      (' user_label ', '  datestr(now,0) ')'];

iptsetpref('ImshowInitialMagnification','fit');

if plotsnr,
    figure
    set(gcf,'name',plotlabel);
    imshow(real(snr)',[]);
    colorbar
    title(['mean ult SNR = ' sprintf('%0.2f',snrmean) ', max ult SNR = ' sprintf('%0.2f',snrmax)  datelabel])

    figure
    set(gcf,'name',plotlabel);
    imshow(real(g)',[]);
    colorbar
    title(['mean ult g = ' sprintf('%0.2f',gmean) ', max ult g = ' sprintf('%0.2f',gmax)  datelabel])
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
        plotlabel_current = char(...
            ['Optimal current pattern (b=' num2str(100*outer_radius,2) 'cm, B_0=' num2str(fieldstrength,2) ...
            'T, at voxel [\rho,\phi,\theta]=[' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) '\circ,' num2str(thetavox,3) '\circ], \sigma_{coil}=' num2str(sigma_coil,'%0.2g') ', whichcurrents=[' num2str(whichcurrents) '], ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel)'],...
            ['                              SNR = ' num2str(real(snr(whichvoxelpatterns(ipatterns,1),whichvoxelpatterns(ipatterns,2))))]);
        plot_currentpatterns_sphere(plotcurrents,plot_3D,currentpattern(:,:,:,ipatterns),currentphi,currenttheta,plotlabel_current,outer_radius,[8 4])
        set(gcf,'name',['optimal current pattern ' num2str(fieldstrength,2) 'T, b=' num2str(100*outer_radius,2) 'cm, (rho,phi,theta)=' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) 'deg,' num2str(thetavox,3) 'deg), ' num2str(acceleration_factor(1)) 'x' num2str(acceleration_factor(2)) ' accel'])
        drawnow
    end
end

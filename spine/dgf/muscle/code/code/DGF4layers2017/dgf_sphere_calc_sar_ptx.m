        
function  [output_values] = dgf_sphere_calc_sar_ptx(... 
                  whichcurrents,fieldstrength,acceleration,s_opts,g_opts,path_opts,currentpatternmatrixsize,whichvoxels,whichvoxelweights)
        
%--------------------------------------------------------------------------
% 
% function  [output_values] = dgf_sphere_calc_sar_ptx(... 
%                  whichcurrents,fieldstrength,acceleration,simulation_options,geometry_options,path_options,p_opts,currentpatternmatrixsize,whichvoxels,whichvoxelweights);
% ------
% input:
% ------
%   whichcurrents: choice of current basis functions to include (1 = divergence-free mag dipole, 2 = curl-free electric dipole) [default [1 2] = both]
%   fieldstrength: field strength (Tesla)
%   acceleration: 1 x 2 vector containing acceleration factors in each of two dimensions
%   expsnr_num: experimental SNR scaling
%   s_opts:
%       lmax: 2*[(lmax + 1)^2 - 1] modes in the harmonic expansion (NB: l=0 is not included because it gives no SNR contribution)
%       include_ult_conductor_losses: 1 --> include losses due to Johnson noise (by uSNR definition should be 0), 0 --> sigma infinite and no coil noise
%       include_coil_conductor_losses: 1 --> include coil losses due to Johnson noise, 0 --> sigma infinite and no coil noise
%       include_ult_radiation_losses: 1 --> include modes' radiation losses (average Poynting vector, no shielding)
%       include_coil_radiation_losses: 1 --> include coils' radiation losses (average Poynting vector, no shielding)
%       include_circuit_losses: 1 --> include noise (not for ultimate case) due to impedance transformation network and LNA (** currently only noise figure **)
%       include_psi_coil: 1 --> include noise correlation matrix in coil optimization
%       include_experimental_snr_scaling: 1 --> include sequence related scaling factors
%       noisefactor: noise factor of the receive chain
%       compute_ultSNR_flag: 1 --> compute ultimate intrinsic SNR
%       compute_coilSNR_flag: 1 --> calculate SNR and g also for circular surface coils
%       compute_ult_current_pattern_flag: 1 --> compute ultimate current pattern
%       compute_coil_current_pattern_flag: 1 --> compute coil current pattern
%       save_efields_ult_flag: 1 --> save a matrix with the modes' electric fields at each position
%       save_efields_coil_flag: 1 --> save a matrix with the coils' electric fields at each position
%       save_bfields_ult_flag: 1 --> save a matrix with the modes' magnetic fields at each position
%       save_bfields_coil_flag: 1 --> save a matrix with the coils' magnetic fields at each position
%       save_ult_current_weights_flag: 1 --> save ultimate current weights
%       save_coil_current_weights_flag: 1 --> save circular surface coil current weights
%       save_ult_currents_flag: 1 --> save ultimate current patterns
%       save_coil_currents_flag: 1 --> save coil current patterns
%       save_noise_contributions: 1 --> save sample, coil and radiation losses separately 
%       sigma_coil: conductivity of coil material, for estimates of coil noise (Siemens/m)
%       d_coil: thickness of coil material, for estimates of coil noise (m)
%       tissue_type: 1 --> brain from Wiesinger et al, 2 --> dog skeletal muscle Cole-Cole-scaled from Stoy et al [default 1], 3 --> Dog skeletal muscle from Schnell thesis Appendix C.
%       epsilon_rel: relative permittivity of imaged body  [NaN --> select tissue values based on field strength]
%       sigma: conductivity of imaged body (Siemens/m) [NaN --> select tissue values based on field strength]




%   g_opts:
%       preset_fov_geometry_flag: 1 --> load FOV data from .MAT file
%       fov_file: file with FOV data (if [] user is allow to browse directories)
%	    fovf: fov in the frequency-encoding direction
%	    fovp: fov in the phase-encoding direction
%       matrix_size: 1 x 2 vector containing image matrix dimensions
%       sphereradius: radius of dielectric sphere (m)
%       currentradius: radius of coil former (m)
%	    phasedir: phase encoding / foldover direction flag ('FH' or 'LR')
%	    patientposition: 'headfirst' or 'feetfirst'
%	    patientorientation: 'supine','prone','ldecub', or 'rdecub'
%	    sliceorientation: reference slice orientation ('transverse','sagittal', or 'coronal')
%       image_plane_offset: [apoff lroff fhoff] list of linear offsets in the AP, LR, FH direction
%       image_plane_orientation: [apang lrang fhang] list of angular offsets about the AP, LR, FH axis
%       ncoils: number of circular surface coils in the array
%       coil_rotations: ncoils x 2 array of inclination and azimuth [theta=beta phi=alpha] of coil center (degrees)
%       coil_radii: ncoils x 1 array of radii of circular coils (m)
%       coil_offsets: ncoils x 1 array of displacements of coil center from sphere center (m)
%   path_opts:
%       commondir: directory with general routines used in the calculations
%       plotdir: directory with plotting routines
%       basissetdir: sub-directory to store results for the ultimate case
%       circcoildir: sub-directory to store results for the coil case
%       moviedir: sub-directory to store movies
%       logdir: sub-directory to store log files
%       geometrydir: sub-directory with preset coil geometries
%   currentpatternmatrixsize: dimensions of stored current pattern for each voxel position [default 32 x 32]                
%   whichvoxels: (number of chosen voxels x 2) array of voxel indices for which to compute current patterns [default NaN --> save current patterns for all voxels]
%   whichvoxelweights: (number of chosen voxels x 2) array of voxel indices for which to save weights [default NaN --> save weights for all voxels]
%   plot_poynting_sphere
%
% -------
% output:
% -------
%   output_values:
%       snr_ult: matrix_size(1) x matrix_size(2) array of SNR values
%       g_ult: matrix_size(1) x matrix_size(2) array of g-factor values
%       snr_coil: matrix_size(1) x matrix_size(2) array of circular surface coil array SNR values
%       g_coil: matrix_size(1) x matrix_size(2) array of circular surface coil array g-factor values
%       psi_coil: coil noise covariance matrix
%       mask: matrix_size(1) x matrix_size(2) binary mask showing object boundary
%       whichvoxels: (number of chosen voxels x 2) array of voxel indices for which to compute current patterns [default NaN --> save current patterns for all voxels]
%       whichvoxelweights: (number of chosen voxels x 2) array of voxel indices for which to save weights [default NaN --> save weights for all voxels]
%       weights: length(whichn) x length(whichm) x length(whichcurrents) x size(whichvoxelweights) array of optimal weights for current basis elements
%       weights_coil: length(whichn) x length(whichm) x length(whichcurrents) x size(whichvoxelweights) array of optimal weights for circular surface coils
%       currentpattern: currentpatternmatrixsize(1) x currentpatternmatrixsize(2) x 2 x number of chosen voxels array of current pattern values as a function of phi and theta
%       currentpattern_coil: currentpatternmatrixsize(1) x currentpatternmatrixsize(2) x 2 x number of chosen voxels array of circular surface current pattern values as a function of phi and z
%       currentphi: phi coordinates for current pattern plotting
%       currenttheta: theta coordinates for current pattern plotting
%       epsilon_rel: the value of epsilon_rel actually used if epsilon_rel was set to NaN on input
%       sigma: the value of sigma actually used if sigma was set to NaN on input
%       x_fov: x coordinates of chosen fov
%       y_fov: y coordinates of chosen fov
%       z_fov: z coordinates of chosen fov
%
% Riccardo Lattanzi, June 1, 2012
%
% Debugging notes:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath(path_opts.commondir);
addpath(path_opts.plotdir);

matrix_size = g_opts.matrix_size;
fovf = g_opts.fovf;
fovp = g_opts.fovp;

lmax = s_opts.lmax;
tissue_type = s_opts.tissue_type;
sphereradius = g_opts.sphereradius;
currentradius = g_opts.currentradius;
sigma_coil = s_opts.sigma_coil;
ncoils = g_opts.ncoils;
coil_rotations = g_opts.coil_rotations;
coil_radii = g_opts.coil_radii;
coil_offsets = g_opts.coil_offsets;

% RL 9/26/2013 to account for the 90 degrees shift between UISAR
% and coil SAR
shiftrotation = zeros(size(coil_rotations));
shiftrotation(:,2) = 90*ones(size(coil_rotations,1),1);
coil_rotations = coil_rotations - shiftrotation;
%%--------------------%%

disp('***   running dgf_sphere_calc_sar_ptx...')
tic
disp('***---------------------------------------------***');
disp(['***   Bo = ' num2str(fieldstrength,3) ' Tesla']);
disp(['***   Acceleration Factor = ' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ]);
disp(['***   Sphere Radius = ' num2str(sphereradius*100,3) ' cm']);
disp(['***   Current Distribution Radius = ' num2str(currentradius*100,3) ' cm']);

if all(whichcurrents==1),
    disp('***   Magnetic dipole currents only');
elseif all(whichcurrents==2),
    disp('***   Electric dipole currents only');
else
    disp('***   Magnetic and electric dipole currents');    
end
disp('***---------------------------------------------***');

if s_opts.save_efields_ult_flag || s_opts.save_efields_coil_flag
    save_efields_flag = 1;
else
    save_efields_flag = 0;
end
if s_opts.save_bfields_ult_flag || s_opts.save_bfields_coil_flag
    save_bfields_flag = 1;
else
    save_bfields_flag = 0;
end


% -- define FOV --
x_fov = [];
y_fov = [];
z_fov = [];
if g_opts.preset_fov_geometry_flag % file must contain x_fov,y_fov,z_fov
    load(g_opts.fov_file);
    nf = matrix_size(1);
    np = matrix_size(2);
else
    nf = matrix_size(1);
    np = matrix_size(2);
    apoff = g_opts.image_plane_offset(1); lroff = g_opts.image_plane_offset(2); fhoff = g_opts.image_plane_offset(3);
    apang = g_opts.image_plane_orientation(1); lrang = g_opts.image_plane_orientation(2); fhang = g_opts.image_plane_orientation(3);
    
    [x_fov,y_fov,z_fov] = sphere_mkplane(fovf,fovp,nf,np,g_opts.phasedir,...
        g_opts.patientposition,g_opts.patientorientation,...
        g_opts.sliceorientation,apoff,lroff,fhoff,apang,lrang,fhang);

    % Make pixels positions symmetric with respect to the origin for a transverse plane
%     if g_opts.sliceorientation == 'transverse'
%         x_fov = x_fov + ((fovf/nf)/2);
%         y_fov = y_fov + ((fovp/np)/2);
%     end


    % Make pixels positions symmetric with respect to the origin for a transverse plane
    switch g_opts.sliceorientation
        case 'coronal'
            if g_opts.phasedir == 'FH'
                x_fov = x_fov + ((fovf/nf)/2);
                z_fov = z_fov + ((fovp/np)/2);
            elseif g_opts.phasedir == 'LR'
                x_fov = x_fov + ((fovp/np)/2);
                z_fov = z_fov + ((fovf/nf)/2);
            end
        case 'transverse'
            if g_opts.phasedir == 'FH'
                x_fov = x_fov + ((fovf/nf)/2);
                y_fov = y_fov + ((fovp/np)/2);
            elseif g_opts.phasedir == 'LR'
                x_fov = x_fov + ((fovp/np)/2);
                y_fov = y_fov + ((fovf/nf)/2);
            end
        case 'sagittal'
            if g_opts.phasedir == 'FH'
                y_fov = y_fov + ((fovf/nf)/2);
                z_fov = z_fov + ((fovp/np)/2);
            elseif g_opts.phasedir == 'LR'
                y_fov = y_fov + ((fovp/np)/2);
                z_fov = z_fov + ((fovf/nf)/2);
            end
    end
    tot_fov = [x_fov, y_fov, z_fov];
    tot_fov = reshape(tot_fov,size(x_fov,1),size(x_fov,2),3);
    
end

%-- check if all varaiables are there --%
if isempty(x_fov) || isempty(y_fov) || isempty(z_fov)
    disp('-------------------------------------------------------');
    disp('**ERROR** unspecified FOV variable');
    disp('-------------------------------------------------------');
    pause
end

% -- determine wavevectors -- 
mu = 4*pi*1e-7;         % permeability of free space [Wb][A^-1][m^-1]
c = 3e8;                % speed of light [m][s]
epsilon_0 = 1/(mu*c^2); % permittivity [C][V^-1] = [s^4][A^2][m^-2][kg^-2]

omega = 2*pi*42.576e6*fieldstrength; % Larmor frequency [Hz]

switch tissue_type
    case 1  % Brain from Wiesinger et al
        fieldset = [1 3 5 7 9 11];
        epsilon_rel_brain = [102.5 63.1 55.3 52 50 48.8];
        sigma_brain = [0.36 0.46 0.51 0.55 0.59 0.62];
        if isnan(s_opts.epsilon_rel),
            epsilon_rel = spline(fieldset,epsilon_rel_brain,fieldstrength);
        else
            epsilon_rel = s_opts.epsilon_rel;
        end
        if isnan(s_opts.sigma),
            sigma = spline(fieldset,sigma_brain,fieldstrength);
        else
            sigma = s_opts.sigma;
        end
    case 2  % Dog skeletal muscle Cole-Cole-scaled from Stoy et al
        epsilon_s = 17025;
        epsilon_inf = 47.49;
        f_c = 263.4e3;
        omega_c = 2*pi*f_c;
        alpha = 0.101;
        freqfac = (omega/omega_c)^(1-alpha);
        freqsinfac = freqfac*sin(alpha*pi/2);
        propdenom = 1+freqfac^2+2*freqsinfac;
        if isnan(s_opts.epsilon_rel),
            epsilon_rel = epsilon_inf + (epsilon_s-epsilon_inf)*(1+freqsinfac)/propdenom;
        else
            epsilon_rel = s_opts.epsilon_rel;
        end
        if isnan(s_opts.sigma),
            sigma = omega*epsilon_0*(epsilon_s-epsilon_inf)*freqfac*cos(alpha*pi/2)/propdenom;
        else
            sigma = s_opts.sigma;
        end
    case 3  % Dog skeletal muscle from Schnell thesis Appendix C
        epsilon_s = 17025;
        epsilon_inf = 47.49;
        sigma_s = 0.3764;
        f_c = 263.4e3;
        alpha = 0.101;
        omega_c = 2*pi*f_c;
        freqratio = (omega/omega_c);
        epsilon_star = epsilon_inf - i*sigma_s/(omega*epsilon_0) + (epsilon_s - epsilon_inf)/(1+(i*freqratio)^(1-alpha));
        if isnan(s_opts.epsilon_rel),
            epsilon_rel = real(epsilon_star);
            epsilon_rel = (58/67)*epsilon_rel;
        else
            epsilon_rel = s_opts.epsilon_rel;
        end
        if isnan(s_opts.sigma),
            sigma = -omega*epsilon_0*imag(epsilon_star);
            sigma = (0.3/0.8)*sigma;
        else
            sigma = s_opts.sigma;
        end
end
epsilon = epsilon_rel*epsilon_0;
epsilon_r3 = g_opts.epsilon_r3*epsilon_0;
epsilon_r2 = g_opts.epsilon_r2*epsilon_0;

% -- create results file name -- 
if length(whichcurrents) > 1
    curr_label = 3;
else
    curr_label = whichcurrents;
end
filetosave_ult = [ path_opts.basissetdir 'ultimate_sar_results/UISARptx_sphere_r[' ...
    num2str(sphereradius*100) '-' num2str(g_opts.radius2*100) '-' num2str(g_opts.radius1*100) '-' num2str(currentradius*100) 'cm]_' ...
    sprintf('%2.1fT_',fieldstrength) num2str(matrix_size(1)) 'x' num2str(matrix_size(2)) ...
    '_acc_' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
    '_e[' sprintf('%1.0f-',epsilon_rel) sprintf('%1.0f-',g_opts.epsilon_r2) sprintf('%1.0f',g_opts.epsilon_r3) ']' ...
    '_s[' sprintf('%2.2f-',sigma) sprintf('%2.2f-',g_opts.sigma2) sprintf('%2.2f',g_opts.sigma3) ']' ...
    '_p' num2str(s_opts.profile_shape) '_l' num2str(lmax) '_cur_' num2str(curr_label) '.mat'];


% for loop coils curr_label is always equal to one, so it's not included in the file name
if s_opts.compute_coilSAR_pTx_flag
    if s_opts.include_psi_coil
        filetosave_coil = [ path_opts.circcoildir 'coils_sar_results/cSARptx_sphere_r[' ...
            num2str(sphereradius*100) '-' num2str(g_opts.radius2*100) '-' num2str(g_opts.radius1*100) '-' num2str(currentradius*100) 'cm]_' ...
            sprintf('%2.1fT_',fieldstrength) num2str(matrix_size(1)) 'x' num2str(matrix_size(2)) ...
            '_acc_' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
            '_e[' sprintf('%1.0f-',epsilon_rel) sprintf('%1.0f-',g_opts.epsilon_r2) sprintf('%1.0f',g_opts.epsilon_r3) ']' ...
            '_s[' sprintf('%2.2f-',sigma) sprintf('%2.2f-',g_opts.sigma2) sprintf('%2.2f',g_opts.sigma3) ']' ...
            '_c' num2str(ncoils) '_p' num2str(s_opts.profile_shape) '_l' num2str(lmax) '.mat'];
    else
        filetosave_coil = [ path_opts.circcoildir 'coils_sar_results/cSARptx_sphere_r[' ...
            num2str(sphereradius*100) '-' num2str(g_opts.radius2*100) '-' num2str(g_opts.radius1*100) '-' num2str(currentradius*100) 'cm]_' ...
            sprintf('%2.1fT_',fieldstrength) num2str(matrix_size(1)) 'x' num2str(matrix_size(2)) ...
            '_acc_' num2str(acceleration(1)) 'x' num2str(acceleration(2)) ...
            '_e[' sprintf('%1.0f-',epsilon_rel) sprintf('%1.0f-',g_opts.epsilon_r2) sprintf('%1.0f',g_opts.epsilon_r3) ']' ...
            '_s[' sprintf('%2.2f-',sigma) sprintf('%2.2f-',g_opts.sigma2) sprintf('%2.2f',g_opts.sigma3) ']' ...
            '_c' num2str(ncoils) '_p' num2str(s_opts.profile_shape) '_l' num2str(lmax) '_nopsi.mat'];
    end
end

% % Define a mask for the pixel within the circular section
% r_fov = sqrt(x_fov.^2 + y_fov.^2);
% mask = (r_fov <= sphereradius);

% Define a mask for the pixel within the circular section
switch  g_opts.sliceorientation
    case 'coronal'
        r_fov = sqrt(x_fov.^2 + z_fov.^2);
        mask = (r_fov <= sphereradius);
        direc = [1 3];
    case 'transverse'
        r_fov = sqrt(x_fov.^2 + y_fov.^2);
        mask = (r_fov <= sphereradius);
        direc = [1 2];
    case 'sagittal'
        r_fov = sqrt(y_fov.^2 + z_fov.^2);
        mask = (r_fov <= sphereradius);
        direc = [2 3];
end

% switch s_opts.profile_shape
%     case 1
%         mu_profile = double((r_fov <= sphereradius)); % simplest profile: one everywhere on the section
%     case 2
%         mu_profile = generate_smooth_profile(sphereradius, x_fov, y_fov, mask, plot_target_profile, 1);
%     case 3
%         mu_profile = generate_smooth_profile(sphereradius, x_fov, y_fov, mask, plot_target_profile, 2);
% end

%% --- CHECK THIS --- %%
% Define mu profile shape from fov
switch s_opts.profile_shape
    case 1
        mu_profile = double((r_fov <= sphereradius)); % simplest profile: one everywhere on the section
    case 2
        mu_profile = generate_smooth_profile(sphereradius, tot_fov(:,:,direc(1)), tot_fov(:,:,direc(2)), mask, 0, 1);
    case 3
        mu_profile = generate_smooth_profile(sphereradius, tot_fov(:,:,direc(1)), tot_fov(:,:,direc(2)), mask, 0, 2);
end

% -- set up for saving current patterns --
if s_opts.compute_ult_current_pattern_flag
    if isempty(whichvoxels),
        [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
        whichvoxels = [ind1(:) ind2(:)];
    end
    currentpattern = zeros([currentpatternmatrixsize 2 size(whichvoxels,1)]);
    if s_opts.compute_coil_current_pattern_flag
        currentpattern_coil = currentpattern;
    else
        currentpattern_coil = [];
    end
    delta_phi = 2*pi/currentpatternmatrixsize(1);
    delta_theta = pi/currentpatternmatrixsize(2);                                                 
%     [currentphi,currenttheta] = ndgrid(-pi:delta_phi:(pi-delta_phi),-pi/2:delta_theta:(pi/2-delta_theta));
    [currentphi,currenttheta] = ndgrid(0:delta_phi:(2*pi-delta_phi),0:delta_theta:(pi-delta_theta));
    cos_currenttheta = cos(currenttheta);
%     cot_currenttheta = cot(currenttheta);
    csc_currenttheta = csc(currenttheta); % NB: it's infinite at theta = 0
else
    currentpattern = [];
    currentpattern_coil = [];
    currentphi = [];
    currenttheta = [];
end
% -- set up for saving optimal voxel weights --
% if s_opts.save_ult_current_weights_flag == 1,
%     if isempty(whichvoxelweights),
%         [ind1,ind2] = meshgrid(1:matrix_size(1),1:matrix_size(2));
%         whichvoxelweights = [ind1(:) ind2(:)];
%     end
%     weights = zeros([((lmax+1)^2 - 1) length(whichcurrents) size(whichvoxelweights,1)]);
% else
%     weights = [];
% end
% if s_opts.save_coil_current_weights_flag == 1,
%     weights_coil = zeros([ncoils size(whichvoxelweights,1)]);
% else
%     weights_coil = [];
% end
if s_opts.compute_coilSAR_pTx_flag
    drfac = pi/180;
    rot_coil = coil_rotations*drfac;
end

if isnan(s_opts.d_coil),
    d_coil = 1/sqrt(omega*mu*sigma_coil/2);
    % use skin depth of coil conductor as coil thickness
    % d_coil = delta_coil = 1/sqrt(pi*f*mu_0*sigma_coil);
else
    d_coil = s_opts.d_coil;
end

disp('-------------------------------------------');
disp(['B_o = ' num2str(fieldstrength) ' [T]']);
disp(['omega = ' num2str(omega/1E6) ' [MHz]']);
disp(['sigma 4 = ' num2str(sigma) ' [ohm^-1][m^-1]']);
disp(['epsilon 4 = ' num2str(epsilon) ' [C][V^-1]']);
disp(['sigma 3 = ' num2str(g_opts.sigma3) ' [ohm^-1][m^-1]']);
disp(['epsilon 3 c= ' num2str(epsilon_r3) ' [C][V^-1]']);
disp(['sigma 2 = ' num2str(g_opts.sigma2) ' [ohm^-1][m^-1]']);
disp(['epsilon 2 = ' num2str(epsilon_r2) ' [C][V^-1]']);
disp('-------------------------------------------');

k_0_squared = omega*omega*epsilon_0*mu;
% k_0_squared = omega*omega*500*epsilon_0*mu;
k_0 = sqrt(k_0_squared);

k_s_squared = omega*mu*(omega*epsilon+1i*sigma);
k_s = sqrt(k_s_squared);

k_3_squared = omega*mu*(omega*epsilon_r3+1i*g_opts.sigma3);
% k_3_squared = omega*omega*epsilon_0*mu;
k_3 = sqrt(k_3_squared);

k_2_squared = omega*mu*(omega*epsilon_r2+1i*g_opts.sigma2);
% k_2_squared = omega*omega*epsilon_0*mu;
k_2 = sqrt(k_2_squared);

disp('-------------------------------------------');
disp(['Radius 3 = ' num2str(sphereradius) ' [m]']);
disp(['Radius 2 = ' num2str(g_opts.radius2) ' [m]']);
disp(['Radius 1 = ' num2str(g_opts.radius1) ' [m]']);
disp(['Current Radius = ' num2str(currentradius) ' [m]']);
disp('-------------------------------------------');

% -- initialize SAR and transmit g-factor -- 
% sar_ult_ptx = zeros(size(x_fov));
sar_ult_ptx = zeros(size(tot_fov(:,:,direc(1)))); %%--- CHECK THIS ---%
g_ult_ptx = sar_ult_ptx;
actual_profile_ptx_ult = sar_ult_ptx;
% sar_global_ult = NaN;                           % Average of SAR calculated using  mu*[(C*phi^-1*C')^-1]*mu'

if s_opts.compute_coilSAR_pTx_flag
    sar_coil_ptx = sar_ult_ptx;
    g_coil_ptx = g_ult_ptx;
    actual_profile_ptx_coil = sar_coil_ptx;
    sar_global_coil = 0;
    if s_opts.compute_rf_power_requirements
        power_req_coil = 0;
    else
        power_req_coil = NaN;
    end
else
    sar_coil_ptx = [];
    g_coil_ptx = [];
    actual_profile_ptx_coil = [];
    sar_global_coil = NaN;
    power_req_coil = NaN;
    psi_coil = [];
    weights_coil = [];
    currentpattern_coil = [];
end

% -- initialize other variables --
if length(whichcurrents) == 1,
    numbasis = (lmax + 1)^2 - 1;
    counterincrement = 0;
else
    numbasis = 2*((lmax + 1)^2 - 1);
    counterincrement = 1;
end

if s_opts.save_efields_ult_flag || s_opts.compute_localSAR_flag,
    efield_ult_set = zeros(numbasis,nf,np,3); % E field of each mode at each position
else
    efield_ult_set = [];
end
if s_opts.compute_coilSAR_pTx_flag && (s_opts.save_efields_coil_flag || s_opts.compute_localSAR_flag),
    efield_coil_set = zeros(ncoils,nf,np,3);
else
    efield_coil_set = [];
end
if s_opts.save_bfields_ult_flag,
    bfield_ult_set = zeros(numbasis,nf,np,3); % B field of each mode at each position
else
    bfield_ult_set = [];
end
if s_opts.compute_coilSAR_pTx_flag && s_opts.save_bfields_coil_flag,
    bfield_coil_set = zeros(ncoils,nf,np,3);
else
    bfield_coil_set = [];
end    

% ---------------------------------- %
%         Simulation begins
% ---------------------------------- %

% -- constant factors depending on sphere radius -- %
% k_0_rad_a = k_0*sphereradius;
k_0_rad_b = k_0*currentradius;
% besselnorm_rad_a = sqrt(pi/(2*k_0_rad_a));
besselnorm_rad_b = sqrt(pi/(2*k_0_rad_b));

% ele_scaling = -1i*(omega*mu)/k_s; % scaling factor for the Electric field
% mag_scaling = -1i*mu*k_0*k_0*currentradius; % scaling factor for the Magnetic field
ele_scaling = omega*mu*k_0*currentradius*currentradius; % scaling factor for the Electric field (RL fixed on 6/11/2012)
mag_scaling = -1i*mu*k_s*k_0*currentradius*currentradius; % scaling factor for the Magnetic field (RL fixed on 6/11/2012)

ele_scaling_poynting = -(omega*mu)/k_0; % scaling factor for the Electric field (RL added on 6/11/2012)
mag_scaling_poynting = -1i*mu; % scaling factor for the Magnetic field (RL added on 6/11/2012)

% all_coil_sens = zeros(matrix_size); % TEMP for revision

% -- loop through voxel positions -- 
ind_skip = floor(matrix_size./acceleration);

% -- initialize weigths and other variables --
f_map = zeros(numbasis,ind_skip(1),ind_skip(2));
sar_pulses = zeros(ind_skip);
if s_opts.compute_coilSAR_pTx_flag
    f_map_coil = zeros(ncoils,ind_skip(1),ind_skip(2));
    sar_pulses_coil = zeros(ind_skip);
    if s_opts.compute_rf_power_requirements
        sar_pulses_powreq_coil = zeros(ind_skip);
    end
else
    f_map_coil = [];
    sar_pulses_coil = [];
end

disp('  looping through voxel positions...')
for ind_1 = 1:ind_skip(1), 
    ind_1_set = ind_1:ind_skip(1):matrix_size(1);
    for ind_2 = 1:ind_skip(2),
        disp(['    voxel (' num2str(ind_1) ',' num2str(ind_2) ')'])
        ind_2_set = ind_2:ind_skip(2):matrix_size(2);
                
        xset = x_fov(ind_1_set,ind_2_set);
        xset = xset(:).';
        yset = y_fov(ind_1_set,ind_2_set);
        yset = yset(:).';
        zset = z_fov(ind_1_set,ind_2_set);
        zset = zset(:).';
        
        mu_profile_set = mu_profile(ind_1_set,ind_2_set);
        mu_profile_set = mu_profile_set(:);    % [R]x[1] vector vector RL 6/12/2007 for 2D accelerations
        
        % Convert in spherical coordinates
        rset = sqrt(xset.^2 + yset.^2 + zset.^2);   % rho
        costhetaset = zset./rset;                   % cos[theta]
        costhetaset(isnan(costhetaset)) = 0;        %** NaN at r=0  
        thetaset = acos(costhetaset);               % theta
        phiset = atan2(yset,xset);                  % phi

        sinthetaset = sin(thetaset);                % sin[theta]
        sinphiset = sin(phiset);                    % sin[phi]
        cosphiset = cos(phiset);                    % cos[phi]

        cotthetaset = cot(thetaset);                % cot[theta] ** Inf at theta=0
        cscthetaset = csc(thetaset);                % csc[theta] ** Inf at theta=0
        cos2thetaset = costhetaset.*costhetaset;    % cos[theta]^2
        
        % unit vectors conversion
        rhat_x = sinthetaset.*cosphiset;
        rhat_y = sinthetaset.*sinphiset;
        rhat_z = costhetaset;
%         thetahat_x = costhetaset.*cosphiset;
%         thetahat_y = costhetaset.*sinphiset;
%         thetahat_z = -sinthetaset;
%         phihat_x = -sinphiset;
%         phihat_y = cosphiset;
        
        krset_s = k_s*rset;
        besselnorm = sqrt(pi./(2.*krset_s));
        % ----------------------------------------- %
        
        % generate sensitivity matrix for each mode
        counter = 1;
        counter_modes = 1;
        X_full = zeros(numbasis,length(ind_1_set)*length(ind_2_set));
        X_P_full = X_full.';
        
        if s_opts.compute_coilSAR_pTx_flag,
            % Initialize quantities needed for circular coil computations
            X_modes = zeros(((lmax + 1)^2 - 1),length(ind_1_set)*length(ind_2_set));
            P_modes = zeros(((lmax + 1)^2 - 1),1);
            if s_opts.compute_rf_power_requirements
                P_req_modes = zeros(((lmax + 1)^2 - 1),1);
            end
        end
        
        if s_opts.save_efields_ult_flag || s_opts.compute_localSAR_flag,
            all_E_phase = zeros(numbasis,length(ind_1_set)*length(ind_2_set),3);
        end
        if s_opts.compute_coilSAR_pTx_flag && (s_opts.save_efields_coil_flag || s_opts.compute_localSAR_flag),
            all_E_phase_modes = zeros(((lmax + 1)^2 - 1),length(ind_1_set)*length(ind_2_set),3);
            all_E_phase_coil = zeros(ncoils,length(ind_1_set)*length(ind_2_set),3);
        end
        if s_opts.save_bfields_ult_flag,
            all_B_phase = zeros(numbasis,length(ind_1_set)*length(ind_2_set),3);
        end
        if s_opts.compute_coilSAR_pTx_flag && s_opts.save_bfields_coil_flag,
            all_B_phase_modes = zeros(((lmax + 1)^2 - 1),length(ind_1_set)*length(ind_2_set),3);
            all_B_phase_coil = zeros(ncoils,length(ind_1_set)*length(ind_2_set),3);
        end
        
        for l = 1:lmax, % for l=0 the T matrix is empty and there would be no contributions 
            %             disp(['      l = ' num2str(l)])
            lnorm = sqrt(l*(l+1));
            legendrenorm = sqrt((2*l + 1)/(4*pi));
            legendrenorm_minus1 = sqrt((2*l - 1)/(4*pi));
            legendrefunctions = legendre(l,costhetaset,'sch'); % # row is m = 0,...l ; # col is R
            if l>0,
                legendrefunctions_lminus1 = legendre(l-1,costhetaset,'sch');
                legendrefunctions_lminus1 = [legendrefunctions_lminus1; zeros(size(costhetaset))];
            end

            % -- these two are for rho = sphere radius --
%             H_l_1_k_0_rad_a = besselnorm_rad_a*besselh(l+0.5,1,k_0_rad_a);
%             H_l_1_k_0_rad_a_prime = -k_0_rad_a*besselnorm_rad_a*besselh(l+1+0.5,1,k_0_rad_a) + (l + 1)*H_l_1_k_0_rad_a;
            % -----------------------------
          
            H_l_1_k_0_rad_b = besselnorm_rad_b*besselh(l+0.5,1,k_0_rad_b);
            H_l_1_k_0_rad_b_prime = -k_0_rad_b*besselnorm_rad_b*besselh(l+1+0.5,1,k_0_rad_b) + (l + 1)*H_l_1_k_0_rad_b;
%             disp(['    Correct = ' num2str(H_l_1_k_0_rad_b_prime)]);
%             H_l_1_k_0_rad_b_prime_wrong = -k_0_rad_b*besselnorm_rad_a*besselh(l+1+0.5,1,k_0_rad_b) + (l + 1)*H_l_1_k_0_rad_b;
%             disp(['    Wrong = ' num2str(H_l_1_k_0_rad_b_prime_wrong)]);
%             disp(['ERROR (%) = ' num2str(100*abs(H_l_1_k_0_rad_b_prime)/abs(H_l_1_k_0_rad_b_prime_wrong))]);
%             disp('-------')
            
            J_l_kr_s = besselnorm.*besselj(l+0.5,krset_s);
            J_l_kr_s(rset<eps) = (l==0);                            %** only j_0 survives at r=0
            J_lplus1_kr_s = besselnorm.*besselj(l+1+0.5,krset_s);
            J_lplus1_kr_s(rset<eps) = 0;                           %** j_l+1 vanishes at r=0 for l>=0
            J_l_kr_s_prime = -krset_s.*J_lplus1_kr_s + (l + 1)*J_l_kr_s;
            
%             [a_l, b_l, c_l, d_l] = compute_T_coefficients_sphere(l,k_0,k_s,sphereradius);
            
%             % T matrix does not depend on the expansion parameter m
%             T = -1i*sqrt(l*(l+1))*([H_l_1_k_0_rad_b*c_l                     0
%                                         0                 (1/k_0_rad_b)*H_l_1_k_0_rad_b_prime*d_l].');
    
            [R_H_P_1, R_H_F_1, R_V_P_1, R_V_F_1, T_H_P_1, T_H_F_1, T_V_P_1, T_V_F_1] = ...
                compute_reflection_and_transmission_coef(l,k_0,k_2,g_opts.radius1);
            
            [R_H_P_2, R_H_F_2, R_V_P_2, R_V_F_2, T_H_P_2, T_H_F_2, T_V_P_2, T_V_F_2] = ...
                compute_reflection_and_transmission_coef(l,k_2,k_3,g_opts.radius2);
            
            [R_H_P_3, R_H_F_3, R_V_P_3, R_V_F_3, T_H_P_3, T_H_F_3, T_V_P_3, T_V_F_3] = ...
                compute_reflection_and_transmission_coef(l,k_3,k_s,sphereradius);
            
            B_m_11 = -( T_H_P_2*(T_H_P_1*R_H_F_1 + T_H_F_1*R_H_F_2) + R_H_F_3*T_H_F_2*(T_H_F_1 + T_H_P_1*R_H_P_2*R_H_F_1) )/...
                ( T_H_P_2*(T_H_P_1 + T_H_F_1*R_H_F_2*R_H_P_1) + R_H_F_3*T_H_F_2*(T_H_P_1*R_H_P_2 + T_H_F_1*R_H_P_1) );
            
            
            B_n_11 = -( T_V_P_2*(T_V_P_1*R_V_F_1 + T_V_F_1*R_V_F_2) + R_V_F_3*T_V_F_2*(T_V_F_1 + T_V_P_1*R_V_P_2*R_V_F_1) )/...
                ( T_V_P_2*(T_V_P_1 + T_V_F_1*R_V_F_2*R_V_P_1) + R_V_F_3*T_V_F_2*(T_V_P_1*R_V_P_2 + T_V_F_1*R_V_P_1) );
            
            B_m_21 = (1/T_H_F_1)*(B_m_11 + R_H_F_1);
            
            B_n_21 = (1/T_V_F_1)*(B_n_11 + R_V_F_1);
            
            D_m_21 = (1/T_H_P_1)*(1+ R_H_P_1*B_m_11);
            
            D_n_21 = (1/T_V_P_1)*(1+ R_V_P_1*B_n_11);
            
            B_m_31 = (1/T_H_F_2)*(B_m_21 + R_H_F_2*D_m_21);
            
            B_n_31 = (1/T_V_F_2)*(B_n_21 + R_V_F_2*D_n_21);
            
            D_m_31 = (1/T_H_P_2)*(R_H_P_2*B_m_21 + D_m_21);
            
            D_n_31 = (1/T_V_P_2)*(R_V_P_2*B_n_21 + D_n_21);
            
            D_m_41 = (1/T_H_P_3)*(R_H_P_3*B_m_31 + D_m_31);
            
            D_n_41 = (1/T_V_P_3)*(R_V_P_3*B_n_31 + D_n_31);
            
%             [D_m_41, D_n_41]
            
            
            % T matrix does not depend on the expansion parameter m
            Ttemp = [H_l_1_k_0_rad_b*D_m_41                     0
                0                 (1/k_0_rad_b)*H_l_1_k_0_rad_b_prime*D_n_41].';

            for m = -l:l,
                
                T = ((-1)^(1-m))*Ttemp;
                
                lmul = sqrt((2*l + 1)*(l^2 - m^2)/(2*l - 1));
                
                if m > 0
                    Y_l_m = ((-1)^m)*legendrenorm*(1/sqrt(2))*legendrefunctions((m+1),:).*exp(1i*m*phiset);
                elseif m == 0
                    Y_l_m = legendrenorm*legendrefunctions(1,:);
                else % using Y_(l,-m) = (-1)^m*conj[Y_(l,m)]
                    Y_l_m = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm*(1/sqrt(2))*legendrefunctions((abs(m)+1),:).*exp(i*abs(m)*phiset));
                end
                S_E = zeros(size(Y_l_m));
                S_M = S_E;
                if m > 0
                    Y_lminus1_m = ((-1)^m)*legendrenorm_minus1*(1/sqrt(2))*legendrefunctions_lminus1(m+1,:).*exp(i*m*phiset);
                elseif m == 0
                    Y_lminus1_m = legendrenorm_minus1*legendrefunctions_lminus1(1,:);
                else
                    Y_lminus1_m = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm_minus1*(1/sqrt(2))*legendrefunctions_lminus1((abs(m)+1),:).*exp(i*abs(m)*phiset));
                end
                
                X_x = (1/lnorm).*((-m*cosphiset+1i*l*sinphiset).*cotthetaset.*Y_l_m ...
                    - 1i*lmul*cscthetaset.*sinphiset.*Y_lminus1_m);
                X_y = (1/lnorm).*((-m*sinphiset-1i*l*cosphiset).*cotthetaset.*Y_l_m ...
                    + 1i*lmul*cscthetaset.*cosphiset.*Y_lminus1_m);
                X_z = (1/lnorm).*m.*Y_l_m;

                r_cross_X_x = (1/lnorm).*((m*sinphiset+1i*l*cos2thetaset.*cosphiset).*cscthetaset.*Y_l_m ...
                    - 1i*lmul*cotthetaset.*cosphiset.*Y_lminus1_m);
                r_cross_X_y = (1/lnorm).*((-m*cosphiset+1i*l*cos2thetaset.*sinphiset).*cscthetaset.*Y_l_m ...
                    - 1i*lmul*cotthetaset.*sinphiset.*Y_lminus1_m);
                r_cross_X_z = (-1i/lnorm).*(l*costhetaset.*Y_l_m ...
                    - lmul.*Y_lminus1_m);

                % create sensitivity matrices using B+ transmit fields
                S_E = -1i*mu*k_s*k_0*currentradius*currentradius*(J_l_kr_s.*(X_x - 1i*X_y));
                
                S_M = -1i*mu*k_s*k_0*currentradius*currentradius*((1./krset_s).*J_l_kr_s_prime.*(r_cross_X_x - 1i*r_cross_X_y)...
                    + 1i*(lnorm./krset_s).*J_l_kr_s.*Y_l_m.*(rhat_x - 1i*rhat_y));

                smallr = rset < eps;
                S_E(smallr) = 0;
                if l == 1,
                    switch m
                        case -1
                            S_M(smallr) = -1i*mu*k_s*k_0*currentradius*currentradius*(1/3)*sqrt(3/(2*pi));
                        case 0
                            S_M(smallr) = 0;
                        case 1
                            S_M(smallr) = 1i*mu*k_s*k_0*currentradius*currentradius*(1/3)*sqrt(3/(2*pi));
                    end
                else
                    S_M(smallr) = 0;   %** C_M vanishes at r=0 for l~=1 and abs(m)~=1
                end
                S = [S_M ; S_E];
                
                T_hat = T;
                if whichcurrents == 1,
                    T_hat = [1 0]*T;
                end
                if whichcurrents == 2,
                    T_hat = [0 1]*T;
                end
                % ------------ %
                % form X = T*S
                X = T_hat*S;
                
                if save_efields_flag || save_bfields_flag,
                    %@@@@@@ check smallr  @@@@@
                    %@@@@@@@@@@@@@@@@@@@@@@@@@@

                    M_x = J_l_kr_s.*X_x;
                    M_y = J_l_kr_s.*X_y;
                    M_z = J_l_kr_s.*X_z;

                    N_x = (1./krset_s).*J_l_kr_s_prime.*r_cross_X_x + 1i*(lnorm./krset_s).*J_l_kr_s.*Y_l_m.*rhat_x;
                    N_y = (1./krset_s).*J_l_kr_s_prime.*r_cross_X_y + 1i*(lnorm./krset_s).*J_l_kr_s.*Y_l_m.*rhat_y;
                    N_z = (1./krset_s).*J_l_kr_s_prime.*r_cross_X_z + 1i*(lnorm./krset_s).*J_l_kr_s.*Y_l_m.*rhat_z;
                    
                    if save_efields_flag
                        % Create electric field components
                        E_x = ele_scaling*(T_hat*[M_x; N_x]);
                        E_y = ele_scaling*(T_hat*[M_y; N_y]);
                        E_z = ele_scaling*(T_hat*[M_z; N_z]);
                        
                        all_E_phase(counter:counter+counterincrement,:,:) = reshape([E_x E_y E_z],[(counterincrement+1) size(xset,2) 3]);
                    end

                    if save_bfields_flag
                        % Create magnetic field components
                        B_x = mag_scaling*(T_hat*[N_x; M_x]);
                        B_y = mag_scaling*(T_hat*[N_y; M_y]);
                        B_z = mag_scaling*(T_hat*[N_z; M_z]);
                        
                        all_B_phase(counter:counter+counterincrement,:,:) = reshape([B_x B_y B_z],[(counterincrement+1) size(xset,2) 3]);
                    end

                end
                
                % ------------------------------------------------------------- %
                % form noise correlation submatrix P (2 x 2 array for each l,m)
                
                % -- body losses component P_L
%                 P_L = (sigma/2)*(abs(omega*mu/k_s)^2)*...
%                     [ computePsiM(l, k_s, sphereradius)              0
%                     0               computePsiE(l, k_s, sphereradius)];
                P_L = (sigma/2)*(abs(omega*mu*k_0*currentradius*currentradius)^2)*...
                    [ computePsiM(l, k_s, sphereradius)              0
                    0               computePsiE(l, k_s, sphereradius)];


                P = T_hat*P_L*T_hat';
                                
                % -- conductor losses component P_A
                if s_opts.compute_rf_power_requirements
                    P_A = (currentradius^2)/(2*sigma_coil*d_coil)*eye(2);
                    P_A_hat = P_A;
                    if whichcurrents == 1,
                        P_A_hat = P_A(1,1);
                    end
                    if whichcurrents == 2,
                        P_A_hat = P_A(2,2);
                    end
                end
                
                % ------------------------------------------------------- %
                X_P = X.'*inv(P.');
                % add X_P and X submatrices to full X_P_full and X_full matrices
                X_P_full(:,counter:counter+counterincrement) = X_P;
                X_full(counter:counter+counterincrement,:) = conj(X); % NB: if whichcurrents = [1 2], then X has the contributions of both the electric and magnetic dipole
                
                if s_opts.compute_coilSAR_pTx_flag,
                    % Save quantities which will be needed for computing loop coil SNR
                    if whichcurrents == 1,
                        X_modes(counter_modes,:) = X;
%                         P_modes(counter_modes) = P;
                        P_modes(counter_modes) = T_hat*P_L*T_hat'; % RL May 7, 2013
                        if s_opts.compute_rf_power_requirements
                            P_req_modes(counter_modes) = P_modes(counter_modes) + P_A_hat;
                        end
                        if s_opts.save_efields_coil_flag,
                            all_E_phase_modes(counter_modes,:,:) = all_E_phase(counter_modes,:,:);
                        end
                        if s_opts.save_bfields_coil_flag,
                            all_B_phase_modes(counter_modes,:,:) = all_B_phase(counter_modes,:,:);
                        end
                    else
                        T_hat = [1 0]*T;
                        X = T_hat*S;
                        X_modes(counter_modes,:) = X;
                        P = T_hat*P_L*T_hat';
                        P_modes(counter_modes)= P;
                        if s_opts.compute_rf_power_requirements
                            P_req_modes(counter_modes) = P_modes(counter_modes) + P_A(1,1);
                        end
                        if s_opts.save_efields_coil_flag,
                            E_x = ele_scaling*(T_hat*[M_x; N_x]);
                            E_y = ele_scaling*(T_hat*[M_y; N_y]);
                            E_z = ele_scaling*(T_hat*[M_z; N_z]);
                            
                            all_E_phase_modes(counter_modes,:,:) = reshape([E_x E_y E_z],[1 size(xset,2) 3]);
                        end
                        if s_opts.save_bfields_coil_flag,
                            B_x = mag_scaling*(T_hat*[N_x; M_x]);
                            B_y = mag_scaling*(T_hat*[N_y; M_y]);
                            B_z = mag_scaling*(T_hat*[N_z; M_z]);
                            
                            all_B_phase_modes(counter_modes,:,:) = reshape([B_x B_y B_z],[1 size(xset,2) 3]);
                        end
                        
                    end
                end
                counter = counter + 1 + counterincrement;
                counter_modes = counter_modes + 1;
            end
            %^end m loop
        end
        %^end l loop
        
        if s_opts.save_efields_ult_flag,
            % Update the matrix with the modes' electric fields (3 components) at each position
            efield_ult_set(:,ind_1_set,ind_2_set,:) = reshape(all_E_phase,[numbasis length(ind_1_set) length(ind_2_set) 3]);
        end
        if s_opts.save_bfields_ult_flag,
            % Update the matrix with the modes' electric fields (3 components) at each position
            bfield_ult_set(:,ind_1_set,ind_2_set,:) = reshape(all_B_phase,[numbasis length(ind_1_set) length(ind_2_set) 3]);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Ultimate intrinsic SAR
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % calculate encoding matrix product
        XPX = X_P_full*X_full;
        %**ADD TEST FOR NANS**
        XPX_inv = inv(XPX);
        % ---------------------------------------------- %
        
        % Calculate minimum SAR excitation pattern. Each f is a [modes] x [1] vector
        f_map(:,ind_1,ind_2) =  (X_P_full')*XPX_inv*mu_profile_set;

        % calculate SAR for accelerated case
        sar_contribution = ((mu_profile_set')*XPX_inv*mu_profile_set); % this is always 1x1
        sar_ult_ptx(ind_1_set,ind_2_set) = sar_contribution*ones([length(ind_1_set) length(ind_2_set)]); % copy at all correspondent locations

        sar_pulses(ind_1,ind_2) = sar_contribution;
                
        % ------------------------------------------------ %
        % calculate SAR for unaccelerated case
        sar_contribution_unaccel = ((mu_profile_set')*(eye(size(XPX)).*repmat(1./diag(XPX),[1 size(XPX,2)]))*mu_profile_set);
        g_ult_ptx(ind_1_set,ind_2_set) = (sar_contribution./sar_contribution_unaccel)*ones([length(ind_1_set) length(ind_2_set)]);
        % ------------------------------------------------ %
        % Calculate actual (achieved) profile
        %         actual_profile_partx_ult(ind_1_set,ind_2_set) = (X_full')*(X_P_full')*XPX_inv*mu_profile_set;
        actual_profile_ptx_ult(ind_1_set,ind_2_set) = reshape((X_full')*(X_P_full')*XPX_inv*mu_profile_set,[length(ind_1_set) length(ind_2_set)]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Circular surface coil array SNR
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if s_opts.compute_coilSAR_pTx_flag
            % initialize quantities
            S_coil = zeros(ncoils,length(ind_1_set)*length(ind_2_set));
            psi_coil = zeros(ncoils);
            if s_opts.compute_rf_power_requirements
                psi_coil_powreq = zeros(ncoils);
            end
            W_coil = zeros([((lmax + 1)^2 - 1) ncoils]);
            
            % define quantities constant for all coils
            costheta_coil_z = coil_offsets(1)/currentradius;
            theta_coil_z = acos(costheta_coil_z);
            %             W_coil_z_norm = (-i*2*pi*coil_radii(1)/(outer_radius^2));
%             W_coil_z_norm = -2*pi*coil_radii(1);
            % NB: for W_coil_z_norm and costheta_coil_z we assume all coils have the same radius,
            % otherwise coil_radii(1) and coil_offsets(1) must be replaced with the radius and
            % the offset of the coil along the z-axis
            
            W_coil_z = zeros(lmax, 1);

            for icoil = 1:ncoils,
                % Compute current weights
                theta_coil_i = rot_coil(icoil,1);
                phi_coil_i = rot_coil(icoil,2);
                costheta_coil_i = cos(theta_coil_i);  %+ coil_offsets(icoil)/outer_radius; 
                
                W_coil_i = zeros([((lmax + 1)^2 - 1) 1]);
                counter_coil_i = 1;
                for l = 1:lmax,
                    
                    W_coil_z_norm = 1i*2*pi*sqrt(l/(l+1))/currentradius; % RL 9/9/2013
                    
                    if icoil == 1,
                        %**-- calculate the weights for the coil along the z-axis --**
                        legendrefunctions_z = legendre(l,costheta_coil_z,'sch'); % # row is m = 0,...l ; # col is R
                        legendrefunctions_lminus1_z = legendre(l-1,costheta_coil_z,'sch');
                        legendrefunctions_lminus1_z = [legendrefunctions_lminus1_z; zeros(size(costheta_coil_z))];
                        % spherical harmonics with m = 0
                        Y_l_0_z = sqrt((2*l + 1)/(4*pi))*legendrefunctions_z(1,:);
                        Y_lminus1_0_z = sqrt((2*l - 1)/(4*pi))*legendrefunctions_lminus1_z(1,:);

%                         W_coil_z(l) = W_coil_z_norm*(1/(l+1))*(Y_l_0_z*cot(theta_coil_z) - Y_lminus1_0_z*csc(theta_coil_z)*sqrt((2*l + 1)/(2*l - 1)));
                        W_coil_z(l) = W_coil_z_norm*(Y_l_0_z*costheta_coil_z - Y_lminus1_0_z*sqrt((2*l + 1)/(2*l - 1))); % RL 9/9/2013
                        %**----**
                    end
                    rot_coil_norm_i = sqrt(4*pi/(2*l + 1));
                    legendrenorm_i = sqrt((2*l + 1)/(4*pi));
                    legendrefunctions_i = legendre(l,costheta_coil_i,'sch'); % # row is m = 0,...l ; # col is R
                    legendrefunctions_lminus1_i = legendre(l-1,costheta_coil_i,'sch');
                    legendrefunctions_lminus1_i = [legendrefunctions_lminus1_i; zeros(size(costheta_coil_i))];
                    for m = -l:l,
                        if m > 0
                            Y_l_m_i = ((-1)^m)*legendrenorm_i*(1/sqrt(2))*legendrefunctions_i((m+1),:).*exp(1i*m*phi_coil_i);
                        elseif m == 0
                            Y_l_m_i = legendrenorm_i*legendrefunctions_i(1,:);
                        else % using Y_(l,-m) = (-1)^m*conj[Y_(l,m)]
                            Y_l_m_i = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm_i*(1/sqrt(2))*legendrefunctions_i((abs(m)+1),:).*exp(1i*abs(m)*phi_coil_i));
                        end

                        W_coil_i(counter_coil_i) = rot_coil_norm_i*conj(Y_l_m_i)*W_coil_z(l);
%                         W_coil_i(counter_coil_i) = ((-1)^m)*rot_coil_norm_i*conj(Y_l_m_i)*W_coil_z(l); % TEST

                        W_coil(counter_coil_i,icoil) = W_coil_i(counter_coil_i);
                        counter_coil_i = counter_coil_i + 1;
                    end % end m loop
                end % end l loop
                
                W_coil_i_bis = zeros(size(W_coil_i));
                for ll = 1:lmax
                    startindex = (ll^2 - 1) + 1;
                    endindex = ((ll+1)^2 - 1);
                    %                 disp(['l = ' num2str(ll) ', start: ' num2str(startindex) ', end: ' num2str(endindex)]);
                    for mm = -ll:ll
                        if mm < 0
                            index2 = endindex - (ll-abs(mm));
                            oldidx1 = startindex + abs(abs(mm)-ll);
                            %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index2)])
                            W_coil_i_bis(index2) = W_coil_i(oldidx1);
                        elseif mm > 0
                            index1 = startindex + abs(mm-ll);
                            oldidx2 = endindex - (ll-abs(mm));
                            %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1)])
                            W_coil_i_bis(index1) = W_coil_i(oldidx2);
                        elseif mm == 0
                            index1 = startindex + ll;
                            %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1)])
                            W_coil_i_bis(index1) = W_coil_i(index1);
                        end
                    end
                end
                W_coil_i = W_coil_i_bis;
                
                
                W_coil_i = W_coil_i(:);
                %                 psi_coil(icoil,icoil) = real((abs(W_coil_i.').^2)*P_modes); % check size . should be psi_coil(1,icoil)
                psi_coil(icoil,icoil) = real(W_coil_i.'*(P_modes.*conj(W_coil_i))); % check size . should be psi_coil(1,icoil)
                if s_opts.compute_rf_power_requirements
                    psi_coil_powreq(icoil,icoil) = real(W_coil_i.'*(P_req_modes.*conj(W_coil_i)));
                end
                
                S_coil(icoil,:) = W_coil_i.'*X_modes;
                %                 all_coil_sens(ind_1,ind_2) = S_coil; % TEMP for revision
                
                if s_opts.save_efields_coil_flag || s_opts.compute_localSAR_flag
                    
                    for ialiased = 1:length(ind_1_set)*length(ind_2_set)
                        temp_field = (W_coil_i.')*squeeze(all_E_phase_modes(:,ialiased,:));
                        all_E_phase_coil(icoil,ialiased,:) = temp_field;
                    end
                    efield_coil_set(icoil,ind_1_set,ind_2_set,:) = reshape(all_E_phase_coil(icoil,:,:),[1 length(ind_1_set) length(ind_2_set) 3]);
                end
                
                if s_opts.save_bfields_coil_flag,
                    
                    for jaliased = 1:length(ind_1_set)*length(ind_2_set)
                        temp_field = (W_coil_i.')*squeeze(all_B_phase_modes(:,jaliased,:));
                        all_B_phase_coil(icoil,jaliased,:) = temp_field;
                    end
                    bfield_coil_set(icoil,ind_1_set,ind_2_set,:) = reshape(all_B_phase_coil(icoil,:,:),[1 length(ind_1_set) length(ind_2_set) 3]);
                end
                
                for jcoil = icoil+1:ncoils,
                    
                    theta_coil_j = rot_coil(jcoil,1);
                    phi_coil_j = rot_coil(jcoil,2);
                    costheta_coil_j = cos(theta_coil_j); % coil_offsets(jcoil)/outer_radius;
                    
                    W_coil_j = zeros([((lmax + 1)^2 - 1) 1]);
                    counter_coil_j = 1;
                    for l = 1:lmax
                        rot_coil_norm_j = sqrt(4*pi/(2*l + 1));
                        legendrenorm_j = sqrt((2*l + 1)/(4*pi));
                        legendrefunctions_j = legendre(l,costheta_coil_j,'sch'); % # row is m = 0,...l ; # col is R
                        legendrefunctions_lminus1_j = legendre(l-1,costheta_coil_j,'sch');
                        legendrefunctions_lminus1_j = [legendrefunctions_lminus1_j; zeros(size(costheta_coil_j))];
                        for m = -l:l,
                            if m > 0
                                Y_l_m_j = ((-1)^m)*legendrenorm_j*(1/sqrt(2))*legendrefunctions_j((m+1),:).*exp(i*m*phi_coil_j);
                            elseif m == 0
                                Y_l_m_j = legendrenorm_j*legendrefunctions_j(1,:);
                            else % using Y_(l,-m) = (-1)^m*conj[Y_(l,m)]
                                Y_l_m_j = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm_j*(1/sqrt(2))*legendrefunctions_j((abs(m)+1),:).*exp(i*abs(m)*phi_coil_j));
                            end
                            W_coil_j(counter_coil_j) = rot_coil_norm_j*conj(Y_l_m_j)*W_coil_z(l);
%                             W_coil_j(counter_coil_j) = ((-1)^m)*rot_coil_norm_j*conj(Y_l_m_j)*W_coil_z(l); % TEST
                            counter_coil_j = counter_coil_j + 1;
                        end % end m loop
                    end % end l loop
                    
                    W_coil_j_bis = zeros(size(W_coil_j));
                    for ll = 1:lmax
                        startindex = (ll^2 - 1) + 1;
                        endindex = ((ll+1)^2 - 1);
                        %                 disp(['l = ' num2str(ll) ', start: ' num2str(startindex) ', end: ' num2str(endindex)]);
                        for mm = -ll:ll
                            if mm < 0
                                index2 = endindex - (ll-abs(mm));
                                oldidx1 = startindex + abs(abs(mm)-ll);
                                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index2)])
                                W_coil_j_bis(index2) = W_coil_j(oldidx1);
                            elseif mm > 0
                                index1 = startindex + abs(mm-ll);
                                oldidx2 = endindex - (ll-abs(mm));
                                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1)])
                                W_coil_j_bis(index1) = W_coil_j(oldidx2);
                            elseif mm == 0
                                index1 = startindex + ll;
                                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1)])
                                W_coil_j_bis(index1) = W_coil_j(index1);
                            end
                        end
                    end
                    W_coil_j = W_coil_j_bis;
                    
                    W_coil_j = W_coil_j(:);
                    psi_coil(icoil,jcoil) = W_coil_i.'*(P_modes.*conj(W_coil_j));
                    psi_coil(jcoil,icoil) = conj(psi_coil(icoil,jcoil));
                    
                    if s_opts.compute_rf_power_requirements
                        psi_coil_powreq(icoil,jcoil) = W_coil_i.'*(P_req_modes.*conj(W_coil_j));
                        psi_coil_powreq(jcoil,icoil) = conj(psi_coil_powreq(icoil,jcoil));
                    end
                    
                end % end jcoil loop
            end % end icoil loop
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Calculate encoding matrix product
            SpsiS_coil = S_coil'*inv(psi_coil)*S_coil;
            if s_opts.compute_rf_power_requirements
                SpsiS_coil_powreq = S_coil'*inv(psi_coil_powreq)*S_coil;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Accelerated case
            if s_opts.include_psi_coil
                
                % Calculate minimum SAR excitation pattern. Each f is a [ncoils] x [1] vector
%                 f_map_coil(:,ind_1,ind_2) =  (inv(psi_coil)*S_coil')*inv(SpsiS_coil)*mu_profile_set;
                f_map_coil(:,ind_1,ind_2) =  (inv(psi_coil)*S_coil)*inv(SpsiS_coil)*mu_profile_set;
                sar_contribution_coil = ((mu_profile_set')*inv(SpsiS_coil)*mu_profile_set); % this is always 1x1
            else
%                 f_map_coil(:,ind_1,ind_2) =  (inv(psi_coil)*S_coil')*( pinv(S_coil)*psi_coil*(pinv(S_coil)'))*mu_profile_set;
                f_map_coil(:,ind_1,ind_2) =  (inv(psi_coil)*S_coil)*( pinv(S_coil)*psi_coil*(pinv(S_coil)'))*mu_profile_set;
                sar_contribution_coil = ((mu_profile_set')*( pinv(S_coil)*psi_coil*(pinv(S_coil)'))*mu_profile_set); % this is always 1x1
            end
            
            sar_coil_ptx(ind_1_set,ind_2_set) = sar_contribution_coil*ones([length(ind_1_set) length(ind_2_set)]); % copy at all correspondent locations
            
            sar_pulses_coil(ind_1,ind_2) = sar_contribution_coil;
            if s_opts.compute_rf_power_requirements
                sar_pulses_powreq_coil(ind_1,ind_2) = ((mu_profile_set')*inv(SpsiS_coil_powreq)*mu_profile_set);
            end
            
            % calculate SAR for unaccelerated case
            if s_opts.include_psi_coil
                sar_contribution_unaccel_coil = ((mu_profile_set')*(eye(size(SpsiS_coil)).*repmat(1./diag(SpsiS_coil),[1 size(SpsiS_coil,2)]))*mu_profile_set);
            else
                sar_contribution_unaccel_coil = ((mu_profile_set')*(eye(size(SpsiS_coil)).*repmat(1./diag(pinv(S_coil)*psi_coil*(pinv(S_coil)')),[1 size(SpsiS_coil,2)]))*mu_profile_set);
            end
            g_coil_ptx(ind_1_set,ind_2_set) = (sar_contribution_coil./sar_contribution_unaccel_coil)*ones([length(ind_1_set) length(ind_2_set)]);
            % ------------------------------------------------ %
            % Calculate actual (achieved) profile
%             actual_profile_ptx_coil(ind_1_set,ind_2_set) = reshape((S_coil*inv(psi_coil)*S_coil')*inv(SpsiS_coil)*mu_profile_set,[length(ind_1_set) length(ind_2_set)]);
            actual_profile_ptx_coil(ind_1_set,ind_2_set) = reshape(((S_coil')*inv(psi_coil)*S_coil)*inv(SpsiS_coil)*mu_profile_set,[length(ind_1_set) length(ind_2_set)]);

        end
    end % end loop indices in phase direction
end % end loop indices in frequency direction

% Each k space position can be mapped to a time instant
total_pulses = (nf/acceleration(1)*np/acceleration(2));

sar_global_ult = (1/total_pulses)*sum(sar_pulses(:)); % This SAR is a single value for the entire excitation
disp('****------------------****');
disp(['Ult Int SAR = ' sprintf('%0.2f',abs(sar_global_ult))]);
disp('****------------------****');

if s_opts.compute_coilSAR_pTx_flag
    sar_global_coil = (1/total_pulses)*sum(sar_pulses_coil(:));
    disp('****------------------****');
    disp(['Minimum Coil SAR = ' sprintf('%0.2f',abs(sar_global_coil))]);
    if s_opts.compute_rf_power_requirements
        power_req_coil = (1/total_pulses)*sum(sar_pulses_powreq_coil(:));
        disp(['     Coil RF Power Requirements = ' sprintf('%0.2f',abs(power_req_coil))]);
    end
    disp('****------------------****');
end

if s_opts.compute_localSAR_flag,
    localsar_sequence = zeros(nf,np,total_pulses); % This is RF power deposited at each pixel position during each pulse
    % assuming EPI the first k-space point is the lower left corner
    peak_sar = 0; % peak SAR during the excitation
    sar_ave = 0; % This is SAR computed averaging localsar_sequence along all pixels and all pulses
    if s_opts.compute_coilSAR_pTx_flag
        peak_sar_coil = 0;
        sar_ave_coil = 0;
        localsar_sequence_coil = zeros(nf,np,total_pulses);
    else
        peak_sar_coil = NaN;
        sar_ave_coil = NaN;
        localsar_sequence_coil = [];
    end
else
    localsar_sequence = [];
    peak_sar = NaN;
    sar_ave = NaN;
    peak_sar_coil = NaN;
    sar_ave_coil = NaN;
    localsar_sequence_coil = [];
end

if s_opts.compute_localSAR_flag || s_opts.save_ult_current_weights_flag || s_opts.compute_ult_current_pattern_flag,
    
    % For each mode I compute the spatial weightings at every K-space
    % position as the inverse Fourier transform of its excitation patterns.
    W_k = zeros(size(f_map)); % [modes]x[freq]x[phase/R]
    for iweight = 1:size(W_k,1)
        W_k(iweight,:,:) = MRifft(squeeze(f_map(iweight,:,:)),[1 2]);
    end
    
    % *** NB: need to change m with -m to calculate the weights *****
    W_k_bis = zeros(size(W_k));
    
    for ll = 1:lmax
        startindex = 2*(ll^2 - 1) + 1;
        endindex = 2*((ll+1)^2 - 1);
        %                 disp(['l = ' num2str(ll) ', start: ' num2str(startindex) ', end: ' num2str(endindex)]);
        for mm = -ll:ll
            if mm < 0
                index2 = endindex - 2*(ll-abs(mm));
                index1 = index2 - 1;
                oldidx1 = startindex + 2*abs(abs(mm)-ll);
                oldidx2 = 1 + startindex + 2*abs(abs(mm)-ll);
                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1) ' and ' num2str(index2)])
                W_k_bis(index1:index2,:,:) = W_k(oldidx1:oldidx2,:,:);
            elseif mm > 0
                index1 = startindex + 2*abs(mm-ll);
                index2 = index1 + 1;
                oldidx1 = endindex - 2*(ll-abs(mm)) - 1;
                oldidx2 = endindex - 2*(ll-abs(mm));
                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1) ' and ' num2str(index2)])
                W_k_bis(index1:index2,:,:) = W_k(oldidx1:oldidx2,:,:);
            elseif mm == 0
                index1 = startindex + ll*2;
                index2 = index1 + 1;
                %                         disp(['    m = ' num2str(mm) ', index = ' num2str(index1) ' and ' num2str(index2)])
                W_k_bis(index1:index2,:,:) = W_k(index1:index2,:,:);
            end
        end
    end
    W_k = W_k_bis;
    % *** ****************************************************** *****
    
    if s_opts.save_ult_current_weights_flag
        weights = reshape(W_k,[((lmax+1)^2 - 1) length(whichcurrents) size(W_k,2) size(W_k,3)]);
    else
        weights = [];
    end
    clear f_map
    
    
    % -- circular surface coil --
    if s_opts.compute_coilSAR_pTx_flag
        W_k_coil = zeros(size(f_map_coil)); % [ncoils]x[freq/acc(1)]x[phase/acc(2)]
        for iweight_coil = 1:size(W_k_coil,1)
            W_k_coil(iweight_coil,:,:) = MRifft(squeeze(f_map_coil(iweight_coil,:,:)),[1 2]);
        end
        if s_opts.save_coil_current_weights_flag,
            weights_coil = W_k_coil;
        else
            weights_coil = [];
        end

        clear f_map_coil
    end
    % -------------------------------
    
    true_nf = floor(nf/acceleration(1));
    true_np = floor(np/acceleration(2)); % CHECK
    
    for itime = 1:total_pulses
        
        if rem(itime,true_nf) == 0 % end of a column
            if rem(ceil(itime/true_nf),2) == 1 % odd column
                ifreq = true_nf;
                iphase = itime/true_nf;
            else
                ifreq = 1;
                iphase = itime/true_nf;
            end
        else
            if rem(ceil(itime/true_nf),2) == 1 % odd column
                ifreq = rem(itime,true_nf);
                iphase = ceil(itime/true_nf);
            else
                ifreq = true_nf - rem(itime,true_nf) + 1;
                iphase = ceil(itime/true_nf);
            end
        end
        
        if s_opts.compute_localSAR_flag,
            
            disp([  '(K_x,K_y) = (',num2str(ifreq),',',num2str(iphase),')']);
            % At each position local SAR is the sum of the contributions of all modes
            
            % extract the weights for the current pulse and make a copy for
            % each pixel and for the (x,y,z) field components
            current_weights = repmat(squeeze(W_k(:,ifreq,iphase)),[1 nf np 3]);
            % sum along all modes  [net_E_field] = [3 x nf x np]
            
            net_E_field =  squeeze(sum(current_weights.*efield_ult_set,1));
            net_E_field =  reshape(net_E_field,nf*np,3);
            
            % net_E_field_select is zero outside the FOV
            mask_select = reshape(mask, 1, nf*np).';
            mask_select = repmat(mask_select,[1 3]);
            
            net_E_field = net_E_field.*(double(mask_select));
            
            % power depostion at each position of the image plane
            RF_pow = zeros(1,nf*np);
            for iRF = 1:(nf*np)
                RF_pow(1,iRF) = sigma*( net_E_field(iRF,:)*net_E_field(iRF,:)' );
            end
            sar_ave = sar_ave + sum(RF_pow(:));
            
            if max(abs(RF_pow(:))) > peak_sar
                peak_sar = max(abs(RF_pow(:)));
            end
            localsar_sequence(:,:,itime) = reshape(RF_pow,nf,np);
            
            if s_opts.compute_coilSAR_pTx_flag
                current_weights_coil = repmat(squeeze(W_k_coil(:,ifreq,iphase)),[1 nf np 3]);
                net_E_field_coil =  squeeze(sum(current_weights_coil.*efield_coil_set,1));
                net_E_field_coil =  reshape(net_E_field_coil,nf*np,3);
                net_E_field_coil = net_E_field_coil.*(double(mask_select));
                RF_pow_coil = zeros(1,nf*np);
                for iRF = 1:(nf*np)
                    RF_pow_coil(1,iRF) = sigma*( net_E_field_coil(iRF,:)*net_E_field_coil(iRF,:)' );
                end
                sar_ave_coil = sar_ave_coil + sum(RF_pow_coil(:));
                
                if max(abs(RF_pow_coil(:))) > peak_sar_coil
                    peak_sar_coil = max(abs(RF_pow_coil(:)));
                end
                localsar_sequence_coil(:,:,itime) = reshape(RF_pow_coil,nf,np);
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if s_opts.compute_ult_current_pattern_flag,
            % compute current patterns %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cptnorm = currentradius;
            test_1 = (whichvoxels(:,1) == ifreq);
            if any(test_1),
                test_2 = (whichvoxels(:,2) == iphase);
                if any(test_1 & test_2),
                    disp('    computing current patterns...')
                    currentweights = ...
                        permute(...
                        reshape(...
                        W_k(:,ifreq,iphase),...
                        [length(whichcurrents) ((lmax + 1)^2 - 1)]),...
                        [2 1]);
                    if s_opts.compute_coil_current_pattern_flag
                        currentweights_coil = W_k_coil(:,ifreq,iphase);
                    end
                    disp('**    computing current patterns...')
                    disp(['**    for (K_x,K_y) = (',num2str(ifreq),',',num2str(iphase),')']);
                    for l = 1:lmax,
                        %                                 for l = 10,
                        lnorm = sqrt(l*(l+1));
                        legendrenorm = sqrt((2*l + 1)/(4*pi));
                        legendrenorm_minus1 = sqrt((2*l - 1)/(4*pi));
                        legendrefunctions = legendre(l,cos_currenttheta,'sch'); % # row is m = 0,...l ; # col is R
                        legendrefunctions_lminus1 = zeros([(l + 1) size(cos_currenttheta)]);
                        legendrefunctions_lminus1(1:l,:,:) = legendre(l-1,cos_currenttheta,'sch');
                        %                                         legendrefunctions_lminus1 = [legendrefunctions_lminus1; zeros(size(cos_currenttheta))];
                        for m = -l:l,
                            %                                     for m = -10,
                            %                                         lmul = sqrt( (2*l + 1)*(l^2 - m^2)/(4*pi) );
                            lmul = sqrt((2*l + 1)*(l^2 - m^2)/(2*l - 1));
                            if m > 0
                                Y_l_m = ((-1)^m)*legendrenorm*(1/sqrt(2))*squeeze(legendrefunctions((m+1),:,:)).*exp(i*m*currentphi);
                            elseif m == 0
                                Y_l_m = legendrenorm*squeeze(legendrefunctions(1,:,:));
                            else % using Y_(l,-m) = (-1)^m*conj[Y_(l,m)]
                                Y_l_m = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm*(1/sqrt(2))*squeeze(legendrefunctions((abs(m)+1),:,:)).*exp(i*abs(m)*currentphi));
                            end
                            if m > 0
                                Y_lminus1_m = ((-1)^m)*legendrenorm_minus1*(1/sqrt(2))*squeeze(legendrefunctions_lminus1(m+1,:,:)).*exp(i*m*currentphi);
                            elseif m == 0
                                Y_lminus1_m = legendrenorm_minus1*squeeze(legendrefunctions_lminus1(1,:,:));
                            else
                                Y_lminus1_m = ((-1)^abs(m))*conj(((-1)^abs(m))*legendrenorm_minus1*(1/sqrt(2))*squeeze(legendrefunctions_lminus1((abs(m)+1),:,:)).*exp(i*abs(m)*currentphi));
                            end
                            % form and weight current patterns
                            cpt = zeros([size(currenttheta) 2]);
                            if s_opts.compute_coil_current_pattern_flag
                                cpt_coil = cpt;
                            end
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % ultimate intrinsic current pattern
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            %-- remove NaN at theta=0 --%
                            [smtheta_1, smtheta_2] = find(abs(currenttheta) < 0.01);
                            csc_Y_l_m = csc_currenttheta.*Y_l_m;
                            csc_Y_lminus1_m = csc_currenttheta.*Y_lminus1_m;
                            if m == -1
                                csc_Y_l_m(smtheta_1, smtheta_2) = csc_Y_l_m_series_expans(currenttheta(smtheta_1,smtheta_2),currentphi(smtheta_1,smtheta_2),l,m);
                                csc_Y_lminus1_m(smtheta_1, smtheta_2) = csc_Y_l_m_series_expans(currenttheta(smtheta_1,smtheta_2),currentphi(smtheta_1,smtheta_2),l-1,m);
                            elseif m == 1
                                csc_Y_l_m(smtheta_1, smtheta_2) = -conj(csc_Y_l_m_series_expans(currenttheta(smtheta_1,smtheta_2),currentphi(smtheta_1,smtheta_2),l,-m));
                                csc_Y_lminus1_m(smtheta_1, smtheta_2) = -conj(csc_Y_l_m_series_expans(currenttheta(smtheta_1,smtheta_2),currentphi(smtheta_1,smtheta_2),l-1,-m));
                            else
                                csc_Y_l_m(smtheta_1, smtheta_2) = 0;
                                csc_Y_lminus1_m(smtheta_1, smtheta_2) = 0;
                            end
                            %----------------------------%
                            if whichcurrents == 1,
                                cpt(:,:,1) = i*m*csc_Y_l_m;
                                cpt(:,:,2) = -l*cos_currenttheta.*csc_Y_l_m + lmul*csc_Y_lminus1_m;
                                cpt = currentweights( (l^2 -1) + (m + l + 1) )*cpt;
                            elseif whichcurrents == 2,
                                cpt(:,:,1) = l*cos_currenttheta.*csc_Y_l_m - lmul*csc_Y_lminus1_m;
                                cpt(:,:,2) = i*m*csc_Y_l_m;
                                cpt = currentweights( (l^2 -1) + (m + l + 1) )*cpt;
                            else
                                cpt(:,:,1) = i*m*csc_Y_l_m.*(currentweights((l^2 -1) + (m + l + 1),1)) + ...
                                    (l*cos_currenttheta.*csc_Y_l_m - lmul*csc_Y_lminus1_m).*currentweights((l^2 -1) + (m + l + 1),2);
                                cpt(:,:,2) = (-l*cos_currenttheta.*csc_Y_l_m + lmul*csc_Y_lminus1_m).*currentweights((l^2 -1) + (m + l + 1),1) + ...
                                    i*m*csc_Y_l_m.*currentweights((l^2 -1) + (m + l + 1),2);
                                %                                             cpt(:,:,1) = i*m*csc_currenttheta.*Y_l_m.*(currentweights((l^2 -1) + (m + l + 1),1)) + ...
                                %                                                 (l*cot_currenttheta.*Y_l_m - lmul*csc_currenttheta.*Y_lminus1_m).*currentweights((l^2 -1) + (m + l + 1),2)*outer_radius;
                                %                                             cpt(:,:,2) = (-l*cot_currenttheta.*Y_l_m + lmul*csc_currenttheta.*Y_lminus1_m).*currentweights((l^2 -1) + (m + l + 1),1) + ...
                                %                                                 i*m*csc_currenttheta.*Y_l_m.*currentweights((l^2 -1) + (m + l + 1),2)*outer_radius;
                            end
                            % normalize current densities for discrete display (i.e. multiply by cross-sectional area of normal current pattern voxel faces)
                            cpt(:,:,1) = cpt(:,:,1)*cptnorm;
                            cpt(:,:,2) = cpt(:,:,2)*cptnorm;
                            %  add weighted currents to running pattern buffer
                            currentpattern(:,:,:,find(test_1 & test_2)) = currentpattern(:,:,:,find(test_1 & test_2)) + cpt;
                            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            % circular coils current pattern
                            if s_opts.compute_coil_current_pattern_flag,
                                cpt_coil(:,:,1) = i*m*csc_Y_l_m;
                                cpt_coil(:,:,2) = -l*cos_currenttheta.*csc_Y_l_m + lmul*csc_Y_lminus1_m;
                                % normalize current densities for discrete display (i.e. multiply by cross-sectional area of normal current pattern voxel faces)
                                cpt_coil(:,:,1) = cpt_coil(:,:,1)*cptnorm;
                                cpt_coil(:,:,2) = cpt_coil(:,:,2)*cptnorm;
                                netcurrentweights_coil = W_coil((l^2 -1) + (m + l + 1),:)*currentweights_coil(:);
                                cpt_coil = netcurrentweights_coil*cpt_coil;
                                currentpattern_coil(:,:,:,find(test_1 & test_2)) = currentpattern_coil(:,:,:,find(test_1 & test_2)) + cpt_coil;
                            end
                        end % m loop
                    end % l loop
                end
            end
        end
    end % itime loop
    sar_ave = (1/total_pulses)*sar_ave;
    if s_opts.compute_coilSAR_pTx_flag
        sar_ave_coil = (1/total_pulses)*sar_ave_coil;
    end
else
    weights = [];
    weights_coil = [];
end


save(filetosave_ult, 'sar_ult_ptx', 'g_ult_ptx', 'sar_global_ult','sar_ave','peak_sar','actual_profile_ptx_ult','localsar_sequence','mask','epsilon_rel','sigma','tissue_type','sphereradius','currentradius','fieldstrength','acceleration',...
    'fovf','fovp','x_fov','y_fov','z_fov','lmax','whichcurrents','whichvoxels','whichvoxelweights','sigma_coil','weights','currentpattern','efield_ult_set','bfield_ult_set','mu_profile');

if s_opts.compute_coilSAR_pTx_flag
    save(filetosave_coil, 'sar_coil_ptx', 'g_coil_ptx', 'sar_global_coil','sar_ave_coil','peak_sar_coil','actual_profile_ptx_coil','localsar_sequence_coil','power_req_coil','mask','epsilon_rel','sigma','tissue_type','sphereradius','currentradius','fieldstrength','acceleration',...
        'fovf','fovp','x_fov','y_fov','z_fov','lmax','whichcurrents','whichvoxels','whichvoxelweights','sigma_coil','weights_coil','currentpattern_coil','efield_coil_set','bfield_coil_set',...
        'd_coil','ncoils','coil_rotations','coil_radii','coil_offsets','W_coil','psi_coil','mu_profile');
end

output_values = struct(...
                       'whichcurrents',whichcurrents,...
                       'fieldstrength',fieldstrength,...
                       'acceleration',acceleration,...
                       'mu_profile',mu_profile,...
                       'sar_ult_ptx',sar_ult_ptx,...
                       'g_ult_ptx',g_ult_ptx,...
                       'sar_global_ult',sar_global_ult,...
                       'sar_ave',sar_ave,...
                       'peak_sar',peak_sar,...
                       'actual_profile_ptx_ult',actual_profile_ptx_ult,...
                       'localsar_sequence',localsar_sequence,...
                       'sar_coil_ptx',sar_coil_ptx,...
                       'g_coil_ptx',g_coil_ptx,...
                       'sar_global_coil',sar_global_coil,...
                       'sar_ave_coil',sar_ave_coil,...
                       'peak_sar_coil',peak_sar_coil,...
                       'actual_profile_ptx_coil',actual_profile_ptx_coil,...
                       'localsar_sequence_coil',localsar_sequence_coil,...
                       'power_req_coil',power_req_coil,...
                       'psi_coil',psi_coil,...
                       'mask',mask,...
                       'whichvoxels',whichvoxels,...
                       'whichvoxelweights',whichvoxelweights,...
                       'weights',weights,...
                       'weights_coil',weights_coil,...
                       'currentpatternmatrixsize',currentpatternmatrixsize,...
                       'currentpattern',currentpattern,...
                       'currentpattern_coil',currentpattern_coil,...
                       'currentphi',currentphi,...
                       'currenttheta',currenttheta,...
                       'epsilon_rel',epsilon_rel,...
                       'sigma',sigma,...
                       'x_fov',x_fov,...
                       'y_fov',y_fov,...
                       'z_fov',z_fov,...
                       'efield_ult_set',efield_ult_set,...
                       'bfield_ult_set',bfield_ult_set,...
                       'efield_coil_set',efield_coil_set,...
                       'bfield_coil_set',bfield_coil_set);


disp('****------------------****');
disp('done.');
endtime = toc;
disp(['Total elapsed time = ' num2str(floor(endtime/3600)) 'h ' num2str(floor(mod(endtime,3600)/60)) 'm ' num2str(round(mod(mod(endtime,3600),60))) 's' ]);
disp('****------------------****');


% END dgf_sphere_calc_sar_ptx.m


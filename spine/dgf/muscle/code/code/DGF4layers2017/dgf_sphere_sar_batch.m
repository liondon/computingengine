% -------------------------------------------------------------------------
%   DGF_sphere_sar_batch.m
%
%   Set up ultimate SAR calculations for a spherical phantom,
%   including ideal current patterns and SAR of finite arrays
%
%   References:
%
%   Lattanzi R, Sodickson DK, Grant AK and Zhu Y, 
%   Electrodynamic constraints on homogeneity and radiofrequency power deposition in multiple coil excitations; 
%   Magnetic Resonance in Medicine, vol. 61(2), 2009, p. 315-334.
%
%   Lattanzi R, Grant AK, Polimeni JR, Ohliger MA, Wiggins GC, Wald LL and Sodickson DK,
%   Performance evaluation of a 32-element head array with respect to the ultimate intrinsic SNR; 
%   NMR in Biomedicine, vol 23(2), 2010, p. 142-151.
%
%   Lattanzi R and Sodickson DK, 
%   Ideal current patterns yielding optimal SNR and SAR in magnetic resonance imaging: computational methods and physical insights; 
%   Magnetic Resonance in Medicine, 2011, in press (available on early view).
%
% Riccardo Lattanzi
% July 17, 2013
%
% NOTES:
%  added multilayer option (SAR only inside innermost layer) 1/31/2014     
%
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
%  SET COMMONLY USED SIMULATION LOOP PARAMETERS
% -------------------------------------------------------------------------
%--- frequencies and fields ---%
% whichfrequencies = [1 32 64 96 128 192 256 300 350 400]*1e6;
whichfrequencies = [128]*1e6;
fieldstrength_set = whichfrequencies/42.576e6;
% fieldstrength_set = [7]; %[1 3 5 7 9 11];
nfields = length(fieldstrength_set);

%--- accelerations and matrix sizes ---% NB: FOR SAR ONLY [1 1] AVAILABLE AT THE MOMENT
acceleration_set = [1 1];       % list of 1 x 2 vectors containing acceleration factors in each of two dimensions
% acceleration_set = [1 4
%     2 2
%     2 3
%     3 3];                   
nacc = size(acceleration_set,1);       
matrix_size_set = [24 24]; % [nf np]
% matrix_size_set = [42 42
%     42 42
%     42 42
%     42 42];
if size(matrix_size_set) ~= size(acceleration_set)
    disp('-------------------------------------------------------');
    disp('**ERROR** size of matrix_size_set not equal to size of acceleration_set');
    disp('-------------------------------------------------------');
    keyboard
end

%--- radii and related geometrical parameters ---%
sphereradius_set = [0.084];% [m] radius of the dielectric sphere (innermost radius)
nradin = length(sphereradius_set);

% outer_radius_set = [0.0840 0.0940 0.0940];     % [m] radial distance of the coil/ultimate current density surface from the axis of the cylinder
outer_radius_set = [0.094];     % [m] radius of the surface where the coil/ultimate current density is defined (outermost radius)
nradout = length(outer_radius_set);
mask_radius = 1; % percentage(1 = 100%) of FOV (from center to surface) included when calculating voxel positions

% % EXAMPLE 1 - LAYERS (outmost to inmost): currents,air,dielectric,sphere
% % Region 3: sphereradius < radius < radius2
% radius2_set = sphereradius_set + 0.015;
% sigma3 = 0;
% epsilon_r3 = 150;
% % Region 2: radius2 < radius < radius1
% radius1_set = sphereradius_set + 0.03;
% sigma2 = 0;
% epsilon_r2 = 1;

% EXAMPLE 2 - LAYERS (outmost to inmost): currents,dielectric,air,sphere
% Region 3: sphereradius < radius < radius2
radius2_set = sphereradius_set + 0.005;
sigma3 = 0;
epsilon_r3 = 1;
% Region 2: radius2 < radius < radius1
radius1_set = sphereradius_set + 0.01;
sigma2 = 0;
epsilon_r2 = 150;

% % EXAMPLE 3 - LAYERS (outmost to inmost): currents,air,air,sphere
% % Region 3: sphereradius < radius < radius2
% radius2_set = sphereradius_set + 0.005;
% sigma3 = 0;
% epsilon_r3 = 1;
% % Region 2: radius2 < radius < radius1
% radius1_set = sphereradius_set + 0.01;
% sigma2 = 0;
% epsilon_r2 = 1;

% % EXAMPLE 4 - LAYERS (outmost to inmost): currents,dielectric,dielectric,sphere
% % Region 3: sphereradius < radius < radius2
% radius2_set = sphereradius_set + 0.015;
% sigma3 = 0;
% epsilon_r3 = 150;
% % Region 2: radius2 < radius < radius1
% radius1_set = sphereradius_set + 0.03;
% sigma2 = 0;
% epsilon_r2 = 150;

% **--** NOTE **--** NOTE **--** NOTE **--** NOTE **--** NOTE **--** NOTE **--**
%
% If outer_radius is > radius2, then it means that there is a layer of air
% (always air) also between radius2 and outer_radius
%
% **--**       **--**     **--**       **--**     **--**       **--**     **--**

%--- allowed current types ---% (1 = magnetic-dipole, 2 = electric-dipole)
% current_set =      {1   1   [1 2]};
current_set =      {[1 2]};
% current_set =      {1};

if size(current_set,2) < size(outer_radius_set,2)
    disp('-------------------------------------------------------');
    disp('**ERROR** size of current_set smaller than size of outer_radius_set');
    disp('-------------------------------------------------------');
    keyboard
end
if size(current_set,2) > size(outer_radius_set,2)
    disp('------------------------------------------------------------------------------------------------------------------------------');
    disp('**WARNING** current_set larger than outer_radius_set, only current choices between 1 and size(outer_radius_set,2) will be used');
    disp('------------------------------------------------------------------------------------------------------------------------------');
    keyboard
end

%--- SAR design variables ---%
profile_shape = 1;  % 1 -> fully homogeneous (i.e. one everywhere)
% 2 -> Gaussian curve with amplitude = 1
% 3 -> Inverse Gaussian curve with amplitude = 1
                    
%--- order of the expansion ---%
lmax = 60; % # of modes = 2(lmax + 1)^2

% -------------------------------------------------------------------------
%  SET SIMULATION FLAGS AND OPTIONS
% -------------------------------------------------------------------------

%--- performed computations ---%
compute_ultSAR_pTx_flag = 0;             % 1 --> compute ultimate intrinsic SAR for parallel transmission
compute_coilSAR_pTx_flag = 0;            % 1 --> compute SAR for circular surface coils (parallel transmission)
compute_ultSAR_RFshim_flag = 1;          % 1 --> compute ultimate intrinsic SAR for RF shimming
compute_coilSAR_RFshim_flag = 1;         % 1 --> compute SAR for circular surface coils (RF shimming)
compute_localSAR_flag = 1;               % 1 --> compute local SAR associated with optimal global SAR
compute_rf_power_requirements = 1;       % 1 --> return RF power requirements (only for coils, as in the ultimate case sigma of conductors is infinite)
compute_ult_current_pattern_flag = 1;    % 1 --> compute ultimate current patterns
compute_coil_current_pattern_flag = 1;   % 1 --> compute coil current patterns

%--- geometry ---%
preset_fov_geometry_flag = 0;            % 1 --> FOV data is loaded from a .MAT file
preset_coil_geometry_flag = 1;           % 1 --> coil geometry is loaded from file
preset_target_profile_flag = 0;          % 1 --> target profile is loaded from file

%--- saved variables ---%
save_efields_ult_flag = 1;               % 1 --> save a matrix with the modes' electric fields at each position (WARNING: large file)
save_efields_coil_flag = 1;              % 1 --> save a matrix with the coils' electric fields at each position
save_bfields_ult_flag = 1;               % 1 --> save a matrix with the modes' magnetic fields at each position (WARNING: large file)
save_bfields_coil_flag = 1;              % 1 --> save a matrix with the coils' magnetic fields at each position
save_ult_current_weights_flag = 1;       % 1 --> save ultimate current weights
save_coil_current_weights_flag = 1;      % 1 --> save circular surface coil current weights
save_ult_currents_flag = 1;              % 1 --> save ultimate current patterns
save_coil_currents_flag = 1;             % 1 --> save coil current patterns

%--- plotting ---%
plot_stored_results = 0;                % 1 --> plot results loaded from MAT file (using plot options specified here and not in the stored result file; WARNING: no computation performed if this flag = 1)
plot_SAR_versus_fieldstrength = 0;      % 1 --> plot global SAR vs Bo at the end of the computation
plot_ultSAR = 1;                        % 1 --> plot ultimate SAR results
plot_coilSAR = 1;                       % 1 --> plot SAR results for circular surface coils
plot_target_profile = 1;                % 1 --> plot target excitation profile
plot_actual_profile = 1;                % 1 --> plot actual excited profile
plot_ult_current_patterns = 1;          % 1 --> plot optimal current patterns
plot_ult_current_weights = 1;           % 1 --> plot modes' combination weights for ultimate SAR
plot_coil_current_patterns = 1;         % 1 --> plot surface coil current patterns
plot_coil_current_weights = 1;          % 1 --> plot coils' combination weights for optimal SAR
plot_current_3D = 1;                    % 1 --> display currents pattern on tridimensional surfaces (only if current patterns are plotted) 
plot_efields_ult = 0;                   % 1 --> plot the net electric field of the modes' SoS combination
plot_efields_coil = 0;                  % 1 --> plot the electric fields of the individual coils and of their SoS combination
plot_bfields_ult = 0;                   % 1 --> plot the net magnetic field of the modes' SoS combination
plot_bfields_coil = 0;                  % 1 --> plot the magnetic fields of the individual coils and of their SoS combination
plot_circular_coils_flag = 0;           % 1 --> plot coil geometry (on a generic cylinder, without FOV)
plot_coil_number_flag = 0;              % 1 --> add coil number next to coil geometry
plot_coil_setup_flag = 1;               % 1 --> create figure with sphere, coil geometry and FOV used in the simulation
plot_epsilon = 0;                       % 1 --> plot epsilon as a function of frequency
plot_sigma = 0;                         % 1 --> plot sigma as a function of frequency

%--- current patterns plotting options ---%
real_part_flag = 1;                     % 1 --> plot the real part of the complex-valued current patterns (0 --> plot imaginary part)
show_axes = 1;                          % 1 --> show Cartesian axes in the 3D plot
axes_color = [0 0 0];                   % 1 --> color of Cartesian axes in the 3D plot
plot_bkgcolor = [0.5 0.5 0.5];          % background color for 3D plots [1 1 1] = white, [0.5 0.5 0.5] = gray, [0 0 0] = black
currentpatternmatrixsize = [52 52];     % number of points at which the current vectors are calculated
whichvoxels = [5 5];                    % coordinates of the voxel for which current patterns are calculated (if [] then all voxels of the FOV)
currentarrowswidth = 1.1;               % "LineWidth" for quiver plot of current patterns
currentarrowscolor = 'k';               % "Color" for quiver plot of current patterns
spherefacecolor = [0.89 0.89 0.89];     % "FaceColor" color of the sphere in 3D current plots. [0.89 0.89 0.89] = Black&White figures, [1 0.46 0] = Ultimate basis set, [0.9 1 1] = Light blue sphere
sphereedgecolor = 'none';               % "EdgeColor" color of the patches' borders in 3D current plots
spherefacealpha = 1;                    % "FaceAlpha" level of transparency of the patches in 3D current plots
sphereview = [-37.5-180 30];            % azimuth and elevation of the viewpoint in 3D current plots

%--- EM fields plotting options ---%
scale_factor = 2;                       % new matrix size will be scale_factor*matrix_size (used also for local SAR movie)
interp_method = 'bilinear';             % interpolation method for scaling the original image (nearest, bilinear, bicubic)
plot_coil_b1plus_phase = 1;             % plot the phase of B1+ for all coils (in addition to magnitude)
plot_coil_b1minus_phase = 1;            % plot the phase of B1- for all coils (in addition to magnitude)

%--- movies ---%
movie_ultSAR_local = 0;                 % 1 --> creates a movie with local (optimal) SAR as a function of time (compute_local_SAR_flag must be = 1)
movie_coilSAR_local = 0;                % 1 --> creates a movie with local SAR as a function of time for cylindrical window coils (compute_local_SAR_flag must be = 1)
movie_ult_current = 0;                  % 1 --> creates a movie of ultimate current patterns as a function of time
movie_coil_current = 0;                 % 1 --> creates a movie of current patterns as a function of time for cylindrical window coils
movie_window_scaling = 2;               % specify by how much the figure window is scaled before capturing the movie frames
movie_frames = 50;                      % specify the number of frames captured (total frames = movie_frames + 1)
movie_fps = 6;                          % specify the speed of the AVI movie in frames per second (fps)
movie_compression = 'None';             % specify the compression codec to use in converting Matlab movie to AVI movie
                                        % (on Windows are available: 'Ideo3','Ideo5','Cinepak','MSVC','RLE','None')
%--- RF shim options ---%
rfshim_trimflag = 1;                    % 1 --> remove points not excited by common excitation profile out of the SAR computation
rfshim_regularizeflag = 1;              % 1 --> use regularization
rfshim_regularizationtol = 1;           % 1 --> Matlab default SVD tolerance (any other number multiplies the default tolerance)
                                        
%--- general ---%
user_label = 'RL';                      % user signature that will be added on some of the plots
plot_font_size = 18;                    % FontSize used for some of the plots
warningsoffflag = 1;                    % 1 --> set off some MATLAB warnings
use_tissue_properties = 1;              % 1 --> use stored tissue properties
include_psi_coil = 1;                   % 1 --> include noise correlation matrix in coil SAR optimization (always included for current patterns)
save_log_file = 0;                      % 1 --> save a log of keyboard input and the resulting text output

%--- virtual coils ---%
virtual_coils_flag = 1;                 % 1 --> calculate SAR after coil compression
vcoils = NaN;                           % NaN --> number of virtual coils is chosen automatically (95% of SV)
% vcoils = 48;                          % NaN --> number of virtual coils is chosen automatically (95% of SV)

%--- Poynting vector options ---%
poynting_rad_scale = 4;                 % the radius of the spherical surface where ExB is integrated is poynting_rad_scale*outer_radius (must be > 1, default = 4)
npatches = [30 30];                     % number of patches used to discretize the spherical surface of integration [vertical azimuthal] divisions
plot_poynting_sphere_flag = 1;               % plot the discretized spherical surface with the locations where the Poynting vector is calculated

% -------------------------------------------------------------------------
% DEFINE DIRECTORIES PATHS
% -------------------------------------------------------------------------

home_dir     = './';
commondir   = [home_dir 'common_routines/'];
plotdir     = [home_dir 'plot_routines/'];
basissetdir = [home_dir 'results_ultimate/'];
circcoildir = [home_dir 'results_coil/'];
moviedir    = [home_dir 'movies/'];
logdir      = [home_dir 'logfiles/'];
geometrydir = [home_dir 'coil_packing/'];

addpath(plotdir);
addpath(commondir);
if save_log_file
    logfilename = [logdir 'sphere_log_user_' user_label '_' datestr(now,30) '.txt'];
    diary(logfilename);
end

%--- stored data file names ---%
fov_file = './dielectrictest_fov.mat';
% coil_file = [];
coil_file = './coil_packing/24_coils_mv.mat';

if preset_fov_geometry_flag % file must contain x_fov,y_fov,z_fov
    if fov_file
        load(fov_file);
    else
        [fov_filename,fov_filepath] = uigetfile('*.mat','Select the MAT-file with FOV data');
        fov_file = fullfile(fov_filepath,fov_filename);
        load(fov_file);
    end
    matrix_size = size(x_fov);
    matrix_size_set = repmat(matrix_size,size(acceleration_set,1),1);
end


if plot_SAR_versus_fieldstrength
    disp('*** plot_SAR_versus_fieldstrength NOT YET IMPLEMENTED')
    plot_SAR_versus_fieldstrength = 0;
end

if plot_stored_results % no computation
    disp('**WARNING: plotting stored results, no computation performed**')
    compute_ultSAR_pTx_flag = 0;
    compute_coilSAR_pTx_flag = 0;
    compute_ultSAR_RFshim_flag = 0;
    compute_coilSAR_RFshim_flag = 0;
    compute_localSAR_flag = 0;
    compute_rf_power_requirements = 0;
    compute_ult_current_pattern_flag = 0;
    compute_coil_current_pattern_flag = 0;
end

% -------------------------------------------------------------------------
%  SET GEOMETRY PARAMETERS
% -------------------------------------------------------------------------

%--- FOV ---%
patientposition = 'headfirst';
patientorientation = 'supine';
sliceorientation = 'transverse';
phasedir = 'LR';

apoff = 0; lroff = 0; fhoff = 0.0015;
apang = 0; lrang = 0; fhang = 0;
image_plane_offset = [apoff lroff fhoff];
image_plane_orientation = [apang lrang fhang];

%--- circular surface coil geometry ---%
if compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag
    if preset_coil_geometry_flag,
        if coil_file
            load(coil_file)
        else
            [coil_file,coil_path] = uigetfile('*.mat','Select the MAT-file with coil array geometry',geometrydir);
            load(fullfile(coil_path,coil_file));
        end
        ncoils = size(coil_rotations,1);
        coil_rotations = 180*coil_rotations/pi; % conversion from rad to deg
    else % user defined loop coil data
        coil_rotations = ... % [theta phi]
            [90 0
            90 10
            90 55
            90 100
            90 145
            90 190
            90 235
            90 280
            90 325
            90 45
            90 90
            90 135
            90 180
            90 225
            90 270
            90 315];
                coil_rotations = ... % [theta phi]
                    [90 45
                     90 55];
        ncoils = size(coil_rotations,1);
%         coil_radius_mul = 0.48;
        %         coil_radius_mul = 0.36;
        coil_radius_mul = 0.5146;
    end
    %--- check if all varaiables are there ---%
    if any(isnan(ncoils)) || isempty(coil_rotations) || any(isnan(coil_radius_mul))
        disp('-------------------------------------------------------');
        disp('**ERROR** unspecified circular surface coils variable');
        disp('-------------------------------------------------------');
        pause
    end
else
    ncoils = NaN;
    coil_rotations = [];
end

% -------------------------------------------------------------------------
%  SET PHANTOM AND OTHER EXPERIMENTAL PARAMETERS
% -------------------------------------------------------------------------

%--- electrical properties ---%
tissue_type = 1;    % 1 --> brain from Wiesinger et al
% 2 --> dog skeletal muscle Cole-Cole-scaled from Stoy et al;
% 3 --> dog skeletal muscle from Schnell thesis Appendix C
if use_tissue_properties,
    epsilon_rel = NaN;
    sigma = NaN;
else
    % SIEMENS phantom at Bo = 2.8941
%     epsilon_rel = 80.03;
%     sigma = 0.084;
    % BRAINO phantom at Bo = 2.8941
    epsilon_rel = 40; %81.31;
    sigma = 0.97;
end
sigma_copper = 58e6;             % copper conductivity = 58*10^6 S/m
if compute_rf_power_requirements,
    sigma_coil = sigma_copper;   % [ohm^-1][m^-1] conductivity of the shield
    d_coil = NaN;                % d_coil = NaN --> use skin depth of coil conductor
else
    sigma_coil = Inf;
    d_coil = 0.001;
end

%--- Experimental scaling factors ---%
Vvoxel = 0.002*0.002*0.003;                
NEX = 1;
flipangle = pi/9;
BW = 25.6e3;           % total receive bandwidth
noisefactor = 1.2023;  % noisefigure = 10*log10(noisefactor) = 0.8 [dB]

% -------------------------------------------------------------------------
%  GROUPING SIMULATION SETTINGS AND FLAGS 
% -------------------------------------------------------------------------

if compute_coilSAR_pTx_flag && ~(compute_ultSAR_pTx_flag)
    compute_ultSAR_pTx_flag = 1;
end
if compute_coilSAR_RFshim_flag && ~(compute_ultSAR_RFshim_flag)
    compute_ultSAR_RFshim_flag = 1;
end
if save_ult_currents_flag && ~(compute_ult_current_pattern_flag)
    compute_ult_current_pattern_flag = 1;
end
if save_coil_currents_flag && ~(compute_coil_current_pattern_flag)
    compute_coil_current_pattern_flag = 1;
end
if compute_coil_current_pattern_flag && ~(compute_ult_current_pattern_flag)
    compute_ult_current_pattern_flag = 1;
end
if save_coil_current_weights_flag && ~(save_ult_current_weights_flag)
    save_ult_current_weights_flag = 1;
end
if compute_rf_power_requirements && ~include_psi_coil
    disp('**WARNING** include_psi_coil has been set to 1 in order to calculate power requirements')
    include_psi_coil = 1;
end

simulation_options = struct(...
    'lmax',lmax,...
    'profile_shape',profile_shape,...
    'compute_rf_power_requirements',compute_rf_power_requirements,...
    'include_psi_coil',include_psi_coil,...
    'compute_ultSAR_pTx_flag',compute_ultSAR_pTx_flag,...
    'compute_coilSAR_pTx_flag',compute_coilSAR_pTx_flag,...
    'compute_ultSAR_RFshim_flag',compute_ultSAR_RFshim_flag,...
    'compute_coilSAR_RFshim_flag',compute_coilSAR_RFshim_flag,...
    'compute_localSAR_flag',compute_localSAR_flag,...
    'compute_ult_current_pattern_flag',compute_ult_current_pattern_flag,...
    'compute_coil_current_pattern_flag',compute_coil_current_pattern_flag,...
    'save_efields_ult_flag',save_efields_ult_flag,...
    'save_efields_coil_flag',save_efields_coil_flag,...
    'save_bfields_ult_flag',save_bfields_ult_flag,...
    'save_bfields_coil_flag',save_bfields_coil_flag,...
    'save_ult_current_weights_flag',save_ult_current_weights_flag,...
    'save_coil_current_weights_flag',save_coil_current_weights_flag,...
    'save_ult_currents_flag',save_ult_currents_flag,...
    'save_coil_currents_flag',save_coil_currents_flag,...
    'sigma_coil',sigma_coil,...
    'd_coil',d_coil,...
    'tissue_type',tissue_type,...
    'rfshim_trimflag',rfshim_trimflag,...
    'rfshim_regularizeflag',rfshim_regularizeflag,...
    'rfshim_regularizationtol',rfshim_regularizationtol,...
    'epsilon_rel',epsilon_rel,...
    'sigma',sigma,...
    'virtual_coils_flag', virtual_coils_flag,...
    'vcoils', vcoils,...
    'poynting_rad_scale',poynting_rad_scale,...
    'npatches',npatches);

path_options = struct(...
    'home_dir',home_dir,...
    'commondir',commondir,...
    'plotdir',plotdir,...
    'basissetdir',basissetdir,...
    'circcoildir',circcoildir,...
    'moviedir',moviedir,...
    'logdir',logdir,...
    'geometrydir',geometrydir);

whichvoxelweights = whichvoxels; % consider making it independent from whichvoxels in the future

plotting_options = struct(...
    'user_label',user_label,...
    'plot_font_size',plot_font_size,...
    'plot_ultSAR',plot_ultSAR,...
    'plot_coilSAR',plot_coilSAR,...
    'plot_target_profile',plot_target_profile,...
    'plot_actual_profile',plot_actual_profile,...
    'plot_ult_current_patterns',plot_ult_current_patterns,...
    'plot_ult_current_weights',plot_ult_current_weights',...
    'plot_coil_current_patterns',plot_coil_current_patterns,...
    'plot_coil_current_weights',plot_coil_current_weights,...
    'plot_current_3D',plot_current_3D,...
    'plot_efields_ult',plot_efields_ult,...
    'plot_efields_coil',plot_efields_coil,...
    'plot_bfields_ult',plot_bfields_ult,...
    'plot_bfields_coil',plot_bfields_coil,...
    'plot_coil_number_flag',plot_coil_number_flag,...
    'plot_coil_setup_flag',plot_coil_setup_flag,...
    'show_axes',show_axes,...
    'axes_color',axes_color,...
    'movie_ultSAR_local',movie_ultSAR_local,...
    'movie_coilSAR_local',movie_coilSAR_local,...
    'movie_ult_current',movie_ult_current,...
    'movie_coil_current',movie_coil_current,...
    'movie_window_scaling',movie_window_scaling,...
    'movie_frames',movie_frames,...
    'movie_fps',movie_fps,...
    'movie_compression',movie_compression,...
    'real_part_flag',real_part_flag,...
    'plot_bkgcolor',plot_bkgcolor,...
    'currentpatternmatrixsize',currentpatternmatrixsize,...
    'whichvoxels',whichvoxels,...
    'whichvoxelweights',whichvoxelweights,...
    'currentarrowswidth',currentarrowswidth,...
    'currentarrowscolor',currentarrowscolor,...
    'spherefacecolor',spherefacecolor,...
    'sphereedgecolor',sphereedgecolor,...
    'spherefacealpha',spherefacealpha,...
    'sphereview',sphereview,...
    'scale_factor',scale_factor,...
    'interp_method',interp_method,...
    'plot_poynting_sphere_flag',plot_poynting_sphere_flag,...
    'plot_coil_b1plus_phase',plot_coil_b1plus_phase,...
    'plot_coil_b1minus_phase',plot_coil_b1minus_phase);

% -------------------------------------------------------------------------
%  RUNNING SNR SIMULATION
% -------------------------------------------------------------------------

if warningsoffflag,
    warning('off','MATLAB:nearlySingularMatrix')
    warning('off','MATLAB:divideByZero')
end

% Error handling
dbstop if error

% -- Ultimate SAR and loop coil SAR--
if compute_ultSAR_pTx_flag || compute_ultSAR_RFshim_flag || compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag,
    if compute_coil_current_pattern_flag && ~(compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag)
    	disp('** Coil currents can''t be computed as compute_coilSAR_pTx_flag and compute_coilSAR_RFshim_flag are zero')
        simulation_options.compute_coil_current_pattern_flag = 0;
    end
    if save_coil_current_weights_flag && ~(compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag)
    	disp('** Coil current weights can''t be computed as compute_coilSAR_pTx_flag and compute_coilSAR_RFshim_flag are zero')
        simulation_options.save_coil_current_weights_flag = 0;
    end
    
    if compute_ultSAR_pTx_flag
        sar_ult_ptx = NaN*zeros([nfields nradout nradin nacc matrix_size_set(nacc,:)]);
        ultg_ptx = sar_ult_ptx;
        ult_actual_prof_ptx = sar_ult_ptx;
        ult_sar_global_ptx = NaN*zeros([nfields nradout nradin nacc]);
        peak_sar = ult_sar_global_ptx;
    end
    if compute_ultSAR_RFshim_flag
        ult_actual_prof_rfshim = NaN*zeros([nfields nradout nradin matrix_size_set(1,:)]);
        sar_global_rfshim =  NaN*zeros([nfields nradout nradin]);
    end
    
    if compute_coilSAR_pTx_flag
        sar_coil_ptx = sar_ult_ptx;
        coilg_ptx = sar_coil_ptx;
        coil_actual_prof_ptx = sar_ult_ptx;
        coil_sar_global_ptx = ult_sar_global_ptx;
        coil_peak_sar = coil_sar_global_ptx;
    end
    if compute_coilSAR_RFshim_flag
        coil_actual_prof_rfshim = ult_actual_prof_rfshim;
        coil_sar_global_rfshim = sar_global_rfshim;
    end
    
    epsilons = zeros(nfields,1);
    sigmas = epsilons;
    disp('Starting ultimate SAR calculation...');
    for ifield = 1:nfields
        fieldstrength = fieldstrength_set(ifield);
        for iacc = 1:size(acceleration_set,1)   
            acceleration = acceleration_set(iacc,:); 
            matrix_size = matrix_size_set(iacc,:);
            for iradin = 1:length(sphereradius_set)
                sphereradius = sphereradius_set(iradin);
                
                radius1 = radius1_set(iradin);
                radius2 = radius2_set(iradin);
                
                fov = [mask_radius*2*sphereradius mask_radius*2*sphereradius];
                fovf = fov(1);
                fovp = fov(2);
                for iradout = 1:length(outer_radius_set)    
                    currentradius = outer_radius_set(iradout);
                    whichcurrents = current_set{iradout};
                    if whichcurrents == 2 % can't generate loops with electric dipole modes
                        simulation_options.compute_coilSAR_pTx_flag = 0;
                        simulation_options.compute_coilSAR_RFshim_flag = 0;
                        compute_coilSAR_pTx_flag = 0;
                        compute_coilSAR_RFshim_flag = 0;
                        simulation_options.compute_coil_current_pattern_flag = 0;
                        simulation_options.save_coil_current_weights_flag = 0;
                    end
                    if compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag
                        coil_surface_radii = ones(ncoils,1)*currentradius;
                        coil_radii = coil_surface_radii*coil_radius_mul;
                        coil_offsets = sqrt(coil_surface_radii.^2 - coil_radii.^2);
                    else
                        coil_radii = [];
                        coil_offsets = [];
                    end
                    if (compute_coilSAR_pTx_flag || compute_coilSAR_RFshim_flag) && plot_circular_coils_flag && (~plot_coil_setup_flag)
                        figure;
                        plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,[0.1],[0],[0.1],3,'-',[1 0.46 0],0,plot_coil_number_flag)
                    end
                    
                    geometry_options = struct(...
                            'preset_fov_geometry_flag',preset_fov_geometry_flag,...
                            'preset_target_profile_flag',preset_target_profile_flag,...
                            'fov_file',fov_file,...
                            'fovf',fovf,...
                            'fovp',fovp,...
                            'matrix_size',matrix_size,...
                            'sphereradius',sphereradius,...
                            'currentradius',currentradius,...
                            'sigma3',sigma3,...
                            'epsilon_r3',epsilon_r3,...
                            'radius2',radius2,...
                            'sigma2',sigma2,...
                            'epsilon_r2',epsilon_r2,...
                            'radius1',radius1,...
                            'phasedir',phasedir,...
                            'patientposition',patientposition,...
                            'patientorientation',patientorientation,...
                            'sliceorientation',sliceorientation,...
                            'image_plane_offset',image_plane_offset,...
                            'image_plane_orientation',image_plane_orientation,...
                            'ncoils',ncoils,...
                            'coil_rotations',coil_rotations,...
                            'coil_radii',coil_radii,...
                            'coil_offsets',coil_offsets);
                    
                        if compute_ultSAR_pTx_flag
                            %------------------------------------------------------
                            [output_values_ptx] = dgf_sphere_calc_sar_ptx(...
                                whichcurrents,fieldstrength,acceleration,simulation_options,geometry_options,...
                                path_options,currentpatternmatrixsize,whichvoxels,whichvoxelweights);
                            
                            %------------------------------------------------------
                            
                            sar_ult_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.sar_ult_ptx);
                            ultg_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.g_ult_ptx);
                            ult_actual_prof_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.actual_profile_ptx_ult);
                            ult_sar_global_ptx(ifield,iradout,iradin,iacc) = real(output_values_ptx.sar_global_ult);
                            peak_sar(ifield,iradout,iacc) = real(output_values_ptx.peak_sar);
                            
                            if compute_coilSAR_pTx_flag
                                sar_coil_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.sar_coil_ptx);
                                coilg_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.g_coil_ptx);
                                coil_actual_prof_ptx(ifield,iradout,iradin,iacc,:,:) = real(output_values_ptx.actual_profile_ptx_coil);
                                coil_sar_global_ptx(ifield,iradout,iradin,iacc) = real(output_values_ptx.sar_global_coil);
                                coil_peak_sar(ifield,iradout,iradin,iacc) = real(output_values_ptx.peak_sar_coil);
                            end
                            
                            epsilons(ifield) = output_values_ptx.epsilon_rel;
                            sigmas(ifield) = output_values_ptx.sigma;
                            
                            if matrix_size ~= size(output_values_ptx.x_fov), % matrix_size might be changed inside dgf_sphere_calc_snr if stored x_fov,y_fov,z_fov are used
                                matrix_size = size(output_values_ptx.x_fov);
                            end
                            
                            dgf_sphere_plot_sar_ptx(output_values_ptx,simulation_options,geometry_options,path_options,plotting_options)
                        end
                        if compute_ultSAR_RFshim_flag
                            %------------------------------------------------------
                            [output_values_rfshim] = dgf_sphere_calc_sar_rfshim(...
                                whichcurrents,fieldstrength,simulation_options,geometry_options,path_options,currentpatternmatrixsize);
                            %------------------------------------------------------
                                                 
                            ult_actual_prof_rfshim(ifield,iradout,iradin,:,:) = real(output_values_rfshim.actual_prof_rfshim_ult);
                            sar_global_rfshim(ifield,iradout,iradin) = real(output_values_rfshim.sar_global_ult_rfshim);
                            
                            if compute_coilSAR_RFshim_flag
                                coil_actual_prof_rfshim(ifield,iradout,iradin,:,:) = real(output_values_rfshim.actual_prof_rfshim_coil);
                                coil_sar_global_rfshim(ifield,iradout,iradin) = real(output_values_rfshim.sar_global_coil_rfshim);
                            end
                            
                            epsilons(ifield) = output_values_rfshim.epsilon_rel;
                            sigmas(ifield) = output_values_rfshim.sigma;
                            
                            if matrix_size ~= size(output_values_rfshim.x_fov), % matrix_size might be changed inside dgf_sphere_calc_snr if stored x_fov,y_fov,z_fov are used
                                matrix_size = size(output_values_rfshim.x_fov);
                            end
                            
                            dgf_sphere_plot_sar_rfshim(output_values_rfshim,simulation_options,geometry_options,path_options,plotting_options)
                        end
                end % iradout loop
            end % iradin loop
        end % iacc loop
    end % ifield loop
    disp('Ultimate SAR calculation done.');
    if plot_SAR_versus_fieldstrength,
        plot_sar_vs_fieldstrength_sphere  % TO BE DONE
    end
    if plot_epsilon,
        f = whichfrequencies/1e6;
        figure
        set(gcf,'name','epsilon')
        plot(f,epsilons)
        set(gca,'xlim',[0 200])
        set(gca,'xtick',0:25:200)
        set(gca,'xminortick','on')
        set(gca,'ylim',[0 200])
        set(gca,'ytick',0:25:200)
        set(gca,'yminortick','on')
        xlabel('f/MHz ->')
        ylabel('\epsilon_{rel} ->')
        grid
    end
    if plot_sigma,
        f = whichfrequencies/1e6;
        figure
        set(gcf,'name','sigma')
        plot(f,sigmas)
        set(gca,'xlim',[0 200])
        set(gca,'xtick',0:25:200)
        set(gca,'xminortick','on')
        set(gca,'ylim',[0 1])
        set(gca,'ytick',0:0.2:1)
        set(gca,'yminortick','on')
        xlabel('f/MHz ->')
        ylabel('\sigma/Sm^{-1} ->')
        grid
    end
end


%--- PLOTS FROM STORED RESULTS ---%
if plot_stored_results
    disp('SORRY - NOT YET IMPLEMENTED!***************')
end

% if plot_stored_results
%     if plot_ultSAR || plot_ult_current_patterns || plot_ult_current_weights || plot_efields_ult || plot_bfields_ult || movie_ult_current || movie_ultSAR_local
% 
%     [ultSARfile,ultSARpath] = uigetfile([ basissetdir 'ultimate_sar_results/*.mat'],'Select the MAT-file with ultSAR results');
%     load(fullfile(ultSARpath,ultSARfile));
%     
% %         output_values_ult = struct(...
% %             's_opts',s_opts,...
% %             'g_opts',g_opts,...
% %             'd_opts',d_opts,...
% %             'p_opts',plotting_options,...
% %             'whichcurrents',whichcurrents,...
% %             'fieldstrength',fieldstrength,...
% %             'acceleration',acceleration,...
% %             'snr_ult',snr_ult,...
% %             'g_ult',g_ult,...
% %             'snr_coil',[],...
% %             'g_coil',[],...
% %             'psi_coil',[],...
% %             'snr_bodycoil',[],...
% %             'mask',mask,...
% %             'whichvoxels',whichvoxels,...
% %             'whichvoxelweights',whichvoxelweights,...
% %             'weights',weights,...
% %             'weights_coil',[],...
% %             'currentpatternmatrixsize',currentpatternmatrixsize,...
% %             'currentpattern',currentpattern,...
% %             'currentpattern_coil',[],...
% %             'currentpattern_coil_ideal',[],...
% %             'currentpattern_bodycoil',[],...
% %             'currentphi',currentphi,...
% %             'currentz',currentz,...
% %             'efield_ult_set',efield_ult_set,...
% %             'bfield_ult_set',bfield_ult_set,...
% %             'efield_coil_set',[],...
% %             'bfield_coil_set',[],...
% %             'efield_bodycoil_set',[],...
% %             'bfield_bodycoil_set',[],...
% %             'epsilon_rel',epsilon_rel,...
% %             'sigma',sigma,...
% %             'x_fov',x_fov,...
% %             'y_fov',y_fov,...
% %             'z_fov',z_fov);
% %         
% %         dgf_cylinder_plot_rx(output_values_ult)
%     end

if save_log_file
    diary off
end

% END DGF_sphere_sar_batch.m

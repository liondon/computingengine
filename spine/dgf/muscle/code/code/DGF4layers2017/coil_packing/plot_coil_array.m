%plot coil array

sphereradius=.1;
current_radius=0.1342;
num_coils=size(coil_rotations,1);

% coil_radius_mul=sin(packing_radius*pi/180);
coil_surface_radii= (ones(1,num_coils)*current_radius)';
coil_radii = coil_surface_radii*coil_radius_mul;
current_radius_set=(current_radius*ones(1,num_coils))';
coil_offsets = (sqrt(current_radius_set.^2 - coil_radii.^2));
% coil_rotations=[theta',phi'];
coil_rotations = 180*coil_rotations/pi; % degree calculation in batch file
plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,[0.1],[0],[0.1],3,'-',[1 0.46 0],0,1)


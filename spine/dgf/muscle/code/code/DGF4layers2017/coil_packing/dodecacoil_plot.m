
figure;
plot_coil_number_flag=1;
sphereradius=.1125;
current_radius=sphereradius+.01;

coil_surface_radii= (ones(1,length(coil_rotations))*current_radius)';
coil_radii = coil_surface_radii*coil_radius_mul;
current_radius_set=(current_radius*ones(1,length(coil_rotations)))';
coil_offsets = (sqrt(current_radius_set.^2 - coil_radii.^2));

plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,[0.1],[0],[0.1],3,'-',[1 0.46 0],0,plot_coil_number_flag)

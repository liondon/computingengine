% function [R,theta, phi]=coil_pack_var(current_radius,coordinates,covering_radius)
% Radius and coordinates obtained from website: http://www2.research.att.com/~njas/packings/index.html#I

plot_coil_number_flag=1;
sphereradius=.1;
current_radius=0.1342;

% covering_radius=74.8584922/2;
packing_radius=63.4349488/2;

coordinates=[  8.506508083520922800e-01
  8.461919126260937200e-21
 -5.257311121190491000e-01
  5.257311121190491000e-01
 -8.506508083520922800e-01
  0.000000000000000000e+00
  1.266847532837018700e-20
 -5.257311121190491000e-01
  8.506508083520922800e-01
  8.506508083520922800e-01
  2.117154529536468700e-20
  5.257311121190491000e-01
 -5.257311121190491000e-01
 -8.506508083520922800e-01
  3.303943689239743800e-23
 -4.393463640892673700e-21
  5.257311121190491000e-01
 -8.506508083520922800e-01
 -8.506508083520922800e-01
 -8.452634485559703400e-21
 -5.257311121190491000e-01
 -5.257311121190491000e-01
  8.506508083520922800e-01
  6.548656517555661000e-21
  1.691455361231732600e-20
  5.257311121190491000e-01
  8.506508083520922800e-01
 -8.506508083520922800e-01
  1.437620000877874100e-20
  5.257311121190491000e-01
  5.257311121190491000e-01
  8.506508083520922800e-01
 -1.769525700386171300e-21
 -1.447394738531641700e-20
 -5.257311121190491000e-01
 -8.506508083520922800e-01];

R=sin(packing_radius*pi/180)*current_radius; % packing_radius is in degrees R=sin(deg*pi/180)*current_radius

len=length(coordinates);
j=1;
i=1;
X=zeros(1,len/3);
Y=zeros(1,len/3);
Z=zeros(1,len/3);

% X=(coordinates(:,1))';
% Y=(coordinates(:,2))';
% Z=(coordinates(:,3))';

while i<=len ,
    X(j)=coordinates(i);
    i=i+1;
    Y(j)=coordinates(i);
    i=i+1;
    Z(j)=coordinates(i);
    i=i+1;
    j=j+1;
end
% plot3(X,Y,Z,'bo');

% -------cartesian to polar-------
rad=sqrt(X.^2+Y.^2+Z.^2);
costheta = (Z./rad);
costheta(isnan(costheta)) = 0;
theta = acos(costheta);  
phi = atan2(Y,X); 
%------------

% figure;
% plot_sphere(rad, theta, phi);
% hold off;

coil_radius_mul=sin(packing_radius*pi/180);
coil_surface_radii= (ones(1,length(Z))*current_radius)';
coil_radii = coil_surface_radii*coil_radius_mul;
current_radius_set=(current_radius*ones(1,length(Z)))';
coil_offsets = (sqrt(current_radius_set.^2 - coil_radii.^2));
coil_rotations=[theta',phi'];
coil_rotations = 180*coil_rotations/pi;
plot_geometry_sphere(sphereradius,coil_radii,coil_offsets,coil_rotations,[0.1],[0],[0.1],3,'-',[1 0.46 0],0,plot_coil_number_flag)


% end

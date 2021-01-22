% Manushka Vaidya : Coil packing by importing coordinates from Sloane's website.
% Radius and coordinates obtained from website: NeilSloane.com/packings/
% N. J. A. Sloane, with the collaboration of R. H. Hardin, W. D. Smith and others, Tables of Spherical Codes, published electronically at NeilSloane.com/packings/

plot_coil_number_flag=1;
sphereradius=.1;
current_radius=0.1342;

% covering_radius=74.8584922/2;
% packing_radius=63.4349488/2;
packing_radius=43.6907671/2;  % use the min. seperation in degrees on the website corresponding to the number of points of interest. 

% for coordinates, open the respective page with the coordinates
% corresponding to the number of points of interest.
coordinates=[ -6.501622274810909800e-01
  7.318552643438611700e-01
 -2.041493326195395500e-01
 -7.068173367372689900e-01
  4.994797737111063600e-01
  5.009283463142569800e-01
  4.345430729432042100e-01
 -1.508894193590818700e-01
  8.879215623480243300e-01
 -4.945931503596364100e-01
 -8.355961035746810600e-01
  2.390748152945876000e-01
 -9.946740895936685400e-01
  9.000325885316010100e-02
 -5.022816826062723900e-02
 -1.264537663428677300e-01
 -9.058741465432007500e-01
 -4.042294838360150900e-01
 -7.776590482212382100e-01
 -2.383167902256642700e-01
  5.817658568669827900e-01
  8.783677431849544700e-01
  2.247777778963001800e-01
  4.218353450058109400e-01
 -2.515712003286377800e-01
  1.292478807567231900e-01
  9.591699101228646800e-01
 -2.003103091943429500e-01
 -3.552926190816992300e-01
 -9.130404891660245400e-01
  3.123147750254637300e-01
  5.720239105612218200e-01
  7.584511368882253000e-01
  9.647213447137686900e-01
 -8.911302114685391900e-02
 -2.477329136706273000e-01
  1.530050152438502800e-02
  3.658194505516781400e-01
 -9.305600594540746100e-01
  5.638515061603007700e-01
  8.194473734962129900e-01
  1.028468816781460300e-01
  5.181149840616122700e-01
 -1.752542222180714100e-01
 -8.371635568307869100e-01
  7.897206361869990600e-01
 -5.100032566080506800e-01
  3.409369370273400100e-01
 -7.501467875856345800e-01
 -5.002675607801907500e-01
 -4.324490313389443000e-01
  1.492986384079533500e-01
 -7.793125135014838900e-01
  6.085901107227514900e-01
 -1.431496295203319200e-01
  9.428486359917011000e-01
  3.009063528355301300e-01
  6.504550730920256600e-01
  5.056760054238899100e-01
 -5.667450709334714800e-01
 -6.739272707559569300e-01
  1.841197605891742900e-01
 -7.154872098731132100e-01
  4.070912249060670100e-02
  9.067729498776537800e-01
 -4.196493592467679900e-01
  5.938385579700630200e-01
 -7.275147032134100500e-01
 -3.436249753384351700e-01];

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

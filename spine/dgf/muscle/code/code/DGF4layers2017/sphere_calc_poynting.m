function P_R = sphere_calc_poynting(l,m,s_opts,g_opts,path_opts,plot_poynting_sphere_flag,whichcurrents,k_0,k_s,ele_scaling,mag_scaling)

addpath(path_opts.commondir);
addpath(path_opts.plotdir);

disp(['***   running sphere_calc_poynting.m (l,m) = ' num2str(l) ',' num2str(m)])

mu = 4*pi*1e-7;  % permeability of free space [Wb][A^-1][m^-1]
poynting_radius = g_opts.currentradius*(s_opts.poynting_rad_scale);

k_0_rad_b = k_0*g_opts.currentradius;

ExBsum = zeros(length(whichcurrents),1);

theta_cap = 1*pi/180; % angle identifying how big is the top and bottom spherical patch (i.e. cap)
r = poynting_radius*sin(theta_cap); % radius of the cap
R_h = sqrt((poynting_radius)^2-(r)^2); % distance between the sphere center and the cap center
h = poynting_radius - R_h; % distance between the cap center and the pole of the sphere
area_spherical_cap = pi*(r^2+h^2); % area of spherical cap

% Poynting vector calculated at the noth pole of the sphere
ExB = evalEcrossB(poynting_radius,0.001*pi/180,0,whichcurrents,g_opts.sphereradius,k_0,k_0_rad_b,k_s,l,m,ele_scaling,mag_scaling); % (since top circle)

avg_theta = 0.001*pi/180;
avg_phi = 0;
normal = calc_normal(poynting_radius,avg_theta,avg_phi);
if length(whichcurrents) == 1,
    ExBsum = ExBsum + dot(ExB(1,:),normal)*area_spherical_cap;
else
    ExBsum(1) = ExBsum(1) + dot(ExB(1,:),normal)*area_spherical_cap;
    ExBsum(2) = ExBsum(2) + dot(ExB(2,:),normal)*area_spherical_cap;
end

if plot_poynting_sphere_flag || ((l == 1) && (m == -1))
    plot_poynting_sphere(poynting_radius,0.001*pi/180,0,'go');
end

% Poynting vector calculated at the south pole of the sphere
ExB = evalEcrossB(poynting_radius,pi,0,whichcurrents,g_opts.sphereradius,k_0,k_0_rad_b,k_s,l,m,ele_scaling,mag_scaling);
avg_theta = pi;
avg_phi = 0;
normal = calc_normal(poynting_radius,avg_theta,avg_phi);

if length(whichcurrents) == 1,
    ExBsum = ExBsum + dot(ExB(1,:),normal)*area_spherical_cap;
else
    ExBsum(1) = ExBsum(1) + dot(ExB(1,:),normal)*area_spherical_cap;
    ExBsum(2) = ExBsum(2) + dot(ExB(2,:),normal)*area_spherical_cap;
end

if plot_poynting_sphere_flag || ((l == 1) && (m == -1))
    plot_poynting_sphere(poynting_radius,pi,0,'ko');
end

vertical_div = s_opts.npatches(1); % horizontal circular divisions
horizontal_div = s_opts.npatches(2); % vertical circular divisions

theta1 = theta_cap;
increment_theta = (180 - 2*theta_cap)/horizontal_div;
for k = 1:horizontal_div % fix del theta
    theta2 = theta1 + (increment_theta*pi/180);
    phi1 = 0;
    increment_phi = 360/vertical_div;
    for t = 1:vertical_div % fix del phi
        phi2 = phi1 + (increment_phi*pi/180);
        area_patch = poynting_radius^2*sin(theta1)*(abs(theta2-theta1))*abs(phi2-phi1);
        ExB = evalEcrossB(poynting_radius,(theta2+theta1)/2,(phi2+phi1)/2,whichcurrents,g_opts.sphereradius,k_0,k_0_rad_b,k_s,l,m,ele_scaling,mag_scaling);
        
        if plot_poynting_sphere_flag || ((l == 1) && (m == -1))
            plot_sphere(poynting_radius,theta1,phi2,'b*'); % comment out for better speed
            plot_sphere(poynting_radius,theta2,phi2,'b*');
            plot_sphere(poynting_radius,theta2,phi1,'b*');
            plot_sphere(poynting_radius,theta1,phi1,'b*');
        end
        avg_theta = (theta1+theta2)/2;
        avg_phi = (phi1+phi2)/2;
        if plot_poynting_sphere_flag || ((l == 1) && (m == -1))
            plot_sphere(poynting_radius,avg_theta,avg_phi,'ro');
        end
        phi1 = phi2;
        normal = calc_normal(poynting_radius,avg_theta,avg_phi);
        
        if length(whichcurrents) == 1,
            ExBsum = ExBsum + dot(ExB(1,:),normal)*area_patch;
        else
            ExBsum(1) = ExBsum(1) + dot(ExB(1,:),normal)*area_patch;
            ExBsum(2) = ExBsum(2) + dot(ExB(2,:),normal)*area_patch;
        end
    end
    theta1 = theta2;
end
if plot_poynting_sphere_flag || ((l == 1) && (m == -1))
    axis square;
    axis tight;
end

%                 sphere_poynting=1/mu*0.5*real(cross(E,conj(B)));
sphere_poynting = abs((1/mu)*0.5*real(ExBsum)); % units in W/m^2 or W(?)

P_R = diag(sphere_poynting,0)*eye(2); % radiation loss






















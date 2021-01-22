%   DGF_sphere_plots.m
%
%
% Riccardo Lattanzi 
% October 4, 2007
% -------------------------------------------------------------------------


matrix_size = [32 32];  % [nf np]
sphereradius_set = [0.05 0.15 0.25];  % [0.05 0.15 0.25]; 
lmax = 65;
fieldstrength_set = [1 4 7 10];	% currently available: [1 3 5 7 9 11];
acceleration_set = {[1 3], [1 4], [1 5], [1 6]};	% list of undersampling factors
whichcurrents = [1 2];
mask_radius = 0.95; %radius of the mask as fraction of sph_rad
mgh_flag = 0;  % if 1 then update durectories for running on mgh computer

outer_radius_set = sphereradius_set;
sigma_coil = 8e4;
d_coil = 0.001;

figure;
set(gcf,'name','    R = 3');
for ifield = 1:length(fieldstrength_set)
    for irad = 1:length(sphereradius_set)
        acc_f = [1 3];
        filetosave = [ './Results/results/dgf_snr_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
            num2str(fieldstrength_set(ifield)) 't_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
            '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lmax_' num2str(lmax) '.mat'];
        load(filetosave);
        ult_g = real(ult_g).';
        ult_g(~mask) = 1;
        max_g = max(ult_g(:));
        mean_g = mean(ult_g(:));
        title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
        subplot(4,3,(irad + (ifield-1)*3));
        imshow(ult_g,[]);
        title(title_label)
        set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
        if irad == 1
            ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
        end
    end
end
figure;
set(gcf,'name','    R = 4');
for ifield = 1:length(fieldstrength_set)
    for irad = 1:length(sphereradius_set)
        acc_f = [1 4];
        filetosave = [ './Results/results/dgf_snr_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
            num2str(fieldstrength_set(ifield)) 't_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
            '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lmax_' num2str(lmax) '.mat'];
        load(filetosave);
        ult_g = real(ult_g).';
        ult_g(~mask) = 1;
        max_g = max(ult_g(:));
        mean_g = mean(ult_g(:));
        title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
        subplot(4,3,(irad + (ifield-1)*3));
        imshow(ult_g,[]);
        title(title_label)
        set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
        if irad == 1
            ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
        end
    end
end
figure;
set(gcf,'name','    R = 5');
for ifield = 1:length(fieldstrength_set)
    for irad = 1:length(sphereradius_set)
        acc_f = [1 5];
        filetosave = [ './Results/results/dgf_snr_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
            num2str(fieldstrength_set(ifield)) 't_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
            '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lmax_' num2str(lmax) '.mat'];
        load(filetosave);
        ult_snr = real(ult_snr).';
        ult_snr(~mask) = 0;
        max_snr = max(ult_snr(:));
        mean_snr = mean(ult_snr(:));
        title_label = [ '[' sprintf('%0.3g',mean_snr) ', ' sprintf('%0.3g',max_snr) ']'];
        subplot(4,3,(irad + (ifield-1)*3));
        imshow(ult_snr,[]);
        title(title_label)
        set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
        if irad == 1
            ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
        end
    end
end

figure;
set(gcf,'name','    R = 6');
for ifield = 1:length(fieldstrength_set)
    for irad = 1:length(sphereradius_set)
        acc_f = [1 6];
        filetosave = [ './Results/results/dgf_snr_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
            num2str(fieldstrength_set(ifield)) 't_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
            '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lmax_' num2str(lmax) '.mat'];
        load(filetosave);
        ult_g = real(ult_g).';
        ult_g(~mask) = 1;
        max_g = max(ult_g(:));
        mean_g = mean(ult_g(:));
        title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
        subplot(4,3,(irad + (ifield-1)*3));
        imshow(ult_g,[]);
        title(title_label)
        set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
        if irad == 1
            ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
        end
    end
end


% figure;
% for ifield = 1:length(fieldstrength_set)
%     for irad = 1:length(sphereradius_set)
%         acc_f = [1 1];
%         filetosave = [ './Results/DGF_SNR_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
%             num2str(fieldstrength_set(ifield)) 'T_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
%             '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lMax_' num2str(lmax) '.mat'];
%         load(filetosave);
%         ult_snr = real(ult_snr).';
%         ult_snr(~mask) = 0;
%         max_snr = max(ult_snr(:));
%         mean_snr = mean(ult_snr(:));
%         title_label = [ '[' sprintf('%0.3g',mean_snr) ', ' sprintf('%0.3g',max_snr) ']'];
%         subplot(2,3,(irad + (ifield-1)*3));
%         imshow(ult_snr,[]);
%         title(title_label)
%         set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
%         if irad == 1
%             ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
%         end
%     end
% end
% figure;
% for ifield = 1:length(fieldstrength_set)
%     for irad = 1:length(sphereradius_set)
%         acc_f = [1 3];
%         filetosave = [ './Results/DGF_SNR_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
%             num2str(fieldstrength_set(ifield)) 'T_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
%             '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lMax_' num2str(lmax) '.mat'];
%         load(filetosave);
%         ult_g = real(ult_g).';
%         ult_g(~mask) = 1;
%         max_g = max(ult_g(:));
%         mean_g = mean(ult_g(:));
%         title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
%         subplot(2,3,(irad + (ifield-1)*3));
%         imshow(ult_g,[]);
%         title(title_label)
%         set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
%         if irad == 1
%             ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
%         end
%     end
% end
% figure;
% for ifield = 1:length(fieldstrength_set)
%     for irad = 1:length(sphereradius_set)
%         acc_f = [1 4];
%         filetosave = [ './Results/DGF_SNR_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
%             num2str(fieldstrength_set(ifield)) 'T_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
%             '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lMax_' num2str(lmax) '.mat'];
%         load(filetosave);
%         ult_g = real(ult_g).';
%         ult_g(~mask) = 1;
%         max_g = max(ult_g(:));
%         mean_g = mean(ult_g(:));
%         title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
%         subplot(2,3,(irad + (ifield-1)*3));
%         imshow(ult_g,[]);
%         title(title_label)
%         set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
%         if irad == 1
%             ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
%         end
%     end
% end
% figure;
% for ifield = 1:length(fieldstrength_set)
%     for irad = 1:length(sphereradius_set)
%         acc_f = [1 6];
%         filetosave = [ './Results/DGF_SNR_sphere_' num2str(sphereradius_set(irad)*100) 'cm_radius_' ...
%             num2str(fieldstrength_set(ifield)) 'T_' num2str(matrix_size(1)) 'x' num2str(matrix_size(2))...
%             '_acc_' num2str(acc_f(1)) 'x' num2str(acc_f(2)) '_lMax_' num2str(lmax) '.mat'];
%         load(filetosave);
%         ult_g = real(ult_g).';
%         ult_g(~mask) = 1;
%         max_g = max(ult_g(:));
%         mean_g = mean(ult_g(:));
%         title_label = [ '[' sprintf('%0.3g',mean_g) ', ' sprintf('%0.3g',max_g) ']'];
%         subplot(2,3,(irad + (ifield-1)*3));
%         imshow(ult_g,[]);
%         title(title_label)
%         set(get(gca,'Title'),'FontSize',12,'FontWeight','bold')
%         if irad == 1
%             ylabel(['B_{0} = ' num2str(fieldstrength_set(ifield)) 'T']);
%         end
%     end
% end




% END DGF_sphere_plots.m
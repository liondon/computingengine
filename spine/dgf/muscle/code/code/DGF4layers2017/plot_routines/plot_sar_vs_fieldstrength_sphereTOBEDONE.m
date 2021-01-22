% plot_snr_vs_fieldstrength_sphere.m
%
% Plots SNR vs frequency from output of DGF_sphere_project
%
% Daniel K. Sodickson 9/16/07 for cylinder
% Riccardo Lattanzi 1/7/08 for sphere

lw = 3;
fs = 14;

if compute_coilSAR_pTx_flag,
    hp = zeros(nacc,matrix_size_set(nacc,1),matrix_size_set(nacc,2),2*nradout,2*nradin);
else
    hp = zeros(nacc,matrix_size_set(nacc,1),matrix_size_set(nacc,2),nradout,nradin);
end
legcell = {};
for irad = 1:nradout,
    if all(current_set{irad}==1),
        currstr = '(mag)';
    elseif all(current_set{irad}==2),
        currstr = '(elec)';
    else
        currstr = '(mag&elec)';
    end
    legcell{irad} = [sprintf('%3.0fcm ',100*outer_radius_set(irad)) currstr];
    if compute_coilSNR_flag && (length(current_set{irad})<2),
        legcell{irad+nradout} = [num2str(ncoils) '-element array, ' sprintf('%3.0fcm ',100*outer_radius_set(irad))];
    end
end
for iacc = 1:nacc,    
    for imat1 = 1:matrix_size(1),           
        for imat2 = 1:matrix_size(2),
            
            xvox = x_fov(imat1,imat2);
            yvox = y_fov(imat1,imat2);
            zvox = z_fov(imat1,imat2);
            rhovox = sqrt(xvox^2 + yvox^2 + zvox^2);
            phivox = (180/pi)*atan2(yvox,xvox);
            costhetavox = zvox/rhovox;
            costhetavox(isnan(costhetavox)) = 0;
            thetavox = acos(costhetavox);
            hf(imat1,imat2) = figure;                             
            set(gcf,'name',['uiSNR vs field, (rho,phi,theta)=(' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) 'deg,' num2str(thetavox,3) 'deg), ' num2str(acceleration_set(iacc,1)) 'x' num2str(acceleration_set(iacc,2))])
            if compute_coilSNR_flag,
                hp(iacc,imat1,imat2,:) = plot(fieldstrength_set(:),snr_ult(:,:,iacc,imat1,imat2),fieldstrength_set(:),snr_coil(:,:,iacc,imat1,imat2),'--o','linewidth',lw);
            else
                hp(iacc,imat1,imat2,:) = plot(fieldstrength_set(:),snr_ult(:,:,iacc,imat1,imat2),'linewidth',lw);   
            end
            xlabel('Field Strength (T)','fontsize',fs)
            ylabel('SNR','fontsize',fs)
            if include_circuit_noise,
                title(str2mat(['                    SNR vs Field Strength and Outer Radius'],...
                    ['(\rho,\phi,\theta)=(' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) '\circ,' num2str(thetavox*100,3) '\circ), R=' num2str(acceleration_set(iacc,1)) 'x' num2str(acceleration_set(iacc,2)) ...
                    ', inner radius = ' num2str(100*sphereradius,3) 'cm, \sigma_{coil} = ' num2str(sigma_coil,'%0.2g') 'S/m, NF = ' num2str(10*log10(noisefactor),2) ' (F = ' num2str(noisefactor,2) ')']),'fontsize',fs-2)
            else
                title(str2mat(['                    SNR vs Field Strength and Outer Radius'],...
                    ['(\rho,\phi,\theta)=(' num2str(rhovox*100,3) 'cm,' num2str(phivox,3) '\circ,' num2str(thetavox*100,3) '\circ), R=' num2str(acceleration_set(iacc,1)) 'x' num2str(acceleration_set(iacc,2)) ...
                    ', inner radius = ' num2str(100*sphereradius,3) 'cm, \sigma_{coil} = ' num2str(sigma_coil,'%0.2g') 'S/m']),'fontsize',fs-2)
            end
            grid
            set(gca,'fontsize',fs)
            legend(legcell,'fontsize',fs)
            drawnow                             
        end
    end                                    
end                                        
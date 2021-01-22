function M2 = rotM(M1,Be,dt)
% Function M2 = rotM(M1,Be,dt); 
% rotate 3D magnetization vector M1(Nx,Ny,Nz,3)
% about 3D effective B field Be(Nx,Ny,Nz,3) at every
% location Nx,Ny,Nz in space as in Bloch equation over time step dt
% 
% simple test example:
% Nx=5; Ny=5; Nz=5; M1=zeros(Nx,Ny,Nz,3); M1(:,:,:,3)=1; Be=zeros(Nx,Ny,Nz,3); Be(:,:,:,2)=2e-6; dt=.003;
% 
% cmc 7/1/05

temp=sqrt(Be(:,:,:,1).*Be(:,:,:,1)+Be(:,:,:,2).*Be(:,:,:,2)+Be(:,:,:,3).*Be(:,:,:,3));

% "-" means Left Hand Rotation

phi(:,:,:,3)=-2.6751e8*dt*temp; phi(:,:,:,2)=phi(:,:,:,3); phi(:,:,:,1)=phi(:,:,:,3);
axs(:,:,:,3)=Be(:,:,:,3)./temp; axs(:,:,:,2)=Be(:,:,:,2)./temp; axs(:,:,:,1)=Be(:,:,:,1)./temp;
clear temp;

temp(:,:,:,3)=axs(:,:,:,1).*M1(:,:,:,1).*axs(:,:,:,3)+axs(:,:,:,2).*M1(:,:,:,2).*axs(:,:,:,3)+axs(:,:,:,3).*M1(:,:,:,3).*axs(:,:,:,3);
temp(:,:,:,2)=axs(:,:,:,1).*M1(:,:,:,1).*axs(:,:,:,2)+axs(:,:,:,2).*M1(:,:,:,2).*axs(:,:,:,2)+axs(:,:,:,3).*M1(:,:,:,3).*axs(:,:,:,2);
temp(:,:,:,1)=axs(:,:,:,1).*M1(:,:,:,1).*axs(:,:,:,1)+axs(:,:,:,2).*M1(:,:,:,2).*axs(:,:,:,1)+axs(:,:,:,3).*M1(:,:,:,3).*axs(:,:,:,1);

M2=M1.*cos(phi)+temp.*(1-cos(phi))+cross(axs,M1,4).*sin(phi);




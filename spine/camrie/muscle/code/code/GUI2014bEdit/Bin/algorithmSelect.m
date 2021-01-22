function algorithmSelect(run, handles)
global X Bnuc 

if get(handles.algorithmSelect,'value')==1
    
    % Algorithm developed by Rahul
    
    % Setup matrix size parameters
    %  susc = susceptibility distribution (should be standard cubical size,
    %  like 128x128x128 or 256x256x256)
    %  suscBackground = background value of susceptibility distribution
    %  (usually air, 0.4 ppm)
    %  Output:
    %  B0Image = dB0 field
    suscBackground=.4e-06;
    
    
    [xRes yRes zRes] = size(X);
    
    % Setup Green's function modifier matrix (called kMod here)
    
    origin = [xRes yRes zRes] ./2 + 1;
    [ky kx kz] = meshgrid(1:yRes, 1:xRes, 1:zRes);
    kx = kx - origin(1);
    ky = ky - origin(2);
    kz = kz - origin(3);
    pause(.001);
    set(handles.status,'String','Processing..');
    pause(.001);
    kr2 = kx.^2 + ky.^2 + kz.^2;
    kModImage = 1./(4.*pi) .* (3.*kz.^2 - kr2) ./ (kr2.^(5/2));
    kModImage(origin(1), origin(2), origin(3)) = 0;
    pause(.001);
    set(handles.status,'String','Processing...');
    pause(.001);
    kMod = fftshift((fftn(fftshift(kModImage))));
    pause(.001);
    set(handles.status,'String','Processing.');
    pause(.001);
    
    % Calculate dB0 field from susceptibility
    
    Bnuc = kMod .* fftshift(fftn(X));
    pause(.001);
    set(handles.status,'String','Processing..');
    pause(.001);
    Bnuc(origin(1), origin(2), origin(3)) = ...
        suscBackground ./ 3 .* xRes .* yRes .* zRes;   % background correction as per Marques/Bowtell
    Bnuc = real(ifftn(ifftshift(Bnuc)));
    Bnuc=real(Bnuc);
else
    Bnuc=fftshift(X);
    Bnuc=fftn(Bnuc);
    pause(.001);
    set(handles.status,'String','Processing..');
    pause(.001);
    clear X
    Bnuc=fftshift(Bnuc);
    p=((size(Bnuc)/2)+.5);
    pause(.001);
    set(handles.status,'String','Processing...');
    pause(.001);
    %build k matrix
    s=size(Bnuc);
    [x,y,z] = ndgrid(1:s(1,1),1:s(1,2),1:s(1,3));
    kznorm=(z-p(1,3)).^2./((x-p(1,1)).^2+(y-p(1,2)).^2+(z-p(1,3)).^2);
    clear p l s
    kznorm=1/3-kznorm;
    clear x y z;
    pause(.001);
    set(handles.status,'String','Processing.');
    pause(.001);
    Bnuc=kznorm.*Bnuc;
    clear kznorm;
    Bnuc=ifftshift(Bnuc);
    pause(.001);
    set(handles.status,'String','Processing..');
    pause(.001);
    Bnuc=ifftn(Bnuc);
    Bnuc=ifftshift(Bnuc);
end
if run~=0
   disp('woot') 
end
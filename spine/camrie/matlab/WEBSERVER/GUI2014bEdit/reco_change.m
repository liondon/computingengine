nRx=1;
histSteps = 256;

%for signal file
if nRx==1
    [filename,pathname]=uigetfile('*.ksig','OPEN: K-space');
    if filename==0
        return;
    end
elseif nRx>1
    [filenameM,pathname]=uigetfile('*.ksig','OPEN: K-space','Multiselect','on');
    
    if isnumeric(filenameM)
        return;
    end
    
    if nRx~=size(filenameM,2)
        msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
        return;
    end
    
    filename=cell2mat(filenameM(1,1));
end
gData.cd_dir=pathname;

fileName=[pathname,filename];
fid=fopen(fileName);
[k_data,cnt]=fread(fid,[2,Inf],'float32');
fclose(fid);

% parameter file reading
protFileName=[fileName(1,1:length(fileName)-6) '.prot'];
fid=fopen(protFileName);

protData=fgetl(fid);

while ischar(protData)
    protData=fgetl(fid);
    
    if ischar(protData)==0
        break;
    end
    
    % Number of Rx
    if strcmp(strtrim(protData),'# Rx:')
        nRx_prot=str2num(fgetl(fid));
    end
    
    %Slice orientation (1=axial, 2=sagittal, 3=coronal)
    if strcmp(strtrim(protData),'Slice Orientation:')
        sliceTemp=fgetl(fid);
        
        if strcmp(strtrim(sliceTemp),'Axial')
            sliceKey=1;
        elseif strcmp(strtrim(sliceTemp),'Sagittal')
            sliceKey=2;
        elseif strcmp(strtrim(sliceTemp),'Coronal')
            sliceKey=3;
        end        
    end
    %FOV offset
    if strcmp(strtrim(protData),'FOV Offset:')
        void=fgetl(fid);
        Xoffset=str2num(fgetl(fid));
        void=fgetl(fid);
        Yoffset=str2num(fgetl(fid));
        void=fgetl(fid);
        Zoffset=str2num(fgetl(fid));
        clear void
    end
    if strcmp(strtrim(protData),'Sample Min:')
        void=fgetl(fid);
        Xmin=str2num(fgetl(fid));
        void=fgetl(fid);
        Ymin=str2num(fgetl(fid));
        void=fgetl(fid);
        Zmin=str2num(fgetl(fid));
        clear void
    end
    if strcmp(strtrim(protData),'Sample Max:')
        void=fgetl(fid);
        Xmax=str2num(fgetl(fid));
        void=fgetl(fid);
        Ymax=str2num(fgetl(fid));
        void=fgetl(fid);
        Zmax=str2num(fgetl(fid));
        clear void
    end
    
    %Matrix size
    if strcmp(strtrim(protData),'MatSize:')
        mSizeLocal=str2num(fgetl(fid));
%         eval(['gData.mSizeLocal',num2str(viewPortIndex),'=mSizeLocal;']);
    end
    
    %PE Direction (0=no rotation, 1=rotation type 1, 2=rotation type 2)
    % Type 1: rot90(~,-1)
    % Type 2: flipLR
    if strcmp(strtrim(protData),'PE Direct:')
        PETemp=fgetl(fid);
        
        if strcmp(strtrim(PETemp),'P--A')
            if sliceKey==1
                peKey=1;
            elseif sliceKey==2
                peKey=2;
            end
        elseif strcmp(strtrim(PETemp),'L--R')
            if sliceKey==1
                peKey=2;
            elseif sliceKey==3
                peKey=2;
            end
        elseif strcmp(strtrim(PETemp),'F--H')
            if sliceKey==2
                peKey=1;
            elseif sliceKey==3
                peKey=1;
            end
        end        
    end
end
fclose(fid);

% eval(['gData.sliceKey',num2str(viewPortIndex),'=sliceKey;']);
% eval(['gData.peKey',num2str(viewPortIndex),'=peKey;']);

% if nRx>nRx_prot
%     msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
%     set(handles.nRx,'string',num2str(8));
%     eval(['gData.nRx',num2str(viewPortIndex),'=8;']);
%     return;
% end

%for noise file
%cd(gData.cd_dir);
noiseKey=0;
% eval(['gData.noiseKey',num2str(viewPortIndex),'=0;']);
% set(handles.noiseSF,'string',num2str(0));
% eval(['noiseSF=gData.noiseSF',num2str(viewPortIndex),';']);

if nRx==1
    [filename_noise,pathname_noise]=uigetfile('*.nois','OPEN: Noise');
    if filename_noise==0
        %return;
    else
        noiseKey=1;
%         eval(['gData.noiseKey',num2str(viewPortIndex),'=1;']);
    end
    
elseif nRx>1
    [filename_noiseM,pathname_noise]=uigetfile('*.nois','OPEN: Noise','Multiselect','on');
    
    if isnumeric(filename_noiseM)
        %return;
    else
        noiseKey=1;
%         eval(['gData.noiseKey',num2str(viewPortIndex),'=1;']);
        
        if nRx~=size(filename_noiseM,2)
            msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
            return;
        end
    end
end

if nRx==1    
    k_data=reshape(k_data(1,:)+1i*k_data(2,:),mSizeLocal(1),mSizeLocal(2));
    if strcmp(strtrim(PETemp),'P--A')
        switch sliceKey %set up coordinate sytem
            case 1 
                y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
                x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
            case 2
                y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
                x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
        end
    elseif strcmp(strtrim(PETemp),'F--H')
        switch sliceKey %set up coordinate sytem
            case 2
                x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
                y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
            case 3
                x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
                y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
        end
    elseif strcmp(strtrim(PETemp),'L--R')
        switch sliceKey %set up coordinate sytem
            case 1 
                x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
                y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
            case 3
                y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
                x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
        end
    end
%     if peKey==1
        for i=1:mSizeLocal(1) %shift FOV along y
            k_data(i,:)=k_data(i,:)*exp(1i*2*pi*(y/mSizeLocal(1))*(i-mSizeLocal(1)/2));
        end
        for j=1:mSizeLocal(2) %shift FOV along x
            k_data(:,j)=k_data(:,j)*exp(1i*2*pi*(x/mSizeLocal(2))*(j-mSizeLocal(2)/2));
        end
%     else
%         for i=1:mSizeLocal(1) %shift FOV along x
%             k_data(i,:)=k_data(i,:)*exp(1i*2*pi*(y/mSizeLocal(1))*(i-mSizeLocal(1)/2));
%         end
%         for j=1:mSizeLocal(2) %shift FOV along y
%             k_data(:,j)=k_data(:,j)*exp(1i*2*pi*(x/mSizeLocal(2))*(j-mSizeLocal(2)/2));
%         end
%     end
    if noiseKey
        fileName_noise=[pathname_noise,filename_noise];
        fid=fopen(fileName_noise);
        [noise_data,cnt]=fread(fid,[2,Inf],'float32');
        fclose(fid);
        
        k_data_clean=k_data;
        noise_data=reshape(noise_data(1,:)+1i*noise_data(2,:),mSizeLocal(1),mSizeLocal(2));
        
%         eval(['gData.noiseSF',num2str(viewPortIndex),'=1;']);
%         set(handles.noiseSF,'string','1');
        k_data=k_data+noise_data*1;
    end
    
    qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
    
    im_data=fftshift(fft2(fftshift(k_data)));

    if peKey==1
        im_data=rot90(im_data,-1);
    elseif peKey==2
        im_data=fliplr(im_data);
    end
    
    qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
    
%     eval(['assignin(''base'',''kSpace',num2str(viewPortIndex),''',k_data);']);
%     eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
%     eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
%     eval(['gData.vPort',num2str(viewPortIndex),'Kspace=k_data;']);
%     if noiseKey
%         eval(['gData.vPort',num2str(viewPortIndex),'Kspace=k_data_clean;']);
%         eval(['gData.vPort',num2str(viewPortIndex),'Noise=noise_data;']);
%     end
%     eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
%     eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
%     eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
%     eval(['gData.w_sliderVal',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.c_sliderVal',num2str(viewPortIndex),'=histSteps/2;']);
%     eval(['gData.w_sliderValK',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.c_sliderValK',num2str(viewPortIndex),'=histSteps/2;']);
%     set(handles.w_slider,'value',histSteps);
%     set(handles.c_slider,'value',histSteps/2);
%     set(handles.w_box,'string',num2str(histSteps));
%     set(handles.c_box,'string',num2str(histSteps/2));
%     eval(['gData.imMax',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.imMin',num2str(viewPortIndex),'=0;']);
%     eval(['gData.imMaxK',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.imMinK',num2str(viewPortIndex),'=0;']);
%     
%     eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
%     imagesc(abs(qImage));
%     axis image;
%     axis off;
%     colormap(gray);
    
    %set check-box status
%     set(handles.im_mag,'enable','on');
%     set(handles.im_phs,'enable','on');
%     set(handles.im_real,'enable','on');
%     set(handles.im_imag,'enable','on');
%     set(handles.ksp_mag,'enable','on');
%     set(handles.ksp_real,'enable','on');
%     set(handles.ksp_imag,'enable','on');
    
elseif nRx>1
    k_data=zeros(mSizeLocal(1),mSizeLocal(2));
    k_data_ch=zeros(nRx,mSizeLocal(1),mSizeLocal(2));
    im_data=zeros(mSizeLocal(1),mSizeLocal(2));
    im_data_ch=zeros(nRx,mSizeLocal(1),mSizeLocal(2));
%     eval(['gData.vPort',num2str(viewPortIndex),'Kspace=[];']);
%     eval(['gData.vPort',num2str(viewPortIndex),'Noise=[];']);
    
    for t=1:nRx
        %signal file
        fileNameTemp=cell2mat(filenameM(1,t));
        fileNameTemp=fileNameTemp(1,1:length(fileNameTemp)-6);
        fileName=[pathname,fileNameTemp,num2str(t),'.ksig'];
        fid=fopen(fileName);
        [k_data_read,cnt]=fread(fid,[2,Inf],'float32');
        fclose(fid);
        
        k_dataTemp=reshape(k_data_read(1,:)+1i*k_data_read(2,:),mSizeLocal(1),mSizeLocal(2));
        
%         eval(['gData.vPort',num2str(viewPortIndex),'Kspace(t,:,:)=k_dataTemp;']);
        
        if t==1
            k_avg=mean2(abs(k_dataTemp(1:round(mSizeLocal/4),:)));
        end
        
        if noiseKey
            %noise file
            fileNameTemp=cell2mat(filename_noiseM(1,t));
            fileNameTemp=fileNameTemp(1,1:length(fileNameTemp)-6);
            fileName=[pathname_noise,fileNameTemp,num2str(t),'.nois'];
            fid=fopen(fileName);
            [noise_data,cnt]=fread(fid,[2,Inf],'float32');
            fclose(fid);
            
            noise_data=reshape(noise_data(1,:)+1i*noise_data(2,:),mSizeLocal(1),mSizeLocal(2));
%             eval(['gData.vPort',num2str(viewPortIndex),'Noise(t,:,:)=noise_data;']);
            
%             eval(['gData.noiseSF',num2str(viewPortIndex),'=1;']);
%             set(handles.noiseSF,'string','1');
            k_dataTemp=k_dataTemp+noise_data*1;
        end
        
        k_data_ch(t,:,:)=k_dataTemp;
        im_DataTemp=ifftshift(ifft2(ifftshift(k_dataTemp)));
        
        if peKey==1
            im_DataTemp=rot90(im_DataTemp,-1);
        elseif peKey==2
            im_DataTemp=fliplr(im_DataTemp);
        end
        
        im_data_ch(t,:,:)=im_DataTemp;
        
        if sumMethod==1 %Sum of Square
            im_data=im_data+abs(im_DataTemp).^2;
            k_data=k_data+abs(k_dataTemp).^2;
        elseif sumMethod==2 %Sum of Magnitude
            im_data=im_data+abs(im_DataTemp);
            k_data=k_data+abs(k_dataTemp);
        end
    end
    
    if sumMethod==1 %Sum of Square
        im_data=sqrt(im_data);
    elseif sumMethod==2 %Sum of Magnitude
        im_data=im_data/1;
    end
    
    qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
    qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
    
%     eval(['assignin(''base'',''kSpace',num2str(viewPortIndex),''',k_data_ch);']);
%     eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
%     eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
%     eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
%     eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
%     eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
%     eval(['gData.w_sliderVal',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.c_sliderVal',num2str(viewPortIndex),'=histSteps/2;']);
%     set(handles.w_slider,'value',histSteps);
%     set(handles.c_slider,'value',histSteps/2);
%     set(handles.w_box,'string',num2str(histSteps));
%     set(handles.c_box,'string',num2str(histSteps/2));
%     eval(['gData.imMax',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.imMin',num2str(viewPortIndex),'=0;']);
%     eval(['gData.imMaxK',num2str(viewPortIndex),'=histSteps;']);
%     eval(['gData.imMinK',num2str(viewPortIndex),'=0;']);
%     
%     eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
%     imagesc(abs(qImage));
%     axis image;
%     axis off;
%     colormap(gray);
end

% set(handles.im_mag,'value',1);
% set(handles.im_phs,'value',0);
% set(handles.im_real,'value',0);
% set(handles.im_imag,'value',0);
% set(handles.ksp_mag,'value',0);
% set(handles.ksp_real,'value',0);
% set(handles.ksp_imag,'value',0);
% 
% set(handles.w_slider,'enable','on');
% set(handles.c_slider,'enable','on');
% set(handles.w_box,'enable','on');
% set(handles.c_box,'enable','on');
% 
% eval(['gData.subKey',num2str(viewPortIndex),'=0;']);

%histogram (Image)
% axes(handles.hist_axes5);
im_data1D=reshape(abs(im_data),1,mSizeLocal(1)*mSizeLocal(2));
% [hist_result,cnt]=hist(im_data1D,histSteps);
% plot(hist_result,'r','linewidth',2);
% axis off;
% yLimVal=gData.yLimVal;
% rectangle('Position',[0,1,histSteps,yLimVal-2],'Edgecolor','k','linestyle',':');
% line([histSteps/2 histSteps/2],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
% xlim([0 histSteps]);
% ylim([0 yLimVal]);
% eval(['gData.hist_result',num2str(viewPortIndex),'=hist_result;']);

%histogram (kspace)
k_data1D=reshape(abs(k_data),1,mSizeLocal(1)*mSizeLocal(2));
% [hist_result,cnt]=hist(k_data1D,histSteps);
% eval(['gData.hist_resultK',num2str(viewPortIndex),'=hist_result;']);

if nRx>1
%     figure;
%     set(gcf,'color','w');
    
    if nRx==2
%         for t=1:nRx
%             subplot(1,2,t);
%             imagesc(abs(squeeze(im_data_ch(t,:,:))));
%             axis image;
%             axis off;
%             colormap(gray);
%         end
    elseif nRx==3 || nRx==4
%         for t=1:nRx
%             subplot(2,2,t);
%             imagesc(abs(squeeze(im_data_ch(t,:,:))));
%             axis image;
%             axis off;
%             colormap(gray);
%         end
    elseif nRx>=5 && nRx<=9
%         for t=1:nRx
%             subplot(3,3,t);
%             imagesc(abs(squeeze(im_data_ch(t,:,:))));
%             axis image;
%             axis off;
%             colormap(gray);
%         end
    elseif nRx>=10 && nRx<=16
%         for t=1:nRx
%             subplot(4,4,t);
%             imagesc(abs(squeeze(im_data_ch(t,:,:))));
%             axis image;
%             axis off;
%             colormap(gray);
%         end
    end
    
end


saveFileName=[fileName(1,1:length(fileName)-6) '.mat'];
save(saveFileName, 'im_data', 'k_data');
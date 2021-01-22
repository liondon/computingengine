
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       GRE with ideal/real spoiling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GRE_ktPts(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)
    
idealDephasing = 1;
    %% Init
    MatSize1=MatSize.value(1);
    MatSize2=MatSize.value(2);

    FOV1=FOV.value(1);
    FOV2=FOV.value(2);
    
    startTime = 0.001; %ms
    gamma = 42576000.0 * 2 * pi; %Hz/T
    GMax = 22; %mT/m
    
    ADC.duration = MatSize1/ADC.BW; %ms
    
    
    %% Return SeqData
    if nargout == 1
        
%         clear RF;
        RF.Freq = 1/1e-3; % kHz

        temp = load ('H:\PSUdoMRI\GUI2012a\SeqDev\User\GRE_ktPts\NewKT_RF.mat');
%         temp = load ('H:\PSUdoMRI\GUI2012a\SeqDev\User\GRE_ktPts\Shim_RF.mat');
        
        ktRF = 0 .* temp.Expression1;
        for n=1:8
            ktRF(n,:) = temp.Expression1(n,:) .* exp(1i * n * pi/4) * 5.8718524e-007 * 150 / 25 * RF.FA; % for kTPoints & Shim
%           ktRF(n,:) = temp.Expression1(n,:) ./ temp.Expression1(n,20) * 0.4317 / 90 * 33 .* exp(1i * n * pi/4) * 5.8718524e-007 * 150 /25 * RF.FA; % For Quard
        end;
        
        ratio = 1;
        ktRF = ktRF ./ ratio;
        
        temp = load ('H:\PSUdoMRI\GUI2012a\SeqDev\User\GRE_ktPts\NewKT_G.mat');
        ktGrad = temp.Expression1 / ratio;
%         ktGrad = repmat(ktRF .* 0,[3,1]);

        RF.Freq = RF.Freq / ratio;
        RF.Duration = size(ktRF,2) / RF.Freq;
        RF.Num = size(ktRF,2);
        frqOffset = 0;
        numTx = 8;

%         tempRF_Y = ktRF(1,:);
        tempRF_Y = ktRF;
        
        %% Waveform plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                       GRE_ktPts Sequence Diagram
%
%           |----------------------TE----------------------|
%
%  RF --|  RF  |-----------------------------------------------------------
%
%  Gz --| ktGz |----------------------------------------------------------
%
%  Gy --| ktGy |------------|GradPE|---------------------------------------
%
%  Gx --| ktGx |----------------------------|GradprePh|-|GradFE|-----------
%
% ADC --------------------------------------------------| ADC  |-----------
% 
%     |------------------------------TR-----------------------------------|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Dummy tStep
        if dummy>0
            varargout{1}.Dummy.tStep = [startTime, ones(1,RF.Num)/RF.Freq,...
                TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        end;
        
        %% RF pulse
        varargout{1}.Main.RF.dPhs = 0;
        varargout{1}.Main.RF.tStep = [startTime, ones(1,RF.Num)/RF.Freq,...
            TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.RF.value = [zeros(numTx,1),tempRF_Y,zeros(numTx,1)];
        
        if dummy>0
            varargout{1}.Dummy.RF.dPhs = 0;
            varargout{1}.Dummy.RF.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.RF.value = [zeros(numTx,1),tempRF_Y,zeros(numTx,1)];
        end;
        
        %% RF DFreq
        varargout{1}.Main.DFreq.tStep = [startTime, ones(1,RF.Num)/RF.Freq,...
            TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.DFreq.value = [zeros(numTx,1), ones(numTx,RF.Num)*frqOffset, zeros(numTx,1)];
        if dummy>0
            varargout{1}.Dummy.DFreq.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.DFreq.value = [zeros(numTx,1), ones(numTx,RF.Num)*frqOffset, zeros(numTx,1)];
        end;
        
        %% ADC
        varargout{1}.Main.ADC.tStep = [startTime,TE+RF.Duration/2-ADC.duration/2,...
            ones(1,MatSize1)/ADC.BW,TR-TE-RF.Duration/2-startTime-ADC.duration/2]; % ms

        if (idealDephasing == 1)
           % Ideal Spoiling
           varargout{1}.Main.ADC.value = [-2,0,ones(1,MatSize1),0];
        else        
           % Real Spoiling
           varargout{1}.Main.ADC.value = [-1,0,ones(1,MatSize1),0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.ADC.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.ADC.value = [-1,0,zeros(1,MatSize1),0];
        end;

        %% Slice Selection gradient
        if GradOn.ss == 1
            
            varargout{1}.Main.Gss.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
                TR-startTime-RF.Duration]; % ms
            varargout{1}.Main.Gss.value = [0,ktGrad(3,:),0];
        else
            Gss.duration = 0;
            Gss.reph.duration = 0;
            varargout{1}.Main.Gss.tStep = [startTime,TR-startTime]; % ms
            varargout{1}.Main.Gss.value = [0,0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gss.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gss.value = zeros(1,(2+RF.Num));
        end;

        %% Phase Encoding gradient
        if GradOn.pe == 1
            Gpe.duration = 1/(FOV2/1000)/gamma*2*pi/(2*(1.5*GMax)/(MatSize2-1)/1000)*1000; %ms, Page 239
            
            if MatSize2~=1
                Gpe.delAmp = 2*(1.5*GMax)/(MatSize2-1); %mT/m
            else
                Gpe.delAmp = 0;
            end;
            
            varargout{1}.Main.Gpe.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
                Gpe.duration,TR-RF.Duration-Gpe.duration-startTime];
            varargout{1}.Main.Gpe.value = [0,ktGrad(2,:),-1.5*GMax,0];
            varargout{1}.Main.Gpe.increment = [0,zeros(1,RF.Num),Gpe.delAmp,0]; % Abs Value
        else
            Gpe.duration = 0;
            varargout{1}.Main.Gpe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gpe.value = [0,0];
            varargout{1}.Main.Gpe.increment = [0,0]; % Abs Value
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gpe.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gpe.value = zeros(1,(2+RF.Num));
        end;
            
        %% Frequency Encoding gradient
        if GradOn.fe == 1
            Gfe.preph.duration = ADC.duration/2/10; %ms % Match Line 214 Below
            Gfe.amp = 1/gamma*2*pi*(ADC.BW*1000)/(FOV1/1000)*1000; %mT/m, Page 238
            Gfe.duration = MatSize1/ADC.BW; %ms
            Gfe.prephAmp = -Gfe.amp*Gfe.duration/2/Gfe.preph.duration; %mT/m
            
            if (idealDephasing == 1)
                % Ideal Spoiling
                varargout{1}.Main.Gfe.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
                    TE-RF.Duration/2-ADC.duration/2-Gfe.preph.duration,...
                    Gfe.preph.duration,ones(1,MatSize1)/ADC.BW,TR-startTime-TE-RF.Duration/2-ADC.duration/2]; %ms
                varargout{1}.Main.Gfe.value = [0,ktGrad(1,:),0,Gfe.prephAmp,Gfe.amp*ones(1,MatSize1),0];
            end;
            
        else
            varargout{1}.Main.Gfe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gfe.value = [0,0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gfe.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gfe.value = zeros(1,(2+RF.Num));
        end;
        
        %%
        varargout{1}.TR = TR; %ms
        varargout{1}.Main.repeat = MatSize2;
        varargout{1}.Dummy.repeat = dummy;
    end;

    %% Return [minTE, minTR]
    if nargout == 2
        if GradOn.pe == 1
            Gpe.duration = 1/(FOV2/1000)/gamma*2*pi/(2*(1.5*GMax)/(MatSize2-1)/1000)*1000; %ms, Page 239
        else
            Gpe.duration = 0;
        end;
        
        if GradOn.ss == 1
            Gss.reph.duration = RF.Duration/2/5;
        else
            Gss.reph.duration = 0;
        end;
        
        if GradOn.fe == 1
            Gfe.preph.duration = ADC.duration/2/10; %ms % Match Line 162 Above
        else
            Gfe.preph.duration = 0;
        end;
        
        % minTE
        varargout{1} = RF.Duration/2 + max([Gss.reph.duration,Gpe.duration,Gfe.preph.duration]) + ADC.duration/2; %ms
        
        if TE<varargout{1}
            TE = varargout{1};
        end;

        % minTR
        if (idealDephasing == 1)
            varargout{2} = startTime+RF.Duration/2+ADC.duration/2+TE; %ms
        else
            Gfe.spoiler.duration = MatSize1/ADC.BW/5;
            varargout{2} = startTime+RF.Duration/2+ADC.duration/2+TE+Gfe.spoiler.duration; %ms
        end;
    end;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           Single Shot GRE_EPI
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GRE_EPI_old(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)

    %% Init
    MatSize1=MatSize.value(1);
    MatSize2=MatSize.value(2);

    FOV1=FOV.value(1);
    FOV2=FOV.value(2);
    
    startTime = 0.001; %ms
    gamma = 42576000.0 * 2 * pi; %Hz/Tm
    gammaBar = 42576000.0; %Hz/Tm
    GMax = 22; %mT/m
    
    ADC.duration = MatSize1*MatSize2/ADC.BW + (MatSize2-1)/(FOV2/1000)/gammaBar/(GMax/1000)*1000; %ms
    
    frqBW = 4/RF.Duration*1000; % RF.Duration = 4/frqBW*1000; % ms
    Gss.amp = frqBW * 2*pi / gamma / slice.TH * 1000; % frqBW = (Gss.amp/1000) * slice.TH * gamma /2/pi; % Gss.amp in mT/m
    frqOffset = (Gss.amp/1000) * slice.offset * gamma /2/pi;    
    RF.Freq = RF.Num / RF.Duration; % kHz

    %% Return SeqData
    if nargout == 1
        switch RF.Shape
            case 1 % 'Sinc'
                tempRF_X = -(2/frqBW):(4/frqBW/(RF.Num-1)):(2/frqBW);
                tempRF_Y = sinc(tempRF_X * frqBW);
                clear tempRF_X;
            case 2 % 'Rect'
                tempRF_Y = ones(1,RF.Num);
                frqOffset = 0;
            case 3 % 'Gauss'
                tempRF_Y = (gausswin(RF.Num))';
        end;
        tempRF_Size = sum(tempRF_Y)/(RF.Freq*1000); % 1/RF.Freq = RF.Duration/RF.Num;
        RF.factor(1) = (RF.FA/180*pi)/gamma/tempRF_Size;
        tempRF_Y = tempRF_Y .* RF.factor(1);
        
        %% Waveform plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            EPI Sequence Diagram
%
%           |-------------------------------TE------------------------------|
%
%  RF --|  RF  |-------------------------------------------------------------------------------------------
%
%  Gs --|GradSS|-|GradRephSS|------------------------------------------------------------------------------
%
%  Gp ------------------------|GradPrePE|-------------------| | | | | | | GradPE | | | | | | |-------------
%
%  Gr -----------------------------------------|GradPreFE|-| | | | | | |  GradFE  | | | | | | | -----------
%
% ADC -----------------------------------------------------|                ADC               |------------
% 
%     |----------------------------------------------TR---------------------------------------------------|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% Dummy tStep
        if dummy>0
            varargout{1}.Dummy.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
                TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        end;
        
        %% RF pulse
        varargout{1}.Main.RF.dPhs = 0;
        varargout{1}.Main.RF.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
            TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.RF.value = [0+0i,tempRF_Y.*(1+0i),0+0i];
        
        if dummy>0
            varargout{1}.Dummy.RF.dPhs = 0;
            varargout{1}.Dummy.RF.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.RF.value = [0+0i,tempRF_Y.*(1+0i),0+0i];
        end;
        
        %% RF DFreq
        varargout{1}.Main.DFreq.tStep = [startTime,ones(1,RF.Num)/RF.Freq,...
            TR-startTime-RF.Duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.DFreq.value = [0,ones(1,RF.Num)*frqOffset,0];
        if dummy>0
            varargout{1}.Dummy.DFreq.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.DFreq.value = [0,ones(1,RF.Num)*frqOffset,0];
        end;
                        
        %% ADC
        temp1 = ones(1,(MatSize1+1)*MatSize1-1)/ADC.BW;
        for n=1:(MatSize1-1)
           temp1(1,(MatSize1+1)*n) = 1/(FOV1/1000)/gammaBar/(GMax/1000)*1000;
        end;

        ADC.value = ones(1,(MatSize1+1)*MatSize1-1);
        for n=1:(MatSize1-1)
            ADC.value(1,(MatSize1+1)*n) = 0;
        end;

        varargout{1}.Main.ADC.tStep = [startTime,TE+RF.Duration/2-ADC.duration/2,...
            temp1,TR-startTime-TE-RF.Duration/2-ADC.duration/2]; % ms
        varargout{1}.Main.ADC.value = [-2,0,ADC.value,0];
        
        if dummy>0
            varargout{1}.Dummy.ADC.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.ADC.value = [-2, zeros(1,(1+RF.Num))];
        end;

        %% Slice Selection gradient
        if GradOn.ss == 1
            Gss.reph.duration = RF.Duration/2/5;
            Gss.duration = RF.Duration;
            Gss.rephAmp = -Gss.amp*Gss.duration/2/Gss.reph.duration;
            varargout{1}.Main.Gss.tStep = [startTime,Gss.duration,Gss.reph.duration,...
                TR-startTime-Gss.duration-Gss.reph.duration]; % ms
            varargout{1}.Main.Gss.value = [0,Gss.amp,Gss.rephAmp,0];
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
            Gpe.preph.duration = (MatSize2/2-0.5)/(FOV2/1000)/gammaBar/(GMax/1000)*1000; %ms, Page 239
            Gpe.preph.value = -GMax;
                        
            Gpe.duration = ones(1,(MatSize2+1)*MatSize2-1)/ADC.BW;
            for n=1:(MatSize2-1)
                Gpe.duration(1,(MatSize2+1)*n) = 1/(FOV2/1000)/gammaBar/(GMax/1000)*1000;
            end;
            Gpe.value = zeros(1,(MatSize2+1)*MatSize2-1);
            for n=1:(MatSize2-1)
                Gpe.value(1,(MatSize2+1)*n) = GMax;
            end;
            
            varargout{1}.Main.Gpe.tStep = [startTime,RF.Duration,...
                Gpe.preph.duration,TE-RF.Duration/2-ADC.duration/2-Gpe.preph.duration,...
                Gpe.duration,TR-TE-startTime-RF.Duration/2-ADC.duration/2];
            varargout{1}.Main.Gpe.value = [0,0,Gpe.preph.value,0,Gpe.value,0];
            varargout{1}.Main.Gpe.increment = 0 * varargout{1}.Main.Gpe.value;
        else
            Gpe.duration = 0;
            varargout{1}.Main.Gpe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gpe.value = [0,0];
            varargout{1}.Main.Gpe.increment = [0,0]; % Abs Value
        end;
        
        % sum(Gpe.duration)==ADC.duration
        
        if dummy>0
            varargout{1}.Dummy.Gpe.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gpe.value = zeros(1,(2+RF.Num));
        end;
            
        %% Frequency Encoding gradient
        if GradOn.fe == 1
            Gfe.preph.duration = MatSize1/2/(FOV1/1000)/gammaBar/(GMax/1000)*1000; %ms
            Gfe.prephAmp = GMax; %mT/m
            Gfe.amp = 1/(FOV1/1000)/gammaBar/(1/ADC.BW/1000)*1000; %mT/m
            
            Gfe.duration = Gpe.duration;
            Gfe.value = Gfe.amp*ones(1,(MatSize1+1)*MatSize1-1);
            for n=1:MatSize1
                if n ~= MatSize1
                    Gfe.value(1,(MatSize1+1)*n) = 0;
                end;
                if mod(n,2)==0
                    tempMat = Gfe.value(1,((MatSize1+1)*(n-1)+1):((MatSize1+1)*n-1));
                    Gfe.value(1,((MatSize1+1)*(n-1)+1):((MatSize1+1)*n-1)) = -tempMat;
                end;
            end;
            
            clear tempMat;

            varargout{1}.Main.Gfe.tStep = [startTime,TE+RF.Duration/2-Gfe.preph.duration-ADC.duration/2,...
                Gfe.preph.duration,Gfe.duration,TR-startTime-TE-RF.Duration/2-ADC.duration/2]; %ms
            varargout{1}.Main.Gfe.value = [0,0,-Gfe.prephAmp,Gfe.value,0];
        else
            Gfe.preph.duration = 0;
            Gfe.duration = 0;
            varargout{1}.Main.Gfe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gfe.value = [0,0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gfe.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gfe.value = zeros(1,(2+RF.Num));
        end;
        
        %%
        varargout{1}.TR = TR; %ms
        varargout{1}.Main.repeat = 1;
        varargout{1}.Dummy.repeat = dummy;
    end;

    %% Return [minTE, minTR]
    if nargout == 2
        if GradOn.pe == 1
            Gpe.preph.duration = (MatSize2/2-0.5)/(FOV2/1000)/gammaBar/(GMax/1000)*1000;
        else
            Gpe.preph.duration = 0;
        end;
        
        if GradOn.ss == 1
            Gss.reph.duration = RF.Duration/2/5;
        else
            Gss.reph.duration = 0;
        end;
        
        if GradOn.fe == 1
            Gfe.preph.duration = MatSize1/2/(FOV1/1000)/gammaBar/(GMax/1000)*1000; %ms
        else
            Gfe.preph.duration = 0;
        end;
        
        % minTE
        varargout{1} = RF.Duration/2 + max([Gss.reph.duration,Gpe.preph.duration,Gfe.preph.duration]) + ADC.duration/2; %ms
        
        if TE<varargout{1}
            TE = varargout{1};
        end;

        % minTR
        varargout{2} = startTime+RF.Duration/2+ADC.duration/2+TE; %ms
    end;

end

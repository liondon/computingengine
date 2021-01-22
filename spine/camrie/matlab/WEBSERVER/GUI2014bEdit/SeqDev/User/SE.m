
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       SE with ideal/real spoiling
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = SE(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)

idealDephasing = 1;
DEBUG = 1; % 1: None selective refocusing

%% Init
    MatSize1=MatSize.value(1);
    MatSize2=MatSize.value(2);

    FOV1=FOV.value(1);
    FOV2=FOV.value(2);
    
    startTime = 0.001; %ms
    gamma = 42576000.0 * 2 * pi; %Hz/T
    GMax = 22; %mT/m
    
    ADC.duration = MatSize1/ADC.BW; %ms
    
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
        tempRF_Y1 = tempRF_Y .* RF.factor(1);
        
%         if DEBUG == 1
%             tempRF_X = -(2/frqBW):(4/frqBW/(80-1)):(2/frqBW);
%             tempRF_Y = sinc(tempRF_X * frqBW);
%             tempRF_Size = sum(tempRF_Y)/(RF.Freq*1000); % 1/RF.Freq = RF.Duration/RF.Num;
%         end;

        RF.factor(2) = (180/180*pi)/gamma/tempRF_Size;
        % RF.factor(2) = (2*RF.FA/180*pi)/gamma/tempRF_Size;

        tempRF_Y2 = tempRF_Y .* RF.factor(2);
        
        %% Waveform plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            SE Sequence Diagram
%
%           |-----------------------------TE-----------------------------|
%
%  RF --|  RF1  |----------------------|  RF2  |----------------------------------------
%
%  Gs --|GradSS1|-|GradReph|-----------|GradSS2|----------------------------------------
%
%  Gp ----------------------|GradPE|-----------------------------------------------------
%
%  Gr ---------------------------------------------------|GradprePh|-|GradFE|-----------
%
% ADC ---------------------------------------------------------------| ADC  |-----------
% 
%     |-------------------------------------TR------------------------------------------|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        %% RF pulse
        varargout{1}.Main.RF.dPhs = 0;
        varargout{1}.Main.RF.tStep = [startTime,ones(1,RF.Num)/RF.Freq,TE/2-RF.Duration,...
            ones(1,RF.Num)/RF.Freq,TR-startTime-RF.Duration-TE/2]; % ms; 1kHz = 1ms
        % varargout{1}.Main.RF.value = [0+0i,tempRF_Y1.*(1+0i),0+0i,tempRF_Y2.*(1+0i),0+0i];
        varargout{1}.Main.RF.value = [0+0i,tempRF_Y1.*(1+0i),0+0i,tempRF_Y2.*(0+1i),0+0i]; % Refocusing pulse should be 90 degree different than excitation pulse.
        
        if dummy>0
            varargout{1}.Dummy.RF.dPhs = 0;
            varargout{1}.Dummy.RF.tStep = varargout{1}.Main.RF.tStep;
            varargout{1}.Dummy.RF.value = varargout{1}.Main.RF.value;
        end;
        
        %% RF DFreq
        varargout{1}.Main.DFreq.tStep = [startTime,ones(1,RF.Num)/RF.Freq,TE/2-RF.Duration,...
            ones(1,RF.Num)/RF.Freq,TR-startTime-RF.Duration-TE/2]; % ms; 1kHz = 1ms
        if DEBUG == 1
            varargout{1}.Main.DFreq.value = [0,ones(1,RF.Num)*frqOffset,0,ones(1,RF.Num)*0,0];
        else
            varargout{1}.Main.DFreq.value = [0,ones(1,RF.Num)*frqOffset,0,ones(1,RF.Num)*frqOffset,0]; % Match line 149
        end;
        
        if dummy>0
            varargout{1}.Dummy.DFreq.tStep = varargout{1}.Main.DFreq.tStep;
            varargout{1}.Dummy.DFreq.value = varargout{1}.Main.DFreq.value;
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
            varargout{1}.Dummy.ADC.tStep = varargout{1}.Main.ADC.tStep;
            if (idealDephasing == 1)
               % Ideal Spoiling
               varargout{1}.Dummy.ADC.value = [-2,0,zeros(1,MatSize1),0];
            else        
               % Real Spoiling
               varargout{1}.Dummy.ADC.value = [-1,0,zeros(1,MatSize1),0];
            end;
        end;

        %% Slice Selection gradient
        if GradOn.ss == 1
            Gss.reph.duration = RF.Duration/2/5;
            Gss.duration = RF.Duration;
            Gss.rephAmp = -Gss.amp*Gss.duration/2/Gss.reph.duration;
            
            % Seems to be a good combination.
            % Gss.crusher.duration = RF.Duration/5;
            % Gss.crusherAmp = 3*GMax;
            
            Gss.crusher.duration = RF.Duration;
            Gss.crusherAmp = calSpoilGrad(8*pi,Gss.crusher.duration,2/1000,gamma);
            
            % To check:
            % Gss.crusherAmp/1000 * Gss.crusher.duration/1000 * gamma * slice.TH /pi*180
            
            varargout{1}.Main.Gss.tStep = [startTime,Gss.duration,Gss.reph.duration,...
                TE/2 - Gss.duration - Gss.reph.duration - Gss.crusher.duration, Gss.crusher.duration, Gss.duration, Gss.crusher.duration,...
                TR-startTime-Gss.duration-Gss.reph.duration-(TE/2 - Gss.duration - Gss.reph.duration - Gss.crusher.duration)-Gss.duration-2*Gss.crusher.duration]; % ms
            if DEBUG == 1
                varargout{1}.Main.Gss.value = [0, Gss.amp, Gss.rephAmp, 0, Gss.crusherAmp,        0, Gss.crusherAmp, 0];
            else
                varargout{1}.Main.Gss.value = [0, Gss.amp, Gss.rephAmp, 0, Gss.crusherAmp,  Gss.amp, Gss.crusherAmp, 0]; % Match line 102 % Reduced slice-selection gradient amp
            end;
        else
            Gss.duration = 0;
            Gss.rephDuration = 0;
            varargout{1}.Main.Gss.tStep = [startTime,TR-startTime]; % ms
            varargout{1}.Main.Gss.value = [0,0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gss.tStep = varargout{1}.Main.Gss.tStep;
            varargout{1}.Dummy.Gss.value = varargout{1}.Main.Gss.value;
        end;

        %% Phase Encoding gradient
        if GradOn.pe == 1
            Gpe.duration = 1/(FOV2/1000)/gamma*2*pi/(2*GMax/(MatSize2-1)/1000)*1000; %ms, Page 239
            Gpe.delAmp = 2*GMax/(MatSize2-1); %mT/m
            
            Gpe.extraAmp = abs(GMax)/2; %mT/m
%             Gpe.extraAmp = 0; %mT/m
            Gpe.extra.duration = Gpe.duration;
            
            varargout{1}.Main.Gpe.tStep = [startTime,RF.Duration,...
                Gpe.duration,Gpe.extra.duration,...
                TE/2-Gpe.duration-Gpe.extra.duration,Gpe.extra.duration,...
                TR-RF.Duration-Gpe.duration-startTime];
            varargout{1}.Main.Gpe.value = [0,0,GMax,Gpe.extraAmp,0,Gpe.extraAmp,0];
            varargout{1}.Main.Gpe.increment = -[0,0,Gpe.delAmp,0,0,0,0]; % Abs Value
        else
            Gpe.duration = 0;
            varargout{1}.Main.Gpe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gpe.value = [0,0];
            varargout{1}.Main.Gpe.increment = [0,0]; % Abs Value
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gpe.tStep = varargout{1}.Main.Gpe.tStep;
            varargout{1}.Dummy.Gpe.value = varargout{1}.Main.Gpe.value .* 0;
        end;
            
        %% Frequency Encoding gradient
        if GradOn.fe == 1
            Gfe.preph.duration = ADC.duration/2; %ms
            Gfe.amp = 1/gamma*2*pi*(ADC.BW*1000)/(FOV1/1000)*1000; %mT/m, Page 238
            Gfe.duration=ADC.duration; %ms
            Gfe.prephAmp = -Gfe.amp*Gfe.duration/2/Gfe.preph.duration; %mT/m
            
            Gfe.extraAmp = abs(Gfe.prephAmp); %mT/m
            % Gfe.extraAmp = 0;
            Gfe.extra.duration = Gfe.duration/10; % Match line 258
            
            if (idealDephasing == 1)
                % Ideal Spoiling
                varargout{1}.Main.Gfe.tStep = [startTime,RF.Duration,Gfe.preph.duration,Gfe.extra.duration...
                    TE-RF.Duration/2-ADC.duration/2-Gfe.preph.duration-2*Gfe.extra.duration,...
                    Gfe.extra.duration,ones(1,MatSize1)/ADC.BW,TR-startTime-RF.Duration-Gfe.preph.duration-TE+RF.Duration/2+ADC.duration/2+Gfe.preph.duration-ADC.duration];
                varargout{1}.Main.Gfe.value = [0,0,-Gfe.prephAmp,Gfe.extraAmp,0,Gfe.extraAmp,Gfe.amp*ones(1,MatSize1),0];
            else
                % Real Spoiling
                Gfe.spoiler.duration = ADC.duration/2;
                Gfe.spoiler.amp = Gfe.amp*5;
                varargout{1}.Main.Gfe.tStep = [startTime,RF.Duration,Gfe.preph.duration,...
                    TE-RF.Duration/2-ADC.duration/2-Gfe.preph.duration,...
                    ones(1,MatSize1)/ADC.BW,Gfe.spoiler.duration,...
                    TR-startTime-RF.Duration-Gfe.preph.duration-TE+RF.Duration/2+ADC.duration/2+Gfe.preph.duration-ADC.duration-Gfe.spoiler.duration];
                varargout{1}.Main.Gfe.value = [0,0,-Gfe.prephAmp,0,Gfe.amp*ones(1,MatSize1),Gfe.spoiler.amp,0];            
            end;
        else
            varargout{1}.Main.Gfe.tStep = [startTime,TR-startTime]; %ms
            varargout{1}.Main.Gfe.value = [0,0];
        end;
        
        if dummy>0
            varargout{1}.Dummy.Gfe.tStep = varargout{1}.Main.Gfe.tStep;
            varargout{1}.Dummy.Gfe.value = varargout{1}.Main.Gfe.value;
        end;
        
        %%
        varargout{1}.TR = TR; %ms
        varargout{1}.Main.repeat = MatSize2;
        varargout{1}.Dummy.repeat = dummy;
    end;

    %% Return [minTE, minTR]
    if nargout == 2
        if GradOn.pe == 1
            Gpe.duration = 1/(FOV2/1000)/gamma*2*pi/(2*GMax/(MatSize2-1)/1000)*1000; %ms, Page 239
        else
            Gpe.duration = 0;
        end;
        
        if GradOn.ss == 1
            % Gss.crusher.duration = RF.Duration/5;
            Gss.crusher.duration = RF.Duration;
            Gss.reph.duration = RF.Duration/2;
        else
            Gss.crusher.duration = 0;
            Gss.reph.duration = 0;
        end;
        
        if GradOn.fe == 1
            Gfe.preph.duration = ADC.duration/2; %ms
        else
            Gfe.preph.duration = 0;
        end;
        
        Gfe.duration=ADC.duration; %ms
        Gfe.extra.duration = Gfe.duration/10; % Match line 258
                    
        % minTE
        varargout{1} = 2 * max(RF.Duration/2 + Gss.crusher.duration + max([Gpe.duration,Gfe.preph.duration,Gss.reph.duration]) + RF.Duration/2,...
            RF.Duration/2 + ADC.duration/2 + Gss.crusher.duration) + 2*Gfe.extra.duration; %ms

        if TE<varargout{1}
            TE = varargout{1};
        end;

        % minTR
        if (idealDephasing == 1)
            varargout{2} = startTime+RF.Duration/2+ADC.duration/2+TE; %ms
        else
            Gfe.spoiler.duration = MatSize1/ADC.BW/2; %ms
            varargout{2} = startTime+RF.Duration/2+ADC.duration/2+TE+Gfe.spoiler.duration; %ms
        end;
    end;

end

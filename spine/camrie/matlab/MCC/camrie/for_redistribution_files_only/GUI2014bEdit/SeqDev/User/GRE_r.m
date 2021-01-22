%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       GRE with ideal/real spoiling (Radial)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout = GRE_r(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)
    
idealDephasing = 1;

    %% Init
    MatSize1=MatSize.value(1);
    MatSize2=MatSize.value(2);
    
    FOV1=FOV.value(1);

    %%
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
        
        varargout{1}.AngleIncrement = GRE_r_GUI(MatSize2);
                
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            GRE Sequence Diagram
%
%           |----------------------TE----------------------|
%
%  RF --|  RF  |-----------------------------------------------------------
%
%  Gs --|GradSS|-|GradReph|------------------------------------------------
%
%  Gp ----------------------|GradPE|---------------------------------------
%
%  Gr --------------------------------------|GradprePh|-|GradFE|-----------
%
% ADC --------------------------------------------------| ADC  |-----------
% 
%     |------------------------------TR-----------------------------------|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

        %% Phase Encoding gradient (There is no phase encoding for Radial)
        Gpe.duration = 0;
        varargout{1}.Main.Gpe.tStep = [startTime,TR-startTime]; %ms
        varargout{1}.Main.Gpe.value = [0,0];
        varargout{1}.Main.Gpe.increment = [0,0]; % Abs Value
        
        if dummy>0
            varargout{1}.Dummy.Gpe.tStep = varargout{1}.Dummy.tStep;
            varargout{1}.Dummy.Gpe.value = zeros(1,(2+RF.Num));
        end;
            
        %% Frequency Encoding gradient
        if GradOn.fe == 1
            Gfe.preph.duration = ADC.duration/2/10; %ms % Match Line 214 Below
            Gfe.amp = 1/gamma*2*pi*(ADC.BW*1000)/(FOV1/1000)*1000; %mT/m, Page 238
            Gfe.duration = MatSize1/ADC.BW; %ms
%             Gfe.prephAmp = -(Gfe.amp*Gfe.duration/2+Gfe.amp*Gfe.duration/MatSize1/2)/Gfe.preph.duration; %mT/m
              Gfe.prephAmp = -(Gfe.amp*Gfe.duration/2)/Gfe.preph.duration; %mT/m
            
            if (idealDephasing == 1)
                % Ideal Spoiling
                varargout{1}.Main.Gfe.tStep = [startTime,...
                    TE+RF.Duration/2-ADC.duration/2-Gfe.preph.duration,...
                    Gfe.preph.duration,ones(1,MatSize1)/ADC.BW,TR-startTime-TE-RF.Duration/2-ADC.duration/2]; %ms
                varargout{1}.Main.Gfe.value = [0,0,Gfe.prephAmp,Gfe.amp*ones(1,MatSize1),0];
            else       
                % Real Spoiling
                Gfe.spoiler.duration = ADC.duration/5;
                Gfe.spoiler.amp = Gfe.amp*20;
                varargout{1}.Main.Gfe.tStep = [startTime,...
                    TE+RF.Duration/2-ADC.duration/2-Gfe.preph.duration,...
                    Gfe.preph.duration,ones(1,MatSize1)/ADC.BW,Gfe.spoiler.duration,TR-startTime-TE-RF.Duration/2-ADC.duration/2-Gfe.spoiler.duration]; %ms
                varargout{1}.Main.Gfe.value = [0,0,Gfe.prephAmp,Gfe.amp*ones(1,MatSize1),Gfe.spoiler.amp,0];
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
            Gpe.duration = 1/(FOV1/1000)/gamma*2*pi/(2*(1.5*GMax)/(MatSize2-1)/1000)*1000; %ms, Page 239
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

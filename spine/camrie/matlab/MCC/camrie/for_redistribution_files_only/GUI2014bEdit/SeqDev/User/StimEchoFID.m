function varargout = StimEchoFID(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)

%% Init
    MatSize1=MatSize.value(1);
    MatSize2=MatSize.value(2);

    FOV1=FOV.value(1);
    FOV2=FOV.value(2);
    
    startTime = 0.001; %ms
    gamma = 42576000.0 * 2 * pi; %Hz/T
    GMax = 22; %mT/m
    
    % ADC.duration = MatSize1/ADC.BW; %ms
    ADC1.duration = 10; % ms
    ADC2.duration = 25; % ms
    ADC3.duration = 100; % ms
    
    frqBW = 4/RF.Duration*1000; % RF.Duration = 4/frqBW*1000; % ms
    Gss.amp = frqBW * 2*pi / gamma / slice.TH * 1000; % frqBW = (Gss.amp/1000) * slice.TH * gamma /2/pi; % Gss.amp in mT/m
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
        RF.factor(1) = (45/180*pi)/gamma/tempRF_Size;
        tempRF_Y1 = tempRF_Y .* RF.factor(1);
        RF.factor(2) = (90/180*pi)/gamma/tempRF_Size;
        tempRF_Y2 = tempRF_Y .* RF.factor(2);
        RF.factor(3) = (90/180*pi)/gamma/tempRF_Size;
        tempRF_Y3 = tempRF_Y .* RF.factor(3);
        
        %% Waveform plot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                            SE Sequence Diagram
%
%  RF --|  RF1  |--------|  RF2  |---------------|  RF3  |---------------------------------
%
% ADC -----------| ADC1 |---------|    ADC2     |---------|             ADC3            |--
% 
%     |--------------------------------------TR-------------------------------------------|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% RF pulse
        varargout{1}.Main.RF.dPhs = 0;
        varargout{1}.Main.RF.tStep = [startTime,ones(1,RF.Num)/RF.Freq,ADC1.duration,ones(1,RF.Num)/RF.Freq,ADC2.duration,ones(1,RF.Num)/RF.Freq,...
            TR-startTime-3*RF.Duration-ADC1.duration-ADC2.duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.RF.value = [0+0i,tempRF_Y1.*(1+0i),0+0i,tempRF_Y2.*(1+0i),0+0i,tempRF_Y3.*(1+0i),0+0i];
        
        %% DFreq
        varargout{1}.Main.DFreq.tStep = [startTime,ones(1,RF.Num)/RF.Freq,ADC1.duration,ones(1,RF.Num)/RF.Freq,ADC2.duration,ones(1,RF.Num)/RF.Freq,...
            TR-startTime-3*RF.Duration-ADC1.duration-ADC2.duration]; % ms; 1kHz = 1ms
        varargout{1}.Main.DFreq.value = [0,zeros(1,RF.Num),0,zeros(1,RF.Num),0,zeros(1,RF.Num),0];
        
        %% Slice Selection Grad
        Gss.duration = 0;
        Gss.reph.duration = 0;
        varargout{1}.Main.Gss.tStep = [startTime,...
            RF.Duration,ADC1.duration,...
            RF.Duration,ADC2.duration,...
            RF.Duration,ADC3.duration,...
            TR-startTime-RF.Duration-RF.Duration-RF.Duration-ADC1.duration-ADC2.duration-ADC3.duration]; % ms
        varargout{1}.Main.Gss.value = [0,0,0,0,0,0,0,0];
        
        %% Phase Encoding Grad
        Gpe.duration = 0;
        varargout{1}.Main.Gpe.tStep = [startTime,...
            RF.Duration,ADC1.duration,...
            RF.Duration,ADC2.duration,...
            RF.Duration,ADC3.duration,...
            TR-startTime-RF.Duration-RF.Duration-RF.Duration-ADC1.duration-ADC2.duration-ADC3.duration]; %ms
        varargout{1}.Main.Gpe.value = [0,0,0,0,0,0,0,0];
        varargout{1}.Main.Gpe.increment = [0,0,0,0,0,0,0,0]*0; % Abs Value
        
        %% Frequency Encoding Grad
        varargout{1}.Main.Gfe.tStep = [startTime,...
            RF.Duration,ADC1.duration,...
            RF.Duration,ADC2.duration,...
            RF.Duration,ADC3.duration,...
            TR-startTime-RF.Duration-RF.Duration-RF.Duration-ADC1.duration-ADC2.duration-ADC3.duration]; %ms
        varargout{1}.Main.Gfe.value = [0,0,GMax,0,GMax,0,GMax,0];
        
        %% ADC
        Num1 = ADC1.duration*ADC.BW; Num2 = ADC2.duration*ADC.BW; Num3 = ADC3.duration*ADC.BW;
        varargout{1}.Main.ADC.tStep = [startTime,...
            RF.Duration,ones(1,Num1)/ADC.BW,...
            RF.Duration,ones(1,Num2)/ADC.BW,...
            RF.Duration,ones(1,Num3)/ADC.BW,...
            TR-startTime-RF.Duration-RF.Duration-RF.Duration-ADC1.duration-ADC2.duration-ADC3.duration]; % ms
        varargout{1}.Main.ADC.value = [-2,0,ones(1,Num1),0,ones(1,Num2),0,ones(1,Num3),0];
        
        %%
        varargout{1}.TR = TR; %ms
        varargout{1}.Main.repeat = 1;
        varargout{1}.Dummy.repeat = dummy;
    end;

    %% Return [minTE, minTR]
    if nargout == 2        
        % minTE        
        varargout{1} = 0;

        if TE<varargout{1}
            TE = varargout{1};
        end;

        % minTR
        varargout{2} = startTime+3*RF.Duration+ADC1.duration+ADC2.duration+ADC3.duration; %ms
    end;

end

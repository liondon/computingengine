function Output = combineSeq(interSeqData,orientation,peDirection,dummy)

    %% Generate new tAbs
    if dummy > 0
        interSeqData.Dummy.RF.tAbs = round(cumsum(interSeqData.Dummy.RF.tStep)*1000000)/1000000;
        interSeqData.Dummy.DFreq.tAbs = round(cumsum(interSeqData.Dummy.DFreq.tStep)*1000000)/1000000;
        interSeqData.Dummy.Gfe.tAbs = round(cumsum(interSeqData.Dummy.Gfe.tStep)*1000000)/1000000;
        interSeqData.Dummy.Gpe.tAbs = round(cumsum(interSeqData.Dummy.Gpe.tStep)*1000000)/1000000;
        interSeqData.Dummy.Gss.tAbs = round(cumsum(interSeqData.Dummy.Gss.tStep)*1000000)/1000000;
        interSeqData.Dummy.ADC.tAbs = round(cumsum(interSeqData.Dummy.ADC.tStep)*1000000)/1000000;
    end;
    
    interSeqData.Main.RF.tAbs = round(cumsum(interSeqData.Main.RF.tStep)*1000000)/1000000;
    interSeqData.Main.DFreq.tAbs = round(cumsum(interSeqData.Main.DFreq.tStep)*1000000)/1000000;
    interSeqData.Main.Gfe.tAbs = round(cumsum(interSeqData.Main.Gfe.tStep)*1000000)/1000000;
    interSeqData.Main.Gpe.tAbs = round(cumsum(interSeqData.Main.Gpe.tStep)*1000000)/1000000;
    interSeqData.Main.Gss.tAbs = round(cumsum(interSeqData.Main.Gss.tStep)*1000000)/1000000;
    interSeqData.Main.ADC.tAbs = round(cumsum(interSeqData.Main.ADC.tStep)*1000000)/1000000;
    
    % for Main
    temp1 = unique(mergesort(interSeqData.Main.Gfe.tAbs,interSeqData.Main.Gpe.tAbs));
    temp2 = unique(mergesort(temp1,interSeqData.Main.Gss.tAbs)); clear temp1;
    temp3 = unique(mergesort(temp2,interSeqData.Main.ADC.tAbs)); clear temp2;
    temp4 = unique(mergesort(interSeqData.Main.DFreq.tAbs,interSeqData.Main.RF.tAbs));
    Result.Main.tAbs = unique(mergesort(temp3,temp4)); clear temp3 temp4;
    Result.Main.repeat = interSeqData.Main.repeat;
    Result.Main.RF.dPhs = interSeqData.Main.RF.dPhs;

    % for Dummy
    if dummy > 0
        temp1 = unique(mergesort(interSeqData.Dummy.Gfe.tAbs,interSeqData.Dummy.Gpe.tAbs));
        temp2 = unique(mergesort(temp1,interSeqData.Dummy.Gss.tAbs)); clear temp1;
        temp3 = unique(mergesort(temp2,interSeqData.Dummy.ADC.tAbs)); clear temp2;
        temp4 = unique(mergesort(interSeqData.Dummy.DFreq.tAbs,interSeqData.Dummy.RF.tAbs));
        Result.Dummy.tAbs = unique(mergesort(temp3,temp4)); clear temp3 temp4;
        Result.Dummy.repeat = interSeqData.Dummy.repeat;
        Result.Dummy.RF.dPhs = interSeqData.Dummy.RF.dPhs;
    end;

    %% Interpolation
    
    % For Main
    % When inserting data for ADC sequence, the new data value should be
    % 0;
    Result.Main.ADC.value = seqInterp(interSeqData.Main.ADC.value,interSeqData.Main.ADC.tAbs,Result.Main.tAbs,1);

    % When inserting data for other sequences, the new data value should
    % equal to the previous data.
    
    % pTx
    for ncoil=1:size(interSeqData.Main.RF.value,1)
        Result.Main.RF.value(ncoil,:) = round(seqInterp(squeeze(interSeqData.Main.RF.value(ncoil,:)),interSeqData.Main.RF.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    end;

%     % no pTx
%     Result.Main.RF.value = round(seqInterp(squeeze(interSeqData.Main.RF.value),interSeqData.Main.RF.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    Result.Main.DFreq.value = round(seqInterp(interSeqData.Main.DFreq.value,interSeqData.Main.DFreq.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    
    Result.Main.Gfe.value = round(seqInterp(interSeqData.Main.Gfe.value,interSeqData.Main.Gfe.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    try %#ok<TRYNC>
        Result.Main.Gfe.increment = round(seqInterp(interSeqData.Main.Gfe.increment,interSeqData.Main.Gfe.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    end;

    Result.Main.Gpe.value = round(seqInterp(interSeqData.Main.Gpe.value,interSeqData.Main.Gpe.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    try %#ok<TRYNC>
        Result.Main.Gpe.increment = round(seqInterp(interSeqData.Main.Gpe.increment,interSeqData.Main.Gpe.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    end;   
    
    Result.Main.Gss.value = round(seqInterp(interSeqData.Main.Gss.value,interSeqData.Main.Gss.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    try %#ok<TRYNC>
        Result.Main.Gss.increment = round(seqInterp(interSeqData.Main.Gss.increment,interSeqData.Main.Gss.tAbs,Result.Main.tAbs,2)*1000000000)/1000000000;
    end;
    
    if dummy > 0
        % For Dummy
        % When inserting data for ADC sequence, the new data value should be
        % 0;
        Result.Dummy.ADC.value = round(seqInterp(interSeqData.Dummy.ADC.value,interSeqData.Dummy.ADC.tAbs,Result.Dummy.tAbs,1)*1000000000)/1000000000;

        % When inserting data for other sequences, the new data value should
        % equal to the previous data.

        Result.Dummy.RF.value = round(seqInterp(interSeqData.Dummy.RF.value,interSeqData.Dummy.RF.tAbs,Result.Dummy.tAbs,2)*1000000000)/1000000000;
        Result.Dummy.DFreq.value = round(seqInterp(interSeqData.Dummy.DFreq.value,interSeqData.Dummy.DFreq.tAbs,Result.Dummy.tAbs,2)*1000000000)/1000000000;
        Result.Dummy.Gfe.value = round(seqInterp(interSeqData.Dummy.Gfe.value,interSeqData.Dummy.Gfe.tAbs,Result.Dummy.tAbs,2)*1000000000)/1000000000;
        Result.Dummy.Gpe.value = round(seqInterp(interSeqData.Dummy.Gpe.value,interSeqData.Dummy.Gpe.tAbs,Result.Dummy.tAbs,2)*1000000000)/1000000000;
        Result.Dummy.Gss.value = round(seqInterp(interSeqData.Dummy.Gss.value,interSeqData.Dummy.Gss.tAbs,Result.Dummy.tAbs,2)*1000000000)/1000000000;
    end;
    
    %% Sequence Generation
    
    % Main
    Output.Main.Time.value = [Result.Main.tAbs(1),diff(Result.Main.tAbs)];
    Output.Main.Time.repeat = Result.Main.repeat;
    
    Output.Main.ADC.value = Result.Main.ADC.value;
    Output.Main.ADC.repeat = Result.Main.repeat;
       
    if Result.Main.RF.dPhs ~= 0
        Output.Main.RF.value = Result.Main.RF.value;
        for n=1:(Result.Main.repeat-1)
            Output.Main.RF.value = [Output.Main.RF.value, Result.Main.RF.value * exp(Result.Main.RF.dPhs*n/180*pi*1i)];
        end;
        Output.Main.RF.repeat = 1;
        
        Output.Main.DFreq.value = Result.Main.DFreq.value;
        for n=1:(Result.Main.repeat-1)
            Output.Main.DFreq.value = [Output.Main.DFreq.value, Result.Main.DFreq.value];
        end;
        Output.Main.DFreq.repeat = 1;
    else
        Output.Main.RF.value = Result.Main.RF.value;
        Output.Main.RF.repeat = Result.Main.repeat;
        
        Output.Main.DFreq.value = Result.Main.DFreq.value;
        Output.Main.DFreq.repeat = Result.Main.repeat;
    end;
        
    tempIncrement = seqInterp(interSeqData.Main.Gpe.increment,interSeqData.Main.Gpe.tAbs,Result.Main.tAbs,2);
    
    %
    Result.Main.Gpe.increment = +1 .* tempIncrement;
    switch orientation
        case 1 % Axial
            Output.Main.Gx.repeat = 1;
            Output.Main.Gy.repeat = 1;
            Output.Main.Gx.value = [];
            Output.Main.Gy.value = [];
                    
            Output.Main.Gz.value = Result.Main.Gss.value;
            Output.Main.Gz.repeat = Result.Main.repeat;
              
            switch cell2mat(peDirection)
                case 'P--A'
                    for n=0:(Result.Main.repeat-1)
                        tempX = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempY = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempX + 1i*tempY) * exp(1i*n*interSeqData.AngleIncrement);
                        tempX = real(temp); tempY = imag(temp);
                        
                        Output.Main.Gx.value = [Output.Main.Gx.value, tempX];
                        Output.Main.Gy.value = [Output.Main.Gy.value, tempY];
                    end;                    
                case 'L--R'
                    for n=0:(Result.Main.repeat-1)
                        tempY = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempX = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempX + 1i*tempY) * exp(1i*n*interSeqData.AngleIncrement);
                        tempX = real(temp); tempY = imag(temp);
                        
                        Output.Main.Gx.value = [Output.Main.Gx.value, tempX];
                        Output.Main.Gy.value = [Output.Main.Gy.value, tempY];
                    end;
            end;

        case 2 % Sagittal
            Output.Main.Gy.repeat = 1;
            Output.Main.Gz.repeat = 1;
            Output.Main.Gy.value = [];
            Output.Main.Gz.value = [];
            
            Output.Main.Gx.value = Result.Main.Gss.value;
            Output.Main.Gx.repeat = Result.Main.repeat;
                    
            switch cell2mat(peDirection)                    
                case 'P--A'
                    for n=0:(Result.Main.repeat-1)
                        tempZ = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempY = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempZ + 1i*tempY) * exp(1i*n*interSeqData.AngleIncrement);
                        tempZ = real(temp); tempY = imag(temp);
                        
                        Output.Main.Gz.value = [Output.Main.Gz.value, tempZ];
                        Output.Main.Gy.value = [Output.Main.Gy.value, tempY];
                    end;                    
                case 'F--H'
                    for n=0:(Result.Main.repeat-1)
                        tempY = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempZ = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempZ + 1i*tempY) * exp(1i*n*interSeqData.AngleIncrement);
                        tempZ = real(temp); tempY = imag(temp);
                        
                        Output.Main.Gz.value = [Output.Main.Gz.value, tempZ];
                        Output.Main.Gy.value = [Output.Main.Gy.value, tempY];
                    end;
            end;            
            
        case 3 % Coronal % Need modification for Non-cartesian Sequences.
            Output.Main.Gz.repeat = 1;
            Output.Main.Gx.repeat = 1;
            Output.Main.Gz.value = [];
            Output.Main.Gx.value = [];
            
            Output.Main.Gy.value = Result.Main.Gss.value;
            Output.Main.Gy.repeat = Result.Main.repeat;
                    
            switch cell2mat(peDirection)                    
                case 'L--R'
                    for n=0:(Result.Main.repeat-1)
                        tempZ = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempX = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempX + 1i*tempZ) * exp(1i*n*interSeqData.AngleIncrement);
                        tempX = real(temp); tempZ = imag(temp);
                        
                        Output.Main.Gx.value = [Output.Main.Gx.value, tempX];
                        Output.Main.Gz.value = [Output.Main.Gz.value, tempZ];
                    end;
                case 'F--H'                    
                    for n=0:(Result.Main.repeat-1)
                        tempX = Result.Main.Gfe.value + Result.Main.Gfe.increment .* n;
                        tempZ = Result.Main.Gpe.value + Result.Main.Gpe.increment .* n;
                        temp = (tempZ + 1i*tempX) * exp(1i*n*interSeqData.AngleIncrement);
                        tempZ = real(temp); tempX = imag(temp);
                        
                        Output.Main.Gz.value = [Output.Main.Gz.value, tempZ];
                        Output.Main.Gx.value = [Output.Main.Gx.value, tempX];
                    end;
            end;            
    end;
    
    % Dummy
    if dummy>0
        Output.Dummy.Time.value = [Result.Dummy.tAbs(1),diff(Result.Dummy.tAbs)];
        Output.Dummy.Time.repeat = Result.Dummy.repeat;

        Output.Dummy.ADC.value = Result.Dummy.ADC.value;
        Output.Dummy.ADC.repeat = Result.Dummy.repeat;

        if Result.Dummy.RF.dPhs ~= 0
            Output.Dummy.RF.value = Result.Dummy.RF.value;
            for n=1:(Result.Main.repeat-1)
                Output.Dummy.RF.value = [Output.Dummy.RF.value, Result.Dummy.RF.value * exp(-Result.Dummy.RF.dPhs*n/180*pi*1i)];
            end;
            Output.Dummy.RF.repeat = 1;

            Output.Dummy.DFreq.value = Result.Dummy.DFreq.value;
            for n=1:(Result.Dummy.repeat-1)
                Output.Dummy.DFreq.value = [Output.Dummy.value, Result.Dummy.DFreq.value];
            end;
            Output.Dummy.DFreq.repeat = 1;
        else
            Output.Dummy.RF.value = Result.Dummy.RF.value;
            Output.Dummy.RF.repeat = Result.Dummy.repeat;

            Output.Dummy.DFreq.value = Result.Dummy.DFreq.value;
            Output.Dummy.DFreq.repeat = Result.Dummy.repeat;
        end;
        
        %%
        Output.Dummy.Gx.value = Result.Dummy.Gfe.value;
        Output.Dummy.Gx.repeat = Result.Dummy.repeat;
        Output.Dummy.Gy.value = Result.Dummy.Gpe.value;
        Output.Dummy.Gy.repeat = Result.Dummy.repeat;
        Output.Dummy.Gz.value = Result.Dummy.Gss.value;
        Output.Dummy.Gz.repeat = Result.Dummy.repeat;
    end;
    
    if dummy > 0
        try
            error = (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.ADC.value) * Output.Main.ADC.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.RF.value) * Output.Main.RF.repeat)...
                +...
            (length(Output.Main.RF.value) ~= length(Output.Main.DFreq.value)) + (Output.Main.RF.repeat ~= Output.Main.DFreq.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gx.value) * Output.Main.Gx.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gy.value) * Output.Main.Gy.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gz.value) * Output.Main.Gz.repeat)...
                +...
            (length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat ~= length(Output.Dummy.ADC.value) * Output.Dummy.ADC.repeat)...
                +...
            (length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat ~= length(Output.Dummy.RF.value) * Output.Dummy.RF.repeat)...
                +...
            (length(Output.Dummy.RF.value) ~= length(Output.Dummy.DFreq.value)) + (Output.Dummy.RF.repeat ~= Output.Dummy.DFreq.repeat)...
                +...
            (length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat ~= length(Output.Dummy.Gx.value) * Output.Dummy.Gx.repeat)...
                +...
            (length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat ~= length(Output.Dummy.Gy.value) * Output.Dummy.Gy.repeat)...
                +...
            (length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat ~= length(Output.Dummy.Gz.value) * Output.Dummy.Gz.repeat); %#ok<NASGU>
        
        catch %#ok<CTCH>
            msgbox('Sequence Error!');
        end;
    else
        try
            error = (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.ADC.value) * Output.Main.ADC.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.RF.value) * Output.Main.RF.repeat)...
                +...
            (length(Output.Main.RF.value) ~= length(Output.Main.DFreq.value)) + (Output.Main.RF.repeat ~= Output.Main.DFreq.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gx.value) * Output.Main.Gx.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gy.value) * Output.Main.Gy.repeat)...
                +...
            (length(Output.Main.Time.value) * Output.Main.Time.repeat ~= length(Output.Main.Gz.value) * Output.Main.Gz.repeat); %#ok<NASGU>
        catch %#ok<CTCH>
            msgbox('Sequence Error!');
        end;
    end;
    
    if dummy > 0
        Output.totalNum = length(Output.Main.Time.value) * Output.Main.Time.repeat + length(Output.Dummy.Time.value) * Output.Dummy.Time.repeat;
    else
        Output.totalNum = length(Output.Main.Time.value) * Output.Main.Time.repeat;
    end;

    %% Sequence Interpolation Function
    function newY = seqInterp(tableY,tableX,newX,type)
        newY = 0 .* newX;
        switch type
            case 1 % for ADC
                for n=1:length(newX) %#ok<*FXUP>
                    ind = find ( newX(n) == tableX, 1);
                    if isempty(ind)==1
                        newY(n) = 0;
                    else
                        newY(n) = tableY(ind);
                    end;
                end;
            case 2 % for others
                for n=1:length(newX)
                    try
                        newY(n) = tableY ( find ( newX(n) <= tableX, 1) );
                    catch
                        a=1;
                    end;
                end;
        end;
    end
end

function fileprotdone = createProtFile(val, inputInfo, SlicePosition, modeComp)

fileprotdone = 0;

sequenceTypes = {'GRE','SE','GRE_EPI','GRE_TI','StimEchoFID','GRE_r'};
RFShapeTypes = {'Sinc', 'Rect', 'Gauss'};
PEDirect = {'P--A', 'L--R', 'F--H'};
ModeComputation = {'SignalSimple','Noise'};

fileprot = strcat(val.path, 'Protfile.prot');

        fid=fopen(fileprot,'w');
        
        fprintf(fid,'INPUT FILENAMES:\n');
        
        %Write Geometry Filename
        fprintf(fid,'  Geometry Filename:\n');
        temp = strcat(val.path, 'Geometry.geo');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);
        
        %Write Tissue Filename
        fprintf(fid,'  Tissue Filename:\n');
        temp = strcat(val.path, 'Tissue.tiss');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);
        
        %Write Sequence Filename
        fprintf(fid,'  Sequence Filename:\n');
        temp = strcat(val.path, 'Sequence.seqn');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);

        %Write DeltagB0 Filename
        fprintf(fid,'  Delta Bo Filename:\n');
        if isempty(val.fields.tdb) < 1
            temp = strcat(val.path, 'Delta.b0');
            fprintf(fid,['    ',slashCvrt(temp),'\n']);
        else
            fprintf(fid,'\n');
        end

        % # Tx
        fprintf(fid,'  # Tx:\n');
        fprintf(fid,['    ',num2str(val.coils.transmittingCoilsNumber),'\n']);
        
        fprintf(fid,'  Tx Mag & Phs:\n');
        if isempty(val.fields.b1plus)<1
            for n=1:(val.coils.transmittingCoilsNumber)
                fprintf(fid,['    ',num2str(val.fields.b1plus(n).amplitude),' ',num2str(val.fields.b1plus(n).phase),'\n']);
            end
        else
            for n=1:(val.coils.transmittingCoilsNumber)
                fprintf(fid,['    ',num2str(1),' ',num2str(0),'\n']);
            end
        end
        
        %B1plus Filenames
        fprintf(fid,'  B1p Filename:\n');
        if isempty(val.fields.b1plus)<1
            for n = 1:length(val.fields.b1plus)
                temp = strcat(val.path, 'B1p', num2str(n), '.bpfld');
                fprintf(fid,['    ',slashCvrt(temp),'\n']);
            end
        else
            fprintf(fid,'\n');
        end
        
        %E1plus Filenames
        fprintf(fid,'  E1p Filename:\n');
        if isempty(val.fields.etransmitted)<1
            for n = 1:length(val.fields.etransmitted)
                temp = strcat(val.path, 'E1p', num2str(n), '.epfld');
                fprintf(fid,['    ',slashCvrt(temp),'\n']);
            end
        else
            fprintf(fid,'\n');
        end
        
        
        fprintf(fid,'  # Rx:\n');
        fprintf(fid,['    ',num2str(val.coils.receivingCoilsNumber),'\n']);
        
        %B1minus Filenames
        fprintf(fid,'  B1m Filename:\n');
        if isempty(val.fields.b1minus)<1
            for n = 1:length(val.fields.b1minus)
                temp = strcat(val.path, 'B1m', num2str(n), '.bmfld');
                fprintf(fid,['    ',slashCvrt(temp),'\n']);
            end
        else
            fprintf(fid,'\n');
        end

        %E1minus Filenames
        fprintf(fid,'  E1m Filename:\n');
        if isempty(val.fields.ereceived)<1
            for n = 1:length(val.fields.ereceived)
                temp = strcat(val.path, 'E1m', num2str(n), '.emfld');
                fprintf(fid,['    ',slashCvrt(temp),'\n']);
            end
        else
            fprintf(fid,'\n');
        end
        
        %Gradx Filenames
        fprintf(fid,'  Gx Filename:\n');
        if isempty(val.fields.gradx) < 1
            temp = strcat(val.path, 'Grad.x');
            fprintf(fid,['    ',slashCvrt(temp),'\n']);
        else
            fprintf(fid,'\n');
        end

        %Grady Filenames
        fprintf(fid,'  Gy Filename:\n');
        if isempty(val.fields.grady) < 1
            temp = strcat(val.path, 'Grad.y');
            fprintf(fid,['    ',slashCvrt(temp),'\n']);
        else
            fprintf(fid,'\n');
        end
        
        %Gradz Filenames
        fprintf(fid,'  Gz Filename:\n');
        if isempty(val.fields.gradz) < 1
            temp = strcat(val.path, 'Grad.z');
            fprintf(fid,['    ',slashCvrt(temp),'\n']);
        else
            fprintf(fid,'\n');
        end
        
        fprintf(fid,'\nOUTPUT FILENAMES:\n');

        %KSpace Filename
        fprintf(fid,'  KSpace Filename:\n');
        temp = strcat(val.path, 'KSpace.ksig');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);
        
        %KMap Filename
        fprintf(fid,'  KMap Filename:\n');
        temp = strcat(val.path, 'KMap.ktrj');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);

        %Noise Filenames
        fprintf(fid,'  Noise Filename:\n');
        temp = strcat(val.path, 'Noise.nois');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);

        %SAR Filename
        fprintf(fid,'  SAR Filename:\n');
        temp = strcat(val.path, 'SARFile.ktrj');
        fprintf(fid,['    ',slashCvrt(temp),'\n']);
        
        
        fprintf(fid,'\nGEOMETRY EDITOR SETUP:\n');
        
        fprintf(fid,'  Display:\n');
        fprintf(fid,['    ','ID\n']);
        
        fprintf(fid,'  Scale:\n');
        fprintf(fid,['    ','Linear\n']);
        
        fprintf(fid,'  Slice Orientation:\n');
        switch(val.sequence.sliceorientation)
            case 1
                SliceOrientation = 'Axial';
            case 2
                SliceOrientation = 'Sagittal';
            case 3
                SliceOrientation = 'Coronal';
        end
        fprintf(fid,['    ',SliceOrientation,'\n']);
        
        fprintf(fid,'  Slice Thickness:\n');
        fprintf(fid,['    ',num2str(val.sequence.slicethickness),'\n']);
        
        fprintf(fid,'  Slice Position:\n');
        fprintf(fid,['    ',num2str(SlicePosition),'\n']);
        
        fprintf(fid,'  Sample Min:\n');
        fprintf(fid,'    XMin:\n');
        fprintf(fid,['      ',num2str(inputInfo.minX),'\n']);
        fprintf(fid,'    YMin:\n');
        fprintf(fid,['      ',num2str(inputInfo.minY),'\n']);
        fprintf(fid,'    ZMin:\n');
        fprintf(fid,['      ',num2str(inputInfo.minZ),'\n']);
        
        fprintf(fid,'  Sample Max:\n');
        fprintf(fid,'    XMax:\n');
        fprintf(fid,['      ',num2str(inputInfo.maxX),'\n']);
        fprintf(fid,'    YMax:\n');
        fprintf(fid,['      ',num2str(inputInfo.maxY),'\n']);
        fprintf(fid,'    ZMax:\n');
        fprintf(fid,['      ',num2str(inputInfo.maxZ),'\n']);
        
        fprintf(fid,'  Grad. IsoCtr:\n');
        fprintf(fid,'    XCtr:\n');
        fprintf(fid,['      ',num2str(inputInfo.ctrX),'\n']);
        fprintf(fid,'    YCtr:\n');
        fprintf(fid,['      ',num2str(inputInfo.ctrY),'\n']);
        fprintf(fid,'    ZCtr:\n');
        fprintf(fid,['      ',num2str(inputInfo.ctrZ),'\n']);
        
        fprintf(fid,'  FOV Offset:\n');
        fprintf(fid,'    XSet:\n');
        fprintf(fid,['      ',num2str(inputInfo.setX),'\n']);
        fprintf(fid,'    YSet:\n');
        fprintf(fid,['      ',num2str(inputInfo.setY),'\n']);
        fprintf(fid,'    ZSet:\n');
        fprintf(fid,['      ',num2str(inputInfo.setZ),'\n']);
        
        %Check What is the purpose of Filter
        fprintf(fid,'  Filter:\n');
        fprintf(fid,['      ','0','\n']);
        
        fprintf(fid,'  Model Res.:\n');
        fprintf(fid,'    XWid:\n');
        fprintf(fid,['      ',num2str(inputInfo.widX),'\n']);
        fprintf(fid,'    YWid:\n');
        fprintf(fid,['      ',num2str(inputInfo.widY),'\n']);
        fprintf(fid,'    ZWid:\n');
        fprintf(fid,['      ',num2str(inputInfo.widZ),'\n']);
                
        fprintf(fid,'\nSEQUENCE PARAMETER SETUP:\n');
        fprintf(fid,'  B0(T):\n');
        fprintf(fid,['    ',num2str(val.fields.B0),'\n']);
        
        fprintf(fid,'  Sequence Type:\n');
        fprintf(fid,['    ',sequenceTypes{val.sequence.sequencename},'\n']);
        
        fprintf(fid,'  RF Shape:\n');
        fprintf(fid,['    ',RFShapeTypes{val.sequence.rfshape},'\n']);
        
        fprintf(fid,'  RF Duration(ms):\n');
        fprintf(fid,['    ',num2str(val.sequence.rfpd),'\n']);
        
        fprintf(fid,'  # Points in RF Pulse:\n');
        fprintf(fid,['    ',num2str(val.sequence.nrfp),'\n']);
        
        fprintf(fid,'  RF Flip Angle:\n');
        fprintf(fid,['    ',num2str(val.sequence.rffa),'\n']);
        
        fprintf(fid,'  FOV(mm)\n');
        fprintf(fid,['    ',num2str(val.sequence.fov0),'  ',num2str(val.sequence.fov1),'\n']);
        
        fprintf(fid,'  MatSize:\n');
        fprintf(fid,['    ',num2str(val.sequence.matrixsize0),'  ',num2str(val.sequence.matrixsize1),'\n']);
        
        fprintf(fid,'  ADC Freq(kHz):\n');
        fprintf(fid,['    ',num2str(val.sequence.rbw),'\n']);
        
        fprintf(fid,'  TI_Duration(ms):\n');
        fprintf(fid,['    ',num2str(val.sequence.TI),'\n']);
        
        fprintf(fid,'  Gradient ON:\n');
        fprintf(fid,'    SS:\n');
        fprintf(fid,['      ',num2str(val.sequence.ss),'\n']);
        fprintf(fid,'    PE:\n');
        fprintf(fid,['      ',num2str(val.sequence.pe),'\n']);
        fprintf(fid,'    FE:\n');
        fprintf(fid,['      ',num2str(val.sequence.fe),'\n']);
        
        fprintf(fid,'  TE(ms):\n');
        fprintf(fid,['    ',num2str(val.sequence.TE),'\n']);
        
        fprintf(fid,'  TR(ms):\n');
        fprintf(fid,['    ',num2str(val.sequence.TR),'\n']);
        
        fprintf(fid,'  #Dummy TRs:\n');
        fprintf(fid,['    ',num2str(val.sequence.dTR),'\n']);
        
        fprintf(fid,'  PE Direct:\n');
        fprintf(fid,['    ',PEDirect{val.sequence.pedirection},'\n']);
        
        %NumIso for now assigned to 1
        fprintf(fid,'\nPROGRAM INFO:\n');
        fprintf(fid,'  NumIsoMenu:\n');
        fprintf(fid,['    ','1','\n']);
        
%         fprintf(fid,'  NumIsoX:\n');
%         fprintf(fid,['    ',num2str(inputInfo.NumIso(1)),'\n']);
%         fprintf(fid,'  NumIsoY:\n');
%         fprintf(fid,['    ',num2str(inputInfo.NumIso(2)),'\n']);
%         fprintf(fid,'  NumIsoZ:\n');
%         fprintf(fid,['    ',num2str(inputInfo.NumIso(3)),'\n']);
        
        %Thread for now is assigned to 1
        fprintf(fid,'  Thread #:\n');
        fprintf(fid,['    ','1','\n']);
        
        fprintf(fid,'  Mode:\n');
        fprintf(fid,['    ',ModeComputation{modeComp},'\n']);
        
        fclose(fid);
        
        fileprotdone = 1;
%         
%         if strcmp(flag,'')
%             msgbox(['Protocols saved to file ',get(hStudyName,'String'),'.prot']);
%         end;
%                 
        % cd(tempAddr);
%         clear tempAddr;
    end
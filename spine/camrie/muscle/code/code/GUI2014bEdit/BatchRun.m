function BatchRun

clc

addr = 'C:\Users\Zhipeng\Dropbox\Vanderbilt\MRF\GUI2014b';
addpath(genpath([pwd,'\Bin\']));
addpath(genpath([pwd,'\SeqDev\']));

%% Generate Sequence
global interSeqData inputInfo;

inputInfo.currentX = 146;
inputInfo.currentY = 80;
inputInfo.currentZ = 110;
inputInfo.ctrX = 146;
inputInfo.ctrY = 80;
inputInfo.ctrZ = 86;
inputInfo.widX = 2;
inputInfo.widY = 2;
inputInfo.widZ = 2;

tempStr = 'GRE_EPI_s';
% tempStr = 'GRE_EPI';
% tempStr = 'GRE';
StudyName = 'MPF1';

Tx.Num = 1; Rx.Num = 1; Tx.MagMat = 1; Tx.PhsMat = 0;
OrientationMenu = 1;

Tx.MagMat = 1;
Tx.PhsMat = 0;
    
MatSize.value(1) = 128;
MatSize.value(2) = 128;

FOV.value(1) = 256; %mm
FOV.value(2) = 256; %mm

RF.Duration = 2.6; %ms
RF.Num = 128;
RF.Shape = 1;

ADC.BW = 500; %kHz

GradOn.ss = 1; %gradients are specified in mT/m, but here it is a on/off flag.
GradOn.fe = 1;
GradOn.pe = 1;
peDirectoin = {'P--A'};

dummy = 30;
if strcmp(tempStr,'GRE_EPI') | strcmp(tempStr,'GRE_EPI_s')
    dummy = 0;
end;

slice.TH = 2/1000; % m.
switch OrientationMenu
    case 1
        slice.offset = (inputInfo.currentZ - inputInfo.ctrZ)*inputInfo.widZ/1000;
    case 2
        slice.offset = (inputInfo.currentX - inputInfo.ctrX)*inputInfo.widX/1000;
    case 3
        slice.offset = (inputInfo.currentY - inputInfo.ctrY)*inputInfo.widY/1000;
end;
    
%% Run Sequence
RFList(1) = 6;
RFList(2) = 4.5;

% TRList(1) = 50;
% TRList(2) = 1300;

for IDX = 1:1
    
    RF.FA = RFList(IDX); % Degrees
    TE = 3; %ms
    % TR = TRList(IDX); %ms % MRF
    TR = 5000;
    TI = 100; %ms

    keyboard
    [minTE,minTR] = eval([tempStr,'(TE,TR,MatSize,FOV,RF,ADC,GradOn,dummy,slice)']);
    if TE < minTE
        TE = minTE;
    end;
    if TR < minTR
        TR = minTR;
    end;
    
    % For GRE
%     interSeqData = SeqInterfaceOut(tempStr,1,TE,TR,MatSize,[],FOV,[],RF,ADC,GradOn,dummy,slice,TI);

    % For GRE_EPI
    interSeqData = SeqInterfaceOut(tempStr,1,TE,TR,MatSize,[],FOV,[],RF,ADC,GradOn,dummy,slice);

    interSeqData = checkSeqProt(interSeqData);
    finalSeqData = combineSeq(interSeqData,OrientationMenu,peDirectoin,dummy); %

    expSeq(finalSeqData,dummy,Tx,Rx); %

NumIsoX = 1; NumIsoY = 1; NumIsoZ = 1;
Thread = 4;
B0Strength = 7; % Tesla
GeometryFile = [addr,'\NewHeadModel\head2x2x2.smpl'];
TissueTypeFile = [addr,'\NewHeadModel\NewHead_2mm_300MHz\Tissue_300MHz.prop'];
SequenceFile = [addr,'\Protocols\',StudyName,'\',tempStr,'.seqn'];

%% Run Commands
%     runScriptSignal = ['"',addr,'\Engine\NutateSignalSimpleTx"',...
%     runScriptSignal = ['"',addr,'\Engine\NutateSignalAdvancedTx"',...
%     runScriptSignal = ['"',addr,'\Engine\NutateSignal"',...

runScriptSignal = ['"',addr,'\Nutate04.2013\Nutate\x64\Release\NutateSignal"',...
        ' "NumIsoX=',num2str(NumIsoX),'"',...
        ' "NumIsoY=',num2str(NumIsoY),'"',...
        ' "NumIsoZ=',num2str(NumIsoZ),'"',...
        ' "Thread=',num2str(Thread),'"',...
        ' "B0=',num2str(B0Strength),'"',...
        ' "GeometryFile=',GeometryFile,'"',...
        ' "TissueTypeFile=',TissueTypeFile,'"',...
        ' "SequenceFile=',SequenceFile,'"'];

runScriptSignal = [runScriptSignal, ' "KSpaceFile=',StudyName,num2str(IDX),'.ksig"'];
    
B0FileName = 'head2x2x2_dB0.db0';
if 1
    runScriptSignal = [runScriptSignal, ' "DelB0File=',[addr,'\NewHeadModel\',B0FileName],'"'];
end;

B1pFileName{1} = 'all1Bp.bfld';
% B1pFileName{1} = ;
% B1pFileName{2} = ;
% B1pFileName{3} = ;
% B1pFileName{4} = ;
% B1pFileName{5} = ;
% B1pFileName{6} = ;
% B1pFileName{7} = ;
% B1pFileName{8} = ;
if 1
    for n = 1:Tx.Num
        runScriptSignal = [runScriptSignal, ' "B1PlusFile=',[addr,'\NewHeadModel\NewHead_2mm_300MHz\bin\',B1pFileName{1}],'"']; %#ok<AGROW>
    end;
end;

B1mFileName{1} = 'all2Bm.bfld';
if 0
    for n = 1:Rx.Num
        runScriptSignal = [runScriptSignal, ' "B1MinsFile=',[addr,'\NewHeadModel\NewHead_2mm_300MHz\bin\',B1mFileName{1}],'"']; %#ok<AGROW>
    end;
end;

if 0
    runScriptSignal = [runScriptSignal, ' "DelGxFile=',[inputCmd{9,1},inputCmd{9,2}],'"'];
    runScriptSignal = [runScriptSignal, ' "DelGyFile=',[inputCmd{10,1},inputCmd{10,2}],'"'];
    runScriptSignal = [runScriptSignal, ' "DelGzFile=',[inputCmd{11,1},inputCmd{11,2}],'"'];
end;

XMin = 29; XMax = 272;
YMin =  8; YMax = 145;
ZMin = 110; ZMax = 110;
runScriptSignal = [runScriptSignal, ...
    ' "xMin=',mat2str(XMin),'"',...
    ' "xMax=',mat2str(XMax),'"',...
    ' "yMin=',mat2str(YMin),'"',...
    ' "yMax=',mat2str(YMax),'"',...
    ' "zMin=',mat2str(ZMin),'"',...
    ' "zMax=',mat2str(ZMax),'"',...
    ' "xCtr=',mat2str(inputInfo.ctrX),'"',...
    ' "yCtr=',mat2str(inputInfo.ctrY),'"',...
    ' "zCtr=',mat2str(inputInfo.ctrZ),'"',...
    ];

% Generate bat file
fid=fopen([addr,'\Protocols\',StudyName,'\','runSignal.bat'],'w');
fprintf(fid,[slashCvrt(runScriptSignal),'\n']);
fprintf(fid,'exit\n');
fclose(fid);

% For Windows system:
runScript = ['runSignal', ' &'];

dos(runScript);

cd(addr);

end;

    %% Export Sequence Function
    function expSeq(finalSeqData,dummy,Tx,Rx)
        
        % Create folder 'Protocols' if it does not exist.
        if exist([addr,'\Protocols\',StudyName],'file')~=7
            mkdir([addr,'\Protocols\',StudyName]);
        end;
        
        cd([addr,'\Protocols\',StudyName]);
        
        fid=fopen([tempStr,'.seqn'],'w');

        fwrite(fid,finalSeqData.totalNum,'float32');
        fwrite(fid,Tx.Num,'float32');
        fwrite(fid,Rx.Num,'float32');
        
        % Time
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Time.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Time.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Time.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Time.value),'float32');
        fwrite(fid,finalSeqData.Main.Time.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Time.value,'float32');
        
        % ADC
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.ADC.value),'float32');
            fwrite(fid,finalSeqData.Dummy.ADC.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.ADC.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.ADC.value),'float32');
        fwrite(fid,finalSeqData.Main.ADC.repeat,'float32');
        fwrite(fid,finalSeqData.Main.ADC.value,'float32');
        
        % RF
        if dummy > 0
            for m=1:Tx.Num
                fwrite(fid,size(finalSeqData.Dummy.RF.value,2),'float32');
                fwrite(fid,finalSeqData.Dummy.RF.repeat,'float32');
                for n=1:size(finalSeqData.Dummy.RF.value,2)
                    fwrite(fid,real(finalSeqData.Dummy.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Dummy.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Dummy.DFreq.value(m,n),'float32');
                end;
            end;
        end;
        
        temp = 0;
        for m=1:Tx.Num
            fwrite(fid,size(finalSeqData.Main.RF.value,2),'float32');
            fwrite(fid,finalSeqData.Main.RF.repeat,'float32');
            if Tx.Num == size(finalSeqData.Main.RF.value,1)
                for n=1:size(finalSeqData.Main.RF.value,2)
                    fwrite(fid,real(finalSeqData.Main.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Main.RF.value(m,n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Main.DFreq.value(n),'float32');
                    temp = temp + 1;
                end;
            else
                for n=1:size(finalSeqData.Main.RF.value,2)
                    fwrite(fid,real(finalSeqData.Main.RF.value(n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,imag(finalSeqData.Main.RF.value(n)*Tx.MagMat(m)*exp(1i*Tx.PhsMat(m)/180*pi)),'float32');
                    fwrite(fid,finalSeqData.Main.DFreq.value(n),'float32');
                    temp = temp + 1;
                end;
            end;
        end;
        
        % Gx
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gx.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gx.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gx.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gx.value),'float32');
        fwrite(fid,finalSeqData.Main.Gx.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gx.value,'float32');
        
        % Gy
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gy.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gy.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gy.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gy.value),'float32');
        fwrite(fid,finalSeqData.Main.Gy.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gy.value,'float32');
        
        % Gz
        if dummy > 0
            fwrite(fid,length(finalSeqData.Dummy.Gz.value),'float32');
            fwrite(fid,finalSeqData.Dummy.Gz.repeat,'float32');
            fwrite(fid,finalSeqData.Dummy.Gz.value,'float32');
        end;
        fwrite(fid,length(finalSeqData.Main.Gz.value),'float32');
        fwrite(fid,finalSeqData.Main.Gz.repeat,'float32');
        fwrite(fid,finalSeqData.Main.Gz.value,'float32');
        
        fclose(fid);
       
    end
end
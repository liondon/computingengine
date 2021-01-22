
function Strname = writeBatchSignal(val, inputInfo, SlicePosition, enginepath)

CompCommand = 'NutateSignal';

filename = strcat(val.path, CompCommand, num2str(SlicePosition),'.bat');

fid = fopen(filename, 'w');

%Write Echo
temp = strcat('echo y | wine');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Command
temp = strcat('"',enginepath, CompCommand,'"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Iso, Threads
%temp = strcat('"NumIso=1" "Thread=1" ');
temp = strcat('"NumIsoX=1" "NumIsoY=1" "NumIsoZ=1" "Thread=1" ');
fprintf(fid,[slashCvrt(temp),' ']);

%Write B0
temp = strcat('"B0=', num2str(val.fields.B0), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Geometry
temp = strcat('"GeometryFile=',val.path, 'Geometry.geo', '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Tissue
temp = strcat('"TissueTypeFile=',val.path, 'Tissue.tiss', '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Sequence
temp = strcat('"SequenceFile=',val.path, 'Sequence.seqn', '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write DB0
if isempty(val.fields.tdb) < 1
    temp = strcat('"DelB0File=',val.path, 'Delta.b0', '"');
    fprintf(fid,[slashCvrt(temp),' ']);
end

%Write Bplus Files
if isempty(val.fields.b1plus)<1
    for n = 1:length(val.fields.b1plus)
        temp = strcat('"B1PlusFile=',val.path, 'B1p', num2str(n), '.bpfld"');
        fprintf(fid,[slashCvrt(temp),' ']);
    end
end

%Write Bminus Files
if isempty(val.fields.b1minus)<1
    for n = 1:length(val.fields.b1minus)
        temp = strcat('"B1MinsFile=',val.path, 'B1m', num2str(n), '.bmfld"');
        fprintf(fid,[slashCvrt(temp),' ']);
    end
end

%Write DelGx File
if isempty(val.fields.gradx) < 1
    temp = strcat('"DelGxFile=',val.path, 'Grad.x', '"');
    fprintf(fid,[slashCvrt(temp),' ']);
end

%Write DelGy File
if isempty(val.fields.grady) < 1
    temp = strcat('"DelGxFile=',val.path, 'Grad.y', '"');
    fprintf(fid,[slashCvrt(temp),' ']);
end

%Write DelGz File
if isempty(val.fields.gradz) < 1
    temp = strcat('"DelGzFile=',val.path, 'Grad.z', '"');
    fprintf(fid,[slashCvrt(temp),' ']);
end

%Write KSpace
temp = strcat('"KSpaceFile=',val.path, 'KSpace.ksig', '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write KMap
temp = strcat('"KMapFile=',val.path, 'KMap.ktrj', '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write xMin
temp = strcat('"xMin=',num2str(inputInfo.minX), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write xMax
temp = strcat('"xMax=',num2str(inputInfo.maxX), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write yMin
temp = strcat('"yMin=',num2str(inputInfo.minY), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write yMax
temp = strcat('"yMax=',num2str(inputInfo.maxY), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write zMin
temp = strcat('"zMin=',num2str(inputInfo.minZ), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write zMax
temp = strcat('"zMax=',num2str(inputInfo.maxZ), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write xCtr
temp = strcat('"xCtr=',num2str(inputInfo.ctrX), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write yCtr
temp = strcat('"yCtr=',num2str(inputInfo.ctrY), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%Write zCtr
temp = strcat('"zCtr=',num2str(inputInfo.ctrZ), '"');
fprintf(fid,[slashCvrt(temp),' ']);

%######END######
fprintf(fid, '\nexit');

fclose(fid);


fid = fopen(filename, 'r');

Strname = fgetl(fid);

fclose(fid);

function Strname = writeBatchNoise(val, inputInfo, enginepath)

CompCommand = 'NutateNoise';

filename = strcat(val.path, CompCommand,'.bat');

fid = fopen(filename, 'w');

%Write Echo
temp = strcat('echo y | wine');
fprintf(fid,[slashCvrt(temp),' ']);

%Write Command
temp = strcat('"',enginepath, CompCommand,'"');
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

%Write Eminus Files
if isempty(val.fields.ereceived)<1
    for n = 1:length(val.fields.ereceived)
        temp = strcat('"E1MinsFile=',val.path, 'E1m', num2str(n), '.emfld"');
        fprintf(fid,[slashCvrt(temp),' ']);
    end
end

%Write KSpace
temp = strcat('"KNoiseFile=',val.path, 'Noise.nois', '"');
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


%######END######
fprintf(fid, '\nexit');

fclose(fid);


fid = fopen(filename, 'r');

Strname = fgetl(fid);

fclose(fid);
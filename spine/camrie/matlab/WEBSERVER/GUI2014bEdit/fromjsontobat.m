
function batfile = fromjsontobat(jsonfile, OutputJson,logJson,parentdir)
MAINPATH=pwd;
batfile =0;

functionspath = pwd;
%####Cambiare Questo a fileread####
val = jsondecode(fileread(jsonfile));
%val = jsonfile;

%enginepath = 'E:\Giuseppe\Giuseppe\NYU\PSUdoMRI Cloud\GUI2014bEdit\Engine\';
%enginepath = '/home/giuseppe/Documents/MATLAB/CAMRIE/Engine/';
enginepath = strcat(functionspath, '/Engine/');


val.ID = char(java.util.UUID.randomUUID);

%parentdir = 'E:\Giuseppe\Giuseppe\NYU\PSUdoMRI Cloud\GUI2014bEdit\Tmp\'
%parentdir = '/home/giuseppe/Documents/MATLAB/CAMRIE/TmpAttempt/'

mkdir(parentdir, val.ID);

%val.path = strcat(parentdir, val.ID, '\');
val.path = strcat(parentdir, val.ID, '/');

%OutputJson = strcat(val.path, OutputJson);

%filetest = 'E:\Giuseppe\Giuseppe\PSUdoMRI\Models\Head 2mm 125MHz\txt\head_2x2x2.txt';

val = changestrings(val);

fileinput = val.geometry.link;


val.test = fileinput;
temp = strcat(val.path, 'InputGeometry.txt');
filetest = websave(temp, fileinput);

%if fileinput is already a txt no ned to convert.  i think it's not converting @Giuseppe cn
%you check?
[~,~,ext]=fileparts(fileinput);
if strcmp(ext,'.txt')
else
%convertfile = 'E:\Giuseppe\Giuseppe\NYU\PSUdoMRI Cloud\GUI2014bEdit\Conversion Tools\txt2bin.exe';

end
convertfile = strcat(functionspath, '/Conversion Tools/txt2bin.exe');
copyfile(convertfile, val.path);
convertfile = 'txt2bin.exe';

%@Giuseppe line 67:
% readInput(filetest, 1); %@Giuseppe this file need txt?
%give me an error if i pass the smpl file
%Class Paths
cd ..
webserverpath = pwd;
addpath(strcat(webserverpath, '/classes/NEW'))
addpath(strcat(webserverpath, '/Utils'))
cd(functionspath);

%addpath('C:\Users\Giuseppe\Documents\PsudoMRI\matlab\WEBSERVER\classes\NEW')
%addpath('C:\Users\Giuseppe\Documents\PsudoMRI\matlab\WEBSERVER\Utils')

OutClass=CLOUDMROutput();
%OutputJson = 'Prova.json';

try
    inputInfo = readInput(filetest, 1); %@Giuseppe this file need txt?
    
    inputInfo.setX = val.sequence.setX;
    inputInfo.setY = val.sequence.setY;
    inputInfo.setZ = val.sequence.setZ;
    
    % val.sequence.rfshape=str2double(val.sequence.rfshape);
    % val.sequence.pedirection = str2double(val.sequence.pedirection);
    % val.sequence.sliceorientation = str2double(val.sequence.sliceorientation);
    % val.sequence.sequencename = str2double(val.sequence.sequencename);
    
    
    switch(val.sequence.sliceorientation)
        case 1
            slicemin = inputInfo.minZ;
            slicemax = inputInfo.maxZ;
        case 2
            slicemin = inputInfo.minX;
            slicemax = inputInfo.maxX;
        case 3
            slicemin = inputInfo.minY;
            slicemax = inputInfo.maxY;
    end
    OutClass.logIT('Loaded Geometry Info','info');
catch
    OutClass.logIT('Error Loading Geometry Info','error');
    %temp = strcat(val.path, OutputJson);
    OutClass.exportLOG(logJson);
    OutClass.exportResults(OutputJson)
    return;
end

%#####DEBUG####
slicemin=97;
slicemax = 99;

val.sequence

try
    %ImageMat = zeros(val.sequence.matrixsize0, val.sequence.matrixsize1, slicemax);
    KSigMat = zeros(val.sequence.matrixsize0, val.sequence.matrixsize1, slicemax+1, val.coils.receivingCoilsNumber);
    KDataMatCoils = zeros(val.sequence.matrixsize0, val.sequence.matrixsize1, slicemax+1, val.coils.receivingCoilsNumber);
    KDataMat = zeros(val.sequence.matrixsize0, val.sequence.matrixsize1, slicemax+1);
    KNoise = zeros(val.sequence.matrixsize0, val.sequence.matrixsize1, val.coils.receivingCoilsNumber);
    
    [peKey, x, y] = reshapematrixParameters(val, inputInfo);
catch
    OutClass.logIT('Error Initializing Sequences','error');
    %temp = strcat(val.path, OutputJson);

        OutClass.exportLOG(logJson);
    OutClass.exportResults(OutputJson)

    return;
end


okdown = downloadfiles(val, OutClass, convertfile, logJson);
if (okdown==0)
    OutClass.logIT('Error Writing Sequence File','error');
    OutClass.exportLOG(logJson);
    return;
end

cd(functionspath);
try
    sequencewrite(val, inputInfo);
catch
    OutClass.logIT('Error Writing Sequence File','error');
    %temp = strcat(val.path, OutputJson);
       OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson);
    return;
end
cd(functionspath);

if (val.output.noise)
    filenoise=writeBatchNoise(val, inputInfo, enginepath);
    cd(val.path);
    [status, result]=system(filenoise);
    if (status>0)
        OutClass.logIT('Error Computing noise','error');
        OutClass.logIT(result,'error');
        %temp = strcat(val.path, OutputJson);
           OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
        return;
    else
        OutClass.logIT('Noise Computed','info');
        OutClass.logIT(result,'info');
    end
    cd(functionspath);
    try
        for coil = 1:(val.coils.receivingCoilsNumber)
            noisefile = strcat(val.path, 'noiseSet1/Noise', num2str(coil), '.nois');
            KNoise(:,:,coil) = loadNoise(noisefile, val);
        end
        %temp = strcat(val.path, OutputJson);
        OutClass.addtoExporter('image2D', 'K Matrix Noise', KNoise);
        OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
    catch
        OutClass.logIT('Error Loading noise File','error');
        %temp = strcat(val.path, OutputJson);
           OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
        return;
    end
end

if (val.output.signal)
    for slice = slicemin:slicemax
        switch(val.sequence.sliceorientation)
            case 1
                inputInfo.minZ = slice-1;
                inputInfo.currentZ = slice;
                inputInfo.maxZ = slice+1;
            case 2
                inputInfo.minX = slice-1;
                inputInfo.currentX = slice;
                inputInfo.maxX = slice+1;
            case 3
                inputInfo.minY = slice-1;
                inputInfo.currentY = slice;
                inputInfo.maxY = slice+1;
        end
        
        createProtFile(val, inputInfo, slice, 1);
        try
            sequencewrite(val, inputInfo);
        catch
            OutClass.logIT('Error Writing Sequence File','error');
            %temp = strcat(val.path, OutputJson);
               OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
            return;
        end
        cd(functionspath);
        filesignal = writeBatchSignal(val, inputInfo, slice, enginepath);
        cd(val.path);
        [status, result]=system(filesignal);
        if (status>0)
            OutClass.logIT('Error Computing signal','error');
            OutClass.logIT(result,'error');
            %temp = strcat(val.path, OutputJson);
               OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
            return;
        else
            temp = strcat('Slice ', num2str(slice), ' computed');
            OutClass.logIT(result,'info');
            OutClass.logIT(temp,'info');
        end
        cd(functionspath);
        try
            for coil = 1:(val.coils.receivingCoilsNumber)
                sigfile = strcat(val.path, 'KSpace', num2str(coil), '.ksig');
                KSigMat(:,:,slice,coil) = loadSignal(sigfile, val, x, y);
                KDataMatCoils(:,:,slice, coil) = KSigMat(:,:,slice,coil)+KNoise(:,:,coil);
                
            end
        catch
            OutClass.logIT('Error Loading Signal File','error');
            %temp = strcat(val.path, OutputJson);
               OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
            return;
        end
        
    end
end

for coil = 1:(val.coils.receivingCoilsNumber)
    namevarSig = strcat('K Signal Matrix Coil', num2str(coil));
    OutClass.addToExporter('image2D', namevarSig, KSigMat(:,:,:,coil));
end
%temp = strcat(val.path, OutputJson);
OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)

try
    Imslice = fromktoimageSingle(KDataMatCoils(:,:,1,1), peKey);
catch
    OutClass.logIT('Error Creating Image','error');
    %temp = strcat(val.path, OutputJson);
       OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
    return;
end

siKdata = size(KDataMatCoils);
siImage = size(Imslice);

ImDataCoils = zeros(siImage(1), siImage(2), slicemax+1, val.coils.receivingCoilsNumber);
ImData = zeros(siImage(1), siImage(2), siKdata(3));

try
    for slice = 1:slicemax+1
        for coil = 1:val.coils.receivingCoilsNumber
            ImDataCoils(:,:,slice, coil) = fromktoimageSingle(KDataMatCoils(:,:,slice, coil), peKey);
        end
    end
    
    for coil = 1:(val.coils.receivingCoilsNumber)
        namevarSigIm = strcat('Image Signal Matrix Coil', num2str(coil));
        OutClass.addToExporter('image2D', namevarSigIm, ImDataCoils(:,:,:,coil));
        
    end
    %temp = strcat(val.path, OutputJson);
    OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
    
catch
    OutClass.logIT('Error Creating Images','error');
    %temp = strcat(val.path, OutputJson);
       OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
    return;
end

try
    nRx = val.coils.receivingCoilsNumber;
    sumMethod = val.imagereconstruction;
    for slice = slicemin:slicemax
        for recCoil = 1:nRx
            if sumMethod==1 %Sum of Square
                ImData(:,:,slice)=ImData(:,:,slice)+abs(ImDataCoils(:,:,slice,recCoil)).^2;
                KDataMat(:,:,slice)=KDataMat(:,:,slice)+abs(KDataMatCoils(:,:,slice,recCoil)).^2;
            else %Sum of Magnitude
                ImData(:,:,slice)=ImData(:,:,slice)+abs(ImDataCoils(:,:,slice,recCoil));
                KDataMat(:,:,slice)=KDataMat(:,:,slice)+abs(KDataMatCoils(:,:,slice,recCoil));
            end
        end
    end
    if sumMethod==1
        ImData = sqrt(ImData);
    end
    
    OutClass.addToExporter('image2D', 'K Matrix Data', KDataMat);
    OutClass.addToExporter('image2D', 'Image Matrix Data', ImData);
    %temp = strcat(val.path, OutputJson);
     %    OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
catch
    OutClass.logIT('Error Combining Images','error');
    %temp = strcat(val.path, OutputJson);
       OutClass.exportLOG(logJson);     OutClass.exportResults(OutputJson)
    return;
end

%cd(val.path);
%save('FilesOutput.mat');
OutClass.logIT('Simulation Completed','OK');
%temp = strcat(val.path, OutputJson);
     OutClass.exportLOG(logJson);
    OutClass.exportResults(OutputJson)

    %delete the temp directory
    rmdir(val.path, 's') ;
end



%%
function inputInfo = readInput(tissueFile, orientation)

fid = fopen(tissueFile, 'r');
inputInfo.filename = tissueFile;
temp = fscanf(fid, '%d', 1);
inputInfo.totNumVox = temp;
a = fscanf(fid, '%d %d', [1,2]);
inputInfo.minX = a(1);
inputInfo.maxX = a(2);

a = fscanf(fid, '%d %d', [1,2]);
inputInfo.minY = a(1);
inputInfo.maxY = a(2);

a = fscanf(fid, '%d %d', [1,2]);
inputInfo.minZ = a(1);
inputInfo.maxZ = a(2);

A = fscanf(fid, '%d %d %d', [1, 3]);
a = A(1); b = A(2); c = A(3);
inputInfo.ctrX = a;
inputInfo.currentX = a;
inputInfo.ctrY = b;
inputInfo.currentY = b;
inputInfo.ctrZ = c;
inputInfo.currentZ = c;

A = fscanf(fid, '%d %d %d', [1,3]);
a = A(1); b = A(2); c = A(3);
inputInfo.widX = a;
inputInfo.widY = b;
inputInfo.widZ = c;


switch(orientation)
    case 1
        inputInfo.sliceTH = inputInfo.widZ;
    case 2
        inputInfo.sliceTH = inputInfo.widX;
    case 3
        inputInfo.sliceTH = inputInfo.widY;
end

fclose(fid);

end

%%
function [peKey, x, y] = reshapematrixParameters(val, inputInfo)

mSizeLocal = [val.sequence.matrixsize0 val.sequence.matrixsize1];

Xmax = inputInfo.maxX;
Ymax = inputInfo.maxY;
Zmax = inputInfo.maxZ;

Xmin = inputInfo.minX;
Ymin = inputInfo.minY;
Zmin = inputInfo.minZ;

Xoffset = inputInfo.setX;
Yoffset = inputInfo.setY;
Zoffset = inputInfo.setZ;

sliceKey = val.sequence.sliceorientation;

if val.sequence.pedirection==1
    if sliceKey==1
        peKey=1;
    elseif sliceKey==2
        peKey=2;
    end
elseif val.sequence.pedirection==2
    if sliceKey==1
        peKey=2;
    elseif sliceKey==3
        peKey=2;
    end
elseif val.sequence.pedirection==3
    if sliceKey==2
        peKey=1;
    elseif sliceKey==3
        peKey=1;
    end
end

if val.sequence.pedirection==1
    switch sliceKey %set up coordinate sytem
        case 1
            y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
            x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
        case 2
            y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
            x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
    end
elseif val.sequence.pedirection==2
    switch sliceKey %set up coordinate sytem
        case 2
            x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
            y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
        case 3
            x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
            y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
    end
elseif val.sequence.pedirection==3
    switch sliceKey %set up coordinate sytem
        case 1
            x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
            y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
        case 3
            y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
            x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
    end
end

end

%%
function k_sig = loadSignal(sigfile, val, x, y)

mSizeLocal = [val.sequence.matrixsize0 val.sequence.matrixsize1];

fsig = fopen(sigfile, 'r');
[k_sig,cnt]=fread(fsig,[2,Inf],'float32');
fclose(fsig);

k_sig=reshape(k_sig(1,:)+1i*k_sig(2,:), mSizeLocal(1), mSizeLocal(2));

for i=1:mSizeLocal(1) %shift FOV along y
    k_sig(i,:)=k_sig(i,:)*exp(1i*2*pi*(y/mSizeLocal(1))*(i-mSizeLocal(1)/2));
end
for j=1:mSizeLocal(2) %shift FOV along x
    k_sig(:,j)=k_sig(:,j)*exp(1i*2*pi*(x/mSizeLocal(2))*(j-mSizeLocal(2)/2));
end

end

%%
function k_noise = loadNoise(noisefile, val)

    mSizeLocal = [val.sequence.matrixsize0 val.sequence.matrixsize1];
    
    fnoise=fopen(noisefile, 'r');
    [noise_data,cnt]=fread(fnoise,[2,Inf],'float32');
    fclose(fnoise);
    
    k_noise=reshape(noise_data(1,:)+1i*noise_data(2,:),mSizeLocal(1),mSizeLocal(2));

end

%%
function valoutput = changestrings(val)
valoutput = val;
valoutput.sequence.sequencename = str2double(val.sequence.sequencename);
valoutput.sequence.rfshape = str2double(val.sequence.rfshape);
valoutput.sequence.pedirection = str2double(val.sequence.pedirection);
valoutput.sequence.sliceorientation = str2double(val.sequence.sliceorientation);

end

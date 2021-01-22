function varargout = sar(varargin)
% SAR M-file for sar.fig
%      SAR, by itself, creates a new SAR or raises the existing
%      singleton*.
%
%      H = SAR returns the handle to a new SAR or the handle to
%      the existing singleton*.
%
%      SAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAR.M with the given input arguments.
%
%      SAR('Property','Value',...) creates a new SAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sar

% Last Modified by GUIDE v2.5 09-Mar-2010 16:16:54

% Begin initialization code - DO NOT EDIT
path(path,[pwd,'\Bin\']);
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sar_OpeningFcn, ...
                   'gui_OutputFcn',  @sar_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sar is made visible.
function sar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sar (see VARARGIN)

% Choose default command line output for sar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sar wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global sData;

sData.cd_dir=cd;

emptyScreen=zeros(256);
emptyScreen(1,1)=1;

axes(handles.axes1);
imagesc(emptyScreen);
axis image;
colormap(jet2);
colorbar('vert');
axis off;

set(handles.navi_slice,'enable','off');
set(handles.sliceNum,'enable','off');

sData.sameScale=1;
set(handles.sameScale,'value',1);
set(handles.sameScale,'enable','off');

set(handles.unAvgSAR_RBT,'value',1);
set(handles.oneAvgSAR_RBT,'value',0);
set(handles.tenAvgSAR_RBT,'value',0);

set(handles.unAvgSAR_RBT,'enable','inactive');
set(handles.oneAvgSAR_RBT,'enable','inactive');
set(handles.tenAvgSAR_RBT,'enable','inactive');

set(handles.scaNetPower_edit,'enable','off');

sData.scaledPower=[];

% --- Outputs from this function are returned to the command line.
function varargout = sar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function exit_Callback(hObject, eventdata, handles)
close(gcf);


function sarLoad_Callback(hObject, eventdata, handles)
global sData;
%cd(sData.cd_dir);

%initialization
set(handles.sameScale,'value',1);
set(handles.sameScale,'enable','off');
sData.sameScale=1;
sData.currentSlice=1;

%file reading
[filename,pathname]=uigetfile('*.sar','OPEN: SAR');
if filename==0
    return;
end
sData.cd_dir=pathname;
%cd(pathname);

fileName=[pathname,filename];
fid=fopen(fileName);
[sarRawData,cntSAR]=fread(fid,[5,Inf],'float32');
fclose(fid);

set(handles.loadSAR_edit,'string',fileName);

% parameter file reading
protFileName=[fileName(1,1:length(fileName)-4) '.prot'];
fid=fopen(protFileName);

protData=fgetl(fid);

while ischar(protData)
    protData=fgetl(fid);
    
    if ischar(protData)==0
        break;
    end
    
    % Tissue file name
    if strcmp(strtrim(protData),'Tissue Filename:')
        tissueFileName=strtrim(fgetl(fid));
    end
    
    %Slice orientation (1=axial, 2=sagittal, 3=coronal)
    if strcmp(strtrim(protData),'Slice Orientation:')
        sliceTemp=fgetl(fid);
        
        if strcmp(strtrim(sliceTemp),'Axial')
            sliceKey=1;
        elseif strcmp(strtrim(sliceTemp),'Sagittal')
            sliceKey=2;
        elseif strcmp(strtrim(sliceTemp),'Coronal')
            sliceKey=3;
        end        
    end
    
    % Model resolution (unit: meter)
    if strcmp(strtrim(protData),'XWid:')
        resX=str2num(fgetl(fid))*0.001;
    end
    
    if strcmp(strtrim(protData),'YWid:')
        resY=str2num(fgetl(fid))*0.001;
    end
    
    if strcmp(strtrim(protData),'ZWid:')
        resZ=str2num(fgetl(fid))*0.001;
    end
    
    %Matrix size
    if strcmp(strtrim(protData),'MatSize:')
        mSizeLocal=str2num(fgetl(fid));
    end
end
fclose(fid);

%Read tissue file to get tissue ID and its density
%   ID              tissueData{1}
%   T1              tissueData{2}   msec
%   T2              tissueData{3}   msec
%   Proton density  tissueData{4}
%   ChemShift       tissueData{5}   ppm?
%   SigmaCon        tissueData{6}   S/m
%   Density         tissueData{7}   kg/m3
%   Tissue name     tissueData{8}
fid=fopen(tissueFileName);
dummy=textscan(fid,'%s',1,'delimiter','\n');
tissueData=textscan(fid,'%d8 %f32 %f32 %f32 %f32 %f32 %f32 %s','delimiter','\n');
fclose(fid);

tissueID=tissueData{1};
density=tissueData{7};

sData.tissueData=tissueData;

maxX=max(sarRawData(1,:));
minX=min(sarRawData(1,:));
maxY=max(sarRawData(2,:));
minY=min(sarRawData(2,:));
maxZ=max(sarRawData(3,:));
minZ=min(sarRawData(3,:));

switch sliceKey
    case 1 %axial
        nSlice=maxZ-minZ+1;
        loopCnt=cntSAR/5;
        sarDataTemp=zeros(nSlice,maxX-minX+1,maxY-minY+1);
        sarData=zeros(nSlice,maxY-minY+1,maxX-minX+1);
        
        densityTemp=zeros(nSlice,maxX-minX+1,maxY-minY+1);
        powerData=zeros(nSlice,1);
        
        for t=1:loopCnt
            sarDataTemp(sarRawData(3,t)-minZ+1,sarRawData(1,t)-minX+1,sarRawData(2,t)-minY+1)=sarRawData(5,t);
            densityTemp(sarRawData(3,t)-minZ+1,sarRawData(1,t)-minX+1,sarRawData(2,t)-minY+1)=density(tissueID==sarRawData(4,t),1);
        end
        
        for t=1:nSlice
            sarTemp=rot90(squeeze(sarDataTemp(t,:,:)),1);
            sarData(t,:,:)=sarTemp;
            powerData(t,1)=sum(sum(sarTemp.*rot90(squeeze(densityTemp(t,:,:)),1)))*resX*resY*resZ;
        end
        clear sarTemp sarDataTemp densityTemp;
        sData.powerData=powerData;
        netDissPower=sum(powerData);
        sData.netDissPower=netDissPower;
        
        maxSAR_whole=max(max(max(sarData)));
        maxSAR_local=max(max(squeeze(sarData(1,:,:))));
        
        %slider setting
        if nSlice~=1
            set(handles.navi_slice,'enable','on');
            set(handles.navi_slice,'max',nSlice);
            set(handles.navi_slice,'min',1);
            h=1/nSlice;
            set(handles.navi_slice,'sliderstep',[h*1 h*10]);
            set(handles.navi_slice,'value',1);
            set(handles.sliceNum,'string','1');
            
            set(handles.sliceNum,'enable','on');
            set(handles.sameScale,'enable','on');
            [maxS_whole maxTemp]=find(sarData==maxSAR_whole);
            maxH_whole=ceil(maxTemp/size(sarData,2));
            maxV_whole=rem(maxTemp,size(sarData,2));
            
            [maxV_local maxH_local]=find(squeeze(sarData(1,:,:))==maxSAR_local);
            maxS_local=1;
        else
            set(handles.navi_slice,'enable','off');
            set(handles.navi_slice,'value',1);
            set(handles.sliceNum,'string','1');
            
            set(handles.sliceNum,'enable','inactive');
            set(handles.sameScale,'enable','off');
            [maxV_whole maxH_whole]=find(squeeze(sarData)==maxSAR_whole);
            maxS_whole=1;
            
            [maxV_local maxH_local]=find(squeeze(sarData)==maxSAR_local);
            maxS_local=1;
        end
    case 2 %sagittal
    case 3 %coronal
end

sData.sarData=sarData;
sData.maxSAR_whole=maxSAR_whole;
sData.maxSAR_local=maxSAR_local;
sData.nSlice=nSlice;
set(handles.scaNetPower_edit,'enable','on');
sData.netDissPower_local=powerData(1,1);

%update output data
set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
set(handles.maxSAR_whole_pos_edit,'string',['(',num2str(maxS_whole),',',num2str(maxV_whole),',',num2str(maxH_whole),')']);

set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
set(handles.maxSAR_local_pos_edit,'string',['(',num2str(maxS_local),',',num2str(maxV_local),',',num2str(maxH_local),')']);

set(handles.comNetPower_edit,'string',num2str(netDissPower));
set(handles.comNetPower_local_edit,'string',num2str(powerData(1,1)));

axes(handles.axes1);
imagesc(squeeze(sarData(1,:,:)),[0 maxSAR_whole]);
axis image;
colormap(jet2);
colorbar('vert');
axis on;

function loadSAR_edit_Callback(hObject, eventdata, handles)


function loadSAR_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function navi_slice_Callback(hObject, eventdata, handles)
global sData;
sarData=sData.sarData;
maxSAR_whole=sData.maxSAR_whole;

currentSlice=round(get(handles.navi_slice,'value'));
set(handles.sliceNum,'string',num2str(currentSlice));
sData.currentSlice=currentSlice;

maxSAR_local=max(max(squeeze(sarData(currentSlice,:,:))));
sData.maxSAR_local=maxSAR_local;
[maxDummy maxTemp]=find(sarData(currentSlice,:,:)==maxSAR_local);
maxS_local=currentSlice;
maxH_local=ceil(maxTemp/size(sarData,2));
maxV_local=rem(maxTemp,size(sarData,2));
netDissPower_local=sData.powerData(currentSlice,1);
sData.netDissPower_local=netDissPower_local;

set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
set(handles.maxSAR_local_pos_edit,'string',['(',num2str(maxS_local),',',num2str(maxV_local),',',num2str(maxH_local),')']);

set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));

scaledPower=abs(str2num(get(handles.scaNetPower_edit,'string')));

if scaledPower==0
    set(handles.scaNetPower_edit,'string',num2str(sData.scaledPower));
    return;
end

if isempty(scaledPower) %if user input is in character or real empty, do nothing
    netDissPower_local=sData.netDissPower_local;
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(currentSlice,:,:)),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(currentSlice,:,:)),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;
else
    scalingFactor=scaledPower/sData.netDissPower;
    
    maxSAR_whole=sData.maxSAR_whole*scalingFactor;
    maxSAR_local=sData.maxSAR_local*scalingFactor;
    netDissPower_local=sData.netDissPower_local*scalingFactor;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(currentSlice,:,:)*scalingFactor),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(currentSlice,:,:)*scalingFactor),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;
end

function navi_slice_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sliceNum_Callback(hObject, eventdata, handles)
global sData;
sarData=sData.sarData;
maxSAR_whole=sData.maxSAR_whole;
nSlice=sData.nSlice;
currentSlice=sData.currentSlice;
sameScale=sData.sameScale;

currentSliceTemp=abs(round(str2num(get(handles.sliceNum,'string'))));

if isempty(currentSliceTemp)
    set(handles.sliceNum,'string',num2str(currentSlice));
    msgbox(['Check your slice number. Maximum slice number is ',num2str(nSlice),'.'],'Slice Number','error');
    return;    
end

if currentSliceTemp>nSlice
    set(handles.sliceNum,'string',num2str(currentSlice));
    msgbox(['Check your slice number. Maximum slice number is ',num2str(nSlice),'.'],'Slice Number','error');
    return;    
end

if currentSliceTemp==0
    set(handles.sliceNum,'string',num2str(currentSlice));
    msgbox('Check your slice number. Minimum slice number is 1.','Slice Number','error');
    return; 
end

set(handles.sliceNum,'string',num2str(currentSliceTemp));
sData.currentSlice=currentSliceTemp;
set(handles.navi_slice,'value',currentSliceTemp);

maxSAR_local=max(max(squeeze(sarData(currentSliceTemp,:,:))));
sData.maxSAR_local=maxSAR_local;
[maxDummy maxTemp]=find(sarData(currentSliceTemp,:,:)==maxSAR_local);
maxS_local=currentSliceTemp;
maxH_local=ceil(maxTemp/size(sarData,2));
maxV_local=rem(maxTemp,size(sarData,2));
netDissPower_local=sData.powerData(currentSliceTemp,1);
sData.netDissPower_local=netDissPower_local;

set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
set(handles.maxSAR_local_pos_edit,'string',['(',num2str(maxS_local),',',num2str(maxV_local),',',num2str(maxH_local),')']);

set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));

scaledPower=abs(str2num(get(handles.scaNetPower_edit,'string')));

if scaledPower==0
    set(handles.scaNetPower_edit,'string',num2str(sData.scaledPower));
    return;
end

if isempty(scaledPower) %if user input is in character or real empty, do nothing
    netDissPower_local=sData.netDissPower_local;
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(currentSliceTemp,:,:)),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(currentSliceTemp,:,:)),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;
else
    scalingFactor=scaledPower/sData.netDissPower;
    
    maxSAR_whole=sData.maxSAR_whole*scalingFactor;
    maxSAR_local=sData.maxSAR_local*scalingFactor;
    netDissPower_local=sData.netDissPower_local*scalingFactor;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(currentSliceTemp,:,:)*scalingFactor),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(currentSliceTemp,:,:)*scalingFactor),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;
end

function sliceNum_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sameScale_Callback(hObject, eventdata, handles)
global sData;
sarData=sData.sarData;
maxSAR_whole=sData.maxSAR_whole;
currentSlice=sData.currentSlice;
sameScale=get(handles.sameScale,'value');
sData.sameScale=sameScale;

scaledPower=abs(str2num(get(handles.scaNetPower_edit,'string')));

if scaledPower==0
    set(handles.scaNetPower_edit,'string',num2str(sData.scaledPower));
    return;
end

if isempty(scaledPower) %if user input is in character or real empty, do nothing
    maxSAR_whole=sData.maxSAR_whole;
    maxSAR_local=sData.maxSAR_local;
    netDissPower_local=sData.netDissPower_local;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(sData.currentSlice,:,:)),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(sData.currentSlice,:,:)),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;   
else    
    scalingFactor=scaledPower/sData.netDissPower;
    
    maxSAR_whole=sData.maxSAR_whole*scalingFactor;
    maxSAR_local=sData.maxSAR_local*scalingFactor;
    netDissPower_local=sData.netDissPower_local*scalingFactor;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));

    sData.scaledPower=scaledPower;

    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(sData.currentSlice,:,:)*scalingFactor),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(sData.currentSlice,:,:)*scalingFactor),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;        
end

function maxSAR_whole_val_edit_Callback(hObject, eventdata, handles)


function maxSAR_whole_val_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxSAR_whole_pos_edit_Callback(hObject, eventdata, handles)


function maxSAR_whole_pos_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxSAR_local_val_edit_Callback(hObject, eventdata, handles)


function maxSAR_local_val_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maxSAR_local_pos_edit_Callback(hObject, eventdata, handles)


function maxSAR_local_pos_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function unAvgSAR_RBT_Callback(hObject, eventdata, handles)


function oneAvgSAR_RBT_Callback(hObject, eventdata, handles)


function tenAvgSAR_RBT_Callback(hObject, eventdata, handles)


function scaleMenu_Callback(hObject, eventdata, handles)


function scaleMenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function avgSAR_edit_Callback(hObject, eventdata, handles)


function avgSAR_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max1gSAR_whole_val_edit_Callback(hObject, eventdata, handles)


function max1gSAR_whole_val_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max1gSAR_whole_pos_edit_Callback(hObject, eventdata, handles)


function max1gSAR_whole_pos_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max10gSAR_whole_val_edit_Callback(hObject, eventdata, handles)


function max10gSAR_whole_val_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function max10gSAR_whole_pos_edit_Callback(hObject, eventdata, handles)


function max10gSAR_whole_pos_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comNetPower_edit_Callback(hObject, eventdata, handles)


function comNetPower_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function scaNetPower_edit_Callback(hObject, eventdata, handles)
global sData;
sarData=sData.sarData;
netDissPower=sData.netDissPower;

scaledPower=abs(str2num(get(handles.scaNetPower_edit,'string')));

if scaledPower==0
    set(handles.scaNetPower_edit,'string',num2str(sData.scaledPower));
    return;
end

if isempty(scaledPower) %if user input is in character or real empty, do nothing
    maxSAR_whole=sData.maxSAR_whole;
    maxSAR_local=sData.maxSAR_local;
    netDissPower_local=sData.netDissPower_local;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));
    
    sData.scaledPower=scaledPower;
    
    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(sData.currentSlice,:,:)),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(sData.currentSlice,:,:)),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;   
else    
    scalingFactor=scaledPower/sData.netDissPower;
    
    maxSAR_whole=sData.maxSAR_whole*scalingFactor;
    maxSAR_local=sData.maxSAR_local*scalingFactor;
    netDissPower_local=sData.netDissPower_local*scalingFactor;
    set(handles.maxSAR_whole_val_edit,'string',num2str(maxSAR_whole));
    set(handles.maxSAR_local_val_edit,'string',num2str(maxSAR_local));
    set(handles.comNetPower_local_edit,'string',num2str(netDissPower_local));

    sData.scaledPower=scaledPower;

    axes(handles.axes1);
    if sData.sameScale
        imagesc(squeeze(sarData(sData.currentSlice,:,:)*scalingFactor),[0 maxSAR_whole]);
    else
        imagesc(squeeze(sarData(sData.currentSlice,:,:)*scalingFactor),[0 maxSAR_local]);
    end
    axis image;
    colormap(jet2);
    colorbar('vert');
    axis on;        
end

function scaNetPower_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function comNetPower_local_edit_Callback(hObject, eventdata, handles)


function comNetPower_local_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

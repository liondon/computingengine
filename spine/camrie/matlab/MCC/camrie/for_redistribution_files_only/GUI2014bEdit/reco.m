function varargout = reco(varargin)
% RECO M-file for reco.fig
%      RECO, by itself, creates a new RECO or raises the existing
%      singleton*.
%
%      H = RECO returns the handle to a new
%      RECO or the handle to
%      the existing singleton*.
%
%      RECO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECO.M with the given input arguments.
%
%      RECO('Property','Value',...) creates a new RECO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before reco_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to reco_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help reco

% Last Modified by GUIDE v2.5 08-Mar-2010 22:42:19

% Begin initialization code - DO NOT EDIT
path(path,[pwd,'\Bin\']);
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @reco_OpeningFcn, ...
                   'gui_OutputFcn',  @reco_OutputFcn, ...
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


% --- Executes just before reco is made visible.
function reco_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to reco (see VARARGIN)

% Choose default command line output for reco
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes reco wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global gData;

set(handles.im_mag,'value',1);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.sos_RBT,'enable','off');
set(handles.som_RBT,'enable','off');
set(handles.sos_RBT,'value',1);
set(handles.som_RBT,'value',0);
set(handles.loadData,'enable','on');

gData.sumMethod=1; %1=sum of square, 2=sum of magnitude

gData.currentViewPort=1;

set(handles.vPort1_check,'value',1);
set(handles.vPort2_check,'value',0);
set(handles.vPort3_check,'value',0);
set(handles.vPort4_check,'value',0);
gData.subKey1=0;

gData.cd_dir=cd;

set(handles.sub_RBT,'value',1);
set(handles.div_RBT,'value',0);
set(handles.add_RBT,'value',0);
set(handles.mul_RBT,'value',0);
set(handles.algebraSymbol,'string','-');

emptyScreen=zeros(256);
emptyScreen(1,1)=1;

axes(handles.viewer_axes1);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes2);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes3);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes4);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.hist_axes5);
emptyScreen1=ones(64);
imagesc(emptyScreen1,[0 1]);
axis image;
colormap(gray);
axis off;

gData.vPort1Image=[];
gData.vPort2Image=[];
gData.vPort3Image=[];
gData.vPort4Image=[];

gData.vPort1Kspace=[];
gData.vPort2Kspace=[];
gData.vPort3Kspace=[];
gData.vPort4Kspace=[];

gData.vPort1Noise=[];
gData.vPort2Noise=[];
gData.vPort3Noise=[];
gData.vPort4Noise=[];

gData.curPortData1=[];
gData.curPortData2=[];
gData.curPortData3=[];
gData.curPortData4=[];

gData.quantizedImage1=[];
gData.quantizedImage2=[];
gData.quantizedImage3=[];
gData.quantizedImage4=[];

gData.quantizedKspace1=[];
gData.quantizedKspace2=[];
gData.quantizedKspace3=[];
gData.quantizedKspace4=[];

gData.hist_result1=[];
gData.hist_result2=[];
gData.hist_result3=[];
gData.hist_result4=[];

gData.subKey1=0;
gData.subKey2=0;
gData.subKey3=0;
gData.subKey4=0;

gData.imMax1=[];
gData.imMin1=[];
gData.imMax2=[];
gData.imMin2=[];
gData.imMax3=[];
gData.imMin3=[];
gData.imMax4=[];
gData.imMin4=[];
gData.imMaxK1=[];
gData.imMinK1=[];
gData.imMaxK2=[];
gData.imMinK2=[];
gData.imMaxK3=[];
gData.imMinK3=[];
gData.imMaxK4=[];
gData.imMinK4=[];

gData.sub1=1;
gData.sub2=2;
gData.subResult=3;
set(handles.sub1,'value',1);
set(handles.sub2,'value',2);
set(handles.subResult,'value',3);
gData.algebraKey=1; %subtract

histSteps=256;
gData.yLimVal=200;
gData.histSteps=histSteps;

%slider setting (window width)
set(handles.w_slider,'max',histSteps);
set(handles.w_slider,'min',1);
h=1/histSteps;
%set(handles.w_slider,'sliderstep',[h*50 h*100]);
set(handles.w_slider,'sliderstep',[h*5 h*10]);
set(handles.w_slider,'value',histSteps);
set(handles.w_box,'string',num2str(histSteps));

%slider setting (window center)
set(handles.c_slider,'max',histSteps);
set(handles.c_slider,'min',1);
h=1/histSteps;
%set(handles.c_slider,'sliderstep',[h*50 h*100]);
set(handles.c_slider,'sliderstep',[h*5 h*10]);
set(handles.c_slider,'value',histSteps/2);
set(handles.c_box,'string',num2str(histSteps/2));

gData.w_sliderVal1=histSteps;
gData.w_sliderVal2=histSteps;
gData.w_sliderVal3=histSteps;
gData.w_sliderVal4=histSteps;
gData.c_sliderVal1=histSteps/2;
gData.c_sliderVal2=histSteps/2;
gData.c_sliderVal3=histSteps/2;
gData.c_sliderVal4=histSteps/2;

gData.w_sliderValK1=histSteps;
gData.w_sliderValK2=histSteps;
gData.w_sliderValK3=histSteps;
gData.w_sliderValK4=histSteps;
gData.c_sliderValK1=histSteps/2;
gData.c_sliderValK2=histSteps/2;
gData.c_sliderValK3=histSteps/2;
gData.c_sliderValK4=histSteps/2;

load buttons.mat;
set(handles.rot90_c,'CData',rot90_c);
set(handles.rot90_ac,'CData',rot90_ac);
set(handles.flip_LR,'CData',flip_LR);
set(handles.flip_UD,'CData',flip_UD);

%check-box status
gData.v1Status=[1 0 0 0 0 0 0];
gData.v2Status=[1 0 0 0 0 0 0];
gData.v3Status=[1 0 0 0 0 0 0];
gData.v4Status=[1 0 0 0 0 0 0];

%reset nRx
gData.nRx1=1;
gData.nRx2=1;
gData.nRx3=1;
gData.nRx4=1;

gData.noiseSF1=0;
gData.noiseSF2=0;
gData.noiseSF3=0;
gData.noiseSF4=0;

gData.mSizeLocal1=128;
gData.mSizeLocal2=128;
gData.mSizeLocal3=128;
gData.mSizeLocal4=128;

gData.noiseKey1=0;
gData.noiseKey2=0;
gData.noiseKey3=0;
gData.noiseKey4=0;

gData.peKey1=0;
gData.peKey2=0;
gData.peKey3=0;
gData.peKey4=0;

gData.sliceKey1=1;
gData.sliceKey2=1;
gData.sliceKey3=1;
gData.sliceKey4=1;
%%%%%%%%%%%%%%%

% --- Outputs from this function are returned to the command line.
function varargout = reco_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1}=handles.output;

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% global gData;
% gData.viewerClose=1;
delete(hObject);

% --- Executes on button press in vPort1_check.
function vPort1_check_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;
kspaceKey=gData.v1Status(1,5);

set(handles.vPort1_check,'value',1);
set(handles.vPort2_check,'value',0);
set(handles.vPort3_check,'value',0);
set(handles.vPort4_check,'value',0);
gData.currentViewPort=1;

if kspaceKey
    set(handles.w_slider,'value',gData.w_sliderValK1);
    set(handles.c_slider,'value',gData.c_sliderValK1);
    set(handles.w_box,'string',num2str(gData.w_sliderValK1));
    set(handles.c_box,'string',num2str(gData.c_sliderValK1));
else
    set(handles.w_slider,'value',gData.w_sliderVal1);
    set(handles.c_slider,'value',gData.c_sliderVal1);
    set(handles.w_box,'string',num2str(gData.w_sliderVal1));
    set(handles.c_box,'string',num2str(gData.c_sliderVal1));
end

%histogram
if kspaceKey
    if isempty(gData.hist_resultK1)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMinK1;
        currentW=gData.w_sliderValK1;
        currentC=gData.c_sliderValK1;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK1,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
else
    if isempty(gData.hist_result1)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMin1;
        currentW=gData.w_sliderVal1;
        currentC=gData.c_sliderVal1;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result1,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

%set check-box & sliders
if gData.subKey1
    set(handles.im_mag,'enable','off');
    set(handles.im_phs,'enable','off');
    set(handles.im_real,'enable','off');
    set(handles.im_imag,'enable','off');
    set(handles.ksp_mag,'enable','off');
    set(handles.ksp_real,'enable','off');
    set(handles.ksp_imag,'enable','off');
    
    set(handles.w_slider,'enable','off');
    set(handles.c_slider,'enable','off');
    set(handles.w_box,'enable','off');
    set(handles.c_box,'enable','off');
    
    gData.w_sliderVal1=gData.histSteps;
    gData.c_sliderVal1=gData.histSteps/2;
else
    set(handles.im_mag,'enable','on');
    set(handles.im_phs,'enable','on');
    set(handles.im_real,'enable','on');
    set(handles.im_imag,'enable','on');
    set(handles.ksp_mag,'enable','on');
    set(handles.ksp_real,'enable','on');
    set(handles.ksp_imag,'enable','on');
    
    set(handles.w_slider,'enable','on');
    set(handles.c_slider,'enable','on');
    set(handles.w_box,'enable','on');
    set(handles.c_box,'enable','on');
    
    set(handles.im_mag,'value',gData.v1Status(1,1));
    set(handles.im_phs,'value',gData.v1Status(1,2));
    set(handles.im_real,'value',gData.v1Status(1,3));
    set(handles.im_imag,'value',gData.v1Status(1,4));
    set(handles.ksp_mag,'value',gData.v1Status(1,5));
    set(handles.ksp_real,'value',gData.v1Status(1,6));
    set(handles.ksp_imag,'value',gData.v1Status(1,7));
end

set(handles.nRx,'string',num2str(gData.nRx1));
set(handles.noiseSF,'string',num2str(gData.noiseSF1));

if gData.nRx1
    set(handles.sos_RBT,'enable','off');
    set(handles.som_RBT,'enable','off');
else
    set(handles.sos_RBT,'enable','on');
    set(handles.som_RBT,'enable','on');
end

% --- Executes on button press in vPort2_check.
function vPort2_check_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;
kspaceKey=gData.v2Status(1,5);

set(handles.vPort1_check,'value',0);
set(handles.vPort2_check,'value',1);
set(handles.vPort3_check,'value',0);
set(handles.vPort4_check,'value',0);
gData.currentViewPort=2;

if kspaceKey
    set(handles.w_slider,'value',gData.w_sliderValK2);
    set(handles.c_slider,'value',gData.c_sliderValK2);
    set(handles.w_box,'string',num2str(gData.w_sliderValK2));
    set(handles.c_box,'string',num2str(gData.c_sliderValK2));
else
    set(handles.w_slider,'value',gData.w_sliderVal2);
    set(handles.c_slider,'value',gData.c_sliderVal2);
    set(handles.w_box,'string',num2str(gData.w_sliderVal2));
    set(handles.c_box,'string',num2str(gData.c_sliderVal2));
end

%histogram
if kspaceKey
    if isempty(gData.hist_resultK2)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMinK2;
        currentW=gData.w_sliderValK2;
        currentC=gData.c_sliderValK2;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK2,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
else
    if isempty(gData.hist_result2)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMin2;
        currentW=gData.w_sliderVal2;
        currentC=gData.c_sliderVal2;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result2,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

%set check-box & sliders
if gData.subKey2
    set(handles.im_mag,'enable','off');
    set(handles.im_phs,'enable','off');
    set(handles.im_real,'enable','off');
    set(handles.im_imag,'enable','off');
    set(handles.ksp_mag,'enable','off');
    set(handles.ksp_real,'enable','off');
    set(handles.ksp_imag,'enable','off');
    
    set(handles.w_slider,'enable','off');
    set(handles.c_slider,'enable','off');
    set(handles.w_box,'enable','off');
    set(handles.c_box,'enable','off');
    
    gData.w_sliderVal2=gData.histSteps;
    gData.c_sliderVal2=gData.histSteps/2;
else
    set(handles.im_mag,'enable','on');
    set(handles.im_phs,'enable','on');
    set(handles.im_real,'enable','on');
    set(handles.im_imag,'enable','on');
    set(handles.ksp_mag,'enable','on');
    set(handles.ksp_real,'enable','on');
    set(handles.ksp_imag,'enable','on');
    
    set(handles.w_slider,'enable','on');
    set(handles.c_slider,'enable','on');
    set(handles.w_box,'enable','on');
    set(handles.c_box,'enable','on');
    
    set(handles.im_mag,'value',gData.v2Status(1,1));
    set(handles.im_phs,'value',gData.v2Status(1,2));
    set(handles.im_real,'value',gData.v2Status(1,3));
    set(handles.im_imag,'value',gData.v2Status(1,4));
    set(handles.ksp_mag,'value',gData.v2Status(1,5));
    set(handles.ksp_real,'value',gData.v2Status(1,6));
    set(handles.ksp_imag,'value',gData.v2Status(1,7));
end

set(handles.nRx,'string',num2str(gData.nRx2));
set(handles.noiseSF,'string',num2str(gData.noiseSF2));

if gData.nRx2
    set(handles.sos_RBT,'enable','off');
    set(handles.som_RBT,'enable','off');
else
    set(handles.sos_RBT,'enable','on');
    set(handles.som_RBT,'enable','on');
end

% --- Executes on button press in vPort3_check.
function vPort3_check_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;
kspaceKey=gData.v3Status(1,5);

set(handles.vPort1_check,'value',0);
set(handles.vPort2_check,'value',0);
set(handles.vPort3_check,'value',1);
set(handles.vPort4_check,'value',0);
gData.currentViewPort=3;

if kspaceKey
    set(handles.w_slider,'value',gData.w_sliderValK3);
    set(handles.c_slider,'value',gData.c_sliderValK3);
    set(handles.w_box,'string',num2str(gData.w_sliderValK3));
    set(handles.c_box,'string',num2str(gData.c_sliderValK3));
else
    set(handles.w_slider,'value',gData.w_sliderVal3);
    set(handles.c_slider,'value',gData.c_sliderVal3);
    set(handles.w_box,'string',num2str(gData.w_sliderVal3));
    set(handles.c_box,'string',num2str(gData.c_sliderVal3));
end

%histogram
if kspaceKey
    if isempty(gData.hist_resultK3)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMinK3;
        currentW=gData.w_sliderValK3;
        currentC=gData.c_sliderValK3;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK3,'m','linewidth',2);
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
else
    if isempty(gData.hist_result3)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMin3;
        currentW=gData.w_sliderVal3;
        currentC=gData.c_sliderVal3;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result3,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

%set check-box & sliders
if gData.subKey3
    set(handles.im_mag,'enable','off');
    set(handles.im_phs,'enable','off');
    set(handles.im_real,'enable','off');
    set(handles.im_imag,'enable','off');
    set(handles.ksp_mag,'enable','off');
    set(handles.ksp_real,'enable','off');
    set(handles.ksp_imag,'enable','off');
    
    set(handles.w_slider,'enable','off');
    set(handles.c_slider,'enable','off');
    set(handles.w_box,'enable','off');
    set(handles.c_box,'enable','off');
    
    gData.w_sliderVal3=gData.histSteps;
    gData.c_sliderVal3=gData.histSteps/2;
else
    set(handles.im_mag,'enable','on');
    set(handles.im_phs,'enable','on');
    set(handles.im_real,'enable','on');
    set(handles.im_imag,'enable','on');
    set(handles.ksp_mag,'enable','on');
    set(handles.ksp_real,'enable','on');
    set(handles.ksp_imag,'enable','on');
    
    set(handles.w_slider,'enable','on');
    set(handles.c_slider,'enable','on');
    set(handles.w_box,'enable','on');
    set(handles.c_box,'enable','on');
    
    set(handles.im_mag,'value',gData.v3Status(1,1));
    set(handles.im_phs,'value',gData.v3Status(1,2));
    set(handles.im_real,'value',gData.v3Status(1,3));
    set(handles.im_imag,'value',gData.v3Status(1,4));
    set(handles.ksp_mag,'value',gData.v3Status(1,5));
    set(handles.ksp_real,'value',gData.v3Status(1,6));
    set(handles.ksp_imag,'value',gData.v3Status(1,7));
end

set(handles.nRx,'string',num2str(gData.nRx3));
set(handles.noiseSF,'string',num2str(gData.noiseSF3));

if gData.nRx3
    set(handles.sos_RBT,'enable','off');
    set(handles.som_RBT,'enable','off');
else
    set(handles.sos_RBT,'enable','on');
    set(handles.som_RBT,'enable','on');
end

% --- Executes on button press in vPort4_check.
function vPort4_check_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;
kspaceKey=gData.v4Status(1,5);

set(handles.vPort1_check,'value',0);
set(handles.vPort2_check,'value',0);
set(handles.vPort3_check,'value',0);
set(handles.vPort4_check,'value',1);
gData.currentViewPort=4;

if kspaceKey
    set(handles.w_slider,'value',gData.w_sliderValK4);
    set(handles.c_slider,'value',gData.c_sliderValK4);
    set(handles.w_box,'string',num2str(gData.w_sliderValK4));
    set(handles.c_box,'string',num2str(gData.c_sliderValK4));
else
    set(handles.w_slider,'value',gData.w_sliderVal4);
    set(handles.c_slider,'value',gData.c_sliderVal4);
    set(handles.w_box,'string',num2str(gData.w_sliderVal4));
    set(handles.c_box,'string',num2str(gData.c_sliderVal4));
end

%histogram
if kspaceKey
    if isempty(gData.hist_resultK4)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMinK4;
        currentW=gData.w_sliderValK4;
        currentC=gData.c_sliderValK4;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK4,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
else
    if isempty(gData.hist_result4)==1
        axes(handles.hist_axes5);
        emptyScreen1=ones(64);
        imagesc(emptyScreen1,[0 1]);
        axis image;
        colormap(gray);
        axis off;
    else
        imMin=gData.imMin4;
        currentW=gData.w_sliderVal4;
        currentC=gData.c_sliderVal4;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result4,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

%set check-box & sliders
if gData.subKey4
    set(handles.im_mag,'enable','off');
    set(handles.im_phs,'enable','off');
    set(handles.im_real,'enable','off');
    set(handles.im_imag,'enable','off');
    set(handles.ksp_mag,'enable','off');
    set(handles.ksp_real,'enable','off');
    set(handles.ksp_imag,'enable','off');
    
    set(handles.w_slider,'enable','off');
    set(handles.c_slider,'enable','off');
    set(handles.w_box,'enable','off');
    set(handles.c_box,'enable','off');
    
    gData.w_sliderVal4=gData.histSteps;
    gData.c_sliderVal4=gData.histSteps/2;
else
    set(handles.im_mag,'enable','on');
    set(handles.im_phs,'enable','on');
    set(handles.im_real,'enable','on');
    set(handles.im_imag,'enable','on');
    set(handles.ksp_mag,'enable','on');
    set(handles.ksp_real,'enable','on');
    set(handles.ksp_imag,'enable','on');
    
    set(handles.w_slider,'enable','on');
    set(handles.c_slider,'enable','on');
    set(handles.w_box,'enable','on');
    set(handles.c_box,'enable','on');
    
    set(handles.im_mag,'value',gData.v4Status(1,1));
    set(handles.im_phs,'value',gData.v4Status(1,2));
    set(handles.im_real,'value',gData.v4Status(1,3));
    set(handles.im_imag,'value',gData.v4Status(1,4));
    set(handles.ksp_mag,'value',gData.v4Status(1,5));
    set(handles.ksp_real,'value',gData.v4Status(1,6));
    set(handles.ksp_imag,'value',gData.v4Status(1,7));
end

set(handles.nRx,'string',num2str(gData.nRx4));
set(handles.noiseSF,'string',num2str(gData.noiseSF4));

if gData.nRx4
    set(handles.sos_RBT,'enable','off');
    set(handles.som_RBT,'enable','off');
else
    set(handles.sos_RBT,'enable','on');
    set(handles.som_RBT,'enable','on');
end

% --- Executes on button press in loadData.
function loadData_Callback(hObject, eventdata, handles)
global gData;
%cd(gData.cd_dir);
sumMethod=gData.sumMethod;
viewPortIndex=gData.currentViewPort;
histSteps=gData.histSteps;
eval(['nRx=gData.nRx',num2str(viewPortIndex),';']);

%for signal file
if nRx==1
    [filename,pathname]=uigetfile('*.ksig','OPEN: K-space');
    if filename==0
        return;
    end
elseif nRx>1
    [filenameM,pathname]=uigetfile('*.ksig','OPEN: K-space','Multiselect','on');
    
    if isnumeric(filenameM)
        return;
    end
    
    if nRx~=size(filenameM,2)
        msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
        return;
    end
    
    filename=cell2mat(filenameM(1,1));
end
gData.cd_dir=pathname;

fileName=[pathname,filename];
fid=fopen(fileName);
[k_data,cnt]=fread(fid,[2,Inf],'float32');
fclose(fid);

% parameter file reading
protFileName=[fileName(1,1:length(fileName)-6) '.prot'];
fid=fopen(protFileName);

protData=fgetl(fid);

while ischar(protData)
    protData=fgetl(fid);
    
    if ischar(protData)==0
        break;
    end
    
    % Number of Rx
    if strcmp(strtrim(protData),'# Rx:')
        nRx_prot=str2num(fgetl(fid));
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
    %FOV offset
    if strcmp(strtrim(protData),'FOV Offset:')
        void=fgetl(fid);
        Xoffset=str2num(fgetl(fid));
        void=fgetl(fid);
        Yoffset=str2num(fgetl(fid));
        void=fgetl(fid);
        Zoffset=str2num(fgetl(fid));
        clear void
    end
    if strcmp(strtrim(protData),'Sample Min:')
        void=fgetl(fid);
        Xmin=str2num(fgetl(fid));
        void=fgetl(fid);
        Ymin=str2num(fgetl(fid));
        void=fgetl(fid);
        Zmin=str2num(fgetl(fid));
        clear void
    end
    if strcmp(strtrim(protData),'Sample Max:')
        void=fgetl(fid);
        Xmax=str2num(fgetl(fid));
        void=fgetl(fid);
        Ymax=str2num(fgetl(fid));
        void=fgetl(fid);
        Zmax=str2num(fgetl(fid));
        clear void
    end
    
    %Matrix size
    if strcmp(strtrim(protData),'MatSize:')
        mSizeLocal=str2num(fgetl(fid));
        eval(['gData.mSizeLocal',num2str(viewPortIndex),'=mSizeLocal;']);
    end
    
    %PE Direction (0=no rotation, 1=rotation type 1, 2=rotation type 2)
    % Type 1: rot90(~,-1)
    % Type 2: flipLR
    if strcmp(strtrim(protData),'PE Direct:')
        PETemp=fgetl(fid);
        
        if strcmp(strtrim(PETemp),'P--A')
            if sliceKey==1
                peKey=1;
            elseif sliceKey==2
                peKey=2;
            end
        elseif strcmp(strtrim(PETemp),'L--R')
            if sliceKey==1
                peKey=2;
            elseif sliceKey==3
                peKey=2;
            end
        elseif strcmp(strtrim(PETemp),'F--H')
            if sliceKey==2
                peKey=1;
            elseif sliceKey==3
                peKey=1;
            end
        end        
    end
end
fclose(fid);

eval(['gData.sliceKey',num2str(viewPortIndex),'=sliceKey;']);
eval(['gData.peKey',num2str(viewPortIndex),'=peKey;']);

if nRx>nRx_prot
    msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
    set(handles.nRx,'string',num2str(8));
    eval(['gData.nRx',num2str(viewPortIndex),'=8;']);
    return;
end

%for noise file
%cd(gData.cd_dir);
noiseKey=0;
eval(['gData.noiseKey',num2str(viewPortIndex),'=0;']);
set(handles.noiseSF,'string',num2str(0));
eval(['noiseSF=gData.noiseSF',num2str(viewPortIndex),';']);

if nRx==1
    [filename_noise,pathname_noise]=uigetfile('*.nois','OPEN: Noise');
    if filename_noise==0
        %return;
    else
        noiseKey=1;
        eval(['gData.noiseKey',num2str(viewPortIndex),'=1;']);
    end
    
elseif nRx>1
    [filename_noiseM,pathname_noise]=uigetfile('*.nois','OPEN: Noise','Multiselect','on');
    
    if isnumeric(filename_noiseM)
        %return;
    else
        noiseKey=1;
        eval(['gData.noiseKey',num2str(viewPortIndex),'=1;']);
        
        if nRx~=size(filename_noiseM,2)
            msgbox('Check the number of Rx Channels','Number of Rx Channel','error');
            return;
        end
    end
end

if nRx==1    
    k_data=reshape(k_data(1,:)+1i*k_data(2,:),mSizeLocal(1),mSizeLocal(2));
    if strcmp(strtrim(PETemp),'P--A')
        switch sliceKey %set up coordinate sytem
            case 1 
                y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
                x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
            case 2
                y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
                x= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(2));
        end
    elseif strcmp(strtrim(PETemp),'F--H')
        switch sliceKey %set up coordinate sytem
            case 2
                x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
                y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
            case 3
                x= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(2));
                y= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(1));
        end
    elseif strcmp(strtrim(PETemp),'L--R')
        switch sliceKey %set up coordinate sytem
            case 1 
                x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
                y= -Yoffset/((Ymax+1-Ymin)/mSizeLocal(1));
            case 3
                y= -Zoffset/((Zmax+1-Zmin)/mSizeLocal(1));
                x= -Xoffset/((Xmax+1-Xmin)/mSizeLocal(2));
        end
    end
%     if peKey==1
        for i=1:mSizeLocal(1) %shift FOV along y
            k_data(i,:)=k_data(i,:)*exp(1i*2*pi*(y/mSizeLocal(1))*(i-mSizeLocal(1)/2));
        end
        for j=1:mSizeLocal(2) %shift FOV along x
            k_data(:,j)=k_data(:,j)*exp(1i*2*pi*(x/mSizeLocal(2))*(j-mSizeLocal(2)/2));
        end
%     else
%         for i=1:mSizeLocal(1) %shift FOV along x
%             k_data(i,:)=k_data(i,:)*exp(1i*2*pi*(y/mSizeLocal(1))*(i-mSizeLocal(1)/2));
%         end
%         for j=1:mSizeLocal(2) %shift FOV along y
%             k_data(:,j)=k_data(:,j)*exp(1i*2*pi*(x/mSizeLocal(2))*(j-mSizeLocal(2)/2));
%         end
%     end
    if noiseKey
        fileName_noise=[pathname_noise,filename_noise];
        fid=fopen(fileName_noise);
        [noise_data,cnt]=fread(fid,[2,Inf],'float32');
        fclose(fid);
        
        k_data_clean=k_data;
        noise_data=reshape(noise_data(1,:)+1i*noise_data(2,:),mSizeLocal(1),mSizeLocal(2));
        
        eval(['gData.noiseSF',num2str(viewPortIndex),'=1;']);
        set(handles.noiseSF,'string','1');
        k_data=k_data+noise_data*1;
    end
    
    qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
    
    im_data=fftshift(fft2(fftshift(k_data)));

    if peKey==1
        im_data=rot90(im_data,-1);
    elseif peKey==2
        im_data=fliplr(im_data);
    end
    
    qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
    
    eval(['assignin(''base'',''kSpace',num2str(viewPortIndex),''',k_data);']);
    eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
    eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
    eval(['gData.vPort',num2str(viewPortIndex),'Kspace=k_data;']);
    if noiseKey
        eval(['gData.vPort',num2str(viewPortIndex),'Kspace=k_data_clean;']);
        eval(['gData.vPort',num2str(viewPortIndex),'Noise=noise_data;']);
    end
    eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
    eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
    eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
    eval(['gData.w_sliderVal',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.c_sliderVal',num2str(viewPortIndex),'=histSteps/2;']);
    eval(['gData.w_sliderValK',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.c_sliderValK',num2str(viewPortIndex),'=histSteps/2;']);
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    eval(['gData.imMax',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.imMin',num2str(viewPortIndex),'=0;']);
    eval(['gData.imMaxK',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.imMinK',num2str(viewPortIndex),'=0;']);
    
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(abs(qImage));
    axis image;
    axis off;
    colormap(gray);
    
    %set check-box status
    set(handles.im_mag,'enable','on');
    set(handles.im_phs,'enable','on');
    set(handles.im_real,'enable','on');
    set(handles.im_imag,'enable','on');
    set(handles.ksp_mag,'enable','on');
    set(handles.ksp_real,'enable','on');
    set(handles.ksp_imag,'enable','on');
    
elseif nRx>1
    k_data=zeros(mSizeLocal(1),mSizeLocal(2));
    k_data_ch=zeros(nRx,mSizeLocal(1),mSizeLocal(2));
    im_data=zeros(mSizeLocal(1),mSizeLocal(2));
    im_data_ch=zeros(nRx,mSizeLocal(1),mSizeLocal(2));
    eval(['gData.vPort',num2str(viewPortIndex),'Kspace=[];']);
    eval(['gData.vPort',num2str(viewPortIndex),'Noise=[];']);
    
    for t=1:nRx
        %signal file
        fileNameTemp=cell2mat(filenameM(1,t));
        fileNameTemp=fileNameTemp(1,1:length(fileNameTemp)-6);
        fileName=[pathname,fileNameTemp,num2str(t),'.ksig'];
        fid=fopen(fileName);
        [k_data_read,cnt]=fread(fid,[2,Inf],'float32');
        fclose(fid);
        
        k_dataTemp=reshape(k_data_read(1,:)+1i*k_data_read(2,:),mSizeLocal(1),mSizeLocal(2));
        
        eval(['gData.vPort',num2str(viewPortIndex),'Kspace(t,:,:)=k_dataTemp;']);
        
        if t==1
            k_avg=mean2(abs(k_dataTemp(1:round(mSizeLocal/4),:)));
        end
        
        if noiseKey
            %noise file
            fileNameTemp=cell2mat(filename_noiseM(1,t));
            fileNameTemp=fileNameTemp(1,1:length(fileNameTemp)-6);
            fileName=[pathname_noise,fileNameTemp,num2str(t),'.nois'];
            fid=fopen(fileName);
            [noise_data,cnt]=fread(fid,[2,Inf],'float32');
            fclose(fid);
            
            noise_data=reshape(noise_data(1,:)+1i*noise_data(2,:),mSizeLocal(1),mSizeLocal(2));
            eval(['gData.vPort',num2str(viewPortIndex),'Noise(t,:,:)=noise_data;']);
            
            eval(['gData.noiseSF',num2str(viewPortIndex),'=1;']);
            set(handles.noiseSF,'string','1');
            k_dataTemp=k_dataTemp+noise_data*1;
        end
        
        k_data_ch(t,:,:)=k_dataTemp;
        im_DataTemp=ifftshift(ifft2(ifftshift(k_dataTemp)));
        
        if peKey==1
            im_DataTemp=rot90(im_DataTemp,-1);
        elseif peKey==2
            im_DataTemp=fliplr(im_DataTemp);
        end
        
        im_data_ch(t,:,:)=im_DataTemp;
        
        if sumMethod==1 %Sum of Square
            im_data=im_data+abs(im_DataTemp).^2;
            k_data=k_data+abs(k_dataTemp).^2;
        elseif sumMethod==2 %Sum of Magnitude
            im_data=im_data+abs(im_DataTemp);
            k_data=k_data+abs(k_dataTemp);
        end
    end
    
    if sumMethod==1 %Sum of Square
        im_data=sqrt(im_data);
    elseif sumMethod==2 %Sum of Magnitude
        im_data=im_data/1;
    end
    
    qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
    qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
    
    eval(['assignin(''base'',''kSpace',num2str(viewPortIndex),''',k_data_ch);']);
    eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
    eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
    eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
    eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
    eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
    eval(['gData.w_sliderVal',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.c_sliderVal',num2str(viewPortIndex),'=histSteps/2;']);
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    eval(['gData.imMax',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.imMin',num2str(viewPortIndex),'=0;']);
    eval(['gData.imMaxK',num2str(viewPortIndex),'=histSteps;']);
    eval(['gData.imMinK',num2str(viewPortIndex),'=0;']);
    
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(abs(qImage));
    axis image;
    axis off;
    colormap(gray);
end

set(handles.im_mag,'value',1);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','on');
set(handles.c_slider,'enable','on');
set(handles.w_box,'enable','on');
set(handles.c_box,'enable','on');

eval(['gData.subKey',num2str(viewPortIndex),'=0;']);

%histogram (Image)
axes(handles.hist_axes5);
im_data1D=reshape(abs(im_data),1,mSizeLocal(1)*mSizeLocal(2));
[hist_result,cnt]=hist(im_data1D,histSteps);
plot(hist_result,'r','linewidth',2);
axis off;
yLimVal=gData.yLimVal;
rectangle('Position',[0,1,histSteps,yLimVal-2],'Edgecolor','k','linestyle',':');
line([histSteps/2 histSteps/2],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
xlim([0 histSteps]);
ylim([0 yLimVal]);
eval(['gData.hist_result',num2str(viewPortIndex),'=hist_result;']);

%histogram (kspace)
k_data1D=reshape(abs(k_data),1,mSizeLocal(1)*mSizeLocal(2));
[hist_result,cnt]=hist(k_data1D,histSteps);
eval(['gData.hist_resultK',num2str(viewPortIndex),'=hist_result;']);

if nRx>1
    figure;
    set(gcf,'color','w');
    
    if nRx==2
        for t=1:nRx
            subplot(1,2,t);
            imagesc(abs(squeeze(im_data_ch(t,:,:))));
            axis image;
            axis off;
            colormap(gray);
        end
    elseif nRx==3 || nRx==4
        for t=1:nRx
            subplot(2,2,t);
            imagesc(abs(squeeze(im_data_ch(t,:,:))));
            axis image;
            axis off;
            colormap(gray);
        end
    elseif nRx>=5 && nRx<=9
        for t=1:nRx
            subplot(3,3,t);
            imagesc(abs(squeeze(im_data_ch(t,:,:))));
            axis image;
            axis off;
            colormap(gray);
        end
    elseif nRx>=10 && nRx<=16
        for t=1:nRx
            subplot(4,4,t);
            imagesc(abs(squeeze(im_data_ch(t,:,:))));
            axis image;
            axis off;
            colormap(gray);
        end
    end
end

% --- Executes on button press in resetContrast.
function resetContrast_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;

if get(handles.vPort1_check,'value')==1
    kspaceKey=gData.v1Status(1,5);
    if kspaceKey
        if isempty(gData.quantizedKspace1)
            msgbox('No image was found in the view port 1','Export','error');
            return;
        end
        
        axes(handles.viewer_axes1);
        imagesc(abs(gData.quantizedKspace1));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderValK1=histSteps;
        gData.c_sliderValK1=histSteps/2;
        gData.imMaxK1=histSteps;
        gData.imMinK1=0;
        hist_result=gData.hist_resultK1;
    else
        if isempty(gData.quantizedImage1)
            msgbox('No image was found in the view port 1','Export','error');
            return;
        end
        
        axes(handles.viewer_axes1);
        imagesc(abs(gData.vPort1Image));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderVal1=histSteps;
        gData.c_sliderVal1=histSteps/2;
        gData.imMax1=histSteps;
        gData.imMin1=0;
        hist_result=gData.hist_result1;
    end
elseif get(handles.vPort2_check,'value')==1
    kspaceKey=gData.v2Status(1,5);
    if kspaceKey
        if isempty(gData.quantizedKspace2)
            msgbox('No image was found in the view port 2','Export','error');
            return;
        end
        
        axes(handles.viewer_axes2);
        imagesc(abs(gData.quantizedKspace2));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderValK2=histSteps;
        gData.c_sliderValK2=histSteps/2;
        gData.imMaxK2=histSteps;
        gData.imMinK2=0;
        hist_result=gData.hist_resultK2;
    else
        if isempty(gData.quantizedImage2)
            msgbox('No image was found in the view port 2','Export','error');
            return;
        end
        
        axes(handles.viewer_axes2);
        imagesc(abs(gData.vPort2Image));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderVal2=histSteps;
        gData.c_sliderVal2=histSteps/2;
        gData.imMax2=histSteps;
        gData.imMin2=0;
        hist_result=gData.hist_result2;
    end
elseif get(handles.vPort3_check,'value')==1
    kspaceKey=gData.v3Status(1,5);
    if kspaceKey
        if isempty(gData.quantizedKspace3)
            msgbox('No image was found in the view port 3','Export','error');
            return;
        end
        
        axes(handles.viewer_axes3);
        imagesc(abs(gData.quantizedKspace3));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderValK3=histSteps;
        gData.c_sliderValK3=histSteps/2;
        gData.imMaxK3=histSteps;
        gData.imMinK3=0;
        hist_result=gData.hist_resultK3;
    else
        if isempty(gData.quantizedImage3)
            msgbox('No image was found in the view port 3','Export','error');
            return;
        end
        
        axes(handles.viewer_axes3);
        imagesc(abs(gData.vPort3Image));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderVal3=histSteps;
        gData.c_sliderVal3=histSteps/2;
        gData.imMax3=histSteps;
        gData.imMin3=0;
        hist_result=gData.hist_result3;
    end
elseif get(handles.vPort4_check,'value')==1
    kspaceKey=gData.v4Status(1,5);
    if kspaceKey
        if isempty(gData.quantizedKspace4)
            msgbox('No image was found in the view port 4','Export','error');
            return;
        end
        
        axes(handles.viewer_axes4);
        imagesc(abs(gData.quantizedKspace4));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderValK4=histSteps;
        gData.c_sliderValK4=histSteps/2;
        gData.imMaxK4=histSteps;
        gData.imMinK4=0;
        hist_result=gData.hist_resultK4;
    else
        if isempty(gData.quantizedImage4)
            msgbox('No image was found in the view port 4','Export','error');
            return;
        end
        
        axes(handles.viewer_axes4);
        imagesc(abs(gData.vPort4Image));
        set(handles.w_slider,'value',histSteps);
        set(handles.c_slider,'value',histSteps/2);
        set(handles.w_box,'string',num2str(histSteps));
        set(handles.c_box,'string',num2str(histSteps/2));
        gData.w_sliderVal4=histSteps;
        gData.c_sliderVal4=histSteps/2;
        gData.imMax4=histSteps;
        gData.imMin4=0;
        hist_result=gData.hist_result4;
    end
end
axis off;
axis image;

%draw a box (width)
axes(handles.hist_axes5);
if kspaceKey
    plot(hist_result,'m','linewidth',2);
else
    plot(hist_result,'r','linewidth',2);
end
yLimVal=gData.yLimVal;
axis off;
xlim([0 histSteps]);
ylim([0 yLimVal]);
rectangle('Position',[0,1,histSteps,yLimVal-2],'Edgecolor','k','linestyle',':');
line([histSteps/2 histSteps/2],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');

% --- Executes on button press in exportViewPort.
function exportViewPort_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
eval(['kspaceKey=gData.v',num2str(viewPortIndex),'Status(1,5);']);

switch viewPortIndex
    case 1
        imData=gData.curPortData1;
    case 2
        imData=gData.curPortData2;
    case 3
        imData=gData.curPortData3;
    case 4
        imData=gData.curPortData4;
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Export','error');
else
    switch viewPortIndex
        case 1
            if gData.subKey1
                imMin=min(min(imData));
                imMax=max(max(imData));
            else
                if kspaceKey
                    imMin=gData.imMinK1;
                    imMax=gData.imMaxK1;
                else
                    imMin=gData.imMin1;
                    imMax=gData.imMax1;
                end
            end
        case 2
            if gData.subKey2
                imMin=min(min(imData));
                imMax=max(max(imData));
            else
                if kspaceKey
                    imMin=gData.imMinK2;
                    imMax=gData.imMaxK2;
                else
                    imMin=gData.imMin2;
                    imMax=gData.imMax2;
                end
            end
        case 3
            if gData.subKey3
                imMin=min(min(imData));
                imMax=max(max(imData));
            else
                if kspaceKey
                    imMin=gData.imMinK3;
                    imMax=gData.imMaxK3;
                else
                    imMin=gData.imMin3;
                    imMax=gData.imMax3;
                end
            end
        case 4
            if gData.subKey4
                imMin=min(min(imData));
                imMax=max(max(imData));
            else
                if kspaceKey
                    imMin=gData.imMinK4;
                    imMax=gData.imMaxK4;
                else
                    imMin=gData.imMin4;
                    imMax=gData.imMax4;
                end
            end
    end
    
    if get(handles.im_mag,'value') || get(handles.ksp_mag,'value')
        figure;
        set(gcf,'color','w');
        imagesc(imData,[imMin imMax]);
        axis image;
        colormap(gray);
        colorbar('vert');
    else
        figure;
        set(gcf,'color','w');
        imagesc(imData);
        axis image;
        colormap(gray);
        colorbar('vert');
    end
end

% --- Executes on button press in clearViewPort.
function clearViewPort_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;

emptyScreen=zeros(256);
emptyScreen(1,1)=1;

if get(handles.vPort1_check,'value')==1
    gData.vPort1Image=[];
    gData.vPort1Noise=[];
    gData.vPort1Kspace=[];
    gData.curPortData1=[];
    gData.quantizedImage1=[];
    gData.hist_result1=[];
    gData.w_sliderVal1=histSteps;
    gData.c_sliderVal1=histSteps/2;
    gData.quantizedKspace1=[];
    gData.hist_resultK1=[];
    gData.w_sliderValK1=histSteps;
    gData.c_sliderValK1=histSteps/2;
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    gData.imMax1=[];
    gData.imMin1=[];
    gData.imMaxK1=[];
    gData.imMinK1=[];
    evalin('base','clear image1 kSpace1');
    
    axes(handles.viewer_axes1);
    imagesc(emptyScreen);
    axis image;
    colormap(gray);
    axis off;
    
    axes(handles.hist_axes5);
    imagesc(ones(64),[0 1]);
    axis off;
    
    gData.subKey1=0;
    gData.v1Status=[1 0 0 0 0 0 0];

    set(handles.im_mag,'value',1);
    set(handles.im_phs,'value',0);
    set(handles.im_real,'value',0);
    set(handles.im_imag,'value',0);
    set(handles.ksp_mag,'value',0);
    set(handles.ksp_real,'value',0);
    set(handles.ksp_imag,'value',0);
    
    set(handles.nRx,'string',num2str(1));
    set(handles.noiseSF,'string',num2str(0));

    gData.nRx1=1;
    gData.noiseSF1=0;
    gData.mSizeLocal1=128;
    gData.noiseKey1=0;
    gData.peKey1=0;
    gData.sliceKey1=1;
elseif get(handles.vPort2_check,'value')==1
    gData.vPort2Image=[];
    gData.vPort2Noise=[];
    gData.vPort2Kspace=[];
    gData.curPortData2=[];
    gData.quantizedImage2=[];
    gData.hist_result2=[];
    gData.w_sliderVal2=histSteps;
    gData.c_sliderVal2=histSteps/2;
    gData.quantizedKspace2=[];
    gData.hist_resultK2=[];
    gData.w_sliderValK2=histSteps;
    gData.c_sliderValK2=histSteps/2;
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    gData.imMax2=[];
    gData.imMin2=[];
    gData.imMaxK2=[];
    gData.imMinK2=[];
    evalin('base','clear image2 kSpace2');
    
    axes(handles.viewer_axes2);
    imagesc(emptyScreen);
    axis image;
    colormap(gray);
    axis off;
    
    axes(handles.hist_axes5);
    imagesc(ones(64),[0 1]);
    axis off;
    
    gData.subKey2=0;
    
    gData.v2Status=[1 0 0 0 0 0 0];

    set(handles.im_mag,'value',1);
    set(handles.im_phs,'value',0);
    set(handles.im_real,'value',0);
    set(handles.im_imag,'value',0);
    set(handles.ksp_mag,'value',0);
    set(handles.ksp_real,'value',0);
    set(handles.ksp_imag,'value',0);
    
    set(handles.nRx,'string',num2str(1));
    set(handles.noiseSF,'string',num2str(0));
    
    gData.nRx2=1;
    gData.noiseSF2=0;
    gData.mSizeLocal2=128;
    gData.noiseKey2=0;
    gData.peKey2=0;
    gData.sliceKey2=1;
elseif get(handles.vPort3_check,'value')==1
    gData.vPort3Image=[];
    gData.vPort3Noise=[];
    gData.vPort3Kspace=[];
    gData.curPortData3=[];
    gData.quantizedImage3=[];
    gData.hist_result3=[];
    gData.w_sliderVal3=histSteps;
    gData.c_sliderVal3=histSteps/2;
    gData.quantizedKspace3=[];
    gData.hist_resultK3=[];
    gData.w_sliderValK3=histSteps;
    gData.c_sliderValK3=histSteps/2;
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    gData.imMax3=[];
    gData.imMin3=[];
    gData.imMaxK3=[];
    gData.imMinK3=[];
    evalin('base','clear image3 kSpace3');
    
    axes(handles.viewer_axes3);
    imagesc(emptyScreen);
    axis image;
    colormap(gray);
    axis off;
    
    axes(handles.hist_axes5);
    imagesc(ones(64),[0 1]);
    axis off;
    
    gData.subKey3=0;
    
    gData.v3Status=[1 0 0 0 0 0 0];

    set(handles.im_mag,'value',1);
    set(handles.im_phs,'value',0);
    set(handles.im_real,'value',0);
    set(handles.im_imag,'value',0);
    set(handles.ksp_mag,'value',0);
    set(handles.ksp_real,'value',0);
    set(handles.ksp_imag,'value',0);
    
    set(handles.nRx,'string',num2str(1));
    set(handles.noiseSF,'string',num2str(0));
    
    gData.nRx3=1;
    gData.noiseSF3=0;
    gData.mSizeLocal3=128;
    gData.noiseKey3=0;
    gData.peKey3=0;
    gData.sliceKey3=1;
elseif get(handles.vPort4_check,'value')==1
    gData.vPort4Image=[];
    gData.vPort4Noise=[];
    gData.vPort4Kspace=[];
    gData.curPortData4=[];
    gData.quantizedImage4=[];
    gData.hist_result4=[];
    gData.w_sliderVal4=histSteps;
    gData.c_sliderVal4=histSteps/2;
    set(handles.w_slider,'value',histSteps);
    set(handles.c_slider,'value',histSteps/2);
    gData.quantizedKspace4=[];
    gData.hist_resultK4=[];
    gData.w_sliderValK4=histSteps;
    gData.c_sliderValK4=histSteps/2;
    set(handles.w_box,'string',num2str(histSteps));
    set(handles.c_box,'string',num2str(histSteps/2));
    gData.imMax4=[];
    gData.imMin4=[];
    gData.imMaxK4=[];
    gData.imMinK4=[];
    evalin('base','clear image4 kSpace4');
    
    axes(handles.viewer_axes4);
    imagesc(emptyScreen);
    axis image;
    colormap(gray);
    axis off;
    
    axes(handles.hist_axes5);
    imagesc(ones(64),[0 1]);
    axis off;
    
    gData.subKey4=0;
    
    gData.v4Status=[1 0 0 0 0 0 0];

    set(handles.im_mag,'value',1);
    set(handles.im_phs,'value',0);
    set(handles.im_real,'value',0);
    set(handles.im_imag,'value',0);
    set(handles.ksp_mag,'value',0);
    set(handles.ksp_real,'value',0);
    set(handles.ksp_imag,'value',0);
    
    set(handles.nRx,'string',num2str(1));
    set(handles.noiseSF,'string',num2str(0));
    
    gData.nRx4=1;
    gData.noiseSF4=0;
    gData.mSizeLocal4=128;
    gData.noiseKey4=0;
    gData.peKey4=0;
    gData.sliceKey4=1;
end

% --- Executes on button press in clearAll.
function clearAll_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;

emptyScreen=zeros(256);
emptyScreen(1,1)=1;

axes(handles.viewer_axes1);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes2);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes3);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.viewer_axes4);
imagesc(emptyScreen);
axis image;
colormap(gray);
axis off;

axes(handles.hist_axes5);
imagesc(ones(64),[0 1]);
axis off;

evalin('base','clear image1 kSpace1');
evalin('base','clear image2 kSpace2');
evalin('base','clear image3 kSpace3');
evalin('base','clear image4 kSpace4');

gData.vPort1Image=[];
gData.vPort2Image=[];
gData.vPort3Image=[];
gData.vPort4Image=[];

gData.vPort1Noise=[];
gData.vPort2Noise=[];
gData.vPort3Noise=[];
gData.vPort4Noise=[];

gData.vPort1Kspace=[];
gData.vPort2Kspace=[];
gData.vPort3Kspace=[];
gData.vPort4Kspace=[];

gData.curPortData1=[];
gData.curPortData2=[];
gData.curPortData3=[];
gData.curPortData4=[];

gData.quantizedImage1=[];
gData.quantizedImage2=[];
gData.quantizedImage3=[];
gData.quantizedImage4=[];

gData.quantizedKspace1=[];
gData.quantizedKspace2=[];
gData.quantizedKspace3=[];
gData.quantizedKspace4=[];

gData.hist_result1=[];
gData.hist_result2=[];
gData.hist_result3=[];
gData.hist_result4=[];

gData.hist_resultK1=[];
gData.hist_resultK2=[];
gData.hist_resultK3=[];
gData.hist_resultK4=[];

set(handles.vPort1_check,'value',1);
set(handles.vPort2_check,'value',0);
set(handles.vPort3_check,'value',0);
set(handles.vPort4_check,'value',0);
gData.currentViewPort=1;

gData.v1Status=[1 0 0 0 0 0 0];
gData.v2Status=[1 0 0 0 0 0 0];
gData.v3Status=[1 0 0 0 0 0 0];
gData.v4Status=[1 0 0 0 0 0 0];

%set check box
set(handles.im_mag,'value',1);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

gData.subKey1=0;
gData.subKey2=0;
gData.subKey3=0;
gData.subKey4=0;

set(handles.sub1,'value',1);
set(handles.sub2,'value',2);
set(handles.subResult,'value',3);

%reset nRx
gData.nRx1=1;
gData.nRx2=1;
gData.nRx3=1;
gData.nRx4=1;
set(handles.nRx,'string',num2str(1));

gData.noiseSF1=0;
gData.noiseSF2=0;
gData.noiseSF3=0;
gData.noiseSF4=0;
set(handles.noiseSF,'string',num2str(0));

gData.mSizeLocal1=128;
gData.mSizeLocal2=128;
gData.mSizeLocal3=128;
gData.mSizeLocal4=128;

gData.w_sliderVal1=histSteps;
gData.c_sliderVal1=histSteps/2;
gData.w_sliderVal2=histSteps;
gData.c_sliderVal2=histSteps/2;
gData.w_sliderVal3=histSteps;
gData.c_sliderVal3=histSteps/2;
gData.w_sliderVal4=histSteps;
gData.c_sliderVal4=histSteps/2;

gData.w_sliderValK1=histSteps;
gData.c_sliderValK1=histSteps/2;
gData.w_sliderValK2=histSteps;
gData.c_sliderValK2=histSteps/2;
gData.w_sliderValK3=histSteps;
gData.c_sliderValK3=histSteps/2;
gData.w_sliderValK4=histSteps;
gData.c_sliderValK4=histSteps/2;

gData.imMax1=[];
gData.imMin1=[];
gData.imMax2=[];
gData.imMin2=[];
gData.imMax3=[];
gData.imMin3=[];
gData.imMax4=[];
gData.imMin4=[];

gData.imMaxK1=[];
gData.imMinK1=[];
gData.imMaxK2=[];
gData.imMinK2=[];
gData.imMaxK3=[];
gData.imMinK3=[];
gData.imMaxK4=[];
gData.imMinK4=[];

set(handles.w_slider,'value',histSteps);
set(handles.c_slider,'value',histSteps/2);
set(handles.w_box,'string',num2str(histSteps));
set(handles.c_box,'string',num2str(histSteps/2));

gData.noiseKey1=0;
gData.noiseKey2=0;
gData.noiseKey3=0;
gData.noiseKey4=0;

gData.peKey1=0;
gData.peKey2=0;
gData.peKey3=0;
gData.peKey4=0;

gData.sliceKey1=1;
gData.sliceKey2=1;
gData.sliceKey3=1;
gData.sliceKey4=1;

set(handles.sos_RBT,'value',1);
set(handles.som_RBT,'value',0);
set(handles.sos_RBT,'enable','off');
set(handles.som_RBT,'enable','off');

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
close(gcf);

% --- Executes on button press in im_mag.
function im_mag_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;

if get(handles.vPort1_check,'value')==1
    imData=abs(gData.quantizedImage1);
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[1 0 0 0 0 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMax1;
        imMin=gData.imMin1;

        currentW=gData.w_sliderVal1;
        currentC=gData.c_sliderVal1;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result1,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort2_check,'value')==1
    imData=abs(gData.quantizedImage2);
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[1 0 0 0 0 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMax2;
        imMin=gData.imMin2;
        
        currentW=gData.w_sliderVal2;
        currentC=gData.c_sliderVal2;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result2,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort3_check,'value')==1
    imData=abs(gData.quantizedImage3);
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[1 0 0 0 0 0 0];

    if isempty(imData)==0
        imMax=gData.imMax3;
        imMin=gData.imMin3;
        
        currentW=gData.w_sliderVal3;
        currentC=gData.c_sliderVal3;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result3,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort4_check,'value')==1
    imData=abs(gData.quantizedImage4);
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[1 0 0 0 0 0 0];

    if isempty(imData)==0
        imMax=gData.imMax4;
        imMin=gData.imMin4;
        
        currentW=gData.w_sliderVal4;
        currentC=gData.c_sliderVal4;
        
        axes(handles.hist_axes5);
        plot(gData.hist_result4,'r','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    
    return;
else
    set(handles.w_slider,'value',currentW);
    set(handles.c_slider,'value',currentC);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));

    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData,[imMin imMax]);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',1);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','on');
set(handles.c_slider,'enable','on');
set(handles.w_box,'enable','on');
set(handles.c_box,'enable','on');

% --- Executes on button press in im_phs.
function im_phs_Callback(hObject, eventdata, handles)
global gData;

if get(handles.vPort1_check,'value')==1
    imData=atan2(imag(gData.vPort1Image),real(gData.vPort1Image));
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 1 0 0 0 0 0];
elseif get(handles.vPort2_check,'value')==1
    imData=atan2(imag(gData.vPort2Image),real(gData.vPort2Image));
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 1 0 0 0 0 0];
elseif get(handles.vPort3_check,'value')==1
    imData=atan2(imag(gData.vPort3Image),real(gData.vPort3Image));
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 1 0 0 0 0 0];
elseif get(handles.vPort4_check,'value')==1
    imData=atan2(imag(gData.vPort4Image),real(gData.vPort4Image));
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 1 0 0 0 0 0];
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.im_phs,'value',0);

    return;
else
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',1);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','off');
set(handles.c_slider,'enable','off');
set(handles.w_box,'enable','off');
set(handles.c_box,'enable','off');

% --- Executes on button press in im_real.
function im_real_Callback(hObject, eventdata, handles)
global gData;

if get(handles.vPort1_check,'value')==1
    imData=real(gData.vPort1Image);
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 0 1 0 0 0 0];
elseif get(handles.vPort2_check,'value')==1
    imData=real(gData.vPort2Image);
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 0 1 0 0 0 0];
elseif get(handles.vPort3_check,'value')==1
    imData=real(gData.vPort3Image);
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 0 1 0 0 0 0];
elseif get(handles.vPort4_check,'value')==1
    imData=real(gData.vPort4Image);
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 0 1 0 0 0 0];
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.im_real,'value',0);

    return;
else
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',1);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','off');
set(handles.c_slider,'enable','off');
set(handles.w_box,'enable','off');
set(handles.c_box,'enable','off');

% --- Executes on button press in im_imag.
function im_imag_Callback(hObject, eventdata, handles)
global gData;

if get(handles.vPort1_check,'value')==1
    imData=imag(gData.vPort1Image);
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 0 0 1 0 0 0];
elseif get(handles.vPort2_check,'value')==1
    imData=imag(gData.vPort2Image);
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 0 0 1 0 0 0];
elseif get(handles.vPort3_check,'value')==1
    imData=imag(gData.vPort3Image);
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 0 0 1 0 0 0];
elseif get(handles.vPort4_check,'value')==1
    imData=imag(gData.vPort4Image);
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 0 0 1 0 0 0];
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.im_imag,'value',0);
    return;
else
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',1);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','off');
set(handles.c_slider,'enable','off');
set(handles.w_box,'enable','off');
set(handles.c_box,'enable','off');

% --- Executes on button press in ksp_mag.
function ksp_mag_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;

if get(handles.vPort1_check,'value')==1
    imData=abs(gData.quantizedKspace1);
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 0 0 0 1 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMaxK1;
        imMin=gData.imMinK1;
        
        currentW=gData.w_sliderValK1;
        currentC=gData.c_sliderValK1;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK1,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort2_check,'value')==1
    imData=abs(gData.quantizedKspace2);
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 0 0 0 1 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMaxK2;
        imMin=gData.imMinK2;
        
        currentW=gData.w_sliderValK2;
        currentC=gData.c_sliderValK2;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK2,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort3_check,'value')==1
    imData=abs(gData.quantizedKspace3);
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 0 0 0 1 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMaxK3;
        imMin=gData.imMinK3;
        
        currentW=gData.w_sliderValK3;
        currentC=gData.c_sliderValK3;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK3,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
elseif get(handles.vPort4_check,'value')==1
    imData=abs(gData.quantizedKspace4);
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 0 0 0 1 0 0];
    
    if isempty(imData)==0
        imMax=gData.imMaxK4;
        imMin=gData.imMinK4;
        
        currentW=gData.w_sliderValK4;
        currentC=gData.c_sliderValK4;
        
        axes(handles.hist_axes5);
        plot(gData.hist_resultK4,'m','linewidth',2);
        yLimVal=gData.yLimVal;
        axis off;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
    end
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.ksp_mag,'value',0);

    return;
else
    set(handles.w_slider,'value',currentW);
    set(handles.c_slider,'value',currentC);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));

    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData,[imMin imMax]);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',1);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','on');
set(handles.c_slider,'enable','on');
set(handles.w_box,'enable','on');
set(handles.c_box,'enable','on');

% --- Executes on button press in ksp_real.
function ksp_real_Callback(hObject, eventdata, handles)
global gData;

if get(handles.vPort1_check,'value')==1
    if gData.nRx1>1
        imData=zeros(gData.mSizeLocal1);
    else
        imData=real(gData.vPort1Kspace);
    end
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 0 0 0 0 1 0];
elseif get(handles.vPort2_check,'value')==1
    if gData.nRx2>1
        imData=zeros(gData.mSizeLocal2);
    else
        imData=real(gData.vPort2Kspace);
    end
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 0 0 0 0 1 0];
elseif get(handles.vPort3_check,'value')==1
    if gData.nRx3>1
        imData=zeros(gData.mSizeLocal3);
    else
        imData=real(gData.vPort3Kspace);
    end
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 0 0 0 0 1 0];
elseif get(handles.vPort4_check,'value')==1
    if gData.nRx4>1
        imData=zeros(gData.mSizeLocal4);
    else
        imData=real(gData.vPort4Kspace);
    end
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 0 0 0 0 1 0];
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.ksp_real,'value',0);

    return;
else
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',1);
set(handles.ksp_imag,'value',0);

set(handles.w_slider,'enable','off');
set(handles.c_slider,'enable','off');
set(handles.w_box,'enable','off');
set(handles.c_box,'enable','off');

% --- Executes on button press in ksp_imag.
function ksp_imag_Callback(hObject, eventdata, handles)
global gData;

if get(handles.vPort1_check,'value')==1
    if gData.nRx1>1
        imData=zeros(gData.mSizeLocal1);
    else
        imData=imag(gData.vPort1Kspace);
    end
    gData.curPortData1=imData;
    viewPortIndex=1;
    gData.v1Status=[0 0 0 0 0 0 1];
elseif get(handles.vPort2_check,'value')==1
    if gData.nRx2>1
        imData=zeros(gData.mSizeLocal2);
    else
        imData=imag(gData.vPort2Kspace);
    end
    gData.curPortData2=imData;
    viewPortIndex=2;
    gData.v2Status=[0 0 0 0 0 0 1];
elseif get(handles.vPort3_check,'value')==1
    if gData.nRx3>1
        imData=zeros(gData.mSizeLocal3);
    else
        imData=imag(gData.vPort3Kspace);
    end
    gData.curPortData3=imData;
    viewPortIndex=3;
    gData.v3Status=[0 0 0 0 0 0 1];
elseif get(handles.vPort4_check,'value')==1
    if gData.nRx4>1
        imData=zeros(gData.mSizeLocal4);
    else
        imData=imag(gData.vPort4Kspace);
    end
    gData.curPortData4=imData;
    viewPortIndex=4;
    gData.v4Status=[0 0 0 0 0 0 1];
end

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');

    set(handles.im_mag,'value',1);
    set(handles.ksp_imag,'value',0);

    return;
else
    eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
    imagesc(imData);
    axis image;
    axis off;
    colormap(gray);
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
end

set(handles.im_mag,'value',0);
set(handles.im_phs,'value',0);
set(handles.im_real,'value',0);
set(handles.im_imag,'value',0);
set(handles.ksp_mag,'value',0);
set(handles.ksp_real,'value',0);
set(handles.ksp_imag,'value',1);

set(handles.w_slider,'enable','off');
set(handles.c_slider,'enable','off');
set(handles.w_box,'enable','off');
set(handles.c_box,'enable','off');

% --- Executes on selection change in sub1.
function sub1_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sub1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sub1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in sub2.
function sub2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function sub2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sub2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in subResult.
function subResult_Callback(hObject, eventdata, handles)
global gData;
algebraKey=gData.algebraKey;
histSteps=gData.histSteps;

if get(handles.sub1,'value')==1
    imData1=gData.curPortData1;
elseif get(handles.sub1,'value')==2
    imData1=gData.curPortData2;
elseif get(handles.sub1,'value')==3
    imData1=gData.curPortData3;
elseif get(handles.sub1,'value')==4
    imData1=gData.curPortData4;
end

if isempty(imData1)
    msgbox('No image was found in the selected view port','subImage','error');
    return;
else
    if get(handles.sub2,'value')==1
        imData2=gData.curPortData1;
    elseif get(handles.sub2,'value')==2
        imData2=gData.curPortData2;
    elseif get(handles.sub2,'value')==3
        imData2=gData.curPortData3;
    elseif get(handles.sub2,'value')==4
        imData2=gData.curPortData4;
    end

    if isempty(imData2)
        msgbox('No image was found in the selected view port','subImage','error');
        return;
    else
        if length(imData1)~=length(imData2)
            msgbox('The matrix size of the selected images is not equal.','subImage','error');
            return;
        else
            if algebraKey==1 %subtract
                subImage=imData1-imData2;
            elseif algebraKey==2 % division
                subImage=imData1./imData2;
            elseif algebraKey==3 % add
                subImage=imData1+imData2;
            elseif algebraKey==4 %multiplication
                subImage=imData1.*imData2;
            end
            
            if get(handles.subResult,'value')==1
                gData.vPort1Image=[];
                gData.vPort1Kspace=[];
                gData.quantizedImage1=[];
                gData.hist_result1=[];
                gData.w_sliderVal1=histSteps;
                gData.c_sliderVal1=histSteps/2;
                set(handles.w_slider,'value',histSteps);
                set(handles.c_slider,'value',histSteps/2);
                set(handles.w_box,'string',num2str(histSteps));
                set(handles.c_box,'string',num2str(histSteps/2));
                gData.currentViewPort=1;
                set(handles.vPort1_check,'value',1);
                set(handles.vPort2_check,'value',0);
                set(handles.vPort3_check,'value',0);
                set(handles.vPort4_check,'value',0);
                
                axes(handles.hist_axes5);
                imagesc(ones(64),[0 1]);
                axis off;
                
                gData.curPortData1=subImage;
                axes(handles.viewer_axes1);
                
                gData.subKey1=1;
                gData.subKey2=0;
                gData.subKey3=0;
                gData.subKey4=0;
                
                gData.imMin1=min(min(subImage));
                gData.imMax1=max(max(subImage));
                
                set(handles.im_mag,'enable','off');
                set(handles.im_phs,'enable','off');
                set(handles.im_real,'enable','off');
                set(handles.im_imag,'enable','off');
                set(handles.ksp_mag,'enable','off');
                set(handles.ksp_real,'enable','off');
                set(handles.ksp_imag,'enable','off');
                
                set(handles.w_slider,'enable','off');
                set(handles.c_slider,'enable','off');
                set(handles.w_box,'enable','off');
                set(handles.c_box,'enable','off');
                
            elseif get(handles.subResult,'value')==2
                gData.vPort2Image=[];
                gData.vPort2Kspace=[];
                gData.quantizedImage2=[];
                gData.hist_result2=[];
                gData.w_sliderVal2=histSteps;
                gData.c_sliderVal2=histSteps/2;
                set(handles.w_slider,'value',histSteps);
                set(handles.c_slider,'value',histSteps/2);
                set(handles.w_box,'string',num2str(histSteps));
                set(handles.c_box,'string',num2str(histSteps/2));
                gData.currentViewPort=2;
                set(handles.vPort1_check,'value',0);
                set(handles.vPort2_check,'value',1);
                set(handles.vPort3_check,'value',0);
                set(handles.vPort4_check,'value',0);
                
                axes(handles.hist_axes5);
                imagesc(ones(64),[0 1]);
                axis off;
                
                gData.curPortData2=subImage;
                axes(handles.viewer_axes2);
                
                gData.subKey1=0;
                gData.subKey2=1;
                gData.subKey3=0;
                gData.subKey4=0;
                
                gData.imMin2=min(min(subImage));
                gData.imMax2=max(max(subImage));
                
                set(handles.im_mag,'enable','off');
                set(handles.im_phs,'enable','off');
                set(handles.im_real,'enable','off');
                set(handles.im_imag,'enable','off');
                set(handles.ksp_mag,'enable','off');
                set(handles.ksp_real,'enable','off');
                set(handles.ksp_imag,'enable','off');
                
                set(handles.w_slider,'enable','off');
                set(handles.c_slider,'enable','off');
                set(handles.w_box,'enable','off');
                set(handles.c_box,'enable','off');
                
            elseif get(handles.subResult,'value')==3
                gData.vPort3Image=[];
                gData.vPort3Kspace=[];
                gData.quantizedImage3=[];
                gData.hist_result3=[];
                gData.w_sliderVal3=histSteps;
                gData.c_sliderVal3=histSteps/2;
                set(handles.w_slider,'value',histSteps);
                set(handles.c_slider,'value',histSteps/2);
                set(handles.w_box,'string',num2str(histSteps));
                set(handles.c_box,'string',num2str(histSteps/2));
                gData.currentViewPort=3;
                set(handles.vPort1_check,'value',0);
                set(handles.vPort2_check,'value',0);
                set(handles.vPort3_check,'value',1);
                set(handles.vPort4_check,'value',0);
                
                axes(handles.hist_axes5);
                imagesc(ones(64),[0 1]);
                axis off;
                
                gData.curPortData3=subImage;
                axes(handles.viewer_axes3);
                
                gData.subKey1=0;
                gData.subKey2=0;
                gData.subKey3=1;
                gData.subKey4=0;
                
                gData.imMin3=min(min(subImage));
                gData.imMax3=max(max(subImage));
                
                set(handles.im_mag,'enable','off');
                set(handles.im_phs,'enable','off');
                set(handles.im_real,'enable','off');
                set(handles.im_imag,'enable','off');
                set(handles.ksp_mag,'enable','off');
                set(handles.ksp_real,'enable','off');
                set(handles.ksp_imag,'enable','off');
                
                set(handles.w_slider,'enable','off');
                set(handles.c_slider,'enable','off');
                set(handles.w_box,'enable','off');
                set(handles.c_box,'enable','off');
                
            elseif get(handles.subResult,'value')==4
                gData.vPort4Image=[];
                gData.vPort4Kspace=[];
                gData.quantizedImage4=[];
                gData.hist_result4=[];
                gData.w_sliderVal4=histSteps;
                gData.c_sliderVal4=histSteps/2;
                set(handles.w_slider,'value',histSteps);
                set(handles.c_slider,'value',histSteps/2);
                set(handles.w_box,'string',num2str(histSteps));
                set(handles.c_box,'string',num2str(histSteps/2));
                gData.currentViewPort=4;
                set(handles.vPort1_check,'value',0);
                set(handles.vPort2_check,'value',0);
                set(handles.vPort3_check,'value',0);
                set(handles.vPort4_check,'value',1);
                
                axes(handles.hist_axes5);
                imagesc(ones(64),[0 1]);
                axis off;
                
                gData.curPortData4=subImage;
                axes(handles.viewer_axes4);
                
                gData.subKey1=0;
                gData.subKey2=0;
                gData.subKey3=0;
                gData.subKey4=1;
                
                gData.imMin4=min(min(subImage));
                gData.imMax4=max(max(subImage));
                
                set(handles.im_mag,'enable','off');
                set(handles.im_phs,'enable','off');
                set(handles.im_real,'enable','off');
                set(handles.im_imag,'enable','off');
                set(handles.ksp_mag,'enable','off');
                set(handles.ksp_real,'enable','off');
                set(handles.ksp_imag,'enable','off');
                
                set(handles.w_slider,'enable','off');
                set(handles.c_slider,'enable','off');
                set(handles.w_box,'enable','off');
                set(handles.c_box,'enable','off');
            end

            imagesc(subImage);
            axis image;
            axis off;
            colormap(gray);
         end
    end
end

% --- Executes during object creation, after setting all properties.
function subResult_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subResult (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function w_slider_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
histSteps=gData.histSteps;
eval(['kspaceKey=gData.v',num2str(viewPortIndex),'Status(1,5);']);

if get(handles.vPort1_check,'value')==1
    if isempty(gData.quantizedImage1)
        msgbox('No image was found in the view port 1','Export','error');
        return;
    end
elseif get(handles.vPort2_check,'value')==1
    if isempty(gData.quantizedImage2)
        msgbox('No image was found in the view port 2','Export','error');
        return;
    end
elseif get(handles.vPort3_check,'value')==1
    if isempty(gData.quantizedImage3)
        msgbox('No image was found in the view port 3','Export','error');
        return;
    end
elseif get(handles.vPort4_check,'value')==1
    if isempty(gData.quantizedImage4)
        msgbox('No image was found in the view port 4','Export','error');
        return;
    end
end

currentW=round(get(handles.w_slider,'value'));
set(handles.w_box,'string',num2str(currentW));

currentC=str2double(get(handles.c_box,'string'));

imMax=currentC+currentW/2;
imMin=currentC-currentW/2;

if imMax>histSteps
    imMax=histSteps;
    imMin=histSteps-currentW;
    currentC=round(imMin+currentW/2);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

if imMin<0
    imMin=0;
    imMax=currentW;
    currentC=round(currentW/2);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

switch viewPortIndex
    case 1
        axes(handles.viewer_axes1);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace1),[imMin imMax]);
            hist_result=gData.hist_resultK1;
            
            gData.w_sliderValK1=currentW;
            gData.c_sliderValK1=currentC;
            gData.imMaxK1=imMax;
            gData.imMinK1=imMin;
        else
            imagesc(abs(gData.quantizedImage1),[imMin imMax]);
            hist_result=gData.hist_result1;
            
            gData.w_sliderVal1=currentW;
            gData.c_sliderVal1=currentC;
            gData.imMax1=imMax;
            gData.imMin1=imMin;
        end
    case 2
        axes(handles.viewer_axes2);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace2),[imMin imMax]);
            hist_result=gData.hist_resultK2;
            
            gData.w_sliderValK2=currentW;
            gData.c_sliderValK2=currentC;
            gData.imMaxK2=imMax;
            gData.imMinK2=imMin;
        else
            imagesc(abs(gData.quantizedImage2),[imMin imMax]);
            hist_result=gData.hist_result2;
            
            gData.w_sliderVal2=currentW;
            gData.c_sliderVal2=currentC;
            gData.imMax2=imMax;
            gData.imMin2=imMin;
        end
    case 3
        axes(handles.viewer_axes3);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace3),[imMin imMax]);
            hist_result=gData.hist_resultK3;
            
            gData.w_sliderValK3=currentW;
            gData.c_sliderValK3=currentC;
            gData.imMaxK3=imMax;
            gData.imMinK3=imMin;
        else
            imagesc(abs(gData.quantizedImage3),[imMin imMax]);
            hist_result=gData.hist_result3;
            
            gData.w_sliderVal3=currentW;
            gData.c_sliderVal3=currentC;
            gData.imMax3=imMax;
            gData.imMin3=imMin;
        end
    case 4
        axes(handles.viewer_axes4);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace4),[imMin imMax]);
            hist_result=gData.hist_resultK4;
            
            gData.w_sliderValK4=currentW;
            gData.c_sliderValK4=currentC;
            gData.imMaxK4=imMax;
            gData.imMinK4=imMin;
        else
            imagesc(abs(gData.quantizedImage4),[imMin imMax]);
            hist_result=gData.hist_result4;
            
            gData.w_sliderVal4=currentW;
            gData.c_sliderVal4=currentC;
            gData.imMax4=imMax;
            gData.imMin4=imMin;
        end
end
axis off;
axis image;

%draw a box (width)
axes(handles.hist_axes5);
if kspaceKey
    plot(hist_result,'m','linewidth',2);
else
    plot(hist_result,'r','linewidth',2);
end
yLimVal=gData.yLimVal;
axis off;
xlim([0 histSteps]);
ylim([0 yLimVal]);
rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');

% --- Executes during object creation, after setting all properties.
function w_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function c_slider_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
histSteps=gData.histSteps;
eval(['kspaceKey=gData.v',num2str(viewPortIndex),'Status(1,5);']);

if get(handles.vPort1_check,'value')==1
    if isempty(gData.quantizedImage1)
        msgbox('No image was found in the view port 1','Export','error');
        return;
    end
elseif get(handles.vPort2_check,'value')==1
    if isempty(gData.quantizedImage2)
        msgbox('No image was found in the view port 2','Export','error');
        return;
    end
elseif get(handles.vPort3_check,'value')==1
    if isempty(gData.quantizedImage3)
        msgbox('No image was found in the view port 3','Export','error');
        return;
    end
elseif get(handles.vPort4_check,'value')==1
    if isempty(gData.quantizedImage4)
        msgbox('No image was found in the view port 4','Export','error');
        return;
    end
end
currentC=round(get(handles.c_slider,'value'));
set(handles.c_box,'string',num2str(currentC));

currentW=str2double(get(handles.w_box,'string'));

imMax=currentC+currentW/2;
imMin=currentC-currentW/2;

if imMax>histSteps
    imMax=histSteps;
    if currentC==histSteps
        currentC=histSteps-1;
    end
    imMin=histSteps-(histSteps-currentC)*2;
    currentW=round(imMax-imMin);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

if imMin<0
    imMin=0;
    imMax=currentC*2;
    currentW=round(imMax);
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

switch viewPortIndex
    case 1
        axes(handles.viewer_axes1);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace1),[imMin imMax]);
            hist_result=gData.hist_resultK1;
            
            gData.w_sliderValK1=currentW;
            gData.c_sliderValK1=currentC;
            gData.imMaxK1=imMax;
            gData.imMinK1=imMin;
        else
            imagesc(abs(gData.quantizedImage1),[imMin imMax]);
            hist_result=gData.hist_result1;
            
            gData.w_sliderVal1=currentW;
            gData.c_sliderVal1=currentC;
            gData.imMax1=imMax;
            gData.imMin1=imMin;
        end
    case 2
        axes(handles.viewer_axes2);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace2),[imMin imMax]);
            hist_result=gData.hist_resultK2;
            
            gData.w_sliderValK2=currentW;
            gData.c_sliderValK2=currentC;
            gData.imMaxK2=imMax;
            gData.imMinK2=imMin;
        else
            imagesc(abs(gData.quantizedImage2),[imMin imMax]);
            hist_result=gData.hist_result2;
            
            gData.w_sliderVal2=currentW;
            gData.c_sliderVal2=currentC;
            gData.imMax2=imMax;
            gData.imMin2=imMin;
        end
    case 3
        axes(handles.viewer_axes3);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace3),[imMin imMax]);
            hist_result=gData.hist_resultK3;
            
            gData.w_sliderValK3=currentW;
            gData.c_sliderValK3=currentC;
            gData.imMaxK3=imMax;
            gData.imMinK3=imMin;
        else
            imagesc(abs(gData.quantizedImage3),[imMin imMax]);
            hist_result=gData.hist_result3;
            
            gData.w_sliderVal3=currentW;
            gData.c_sliderVal3=currentC;
            gData.imMax3=imMax;
            gData.imMin3=imMin;
        end
    case 4
        axes(handles.viewer_axes4);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace4),[imMin imMax]);
            hist_result=gData.hist_resultK4;
            
            gData.w_sliderValK4=currentW;
            gData.c_sliderValK4=currentC;
            gData.imMaxK4=imMax;
            gData.imMinK4=imMin;
        else
            imagesc(abs(gData.quantizedImage4),[imMin imMax]);
            hist_result=gData.hist_result4;
            
            gData.w_sliderVal4=currentW;
            gData.c_sliderVal4=currentC;
            gData.imMax4=imMax;
            gData.imMin4=imMin;
        end
end
axis off;
axis image;

%draw a box (width)
axes(handles.hist_axes5);
if kspaceKey
    plot(hist_result,'m','linewidth',2);
else
    plot(hist_result,'r','linewidth',2);
end
yLimVal=gData.yLimVal;
axis off;
xlim([0 histSteps]);
ylim([0 yLimVal]);
rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');

% --- Executes during object creation, after setting all properties.
function c_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function w_box_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
histSteps=gData.histSteps;
eval(['kspaceKey=gData.v',num2str(viewPortIndex),'Status(1,5);']);

if get(handles.vPort1_check,'value')==1
    if isempty(gData.quantizedImage1)
        msgbox('No image was found in the view port 1','Export','error');
        return;
    end
    viewPortIndex=1;
elseif get(handles.vPort2_check,'value')==1
    if isempty(gData.quantizedImage2)
        msgbox('No image was found in the view port 2','Export','error');
        return;
    end
    viewPortIndex=2;
elseif get(handles.vPort3_check,'value')==1
    if isempty(gData.quantizedImage3)
        msgbox('No image was found in the view port 3','Export','error');
        return;
    end
    viewPortIndex=3;
elseif get(handles.vPort4_check,'value')==1
    if isempty(gData.quantizedImage4)
        msgbox('No image was found in the view port 4','Export','error');
        return;
    end
    viewPortIndex=4;
end
axis off;
axis image;

currentW=round(str2double(get(handles.w_box,'string')));
if isnan(currentW)==1 || currentW<=0 || currentW>histSteps
    eval(['currentW=gData.w_sliderVal',num2str(viewPortIndex),';']);
end

set(handles.w_box,'string',num2str(currentW));
set(handles.w_slider,'value',currentW);

currentC=str2double(get(handles.c_box,'string'));
imMax=currentC+currentW/2;
imMin=currentC-currentW/2;

if imMax>histSteps
    imMax=histSteps;
    imMin=histSteps-currentW;
    currentC=imMin+currentW/2;
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

if imMin<0
    imMin=0;
    imMax=currentW;
    currentC=currentW/2;
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

switch viewPortIndex
    case 1
        axes(handles.viewer_axes1);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace1),[imMin imMax]);
            hist_result=gData.hist_resultK1;
            
            gData.w_sliderValK1=currentW;
            gData.c_sliderValK1=currentC;
            gData.imMaxK1=imMax;
            gData.imMinK1=imMin;
        else
            imagesc(abs(gData.quantizedImage1),[imMin imMax]);
            hist_result=gData.hist_result1;
            
            gData.w_sliderVal1=currentW;
            gData.c_sliderVal1=currentC;
            gData.imMax1=imMax;
            gData.imMin1=imMin;
        end
    case 2
        axes(handles.viewer_axes2);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace2),[imMin imMax]);
            hist_result=gData.hist_resultK2;
            
            gData.w_sliderValK2=currentW;
            gData.c_sliderValK2=currentC;
            gData.imMaxK2=imMax;
            gData.imMinK2=imMin;
        else
            imagesc(abs(gData.quantizedImage2),[imMin imMax]);
            hist_result=gData.hist_result2;
            
            gData.w_sliderVal2=currentW;
            gData.c_sliderVal2=currentC;
            gData.imMax2=imMax;
            gData.imMin2=imMin;
        end
    case 3
        axes(handles.viewer_axes3);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace3),[imMin imMax]);
            hist_result=gData.hist_resultK3;
            
            gData.w_sliderValK3=currentW;
            gData.c_sliderValK3=currentC;
            gData.imMaxK3=imMax;
            gData.imMinK3=imMin;
        else
            imagesc(abs(gData.quantizedImage3),[imMin imMax]);
            hist_result=gData.hist_result3;
            
            gData.w_sliderVal3=currentW;
            gData.c_sliderVal3=currentC;
            gData.imMax3=imMax;
            gData.imMin3=imMin;
        end
    case 4
        axes(handles.viewer_axes4);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace4),[imMin imMax]);
            hist_result=gData.hist_resultK4;
            
            gData.w_sliderValK4=currentW;
            gData.c_sliderValK4=currentC;
            gData.imMaxK4=imMax;
            gData.imMinK4=imMin;
        else
            imagesc(abs(gData.quantizedImage4),[imMin imMax]);
            hist_result=gData.hist_result4;
            
            gData.w_sliderVal4=currentW;
            gData.c_sliderVal4=currentC;
            gData.imMax4=imMax;
            gData.imMin4=imMin;
        end
end
axis off;
axis image;

%draw a box (width)
axes(handles.hist_axes5);
if kspaceKey
    plot(hist_result,'m','linewidth',2);
else
    plot(hist_result,'r','linewidth',2);
end
yLimVal=gData.yLimVal;
axis off;
xlim([0 histSteps]);
ylim([0 yLimVal]);
rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');

% --- Executes during object creation, after setting all properties.
function w_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function c_box_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
histSteps=gData.histSteps;
eval(['kspaceKey=gData.v',num2str(viewPortIndex),'Status(1,5);']);

if get(handles.vPort1_check,'value')==1
    if isempty(gData.quantizedImage1)
        msgbox('No image was found in the view port 1','Export','error');
        return;
    end
elseif get(handles.vPort2_check,'value')==1
    if isempty(gData.quantizedImage2)
        msgbox('No image was found in the view port 2','Export','error');
        return;
    end
elseif get(handles.vPort3_check,'value')==1
    if isempty(gData.quantizedImage3)
        msgbox('No image was found in the view port 3','Export','error');
        return;
    end
elseif get(handles.vPort4_check,'value')==1
    if isempty(gData.quantizedImage4)
        msgbox('No image was found in the view port 4','Export','error');
        return;
    end
end

currentC=round(str2double(get(handles.c_box,'string')));
if isnan(currentC)==1 || currentC<=0 || currentC>histSteps
    eval(['currentC=gData.c_sliderVal',num2str(viewPortIndex),';']);
end

if currentC==histSteps
    currentC=histSteps-1;
end

gData.c_sliderVal=currentC;

set(handles.c_box,'string',num2str(currentC));
set(handles.c_slider,'value',currentC);

currentW=str2double(get(handles.w_box,'string'));
imMax=currentC+currentW/2;
imMin=currentC-currentW/2;

if imMax>histSteps
    imMax=histSteps;
    imMin=histSteps-(histSteps-currentC)*2;
    currentW=imMax-imMin;
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

if imMin<0
    imMin=0;
    imMax=currentC*2;
    currentW=imMax;
    set(handles.w_box,'string',num2str(currentW));
    set(handles.c_box,'string',num2str(currentC));
    set(handles.w_slider,'value',round(currentW));
    set(handles.c_slider,'value',round(currentC));
end

switch viewPortIndex
    case 1
        axes(handles.viewer_axes1);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace1),[imMin imMax]);
            hist_result=gData.hist_resultK1;
            
            gData.w_sliderValK1=currentW;
            gData.c_sliderValK1=currentC;
            gData.imMaxK1=imMax;
            gData.imMinK1=imMin;
        else
            imagesc(abs(gData.quantizedImage1),[imMin imMax]);
            hist_result=gData.hist_result1;
            
            gData.w_sliderVal1=currentW;
            gData.c_sliderVal1=currentC;
            gData.imMax1=imMax;
            gData.imMin1=imMin;
        end
    case 2
        axes(handles.viewer_axes2);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace2),[imMin imMax]);
            hist_result=gData.hist_resultK2;
            
            gData.w_sliderValK2=currentW;
            gData.c_sliderValK2=currentC;
            gData.imMaxK2=imMax;
            gData.imMinK2=imMin;
        else
            imagesc(abs(gData.quantizedImage2),[imMin imMax]);
            hist_result=gData.hist_result2;
            
            gData.w_sliderVal2=currentW;
            gData.c_sliderVal2=currentC;
            gData.imMax2=imMax;
            gData.imMin2=imMin;
        end
    case 3
        axes(handles.viewer_axes3);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace3),[imMin imMax]);
            hist_result=gData.hist_resultK3;
            
            gData.w_sliderValK3=currentW;
            gData.c_sliderValK3=currentC;
            gData.imMaxK3=imMax;
            gData.imMinK3=imMin;
        else
            imagesc(abs(gData.quantizedImage3),[imMin imMax]);
            hist_result=gData.hist_result3;
            
            gData.w_sliderVal3=currentW;
            gData.c_sliderVal3=currentC;
            gData.imMax3=imMax;
            gData.imMin3=imMin;
        end
    case 4
        axes(handles.viewer_axes4);
        
        if kspaceKey
            imagesc(abs(gData.quantizedKspace4),[imMin imMax]);
            hist_result=gData.hist_resultK4;
            
            gData.w_sliderValK4=currentW;
            gData.c_sliderValK4=currentC;
            gData.imMaxK4=imMax;
            gData.imMinK4=imMin;
        else
            imagesc(abs(gData.quantizedImage4),[imMin imMax]);
            hist_result=gData.hist_result4;
            
            gData.w_sliderVal4=currentW;
            gData.c_sliderVal4=currentC;
            gData.imMax4=imMax;
            gData.imMin4=imMin;
        end
end
axis off;
axis image;

%draw a box (width)
axes(handles.hist_axes5);
if kspaceKey
    plot(hist_result,'m','linewidth',2);
else
    plot(hist_result,'r','linewidth',2);
end
yLimVal=gData.yLimVal;
axis off;
xlim([0 histSteps]);
ylim([0 yLimVal]);
rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');

% --- Executes during object creation, after setting all properties.
function c_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function sos_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sos_RBT,'value',1);
set(handles.som_RBT,'value',0);
gData.sumMethod=1;

function som_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sos_RBT,'value',0);
set(handles.som_RBT,'value',1);
gData.sumMethod=2;

function noiseSF_Callback(hObject, eventdata, handles)
global gData;
histSteps=gData.histSteps;
viewPortIndex=gData.currentViewPort;
eval(['nRx=gData.nRx',num2str(viewPortIndex),';']);
eval(['mSizeLocal=gData.mSizeLocal',num2str(viewPortIndex),';']);
eval(['noiseKey=gData.noiseKey',num2str(viewPortIndex),';']);
eval(['imMin=gData.imMin',num2str(viewPortIndex),';']);
eval(['imMax=gData.imMax',num2str(viewPortIndex),';']);
eval(['currentW=gData.w_sliderVal',num2str(viewPortIndex),';']);
eval(['currentC=gData.c_sliderVal',num2str(viewPortIndex),';']);
eval(['imMinK=gData.imMinK',num2str(viewPortIndex),';']);
eval(['imMaxK=gData.imMax',num2str(viewPortIndex),';']);
eval(['currentWK=gData.w_sliderValK',num2str(viewPortIndex),';']);
eval(['currentCK=gData.c_sliderValK',num2str(viewPortIndex),';']);
eval(['peKey=gData.peKey',num2str(viewPortIndex),';']);

noiseSFtemp=str2double(get(handles.noiseSF,'string'));

eval(['imData=gData.curPortData',num2str(viewPortIndex),';']);

if isempty(imData)
    msgbox('No image was found in the selected view port','Error','error');
    set(handles.noiseSF,'string','0');
    return;
end

if noiseKey==0
    msgbox('Noise file was not defined.','Noise','error');
    set(handles.noiseSF,'string','0');
    eval(['gData.noiseSF',num2str(viewPortIndex),'=0;']);
    return;
end

if isnan(noiseSFtemp)==1 %empty
    noiseSFtemp=0;
    set(handles.noiseSF,'string','0');
end
    
if noiseSFtemp<0
    noiseSFtemp=0;
    set(handles.noiseSF,'string','0');
end
eval(['peKey=gData.peKey',num2str(viewPortIndex),';']);
eval(['gData.noiseSF',num2str(viewPortIndex),'=noiseSFtemp;']);

if noiseKey
    if nRx==1
        eval(['k_data=gData.vPort',num2str(viewPortIndex),'Kspace+gData.vPort',num2str(viewPortIndex),'Noise*noiseSFtemp;']);
        
        qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
        
        im_data=ifftshift(ifft2(ifftshift(k_data)));
        
        if peKey==1
            im_data=rot90(im_data,-1);
        elseif peKey==2
            im_data=fliplr(im_data);
        end
        
        qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
        
        eval(['assignin(''base'',''kSpace',num2str(viewPortIndex),''',k_data);']);
        eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
        eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
        eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
        eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
        eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
        
        eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
        eval(['tempVal=find(gData.v',num2str(viewPortIndex),'Status==1);']);
        
        switch tempVal
            case 1 %im_mag
                imagesc(qImage,[imMin imMax]);
            case 2 %im_phs
                imagesc(atan2(imag(im_data),real(im_data)));
            case 3 %im_real
                imagesc(real(im_data));
            case 4 %im_imag
                imagesc(imag(im_data));
            case 5 %ksp_mag
                imagesc(qKspace,[imMinK imMaxK]);
            case 6 %ksp_real
                imagesc(real(k_data));
            case 7 %ksp_imag
                imagesc(imag(k_data));
        end
        axis image;
        axis off;
        colormap(gray);
        
        %set check-box status
        set(handles.im_mag,'enable','on');
        set(handles.im_phs,'enable','on');
        set(handles.im_real,'enable','on');
        set(handles.im_imag,'enable','on');
        set(handles.ksp_mag,'enable','on');
        set(handles.ksp_real,'enable','on');
        set(handles.ksp_imag,'enable','on');
    end
    
    if nRx>1
        sumMethod=gData.sumMethod;
        k_data=zeros(mSizeLocal,mSizeLocal);
        im_data=zeros(mSizeLocal,mSizeLocal);
        im_data_ch=zeros(nRx,mSizeLocal,mSizeLocal);
        
        for t=1:nRx
            eval(['k_dataTemp=squeeze(gData.vPort',num2str(viewPortIndex),'Kspace(t,:,:))+squeeze(gData.vPort',num2str(viewPortIndex),'Noise(t,:,:))*noiseSFtemp;']);
            
            im_dataTemp=ifftshift(ifft2(ifftshift(k_dataTemp)));
            
            if sumMethod==1 %Sum of Square
                im_data=im_data+abs(im_dataTemp).^2;
                k_data=k_data+abs(k_dataTemp).^2;
            elseif sumMethod==2 %Sum of Magnitude
                im_data=im_data+abs(im_dataTemp);
                k_data=k_data+abs(k_dataTemp);
            end
        end
        
        if sumMethod==1 %Sum of Square
            im_data=sqrt(im_data);
        elseif sumMethod==2 %Sum of Magnitude
            im_data=im_data/1;
        end
        
        if peKey==1
            im_data=rot90(im_data,-1);
        elseif peKey==2
            im_data=fliplr(im_data);
        end
        
        qKspace=abs(k_data)/max(max(abs(k_data)))*histSteps;
        qImage=abs(im_data)/max(max(abs(im_data)))*histSteps;
        
        eval(['assignin(''base'',''image',num2str(viewPortIndex),''',im_data);']);
        eval(['gData.vPort',num2str(viewPortIndex),'Image=im_data;']);
        eval(['gData.curPortData',num2str(viewPortIndex),'=qImage;']);
        eval(['gData.quantizedImage',num2str(viewPortIndex),'=qImage;']);
        eval(['gData.quantizedKspace',num2str(viewPortIndex),'=qKspace;']);
        
        eval(['axes(handles.viewer_axes',num2str(viewPortIndex),');']);
        eval(['tempVal=find(gData.v',num2str(viewPortIndex),'Status==1);']);
        
        switch tempVal
            case 1 %im_mag
                imagesc(qImage,[imMin imMax]);
            case 2 %im_phs
                imagesc(atan2(imag(im_data),real(im_data)));
            case 3 %im_real
                imagesc(real(im_data));
            case 4 %im_imag
                imagesc(imag(im_data));
            case 5 %ksp_mag
                imagesc(qKspace,[imMinK imMaxK]);
            case 6 %ksp_real
                imagesc(real(k_data));
            case 7 %ksp_imag
                imagesc(imag(k_data));
        end
        axis image;
        axis off;
        colormap(gray);
        
        %set check-box status
        set(handles.im_mag,'enable','on');
        set(handles.im_phs,'enable','on');
        set(handles.im_real,'enable','on');
        set(handles.im_imag,'enable','on');
        set(handles.ksp_mag,'enable','on');
        set(handles.ksp_real,'enable','on');
        set(handles.ksp_imag,'enable','on');
    end
    
    set(handles.w_slider,'enable','on');
    set(handles.c_slider,'enable','on');
    set(handles.w_box,'enable','on');
    set(handles.c_box,'enable','on');
    
    eval(['gData.subKey',num2str(viewPortIndex),'=0;']);
    
    %histogram (Image)
    im_data1D=reshape(abs(im_data),1,mSizeLocal^2);
    [hist_result,cnt]=hist(im_data1D,histSteps);
    eval(['gData.hist_result',num2str(viewPortIndex),'=hist_result;']);
    
    %histogram (kspace)
    k_data1D=reshape(abs(k_data),1,mSizeLocal^2);
    [hist_resultK,cnt]=hist(k_data1D,histSteps);
    eval(['gData.hist_resultK',num2str(viewPortIndex),'=hist_resultK;']);

    if get(handles.im_mag,'value')
        axes(handles.hist_axes5);
        plot(hist_result,'r','linewidth',2);
        axis off;
        yLimVal=gData.yLimVal;
        rectangle('Position',[imMin,1,currentW,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentC currentC],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
        
        set(handles.im_mag,'value',1);
        set(handles.im_phs,'value',0);
        set(handles.im_real,'value',0);
        set(handles.im_imag,'value',0);
        set(handles.ksp_mag,'value',0);
        set(handles.ksp_real,'value',0);
        set(handles.ksp_imag,'value',0);
    elseif get(handles.ksp_mag,'value')
        axes(handles.hist_axes5);
        plot(hist_resultK,'m','linewidth',2);
        axis off;
        yLimVal=gData.yLimVal;
        rectangle('Position',[imMinK,1,currentWK,yLimVal-2],'Edgecolor','k','linestyle',':');
        line([currentCK currentCK],[1 yLimVal-1],'color','b','linewidth',2,'linestyle','--');
        xlim([0 histSteps]);
        ylim([0 yLimVal]);
        
        set(handles.im_mag,'value',0);
        set(handles.im_phs,'value',0);
        set(handles.im_real,'value',0);
        set(handles.im_imag,'value',0);
        set(handles.ksp_mag,'value',1);
        set(handles.ksp_real,'value',0);
        set(handles.ksp_imag,'value',0);
    end
end

function noiseSF_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function nRx_Callback(hObject, eventdata, handles)
global gData;
viewPortIndex=gData.currentViewPort;
nRxTemp=str2double(get(handles.nRx,'string'));

if isnan(nRxTemp)==1 %empty
    nRxTemp=1;
    set(handles.nRx,'string','1');
end

nRxTemp=round(nRxTemp);

if nRxTemp<=0
    nRxTemp=1;
    set(handles.nRx,'string','1');
end

set(handles.nRx,'string',num2str(nRxTemp));
eval(['gData.nRx',num2str(viewPortIndex),'=nRxTemp;']);

if nRxTemp==1
    set(handles.sos_RBT,'enable','off');
    set(handles.som_RBT,'enable','off');
else
    set(handles.sos_RBT,'enable','on');
    set(handles.som_RBT,'enable','on');
end

function nRx_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sub_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sub_RBT,'value',1);
set(handles.div_RBT,'value',0);
set(handles.add_RBT,'value',0);
set(handles.mul_RBT,'value',0);
set(handles.algebraSymbol,'string','-');
gData.algebraKey=1;

function div_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sub_RBT,'value',0);
set(handles.div_RBT,'value',1);
set(handles.add_RBT,'value',0);
set(handles.mul_RBT,'value',0);
set(handles.algebraSymbol,'string','/');
gData.algebraKey=2;

function add_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sub_RBT,'value',0);
set(handles.div_RBT,'value',0);
set(handles.add_RBT,'value',1);
set(handles.mul_RBT,'value',0);
set(handles.algebraSymbol,'string','+');
gData.algebraKey=3;

function mul_RBT_Callback(hObject, eventdata, handles)
global gData;
set(handles.sub_RBT,'value',0);
set(handles.div_RBT,'value',0);
set(handles.add_RBT,'value',0);
set(handles.mul_RBT,'value',1);
set(handles.algebraSymbol,'string','x');
gData.algebraKey=4;


function rot90_c_Callback(hObject, eventdata, handles)
global gData;

currentViewPort=gData.currentViewPort;

switch currentViewPort
    case 1
        gData.vPort1Image=rot90(gData.vPort1Image,-1);
        gData.curPortData1=rot90(gData.curPortData1,-1);
        gData.quantizedImage1=rot90(gData.quantizedImage1,-1);
        kspaceKey=gData.v1Status(1,5);
        if kspaceKey
            imMin=gData.imMinK1;
            imMax=gData.imMaxK1;
        else
            imMin=gData.imMin1;
            imMax=gData.imMax1;
        end
    case 2
        gData.vPort2Image=rot90(gData.vPort2Image,-1);
        gData.curPortData2=rot90(gData.curPortData2,-1);
        gData.quantizedImage2=rot90(gData.quantizedImage2,-1);
        kspaceKey=gData.v2Status(1,5);
        if kspaceKey
            imMin=gData.imMinK2;
            imMax=gData.imMaxK2;
        else
            imMin=gData.imMin2;
            imMax=gData.imMax2;
        end
    case 3
        gData.vPort3Image=rot90(gData.vPort3Image,-1);
        gData.curPortData3=rot90(gData.curPortData3,-1);
        gData.quantizedImage3=rot90(gData.quantizedImage3,-1);
        kspaceKey=gData.v3Status(1,5);
        if kspaceKey
            imMin=gData.imMinK3;
            imMax=gData.imMaxK3;
        else
            imMin=gData.imMin3;
            imMax=gData.imMax3;
        end
    case 4
        gData.vPort4Image=rot90(gData.vPort4Image,-1);
        gData.curPortData4=rot90(gData.curPortData4,-1);
        gData.quantizedImage4=rot90(gData.quantizedImage4,-1);
        kspaceKey=gData.v4Status(1,5);
        if kspaceKey
            imMin=gData.imMinK4;
            imMax=gData.imMaxK4;
        else
            imMin=gData.imMin4;
            imMax=gData.imMax4;
        end
end

eval(['imData=gData.curPortData',num2str(currentViewPort),';']);
if isempty(imData)
    eval(['msgbox(''No image was found in the view port ',num2str(currentViewPort),''',''Export'',''error'');']);
    return;
else
    if get(handles.im_mag,'value') || get(handles.ksp_mag,'value')
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),',[imMin imMax]);']);
        axis image;
        axis off;
        colormap(gray);
    else
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),');']);
        axis image;
        axis off;
        colormap(gray);
    end
end

function rot90_ac_Callback(hObject, eventdata, handles)
global gData;

currentViewPort=gData.currentViewPort;

switch currentViewPort
    case 1
        gData.vPort1Image=rot90(gData.vPort1Image,1);
        gData.curPortData1=rot90(gData.curPortData1,1);
        gData.quantizedImage1=rot90(gData.quantizedImage1,1);
        kspaceKey=gData.v1Status(1,5);
        if kspaceKey
            imMin=gData.imMinK1;
            imMax=gData.imMaxK1;
        else
            imMin=gData.imMin1;
            imMax=gData.imMax1;
        end
    case 2
        gData.vPort2Image=rot90(gData.vPort2Image,1);
        gData.curPortData2=rot90(gData.curPortData2,1);
        gData.quantizedImage2=rot90(gData.quantizedImage2,1);
        kspaceKey=gData.v2Status(1,5);
        if kspaceKey
            imMin=gData.imMinK2;
            imMax=gData.imMaxK2;
        else
            imMin=gData.imMin2;
            imMax=gData.imMax2;
        end
    case 3
        gData.vPort3Image=rot90(gData.vPort3Image,1);
        gData.curPortData3=rot90(gData.curPortData3,1);
        gData.quantizedImage3=rot90(gData.quantizedImage3,1);
        kspaceKey=gData.v3Status(1,5);
        if kspaceKey
            imMin=gData.imMinK3;
            imMax=gData.imMaxK3;
        else
            imMin=gData.imMin3;
            imMax=gData.imMax3;
        end
    case 4
        gData.vPort4Image=rot90(gData.vPort4Image,1);
        gData.curPortData4=rot90(gData.curPortData4,1);
        gData.quantizedImage4=rot90(gData.quantizedImage4,1);
        kspaceKey=gData.v4Status(1,5);
        if kspaceKey
            imMin=gData.imMinK4;
            imMax=gData.imMaxK4;
        else
            imMin=gData.imMin4;
            imMax=gData.imMax4;
        end
end

eval(['imData=gData.curPortData',num2str(currentViewPort),';']);
if isempty(imData)
    eval(['msgbox(''No image was found in the view port ',num2str(currentViewPort),''',''Export'',''error'');']);
    return;
else
    if get(handles.im_mag,'value') || get(handles.ksp_mag,'value')
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),',[imMin imMax]);']);
        axis image;
        axis off;
        colormap(gray);
    else
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),');']);
        axis image;
        axis off;
        colormap(gray);
    end
end

function flip_UD_Callback(hObject, eventdata, handles)
global gData;

currentViewPort=gData.currentViewPort;

switch currentViewPort
    case 1
        gData.vPort1Image=flipud(gData.vPort1Image);
        gData.curPortData1=flipud(gData.curPortData1);
        gData.quantizedImage1=flipud(gData.quantizedImage1);
        kspaceKey=gData.v1Status(1,5);
        if kspaceKey
            imMin=gData.imMinK1;
            imMax=gData.imMaxK1;
        else
            imMin=gData.imMin1;
            imMax=gData.imMax1;
        end
    case 2
        gData.vPort2Image=flipud(gData.vPort2Image);
        gData.curPortData2=flipud(gData.curPortData2);
        gData.quantizedImage2=flipud(gData.quantizedImage2);
        kspaceKey=gData.v2Status(1,5);
        if kspaceKey
            imMin=gData.imMinK2;
            imMax=gData.imMaxK2;
        else
            imMin=gData.imMin2;
            imMax=gData.imMax2;
        end
    case 3
        gData.vPort3Image=flipud(gData.vPort3Image);
        gData.curPortData3=flipud(gData.curPortData3);
        gData.quantizedImage3=flipud(gData.quantizedImage3);
        kspaceKey=gData.v3Status(1,5);
        if kspaceKey
            imMin=gData.imMinK3;
            imMax=gData.imMaxK3;
        else
            imMin=gData.imMin3;
            imMax=gData.imMax3;
        end
    case 4
        gData.vPort4Image=flipud(gData.vPort4Image);
        gData.curPortData4=flipud(gData.curPortData4);
        gData.quantizedImage4=flipud(gData.quantizedImage4);
        kspaceKey=gData.v4Status(1,5);
        if kspaceKey
            imMin=gData.imMinK4;
            imMax=gData.imMaxK4;
        else
            imMin=gData.imMin4;
            imMax=gData.imMax4;
        end
end

eval(['imData=gData.curPortData',num2str(currentViewPort),';']);
if isempty(imData)
    eval(['msgbox(''No image was found in the view port ',num2str(currentViewPort),''',''Export'',''error'');']);
    return;
else
    if get(handles.im_mag,'value') || get(handles.ksp_mag,'value')
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),',[imMin imMax]);']);
        axis image;
        axis off;
        colormap(gray);
    else
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),');']);
        axis image;
        axis off;
        colormap(gray);
    end
end

function flip_LR_Callback(hObject, eventdata, handles)
global gData;

currentViewPort=gData.currentViewPort;

switch currentViewPort
    case 1
        gData.vPort1Image=fliplr(gData.vPort1Image);
        gData.curPortData1=fliplr(gData.curPortData1);
        gData.quantizedImage1=fliplr(gData.quantizedImage1);
        kspaceKey=gData.v1Status(1,5);
        if kspaceKey
            imMin=gData.imMinK1;
            imMax=gData.imMaxK1;
        else
            imMin=gData.imMin1;
            imMax=gData.imMax1;
        end
    case 2
        gData.vPort2Image=fliplr(gData.vPort2Image);
        gData.curPortData2=fliplr(gData.curPortData2);
        gData.quantizedImage2=fliplr(gData.quantizedImage2);
        kspaceKey=gData.v2Status(1,5);
        if kspaceKey
            imMin=gData.imMinK2;
            imMax=gData.imMaxK2;
        else
            imMin=gData.imMin2;
            imMax=gData.imMax2;
        end
    case 3
        gData.vPort3Image=fliplr(gData.vPort3Image);
        gData.curPortData3=fliplr(gData.curPortData3);
        gData.quantizedImage3=fliplr(gData.quantizedImage3);
        kspaceKey=gData.v3Status(1,5);
        if kspaceKey
            imMin=gData.imMinK3;
            imMax=gData.imMaxK3;
        else
            imMin=gData.imMin3;
            imMax=gData.imMax3;
        end
    case 4
        gData.vPort4Image=fliplr(gData.vPort4Image);
        gData.curPortData4=fliplr(gData.curPortData4);
        gData.quantizedImage4=fliplr(gData.quantizedImage4);
        kspaceKey=gData.v4Status(1,5);
        if kspaceKey
            imMin=gData.imMinK4;
            imMax=gData.imMaxK4;
        else
            imMin=gData.imMin4;
            imMax=gData.imMax4;
        end
end

eval(['imData=gData.curPortData',num2str(currentViewPort),';']);
if isempty(imData)
    eval(['msgbox(''No image was found in the view port ',num2str(currentViewPort),''',''Export'',''error'');']);
    return;
else
    if get(handles.im_mag,'value') || get(handles.ksp_mag,'value')
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),',[imMin imMax]);']);
        axis image;
        axis off;
        colormap(gray);
    else
        eval(['axes(handles.viewer_axes',num2str(currentViewPort),');']);
        eval(['imagesc(gData.curPortData',num2str(currentViewPort),');']);
        axis image;
        axis off;
        colormap(gray);
    end
end

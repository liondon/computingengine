function setup

% PSUdo_MRI Startup GUI.

% Clear screen.
clc;

% path(path,[pwd,'\Bin\']);
addpath(genpath([pwd,'\Bin\']));
addpath(genpath([pwd,'\SeqDev\']));

%% Init GUIs.
temp01 = 1000;
temp02 = 600;
hGap = 2;
vGap = 22;

% % Global variables.
global fileAddr;

% Set default file path.
addr = pwd;

% Set file selection path
fileAddr = pwd;

% Create folder 'Protocols' if it does not exist.
if exist('.\Protocols','file')~=7
    mkdir('.\Protocols');
end;

% % Init Main.
hMain = figure('Visible','on','MenuBar','none','Name','StartupGUI',...
    'NumberTitle','off','Position',[100,100,temp01,temp02],'Resize','off',...
    'Toolbar','none','Color',[1,1,1]);
movegui(hMain,'center'); 
 
% % Display the PSUdo_MRI logo.
axes('Position',[.01 .82 .44 .2]);
psuLogo = load('psuLogo.mat');
image(psuLogo.psuLogo);
axis image off;
clear psuLogo;

% % % Display the version.
uicontrol(hMain,'Style','text','string','2014',...
    'Position',[.355*temp01 .915*temp02 55 22],'FontSize',13,...
    'FontWeight','bold','BackgroundColor',[1,1,1]);

% % Display the GeoPanel.
uipanel(hMain,'Title','Geometry Viewer & Editor','BackgroundColor','white',...
    'Position',[.45 .01 .545 .98],'FontWeight','bold');
temp1= 208;
temp2=.725;
temp3=.075;
hImages.hAxlImage = axes('Position',[temp2 temp3+(temp1+25)/500 temp1/800 temp1/500]);
hImages.hSagImage = axes('Position',[temp2-(temp1+3)/800 temp3 temp1/800 temp1/500]);
hImages.hCrlImage = axes('Position',[temp2 temp3 temp1/800 temp1/500]);
clear temp1 temp2 temp3;

% % % Display black AxialImage.
axes(hImages.hAxlImage); %#ok<MAXES>
image(0);
colormap(gray);
axis image off;
uicontrol(hMain,'Style','text','string','Axial',...
    'Position',[840 305 40 18],'FontWeight','bold',...
    'BackgroundColor',[1,1,1]);
hImages.Axial.slice = rectangle('edgecolor','r','Visible','off');
hImages.Axial.center = rectangle('edgecolor','y','Visible','off');
hImages.Axial.volume = rectangle('edgecolor','g','Visible','off');

% % % Display black SagittalImage.
axes(hImages.hSagImage); %#ok<MAXES>
image(0);
colormap(gray);
axis image off;
uicontrol(hMain,'Style','text','string','Sagittal',...
    'Position',[570 20 50 18],'FontWeight','bold',...
    'BackgroundColor',[1,1,1]);
hImages.Sagittal.slice = rectangle('edgecolor','r','Visible','off');
hImages.Sagittal.center = rectangle('edgecolor','y','Visible','off');
hImages.Sagittal.volume = rectangle('edgecolor','g','Visible','off');

% % % Display black CoronalImage.
axes(hImages.hCrlImage); %#ok<MAXES>
image(0);
colormap(gray);
axis image off;
uicontrol(hMain,'Style','text','string','Coronal',...
    'Position',[830 20 56 18],'FontWeight','bold',...
    'BackgroundColor',[1,1,1]);
hImages.Coronal.slice = rectangle('edgecolor','r','Visible','off');
hImages.Coronal.center = rectangle('edgecolor','y','Visible','off');
hImages.Coronal.volume = rectangle('edgecolor','g','Visible','off');

global inputCmd;

% % % Save FileName Addresses.
inputCmd = cell(13,2);
inputCmd{1,1}=''; inputCmd{1,2}=''; % Geo FileName
inputCmd{2,1}=''; inputCmd{2,2}=''; % Tiss FileName
inputCmd{3,1}=''; inputCmd{3,2}=''; % dB0 FileName
inputCmd{4,1}=''; inputCmd{4,2}=''; % Sequence FileName
inputCmd{5,1}=''; inputCmd{5,2}=''; % B1+ FileName
inputCmd{6,1}=''; inputCmd{6,2}=''; % E1+ FileName
inputCmd{7,1}=''; inputCmd{7,2}=''; % B1- FileName
inputCmd{8,1}=''; inputCmd{8,2}=''; % E1- FileName
inputCmd{9,1}='';  inputCmd{9,2}='';  % Gx FileName
inputCmd{10,1}=''; inputCmd{10,2}=''; % Gy FileName
inputCmd{11,1}=''; inputCmd{11,2}=''; % Gz FileName
inputCmd{12,1}=''; inputCmd{12,2}=''; % KSpace FileName
inputCmd{13,1}=''; inputCmd{13,2}=''; % KMap FileName
inputCmd{14,1}=''; inputCmd{14,2}=''; % Noise FileName
inputCmd{15,1}=''; inputCmd{15,2}=''; % SAR FileName

global Tx Rx;

Tx.Num = 1;
Tx.MagMat = ones(Tx.Num,1);
Tx.PhsMat = zeros(Tx.Num,1);

Rx.Num = 1;

vGap = 25;
% % % Display DisplayMenu.
uicontrol(hMain,'Style','text','String','Display',...
    'Position',[.46*temp01 .915*temp02 50 20],'BackgroundColor',[1,1,1]);
hDisplayMenu = uicontrol(hMain,'Style','popupmenu','String',{'ID','T1','T2','PD','Chemical Shift','Conductivity','Mass Density'},...
    'Position',[.46*temp01+50 .915*temp02+3 60 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@DisplayMenu_Callback,''});

% % % Display ScaleMenu.
uicontrol(hMain,'Style','text','String','Scale',...
    'Position',[.46*temp01+110 .915*temp02-1 40 20],'BackgroundColor',[1,1,1]);
hScaleMenu = uicontrol(hMain,'Style','popupmenu','String',{'Linear';'Log'},...
    'Position',[.46*temp01+40+110 .915*temp02-4 60 20+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ScaleMenu_Callback,''});

temp001 = .46*temp01; temp002 = .915*temp02-vGap;
% % % Display OrientationMenu.
uicontrol(hMain,'Style','text','String','Slice Orientation',...
    'Position',[temp001 temp002 100 13],'BackgroundColor',[1,1,1]);
temp001 = temp001+100+hGap; temp002 = .915*temp02-vGap-3;
hOrientationMenu = uicontrol(hMain,'Style','popupmenu',...
    'String',{'Axial';'Sagittal';'Coronal'},'Value',1,...
    'Position',[temp001 temp002 60 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@OrientationMenu_Callback,''});
temp001 = temp001+60+hGap; temp002 = .915*temp02-vGap-9;
% % % Display Filter check box
hFilter=uicontrol(hMain,'Style','checkbox','string','Filter',...
    'Value',0,'Position',[temp001 temp002 60 20+7],...
    'BackgroundColor',[1,1,1],'Callback',{@Filter_Callback,''});

temp001 = .46*temp01; temp002 = temp002-vGap-5;
% % % Display GeoSliderTH.
uicontrol(hMain,'Style','text','String','Slice TH(mm)',...
    'Position',[temp001 temp002 80 20],'BackgroundColor',[1,1,1]);
temp001 = temp001+80+hGap;
hGeoSliceTH = uicontrol(hMain,'Style','edit','String','0',...
    'Position',[temp001 temp002 25 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@GeoSliceTHEdit_Callback,''});

% % % Display the FOV popup.
temp001 = temp001+25+2*hGap;
hFOV_Pop = uicontrol(hMain,'Style','popup','string','FOV FE(mm)|FOV PE(mm)',...
    'Position',[temp001 temp002+3 105 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@FOV_Pop_Callback,''});

% % % Display the FOV edit.
temp001 = temp001+105+hGap; 
hFOV = uicontrol(hMain,'Style','edit','String','300',...
    'Position',[temp001 temp002 30 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@FOV_Callback,''});

temp001 = .46*temp01; temp002 = temp002-vGap+6;
% % % Display SlicePosition.
uicontrol(hMain,'Style','text','String','Slice Position',...
    'Position',[temp001 temp002 80 13],'BackgroundColor',[1,1,1]);

temp001 = .46*temp01; temp002 = temp002-vGap;
% % % Display GeoSlider.
hGeoSlider = uicontrol(hMain,'Style','slider','Max',100,'Min',0,...
    'Value',0,'SliderStep',[1/100,10/100],...
    'Position',[temp001 temp002 230 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@GeoSlider_Callback,''});

temp001 = temp001+230+2;
% % % Display GeoSliderEdit.
hGeoSliderEdit = uicontrol(hMain,'Style','edit',...
    'String','0','Position',[temp001 temp002 25 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@GeoSliderEdit_Callback,''});

temp001 = .49*temp01+hGap+5; temp002 = 0.73*temp02-vGap;
% % % Display texts.
uicontrol(hMain,'Style','text','String','Sample',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Sample',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Grad.',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','FOV',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Model',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);

temp001 = .49*temp01+hGap+5; temp002 = temp002-18;
uicontrol(hMain,'Style','text','String','Min',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Max',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','IsoCtr',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Offset',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);
temp001 = temp001+35+5;
uicontrol(hMain,'Style','text','String','Res.',...
    'Position',[temp001 temp002 40 20],...
    'BackgroundColor',[1,1,1]);

temp001 = .49*temp01-5; temp002 = temp002-vGap+3;
uicontrol(hMain,'Style','text','String','X',...
    'Position',[temp001 temp002 10 20],'BackgroundColor',[1,1,1]);
temp002 = temp002-vGap;
uicontrol(hMain,'Style','text','String','Y',...
    'Position',[temp001 temp002 10 20],'BackgroundColor',[1,1,1]);
temp002 = temp002-vGap;
uicontrol(hMain,'Style','text','String','Z',...
    'Position',[temp001 temp002 10 20],'BackgroundColor',[1,1,1]);

temp001 = .49*temp01+8; temp002 = 372.5/500*temp02-vGap*3+4;
% % % Display Min,Max,Ctr,Wid edits.
hXMin = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@XMin_Callback,''});
temp001 = temp001+35+5;
hXMax = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@XMax_Callback,''});
temp001 = temp001+35+5;
hXCtr = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@XCtr_Callback,''});
temp001 = temp001+35+5;
hXSet = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@XSet_Callback,''});
temp001 = temp001+35+5;
hXWid = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@XWid_Callback});

temp001 = .49*temp01+8; temp002 = temp002-vGap;
hYMin = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@YMin_Callback,''});
temp001 = temp001+35+5;
hYMax = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@YMax_Callback,''});
temp001 = temp001+35+5;
hYCtr = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@YCtr_Callback,''});
temp001 = temp001+35+5;
hYSet = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@YSet_Callback,''});
temp001 = temp001+35+5;
hYWid = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@YWid_Callback});

temp001 = .49*temp01+8; temp002 = temp002-vGap;
hZMin = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ZMin_Callback,''});
temp001 = temp001+35+5;
hZMax = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ZMax_Callback,''});
temp001 = temp001+35+5;
hZCtr = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ZCtr_Callback,''});
temp001 = temp001+35+5;
hZSet = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ZSet_Callback,''});
temp001 = temp001+35+5;
hZWid = uicontrol(hMain,'Style','edit','Enable','Inactive',...
    'Position',[temp001 temp002 35 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ZWid_Callback});

% % Display the StudyPanel.
uipanel(hMain,'Title','Study','BackgroundColor','white',...
    'Position',[.01 .78 .43 .08],'FontWeight','bold');

vGap = 22;
temp001 = .018*temp01;
% % % Display the StudyNameText.
uicontrol(hMain,'Style','text','string','Name',...
    'Position',[temp001 .80*temp02 35 13],'BackgroundColor',[1,1,1]);

% % % Display the StudyName.
hStudyName = uicontrol(hMain,'Style','edit','Enable','inactive',...
    'Position',[temp001+35 .80*temp02-3 145 13+6],...
    'BackgroundColor',[1,1,1]);

% % % Display the New button.
hNew = uicontrol(hMain,'Style','pushbutton','String','New',...
    'Position',[temp001+35+145+2 .80*temp02-3 35 13+6],...
    'BusyAction','cancel','Callback',{@StudyNew_Callback,''}); %#ok<NASGU>

% % % Display the Load button.
hLoad = uicontrol(hMain,'Style','pushbutton','String','Load',...
    'Position',[temp001+35+145+2+(35+2)*1 .80*temp02-3 35 13+6],...
    'BusyAction','cancel','Callback',{@StudyLoad_Callback}); %#ok<NASGU>

% % % Display the Save button.
hSave = uicontrol(hMain,'Style','pushbutton','String','Save',...
    'Position',[temp001+35+145+2+(35+2)*2 .80*temp02-3 35 13+6],...
    'BusyAction','cancel','Callback',{@StudySave_Callback,''});

% % % Display the Reset button.
hReset = uicontrol(hMain,'Style','pushbutton','String','Reset',...
    'Position',[temp001+35+145+2+(35+2)*3 .80*temp02-3 38 13+6],...
    'BusyAction','cancel','Callback',{@StudyReset_Callback});

% % Display the InputFilenamesPanel.
uipanel(hMain,'Title','Input Filenames','BackgroundColor','white',...
    'Position',[.01 .37 .43 .41],'FontWeight','bold');

temp001 = .019*temp01; temp002 = .716*temp02;
% % % Display the Geometry button.
hExpGeo = uicontrol(hMain,'Style','pushbutton',...
    'string','Geometry','Position',[temp001 temp002 60 13+6],...
    'BusyAction','cancel','Callback',{@ExpGeometry_Callback,''});

temp001 = temp001 + (60+2);
% % % Display the GeoName.
hExpGeoEdit = uicontrol(hMain,'Style','edit','Enable','inactive',...
    'string','Geo Filename','FontAngle','italic',...
    'Position',[temp001 temp002 110 13+6],...
    'BackgroundColor',[1,1,1]);

temp001 = temp001 + (110+2);
% % % Display the Tissue button.
hExpTiss = uicontrol(hMain,'Style','pushbutton',...
    'string','Tissue',...
    'Position',[temp001 temp002 45 13+6],...
    'BusyAction','cancel','Callback',{@ExpTissue_Callback,''});

temp001 = temp001 + (45+2);
% % % Display the TissName.
hExpTissEdit = uicontrol(hMain,'Style','edit','Enable','inactive',...
    'string','Tiss Filename','FontAngle','italic',...
    'Position',[temp001 temp002 110 13+6],...
    'BackgroundColor',[1,1,1]);

temp001 = .019*temp01; temp002 = temp002-vGap+3;
% % % Display the #Tx text.
uicontrol(hMain,'Style','text','string','#T',...
    'Position',[temp001 temp002 20 13],...
    'BackgroundColor',[1,1,1]);

% % % Display the #Tx edit.
temp001=temp001+20+hGap; temp002 = temp002-3;
hTx = uicontrol(hMain,'Style','edit','String','1',...
    'Position',[temp001 temp002 20 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@hTx_Callback,''});

% % % Display the #R text.
temp001 = temp001+20+hGap; temp002 = temp002+3;
uicontrol(hMain,'Style','text','string','#R',...
    'Position',[temp001 temp002 20 13],...
    'BackgroundColor',[1,1,1]);

% % % Display the #Rx edit.
temp001=temp001+20+hGap; temp002 = temp002-3;
hRx = uicontrol(hMain,'Style','edit','String','1',...
    'Position',[temp001 temp002 20 13+6],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@hRx_Callback,''});

temp001=temp001+25+hGap;
% % % Display the Seq button.
hExpSeq = uicontrol(hMain,'Style','pushbutton','string','Seq',...
    'Position',[temp001 temp002 56 13+6],...
    'BusyAction','cancel','Callback',{@ExpSeq_Callback,''});

temp001 = temp001+(56+2);
% % % Display the seqEdit.
hExpSeqEdit = uicontrol(hMain,'Style','edit','string','Use setup or Seq Filename',...
    'Position',[temp001 temp002 180 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the dB0 button.
hExpDB0 = uicontrol(hMain,'Style','pushbutton','string','dB0',...
    'Position',[temp001 temp002 30 13+6],...
    'BusyAction','cancel','Callback',{@ExpDB0_Callback,''});

temp001 = temp001+(30+2);
% % % Display the dB0Edit.
hExpDB0Edit = uicontrol(hMain,'Style','edit','string','0 or dB0 Filename',...
    'Position',[temp001 temp002 300 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(300+2);
% % % Display the clear dB0 button.
hExpClearDB0 = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearDB0_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the B1p button.
hExpB1p = uicontrol(hMain,'Style','pushbutton','string','B1+',...
    'Position',[temp001 temp002 30 13+6],...
    'BusyAction','cancel','Callback',{@ExpB1p_Callback,''});

temp001 = .019*temp01+30+2;
% % % Display the B1pEdit.
hExpB1pEdit = uicontrol(hMain,'Style','edit','string','Homogeneous or B1+ Filename(s)',...
    'Position',[temp001 temp002 300 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(300+2);
% % % Display the clear B1p button.
hExpClearB1p = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearB1p_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the E1p button.
hExpE1p = uicontrol(hMain,'Style','pushbutton','string','E1+',...
    'Position',[temp001 temp002 30 13+6],...
    'BusyAction','cancel','Callback',{@ExpE1p_Callback,''});

temp001 = temp001 + (30+2);
% % % Display the E1pEdit.
hExpE1pEdit = uicontrol(hMain,'Style','edit','string','E1+ Filename(s)',...
    'Position',[temp001 temp002 300 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(300+2);
% % % Display the clear E1p button.
hExpClearE1p = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearE1p_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the B1m button.
hExpB1m = uicontrol(hMain,'Style','pushbutton','string','B1-',...
    'Position',[temp001 temp002 30 13+6],...
    'BusyAction','cancel','Callback',{@ExpB1m_Callback,''});

temp001 = temp001+(30+2);
% % % Display the B1mEdit.
hExpB1mEdit = uicontrol(hMain,'Style','edit','string','Homogeneous or B1- Filename(s)',...
    'Position',[temp001 temp002 300 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(300+2);
% % % Display the clear B1m button.
hExpClearB1m = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearB1m_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the E1m button.
hExpE1m = uicontrol(hMain,'Style','pushbutton','string','E1-',...
    'Position',[temp001 temp002 30 13+6],...
    'BusyAction','cancel','Callback',{@ExpE1m_Callback,''});

temp001 = temp001+(30+2);
% % % Display the E1mEdit.
hExpE1mEdit = uicontrol(hMain,'Style','edit','string','E1- Filename(s)',...
    'Position',[temp001 temp002 300 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(300+2);
% % % Display the clear E1m button.
hExpClearE1m = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearE1m_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the Gx button.
hExpGx = uicontrol(hMain,'Style','pushbutton','string','Gx',...
    'Position',[temp001 temp002 25 13+6],...
    'BusyAction','cancel','Callback',{@ExpGx_Callback,''});

temp001 = temp001+(25+2);
% % % Display the GxEdit.
hExpGxEdit = uicontrol(hMain,'Style','edit','string','Linear or Gx Filename',...
    'Position',[temp001 temp002 305 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(305+2);
% % % Display the clear Gx button.
hExpClearGx = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearGx_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the Gy button.
hExpGy = uicontrol(hMain,'Style','pushbutton','string','Gy',...
    'Position',[temp001 temp002 25 13+6],...
    'BusyAction','cancel','Callback',{@ExpGy_Callback,''});

temp001 = temp001+(25+2);
% % % Display the GyEdit.
hExpGyEdit = uicontrol(hMain,'Style','edit','string','Linear or Gy Filename',...
    'Position',[temp001 temp002 305 13+6],'FontAngle','italic',...
    'BusyAction','cancel','Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(305+2);
% % % Display the clear Gy button.
hExpClearGy = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearGy_Callback,''});

temp001 = .019*temp01; temp002 = temp002-vGap;
% % % Display the Gz button.
hExpGz = uicontrol(hMain,'Style','pushbutton','string','Gz',...
    'Position',[temp001 temp002 25 13+6],...
    'BusyAction','cancel','Callback',{@ExpGz_Callback,''});

temp001 = temp001+(25+2);
% % % Display the GzEdit.
hExpGzEdit = uicontrol(hMain,'Style','edit','string','Linear or Gz Filename',...
    'Position',[temp001 temp002 305 13+6],'FontAngle','italic',...
    'Enable','inactive','BackgroundColor',[1,1,1]);

temp001 = temp001+(305+2);
% % % Display the clear Gz button.
hExpClearGz = uicontrol(hMain,'Style','pushbutton','string','Clear',...
    'Position',[temp001 temp002 40 13+6],...
    'BusyAction','cancel','Callback',{@ExpClearGz_Callback,''});

% % Display the ImagingPanel.
uipanel(hMain,'Title','Sequence Parameter Setup',...
    'BackgroundColor','white','Position',[.01 .07 .43 .3],...
    'FontWeight','bold');

temp001 = .02*temp01; temp002 = .3*temp02;
% % % Display the B0Text.
uicontrol(hMain,'Style','text','string','B0(T)',...
    'Position',[temp001 temp002 38 16],...
    'BackgroundColor',[1,1,1]);

temp001 = temp001+(38+2); temp002 = temp002-3;
% % % Display the B0Edit.
hB0Edit = uicontrol(hMain,'Style','edit','string','3',...
    'Position',[temp001 temp002 20 13+6],...
    'BackgroundColor',[1,1,1],'Callback',{@B0Edit_Callback,''});

temp001 = temp001+(20+hGap); temp002 = .3*temp02;
% % % Display the SequenceType text.
uicontrol(hMain,'Style','text','string','Sequence Type',...
    'Position',[temp001 temp002 70 16],...
    'BackgroundColor',[1,1,1]);

temp001 = temp001+70; temp002 = temp002-3;

cd([addr '\SeqDev\User']);
tempCell = SeqInterfaceIn;
hSeqType = uicontrol(hMain,'Style','popupmenu',...
    'String',tempCell,'Value',1,...
    'Position',[temp001 temp002 60 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@SeqType_Callback,''});
cd(addr);

clear tempN tempM tempCell;

temp001 = temp001+hGap*2+60; temp002 = temp002+3;
% % % Display the RFShape text.
uicontrol(hMain,'Style','text','string','RF Shape',...
    'Position',[temp001 temp002 70 15],...
    'BackgroundColor',[1,1,1]);

% % % Display the RF_Shape menu.
temp001 = temp001+70; temp002 = temp002-3;
hRF_Shape = uicontrol(hMain,'Style','popupmenu',...
    'String',{'Sinc';'Rect';'Gauss'},'Value',1,...
    'Position',[temp001 temp002 60 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@RF_Shape_Callback,''});


vGap = 25;
% % % Display the RF_Duration text.
temp001 = .02*temp01; temp002 = temp002-vGap+1;
uicontrol(hMain,'Style','text','string','RF Duration (ms)',...
    'Position',[temp001 temp002 110 15],...
    'BackgroundColor',[1,1,1]);

% % % Display the RF_Duration edit.
temp001 = temp001+hGap+110; temp002 = temp002-3;
hRF_Duration = uicontrol(hMain,'Style','edit',...
    'String','2.6',...
    'Position',[temp001 temp002 30 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@RF_Duration_Callback,''});

% % % Display the RF# text.
temp001 = temp001+hGap+35; temp002 = temp002+3;
uicontrol(hMain,'Style','text','string','#Pts in RF Pulse',...
    'Position',[temp001 temp002 70 15],...
    'BackgroundColor',[1,1,1]);

% % % Display the RF# edit.
temp001 = temp001+70+hGap; temp002 = temp002-3;
hRF_Num = uicontrol(hMain,'Style','edit',...
    'String','128',...
    'Position',[temp001 temp002 30 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@RF_Num_Callback,''});

% % % Display the RF_FA text.
temp001 = temp001+35; temp002 = temp002+3;
uicontrol(hMain,'Style','text','string','RF FA',...
    'Position',[temp001 temp002 40 15],...
    'BackgroundColor',[1,1,1]);

% % % Display the RF_FA edit.
temp001 = temp001+42+hGap; temp002 = temp002-3;
hRF_FA = uicontrol(hMain,'Style','edit',...
    'String','90',...
    'Position',[temp001 temp002 25 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@RF_FA_Callback,''});

% % % Display the TI text.
temp001 = .02*temp01; temp002 = temp002-vGap;
uicontrol(hMain,'Style','text','string','TI (ms)',...
    'Position',[temp001 temp002 50 15],...
    'BackgroundColor',[1,1,1]);

% % % Display the TI edit.
temp001 = temp001+hGap+50; temp002 = temp002-3;
hTI = uicontrol(hMain,'Style','edit',...
    'String','10',...
    'Position',[temp001 temp002 25 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@TI_Duration_Callback,''});

% % % Display the MatSize popup.
temp001 = temp001+35+hGap; temp002 = temp002+5;
hMatSize_Pop = uicontrol(hMain,'Style','popup','string','MatSize FE|MatSize PE',...
    'Position',[temp001 temp002+4 40+60 13],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@MatSize_Pop_Callback,''});

% % % Display the MatSize edit.
temp001 = temp001+60+hGap; temp002 = temp002-5;
hMatSize = uicontrol(hMain,'Style','edit','value',[128,128],...
    'Position',[temp001+40 temp002 35 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@MatSize_Callback,''});

% % % Display the ADC_Freq text.
temp001 = temp001+hGap+35; temp002 = temp002+5;
uicontrol(hMain,'Style','text','string','Rcvr BW (kHz)',...
    'Position',[temp001+40 temp002 70 13],...
    'BackgroundColor',[1,1,1]);

% % % Display the ADC_Freq edit.
temp001=temp001+70; temp002 = temp002-5;
hADC_Freq = uicontrol(hMain,'Style','edit','String','50',...
    'Position',[temp001+40 temp002 30 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@ADC_Freq_Callback,''});

temp001=.02*temp01; temp002 = temp002-vGap+3;
% % % Display the Gradient ON text.
uicontrol(hMain,'Style','text','string','Gradient ON',...
    'Position',[temp001 temp002 75 13],...
    'BackgroundColor',[1,1,1]);

temp001=temp001+75+hGap; temp002 = temp002-2;
% % % Display the SS checkbox.
hSS=uicontrol(hMain,'Style','checkbox','string','SS','Value',1,...
    'Position',[temp001 temp002 40 13],...
    'BackgroundColor',[1,1,1],'Callback',{@SS_Callback,''});

temp001=temp001+40;
% % % Display the PE checkbox.
hPE=uicontrol(hMain,'Style','checkbox','string','PE','Value',1,...
    'Position',[temp001 temp002 40 13],...
    'BackgroundColor',[1,1,1],'Callback',{@PE_Callback,''});

temp001=temp001+40;
% % % Display the FE checkbox.
hFE=uicontrol(hMain,'Style','checkbox','string','FE','Value',1,...
    'Position',[temp001 temp002 40 13],...
    'BackgroundColor',[1,1,1],'Callback',{@FE_Callback,''});

% % % Display the TE text.
temp001=temp001+40+10;
uicontrol(hMain,'Style','text','string','TE(ms)',...
    'Position',[temp001 temp002 50 15],...
    'BackgroundColor',[1,1,1]);

temp001=temp001+50; temp002 = temp002-3;
% % % Display the TE edit.
hTE = uicontrol(hMain,'Style','edit',...
    'String','10',...
    'Position',[temp001 temp002 35 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@TE_Callback,''});

temp001=temp001+35+hGap; temp002 = temp002+3;
% % % Display the TR text.
uicontrol(hMain,'Style','text','string','TR(ms)',...
    'Position',[temp001 temp002 50 15],...
    'BackgroundColor',[1,1,1]);

temp001=temp001+50; temp002 = temp002-3;
% % % Display the TR edit.
hTR = uicontrol(hMain,'Style','edit','String','500',...
    'Position',[temp001 temp002 40 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@TR_Callback,''});

% % % Display the #DummyTR text.
temp001=.02*temp01; temp002 = temp002-vGap;
uicontrol(hMain,'Style','text','string','#Dummy',...
    'Position',[temp001 temp002 68 18],...
    'BackgroundColor',[1,1,1]);

% % % Display the DummyNum edit.
temp001 = temp001+68; temp002 = temp002-2;
hDummyNum = uicontrol(hMain,'Style','edit',...
    'String','0',...
    'Position',[temp001 temp002 25 15+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@DummyNum_Callback,''});

% % % Display the PEDirect text.
temp001=temp001+25+hGap; temp002 = temp002-3;
uicontrol(hMain,'Style','text','string','PE Direction',...
    'Position',[temp001 temp002 100 15+7],...
    'BackgroundColor',[1,1,1]);

% % % Display the PEDirect edit.
temp001 = temp001+90+hGap; temp002 = temp002+6;
hPEDirectMenu = uicontrol(hMain,'Style','popup',...
    'String',{'P--A';'L--R'},'Value',1,...
    'Position',[temp001 temp002 50 13+7],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@PEDirectMenu_Callback,''});

temp001=.27*temp01; temp002 = temp002-2;
% % %  Display the SeqGen button.
hSeqGen = uicontrol(hMain,'Style','pushbutton','String','SeqGen',...
    'Position',[temp001 temp002 80 19],'BusyAction','cancel',...
    'Callback',{@SeqGen_Callback}); % on to change to on.

global hSeqPlot;
temp001=temp001+80;
% % % Display the SeqPlot button.
hSeqPlot = uicontrol(hMain,'Style','pushbutton','String','SeqPlot',...
    'Position',[temp001 temp002 50 19],'BusyAction','cancel',...
    'Callback',{@SeqPlot_Callback});

temp001 = .01*temp01; temp002 = .02*temp02;
% % % Display the NumIso text.
% uicontrol(hMain,'Style','text','string','NumIso',...
%     'Position',[temp001 temp002 50 15],...
%     'BackgroundColor',[1,1,1]);

hNumIsoMenu = uicontrol(hMain,'Style','popupmenu',...
    'String',{'IsoNumX';'IsoNumY';'IsoNumZ'},'Value',3,...
    'Position',[temp001 temp002 68 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@NumIsoMenu_Callback,''});

temp001 = temp001+70;
% % Display the NumIso edit.
hNumIso = uicontrol(hMain,'Style','edit','String','1',...
    'Position',[temp001 temp002 20 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@NumIso_Callback,''});

temp001 = temp001+20;
% % Display the Thread text.
uicontrol(hMain,'Style','text','string','Thread(s)',...
    'Position',[temp001 temp002 62 16],...
    'BackgroundColor',[1,1,1]);

temp001 = temp001+60;
% % Display the Thread edit.
hThread = uicontrol(hMain,'Style','edit','String','1',...
    'Position',[temp001 temp002 20 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@Thread_Callback,''});

temp001 = temp001+20;
% % Display the Mode text.
uicontrol(hMain,'Style','text','string','Mode',...
    'Position',[temp001 temp002 40 16],...
    'BackgroundColor',[1,1,1]);

temp001 = temp001+40;
% % Display the Mode Menu.
hMode = uicontrol(hMain,'Style','popupmenu',...
    'String',{'SignalSimple';'SignalAdvanced';'SAR';'Noise'},'Value',2,...
    'Position',[temp001 temp002 110 20],...
    'BackgroundColor',[1,1,1],'BusyAction','cancel',...
    'Callback',{@Mode_Callback,''});

% %  Display the Run button.
hRun = uicontrol(hMain,'Style','pushbutton','String','Run',...
    'Position',[.33*temp01 .015*temp02 60 25],...
    'FontSize',12,'BackgroundColor',[0,1,0],'FontWeight','bold',...
    'Callback',{@Run_Callback});

% %  Display the Exit button.
hExit = uicontrol(hMain,'Style','pushbutton','String','Exit',...
    'Position',[.305*temp01+80+5 .015*temp02 50 25],'Enable','on',...
    'FontSize',12,'BackgroundColor',[1,0,0],'FontWeight','bold',...
    'BusyAction','cancel','Callback',{@Exit_Callback});

clear temp01 temp02;
clear hGap vGap;

reset();

    %% --- Executes on Exit button.
    function Exit_Callback(source,eventdata) %#ok<INUSD,INUSD>
        cd(addr);
        clear variables ;
        clear global inputInfo
        close(gcf);
    end

    %% --- Executes on StudyNew button.
    function StudyNew_Callback(source,eventdata,flag) %#ok<INUSD,INUSD>
        if strcmp(flag,'')
            prompt={'Enter new study name (30):'};
            title='New Study';
            numChar=[1,30];
            newStudy=inputdlg(prompt,title,numChar);

            if isempty(newStudy)~=1
                if strcmp('',newStudy)==1
                    errordlg('NOT A VALID NAME!','Input Error','modal');
                else
                    if exist(horzcat(addr,'\Protocols\',newStudy{1},'.txt'),'file')==2
                        errordlg('THE NEW STUDY NAME ALREADY EXIST!','Input Error','modal');
                    else
                        if isempty(get(hStudyName,'String'))~=1
                            reset();
                        end;
                        set(hStudyName,'String',newStudy{1});
                        set(hExpGeo,'Enable','on');

                        tempStr = get(hStudyName,'String');        
                        if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                            mkdir([addr,'\Protocols\',tempStr,'\']);
                        end;

                        inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[newStudy{1},'.ksig']; % KSpace FileName
                        inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[newStudy{1},'.ktrj']; % KMap FileName
                        inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[newStudy{1},'.nois']; % Noise FileName
                        inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[newStudy{1},'.sar']; % SAR FileName
                    end;
                end;
            end;
        else
            if isempty(get(hStudyName,'String'))~=1
                reset();
            end;
            set(hStudyName,'String',flag);

            tempStr = get(hStudyName,'String');
            if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                mkdir([addr,'\Protocols\',tempStr,'\']);
            end;
            inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[tempStr,'.ksig']; % KSpace FileName
            inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[tempStr,'.ktrj']; % KMap FileName
            inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[tempStr,'.nois']; % Noise FileName
            inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[tempStr,'.sar']; % SAR FileName
        end;
    end

    %% --- Executes on StudyLoad button.
    function StudyLoad_Callback(source,eventdata)
        global geoData;
        global inputInfo;
        global displayInfo;
        
        cd([addr,'\Protocols']);
        
        [fileName,pathName,index]=uigetfile({'*.prot','Protocols File (*.prot)';'*.*','All Fiiles (*.*)'},'OPEN: Protocols File');
        
        cd(addr);
        
        % Read in data from selected file and set protocol
        if index==1     % If *.prot file is selected
            reset();
            tempStr = get(hStudyName,'String');
            if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                mkdir([addr,'\Protocols\',tempStr,'\']);
            end;
            inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[tempStr,'.ksig']; % KSpace FileName
            inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[tempStr,'.ktrj']; % KMap FileName
            inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[tempStr,'.nois']; % Noise FileName
            inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[tempStr,'.sar'];  % SAR FileName
            
            fileAddr = pathName;
            
            set(hStudyName,'String',filenameCvrt(fileName));
            tempStr=textread([pathName,fileName],'%s','delimiter','\n');
            
            tempLoc=find(strcmp(tempStr,'Geometry Filename:'))+1;
            [inputCmd{1,1},inputCmd{1,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{1,1})
                set(hExpGeoEdit,'String','Geo Filename');
            else
                ExpGeometry_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
                set(hExpGeo,'Enable','on');
            end;  
            
            tempLoc=find(strcmp(tempStr,'Tissue Filename:'))+1;
            [inputCmd{2,1},inputCmd{2,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{2,1})
                set(hExpTissEdit,'String','Tiss Filename');
            else
                ExpTissue_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
                set(hExpTiss,'Enable','on');
            end;
            
            tempLoc=find(strcmp(tempStr,'Delta Bo Filename:'))+1;
            [inputCmd{3,1},inputCmd{3,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{3,1})
                set(hExpDB0Edit,'String','0 or dB0 Filename');
            else
                set(hExpDB0Edit,'String',filenameCvrt(inputCmd{3,2}));
                set(hExpDB0Edit,'FontAngle','normal');
                
                set(hExpClearDB0,'Enable','on');
            end;
            
%             tempLoc=find(strcmp(tempStr,'Sequence Filename:'))+1;
%             [inputCmd{4,1},inputCmd{4,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
%             if isempty(inputCmd{4,1})
%                 set(hExpSeqEdit,'String','Use setup or Seq Filename');
%             else
%                 ExpSeq_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
%                 if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
%                     set(hRun,'Enable','on');
%                 end;
%             end;

            tempLoc=find(strcmp(tempStr,'# Tx:'))+1;
            hTx_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'Tx Mag & Phs:'));
            Tx.MagMat = ones(Tx.Num,1);
            Tx.PhsMat = zeros(Tx.Num,1);
            for n=1:Tx.Num
                temp = str2num(cell2mat(tempStr(tempLoc+n,:))); %#ok<ST2NM>
                Tx.MagMat(n)=temp(1);
                Tx.PhsMat(n)=temp(2);
            end;
            
            tempLoc1=find(strcmp(tempStr,'B1p Filename:'))+1;
            tempLoc2=find(strcmp(tempStr,'E1p Filename:'))-1;
            if tempLoc2-tempLoc1 == 0
                [tempStr1,tempStr2] = addrCvrt(cell2mat(tempStr(tempLoc1,:)));
                if isempty(tempStr1)
                    set(hExpB1pEdit,'String','Homogeneous or B1+ Filename(s)');
                else
                    inputCmd{5,1} = {tempStr1};
                    inputCmd{5,2} = {tempStr2};
                    set(hExpB1pEdit,'String',filenameCvrt(tempStr2));
                    set(hExpB1pEdit,'FontAngle','normal');
                end;
            else
                [inputCmd{5,1},inputCmd{5,2}] = addrCvrt(tempStr(tempLoc1:tempLoc2,:));
                tempStr1 = '';
                for n=1:length(inputCmd{5,2})
                    tempStr1 = [tempStr1,filenameCvrt(inputCmd{5,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpB1pEdit,'String',tempStr1);
                set(hExpB1pEdit,'FontAngle','normal');
            end;
            
            tempLoc1=find(strcmp(tempStr,'E1p Filename:'))+1;
            tempLoc2=find(strcmp(tempStr,'# Rx:'))-1;
            if tempLoc2-tempLoc1 == 0
                [tempStr1,tempStr2] = addrCvrt(cell2mat(tempStr(tempLoc1,:)));
                if isempty(tempStr1)
                    set(hExpE1pEdit,'String','E1+ Filename(s)');
                else
                    inputCmd{6,1} = {tempStr1};
                    inputCmd{6,2} = {tempStr2};
                    set(hExpE1pEdit,'String',filenameCvrt(inputCmd{6,2}));
                    set(hExpE1pEdit,'FontAngle','normal');
                end;
            else
                [inputCmd{6,1},inputCmd{6,2}] = addrCvrt(tempStr(tempLoc1:tempLoc2,:));
                tempStr1 = '';
                for n=1:length(inputCmd{6,2})
                    tempStr1 = [tempStr1,filenameCvrt(inputCmd{6,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpE1pEdit,'String',tempStr1);
                set(hExpE1pEdit,'FontAngle','normal');
            end;
            
            tempLoc=find(strcmp(tempStr,'# Rx:'))+1;
            set(hRx,'String',tempStr(tempLoc,:));
            Rx.Num = str2num(cell2mat(tempStr(tempLoc,:))); %#ok<ST2NM>
            
            tempLoc1=find(strcmp(tempStr,'B1m Filename:'))+1;
            tempLoc2=find(strcmp(tempStr,'E1m Filename:'))-1;
            if tempLoc2-tempLoc1 == 0
                [tempStr1,tempStr2] = addrCvrt(cell2mat(tempStr(tempLoc1,:)));
                if isempty(tempStr1)
                    set(hExpB1mEdit,'String','Homogeneous or B1- Filename(s)');
                else
                    inputCmd{7,1} = {tempStr1};
                    inputCmd{7,2} = {tempStr2};
                    set(hExpB1mEdit,'String',filenameCvrt(inputCmd{7,2}));
                    set(hExpB1mEdit,'FontAngle','normal');
                end;
            else
                [inputCmd{7,1},inputCmd{7,2}] = addrCvrt(tempStr(tempLoc1:tempLoc2,:));
                tempStr1 = '';
                for n=1:length(inputCmd{7,2})
                    tempStr1 = [tempStr1,filenameCvrt(inputCmd{7,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpB1mEdit,'String',tempStr1);
                set(hExpB1mEdit,'FontAngle','normal');
            end;
            
            tempLoc1=find(strcmp(tempStr,'E1m Filename:'))+1;
            tempLoc2=find(strcmp(tempStr,'Gx Filename:'))-1;
            if tempLoc2-tempLoc1 == 0
                [tempStr1,tempStr2] = addrCvrt(cell2mat(tempStr(tempLoc1,:)));
                if isempty(tempStr1)
                    set(hExpE1mEdit,'String','E1- Filename(s)');
                else
                    inputCmd{8,1} = {tempStr1};
                    inputCmd{8,2} = {tempStr2};
                    set(hExpE1mEdit,'String',filenameCvrt(inputCmd{8,2}));
                    set(hExpE1mEdit,'FontAngle','normal');
                end;
            else
                [inputCmd{8,1},inputCmd{8,2}] = addrCvrt(tempStr(tempLoc1:tempLoc2,:));
                tempStr1 = '';
                for n=1:length(inputCmd{8,2})
                    tempStr1 = [tempStr1,filenameCvrt(inputCmd{8,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpE1mEdit,'String',tempStr1);
                set(hExpE1mEdit,'FontAngle','normal');
            end;
            
            tempLoc=find(strcmp(tempStr,'Gx Filename:'))+1;
            [inputCmd{9,1},inputCmd{9,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{9,1})
                set(hExpGxEdit,'String','Linear or Gx Filename');
            else
                set(hExpGxEdit,'String',filenameCvrt(inputCmd{9,2}));
                set(hExpGxEdit,'FontAngle','normal');
            end;
            
            tempLoc=find(strcmp(tempStr,'Gy Filename:'))+1;
            [inputCmd{10,1},inputCmd{10,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{10,1})
                set(hExpGyEdit,'String','Linear or Gy Filename');
            else
                set(hExpGyEdit,'String',filenameCvrt(inputCmd{10,2}));
                set(hExpGyEdit,'FontAngle','normal');
            end;
            
            tempLoc=find(strcmp(tempStr,'Gz Filename:'))+1;
            [inputCmd{11,1},inputCmd{11,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            if isempty(inputCmd{11,1})
                set(hExpGzEdit,'String','Linear or Gz Filename');
            else
                set(hExpGzEdit,'String',filenameCvrt(inputCmd{11,2}));
                set(hExpGzEdit,'FontAngle','normal');
            end;
            
            tempLoc=find(strcmp(tempStr,'KSpace Filename:'))+1;
            [inputCmd{12,1},inputCmd{12,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));

            tempLoc=find(strcmp(tempStr,'KMap Filename:'))+1;
            [inputCmd{13,1},inputCmd{13,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'Noise Filename:'))+1;
            [inputCmd{14,1},inputCmd{14,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'SAR Filename:'))+1;
            [inputCmd{15,1},inputCmd{15,2}] = addrCvrt(cell2mat(tempStr(tempLoc,:)));

            tempLoc=find(strcmp(tempStr,'Display:'))+1;
            DisplayMenu_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
                      
            tempLoc=find(strcmp(tempStr,'Slice Orientation:'))+1;
            OrientationMenu_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'Slice Thickness:'))+1;
            GeoSliceTHEdit_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
        
            tempLoc=find(strcmp(tempStr,'Slice Position:'))+1;
            GeoSlider_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'XMin:'))+1;
            XMin_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'YMin:'))+1;
            YMin_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'ZMin:'))+1;
            ZMin_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'XMax:'))+1;
            XMax_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));            
            tempLoc=find(strcmp(tempStr,'YMax:'))+1;
            YMax_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));            
            tempLoc=find(strcmp(tempStr,'ZMax:'))+1;
            ZMax_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'XCtr:'))+1;
            XCtr_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'YCtr:'))+1;
            YCtr_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'ZCtr:'))+1;
            ZCtr_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'XSet:'))+1;
            XSet_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'YSet:'))+1;
            YSet_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'ZSet:'))+1;
            ZSet_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'B0(T):'))+1;
            B0Edit_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'Sequence Type:'))+1;
            SeqType_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'RF Shape:'))+1;
            RF_Shape_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'RF Duration(ms):'))+1;
            RF_Duration_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'# Points in RF Pulse:'))+1;
            RF_Num_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'RF Flip Angle:'))+1;
            RF_FA_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'FOV(mm)'))+1;
            FOV_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'MatSize:'))+1;
            MatSize_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'ADC Freq(kHz):'))+1;
            ADC_Freq_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'TI_Duration(ms):'))+1;
            TI_Duration_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));          
            tempLoc=find(strcmp(tempStr,'Filter'))+1;
            Filter_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'SS:'))+1;
            SS_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'PE:'))+1;
            PE_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'FE:'))+1;
            FE_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));

            tempLoc=find(strcmp(tempStr,'#Dummy TRs:'))+1;
            DummyNum_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'PE Direct:'))+1;
            tempCell = get(hPEDirectMenu,'String');
            temp = find(strcmp(tempCell,cell2mat(tempStr(tempLoc,:))));
            set(hPEDirectMenu,'Value',temp);
            
            tempLoc=find(strcmp(tempStr,'TE(ms):'))+1;
            TE_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'TR(ms):'))+1;
            TR_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
                        
            tempLoc=find(strcmp(tempStr,'NumIsoX:'))+1;
            inputInfo.NumIso(1) = str2double(cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'NumIsoY:'))+1;
            inputInfo.NumIso(2) = str2double(cell2mat(tempStr(tempLoc,:)));
            tempLoc=find(strcmp(tempStr,'NumIsoZ:'))+1;
            inputInfo.NumIso(3) = str2double(cell2mat(tempStr(tempLoc,:)));
            NumIso_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'Thread #:'))+1;
            Thread_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            tempLoc=find(strcmp(tempStr,'Mode:'))+1;
            Mode_Callback(source,eventdata,cell2mat(tempStr(tempLoc,:)));
            
            clear tempStr tempCell tempLoc tempLoc1 tempLoc2;
            
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        end;
        
        clear tempAddr;
    end

    %% --- Executes on StudySave button.
    function StudySave_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        global inputInfo
        
        cd(addr);
        
        % tempAddr = pwd;

        fileName = get(hStudyName,'String');
        pathName = horzcat(pwd,'\Protocols\',get(hStudyName,'String'),'\');

        fid=fopen([pathName,fileName,'.prot'],'w');
        
        fprintf(fid,'INPUT FILENAMES:\n');
        
        fprintf(fid,'  Geometry Filename:\n');
        if strcmp(inputCmd{1,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{1,1},inputCmd{1,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  Tissue Filename:\n');
        if strcmp(inputCmd{2,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{2,1},inputCmd{2,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  Sequence Filename:\n');
        if strcmp(inputCmd{4,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{4,1},inputCmd{4,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;
        
        fprintf(fid,'  Delta Bo Filename:\n');
        if strcmp(inputCmd{3,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{3,1},inputCmd{3,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  # Tx:\n');
        fprintf(fid,['    ',num2str(Tx.Num),'\n']);
        
        fprintf(fid,'  Tx Mag & Phs:\n');
        for n=1:Tx.Num
            fprintf(fid,['    ',num2str(Tx.MagMat(n)),' ',num2str(Tx.PhsMat(n)),'\n']);
        end;
        
        fprintf(fid,'  B1p Filename:\n');
        if strcmp(inputCmd{5,1},'') ~= 1
            for n = 1:length(inputCmd{5,2})
                fprintf(fid,['    ',slashCvrt([inputCmd{5,1}{n},inputCmd{5,2}{n}]),'\n']);
            end;
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  E1p Filename:\n');
        if strcmp(inputCmd{6,1},'') ~= 1
            for n = 1:length(inputCmd{6,2})
                fprintf(fid,['    ',slashCvrt([inputCmd{6,1}{n},inputCmd{6,2}{n}]),'\n']);
            end;
        else
            fprintf(fid,'\n');
        end;
        
        fprintf(fid,'  # Rx:\n');
        fprintf(fid,['    ',num2str(Rx.Num),'\n']);
        
        fprintf(fid,'  B1m Filename:\n');
        if strcmp(inputCmd{7,1},'') ~= 1
            for n = 1:length(inputCmd{7,2})
                fprintf(fid,['    ',slashCvrt([inputCmd{7,1}{n},inputCmd{7,2}{n}]),'\n']);
            end;
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  E1m Filename:\n');
        if strcmp(inputCmd{8,1},'') ~= 1
            for n = 1:length(inputCmd{8,2})
                fprintf(fid,['    ',slashCvrt([inputCmd{8,1}{n},inputCmd{8,2}{n}]),'\n']);
            end;
        else
            fprintf(fid,'\n');
        end;
        
        fprintf(fid,'  Gx Filename:\n');
        if strcmp(inputCmd{9,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{9,1},inputCmd{9,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  Gy Filename:\n');
        if strcmp(inputCmd{10,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{10,1},inputCmd{10,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  Gz Filename:\n');
        if strcmp(inputCmd{11,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{11,1},inputCmd{11,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;
        
        fprintf(fid,'\nOUTPUT FILENAMES:\n');

        fprintf(fid,'  KSpace Filename:\n');
        if strcmp(inputCmd{12,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{12,1},inputCmd{12,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  KMap Filename:\n');
        if strcmp(inputCmd{13,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{13,1},inputCmd{13,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  Noise Filename:\n');
        if strcmp(inputCmd{14,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{14,1},inputCmd{14,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;

        fprintf(fid,'  SAR Filename:\n');
        if strcmp(inputCmd{15,1},'') ~= 1
            fprintf(fid,['    ',slashCvrt([inputCmd{15,1},inputCmd{15,2}]),'\n']);
        else
            fprintf(fid,'\n');
        end;
        
        fprintf(fid,'\nGEOMETRY EDITOR SETUP:\n');
        
        fprintf(fid,'  Display:\n');
        tempStr = get(hDisplayMenu,'String');
        fprintf(fid,['    ',tempStr{get(hDisplayMenu,'Value')},'\n']);
        
        fprintf(fid,'  Scale:\n');
        tempStr = get(hScaleMenu,'String');
        fprintf(fid,['    ',tempStr{get(hScaleMenu,'Value')},'\n']);
        
        fprintf(fid,'  Slice Orientation:\n');
        tempStr = get(hOrientationMenu,'String');
        fprintf(fid,['    ',tempStr{get(hOrientationMenu,'Value')},'\n']);
        
        fprintf(fid,'  Slice Thickness:\n');
        fprintf(fid,['    ',get(hGeoSliceTH,'String'),'\n']);
        
        fprintf(fid,'  Slice Position:\n');
        fprintf(fid,['    ',get(hGeoSliderEdit,'String'),'\n']);
        
        fprintf(fid,'  Sample Min:\n');
        fprintf(fid,'    XMin:\n');
        fprintf(fid,['      ',get(hXMin,'String'),'\n']);
        fprintf(fid,'    YMin:\n');
        fprintf(fid,['      ',get(hYMin,'String'),'\n']);
        fprintf(fid,'    ZMin:\n');
        fprintf(fid,['      ',get(hZMin,'String'),'\n']);
        
        fprintf(fid,'  Sample Max:\n');
        fprintf(fid,'    XMax:\n');
        fprintf(fid,['      ',get(hXMax,'String'),'\n']);
        fprintf(fid,'    YMax:\n');
        fprintf(fid,['      ',get(hYMax,'String'),'\n']);
        fprintf(fid,'    ZMax:\n');
        fprintf(fid,['      ',get(hZMax,'String'),'\n']);
        
        fprintf(fid,'  Grad. IsoCtr:\n');
        fprintf(fid,'    XCtr:\n');
        fprintf(fid,['      ',get(hXCtr,'String'),'\n']);
        fprintf(fid,'    YCtr:\n');
        fprintf(fid,['      ',get(hYCtr,'String'),'\n']);
        fprintf(fid,'    ZCtr:\n');
        fprintf(fid,['      ',get(hZCtr,'String'),'\n']);
        
        fprintf(fid,'  FOV Offset:\n');
        fprintf(fid,'    XSet:\n');
        fprintf(fid,['      ',get(hXSet,'String'),'\n']);
        fprintf(fid,'    YSet:\n');
        fprintf(fid,['      ',get(hYSet,'String'),'\n']);
        fprintf(fid,'    ZSet:\n');
        fprintf(fid,['      ',get(hZSet,'String'),'\n']);
        
        fprintf(fid,'  Filter:\n');
        fprintf(fid,['      ',num2str(get(hFilter,'Value')),'\n']);
        
        fprintf(fid,'  Model Res.:\n');
        fprintf(fid,'    XWid:\n');
        fprintf(fid,['      ',get(hXWid,'String'),'\n']);
        fprintf(fid,'    YWid:\n');
        fprintf(fid,['      ',get(hYWid,'String'),'\n']);
        fprintf(fid,'    ZWid:\n');
        fprintf(fid,['      ',get(hZWid,'String'),'\n']);
                
        fprintf(fid,'\nSEQUENCE PARAMETER SETUP:\n');
        fprintf(fid,'  B0(T):\n');
        fprintf(fid,['    ',get(hB0Edit,'String'),'\n']);
        
        fprintf(fid,'  Sequence Type:\n');
        tempStr = get(hSeqType,'String');
        fprintf(fid,['    ',tempStr{get(hSeqType,'Value')},'\n']);
        
        fprintf(fid,'  RF Shape:\n');
        tempStr = get(hRF_Shape,'String');
        fprintf(fid,['    ',tempStr{get(hRF_Shape,'Value')},'\n']);
        
        fprintf(fid,'  RF Duration(ms):\n');
        fprintf(fid,['    ',get(hRF_Duration,'String'),'\n']);
        
        fprintf(fid,'  # Points in RF Pulse:\n');
        fprintf(fid,['    ',get(hRF_Num,'String'),'\n']);
        
        fprintf(fid,'  RF Flip Angle:\n');
        fprintf(fid,['    ',get(hRF_FA,'String'),'\n']);
        
        fprintf(fid,'  FOV(mm)\n');
        fprintf(fid,['    ',num2str(get(hFOV,'value')),'\n']);
        
        fprintf(fid,'  MatSize:\n');
        fprintf(fid,['    ',num2str(get(hMatSize,'value')),'\n']);
        
        fprintf(fid,'  ADC Freq(kHz):\n');
        fprintf(fid,['    ',get(hADC_Freq,'String'),'\n']);
        
        fprintf(fid,'  TI_Duration(ms):\n');
        fprintf(fid,['    ',get(hTI,'String'),'\n']);
        
        fprintf(fid,'  Gradient ON:\n');
        fprintf(fid,'    SS:\n');
        fprintf(fid,['      ',num2str(get(hSS,'Value')),'\n']);
        fprintf(fid,'    PE:\n');
        fprintf(fid,['      ',num2str(get(hPE,'Value')),'\n']);
        fprintf(fid,'    FE:\n');
        fprintf(fid,['      ',num2str(get(hFE,'Value')),'\n']);
        
        fprintf(fid,'  TE(ms):\n');
        fprintf(fid,['    ',get(hTE,'String'),'\n']);
        
        fprintf(fid,'  TR(ms):\n');
        fprintf(fid,['    ',get(hTR,'String'),'\n']);
        
        fprintf(fid,'  #Dummy TRs:\n');
        fprintf(fid,['    ',get(hDummyNum,'String'),'\n']);
        
        fprintf(fid,'  PE Direct:\n');
        tempStr = get(hPEDirectMenu,'String');
        fprintf(fid,['    ',tempStr{get(hPEDirectMenu,'Value')},'\n']);
        
        fprintf(fid,'\nPROGRAM INFO:\n');
        fprintf(fid,'  NumIsoMenu:\n');
        fprintf(fid,['    ',num2str(get(hNumIsoMenu,'Value')),'\n']);
        
        fprintf(fid,'  NumIsoX:\n');
        fprintf(fid,['    ',num2str(inputInfo.NumIso(1)),'\n']);
        fprintf(fid,'  NumIsoY:\n');
        fprintf(fid,['    ',num2str(inputInfo.NumIso(2)),'\n']);
        fprintf(fid,'  NumIsoZ:\n');
        fprintf(fid,['    ',num2str(inputInfo.NumIso(3)),'\n']);
        
        fprintf(fid,'  Thread #:\n');
        fprintf(fid,['    ',get(hThread,'String'),'\n']);
        
        fprintf(fid,'  Mode:\n');
        tempStr = get(hMode,'String');
        fprintf(fid,['    ',tempStr{get(hMode,'Value')},'\n']);
        
        fclose(fid);
        
        if strcmp(flag,'')
            msgbox(['Protocols saved to file ',get(hStudyName,'String'),'.prot']);
        end;
                
        % cd(tempAddr);
        clear tempAddr;
    end

    %% --- Executes on StudyReset button.
    function StudyReset_Callback(source,eventdata) %#ok<INUSD>
        temp = questdlg('All input will be lost. Are you sure to continue?','Reset','Yes','No','No');
        if strcmp(temp,'Yes')
            reset();
            tempStr = get(hStudyName,'String');
            if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                mkdir([addr,'\Protocols\',tempStr,'\']);
            end;
            inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[tempStr,'.ksig']; % KSpace FileName
            inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[tempStr,'.ktrj']; % KMap FileName
            inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[tempStr,'.nois']; % Noise FileName
            inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[tempStr,'.sar']; % SAR FileName
            set(hExpGeo,'Enable','on');
        end;
    end

    %% --- Executes on Geometry button.
    function ExpGeometry_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
              
        global geoData;
        global inputGeoData;
        global displayInfo;
        global inputInfo;
        
        if strcmp(flag,'')==1 % User Action
            
            cd(fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.smpl','Tissue Geometry File (*.smpl)';'*.*','All Fiiles (*.*)'},'OPEN: Geometry File');
            if index ~= 0
                reset();
                
                tempStr = get(hStudyName,'String');
                if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                    mkdir([addr,'\Protocols\',tempStr,'\']);
                end;
                inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[tempStr,'.ksig']; % KSpace FileName
                inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[tempStr,'.ktrj']; % KMap FileName
                inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[tempStr,'.nois']; % Noise FileName
                inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[tempStr,'.sar']; % SAR FileName
                
                set(hExpGeo,'Enable','on');
                
                inputCmd{1,1} = pathName;
                inputCmd{1,2} = fileName;
               
                fileAddr = pathName;
            end;
        else
            index = 1;
            
            reset();
            tempStr = get(hStudyName,'String');
            if exist([addr,'\Protocols\',tempStr,'\'],'file')~=7
                mkdir([addr,'\Protocols\',tempStr,'\']);
            end;
            inputCmd{12,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{12,2}=[tempStr,'.ksig']; % KSpace FileName
            inputCmd{13,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{13,2}=[tempStr,'.ktrj']; % KMap FileName
            inputCmd{14,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{14,2}=[tempStr,'.nois']; % Noise FileName
            inputCmd{15,1}=[addr,'\Protocols\',tempStr,'\']; inputCmd{15,2}=[tempStr,'.sar']; % SAR FileName
            
            set(hExpGeo,'Enable','on');
            
            [pathName, fileName] = addrCvrt(flag);
            inputCmd{1,1} = pathName;
            inputCmd{1,2} = fileName;
        end;

        if index ~= 0 % If *.smpl file is selected
            file=[pathName fileName];
            inputInfo.filename=file;
            set(hExpGeoEdit,'String',filenameCvrt(inputCmd{1,2}));
            set(hExpGeoEdit,'FontAngle','normal');

            % Read in data.
            fid = fopen([inputCmd{1,1},inputCmd{1,2}]);

            inputInfo.totNumVox = fread(fid,1,'float32');

            inputInfo.minX = round(fread(fid,1,'float32'));
            set(hXMin,'String',round(inputInfo.minX),'Enable','on');

            inputInfo.maxX = round(fread(fid,1,'float32'));                
            set(hXMax,'String',round(inputInfo.maxX),'Enable','on');

            inputInfo.minY = round(fread(fid,1,'float32'));
            set(hYMin,'String',round(inputInfo.minY),'Enable','on');

            inputInfo.maxY = round(fread(fid,1,'float32'));
            set(hYMax,'String',round(inputInfo.maxY),'Enable','on');

            inputInfo.minZ = round(fread(fid,1,'float32'));
            set(hZMin,'String',round(inputInfo.minZ),'Enable','on');

            inputInfo.maxZ = round(fread(fid,1,'float32'));
            set(hZMax,'String',round(inputInfo.maxZ),'Enable','on');

            inputInfo.ctrX = round(fread(fid,1,'float32'));
            set(hXCtr,'String',round(inputInfo.ctrX),'Enable','on');

            inputInfo.ctrY = round(fread(fid,1,'float32'));
            set(hYCtr,'String',round(inputInfo.ctrY),'Enable','on');

            inputInfo.ctrZ = round(fread(fid,1,'float32'));
            set(hZCtr,'String',round(inputInfo.ctrZ),'Enable','on');
            
            inputInfo.setX = 0;
            set(hXSet,'String',inputInfo.setX,'Enable','on');
            inputInfo.setY = 0;
            set(hYSet,'String',inputInfo.setY,'Enable','on');
            inputInfo.setZ = 0;
            set(hZSet,'String',inputInfo.setZ,'Enable','on');

            inputInfo.widX = fread(fid,1,'float32');
            set(hXWid,'String',inputInfo.widX,'Enable','inactive');

            inputInfo.widY = fread(fid,1,'float32');
            set(hYWid,'String',inputInfo.widY,'Enable','inactive');

            inputInfo.widZ = fread(fid,1,'float32');
            set(hZWid,'String',inputInfo.widZ,'Enable','inactive');
            
            inputInfo.FOV_flag=0;

            inputGeoData = fread(fid,[4, Inf],'float32');
            fclose(fid);

            % Display images.
            displayInfo.Scale = get(hScaleMenu,'Value');
            
            displayInfo.minX = inputInfo.minX; % Fixed value, not to be changed by user input
            displayInfo.maxX = inputInfo.maxX;
            displayInfo.minY = inputInfo.minY;
            displayInfo.maxY = inputInfo.maxY;
            displayInfo.minZ = inputInfo.minZ;
            displayInfo.maxZ = inputInfo.maxZ;
            
            displayInfo.geoLengthX = displayInfo.maxX-displayInfo.minX+1;
            displayInfo.geoLengthY = displayInfo.maxY-displayInfo.minY+1;
            displayInfo.geoLengthZ = displayInfo.maxZ-displayInfo.minZ+1;

            displayInfo.geoDeltaX = (displayInfo.geoLengthX+1)/2-(displayInfo.maxX+displayInfo.minX)/2;
            displayInfo.geoDeltaY = (displayInfo.geoLengthY+1)/2-(displayInfo.maxY+displayInfo.minY)/2;
            displayInfo.geoDeltaZ = (displayInfo.geoLengthZ+1)/2-(displayInfo.maxZ+displayInfo.minZ)/2;

            geoData = zeros(displayInfo.geoLengthX, displayInfo.geoLengthY, displayInfo.geoLengthZ); % ID
            for n=1:length(inputGeoData(4,:))
                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX, inputGeoData(2,n)+displayInfo.geoDeltaY, inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputGeoData(4,n);
            end;

            displayInfo.imageLengthXY = max(displayInfo.geoLengthX,displayInfo.geoLengthY)*1.1;
            displayInfo.padAxial_X = ceil((displayInfo.imageLengthXY - displayInfo.geoLengthX)/2);
            displayInfo.padAxial_Y = ceil((displayInfo.imageLengthXY - displayInfo.geoLengthY)/2);

            displayInfo.imageLengthYZ = max(displayInfo.geoLengthY,displayInfo.geoLengthZ)*1.1;
            displayInfo.padSagittal_Y = ceil((displayInfo.imageLengthYZ - displayInfo.geoLengthY)/2);
            displayInfo.padSagittal_Z = ceil((displayInfo.imageLengthYZ - displayInfo.geoLengthZ)/2);

            displayInfo.imageLengthXZ = max(displayInfo.geoLengthX,displayInfo.geoLengthZ)*1.1;
            displayInfo.padCoronal_X = ceil((displayInfo.imageLengthXZ - displayInfo.geoLengthX)/2);
            displayInfo.padCoronal_Z = ceil((displayInfo.imageLengthXZ - displayInfo.geoLengthZ)/2);

%             inputInfo.currentX = round((inputInfo.maxX+inputInfo.minX)/2);
%             inputInfo.currentY = round((inputInfo.maxY+inputInfo.minY)/2);
%             inputInfo.currentZ = round((inputInfo.maxZ+inputInfo.minZ)/2);
            inputInfo.currentX = inputInfo.ctrX;
            inputInfo.currentY = inputInfo.ctrY;
            inputInfo.currentZ = inputInfo.ctrZ;

            inputInfo.NumIso(1) = 1; % X
            inputInfo.NumIso(2) = 1; % Y
            inputInfo.NumIso(3) = 1; % Z
            
            set(hGeoSliceTH,'Enable','on');
            switch get(hOrientationMenu,'Value')
                case 1
                    set(hGeoSliceTH,'String',num2str(inputInfo.widZ));
                    inputInfo.sliceTH = inputInfo.widZ;
                case 2
                    set(hGeoSliceTH,'String',num2str(inputInfo.widY));
                    inputInfo.sliceTH = inputInfo.widX;
                case 3
                    set(hGeoSliceTH,'String',num2str(inputInfo.widX));
                    inputInfo.sliceTH = inputInfo.widY;
            end;
            inputInfo.FOV = str2double(get(hFOV,'String'));

            if strcmp(flag,'')==1
                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
            end;

            set(hExpTiss,'Enable','on');
            set(hOrientationMenu,'Enable','on');
            set(hSave,'Enable','on');
            set(hReset,'Enable','on');
            set(hGeoSlider,'Enable','on');
            set(hGeoSliderEdit,'Enable','on');
            set(hScaleMenu,'Enable','on');

            % % % Display GeoSlider.
            switch get(hOrientationMenu,'Value')
                case 1
                    set(hGeoSlider,'Max',displayInfo.maxZ,...
                        'Min',displayInfo.minZ,...
                        'Value',inputInfo.currentZ,...
                        'SliderStep',[1/(displayInfo.maxZ-displayInfo.minZ + 1),1/10]); % need + 1 for cases when Max = Min % Nov 11, 2012
                    set(hGeoSliderEdit,'String',num2str(inputInfo.currentZ));
                case 2
                    set(hGeoSlider,'Max',displayInfo.maxX,...
                        'Min',displayInfo.minX,...
                        'Value',inputInfo.currentX,...
                        'SliderStep',[1/(displayInfo.maxX-displayInfo.minX + 1),1/10]);
                    set(hGeoSliderEdit,'String',num2str(inputInfo.currentX));
                case 3
                    set(hGeoSlider,'Max',displayInfo.maxY,...
                        'Min',displayInfo.minY,...
                        'Value',inputInfo.currentY,...
                        'SliderStep',[1/(displayInfo.maxY-displayInfo.minY + 1),1/10]);
                    set(hGeoSliderEdit,'String',num2str(inputInfo.currentY));
            end;
        end;
    end

    %% --- Executes on Tissue button.
    function ExpTissue_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.prop','Tissue Property File (*.prop)';'*.*','All Fiiles (*.*)'},'OPEN: Tissue Property File');
            if index ~= 0
                inputCmd{2,1} = pathName;
                inputCmd{2,2} = fileName;
                
                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0   % If *.prop file is selected
            set(hExpTissEdit,'String',filenameCvrt(inputCmd{2,2}));
            set(hExpTissEdit,'FontAngle','normal');

            set(hSave,'Enable','on');
            
            set(hDisplayMenu,'Enable','on');
            
            set(hExpSeq,'Enable','on');
            set(hSeqType,'Enable','on');
            set(hRF_Shape,'Enable','on');
            set(hRF_Duration,'Enable','on');
            set(hRF_Num,'Enable','on');
            set(hRF_FA,'Enable','on');
            set(hDummyNum,'Enable','on');
            set(hFOV,'Enable','on');
            set(hFOV_Pop,'Enable','on');
            set(hFilter,'Enable','on');
            set(hMatSize,'Enable','on');
            set(hMatSize_Pop,'Enable','on');
                    
            set(hADC_Freq,'Enable','on');
            
            set(hTx,'Enable','on');
            set(hRx,'Enable','on');
            
            set(hTI,'Enable','on');
            set(hTE,'Enable','on');
            set(hTR,'Enable','on');
            set(hSS,'Enable','on');
            set(hPE,'Enable','on');
            set(hFE,'Enable','on');
            set(hPEDirectMenu,'Enable','on');
            set(hSeqGen,'Enable','on');
            
            set(hNumIsoMenu,'Enable','on');
            
            % % % Get minTE, minTR
            updateSeq();
            
        end;
    end

    %% --- Executes on DB0 button.
    function ExpDB0_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        global button inputInfo
        if strcmp(flag,'')==1

            cd(fileAddr);
            % button = questdlg('Please select an option.','Delta B0 File','Load File','Create File','Cancel','Load File');
            button = questdlg('Please select an option.','Delta B0 File','Load File','Cancel','Load File');
            switch button
                case 'Create File'
                    run B0Solver
                    uiwait(B0Solver)
                    fileName=inputInfo.savefilename;
                    pathName=inputInfo.pathname;
%                     if fileName~=0 && pathName~=0
                        inputCmd{3,1} = pathName;
                        inputCmd{3,2} = savefileName;
                        index=1;
                        fileAddr = pathName;
%                     end;
%                     else
%                         index = 1;
%                     end;

                    if index ~= 0
                        set(hExpDB0Edit,'String',filenameCvrt(inputCmd{3,2}));
                        set(hExpDB0Edit,'FontAngle','normal');
                    end;
                case 'Load File'
                    [fileName,pathName,index]=uigetfile({'*.db0','Delta B0 File (*.db0)';'*.*','All Fiiles (*.*)'},'OPEN: Delta B0 File');
                    if index ~= 0
                        inputCmd{3,1} = pathName;
                        inputCmd{3,2} = fileName;

                        fileAddr = pathName;
                        %                     end;
                    else
                        index = 1;
                    end;

                    if index ~= 0
                        set(hExpDB0Edit,'String',filenameCvrt(inputCmd{3,2}));
                        set(hExpDB0Edit,'FontAngle','normal');
                        
                        set(hExpClearDB0,'Enable','on');
                    end;
                case 'Cancel'
                    if isempty(filenameCvrt(inputCmd{3,2}))
                        set(hExpDB0Edit,'String','0 or dB0 Filename');
                        set(hExpDB0Edit,'FontAngle','italic');
                    end;
                    % return
            end
        end
    end

    %% --- Executes on Clear dB0 button.
    function ExpClearDB0_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        inputCmd{3,1}=''; inputCmd{3,2}=''; % dB0 FileName
        
        % % % Display the dB0Edit.
        set(hExpDB0Edit,'String','0 or dB0 Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpClearDB0,'Enable','off');
    end

    %% --- Executes on Seq button.
    function ExpSeq_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        
        global geoData;
        global displayInfo;
        global inputInfo;
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.seqn','Sequence File (*.seqn)';'*.*','All Fiiles (*.*)'},'OPEN: Sequence File');
            if index ~= 0
                inputCmd{4,1} = pathName;
                inputCmd{4,2} = fileName;

                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            set(hExpSeqEdit,'String',filenameCvrt(inputCmd{4,2}));
            set(hExpSeqEdit,'FontAngle','normal');

            % % % Display OrientationMenu.
            set(hOrientationMenu,'Enable','off');

            % % % Display GeoSliderTH.
            set(hGeoSliceTH,'String','0','Enable','off');

            % % % Display GeoSlider.
            set(hGeoSlider,'Max',100,'Min',0,'Value',0,...
                'SliderStep',[1/100,10/100],'Enable','off');

            % % % Display GeoSliderEdit.
            set(hGeoSliderEdit,'String','0','Enable','off');

            % % % Display the B0Edit.
            set(hB0Edit,'string','3','Enable','on');

            % % % Display the SequenceType menu.
            set(hSeqType,'Value',1,'Enable','off');

            % % % Display the RF_Shape menu.
            set(hRF_Shape,'Value',1,'Enable','off');

            % % % Display the RF_Duration edit.
            set(hRF_Duration,'String','2.6','Enable','off');

            % % % Display the RF# edit.
            set(hRF_Num,'String','128','Enable','off');
            
            % % % Display the RF_FA edit.
            set(hRF_FA,'String','90','Enable','off');

            % % % Display the FOV edit.
            set(hFOV,'String','300','Enable','off');

            % % % Display the MatSize edit.
            set(hMatSize,'String','128','Enable','off');

            % % % Display the ADC_Freq edit.
            set(hADC_Freq,'String','50','Enable','off');

            % % % Display the #T edit.
            fid=fopen([inputCmd{4,1},inputCmd{4,2}]);
            fseek(fid, 4*1, 'bof');
            Tx.Num=fread(fid,1,'float32');
            fclose(fid);
            
            set(hTx,'String',num2str(Tx.Num),'Enable','off');            
            Tx.MagMat = ones(Tx.Num,1);
            Tx.PhsMat = zeros(Tx.Num,1);
            
            % % % Display the #Rx edit.
            fid=fopen([inputCmd{4,1},inputCmd{4,2}]);
            fseek(fid, 4*2, 'bof');
            Rx.Num=fread(fid,1,'float32');
            fclose(fid);
            
            set(hRx,'String',num2str(Rx.Num),'Enable','off');
                        
            % % % Display the SS checkbox.
            set(hSS,'String','SS','Value',1,'Enable','off');

            % % % Display the PE checkbox.
            set(hPE,'String','PE','Value',1,'Enable','off');

            % % % Display the FE checkbox.
            set(hFE,'String','FE','Value',1,'Enable','off');

            % % % Display the TE edit.
            set(hTE,'String','TE','String','10','Enable','off');

            % % % Display the TR edit.
            set(hTR,'String','TR','String','500','Enable','off');

            % % % Display the DummyNum edit.
            set(hDummyNum,'String','0','Enable','off');

            % % % Display the PEDirect edit.
            set(hPEDirectMenu,'String',{'P--A';'L--R'},'Value',1,...
               'Enable','off'); % to be edited

            set(hSeqGen,'Enable','off');

            set(hSeqPlot,'Enable','off');

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
            
            set(hMode,'Enable','on');
            tempMode = get(hMode,'Value');
            switch tempMode
                case {1,2}
                    set(hB0Edit,'Enable','on');
                    set(hExpDB0,'Enable','on');

                    set(hExpGx,'Enable','on');
                    set(hExpGy,'Enable','on');
                    set(hExpGz,'Enable','on');

                    set(hExpB1p,'Enable','on');
                    set(hExpB1m,'Enable','on');
                    set(hExpE1p,'Enable','off');

                    set(hExpE1m,'Enable','off');

                    set(hNumIso,'Enable','on');
                    set(hThread,'Enable','on');

                case 3
                    set(hB0Edit,'Enable','off');
                    set(hExpDB0,'Enable','off');

                    set(hExpGx,'Enable','off');
                    set(hExpGy,'Enable','off');
                    set(hExpGz,'Enable','off');

                    set(hExpB1p,'Enable','on');
                    set(hExpB1m,'Enable','on');
                    set(hExpE1p,'Enable','on');

                    set(hExpE1m,'Enable','off');

                    set(hNumIso,'Enable','off');
                    set(hThread,'Enable','on');

                case 4
                    set(hB0Edit,'Enable','off');
                    set(hExpDB0,'Enable','off');

                    set(hExpGx,'Enable','off');
                    set(hExpGy,'Enable','off');
                    set(hExpGz,'Enable','off');

                    set(hExpB1p,'Enable','off');
                    set(hExpE1p,'Enable','off');

                    set(hExpE1m,'Enable','on');

                    set(hNumIso,'Enable','off');
                    set(hThread,'Enable','off');
            end;
            
            if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
                set(hRun,'Enable','on');
                set(hThread,'Enable','on');
            end;
        end;
    end

    %% --- Executes on B1p button.
    function ExpB1p_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>

        if strcmp(flag,'')==1
            RF.FA = str2double(get(hRF_FA,'String')); %Degrees
            [fileName,pathName,index]=B1pTxFileNameGUI(Tx.Num,inputCmd{5,1},inputCmd{5,2},Tx.MagMat,Tx.PhsMat,RF.FA);
            if index ~= 0
                if (iscell(fileName) == 1 && Tx.Num == length(fileName))
                    inputCmd{5,1} = pathName;
                    inputCmd{5,2} = fileName;
                end;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            tempStr = '';
            for n=1:length(inputCmd{5,2})
                tempStr = [tempStr,filenameCvrt(inputCmd{5,2}{n}),'; ']; %#ok<AGROW>
            end;
            set(hExpB1pEdit,'String',tempStr);
            set(hExpB1pEdit,'FontAngle','normal');
        end;
    end

    %% --- Executes on Clear B1p button.
    function ExpClearB1p_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        inputCmd{5,1}=''; inputCmd{5,2}=''; % B1+ FileName
        
        % % % Display the B1pEdit.
        set(hExpB1pEdit,'string','Homogeneous or B1+ Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        
        set(hExpClearB1p,'Enable','off');
    end

    %% --- Executes on E1p button.
    function ExpE1p_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        
        if strcmp(flag,'')==1
            
            RF.FA = str2double(get(hRF_FA,'String')); %Degrees
            [fileName,pathName,index]=E1pTxFileNameGUI(Tx.Num,inputCmd{6,1},inputCmd{6,2},Tx.MagMat,Tx.PhsMat,RF.FA);
            if index ~= 0
                if (iscell(fileName) == 1 && Tx.Num == length(fileName))
                    inputCmd{6,1} = pathName;
                    inputCmd{6,2} = fileName;
                end;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            tempStr = '';
            for n=1:length(inputCmd{6,2})
                tempStr = [tempStr,filenameCvrt(inputCmd{6,2}{n}),'; ']; %#ok<AGROW>
            end;
            set(hExpE1pEdit,'String',tempStr);
            set(hExpE1pEdit,'FontAngle','normal');
        end;
    end

    %% --- Executes on Clear E1p button.
    function ExpClearE1p_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        inputCmd{6,1}=''; inputCmd{6,2}=''; % E1+ FileName
        
        % % % Display the E1pEdit.
        set(hExpB1pEdit,'string','Homogeneous or E1+ Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        
        set(hExpClearE1p,'Enable','off');
    end

    %% --- Executes on B1m button.
    function ExpB1m_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.bfld','B1 Minus File (*.bfld)';'*.*','All Fiiles (*.*)'},'OPEN: B1 Minus File','MultiSelect','on');
            if index ~= 0                
                if (iscell(fileName) ~= 1 && Rx.Num == 1)
                    inputCmd{7,1}{1} = pathName;
                    inputCmd{7,2}{1} = fileName;
                elseif (iscell(fileName) == 1 && Rx.Num == length(fileName))
                    inputCmd{7,1} = fileName;
                    for n=1:length(inputCmd{7,1})
                        inputCmd{7,1}{n} = pathName;
                    end;
                    inputCmd{7,2} = fileName;
                else
                    tempStr = '# Rx does not match the sequence file!';
                    errordlg(tempStr,'modal');
                    index = 0;
                end;
                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            if iscell(inputCmd{7,2}) ~= 1
                set(hExpB1mEdit,'String',[filenameCvrt(inputCmd{7,2}),'; ']);
            else
                tempStr = '';
                for n=1:length(inputCmd{7,2})
                    tempStr = [tempStr,filenameCvrt(inputCmd{7,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpB1mEdit,'String',tempStr);
            end;
            set(hExpB1mEdit,'FontAngle','normal');
        end;
    end


    %% --- Executes on Clear B1m button.
    function ExpClearB1m_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        inputCmd{7,1}=''; inputCmd{7,2}=''; % B1- FileName
        
        % % % Display the B1mEdit.
        set(hExpB1mEdit,'string','Homogeneous or B1- Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        
        set(hExpClearB1m,'Enable','off');
    end

    %% --- Executes on E1m button.
    function ExpE1m_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.efld','E1 Minus File (*.efld)';'*.*','All Fiiles (*.*)'},'OPEN: E1 Minus File','MultiSelect','on');
            if index ~= 0
                if (iscell(fileName) ~= 1 && Rx.Num == 1)
                    inputCmd{8,1}{1} = pathName;
                    inputCmd{8,2}{1} = fileName;
                elseif (iscell(fileName) == 1 && Rx.Num == length(fileName))
                    inputCmd{8,1} = fileName;
                    for n=1:length(inputCmd{8,1})
                        inputCmd{8,1}{n} = pathName;
                    end;
                    inputCmd{8,2} = fileName;
                else
                    tempStr = '# Rx does not match the sequence file!';
                    errordlg(tempStr,'modal');
                    index = 0;
                end;
                
                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            if iscell(inputCmd{8,2}) ~= 1
                set(hExpE1mEdit,'String',[filenameCvrt(inputCmd{8,2}),'; ']);
            else
                tempStr = '';
                for n=1:length(inputCmd{8,2})
                    tempStr = [tempStr,filenameCvrt(inputCmd{8,2}{n}),'; ']; %#ok<AGROW>
                end;
                set(hExpE1mEdit,'String',tempStr);
            end;
            set(hExpE1mEdit,'FontAngle','normal');
        end;
    end

    %% --- Executes on Clear E1m button.
    function ExpClearE1m_Callback(source,eventdata,flag) %#ok<INUSL,INUSL>
        inputCmd{8,1}=''; inputCmd{8,2}=''; % E1- FileName
        
        % % % Display the E1mEdit.
        set(hExpB1mEdit,'string','Homogeneous or E1- Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        
        set(hExpClearE1m,'Enable','off');
    end

%% --- Executes on Gx button.
    function ExpGx_Callback(source,eventdata,flag) %#ok<INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.grad','Grad Distribution File (*.grad)';'*.*','All Fiiles (*.*)'},'OPEN: Grad Distribution File');
            if index ~= 0
                inputCmd{9,1} = pathName;
                inputCmd{9,2} = fileName;
                
                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            set(hExpGxEdit,'String',filenameCvrt(inputCmd{9,2}));
        end;

        set(hExpGxEdit,'FontAngle','normal');
    end

    %% --- Executes on Gy button.
    function ExpGy_Callback(source,eventdata,flag) %#ok<INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.grad','Grad Distribution File (*.grad)';'*.*','All Fiiles (*.*)'},'OPEN: Grad Distribution File');            
            if index ~= 0
                inputCmd{10,1} = pathName;
                inputCmd{10,2} = fileName;
               
                fileAddr = pathName;
            end;            
        else
            index = 1;
        end;
        
        if index ~= 0
            set(hExpGyEdit,'String',filenameCvrt(inputCmd{10,2}));
        end;
        
        set(hExpGyEdit,'FontAngle','normal');
    end

    %% --- Executes on Gz button.
    function ExpGz_Callback(source,eventdata,flag) %#ok<INUSL>
        
        if strcmp(flag,'')==1
            
            cd (fileAddr);
            
            [fileName,pathName,index]=uigetfile({'*.grad','Grad Distribution File (*.grad)';'*.*','All Fiiles (*.*)'},'OPEN: Grad Distribution File');
            if index ~= 0
                inputCmd{11,1} = pathName;
                inputCmd{11,2} = fileName;
                
                fileAddr = pathName;
            end;
        else
            index = 1;
        end;
        
        if index ~= 0
            set(hExpGzEdit,'String',filenameCvrt(inputCmd{11,2}));
        end;
        set(hExpGzEdit,'FontAngle','normal');
    end

    %% --- Executes on DisplayMenu.
    function DisplayMenu_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo inputGeoData;
        
        if strcmp(flag,'')==1
            
            fid=fopen([inputCmd{2,1}, inputCmd{2,2}]);
            textscan(fid,'%s',1,'delimiter','\n');
            inputTissData = textscan(fid,'%f %f %f %f %f %f %f %s','delimiter','\n');
            fclose(fid);
            
            temp = get(hDisplayMenu,'Value');
            for n=1:length(inputGeoData(4,:))
                if inputInfo.currentX == inputGeoData(1,n) || inputInfo.currentY == inputGeoData(2,n) || inputInfo.currentZ == inputGeoData(3,n)
                    tempResult=find(inputTissData{1}==inputGeoData(4,n));
                    if isempty(tempResult)==1
                        tempStr = ['Tissue Type ',num2str(inputGeoData(4,n)),' not Found in File!'];
                        errordlg(tempStr,'modal');
                        return;
                    else
                        switch temp
                            case 1
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{1}(tempResult);
                            case 2
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{2}(tempResult);
                            case 3
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{3}(tempResult);
                            case 4
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{4}(tempResult);
                            case 5
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{5}(tempResult);
                            case 6
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{6}(tempResult);
                            case 7
                                geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{7}(tempResult);
                        end;
                    end;
                end;
            end;
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            tempDisplayMenu = get(hDisplayMenu,'String');
            tempLoc=find(strcmp(tempDisplayMenu,flag));
            set(hDisplayMenu,'Value',tempLoc);
        end;
        clear tempDisplayMenu;
    end

    %% --- Executes on ScaleMenu.
    function ScaleMenu_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            displayInfo.Scale = get(hScaleMenu,'Value');
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hScaleMenu,'Value',flag);
        end;
        clear tempDisplayMenu;
    end
        
    %% --- Executes on OrientationMenu.
    function OrientationMenu_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            % % % Update GeoSlider.
            switch get(hOrientationMenu,'Value')
                case 1
                    set(hGeoSlider,'Max',displayInfo.maxZ,...
                        'Min',displayInfo.minZ,...
                        'Value',inputInfo.currentZ,...
                        'SliderStep',[1/(displayInfo.maxZ-displayInfo.minZ),1/10]);
                    set(hPEDirectMenu,'String',{'P--A';'L--R'});

                case 2
                    set(hGeoSlider,'Max',displayInfo.maxX,...
                        'Min',displayInfo.minX,...
                        'Value',inputInfo.currentX,...
                        'SliderStep',[1/(displayInfo.maxX-displayInfo.minX),1/10]);
                    set(hPEDirectMenu,'String',{'P--A';'F--H'});

                case 3
                    set(hGeoSlider,'Max',displayInfo.maxY,...
                        'Min',displayInfo.minY,...
                        'Value',inputInfo.currentY,...
                        'SliderStep',[1/(displayInfo.maxY-displayInfo.minY),1/10]);
                    set(hPEDirectMenu,'String',{'L--R';'F--H'});
            end;
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            switch flag
                case 'Axial'
                    set(hGeoSlider,'Max',displayInfo.maxZ,...
                        'Min',displayInfo.minZ,...
                        'Value',inputInfo.currentZ,...
                        'SliderStep',[1/(displayInfo.maxZ-displayInfo.minZ),1/10]);
                    set(hOrientationMenu,'Value',1);
                    set(hPEDirectMenu,'String',{'P--A';'L--R'});

                case 'Sagittal'
                    set(hGeoSlider,'Max',displayInfo.maxX,...
                        'Min',displayInfo.minX,...
                        'Value',inputInfo.currentX,...
                        'SliderStep',[1/(displayInfo.maxX-displayInfo.minX),1/10]);
                    set(hOrientationMenu,'Value',2);
                    set(hPEDirectMenu,'String',{'P--A';'F--H'});

                case 'Coronal'
                    set(hGeoSlider,'Max',displayInfo.maxY,...
                        'Min',displayInfo.minY,...
                        'Value',inputInfo.currentY,...
                        'SliderStep',[1/(displayInfo.maxY-displayInfo.minY),1/10]);
                    set(hOrientationMenu,'Value',3);
                    set(hPEDirectMenu,'String',{'L--R';'F--H'});
            end;
        end;
        
        set(hGeoSliderEdit,'String',get(hGeoSlider,'Value'));
    end

    %% --- Executes on GeoSliceTHEdit.
    function GeoSliceTHEdit_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1      
            temp = str2double(get(hGeoSliceTH,'String'));
            if ~isnan(temp)        
                switch get(hOrientationMenu,'Value')
                    case 1
                        temp = inputInfo.widX;
                        temp = round(str2double(get(hGeoSliceTH, 'String'))/temp)*temp;
                        if temp == 0
                            temp = inputInfo.widX;
                        end;
                    case 2
                        temp = inputInfo.widZ;
                        temp = round(str2double(get(hGeoSliceTH, 'String'))/temp)*temp;
                        if temp == 0
                            temp = inputInfo.widZ;
                        end;
                    case 3
                        temp = inputInfo.widY;
                        temp = round(str2double(get(hGeoSliceTH, 'String'))/temp)*temp;
                        if temp == 0
                            temp = inputInfo.widY;
                        end;
                end;
                set(hGeoSliceTH,'String',num2str(abs(temp)));
            else
                set(hGeoSliceTH,'String','2');
                temp = 2;
            end;                        

            slice.TH = temp;
            inputInfo.sliceTH = temp;
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            switch get(hOrientationMenu,'Value')
                case 1
                    temp = inputInfo.widX;
                    temp = round(str2double(flag)/temp)*temp;
                case 2
                    temp = inputInfo.widZ;
                    temp = round(str2double(flag)/temp)*temp;
                case 3
                    temp = inputInfo.widY;
                    temp = round(str2double(flag)/temp)*temp;
            end;   
            set(hGeoSliceTH,'String',num2str(temp));
            slice.TH = temp;
            inputInfo.sliceTH = temp;
        end;
    end

    %% --- Executes on GeoSlider.
    function GeoSlider_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo inputGeoData;

        if strcmp(flag,'')==1
            temp = round(get(hGeoSlider,'Value'));
            set(hGeoSlider,'Value',temp);
            set(hGeoSliderEdit,'String',num2str(get(hGeoSlider,'Value')));
            switch get(hOrientationMenu,'Value')
                case 1
                    inputInfo.currentZ = temp;
                case 2
                    inputInfo.currentX = temp;
                case 3
                    inputInfo.currentY = temp;
            end;
                    
            temp = get(hDisplayMenu,'Value');
            if temp ~= 1
                fid=fopen([inputCmd{2,1}, inputCmd{2,2}]);
                textscan(fid,'%s',1,'delimiter','\n');
                inputTissData = textscan(fid,'%f %f %f %f %f %f %f %s','delimiter','\n');
                fclose(fid);
            end;
            
            for n=1:length(inputGeoData(4,:))
                if inputInfo.currentX == inputGeoData(1,n) || inputInfo.currentY == inputGeoData(2,n) || inputInfo.currentZ == inputGeoData(3,n)
                    if temp == 1
                        geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ) = inputGeoData(4,n);
                    else
                        tempResult=find(inputTissData{1}==inputGeoData(4,n));
                        if isempty(tempResult)==1
                            tempStr = ['Tissue Type ',num2str(inputGeoData(4,n)),' not Found in File!'];
                            errordlg(tempStr,'modal');
                            return;
                        else
                            switch temp
                                case 2
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{2}(tempResult);
                                case 3
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{3}(tempResult);
                                case 4
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{4}(tempResult);
                                case 5
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{5}(tempResult);
                                case 6
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{6}(tempResult);
                                case 7
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{7}(tempResult);
                            end;
                        end;
                    end;
                end;
            end;
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hGeoSlider,'Value',str2double(flag));
            set(hGeoSliderEdit,'String',flag);
            switch get(hOrientationMenu,'Value')
                case 1
                    inputInfo.currentZ = str2double(flag);
                case 2
                    inputInfo.currentX = str2double(flag);
                case 3
                    inputInfo.currentY = str2double(flag);
            end;            
        end;
    end

    %% --- Executes on GeoSliderEdit.
    function GeoSliderEdit_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo inputGeoData;

        if strcmp(flag,'')==1
            temp = round(str2double(get(hGeoSliderEdit,'String')));

            switch get(hOrientationMenu,'Value')
                case 1
%                     if temp > inputInfo.maxZ
%                         temp = inputInfo.maxZ;
%                     end;
%                     if temp < inputInfo.minZ
%                         temp = inputInfo.minZ;
%                     end;
                    inputInfo.currentZ = temp;
                case 2
%                     if temp > inputInfo.maxX
%                         temp = inputInfo.maxX;
%                     end;
%                     if temp < inputInfo.minX
%                         temp = inputInfo.minX;
%                     end;
                    inputInfo.currentX = temp;
                case 3
%                     if temp > inputInfo.maxY
%                         temp = inputInfo.maxY;
%                     end;
%                     if temp < inputInfo.minY
%                         temp = inputInfo.minY;
%                     end;
                    inputInfo.currentY = temp;
            end;

            set(hGeoSliderEdit,'String',num2str(temp));
            set(hGeoSlider,'Value',temp);
            
            temp = get(hDisplayMenu,'Value');
            if temp ~= 1
                fid=fopen([inputCmd{2,1}, inputCmd{2,2}]);
                textscan(fid,'%s',1,'delimiter','\n');
                inputTissData = textscan(fid,'%f %f %f %f %f %f %f %s','delimiter','\n');
                fclose(fid);
            end;
            
            for n=1:length(inputGeoData(4,:))
                if inputInfo.currentX == inputGeoData(1,n) || inputInfo.currentY == inputGeoData(2,n) || inputInfo.currentZ == inputGeoData(3,n)
                    if temp == 1
                        geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ) = inputGeoData(4,n);
                    else
                        tempResult=find(inputTissData{1}==inputGeoData(4,n));
                        if isempty(tempResult)==1
                            tempStr = ['Tissue Type ',num2str(inputGeoData(4,n)),' not Found in File!'];
                            errordlg(tempStr,'modal');
                            return;
                        else
                            switch temp
                                case 2
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{2}(tempResult);
                                case 3
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{3}(tempResult);
                                case 4
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{4}(tempResult);
                                case 5
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{5}(tempResult);
                                case 6
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{6}(tempResult);
                                case 7
                                    geoData(inputGeoData(1,n)+displayInfo.geoDeltaX,inputGeoData(2,n)+displayInfo.geoDeltaY,inputGeoData(3,n)+displayInfo.geoDeltaZ)=inputTissData{7}(tempResult);
                            end;
                        end;
                    end;
                end;
            end;
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hGeoSlider,'Value',str2double(flag));
            set(hGeoSliderEdit,'String',flag);
            switch get(hOrientationMenu,'Value')
                case 1
                    inputInfo.currentZ = str2double(flag);
                case 2
                    inputInfo.currentX = str2double(flag);
                case 3
                    inputInfo.currentY = str2double(flag);
            end;            
        end;
    end

    %% --- Executes on xMin_edit.
    function XMin_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hXMin, 'String')));
                      
            if temp <= str2double(get(hXMax, 'String'))
                set(hXMin,'String',num2str(temp));
                inputInfo.minX = str2double(get(hXMin, 'String'));
            elseif temp > str2double(get(hXMax, 'String'))
                set(hXMin,'String',num2str(str2double(get(hXMax, 'String'))));
                inputInfo.minX = str2double(get(hXMin, 'String'));
            else
                set(hXMin, 'String',num2str(inputInfo.minX));
            end;
                       
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hXMin,'String',flag);
            inputInfo.minX = round(str2double(get(hXMin, 'String')));
        end;
    end

    %% --- Executes on xMax_edit.
    function XMax_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hXMax, 'String')));
            
            if temp >= str2double(get(hXMin, 'String'))
                set(hXMax,'String',num2str(temp));
                inputInfo.maxX = str2double(get(hXMax, 'String'));
            elseif temp < str2double(get(hXMin, 'String'))
                set(hXMax,'String',num2str(str2double(get(hXMin, 'String'))));
                inputInfo.maxX = str2double(get(hXMax, 'String'));
            else
                set(hXMax, 'String',num2str(inputInfo.maxX));
            end;

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hXMax,'String',flag);
            inputInfo.maxX = round(str2double(get(hXMax, 'String')));
        end;
    end

    %% --- Executes on yMin_edit.
    function YMin_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hYMin, 'String')));
            
            if temp <= str2double(get(hYMax, 'String'))
                set(hYMin,'String',num2str(temp));
                inputInfo.minY = str2double(get(hYMin, 'String'));
            elseif temp > str2double(get(hYMax, 'String'))
                set(hYMin,'String',num2str(str2double(get(hYMax, 'String'))));
                inputInfo.minY = str2double(get(hYMin, 'String'));
            else
                set(hYMin, 'String',num2str(inputInfo.minY));
            end;

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hYMin,'String',flag); 
            inputInfo.minY = round(str2double(get(hYMin, 'String')));
        end;        
    end

    %% --- Executes on yMax_edit.
    function YMax_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hYMax, 'String')));
            
            if temp >= str2double(get(hYMin, 'String'))
                set(hYMax,'String',num2str(temp));
                inputInfo.maxY = str2double(get(hYMax, 'String'));
            elseif temp < str2double(get(hYMin, 'String'))
                set(hYMax,'String',num2str(str2double(get(hYMin, 'String'))));
                inputInfo.maxY = str2double(get(hYMax, 'String'));
            else
                set(hYMax, 'String',num2str(inputInfo.maxY));
            end;

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hYMax,'String',flag);
            inputInfo.maxY = round(str2double(get(hYMax, 'String')));
        end;
    end

    %% --- Executes on zMin_edit.
    function ZMin_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hZMin, 'String')));

            if temp <= str2double(get(hZMax, 'String'))
                set(hZMin,'String',num2str(temp));
                inputInfo.minZ = str2double(get(hZMin, 'String'));
            elseif temp > str2double(get(hZMax, 'String'))
                set(hZMin,'String',num2str(str2double(get(hZMax, 'String'))));
                inputInfo.minZ = str2double(get(hZMin, 'String'));
            else
                set(hZMin, 'String',num2str(inputInfo.minZ));
            end;

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hZMin,'String',flag);
            inputInfo.minZ = round(str2double(get(hZMin, 'String')));
        end;
    end

    %% --- Executes on zMax_edit.
    function ZMax_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hZMax, 'String')));
            
            if temp >= str2double(get(hZMin, 'String'))
                set(hZMax,'String',num2str(temp));
                inputInfo.maxZ = str2double(get(hZMax, 'String'));
            elseif temp < str2double(get(hZMin, 'String'))
                set(hZMax,'String',num2str(str2double(get(hZMin, 'String'))));
                inputInfo.maxZ = str2double(get(hZMax, 'String'));
            else
                set(hZMax, 'String',num2str(inputInfo.maxZ));
            end;

            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hZMax,'String',flag);
            inputInfo.maxZ = round(str2double(get(hZMax, 'String')));
        end;
    end

    %% --- Executes on xCtr_edit.
    function XCtr_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo button;
        if strcmp(button,'Create File')==1
            h = questdlg('Continuing will destroy dB0-geometry relationship.','Warning','Change','Cancel','Cancel');
%             uiwait(h)
            if strcmp(h,'Change')==1;
                if strcmp(flag,'')==1
                    temp = round(str2double(get(hXCtr, 'String')));
                    if ~isnan(temp)
                        inputInfo.ctrX = temp;
                        set(hXCtr,'String',num2str(temp));
                        displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                    else
                        temp = inputInfo.ctrX;
                        set(hXCtr,'String',num2str(temp));
                    end;
                else
                    set(hXCtr,'String',flag);
                    inputInfo.ctrX = round(str2double(get(hXCtr, 'String')));
                end;
            else
                set(hXCtr,'String',num2str(inputInfo.ctrX));
                return
            end
        else
            if strcmp(flag,'')==1
                temp = round(str2double(get(hXCtr, 'String')));
                if ~isnan(temp)
                    inputInfo.ctrX = temp;
                    set(hXCtr,'String',num2str(temp));
                    displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                else
                    temp = inputInfo.ctrX;
                    set(hXCtr,'String',num2str(temp));
                end;
            else
                set(hXCtr,'String',flag);
                inputInfo.ctrX = round(str2double(get(hXCtr, 'String')));
            end;
        end
    end
    %% --- Executes on yCtr_edit.
    function YCtr_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo button;
        if strcmp(button,'Create File')==1
            h = questdlg('Continuing will destroy dB0-geometry relationship.','Warning','Change','Cancel','Cancel');
%             uiwait(h)
            if strcmp(h,'Change')==1;
                if strcmp(flag,'')==1
                    temp = round(str2double(get(hYCtr, 'String')));
                    if ~isnan(temp)
                        inputInfo.ctrY = temp;
                        set(hYCtr,'String',num2str(temp));
                        displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                    else
                        temp = inputInfo.ctrY;
                        set(hYCtr,'String',num2str(temp));
                    end;
                else
                    set(hYCtr,'String',flag);
                    inputInfo.ctrY = round(str2double(get(hYCtr, 'String')));
                end;
            else
                set(hYCtr,'String',num2str(inputInfo.ctrY));
                return
            end
        else
            if strcmp(flag,'')==1
                temp = round(str2double(get(hYCtr, 'String')));
                if ~isnan(temp)
                    inputInfo.ctrY = temp;
                    set(hYCtr,'String',num2str(temp));
                    displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                else
                    temp = inputInfo.ctrY;
                    set(hYCtr,'String',num2str(temp));
                end;
            else
                set(hYCtr,'String',flag);
                inputInfo.ctrY = round(str2double(get(hYCtr, 'String')));
            end;
        end
    end

    %% --- Executes on zCtr_edit.
    function ZCtr_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo button;
        if strcmp(button,'Create File')==1
            h = questdlg('Continuing will destroy dB0-geometry relationship.','Warning','Change','Cancel','Cancel');
%             uiwait(h)
            if strcmp(h,'Change')==1;
                if strcmp(flag,'')==1
                    temp = round(str2double(get(hZCtr, 'String')));
                    if ~isnan(temp)
                        inputInfo.ctrX = temp;
                        set(hZCtr,'String',num2str(temp));
                        displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                    else
                        temp = inputInfo.ctrZ;
                        set(hZCtr,'String',num2str(temp));
                    end;
                else
                    set(hZCtr,'String',flag);
                    inputInfo.ctrZ = round(str2double(get(hZCtr, 'String')));
                end;
            else
                set(hZCtr,'String',num2str(inputInfo.ctrZ));
                return
            end
        else
            if strcmp(flag,'')==1
                temp = round(str2double(get(hZCtr, 'String')));
                if ~isnan(temp)
                    inputInfo.ctrZ = temp;
                    set(hZCtr,'String',num2str(temp));
                    displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                else
                    temp = inputInfo.ctrZ;
                    set(hZCtr,'String',num2str(temp));
                end;
            else
                set(hZCtr,'String',flag);
                inputInfo.ctrZ = round(str2double(get(hZCtr, 'String')));
            end;
        end
    end

    %% --- Executes on xSet_edit.
    function XSet_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hXSet, 'String')));
            set(hXSet,'String',num2str(temp));
            inputInfo.setX = str2double(get(hXSet, 'String'));
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hXSet,'String',flag);
            inputInfo.setX = round(str2double(get(hXSet, 'String')));
        end;
    end

    %% --- Executes on ySet_edit.
    function YSet_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hYSet, 'String')));
            set(hYSet,'String',num2str(temp));
            inputInfo.setY = str2double(get(hYSet, 'String'));
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hYSet,'String',flag);
            inputInfo.setY = round(str2double(get(hYSet, 'String')));
        end;
    end

    %% --- Executes on zSet_edit.
    function ZSet_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        
        if strcmp(flag,'')==1
            temp = round(str2double(get(hZSet, 'String')));
            set(hZSet,'String',num2str(temp));
            inputInfo.setZ = str2double(get(hZSet, 'String'));
            displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        else
            set(hZSet,'String',flag);
            inputInfo.setZ = round(str2double(get(hZSet, 'String')));
        end;
    end

%     %% --- Executes on xWid_edit.
%     function XWid_Callback(source,eventdata)
%         set(hXWid,'String',num2str(round(str2double(get(hXCtr, 'String'))/inputInfo.widX/1000)*inputInfo.widX*1000));
%     end
% 
%     %% --- Executes on yWid_edit.
%     function YWid_Callback(source,eventdata)
%         set(hYWid,'String',num2str(round(str2double(get(hYCtr, 'String'))/inputInfo.widX/1000)*inputInfo.widX*1000));
%     end
% 
%     %% --- Executes on zWid_edit.
%     function ZWid_Callback(source,eventdata)
%         set(hZWid,'String',num2str(round(str2double(get(hZCtr, 'String'))/inputInfo.widX/1000)*inputInfo.widX*1000));
%     end

    %% --- Executes on hSeqType_Menu.
    function SeqType_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            updateSeq();
        else
            tempStr = get(hSeqType,'String');
            temp = find(strcmp(tempStr,flag));
            set(hSeqType,'Value',temp);
            clear tempStr temp;
        end;
    end

    %% --- Executes on hB0Edit_Editbox.
    function B0Edit_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            temp = str2double(get(hB0Edit,'String'));
            if ~isnan(temp)        
                set(hB0Edit,'String',num2str(abs(temp)));
            else
                set(hB0Edit,'String','3');
            end;
        else
            set(hB0Edit,'String',flag); 
        end;  
    end
    
    %% --- Executes on hRF_Shape_Menu.
    function RF_Shape_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            updateSeq();
        else
            tempStr = get(hRF_Shape,'String');
            temp = find(strcmp(tempStr,flag));
            set(hRF_Shape,'Value',temp);
            clear tempStr temp;
        end;
    end
    
    %% --- Executes on hRF_Duration_Editbox.
    function RF_Duration_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            temp = str2double(get(hRF_Duration,'String'));
            if ~isnan(temp)
                set(hRF_Duration,'String',num2str(abs(temp)));
            else
                set(hRF_Duration,'String','2.6');
            end;
            updateSeq();
        else
            set(hRF_Duration,'String',flag); 
        end;
    end

    %% --- Executes on hRF_Num_Editbox.
    function RF_Num_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            temp = str2double(get(hRF_Num,'String'));
            if ~isnan(temp)
                set(hRF_Num,'String',num2str(round(abs(temp))));
            else
                set(hRF_Num,'String','128');
            end;
            updateSeq();
        else
            set(hRF_Num,'String',flag); 
        end;
    end

    %% --- Executes on hRF_FA_Editbox.
    function RF_FA_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            temp = str2double(get(hRF_FA,'String'));
            if ~isnan(temp)
                set(hRF_FA,'String',num2str(abs(temp)));
            else
                set(hRF_FA,'String','90');
            end;
            updateSeq();
        else
            set(hRF_FA,'String',flag); 
        end;
    end

    %% --- Executes on hTI_Duration_Editbox.
    function TI_Duration_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            temp = str2double(get(hTI,'String'));
            if ~isnan(temp)
                if abs(temp) ~= 0
                    set(hTI,'String',num2str(abs(temp)));
                else
                    set(hTI,'String','10');
                end;
            else
                set(hTI,'String','10');
            end;
            updateSeq();
        else
            set(hTI,'String',flag);
        end;
    end
%% --- Executes on Filter_checkbox
    function Filter_Callback(source,eventdata,flag)
        global geoData inputInfo displayInfo;
        if get(hFilter,'value')
            if strcmp(flag,'')==1
                tempX = [round(str2double(get(hXMin, 'String'))) ,round(str2double(get(hXMax, 'String')))];
                tempY = [round(str2double(get(hYMin, 'String'))) ,round(str2double(get(hYMax, 'String')))];
                tempZ = [round(str2double(get(hZMin, 'String'))) ,round(str2double(get(hZMax, 'String')))];
                ctrX  = round(str2double(get(hXCtr, 'String')));
                ctrY  = round(str2double(get(hYCtr, 'String')));
                ctrZ  = round(str2double(get(hZCtr, 'String')));
                selectView=get(hOrientationMenu,'Value');
                switch selectView
                    case 1 %axial
                        switch get(hPEDirectMenu,'Value')
                            case 1
                                Xvariable=[round((ctrX)-inputInfo.FOV(1)/(2*inputInfo.widX)+inputInfo.setX),round(inputInfo.FOV(1)/(2*inputInfo.widX)+(ctrX)+inputInfo.setX)-1];
                                inputInfo.minX=Xvariable(1);
                                set(hXMin,'string',num2str(inputInfo.minX));
                                inputInfo.maxX=Xvariable(2);
                                set(hXMax,'string',num2str(inputInfo.maxX));
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                            case 2
                                Yvariable=[round((ctrY+1)-inputInfo.FOV(1)/(2*inputInfo.widY+inputInfo.setY)),round(inputInfo.FOV(1)/(2*inputInfo.widY)+(ctrY)+inputInfo.setY)];
                                inputInfo.minY=Yvariable(1);
                                set(hYMin,'string',num2str(inputInfo.minY));
                                inputInfo.maxY=Yvariable(2);
                                set(hYMax,'string',num2str(inputInfo.maxY));
%                                 inputInfo.FOV=rot90(inputInfo.FOV,2);
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
%                                 inputInfo.FOV=rot90(inputInfo.FOV,2);
                        end
                    case 2 %sag
                        switch get(hPEDirectMenu,'Value')
                            case 1
                                Yvariable=[round((ctrZ+1)-inputInfo.FOV(1)/(2*inputInfo.widZ)+inputInfo.setZ),round(inputInfo.FOV(1)/(2*inputInfo.widZ)+(ctrZ)+inputInfo.setZ)];
                                inputInfo.minZ=Yvariable(1);
                                set(hZMin,'string',num2str(inputInfo.minZ));
                                inputInfo.maxZ=Yvariable(2);
                                set(hZMax,'string',num2str(inputInfo.maxZ));
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                            case 2
                                Xvariable=[round((ctrY)-inputInfo.FOV(1)/(2*inputInfo.widY+inputInfo.setY)),round(inputInfo.FOV(1)/(2*inputInfo.widY)+(ctrY)+inputInfo.setY)];
                                inputInfo.minY=Xvariable(1);
                                set(hYMin,'string',num2str(inputInfo.minY));
                                inputInfo.maxY=Xvariable(2);
                                set(hYMax,'string',num2str(inputInfo.maxY));
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                        end
                        
                    case 3 %cor
                        switch get(hPEDirectMenu,'Value')
                            case 1
                                Yvariable=[round((ctrZ+1)-inputInfo.FOV(1)/(2*inputInfo.widZ)+inputInfo.setZ),round(inputInfo.FOV(1)/(2*inputInfo.widZ)+(ctrZ)+inputInfo.setZ)];
                                inputInfo.minZ=Yvariable(1);
                                set(hZMin,'string',num2str(inputInfo.minZ));
                                inputInfo.maxZ=Yvariable(2);
                                set(hZMax,'string',num2str(inputInfo.maxZ));
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                            case 2
                                Xvariable=[round((ctrX)-inputInfo.FOV(1)/(2*inputInfo.widX)+inputInfo.setX),round(inputInfo.FOV(1)/(2*inputInfo.widX)+(ctrX)+inputInfo.setX)-1];
                                inputInfo.minX=Xvariable(1);
                                set(hXMin,'string',num2str(inputInfo.minX));
                                inputInfo.maxX=Xvariable(2);
                                set(hXMax,'string',num2str(inputInfo.maxX));
                                displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                        end
                end
            else
                set(hFilter,'Value',str2double(flag));
            end
        end
    end

    %% --- Executes on hFOV_Pop_popmenu.
    function FOV_Pop_Callback(source,eventdata,flag)
        global geoData inputInfo displayInfo;
        if strcmp(flag,'')==1
            val = get(hFOV_Pop,'Value');
            FOV=get(hFOV,'value');
            PE=get(hPEDirectMenu,'Value');
            switch val
                case 1   % User selected the first item
%                     if PE==1
                        if isempty(FOV)
                            FOV=get(hFOV,'Value');
                            set(hFOV,'value',FOV);
                        else
                            set(hFOV,'string',sprintf('%1.0f',FOV(1)));
%                             switch get(hOrientationMenu,'Value')
%                                 case 1
%                                     set(hFOV,'string',sprintf('%1.0f',FOV(1)));
%                                 case 2
%                                     set(hFOV,'string',sprintf('%1.0f',FOV(2)));
%                                 case 3
%                                     set(hFOV,'string',sprintf('%1.0f',FOV(2)));
%                             end
                        end
%                     else
%                         if FOV==0
%                             FOV=str2double(get(hFOV,'string'));
%                             FOV(2)=FOV;
%                             set(hFOV,'value',FOV);
%                         else
%                             if length(FOV)>1
%                                 set(hFOV,'string',sprintf('%1.0f',FOV(2)));
% %                                 switch get(hOrientationMenu,'Value')
% %                                     case 1
% %                                         set(hFOV,'string',sprintf('%1.0f',FOV(2)));
% %                                     case 2
% %                                         set(hFOV,'string',sprintf('%1.0f',FOV(1)));
% %                                     case 3
% %                                         set(hFOV,'string',sprintf('%1.0f',FOV(1)));
% %                                 end
%                             else
%                                 FOV(2)=FOV;
%                                 set(hFOV,'string',sprintf('%1.0f',FOV(2)));
%                                 set(hFOV,'value',FOV);
%                             end
%                         end
%                     end
                case 2   % User selected the second item
%                     if PE==1
                        if FOV==0
                            FOV=str2double(get(hFOV,'string'));
                            FOV(2)=FOV;
                            set(hFOV,'value',FOV);
                        else
                            if length(FOV)>1
                                set(hFOV,'string',sprintf('%1.0f',FOV(2)));
%                                 switch get(hOrientationMenu,'Value')
%                                     case 1
%                                         set(hFOV,'string',sprintf('%1.0f',FOV(2)));
%                                     case 2
%                                         set(hFOV,'string',sprintf('%1.0f',FOV(1)));
%                                     case 3
%                                         set(hFOV,'string',sprintf('%1.0f',FOV(1)));
%                                 end
                            else
                                FOV(2)=FOV;
                                set(hFOV,'string',sprintf('%1.0f',FOV(2)));
                                set(hFOV,'value',FOV);
                            end
                        end
%                     else
%                         if isempty(FOV)
%                             FOV=get(hFOV,'Value');
%                             set(hFOV,'value',FOV);
%                         else
%                             set(hFOV,'string',sprintf('%1.0f',FOV(1)));
% %                             switch get(hOrientationMenu,'Value')
% %                                 case 1
% %                                     set(hFOV,'string',sprintf('%1.0f',FOV(1)));
% %                                 case 2
% %                                     set(hFOV,'string',sprintf('%1.0f',FOV(2)));
% %                                 case 3
% %                                     set(hFOV,'string',sprintf('%1.0f',FOV(2)));
% %                             end
%                         end
%                     end
            end
        end
    end

    %% --- Executes on hFOV_Editbox.
    function FOV_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        tempStr = get(hFOV_Pop,'value');
        PE=get(hPEDirectMenu,'Value');
%         set(hFilter,'value',0);
        if tempStr==1 %user selected to edit the FE direction
            temp=1;
        else          %user selected to edit the PE direction
            temp=2;
        end
        switch get(hOrientationMenu,'Value')
            case 1 %axial
                switch PE
                    case 1 %P-A
                        inputInfo.FOV_flag=2; %dimensions will be flipped to align graphic properly
                    case 2 %L-R
                        inputInfo.FOV_flag=1;
                end
            case 2 %sagital
                switch PE
                    case 1 %P-A
                        inputInfo.FOV_flag=1;
                    case 2 %F-H
                        inputInfo.FOV_flag=2;
                end
            case 3 %coronal
                switch PE
                    case 1 
                        inputInfo.FOV_flag=1;
                    case 2
                        inputInfo.FOV_flag=2;
                end
        end
        if strcmp(flag,'')==1
            FOV=get(hFOV,'value');
            switch temp
                case 1 %FE
                    FOVtemp=str2double(get(hFOV,'String'));
                    if FOVtemp==0
                        FOVtemp=1;
                        set(hFOV,'string',sprintf('%1.0f',FOVtemp));
                    end
                    FOV(1)=FOVtemp;
                    if length(FOV)<2
                        FOV(2)=FOVtemp;
                    end
                    if ~isnan(FOV(1))
                        set(hFOV,'value',FOV);
                    else
                        set(hFOV,'String','300');
                    end;
                        inputInfo.FOV=FOV;
                        displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
                case 2 %PE
                    FOVtemp=str2double(get(hFOV,'String'));
                    if FOVtemp==0
                        FOVtemp=1;
                        set(hFOV,'string',sprintf('%1.0f',FOVtemp));
                    end
                    FOV(2)=FOVtemp;
                    if length(FOV)<2
                        FOV(1)=FOVtemp;
                    end
                    if ~isnan(FOV(2))
                        set(hFOV,'value',FOV);
                    else
                        set(hFOV,'String','300');
                    end;
                    inputInfo.FOV = FOV;
                    displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
            end
            updateSeq();
            Filter_Callback(source,eventdata,flag);
        else
            flag=sscanf(flag,'%f');
            set(hFOV,'value',flag);
            set(hFOV,'string',num2str(flag(1)));
            inputInfo.FOV = flag;
        end;
    end
    %% --- Executes on hMatSize_Popupmenu.
    function MatSize_Pop_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            val = get(hMatSize_Pop,'Value');
            MatSize=get(hMatSize,'value');
            switch val
                case 1   % User selected the first item
                    if isempty(MatSize)
                        MatSize=get(hMatSize,'Value');
                        set(hMatSize,'value',MatSize);
                    else
                        set(hMatSize,'string',sprintf('%1.0f',MatSize(1)));
                    end
                case 2   % User selected the second item
                    if isempty(MatSize)
                        MatSize=get(hMatSize,'Value');
                        set(hMatSize,'string',sprintf('%1.0f',MatSize));
                    else
                        if length(MatSize)>1
                            set(hMatSize,'string',sprintf('%1.0f',MatSize(2)));
                        else
                            MatSize(2)=MatSize;
                            set(hMatSize,'string',sprintf('%1.0f',MatSize(2)));
                            set(hMatSize,'value',MatSize);
                        end
                    end  
            end
        end

    end
    %% --- Executes on hMatSize_Editbox.
    function MatSize_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            tempStr = get(hMatSize_Pop,'value');
            PE=get(hPEDirectMenu,'Value');
%         switch get(hOrientationMenu,'Value')
%             case 1
                switch PE
                    case 1
                        if tempStr==1
                            temp=1;
                        else
                            temp=2;
                        end
                    case 2
                        if tempStr==1
                            temp=1;
                        else
                            temp=2;
                        end
                end
                %                     set(hPEDirectMenu,'String',{'P--A';'L--R'});
%             case 2
%                 switch PE
%                     case 1
%                         if tempStr==1
%                             temp=1;
%                         else
%                             temp=2;
%                         end
%                     case 2
%                         if tempStr==1
%                             temp=1;
%                         else
%                             temp=2;
%                         end
%                 end
                %                     set(hPEDirectMenu,'String',{'P--A';'F--H'});
%             case 3
%                 switch PE
%                     case 1
%                         if tempStr==1
%                             temp=1;
%                         else
%                             temp=2;
%                         end
%                     case 2
%                         if tempStr==1
%                             temp=1;
%                         else
%                             temp=2;
%                         end
%                 end
                %                     set(hPEDirectMenu,'String',{'L--R';'F--H'});
%         end
            MatSize=get(hMatSize,'value');
            switch temp
                case 1
                    MatSizetemp=str2double(get(hMatSize,'String'));
                    if MatSizetemp==0
                        MatSizetemp=1;
                    end
                    MatSize(1)=MatSizetemp;
                    if length(MatSize)<2
                        MatSize(2)=MatSizetemp;
                    end
                    if ~isnan(MatSize(1))
                        set(hMatSize,'value',MatSize);
                        set(hMatSize,'string',sprintf('%1.0f',MatSize(1)));
                    else
                        set(hMatSize,'String','128');
                    end;
                case 2
                    MatSizetemp=str2double(get(hMatSize,'String'));
                    if MatSizetemp==0
                        MatSizetemp=1;
                    end
                    MatSize(2)=MatSizetemp;
                    if length(MatSize)<2
                        MatSize(1)=MatSizetemp;
                    end
                    if ~isnan(MatSize(2))
                        set(hMatSize,'value',MatSize);
                        set(hMatSize,'string',sprintf('%1.0f',MatSize(2)));
                    else
                        set(hMatSize,'String','128');
                    end;
            end
            updateSeq();
        else
            flag=sscanf(flag,'%f');
            set(hMatSize,'value',flag); 
            set(hMatSize,'string',num2str(flag(1)));
        end;
    end

    %% --- Executes on hADC_Freq_Editbox.
    function ADC_Freq_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hADC_Freq,'String'));
            if ~isnan(temp)
                set(hADC_Freq,'String',num2str(abs(temp)));
            else
                set(hADC_Freq,'String','50');
            end;
            updateSeq();
        else
            set(hADC_Freq,'String',flag); 
        end;
    end

    %% --- Executes on hTx_Editbox.
    function hTx_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hTx,'String'));
            if ~isnan(temp)
                set(hTx,'String',num2str(round(abs(temp))));
            else
                set(hTx,'String','1');
            end;
        else
            set(hTx,'String',flag); 
        end;
        
        Tx.Num = str2double(get(hTx,'String'));
        Tx.MagMat = ones(Tx.Num,1);
        Tx.PhsMat = zeros(Tx.Num,1);
    end

    %% --- Executes on hRx_Editbox.
    function hRx_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hRx,'String'));
            if ~isnan(temp)
                set(hRx,'String',num2str(round(abs(temp))));
            else
                set(hRx,'String','1');
            end;
        else
            set(hRx,'String',flag); 
        end;
        
        Rx.Num = str2double(get(hRx,'String'));
    end

    %% --- Executes on hSS_Checkbox.
    function SS_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            updateSeq();
        else
            set(hSS,'Value',str2double(flag)); 
        end;
    end

    %% --- Executes on hFE_Checkbox.
    function FE_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            updateSeq();
        else
            set(hFE,'Value',str2double(flag)); 
        end;
    end  

    %% --- Executes on hPE_Checkbox.
    function PE_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            updateSeq();
        else
            set(hPE,'Value',str2double(flag)); 
        end;
    end  

    %% --- Executes on hTE_Editbox.
    function TE_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hTE,'String'));
            if ~isnan(temp)
                set(hTE,'String',num2str(abs(temp)));
            else
                set(hTE,'String','10');
            end;
            updateSeq();
        else
            set(hTE,'String',flag); 
        end;
    end  

    %% --- Executes on hTR_Editbox.
    function TR_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hTR,'String'));
            if ~isnan(temp)
                set(hTR,'String',num2str(abs(temp)));
            else
                set(hTR,'String','500');
            end;
            updateSeq();
        else
            set(hTR,'String',flag); 
        end;
    end  

    %% --- Executes on hDummyNum_Editbox.
    function DummyNum_Callback(source,eventdata,flag) %#ok<INUSL>
        if strcmp(flag,'')==1
            temp = str2double(get(hDummyNum,'String'));
            if ~isnan(temp)
                set(hDummyNum,'String',num2str(round(abs(temp))));
            else
                set(hDummyNum,'String','0');
            end;
        else
            set(hDummyNum,'String',flag);
        end;
    end

    %% --- Executes on PEDirectMenu
    function PEDirectMenu_Callback(source,eventdata,flag) %#ok<INUSL>
        global geoData inputInfo displayInfo;
        if strcmp(flag,'')==1
            x=get(hPEDirectMenu,'value');
            set(hFilter,'value',0)
        else
            set(PEDirectMenu,'String',flag);
        end
        if x==2
            inputInfo.FOV_flag=2;
        end
%         FOV=inputInfo.FOV;
%         tempFE=FOV(1);
% %         if size(FOV)<2
% %             tempPE=FOV(1);
% %         else
% %             tempPE=FOV(2);
% %         end
        inputInfo.FOV(1)=300; %tempPE;
        inputInfo.FOV(2)=300; %tempFE;
        set(hFOV,'value',inputInfo.FOV);
        FOV_Pop_Callback(source,eventdata,flag);
        displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
    end

    %% --- Executes on hSeqGen_Button.
    function SeqGen_Callback(source,eventdata) %#ok<INUSD,INUSD>
        global interSeqData inputInfo;
                
        %cd(addr);
        
%         tempAddr = pwd;
        
%         path(path,[pwd,'\SeqDev\Functions\']);
%         path(path,[pwd,'\SeqDev\Bin\']);
        
        RF.FA = str2double(get(hRF_FA,'String')); % Degrees
        [MagMat, PhsMat,index] = TxMagPhsGUI(Tx.Num,Tx.MagMat,Tx.PhsMat,RF.FA);

        if index ~= 0
            Tx.MagMat = MagMat;
            Tx.PhsMat = PhsMat;
            
            set(hTx,'Enable','off');
            set(hRx,'Enable','off');
            
            %cd([tempAddr '\SeqDev\User']);
        
            TE = str2double(get(hTE,'String')); %ms
            TR = str2double(get(hTR,'String')); %ms
            TI.duration = str2double(get(hTI,'string')); %ms
            MatSize.value = get(hMatSize,'value');
            FOV.value = get(hFOV,'value'); %mm
            RF.Duration = str2double(get(hRF_Duration,'String')); %ms
            RF.Num = str2double(get(hRF_Num,'String'));
            RF.Shape = get(hRF_Shape,'Value');

            ADC.BW = str2double(get(hADC_Freq,'String')); %kHz

            GradOn.ss = get(hSS,'Value'); %gradients are specified in mT/m, but here it is a on/off flag.
            GradOn.fe = get(hFE,'Value');
            GradOn.pe = get(hPE,'Value');
            temp = get(hPEDirectMenu,'String'); peDirectoin = temp(get(hPEDirectMenu,'Value')); clear temp;
            dummy = str2double(get(hDummyNum,'String'));

            slice.TH = str2double(get(hGeoSliceTH,'String'))/1000;
            switch get(hOrientationMenu,'Value')
                case 1
                    slice.offset = (inputInfo.currentZ - inputInfo.ctrZ)*inputInfo.widZ/1000;
                case 2
                    slice.offset = (inputInfo.currentX - inputInfo.ctrX)*inputInfo.widX/1000;
                case 3
                    slice.offset = (inputInfo.currentY - inputInfo.ctrY)*inputInfo.widY/1000;
            end;
            
            tempNum = get(hSeqType,'Value');
            tempStr = get(hSeqType,'String');
            
            MatSize.handle = hMatSize;
            FOV.handle = hFOV;
            interSeqData = SeqInterfaceOut(cell2mat(tempStr(tempNum)),...
                tempNum,TE,TR,MatSize,hMatSize_Pop,FOV,hFOV_Pop,RF,ADC,GradOn,dummy,slice,TI);
            
            set(hSeqPlot,'Enable','on');
            %cd([tempAddr '\SeqDev\Bin']);

            interSeqData = checkSeqProt(interSeqData);
            finalSeqData = combineSeq(interSeqData,get(hOrientationMenu,'Value'),peDirectoin,dummy); %

            expSeq(finalSeqData,dummy,Tx,Rx); %

            % inputCmd{5,1}=''; inputCmd{5,2}=''; % B1+ FileName
            % inputCmd{6,1}=''; inputCmd{6,2}=''; % E1+ FileName
            % inputCmd{7,1}=''; inputCmd{7,2}=''; % B1- FileName
            % inputCmd{8,1}=''; inputCmd{8,2}=''; % E1- FileName
            
            if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
                set(hRun,'Enable','on');
            end;

            set(hExpSeqEdit,'String',get(hStudyName,'String'),'FontAngle','normal');
            inputCmd{4,2} = [get(hStudyName,'String'),'.seqn'];
            inputCmd{4,1} = [addr,'\Protocols\',get(hStudyName,'String'),'\']; %%---

            set(hSeqPlot,'Enable','on');

            set(hMode,'Enable','on');
            tempMode = get(hMode,'Value');
            switch tempMode
                case {1,2}
                    set(hB0Edit,'Enable','on');
                    set(hExpDB0,'Enable','on');
                    
                    set(hExpB1m,'Enable','on');
%                     tempStr = get(hExpB1mEdit,'String');

%                         set(hExpB1mEdit,'String','Homogeneous or B1- Filename(s)','FontAngle','italic');
%                         clear inputCmd{7,1} inputCmd{7,2};
                    
                    set(hExpGx,'Enable','on');
                    set(hExpGy,'Enable','on');
                    set(hExpGz,'Enable','on');

                    set(hExpB1p,'Enable','on');
                    set(hExpB1m,'Enable','on');
%                     set(hExpB1pEdit,'String','Homogeneous or B1+ Filename(s)','FontAngle','italic');
%                     clear inputCmd{5,1} inputCmd{5,2};
                    
                    set(hExpE1p,'Enable','off');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
                    set(hExpE1m,'Enable','off');
                    % set(hExpE1mEdit,'String','E1- Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};

                    set(hNumIso,'Enable','on');
                    set(hThread,'Enable','on');

                case 3
                    set(hB0Edit,'Enable','off');
                    set(hExpDB0,'Enable','off');
                                       
                    set(hExpGx,'Enable','off');
                    set(hExpGy,'Enable','off');
                    set(hExpGz,'Enable','off');

                    set(hExpB1p,'Enable','on');
                    set(hExpB1m,'Enable','off');
                    
                    set(hExpE1p,'Enable','on');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
                    set(hExpE1m,'Enable','off');
                    % set(hExpE1mEdit,'String','E1- Filename(s)','FontAngle','italic');
                    % clear inputCmd{8,1} inputCmd{8,2};
                    
                    set(hNumIso,'Enable','off');
                    set(hThread,'Enable','on');

                case 4
                    set(hB0Edit,'Enable','off');
                    set(hExpDB0,'Enable','off');
                                        
                    set(hExpB1m,'Enable','off');
%                     set(hExpB1mEdit,'String','Homogeneous or B1- Filename(s)','FontAngle','italic');
%                     clear inputCmd{7,1} inputCmd{7,2};
                    
                    set(hExpGx,'Enable','off');
                    set(hExpGy,'Enable','off');
                    set(hExpGz,'Enable','off');

                    set(hExpB1p,'Enable','off');
%                     set(hExpB1pEdit,'String','Homogeneous or B1+ Filename(s)','FontAngle','italic');
%                     clear inputCmd{5,1} inputCmd{5,2};
                    
                    set(hExpE1p,'Enable','off');
                    % set(hExpE1pEdit,'String','E1+ Filename(s)','FontAngle','italic');
                    % clear inputCmd{6,1} inputCmd{6,2};
                    
                    set(hExpE1m,'Enable','on');
                    % set(hExpE1mEdit,'string','E1- Filename(s)','FontAngle','italic');        
                    % clear inputCmd{8,1} inputCmd{8,2};
                    
                    set(hNumIso,'Enable','off');
                    set(hThread,'Enable','off');
            end;

            if ~isempty(inputCmd{1,1}) && ~isempty(inputCmd{2,1})
                set(hRun,'Enable','on');
            end;
        end
    end

    %% --- Executes on hSeqPlot_Button.
    function SeqPlot_Callback(source,eventdata) %#ok<INUSD,INUSD>
        global interSeqData;
        
        RF = sum(abs(interSeqData.Main.RF.value),1) ./ max(sum(abs(interSeqData.Main.RF.value),1));
        if max(abs(interSeqData.Main.DFreq.value)) ~= 0
            DFreq = interSeqData.Main.DFreq.value ./ max(abs(interSeqData.Main.DFreq.value));
        else
            DFreq = interSeqData.Main.DFreq.value;
        end;
        if max(abs(interSeqData.Main.Gss.value)) ~= 0
            SS = interSeqData.Main.Gss.value ./ max(abs(interSeqData.Main.Gss.value));
        else
            SS = interSeqData.Main.Gss.value;
        end;
        if max(abs(interSeqData.Main.Gpe.value)) ~= 0
            PE = interSeqData.Main.Gpe.value ./ max(abs(interSeqData.Main.Gpe.value));
        else
            PE = interSeqData.Main.Gpe.value;
        end;
        if max(abs(interSeqData.Main.Gfe.value)) ~= 0
            FE = interSeqData.Main.Gfe.value ./ max(abs(interSeqData.Main.Gfe.value));
        else
            FE = interSeqData.Main.Gfe.value;
        end;
        ADC = interSeqData.Main.ADC.value;
        dRF = diff([0, sum(abs(interSeqData.Main.RF.value),1)]);
        dDFreq = diff([0, sum(abs(interSeqData.Main.DFreq.value),1)]);
        dSS = diff([0, interSeqData.Main.Gss.value]);
        dPE = diff([0, interSeqData.Main.Gpe.value]);
        dFE = diff([0, interSeqData.Main.Gfe.value]);
        
        for n=1:length(interSeqData.Main.ADC.tStep)+1
            if n==1
                time.ADC(n) = 0;
            else
                time.ADC(n) = time.ADC(n-1) + interSeqData.Main.ADC.tStep(n-1);
            end;
        end;
        for n=1:length(interSeqData.Main.RF.tStep)+1
            if n==1
                time.RF(n) = 0;
            else
                time.RF(n) = time.RF(n-1) + interSeqData.Main.RF.tStep(n-1);
            end;
        end;
        for n=1:length(interSeqData.Main.DFreq.tStep)+1
            if n==1
                time.DFreq(n) = 0;
            else
                time.DFreq(n) = time.DFreq(n-1) + interSeqData.Main.DFreq.tStep(n-1);
            end;
        end;
        for n=1:length(interSeqData.Main.Gpe.tStep)+1
            if n==1
                time.PE(n) = 0;
            else
                time.PE(n) = time.PE(n-1) + interSeqData.Main.Gpe.tStep(n-1);
            end;
        end;
        for n=1:length(interSeqData.Main.Gfe.tStep)+1
            if n==1
                time.FE(n) = 0;
            else
                time.FE(n) = time.FE(n-1) + interSeqData.Main.Gfe.tStep(n-1);
            end;
        end;
        for n=1:length(interSeqData.Main.Gss.tStep)+1
            if n==1
                time.SS(n) = 0;
            else
                time.SS(n) = time.SS(n-1) + interSeqData.Main.Gss.tStep(n-1);
            end;
        end;
        
        hSeqPlotFig=figure('Visible','on','MenuBar','none','Name','Sequence Plot',...
            'NumberTitle','off','Position',[100,100,1000,800],'Resize','off',...
            'Toolbar','figure','Color',[1,1,1]);
        
        temp1 = sum(interSeqData.Main.ADC.tStep) - interSeqData.Main.ADC.tStep(length(interSeqData.Main.ADC.tStep));
        temp2 = sum(interSeqData.Main.RF.tStep) - interSeqData.Main.RF.tStep(length(interSeqData.Main.RF.tStep));
        temp3 = sum(interSeqData.Main.DFreq.tStep) - interSeqData.Main.DFreq.tStep(length(interSeqData.Main.DFreq.tStep));
        temp4 = sum(interSeqData.Main.Gss.tStep) - interSeqData.Main.Gss.tStep(length(interSeqData.Main.Gss.tStep));
        temp5 = sum(interSeqData.Main.Gpe.tStep) - interSeqData.Main.Gpe.tStep(length(interSeqData.Main.Gpe.tStep));
        temp6 = sum(interSeqData.Main.Gfe.tStep) - interSeqData.Main.Gfe.tStep(length(interSeqData.Main.Gfe.tStep));
        
        timeMax = max([temp1, temp2, temp3, temp4, temp5, temp6]) * 5/4;
        
        movegui(hSeqPlotFig,'center');
        xlim([0 timeMax]);
        ylim([-0.5 15.0]);
        set(gca,'YTickLabelMode','manual');
        set(gca,'YTick',[0.3;1.7;4;6.6;9.2;11.8;13.5]);
        set(gca,'YTickLabel',{'Events';'Acq';'FE';'PE';'SS';'DFreq';'RF'});
        
        for t=1:length(time.RF)-1
            %RF
            line([time.RF(t),time.RF(t+1)],[RF(t),RF(t)]+13.5,'LineStyle','-','linewidth',3,'color',[60 42 196]/255);
            if dRF(t)~=0
                line([time.RF(t),time.RF(t)],[RF(t-1),RF(t)]+13.5,'LineStyle','-','linewidth',3,'color',[60 42 196]/255);
            end;
        end;
        
        for t=1:length(time.DFreq)-1
            %DFreq
            line([time.DFreq(t),time.DFreq(t+1)],[DFreq(t),DFreq(t)]+11.8,'LineStyle','-','linewidth',3,'color',[60 42 196]/255);
            if dDFreq(t)~=0
                line([time.DFreq(t),time.DFreq(t)],[DFreq(t-1),DFreq(t)]+11.8,'LineStyle','-','linewidth',3,'color',[60 42 196]/255);
            end;
        end;
        
        for t=1:length(time.SS)-1
            %SS
            line([time.SS(t),time.SS(t+1)],[SS(t),SS(t)]+9.2,'LineStyle','-','linewidth',3,'color',[0 125 197]/255);
            if dSS(t)~=0
                line([time.SS(t),time.SS(t)],[SS(t-1),SS(t)]+9.2,'LineStyle','-','linewidth',3,'color',[0 125 197]/255);
            end;
        end;

        for t=1:length(time.PE)-1
            %PE
            line([time.PE(t),time.PE(t+1)],[PE(t),PE(t)]+6.6,'LineStyle','-','linewidth',3,'color',[237 24 73]/255);
            if dPE(t)~=0
                line([time.PE(t),time.PE(t)],[PE(t-1),PE(t)]+6.6,'LineStyle','-','linewidth',3,'color',[237 24 73]/255);
            end;
        end;
        
        for t=1:length(time.FE)-1
            %FE
            line([time.FE(t),time.FE(t+1)],[FE(t),FE(t)]+4,'LineStyle','-','linewidth',3,'color',[0 169 79]/255);
            if dFE(t)~=0
                line([time.FE(t),time.FE(t)],[FE(t-1),FE(t)]+4,'LineStyle','-','linewidth',3,'color',[0 169 79]/255);
            end;
        end;

        for t=1:length(time.ADC)-1
            %ADC
            if ADC(t)==1
                line([(time.ADC(t)+time.ADC(t+1))/2,(time.ADC(t)+time.ADC(t+1))/2]...
                ,[0,1]+1.7,'LineStyle','-','linewidth',0.1,'color',[247 80 13]/255);
            else
                line([time.ADC(t),time.ADC(t+1)],[0 0]+1.7...
                    ,'LineStyle','-','linewidth',3,'color',[247 80 13]/255);
            end;
        end;
        
        for t=1:length(time.ADC)-1
            %Events
            if ADC(t)==-2 %Ideal Crushing
                line([(time.ADC(t)+time.ADC(t+1))/2,(time.ADC(t)+time.ADC(t+1))/2]...
                ,[0 1]+0.3,'LineStyle','-','linewidth',5,'color','m');
                text((time.ADC(t)+time.ADC(t+1))/2-0.5,0.1,'Ideal Crushing');
            else
                line([time.ADC(t) time.ADC(t+1)],[0 0]+0.3...
                    ,'LineStyle','-','linewidth',3,'color','m');
            end;
        end;
        title('Pulse Sequence Diagram');
        xlabel('Time(ms)');
    end


    %% --- Executes on NumIsoMenu.
    function NumIsoMenu_Callback(source,eventdata,flag)
        global inputInfo;
        if strcmp(flag,'')==1
            idx = get(hNumIsoMenu,'Value');
            set(hNumIso,'String',num2str(inputInfo.NumIso(idx)));
        end
    end

    %% --- Executes on hNumIso_Editbox.
    function NumIso_Callback(source,eventdata,flag) %#ok<INUSD,INUSD>
        global inputInfo;
        idx = get(hNumIsoMenu,'Value');
        if strcmp(flag,'')==1
            temp = str2double(get(hNumIso,'String'));
            if ~isnan(temp)
                set(hNumIso,'String',num2str(round(abs(temp))));
                inputInfo.NumIso(idx) = temp;
            else
                set(hNumIso,'String','1');
                inputInfo.NumIso(idx) = 1;
            end;
        else
            set(hNumIso,'String',flag);
            inputInfo.NumIso(idx) = str2double(flag);
        end;
    end

    %% --- Executes on hThread_Editbox.
    function Thread_Callback(source,eventdata,flag) %#ok<INUSD,INUSD>
        if strcmp(flag,'')==1
            temp = str2double(get(hThread,'String'));
            if ~isnan(temp)
                set(hThread,'String',num2str(round(abs(temp))));
            else
                set(hThread,'String','1');
            end;
        else
            set(hThread,'String',flag); 
        end;
    end

    %% --- Executes on hMode_Menu
    function Mode_Callback(source,eventdata,flag)
        if strcmp(flag,'')==1
            tempMode = get(hMode,'Value');
        else
            tempStr = get(hMode,'String');
            tempMode = find(strcmp(tempStr,flag));
            set(hMode,'Value',tempMode);
        end;
        
        switch tempMode
            case {1,2}
                set(hB0Edit,'Enable','on');
                set(hExpDB0,'Enable','on');
                
                set(hExpGx,'Enable','on');
                set(hExpGy,'Enable','on');
                set(hExpGz,'Enable','on');

                set(hExpB1p,'Enable','on');
                set(hExpB1m,'Enable','on');
                set(hExpE1p,'Enable','off');

                set(hExpE1m,'Enable','off');
                
                set(hNumIso,'Enable','on');
                set(hThread,'Enable','on');

            case 3
                set(hB0Edit,'Enable','off');
                set(hExpDB0,'Enable','off');

                set(hExpGx,'Enable','off');
                set(hExpGy,'Enable','off');
                set(hExpGz,'Enable','off');

                set(hExpB1p,'Enable','on');
                set(hExpB1m,'Enable','off');
                set(hExpE1p,'Enable','on');

                set(hExpE1m,'Enable','off');
                
                set(hNumIso,'Enable','off');
                set(hThread,'Enable','on');

            case 4
                set(hB0Edit,'Enable','off');
                set(hExpDB0,'Enable','off');

                set(hExpGx,'Enable','off');
                set(hExpGy,'Enable','off');
                set(hExpGz,'Enable','off');

                set(hExpB1p,'Enable','off');
                set(hExpB1m,'Enable','off');
                set(hExpE1p,'Enable','off');

                set(hExpE1m,'Enable','on');
                
                set(hNumIso,'Enable','off');
                set(hThread,'Enable','off');
        end;
    end

    %% --- Executes on hRun_Button.
    function Run_Callback(source,eventdata) %#ok<INUSD,INUSD>
        global inputInfo;
        
        %cd(addr);
        
        tempMode = get(hMode,'Value');
        switch tempMode
            case {1,2}
                if (Tx.Num == 1) && (tempMode == 1)
                    runScriptSignal = ['"',addr,'\Engine\NutateSignalSimpleTx"',...
                        ' "NumIsoX=',num2str(inputInfo.NumIso(1)),'"',...
                        ' "NumIsoY=',num2str(inputInfo.NumIso(2)),'"',...
                        ' "NumIsoZ=',num2str(inputInfo.NumIso(3)),'"',...
                        ' "Thread=',get(hThread,'String'),'"',...
                        ' "B0=',get(hB0Edit,'String'),'"',...
                        ' "GeometryFile=',[inputCmd{1,1},inputCmd{1,2}],'"',...
                        ' "TissueTypeFile=',[inputCmd{2,1},inputCmd{2,2}],'"',...
                        ' "SequenceFile=',[inputCmd{4,1},inputCmd{4,2}],'"'];
                else
                    runScriptSignal = ['"',addr,'\Engine\NutateSignalAdvancedTx"',...
                        ' "NumIsoX=',num2str(inputInfo.NumIso(1)),'"',...
                        ' "NumIsoY=',num2str(inputInfo.NumIso(2)),'"',...
                        ' "NumIsoZ=',num2str(inputInfo.NumIso(3)),'"',...
                        ' "Thread=',get(hThread,'String'),'"',...
                        ' "B0=',get(hB0Edit,'String'),'"',...
                        ' "GeometryFile=',[inputCmd{1,1},inputCmd{1,2}],'"',...
                        ' "TissueTypeFile=',[inputCmd{2,1},inputCmd{2,2}],'"',...
                        ' "SequenceFile=',[inputCmd{4,1},inputCmd{4,2}],'"'];
                end;
                
                if ~isempty(inputCmd{3,1})
                    runScriptSignal = [runScriptSignal, ' "DelB0File=',[inputCmd{3,1},inputCmd{3,2}],'"'];
                end;
                
                if ~isempty(inputCmd{5,1})
                    temp1 = size(inputCmd{5,2});
                    for n=1:temp1(2)
                        runScriptSignal = [runScriptSignal, ' "B1PlusFile=',[inputCmd{5,1}{n},inputCmd{5,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                end;
                
                if ~isempty(inputCmd{7,1})
                    temp1 = size(inputCmd{7,2});
                    for n=1:temp1(2)
                        runScriptSignal = [runScriptSignal, ' "B1MinsFile=',[inputCmd{7,1}{n},inputCmd{7,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                end;
                
                if ~isempty(inputCmd{9,1})
                    runScriptSignal = [runScriptSignal, ' "DelGxFile=',[inputCmd{9,1},inputCmd{9,2}],'"'];
                end;

                if ~isempty(inputCmd{10,1})
                    runScriptSignal = [runScriptSignal, ' "DelGyFile=',[inputCmd{10,1},inputCmd{10,2}],'"'];
                end;

                if ~isempty(inputCmd{11,1})
                    runScriptSignal = [runScriptSignal, ' "DelGzFile=',[inputCmd{11,1},inputCmd{11,2}],'"'];
                end;
                
                if ~isempty(inputCmd{12,1})
                    runScriptSignal = [runScriptSignal, ' "KSpaceFile=',[inputCmd{12,1},inputCmd{12,2}],'"'];
                else
                    errordlg('Please Specify kSpace Filename.','modal');
                    return
                end;

                if ~isempty(inputCmd{13,1})
                    runScriptSignal = [runScriptSignal, ' "KMapFile=',[inputCmd{13,1},inputCmd{13,2}],'"'];
                else
                    errordlg('Please Specify kMap Filename.','modal');
                    return
                end;

                runScriptSignal = [runScriptSignal, ...
                    ' "xMin=',get(hXMin,'String'),'"',...
                    ' "xMax=',get(hXMax,'String'),'"',...
                    ' "yMin=',get(hYMin,'String'),'"',...
                    ' "yMax=',get(hYMax,'String'),'"',...
                    ' "zMin=',get(hZMin,'String'),'"',...
                    ' "zMax=',get(hZMax,'String'),'"',...
                    ' "xCtr=',get(hXCtr,'String'),'"',...
                    ' "yCtr=',get(hYCtr,'String'),'"',...
                    ' "zCtr=',get(hZCtr,'String'),'"',...
                    ];
                
            case 3
                runScriptSAR = ['"',addr,'\Engine\NutateSAR"',...
                    ' "Thread=',get(hThread,'String'),'"',...
                    ' "GeometryFile=',[inputCmd{1,1},inputCmd{1,2}],'"',...
                    ' "TissueTypeFile=',[inputCmd{2,1},inputCmd{2,2}],'"',...
                    ' "SequenceFile=',[inputCmd{4,1},inputCmd{4,2}],'"'];
                
                if ~isempty(inputCmd{5,1})
                    temp1 = size(inputCmd{5,2});
                    for n=1:temp1(2)
                        runScriptSAR = [runScriptSAR, ' "B1PlusFile=',[inputCmd{5,1}{n},inputCmd{5,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                else
                    errordlg('Please Specify B1+ Filename(s).','modal');
                    return
                end;
                
                if ~isempty(inputCmd{6,1})
                    temp1 = size(inputCmd{6,2});
                    for n=1:temp1(2)
                        runScriptSAR = [runScriptSAR, ' "E1PlusFile=',[inputCmd{6,1}{n},inputCmd{6,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                else
                    errordlg('Please Specify E1+ Filename(s).','modal');
                    return
                end;               
                                
                if ~isempty(inputCmd{7,1})
                    temp1 = size(inputCmd{7,2});
                    for n=1:temp1(2)
                        runScriptSAR = [runScriptSAR, ' "B1MinsFile=',[inputCmd{7,1}{n},inputCmd{7,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                end;
                
                if ~isempty(inputCmd{15,1})
                    runScriptSAR = [runScriptSAR, ' "SARFile=',[inputCmd{15,1},inputCmd{15,2}],'"'];
                else
                    errordlg('Please Specify SAR Filename.','modal');
                    return
                end;
                               
                runScriptSAR = [runScriptSAR, ...
                    ' "xMin=',get(hXMin,'String'),'"',...
                    ' "xMax=',get(hXMax,'String'),'"',...
                    ' "yMin=',get(hYMin,'String'),'"',...
                    ' "yMax=',get(hYMax,'String'),'"',...
                    ' "zMin=',get(hZMin,'String'),'"',...
                    ' "zMax=',get(hZMax,'String'),'"',...
                    ];
                               
            case 4
                runScriptNoise = ['"',addr,'\Engine\NutateNoise"',...
                    ' "NEX=1"',...
                    ' "GeometryFile=',[inputCmd{1,1},inputCmd{1,2}],'"',...
                    ' "TissueTypeFile=',[inputCmd{2,1},inputCmd{2,2}],'"',...
                    ' "SequenceFile=',[inputCmd{4,1},inputCmd{4,2}],'"'];

                if ~isempty(inputCmd{8,1})
                    temp1 = size(inputCmd{8,2});
                    for n=1:temp1(2)
                        runScriptNoise = [runScriptNoise, ' "E1MinsFile=',[inputCmd{8,1}{n},inputCmd{8,2}{n}],'"']; %#ok<AGROW>
                    end;
                    clear temp1;
                else
                    errordlg('Please Specify E1- Filename(s).','modal');
                    return
                end;
                
                if ~isempty(inputCmd{14,1})
                    runScriptNoise = [runScriptNoise, ' "KNoiseFile=',[inputCmd{14,1},inputCmd{14,2}],'"'];
                else
                    errordlg('Please Specify Noise Filename.','modal');
                    return
                end;
                
                runScriptNoise = [runScriptNoise, ...
                    ' "xMin=',get(hXMin,'String'),'"',...
                    ' "xMax=',get(hXMax,'String'),'"',...
                    ' "yMin=',get(hYMin,'String'),'"',...
                    ' "yMax=',get(hYMax,'String'),'"',...
                    ' "zMin=',get(hZMin,'String'),'"',...
                    ' "zMax=',get(hZMax,'String'),'"',...
                    ];
        end;
        
        % Generate bat file        
        switch tempMode
            case {1,2}
                fid=fopen([addr,'\Protocols\',get(hStudyName,'String'),'\','runSignal.bat'],'w');
                fprintf(fid,[slashCvrt(runScriptSignal),'\n']);
            case 3
                fid=fopen([addr,'\Protocols\',get(hStudyName,'String'),'\','runSAR.bat'],'w');
                fprintf(fid,[slashCvrt(runScriptSAR),'\n']);
            case 4
                fid=fopen([addr,'\Protocols\',get(hStudyName,'String'),'\','runNoise.bat'],'w');
                fprintf(fid,[slashCvrt(runScriptNoise),'\n']);
        end;
        fprintf(fid,'exit\n');
        fclose(fid);
        
        StudySave_Callback(source,eventdata,'Run');
        
        cd([addr,'\Protocols\',get(hStudyName,'String'),'\']);
        
        % For Windows system:
        switch tempMode
            case {1,2}
                runScript = ['runSignal', ' &'];
            case 3
                runScript = ['runSAR', ' &'];
            case 4
                runScript = ['runNoise', ' &'];
        end;

        dos(runScript);
        
        %cd(addr);
    end

    %% Update Sequence Function
    function updateSeq()
        global inputInfo;
        
        tempAddr = addr;
        %cd([tempAddr '\SeqDev\User']);
        
        TE = str2double(get(hTE,'String'));
        TR = str2double(get(hTR,'String'));
        MatSize.value = get(hMatSize,'value');
        FOV.value = get(hFOV,'value');
        RF.Duration = str2double(get(hRF_Duration,'String'));
        
        if ((str2double(get(hRF_Num,'String')) == 1) && ( get(hRF_Shape,'Value') == 1))
            set(hRF_Num,'String','2');
        end;
        RF.Num = str2double(get(hRF_Num,'String'));
        
        RF.Shape = get(hRF_Shape,'Value');
        RF.FA = str2double(get(hRF_FA,'String'));
        ADC.BW = str2double(get(hADC_Freq,'String'));

        GradOn.ss = get(hSS,'Value');
        GradOn.fe = get(hFE,'Value');
        GradOn.pe = get(hPE,'Value');
        dummy = str2double(get(hDummyNum,'String'));
        
        %cd([tempAddr '\SeqDev\User']);

        tempCell = SeqInterfaceIn;
        set(hSeqType,'String',tempCell);
        
        clear tempN tempM tempCell;
        
        slice.TH = str2double(get(hGeoSliceTH,'String'))/1000;
        switch get(hOrientationMenu,'Value')
            case 1
                slice.offset = (inputInfo.currentZ - inputInfo.ctrZ)*inputInfo.widZ;
            case 2
                slice.offset = (inputInfo.currentX - inputInfo.ctrX)*inputInfo.widX;
            case 3
                slice.offset = (inputInfo.currentY - inputInfo.ctrY)*inputInfo.widY;
        end;
        
        tempNum = get(hSeqType,'Value');
        tempStr = get(hSeqType,'String');
        
        SeqInterfaceIn(tempNum,hTI);
        TI.duration = str2double(get(hTI,'string'));
        TI.handle = hTI;
        MatSize.handle = hMatSize;
        FOV.handle = hFOV;
        
        [minTE,minTR] = SeqInterfaceOut(tempStr{tempNum},tempNum,TE,TR,MatSize,hMatSize_Pop,FOV,hFOV_Pop,RF,ADC,GradOn,dummy,slice,TI);
        % displayImages(hImages,inputInfo,displayInfo,get(hOrientationMenu,'Value'),geoData);
        
        if str2double(get(hTE,'String')) < minTE
            set(hTE,'String',num2str(round(minTE*10000)/10000));
        end;
        if str2double(get(hTR,'String')) < minTR
            set(hTR,'String',num2str(round(minTR*10000)/10000));
        end;
        
        %cd(tempAddr);
    end

    %% Export Sequence Function
    function expSeq(finalSeqData,dummy,Tx,Rx)
        
        tempStr = get(hStudyName,'String');
        cd([addr,'\Protocols\',tempStr]);
        
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
        
        %cd(addr);
        
        msgbox('Sequence File Generated.','modal');
    end

    %% Reset Function
    function reset()

        % % % Display black AxialImage.
        axes(hImages.hAxlImage); %#ok<MAXES>
        image(0);
        colormap(gray);
        axis image off;
        hImages.Axial.slice = rectangle('edgecolor','r','Visible','off');
        hImages.Axial.center = rectangle('edgecolor','y','Visible','off');
        hImages.Axial.volume = rectangle('edgecolor','g','Visible','off');

        % % % Display black SagittalImage.
        axes(hImages.hSagImage); %#ok<MAXES>
        image(0);
        colormap(gray);
        axis image off;
        hImages.Sagittal.slice = rectangle('edgecolor','r','Visible','off');
        hImages.Sagittal.center = rectangle('edgecolor','y','Visible','off');
        hImages.Sagittal.volume = rectangle('edgecolor','g','Visible','off');

        % % % Display black CoronalImage.
        axes(hImages.hCrlImage); %#ok<MAXES>
        image(0);
        colormap(gray);
        axis image off;
        hImages.Coronal.slice = rectangle('edgecolor','r','Visible','off');
        hImages.Coronal.center = rectangle('edgecolor','y','Visible','off');
        hImages.Coronal.volume = rectangle('edgecolor','g','Visible','off');

        % % % Save FileName Addresses.
        inputCmd = cell(13,2);
        inputCmd{1,1}=''; inputCmd{1,2}=''; % Geo FileName
        inputCmd{2,1}=''; inputCmd{2,2}=''; % Tiss FileName
        inputCmd{3,1}=''; inputCmd{3,2}=''; % dB0 FileName
        inputCmd{4,1}=''; inputCmd{4,2}=''; % Sequence FileName
        inputCmd{5,1}=''; inputCmd{5,2}=''; % B1+ FileName
        inputCmd{6,1}=''; inputCmd{6,2}=''; % E1+ FileName
        inputCmd{7,1}=''; inputCmd{7,2}=''; % B1- FileName
        inputCmd{8,1}=''; inputCmd{8,2}=''; % E1- FileName
        inputCmd{9,1}='';  inputCmd{9,2}='';  % Gx FileName
        inputCmd{10,1}=''; inputCmd{10,2}=''; % Gy FileName
        inputCmd{11,1}=''; inputCmd{11,2}=''; % Gz FileName
        inputCmd{12,1}=''; inputCmd{12,2}=''; % KSpace FileName
        inputCmd{13,1}=''; inputCmd{13,2}=''; % KMap FileName
        inputCmd{14,1}=''; inputCmd{14,2}=''; % Noise FileName
        inputCmd{15,1}=''; inputCmd{15,2}=''; % SAR FileName

        Tx.Num = 1;
        Tx.MagMat = ones(Tx.Num,1);
        Tx.PhsMat = zeros(Tx.Num,1);
        
        Rx.Num = 1;
        
        set(hSave,'Enable','off');
        set(hReset,'Enable','off');
        
        % % % Display DisplayMenu.
        set(hDisplayMenu,'String',{'ID','T1','T2','PD','Chemical Shift','Conductivity','Mass Density'},'Value',1,'Enable','off');
        
        % % % Display ScaleMenu.
        set(hScaleMenu,'Value',1,'Enable','off');

        % % % Display OrientationMenu.
        set(hOrientationMenu,'Value',1,'Enable','off');

        % % % Display GeoSliderTH.
        set(hGeoSliceTH,'String','0','Enable','off');

        % % % Display GeoSlider.
        set(hGeoSlider,'Max',100,'Min',0,'Value',0,...
            'SliderStep',[1/100,10/100],'Enable','off');

        % % % Display GeoSliderEdit.
        set(hGeoSliderEdit,'String','0','Enable','off');

        % % % Display Min,Max,Ctr,Wid,Set edits.
        set(hXMin,'String','','Enable','Inactive');
        set(hYMin,'String','','Enable','Inactive');
        set(hZMin,'String','','Enable','Inactive');
        set(hXMax,'String','','Enable','Inactive');
        set(hYMax,'String','','Enable','Inactive');
        set(hZMax,'String','','Enable','Inactive');
        set(hXCtr,'String','','Enable','Inactive');
        set(hYCtr,'String','','Enable','Inactive');
        set(hZCtr,'String','','Enable','Inactive');
        set(hXWid,'String','','Enable','Inactive');
        set(hYWid,'String','','Enable','Inactive');
        set(hZWid,'String','','Enable','Inactive');
        set(hXSet,'String','','Enable','Inactive');
        set(hYSet,'String','','Enable','Inactive');
        set(hZSet,'String','','Enable','Inactive');
        

        % % % Display the GeoName.
        set(hExpGeoEdit,'String','Geo Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpGeo,'Enable','off');

        % % % Display the TissName.
        set(hExpTissEdit,'String','Tiss Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpTiss,'Enable','off');
        
        % % % Display the dB0Edit.
        set(hExpDB0Edit,'String','0 or dB0 Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpDB0,'Enable','off');
        set(hExpClearDB0,'Enable','off');

        % % % Display the seqEdit.
        set(hExpSeqEdit,'string','Use setup or Seq Filename',...
            'Enable','inactive',...
            'FontAngle','italic');
        set(hExpSeq,'Enable','off');
        
        % % % Display the B1pEdit.
        set(hExpB1pEdit,'string','Homogeneous or B1+ Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        set(hExpB1p,'Enable','off');
        set(hExpClearB1p,'Enable','off');
        
        % % % Display the E1pEdit.
        set(hExpE1pEdit,'string','E1+ Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        set(hExpE1p,'Enable','off');
        set(hExpClearE1p,'Enable','off');
        
        % % % Display the B1mEdit.
        set(hExpB1mEdit,'string','Homogeneous or B1- Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        set(hExpB1m,'Enable','off');
        set(hExpClearB1m,'Enable','off');
        
        % % % Display the E1mEdit.
        set(hExpE1mEdit,'string','E1- Filename(s)',...
            'Enable','inactive',...
            'FontAngle','italic');
        set(hExpE1m,'Enable','off');
        set(hExpClearE1m,'Enable','off');
        
        % % % Display the GxEdit.
        set(hExpGxEdit,'string','Linear or Gx Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpGx,'Enable','off');
        set(hExpClearGx,'Enable','off');
        
        % % % Display the GyEdit.
        set(hExpGyEdit,'string','Linear or Gy Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpGy,'Enable','off');
        set(hExpClearGy,'Enable','off');
        
        % % % Display the GzEdit.
        set(hExpGzEdit,'string','Linear or Gz Filename','Enable','inactive',...
            'FontAngle','italic');
        set(hExpGz,'Enable','off');
        set(hExpClearGz,'Enable','off');
        
        % % % Display the B0Edit.
        set(hB0Edit,'string','3','Enable','off');
        
        % % % Display the SequenceType menu.
        set(hSeqType,'Value',1,'Enable','off');
        
        % % % Display the RF_Shape menu.
        set(hRF_Shape,'Value',1,'Enable','off');
        
        % % % Display the RF_Duration edit.
        set(hRF_Duration,'String','2.6','Enable','off');
        
        % % % Display the RF# edit.
        set(hRF_Num,'String','128','Enable','off');
        
        % % % Display the RF_FA edit.
        set(hRF_FA,'String','90','Enable','off');
        
        % % % Display the RF_TI edit.
        set(hTI,'String','10','Enable','off');
        
        % % % Display the FOV edit.
        set(hFOV_Pop,'String','FOV FE(mm)|FOV PE(mm)','Enable','off');

        % % % Display the FOV edit.
        set(hFOV,'String','300','Value',[300,300],'Enable','off');
        
        % % % Display the MatSize edit.
        set(hMatSize_Pop,'String','MatSize FE|MatSize PE','Enable','off');

        % % % Display the MatSize edit.
        set(hMatSize,'String','128','Value',[128,128],'Enable','off');

        % % % Display the ADC_Freq edit.
        set(hADC_Freq,'String','50','Enable','off');

        % % % Display the Tx edit.
        set(hTx,'String','1','Enable','off');
        % % % Display the Rx edit.
        set(hRx,'String','1','Enable','off');
        
        % % % Display the Filter checkbox.
        set(hFilter,'String','Filter','Value',0,'Enable','off');
        
        % % % Display the SS checkbox.
        set(hSS,'String','SS','Value',1,'Enable','off');

        % % % Display the PE checkbox.
        set(hPE,'String','PE','Value',1,'Enable','off');

        % % % Display the FE checkbox.
        set(hFE,'String','FE','Value',1,'Enable','off');

        % % % Display the TE edit.
        set(hTE,'String','TE','String','10','Enable','off');

        % % % Display the TR edit.
        set(hTR,'String','TR','String','500','Enable','off');
        
        % % % Display the TI_Duration edit.
        set(hTI,'String','10','Enable','off');
        
        % % % Display the DummyNum edit.
        set(hDummyNum,'String','0','Enable','off');

        % % % Display the PEDirect edit.
        set(hPEDirectMenu,'String',{'P--A';'L--R'},'Value',1,...
           'Enable','off'); % to be edited
        
        set(hSeqGen,'Enable','off');
        
        set(hSeqPlot,'Enable','off');
        
        % % Show the NumIso Menu
        set(hNumIsoMenu,'String','NumIsoX|NumIsoY|NumIsoZ','Value',3,'Enable','off');
                
        % % Display the NumIso edit.
        set(hNumIso, 'String','1','Enable','off');
        
        % % Display the Thread edit.
        set(hThread, 'String','1','Enable','off');

        % % Display the Mode menu.
        set(hMode,'Enable','off');
        
        % %  Display the Run button.
        set(hRun,'Enable','off');

        % %  Display the Exit button.
        set(hExit,'Enable','on');
    end
end
   

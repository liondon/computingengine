function varargout = B0Solver(varargin)
% B0SOLVER M-file for B0Solver.fig
%      B0SOLVER, by itself, creates a new B0SOLVER or raises the existing
%      singleton*.
%
%      H = B0SOLVER returns the handle to a new B0SOLVER or the handle to
%      the existing singleton*.
%
%      B0SOLVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in B0SOLVER.M with the given input arguments.
%
%      B0SOLVER('Property','Value',...) creates a new B0SOLVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before B0Solver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to B0Solver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help B0Solver

% Last Modified by GUIDE v2.5 16-Aug-2010 12:16:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @B0Solver_OpeningFcn, ...
                   'gui_OutputFcn',  @B0Solver_OutputFcn, ...
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


% --- Executes just before B0Solver is made visible.
function B0Solver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to B0Solver (see VARARGIN)

% Choose default command line output for B0Solver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global inputGeoData inputInfo head xmin_max ymin_max zmin_max count v min_size rect
count=0;
% ex=exist('inputInfo.FOV');
if ~(isempty(inputInfo))
   
    
    %load user defined geometry
    set(handles.status,'String','Loading...');
    fid1=fopen(inputInfo.filename,'rb');
    if fid1>0
        fseek(fid1,4,'bof');
        xmin_max=fread(fid1,[1 2],'float32');
        ymin_max=fread(fid1,[1 2],'float32');
        zmin_max=fread(fid1,[1 2],'float32');
        fseek(fid1,28,'bof');
        center=fread(fid1,[1 3],'float32');
    end
    fclose(fid1);
    set(handles.geoedit,'String',inputInfo.filename);
    set(handles.geopb,'enable','inactive');
    set(handles.matrixedit,'enable','on')
    x=inputGeoData(1,:);
    y=inputGeoData(2,:);
    z=inputGeoData(3,:);
    ID=inputGeoData(4,:);
    rows=inputInfo.totNumVox;
%     xmin_max(1,1)=inputInfo.minX;
%     xmin_max(1,2)=inputInfo.maxX;
%     ymin_max(1,1)=inputInfo.minY;
%     ymin_max(1,2)=inputInfo.maxY;
%     zmin_max(1,1)=inputInfo.minZ;
%     zmin_max(1,2)=inputInfo.maxZ;
    min_size=max(max(max(xmin_max,ymin_max),zmin_max));
    size= max(max(max(xmin_max,ymin_max),zmin_max))+128;
%      size=inputInfo.FOV;
    if mod(size,2)~=0
        size=size+1;
    end
    head=zeros(size,size,size);
    w=size/2;
    %set slider values according to mat size
    step(1)=.01/(w*2);
    step(2)=.04/(w*2);
%     center(1,1)=(inputInfo.FOV)/2;
%     center(1,2)=(inputInfo.FOV)/2;
%     center(1,3)=(inputInfo.FOV)/2;
    mx=center(1,1)-w;
    my=center(1,2)-w;
    mz=center(1,3)-w;
    x=x-mx;
    xmin_max=xmin_max-mx;
    y=y-my;
    ymin_max=ymin_max-my;
    z=z-mz;
    zmin_max=zmin_max-mz;
    cx=center(1,1)-mx;
    cy=center(1,2)-my;
    cz=center(1,3)-mz;
    iso_cx=inputInfo.ctrX-mx;
    iso_cy=inputInfo.ctrY-my;
    iso_cz=inputInfo.ctrZ-mz;
   
    
    %set initial slider and edit box value
    set(handles.xslider,'Value',cx);
    set(handles.yslider,'Value',cy);
    set(handles.zslider,'Value',cz);
    set(handles.iso_x,'string',sprintf('%1.0f',iso_cx));
    set(handles.iso_y,'string',sprintf('%1.0f',iso_cy));
    set(handles.iso_z,'string',sprintf('%1.0f',iso_cz));
    set(handles.iso_x,'enable','inactive');
    set(handles.iso_y,'enable','inactive');
    set(handles.iso_z,'enable','inactive');
    set(handles.xedit,'enable','inactive');
    set(handles.yedit,'enable','inactive');
    set(handles.zedit,'enable','inactive');
    set(handles.xslider,'enable','inactive');
    set(handles.yslider,'enable','inactive');
    set(handles.zslider,'enable','inactive');
    set(handles.matrixedit,'string',sprintf('%1.0f',size));
    %assign tissue id number
    for i=1:rows
        head(x(i),y(i),z(i))=ID(i);
    end
    set(handles.status,'String','');
    %diplays geometry file name in geo edit box
    %     set(handles.geoedit,'string',startup);
    count=count+1;
    clear i j n s array x y z ID c filename pathname center rows scale status file
    
%     x=round(get(handles.xslider,'Value'));
%     y=round(get(handles.yslider,'Value'));
%     z=round(get(handles.zslider,'Value'));
    x=inputInfo.currentX-mx;
    y=inputInfo.currentY-my;
    z=inputInfo.currentZ-mz;
    f=length(head);
    set(handles.xslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
    set(handles.yslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
    set(handles.zslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
    hx(:,:)=head(x,:,:);
    hx=flipdim(rot90(hx,3),2);
    hy(:,:)=head(:,y,:);
    hy=flipdim(rot90(hy,3),2);
    hz(:,:)=head(:,:,z);
    hz=flipdim(rot90(hz,3),2);
%     clear x y z;
    
    clear lx ly lz mx my mz pad fid fid1 cx cy cz
    set(handles.xslider,'sliderstep',step,'max',w*2,'min',1,'value',x);
    set(handles.xedit,'string',sprintf('%1.0f',x));
    set(handles.yslider,'sliderstep',step,'max',w*2,'min',1,'value',y);
    set(handles.yedit,'string',sprintf('%1.0f',y));
    set(handles.zslider,'sliderstep',step,'max',w*2,'min',1,'value',z);
    set(handles.zedit,'string',sprintf('%1.0f',z));
    clear step
    axes(handles.axes1)%plots sagital X map
    pcolor(hx);shading flat;axis off;colormap jet2;axis equal
    v=caxis;%sets color scale
    axes(handles.axes5)
    colorbar('delete')
    caxis(v);
    %sets colorscale edit and sliders to colorscale value
    set(handles.csmaxedit,'string',sprintf('%.1f',max(v)));
    set(handles.csminedit,'string',sprintf('%.1f',min(v)));
    set(handles.csminslider,'value',min(v));
    set(handles.csmaxslider,'value',max(v));
    axes(handles.axes2)%plots coronal X map
    pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
    axes(handles.axes3)%plots
    pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
    %sends the colorbar to axis 5
    colorbar('peer',handles.axes5,'location','north')
    axes(handles.axes1)
    rect.x=rectangle('position',[iso_cy-3 iso_cz-3 6 6],'FaceColor','y');
    axes(handles.axes2)
    rect.y=rectangle('position',[iso_cx-3 iso_cz-3 6 6],'FaceColor','y');
    axes(handles.axes3)
    rect.z=rectangle('position',[iso_cx-3 iso_cy-3 6 6],'FaceColor','y');
    if count>=1
        set(handles.suscpb,'enable','on')
    end
end
return


% UIWAIT makes B0Solver wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = B0Solver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% global X;
% global head;
% global s;
% global fileh;
% global Bnuc;
% global run;
% global v;
% global Bhead;
% global count update shim 

% count=0;
update=0;
shim=0;




% --- Executes on button press in geopb.
function geopb_Callback(hObject, eventdata, handles)

global head fileh xmin_max ymin_max zmin_max count v run min_size rect

if run>0
    set(handles.suscpb,'enable','off')
    set(handles.runpb,'enable','off')
    set(handles.autoshimpb,'enable','off')
    set(handles.updatepb,'enable','off')
    set(handles.resetpb,'enable','off')
    set(handles.suscedit,'string','Susceptability filename')
    set(handles.geoedit,'string','Geometry filename')
    set(handles.matrixedit,'enable','on')
    set(handles.fieldpop,'enable','off')
    count=0;
    run=0;
end


set(handles.matrixedit,'enable','on');
size=round(str2num(get(handles.matrixedit,'String')));
if mod(size,2)~=0
    size=size+1;
end
head=zeros(size,size,size);
w=size/2;
%set slider values according to mat size
step(1)=.01/(w*2);
step(2)=.04/(w*2);
set(handles.xslider,'sliderstep',step,'max',w*2,'min',1,'value',w);
set(handles.xedit,'string',sprintf('%1.0f',w));
set(handles.yslider,'sliderstep',step,'max',w*2,'min',1,'value',w);
set(handles.yedit,'string',sprintf('%1.0f',w));
set(handles.zslider,'sliderstep',step,'max',w*2,'min',1,'value',w);
set(handles.zedit,'string',sprintf('%1.0f',w));
clear step
%load user defined geometry
set(handles.status,'String','Loading...');
[filename,pathname]=uigetfile('*.smpl','Load Geometry File');
if isequal(filename,0)
    set(handles.status,'String','');
    return
else
    fileh=[pathname filename];
    fid1=fopen(fileh,'rb');
    if fid1>0
        rows=fread(fid1,1,'float32');
        %checks that geometry size fits in zero matrix
        xmin_max=fread(fid1,[1 2],'float32');
        %         if max(xmin_max)-min(xmin_max)>=w*2
        %             set(handles.status,'string','Geometry file exceeds matrix dimensions');
        %             clear head w filname pathname fid1 file rows xmin_max;
        %             errordlg('Geometry file exceeds program matrix dimensions.','Dimension Error');
        %             return
        %         end
        ymin_max=fread(fid1,[1 2],'float32');
        %         if max(ymin_max)-min(ymin_max)>=w*2
        %             set(handles.status,'string','Geometry file exceeds matrix dimensions');
        %             clear head w filname pathname fid1 file rows xmin_max ymin_max;
        %             errordlg('Geometry file exceeds program matrix dimensions.','Dimension Error');
        %             return
        %         end
        zmin_max=fread(fid1,[1 2],'float32');
        %         if max(zmin_max)-min(zmin_max)>=w*2
        %             set(handles.status,'string','Geometry file exceeds matrix dimensions');
        %             clear head w filname pathname fid1 file rows xmin_max ymin_max zmin_max;
        %             errordlg('Geometry file exceeds program matrix dimensions.','Dimension Error');
        %             return
        %         end
        if max(xmin_max)-min(xmin_max)>=w*2 || max(ymin_max)-min(ymin_max)>=w*2|| max(zmin_max)-min(zmin_max)>=w*2
            size= max(max(max(xmin_max,ymin_max),zmin_max))+128;
            %      size=inputInfo.FOV;
            if mod(size,2)~=0
                size=size+1;
            end
            set(handles.matrixedit,'string',sprintf('%1.0f',size))
            head=zeros(size,size,size);
            w=size/2;
        end
        min_size=max(max(max(xmin_max,ymin_max),zmin_max));
        %read in and center geometry file
        center=fread(fid1,[1 3],'float32');
        scale=fread(fid1,[1 3],'float32');
        x=fread(fid1,rows,'float32',12);
        fseek(fid1,56,'bof');
        y=fread(fid1,rows,'float32',12);
        fseek(fid1,60,'bof');
        z=fread(fid1,rows,'float32',12);
        fseek(fid1,64,'bof');
        ID=fread(fid1,rows,'float32',12);
        fclose(fid1);
        mx=center(1,1)-w;
        my=center(1,2)-w;
        mz=center(1,3)-w;
        x=x-mx;
        xmin_max=xmin_max-mx;
        y=y-my;
        ymin_max=ymin_max-my;
        z=z-mz;
        zmin_max=zmin_max-mz;
        cx=center(1,1)-mx;
        cy=center(1,2)-my;
        cz=center(1,3)-mz;
        %set initial slider and edit box value
        set(handles.xslider,'Value',cx);
        set(handles.yslider,'Value',cy);
        set(handles.zslider,'Value',cz);
        set(handles.iso_x,'string',sprintf('%1.0f',cx));
        set(handles.iso_y,'string',sprintf('%1.0f',cy));
        set(handles.iso_z,'string',sprintf('%1.0f',cz));
        %assign tissue id number
        for i=1:rows
            head(x(i),y(i),z(i))=ID(i);
        end
        set(handles.status,'String','');
        %diplays geometry file name in geo edit box
        set(handles.geoedit,'string',filename);
    else
        disp('WRONG')
    end
count=count+1;

clear i j n s array x y z ID c filename pathname center rows scale status file
clear lx ly lz mx my mz pad w fid fid1 cx cy cz
end
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
f=length(head);
set(handles.xslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
set(handles.yslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
set(handles.zslider,'sliderstep',[(1/f) 10/f],'max',f,'min',1);
hx(:,:)=head(x,:,:);
hx=flipdim(rot90(hx,3),2);
hy(:,:)=head(:,y,:);
hy=flipdim(rot90(hy,3),2);
hz(:,:)=head(:,:,z);
hz=flipdim(rot90(hz,3),2);
clear x y z;
axes(handles.axes1)%plots sagital X map
pcolor(hx);shading flat;axis off;colormap jet2;axis equal
v=caxis;%sets color scale
axes(handles.axes5)
colorbar('delete')
caxis(v);
%sets colorscale edit and sliders to colorscale value
set(handles.csmaxedit,'string',sprintf('%.1f',max(v)));
set(handles.csminedit,'string',sprintf('%.1f',min(v)));
set(handles.csminslider,'value',min(v));
set(handles.csmaxslider,'value',max(v));
axes(handles.axes2)%plots coronal X map
pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)%plots
pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
%sends the colorbar to axis 5
colorbar('peer',handles.axes5,'location','north')
if count>=1
    set(handles.suscpb,'enable','on')
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');








function geoedit_Callback(hObject, eventdata, handles)
% hObject    handle to geoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%diplays geometry file name


% --- Executes during object creation, after setting all properties.
function geoedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to geoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in suscpb.
function suscpb_Callback(hObject, eventdata, handles)
% hObject    handle to suscpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s;
global filename;
global fid2;
global count;
global head;
global X;
global run;
global v rect;
if run>0
    return
end
%load user defined suscept file
set(handles.status,'String','Loading...');
set(handles.matrixedit,'enable','off');
set(handles.fieldpop,'enable','on')
[filename,pathname]=uigetfile('*.susc','Load Susceptibility File');
if isequal(filename,0)
    set(handles.status,'String','');
    return
else
    file=[pathname filename];
    fid2=fopen(file,'rt');
    if fid2>0
        f=textscan(fid2,'%s %s %s');
        fclose(fid2);
    else
        disp('WRONG')
    end
end
y2=str2double(f{2});
y1=str2double(f{1});
susc=zeros(19,2);
for i=1:19
    susc(i,1)=y1(i);
    susc(i,2)=y2(i);
end
%assign susc values to susc matrix
s=size(head);
X=0.00000040*ones(s(1),s(2),s(3));
for d=1:19
    indexList = (head==susc(d,1));
    X(indexList) = susc(d,2);
end
clear indexList
clear a;
clear b;
clear c;
clear d;
set(handles.status,'String','');
%displays susc filename in susc edit box
set(handles.suscedit,'string',filename);
%gets slider position values
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
%increases count to show that geo and susc files are loaded
count=count+1;
%checks the display pop up menu, if X dist is selected, plots X dist
pop=get(handles.fieldpop,'value');
if pop==2 
    if count>=2
        Xxp(:,:)=X(x,:,:);
        Xxp=flipdim(rot90(Xxp,3),2);
        Xyp(:,:)=X(:,y,:);
        Xyp=flipdim(rot90(Xyp,3),2);
        Xzp(:,:)=X(:,:,z);
        Xzp=flipdim(rot90(Xzp,3),2);
        clear x y z;
        axes(handles.axes1)%plots sagital X map
        pcolor(Xxp);shading flat;axis off;colormap jet2;axis equal
        v=caxis;%sets color scale
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        %sets colorscale edit and sliders to colorscale value 
        set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
        set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));         
        set(handles.csminslider,'value',v(1,1)*10^6);
        set(handles.csmaxslider,'value',v(1,2)*10^6);
        axes(handles.axes2)%plots coronal X map
        pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots
        pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')       
        set(handles.status,'String','');
    end
end

clear f;
clear y1;
clear y2;
clear filename;
clear pathname;
clear msg;
clear i;
clear status;
clear file;
clear x;
clear y;
clear z;
clear c;
%enables run pb
set(handles.runpb,'enable','on')
run=0;
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

function suscedit_Callback(hObject, eventdata, handles)
% hObject    handle to suscedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suscedit as text
%        str2double(get(hObject,'String')) returns contents of suscedit as a double


% --- Executes during object creation, after setting all properties.
function suscedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suscedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function xslider_Callback(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider
global run;
global Bnuc;
global v;
global Bhead head;
global X;
global count;
global sagrect;
global xROImin xROImax yROImin yROImax zROImin zROImax inputInfo rect;
if isempty(inputInfo)
pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
set(handles.xedit,'string',sprintf('%1.0f',x));
state=get(handles.fieldcb,'value');
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));

%checks to see which field distribution is being plotted with each change in x-slider
%position and plots to sagital axes
if run>0
    if pop==1
        if state==1
            clear Bplane
            axes(handles.axes1)
            Bplane(:,:)=Bnuc(x,:,:);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if x<=xROImax && x>=xROImin
                sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
            end
            clear x;
        else
            clear Bplane
            axes(handles.axes1)
            Bplane(:,:)=Bhead(x,:,:);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if x<=xROImax && x>=xROImin
                sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
            end
            clear x;
        end
    end
    if pop==2
        if count>=2
            clear Xxp;
            Xxp(:,:)=X(x,:,:);
            Xxp=flipdim(rot90(Xxp,3),2);
            axes(handles.axes1)
            pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear x;
        end
    end
else
    if pop==1
        clear hx
        axes(handles.axes1)
        hx(:,:)=head(x,:,:);
        hx=flipdim(rot90(hx,3),2);
        clear x;
        pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
    end
    if pop==2
        if count>=2
            clear Xxp;
            Xxp(:,:)=X(x,:,:);
            Xxp=flipdim(rot90(Xxp,3),2);
            clear x;
            axes(handles.axes1)
            pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        end
    end
end
else 
    x=str2num(get(handles.xedit,'string'));
    set(handles.xslider,'value',x);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% --- Executes during object creation, after setting all properties.
function xslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function yslider_Callback(hObject, eventdata, handles)
% hObject    handle to yslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global run;
global Bnuc;
global v;
global Bhead head;
global X;
global count correct inputInfo rect;
if isempty(inputInfo)
pop=get(handles.fieldpop,'value');
y=round(get(handles.yslider,'Value'));
set(handles.yedit,'string',sprintf('%1.0f',y));
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
state=get(handles.fieldcb,'value');
%checks to see which field distribution is being plotted with each change in y-slider
%position and plots to coronal axes
if run>0
    if pop==1
        if state==1
            clear Bplane
            axes(handles.axes2)
            Bplane(:,:)=Bnuc(:,y,:);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if y<=yROImax && y>=yROImin
                correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
            end
            clear y;
        else
            clear Bplane
            axes(handles.axes2)
            Bplane(:,:)=Bhead(:,y,:);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if y<=yROImax && y>=yROImin
                correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
            end
            clear y;
        end
    end
    if pop==2
        if count>=2
            clear Xyp;
            Xyp(:,:)=X(:,y,:);
            Xyp=flipdim(rot90(Xyp,3),2);
            axes(handles.axes2)
            pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear y;
        end
    end
else
    if pop==2
        if count>=2
            clear Xyp;
            Xyp(:,:)=X(:,y,:);
            Xyp=flipdim(rot90(Xyp,3),2);
            axes(handles.axes2)
            pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear y;
        end
    end
    if pop==1
        clear hy
        axes(handles.axes2)
        hy(:,:)=head(:,y,:);
        hy=flipdim(rot90(hy,3),2);
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        clear y;
    end
end
else 
    x=str2num(get(handles.yedit,'string'));
    set(handles.yslider,'value',x);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% --- Executes during object creation, after setting all properties.
function yslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function zslider_Callback(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global run;
global Bnuc;
global v;
global Bhead head;
global X;
global count axrect inputInfo rect;
if isempty(inputInfo)
pop=get(handles.fieldpop,'value');
z=round(get(handles.zslider,'Value'));
set(handles.zedit,'string',sprintf('%1.0f',z));
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
state=get(handles.fieldcb,'value');
%checks to see which field distribution is being plotted with each change in z-slider
%position and plots to axial axes
if run>0
    if pop==1
        if state==1
            clear Bplane
            axes(handles.axes3)
            Bplane(:,:)=Bnuc(:,:,z);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if z<=zROImax && z>=zROImin
                axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
            end
            clear z;
        else
            clear Bplane
            axes(handles.axes3)
            Bplane(:,:)=Bhead(:,:,z);
            Bplane=flipdim(rot90(Bplane,3),2);
            pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            if z<=zROImax && z>=zROImin
                axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
            end
            clear z;
        end
    end
    if pop==2
        if count>=2
            clear Xzp;
            Xzp(:,:)=X(:,:,z);
            Xzp=flipdim(rot90(Xzp,3),2);
            axes(handles.axes3)
            pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear z;
            set(handles.status,'String','');
        end
    end
else
    if pop==1
        clear hz
        axes(handles.axes3)
        hz(:,:)=head(:,:,z);
        hz=flipdim(rot90(hz,3),2);
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
    end
    if pop==2
        if count>=2
            clear Xzp;
            Xzp(:,:)=X(:,:,z);
            Xzp=flipdim(rot90(Xzp,3),2);
            axes(handles.axes3)
            pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear z;
            set(handles.status,'String','');
        end
    end
end
else 
    x=str2num(get(handles.zedit,'string'));
    set(handles.zslider,'value',x);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% --- Executes during object creation, after setting all properties.
function zslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function xedit_Callback(hObject, eventdata, handles)
% hObject    handle to xedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of xedit as text
%        str2double(get(hObject,'String')) returns contents of xedit as a double
global run;
global Bnuc;
global v;
global Bhead head;
global X;
global count sagrect inputInfo rect
if isempty(inputInfo)
pop=get(handles.fieldpop,'value');
x=round(str2num(get(hObject,'string')));
set(hObject,'string',sprintf('%1.0f',x))
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
if x<=length(Bnuc)||x<=length(Bhead)||x<=length(X)||x<=length(head)&&x>0
    set(handles.xslider,'value',x);
    state=get(handles.fieldcb,'value');
    %checks to see which field distribution is being plotted with each change in x-slider
    %position and plots to saggital axes
    if run>0
        if pop==1
            if state==1
                clear Bplane
                axes(handles.axes1)
                Bplane(:,:)=Bnuc(x,:,:);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if x<=xROImax && x>=xROImin
                    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
                end
                clear x;
            else
                clear Bplane
                axes(handles.axes1)
                Bplane(:,:)=Bhead(x,:,:);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if x<=xROImax && x>=xROImin
                    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
                end
                clear x;
            end
        end
    else
        if pop==2
            if count>=2
                clear Xxp;
                Xxp(:,:)=X(x,:,:);
                Xxp=flipdim(rot90(Xxp,3),2);
                axes(handles.axes1)
                pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                clear x;
            end
        end
        if pop==1
            clear hx
            axes(handles.axes1)
            hx(:,:)=head(x,:,:);
            hx=flipdim(rot90(hx,3),2);
            pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear x;
        end
    end
else
    errordlg('Position exceeds matrix dimensions','Index error');
end
else 
    set(handles.xedit,'enable','inactive');
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% --- Executes during object creation, after setting all properties.
function xedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yedit_Callback(hObject, eventdata, handles)
% hObject    handle to yedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of yedit as text
%        str2double(get(hObject,'String')) returns contents of yedit as a double
global run;
global Bnuc;
global v;
global Bhead;
global X head;
global count correct inputInfo rect
if isempty(inputInfo)
pop=get(handles.fieldpop,'value');
y=round(str2num(get(hObject,'string')));
set(hObject,'string',sprintf('%1.0f',y))
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
if y<=length(Bnuc)||y<=length(Bhead)||y<=length(X)||y<=length(head)&&y>0
    set(handles.yslider,'value',y);
    state=get(handles.fieldcb,'value');
    %checks to see which field distribution is being plotted with each change in y-slider
    %position and plots to coronal axes
    if run>0
        if pop==1
            if state==1
                clear Bplane
                axes(handles.axes2)
                Bplane(:,:)=Bnuc(:,y,:);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if y<=yROImax && y>=yROImin
                    correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
                end
                clear y;
            else
                clear Bplane
                axes(handles.axes2)
                Bplane(:,:)=Bhead(:,y,:);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if y<=yROImax && y>=yROImin
                correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
                end
                clear y;
            end
        end
        if pop==2
            if count>=2
                clear Xyp;
                Xyp(:,:)=X(:,y,:);
                Xyp=flipdim(rot90(Xyp,3),2);
                axes(handles.axes2)
                pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                clear y;
            end
        end
    else
        if pop==2
            if count>=2
                clear Xyp;
                Xyp(:,:)=X(:,y,:);
                Xyp=flipdim(rot90(Xyp,3),2);
                axes(handles.axes2)
                pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                clear y;
            end
        end
        if pop==1
            clear hy
            axes(handles.axes2)
            hy(:,:)=head(:,y,:);
            hy=flipdim(rot90(hy,3),2);
            pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear y;
        end
    end
else
    errordlg('Position exceeds matrix dimensions','Index error');
end
else 
    set(handles.yedit,'enable','inactive');
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% --- Executes during object creation, after setting all properties.
function yedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit_Callback(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of zedit as text
%        str2double(get(hObject,'String')) returns contents of zedit as a double
global run;
global Bnuc;
global v;
global Bhead head;
global X;
global count axrect inputInfo rect
if isempty(inputInfo)
z=round(str2num(get(handles.zedit,'string')));
set(hObject,'string',sprintf('%1.0f',z))
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
if z<=length(Bnuc)||z<=length(Bhead)||z<=length(X)||z<=length(head)&&z>0
    set(handles.zslider,'value',z);
    state=get(handles.fieldcb,'value');
    pop=get(handles.fieldpop,'value');
    %checks to see which field distribution is being plotted with each change in z-slider
    %position and plots axial axes
    if run>0
        if pop==1
            if state==1
                clear Bplane
                axes(handles.axes3)
                Bplane(:,:)=Bnuc(:,:,z);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if z<=zROImax && z>=zROImin
                    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
                end
                clear z;
            else
                clear Bplane
                axes(handles.axes3)
                Bplane(:,:)=Bhead(:,:,z);
                Bplane=flipdim(rot90(Bplane,3),2);
                pcolor(Bplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                if z<=zROImax && z>=zROImin
                    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
                end
                clear z;
            end
        end
        if pop==2
            if count>=2
                clear Xzp;
                Xzp(:,:)=X(:,:,z);
                Xzp=flipdim(rot90(Xzp,3),2);
                axes(handles.axes3)
                pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                clear z;
                set(handles.status,'String','');
            end
        end
    else
        if pop==1
            clear hz
            axes(handles.axes3)
            hz(:,:)=head(:,:,z);
            hz=flipdim(rot90(hz,3),2);
            pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
            clear z;
        end
        if pop==2
            if count>=2
                clear Xzp;
                Xzp(:,:)=X(:,:,z);
                Xzp=flipdim(rot90(Xzp,3),2);
                axes(handles.axes3)
                pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                clear z;
                set(handles.status,'String','');
            end
        end
    end
else
    errordlg('Position exceeds matrix dimensions','Index error');
end
else 
    set(handles.zedit,'enable','inactive');
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% --- Executes during object creation, after setting all properties.
function zedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runpb.
function runpb_Callback(hObject, eventdata, handles)
% hObject    handle to runpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X head Bnuc Bhead run v xmin_max ymin_max zmin_max inputInfo rect
if isempty(inputInfo)
    set(handles.iso_x,'enable','on');
    set(handles.iso_y,'enable','on');
    set(handles.iso_z,'enable','on');
    set(handles.xedit,'enable','on');
    set(handles.yedit,'enable','on');
    set(handles.zedit,'enable','on');
    set(handles.xslider,'enable','on');
    set(handles.yslider,'enable','on');
    set(handles.zslider,'enable','on');
end
clear inputInfo
pause(.001);
set(handles.status,'String','Processing.'); 
pause(.001);
%checks to see if field lines are included or not
state=get(handles.fieldcb,'value');

algorithmSelect(run,handles)
set(handles.algorithmSelect,'enable','off');

% Bnuc=fftshift(X);
% Bnuc=fftn(Bnuc);
% pause(.001);
% set(handles.status,'String','Processing..'); 
% pause(.001);
% clear X
% Bnuc=fftshift(Bnuc);
% p=((size(Bnuc)/2)+.5);
% pause(.001);
% set(handles.status,'String','Processing...'); 
% pause(.001);
% %build k matrix
% s=size(Bnuc);
% [x,y,z] = ndgrid(1:s(1,1),1:s(1,2),1:s(1,3));
% kznorm=(z-p(1,3)).^2./((x-p(1,1)).^2+(y-p(1,2)).^2+(z-p(1,3)).^2);
% clear p l s
% kznorm=1/3-kznorm;
% clear x y z;
% pause(.001);
% set(handles.status,'String','Processing.'); 
% pause(.001);
% Bnuc=kznorm.*Bnuc;
% clear kznorm;
% Bnuc=ifftshift(Bnuc);
% pause(.001);
% set(handles.status,'String','Processing..'); 
% pause(.001);
% Bnuc=ifftn(Bnuc);
% Bnuc=ifftshift(Bnuc);

% %% Algorithm developed by Rahul
% 
% % Setup matrix size parameters
% %  susc = susceptibility distribution (should be standard cubical size, 
% %  like 128x128x128 or 256x256x256)
% %  suscBackground = background value of susceptibility distribution 
% %  (usually air, 0.4 ppm)
% %  Output:
% %  B0Image = dB0 field
% suscBackground=.4e-06;
% 
% 
% [xRes yRes zRes] = size(X);
% 
% % Setup Green's function modifier matrix (called kMod here)
% 
% origin = [xRes yRes zRes] ./2 + 1;
% [ky kx kz] = meshgrid(1:yRes, 1:xRes, 1:zRes);
% kx = kx - origin(1);
% ky = ky - origin(2);
% kz = kz - origin(3);
% pause(.001);
% set(handles.status,'String','Processing..'); 
% pause(.001);
% kr2 = kx.^2 + ky.^2 + kz.^2;
% kModImage = 1./(4.*pi) .* (3.*kz.^2 - kr2) ./ (kr2.^(5/2));
% kModImage(origin(1), origin(2), origin(3)) = 0;
% pause(.001);
% set(handles.status,'String','Processing...'); 
% pause(.001);
% kMod = fftshift((fftn(fftshift(kModImage))));
% pause(.001);
% set(handles.status,'String','Processing.'); 
% pause(.001);
% 
% % Calculate dB0 field from susceptibility
% 
% B0Image = kMod .* fftshift(fftn(X));
% pause(.001);
% set(handles.status,'String','Processing..'); 
% pause(.001);
% B0Image(origin(1), origin(2), origin(3)) = ...
%     suscBackground ./ 3 .* xRes .* yRes .* zRes;   % background correction as per Marques/Bowtell
% B0Image = real(ifftn(ifftshift(B0Image)));
% %%
% Bnuc=real(B0Image);
Bhead=Bnuc;
%creates dB matrix without field  lines
Bhead=(head~=0).*Bhead;
% clear head;
pause(.001);
set(handles.status,'String','Processing...'); 
pause(.001);
run=1;
%get slider position values
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
%checks to see which field distribution is being plotted, if dB is selected
%checks to see if field lines are plotted and plots db0 maps
pop=get(handles.fieldpop,'value');
if pop==1
    if state==1
        axes(handles.axes1)%plots sagital axes
        Bxplane(:,:)=Bnuc(x,:,:);
        Byplane(:,:)=Bnuc(:,y,:);
        Bzplane(:,:)=Bnuc(:,:,z);
        %rotates geometry 270 degrees clockwise
        Bxplane=flipdim(rot90(Bxplane,3),2);
        Byplane=flipdim(rot90( Byplane,3),2);
        Bzplane=flipdim(rot90(Bzplane,3),2);
        pcolor(Bxplane);shading flat;axis off;colormap jet2;axis equal
        %defines colorscale
        v=caxis;
        %sets colorscale sliders and edit boxes to colorscale value
        set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
        set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
        set(handles.csminslider,'value',v(1,1)*10^6);
        set(handles.csmaxslider,'value',v(1,2)*10^6);
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal axes
        pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots axial axes
        pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends colorbar to axes5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
        clear Bxplane Byplane Bzplane;
    else
        axes(handles.axes1)
        Bxhp(:,:)=Bhead(x,:,:);
        Byhp(:,:)=Bhead(:,y,:);
        Bzhp(:,:)=Bhead(:,:,z);
        Bxhp=flipdim(rot90(Bxhp,3),2);
        Byhp=flipdim(rot90(Byhp,3),2);
        Bzhp=flipdim(rot90(Bzhp,3),2);
        pcolor(Bxhp);shading flat;axis off;colormap jet2;axis equal
        v=caxis;
        set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
        set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
        set(handles.csminslider,'value',v(1,1)*10^6);
        set(handles.csmaxslider,'value',v(1,2)*10^6);
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)
        pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)
        pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
        clear Bxhp Byhp Bzhp;
    end
end

set(handles.xROImin,'string',sprintf('%1.0f',min(xmin_max)));
set(handles.xROImax,'string',sprintf('%1.0f',max(xmin_max)));
set(handles.yROImin,'string',sprintf('%1.0f',min(ymin_max)));
set(handles.yROImax,'string',sprintf('%1.0f',max(ymin_max)));
set(handles.zROImin,'string',sprintf('%1.0f',min(zmin_max)));
set(handles.zROImax,'string',sprintf('%1.0f',max(zmin_max)));
set(handles.xROImin,'enable','on');
set(handles.xROImax,'enable','on');
set(handles.yROImin,'enable','on');
set(handles.yROImax,'enable','on');
set(handles.zROImin,'enable','on');
set(handles.zROImax,'enable','on');

global sagrect axrect correct
axes(handles.axes1)
sagrect=rectangle('position',[min(ymin_max) min(zmin_max) max(ymin_max)-min(ymin_max) max(zmin_max)-min(zmin_max)]);

axes(handles.axes2)
correct=rectangle('position',[min(xmin_max) min(zmin_max) max(xmin_max)-min(xmin_max) max(zmin_max)-min(zmin_max)]);

axes(handles.axes3)
axrect=rectangle('position',[min(xmin_max) min(ymin_max) max(xmin_max)-min(xmin_max) max(ymin_max)-min(ymin_max)]);
clear x y z;
set(handles.autoshimpb,'enable','on')
set(handles.savepb,'enable','on')
set(handles.status,'String','');
set(handles.matrixedit,'enable','on');
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');




% --- Executes on button press in exitpb.
function exitpb_Callback(hObject, eventdata, handles)
% hObject    handle to exitpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% clear all
clear global Bnuc Bhead axrect correct sagrect count head X xmin_max ymin_max zmin_max run
close B0Solver

clc


% --- Executes on button press in fieldcb.
function fieldcb_Callback(hObject, eventdata, handles)
% hObject    handle to fieldcb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bnuc;
global Bhead;
global run;
global v;
global xmin_max ymin_max zmin_max rect;
%checks if sim has been run, if run plots the field dist with or without
%field lines depending on user selection.(default display is without field
%lines)
if run>0
    state=get(handles.fieldcb,'value');
    x=round(get(handles.xslider,'Value'));
    y=round(get(handles.yslider,'Value'));
    z=round(get(handles.zslider,'Value'));
    pop=get(handles.fieldpop,'value');
    if pop==1
        if state==1
            axes(handles.axes1)%plots saggital axes
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            %rotates geometry 270 degrees clockwise
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90( Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes5)%deletes colorbar
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)%plots coronal axes
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)%plots axial axes
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            %sends new colorbar to axes5
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)%plots saggital
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            %rotates geometry 270 degrees clockwise
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes5)%deletes old colorbar
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)%plots coronal
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)%plots axial
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            %sends new colorbar to axes5
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
    end
end
global sagrect axrect correct
axes(handles.axes1)
sagrect=rectangle('position',[min(ymin_max) min(zmin_max) max(ymin_max)-min(ymin_max) max(zmin_max)-min(zmin_max)]);

axes(handles.axes2)
correct=rectangle('position',[min(xmin_max) min(zmin_max) max(xmin_max)-min(xmin_max) max(zmin_max)-min(zmin_max)]);

axes(handles.axes3)
axrect=rectangle('position',[min(xmin_max) min(ymin_max) max(xmin_max)-min(xmin_max) max(ymin_max)-min(ymin_max)]);
clear x y z;
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% Hint: get(hObject,'Value') returns toggle state of fieldcb


% --- Executes on selection change in fieldpop.
function fieldpop_Callback(hObject, eventdata, handles)
% hObject    handle to fieldpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X run Bnuc Bhead v head rect;

pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
state=get(handles.fieldcb,'value');
name=get(handles.suscedit,'string');
%cheacks to see which dist field user wants plotted, if sim hasnt been run
%amd user selects dB0, plots a black screen
if pop==2 && ~strcmp(name,'Susceptibility Filename')
    clear Xxp Xyp Xzp;
    Xxp(:,:)=X(x,:,:);
    Xyp(:,:)=X(:,y,:);
    Xzp(:,:)=X(:,:,z);
    clear x y z;
    Xxp=flipdim(rot90(Xxp,3),2);
    Xyp=flipdim(rot90(Xyp,3),2);
    Xzp=flipdim(rot90(Xzp,3),2);
    axes(handles.axes1)
    pcolor(Xxp);shading flat;axis off;colormap jet2;axis equal
    v=caxis;
    set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
    set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
    set(handles.csminslider,'value',v(1,1)*10^6);
    set(handles.csmaxslider,'value',v(1,2)*10^6);
    axes(handles.axes5)
    colorbar('delete')
    caxis(v);
    axes(handles.axes2)
    pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
    axes(handles.axes3)
    pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
    colorbar('peer',handles.axes5,'location','north')
    set(handles.status,'String','');
elseif pop==1
    if  run>0
        if state==1
            axes(handles.axes5)
            colorbar('delete')
            axes(handles.axes1)
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            clear x y z;
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90(Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;axis equal
            v=caxis;  
            set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
            set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
            set(handles.csminslider,'value',v(1,1)*10^6);
            set(handles.csmaxslider,'value',v(1,2)*10^6);
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            clear x y z;
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;axis equal
            v=caxis;
            set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
            set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
            set(handles.csminslider,'value',v(1,1)*10^6);
            set(handles.csmaxslider,'value',v(1,2)*10^6);
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
        xROImin=str2num(get(handles.xROImin,'String'));
        xROImax=str2num(get(handles.xROImax,'String'));
        yROImin=str2num(get(handles.yROImin,'String'));
        yROImax=str2num(get(handles.yROImax,'String'));
        zROImin=str2num(get(handles.zROImin,'String'));
        zROImax=str2num(get(handles.zROImax,'String'));
        global sagrect axrect correct
        axes(handles.axes1)
        sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
        
        axes(handles.axes2)
        correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
        
        axes(handles.axes3)
        axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
    else
        hx(:,:)=head(x,:,:);
        hx=flipdim(rot90(hx,3),2);
        hy(:,:)=head(:,y,:);
        hy=flipdim(rot90(hy,3),2);
        hz(:,:)=head(:,:,z);
        hz=flipdim(rot90(hz,3),2);
        axes(handles.axes1)%plots sagital X map
        pcolor(hx);shading flat;axis off;colormap jet2;axis equal
        v=caxis;%sets color scale
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal X map
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
    

% Hints: contents = get(hObject,'String') returns fieldpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fieldpop


% --- Executes during object creation, after setting all properties.
function fieldpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fieldpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function csminslider_Callback(hObject, eventdata, handles)
% hObject    handle to csminslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count X run Bnuc Bhead v head rect;

x=get(handles.csminslider,'Value');
set(handles.csminedit,'string',sprintf('%.1f',x));
%rescale colorscale edit value
v(1,1)=x*10^-6;
pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
state=get(handles.fieldcb,'value');
%plots the axes with new colorscale values
if pop==2 
    if count>=2
        clear Xxp Xyp Xzp;
        Xxp(:,:)=X(x,:,:);
        Xyp(:,:)=X(:,y,:);
        Xzp(:,:)=X(:,:,z);
        clear x y z;
        Xxp=flipdim(rot90(Xxp,3),2);       
        Xyp=flipdim(rot90(Xyp,3),2);
        Xzp=flipdim(rot90(Xzp,3),2);
        axes(handles.axes1)
        pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)
        pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)
        pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
if pop==1
    if  run>0
        if state==1
            axes(handles.axes5)
            colorbar('delete')
            axes(handles.axes1)
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            clear x y z;
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90( Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal 
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            clear x y z;
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal        
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
    else
        v(1,1)=v(1,1)*10^6;
        axes(handles.axes1)%plots sagital X map
        hx(:,:)=head(x,:,:);
        hy(:,:)=head(:,y,:);
        hz(:,:)=head(:,:,z);
        clear x y z
        hx=flipdim(rot90(hx,3),2);
        hy=flipdim(rot90(hy,3),2);
        hz=flipdim(rot90(hz,3),2);
        pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal X map
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots axial
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
global sagrect axrect correct
if run>0
    axes(handles.axes1)
    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
    
    axes(handles.axes2)
    correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
    
    axes(handles.axes3)
    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function csminslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csminslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function csminedit_Callback(hObject, eventdata, handles)
% hObject    handle to csminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count X run Bnuc Bhead v head rect;

x1=str2num(get(hObject,'string'));
x2=str2num(get(handles.csmaxedit,'string'));
if x1>=x2
    errordlg('Min value must be less than max value','Error')
    return
end
if x1<=40 && x1>=-40
set(handles.csminslider,'value',x1);
v(1,1)=x1*10^-6;
pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
state=get(handles.fieldcb,'value');
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
%plots axes with new colorscale
if pop==2 
    if count>=2
        clear Xxp Xyp Xzp;
        Xxp(:,:)=X(x,:,:);
        Xyp(:,:)=X(:,y,:);
        Xzp(:,:)=X(:,:,z);
        clear x y z;
        Xxp=flipdim(rot90(Xxp,3),2);
        Xyp=flipdim(rot90(Xyp,3),2);
        Xzp=flipdim(rot90(Xzp,3),2);
        axes(handles.axes1)
        pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)
        pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)
        pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
if pop==1
    if  run>0
        if state==1
            axes(handles.axes5)
            colorbar('delete')
            axes(handles.axes1)
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            clear x y z;
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90( Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal 
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            clear x y z;
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal          
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
    else
        v(1,1)=x1;
        axes(handles.axes1)%plots sagital X map
        hx(:,:)=head(x,:,:);
        hy(:,:)=head(:,y,:);
        hz(:,:)=head(:,:,z);
        clear x y z
        hx=flipdim(rot90(hx,3),2);
        hy=flipdim(rot90(hy,3),2);
        hz=flipdim(rot90(hz,3),2);
        pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal X map
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots axial
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
else
    errordlg('Index exceeds color scale','Index error')
end
global sagrect axrect correct
if run>0
    axes(handles.axes1)
    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
    
    axes(handles.axes2)
    correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
    
    axes(handles.axes3)
    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% Hints: get(hObject,'String') returns contents of csminedit as text
%        str2double(get(hObject,'String')) returns contents of csminedit as a double


% --- Executes during object creation, after setting all properties.
function csminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function csmaxslider_Callback(hObject, eventdata, handles)
% hObject    handle to csmaxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count X run Bnuc Bhead v head rect;

x=get(handles.csmaxslider,'Value');
set(handles.csmaxedit,'string',sprintf('%.1f',x));
v(1,2)=x*10^-6;
pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
state=get(handles.fieldcb,'value');
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
%plots axes with new colorscale values
if pop==2 
    if count>=2
        clear Xxp Xyp Xzp;
        Xxp(:,:)=X(x,:,:);
        Xyp(:,:)=X(:,y,:);
        Xzp(:,:)=X(:,:,z);
        clear x y z;
        Xxp=flipdim(rot90(Xxp,3),2);
        Xyp=flipdim(rot90(Xyp,3),2);
        Xzp=flipdim(rot90(Xzp,3),2);
        axes(handles.axes1)
        pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)
        pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)
        pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
if pop==1
    if  run>0
        if state==1
            axes(handles.axes5)
            colorbar('delete')
            axes(handles.axes1)
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            clear x y z;
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90(Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal 
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            clear x y z;
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal           
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
    else
        v(1,2)=v(1,2)*10^6;
        axes(handles.axes1)%plots sagital X map
        hx(:,:)=head(x,:,:);
        hy(:,:)=head(:,y,:);
        hz(:,:)=head(:,:,z);
        clear x y z
        hx=flipdim(rot90(hx,3),2);
        hy=flipdim(rot90(hy,3),2);
        hz=flipdim(rot90(hz,3),2);
        pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal X map
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots axial
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
if run>0
    axes(handles.axes1)
    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
    
    axes(handles.axes2)
    correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
    
    axes(handles.axes3)
    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function csmaxslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csmaxslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function csmaxedit_Callback(hObject, eventdata, handles)
% hObject    handle to csmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count X run Bnuc Bhead v head rect;

x1=str2num(get(hObject,'string'));
x2=str2num(get(handles.csminedit,'string'));
if x1<=x2
    errordlg('Min value must be less than max value','Error')
    return
end
if x1<=40 && x1>=-40
set(handles.csmaxslider,'value',x1);
v(1,2)=x1*10^-6;
pop=get(handles.fieldpop,'value');
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
state=get(handles.fieldcb,'value');
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
%plots axes with new colorscale values
if pop==2 
    if count>=2
        clear Xxp Xyp Xzp;
        Xxp(:,:)=X(x,:,:);
        Xyp(:,:)=X(:,y,:);
        Xzp(:,:)=X(:,:,z);
        clear x y z;
        Xxp=flipdim(rot90(Xxp,3),2);
        Xyp=flipdim(rot90(Xyp,3),2);
        Xzp=flipdim(rot90(Xzp,3),2);
        axes(handles.axes1)
        pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)
        pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)
        pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
if pop==1
    if  run>0
        if state==1
            axes(handles.axes5)
            colorbar('delete')
            axes(handles.axes1)
            Bxplane(:,:)=Bnuc(x,:,:);
            Byplane(:,:)=Bnuc(:,y,:);
            Bzplane(:,:)=Bnuc(:,:,z);
            clear x y z;
            Bxplane=flipdim(rot90(Bxplane,3),2);
            Byplane=flipdim(rot90(Byplane,3),2);
            Bzplane=flipdim(rot90(Bzplane,3),2);
            pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal 
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        else
            axes(handles.axes1)
            Bxhp(:,:)=Bhead(x,:,:);
            Byhp(:,:)=Bhead(:,y,:);
            Bzhp(:,:)=Bhead(:,:,z);
            clear x y z;
            Bxhp=flipdim(rot90(Bxhp,3),2);
            Byhp=flipdim(rot90(Byhp,3),2);
            Bzhp=flipdim(rot90(Bzhp,3),2);
            pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal            
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            set(handles.status,'String','');
        end
    else
        v(1,2)=x1;
        axes(handles.axes1)%plots sagital X map
        hx(:,:)=head(x,:,:);
        hy(:,:)=head(:,y,:);
        hz(:,:)=head(:,:,z);
        clear x y z
        hx=flipdim(rot90(hx(:,:),3),2);
        hy=flipdim(rot90(hy(:,:),3),2);
        hz=flipdim(rot90(hz(:,:),3),2);
        pcolor(hx);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes5)
        colorbar('delete')
        caxis(v);
        axes(handles.axes2)%plots coronal X map
        pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
        axes(handles.axes3)%plots axial
        pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
        %sends the colorbar to axis 5
        colorbar('peer',handles.axes5,'location','north')
        set(handles.status,'String','');
    end
end
else
    errordlg('Index exceeds color scale','Index error')
end
global sagrect axrect correct
if run>0
    axes(handles.axes1)
    sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
    
    axes(handles.axes2)
    correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
    
    axes(handles.axes3)
    axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
% Hints: get(hObject,'String') returns contents of csmaxedit as text
%        str2double(get(hObject,'String')) returns contents of csmaxedit as a double


% --- Executes during object creation, after setting all properties.
function csmaxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to csmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xpad_Callback(hObject, eventdata, handles)
% hObject    handle to xpad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xpad=str2double(get(hobject,'string'));
% Hints: get(hObject,'String') returns contents of xpad as text
%        str2double(get(hObject,'String')) returns contents of xpad as a double


% --- Executes during object creation, after setting all properties.
function xpad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ypad_Callback(hObject, eventdata, handles)
% hObject    handle to ypad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ypad as text
%        str2double(get(hObject,'String')) returns contents of ypad as a double


% --- Executes during object creation, after setting all properties.
function ypad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zpad_Callback(hObject, eventdata, handles)
% hObject    handle to zpad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zpad as text
%        str2double(get(hObject,'String')) returns contents of zpad as a double


% --- Executes during object creation, after setting all properties.
function zpad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zpad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in padpop.
function padpop_Callback(hObject, eventdata, handles)
% hObject    handle to padpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global count
global X
global run
global v
global Bnuc Bhead head
p=(length(X)/2);
pop=get(handles.fieldpop,'value');
state=get(handles.fieldcb,'value');
pad=get(handles.padpop,'value');
%pop up menu that allows users to specify zero matrix size. if the sim
%hasnt run, it defines initial zero matrix, else it redifines the field of
%view, when matrix size is decreased, field line data is deleted.
if count ==1  
    p=(length(head)/2);
    switch pad
        case 1
            w=64;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 2
            w=128;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 3 
            w=150;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 4
            w=175;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 5
            w=200;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 6
            w=225;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 7
            w=250;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 8
            w=275;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 9
            w=300;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 10
            w=350;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
        case 11
            w=400;
            if length(head)>w*2
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
            end
            if length(head)<w*2
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;             
            end
    end
end
if count >=2 && run==0 
    p=(length(X)/2);
    switch pad
        case 1
            w=64;
            if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 2
            w=128;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 3
            w=150;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 4
            w=175;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 5
            w=200;
            if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 6
            w=225;
            if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 7
            w=250;
           if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 8
            w=275;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 9
            w=300;
            if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 10
            w=350;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
        case 11
            w=400;
             if length(X)>w*2
                h=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=h;
                clear h;
                h=head(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                head=h;
                clear h;
               
            end
            if length(X)<w*2
                h=0.00000040*ones(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=h;
                clear h;
                h=zeros(w*2,w*2,w*2);
                h(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=head;
                head=h;
                clear h;
                
            end
    end
end
if count >=2 && run>=1
    switch pad
        case 1
            w=64;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 2
            w=128;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 3
            w=150;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 4
            w=175;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 5
            w=200;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 6
            w=225;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 7
            w=250;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 8
            w=275;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 9
            w=300;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 10
            w=350;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
        case 11
            w=400;
            if length(X)>w*2
                x=X(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                X=x;
                clear x;
                
            end
            if length(X)<w*2
                x=0.00000040*ones(w*2,w*2,w*2);
                x(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=X;
                X=x;
                clear x;
                
            end
            if length(Bnuc)>w*2
                b=Bnuc(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bnuc=b;
                clear b;
                
            end
            if length(Bnuc)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bnuc;
                Bnuc=b;
                clear b;
               
            end
            if length(Bhead)>w*2
                b=Bhead(p-w+1:p+w,p-w+1:p+w,p-w+1:p+w);
                Bhead=b;
                clear b;

            end
            if length(Bhead)<w*2
                b=zeros(w*2,w*2,w*2);
                b(w-p+1:p+w,w-p+1:p+w,w-p+1:p+w)=Bhead;
                Bhead=b;
                clear b;

            end
    end
end

if count>=1
    l=w+w;
    %sets the sliders to new matrix dimensions
    set(handles.xslider,'max',l,'min',1,'value',w);
    set(handles.xedit,'string',sprintf('%1.0f',w));
    set(handles.yslider,'max',w*2,'min',1,'value',w);
    set(handles.yedit,'string',sprintf('%1.0f',w));
    set(handles.zslider,'max',w*2,'min',1,'value',w,'enable','on');
    set(handles.zedit,'string',sprintf('%1.0f',w));
    switch pop
        case 2         
            clear Xxp Xyp Xzp;
            Xxp(:,:)=X(w,:,:);
            Xyp(:,:)=X(:,w,:);
            Xzp(:,:)=X(:,:,w);
            clear w
            Xxp=flipdim(rot90(Xxp,3),2);
            Xyp=flipdim(rot90(Xyp,3),2);
            Xzp=flipdim(rot90(Xzp,3),2);
            axes(handles.axes1)
            pcolor(Xxp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes5)
            colorbar('delete')
            caxis(v);
            axes(handles.axes2)
            pcolor(Xyp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            axes(handles.axes3)
            pcolor(Xzp);shading flat;axis off;colormap jet2;caxis(v);axis equal
            colorbar('peer',handles.axes5,'location','north')
            clear Xxp Xyp Xzp           
        case 1
            if run>0
                if state==1
                   
                    axes(handles.axes5)
                    colorbar('delete')
                    axes(handles.axes1)
                    Bxplane(:,:)=Bnuc(w,:,:);
                    Byplane(:,:)=Bnuc(:,w,:);
                    Bzplane(:,:)=Bnuc(:,:,w);
                    clear w
                    Bxplane=flipdim(rot90(Bxplane,3),2);
                    Byplane=flipdim(rot90(Byplane,3),2);
                    Bzplane=flipdim(rot90(Bzplane,3),2);
                    pcolor(Bxplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    axes(handles.axes5)
                    colorbar('delete')
                    caxis(v);
                    axes(handles.axes2)
                    pcolor(Byplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    axes(handles.axes3)
                    pcolor(Bzplane);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    colorbar('peer',handles.axes5,'location','north')
                    clear Bxplane Byplane Bzplane
                else                   
                    axes(handles.axes1)
                    Bxhp(:,:)=Bhead(w,:,:);
                    Byhp(:,:)=Bhead(:,w,:);
                    Bzhp(:,:)=Bhead(:,:,w);
                    clear w
                    Bxhp=flipdim(rot90(Bxhp,3),2);
                    Byhp=flipdim(rot90(Byhp,3),2);
                    Bzhp=flipdim(rot90(Bzhp,3),2);
                    pcolor(Bxhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    axes(handles.axes5)
                    colorbar('delete')
                    caxis(v);
                    axes(handles.axes2)
                    pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    axes(handles.axes3)
                    pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
                    colorbar('peer',handles.axes5,'location','north')
                    clear Bxhp Byhp Bzhp
                end
            else
                hx(:,:)=head(w,:,:);
                hx=flipdim(rot90(hx(:,:),3),2);
                hy(:,:)=head(:,w,:);
                hy=flipdim(rot90(hy(:,:),3),2);
                hz(:,:)=head(:,:,w);
                hz=flipdim(rot90(hz(:,:),3),2);
                axes(handles.axes1)%plots sagital X map
                pcolor(hx);shading flat;axis off;colormap jet2;axis equal
                c=caxis;%sets color scale
                axes(handles.axes5)
                colorbar('delete')
                caxis(c);
                %sets colorscale edit and sliders to colorscale value
                set(handles.csmaxedit,'string',sprintf('%.1f',max(c)));
                set(handles.csminedit,'string',sprintf('%.1f',min(c)));
                set(handles.csminslider,'value',min(c));
                set(handles.csmaxslider,'value',max(c));
                axes(handles.axes2)%plots coronal X map
                pcolor(hy);shading flat;axis off;colormap jet2;caxis(c);axis equal
                axes(handles.axes3)%plots
                pcolor(hz);shading flat;axis off;colormap jet2;caxis(c);axis equal
                %sends the colorbar to axis 5
                colorbar('peer',handles.axes5,'location','north')
                set(handles.status,'String','');
            end           
    end
end


% Hints: contents = get(hObject,'String') returns padpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from padpop


% --- Executes during object creation, after setting all properties.
function padpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to padpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xgrad.
function xgrad_Callback(hObject, eventdata, handles)
% hObject    handle to xgrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in ygrad.
function ygrad_Callback(hObject, eventdata, handles)
% hObject    handle to ygrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zgrad.
function zgrad_Callback(hObject, eventdata, handles)
% hObject    handle to zgrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function xgradedit_Callback(hObject, eventdata, handles)
% hObject    handle to xgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xgradedit as text
%        str2double(get(hObject,'String')) returns contents of xgradedit as a double


% --- Executes during object creation, after setting all properties.
function xgradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ygradedit_Callback(hObject, eventdata, handles)
% hObject    handle to ygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ygradedit as text
%        str2double(get(hObject,'String')) returns contents of ygradedit as a double


% --- Executes during object creation, after setting all properties.
function ygradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zgradedit_Callback(hObject, eventdata, handles)
% hObject    handle to zgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zgradedit as text
%        str2double(get(hObject,'String')) returns contents of zgradedit as a double


% --- Executes during object creation, after setting all properties.
function zgradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xygrad.
function xygrad_Callback(hObject, eventdata, handles)
% hObject    handle to xygrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in yzgrad.
function yzgrad_Callback(hObject, eventdata, handles)
% hObject    handle to yzgrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in xzgrad.
function xzgrad_Callback(hObject, eventdata, handles)
% hObject    handle to xzgrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function xygradedit_Callback(hObject, eventdata, handles)
% hObject    handle to xygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xygradedit as text
%        str2double(get(hObject,'String')) returns contents of xygradedit as a double


% --- Executes during object creation, after setting all properties.
function xygradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yzgradedit_Callback(hObject, eventdata, handles)
% hObject    handle to yzgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yzgradedit as text
%        str2double(get(hObject,'String')) returns contents of yzgradedit as a double


% --- Executes during object creation, after setting all properties.
function yzgradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yzgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xzgradedit_Callback(hObject, eventdata, handles)
% hObject    handle to xzgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xzgradedit as text
%        str2double(get(hObject,'String')) returns contents of xzgradedit as a double


% --- Executes during object creation, after setting all properties.
function xzgradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xzgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in z2grad.
function z2grad_Callback(hObject, eventdata, handles)
% hObject    handle to z2grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in z2xgrad.
function z2xgrad_Callback(hObject, eventdata, handles)
% hObject    handle to z2xgrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in z2ygrad.
function z2ygrad_Callback(hObject, eventdata, handles)
% hObject    handle to z2ygrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function z2gradedit_Callback(hObject, eventdata, handles)
% hObject    handle to z2gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2gradedit as text
%        str2double(get(hObject,'String')) returns contents of z2gradedit as a double


% --- Executes during object creation, after setting all properties.
function z2gradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z2gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z2xgradedit_Callback(hObject, eventdata, handles)
% hObject    handle to z2xgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2xgradedit as text
%        str2double(get(hObject,'String')) returns contents of z2xgradedit as a double


% --- Executes during object creation, after setting all properties.
function z2xgradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z2xgradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z2ygradedit_Callback(hObject, eventdata, handles)
% hObject    handle to z2ygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z2ygradedit as text
%        str2double(get(hObject,'String')) returns contents of z2ygradedit as a double


% --- Executes during object creation, after setting all properties.
function z2ygradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z2ygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in z3grad.
function z3grad_Callback(hObject, eventdata, handles)
% hObject    handle to z3grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in zxygrad.
function zxygrad_Callback(hObject, eventdata, handles)
% hObject    handle to zxygrad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in x2y2grad.
function x2y2grad_Callback(hObject, eventdata, handles)
% hObject    handle to x2y2grad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function z3gradedit_Callback(hObject, eventdata, handles)
% hObject    handle to z3gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z3gradedit as text
%        str2double(get(hObject,'String')) returns contents of z3gradedit as a double


% --- Executes during object creation, after setting all properties.
function z3gradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z3gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zxygradedit_Callback(hObject, eventdata, handles)
% hObject    handle to zxygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zxygradedit as text
%        str2double(get(hObject,'String')) returns contents of zxygradedit as a double


% --- Executes during object creation, after setting all properties.
function zxygradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zxygradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x2y2gradedit_Callback(hObject, eventdata, handles)
% hObject    handle to x2y2gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x2y2gradedit as text
%        str2double(get(hObject,'String')) returns contents of x2y2gradedit as a double


% --- Executes during object creation, after setting all properties.
function x2y2gradedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x2y2gradedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in autoshimpb.
function autoshimpb_Callback(hObject, eventdata, handles)
global Bhead;
global x y z xy yz xz z2 z2x z2y z3 zxy x2y2 A;
set(handles.status,'string','Processing...')
pause(.001)
set(handles.xgradedit,'string','')
set(handles.ygradedit,'string','')
set(handles.zgradedit,'string','')
set(handles.xygradedit,'string','')
set(handles.yzgradedit,'string','')
set(handles.xzgradedit,'string','')
set(handles.z2gradedit,'string','')
set(handles.z2xgradedit,'string','')
set(handles.z2ygradedit,'string','')
set(handles.z3gradedit,'string','')
set(handles.zxygradedit,'string','')
set(handles.x2y2gradedit,'string','')
set(handles.iso_x,'enable','inactive');
set(handles.iso_y,'enable','inactive');
set(handles.iso_z,'enable','inactive');
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
x=get(handles.xgrad,'Value'); 
y=get(handles.ygrad,'Value'); 
z=get(handles.zgrad,'Value');
xy=get(handles.xygrad,'Value');
yz=get(handles.yzgrad,'Value');
xz=get(handles.xzgrad,'Value');
z2=get(handles.z2grad,'Value');
z2x=get(handles.z2xgrad,'Value');
z2y=get(handles.z2ygrad,'Value');
z3=get(handles.z3grad,'Value');
zxy=get(handles.zxygrad,'Value');
x2y2=get(handles.x2y2grad,'Value');
iso_x=str2double(get(handles.iso_x,'string'));
iso_y=str2double(get(handles.iso_y,'string'));
iso_z=str2double(get(handles.iso_z,'string'));

if x<1 && y<1 && z<1 && xy<1 && yz<1 && xz<1 && z2<1 && z2x<1 && z2y<1 && z3<1 && zxy<1 && x2y2<1
    errordlg('No gradients selected.','Error')
    return
end
lx=length(xROImin:xROImax);
ly=length(yROImin:yROImax);
lz=length(zROImin:zROImax);
l=lx*ly*lz;
disp=['x   ';'y   ';'z   ';'xy  ';'yz  ';'xz  ';'z2  ';'z2x ';'z2y ';'z3  ';'zxy ';'x2y2'];
disp=cellstr(disp);
dispval=[x;y;z;xy;yz;xz;z2;z2x;z2y;z3;zxy;x2y2];
s=size(Bhead);
if x==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    x=(i-iso_x);
    clear i j k
    x=x(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    x=reshape(x,l,1);
else
    x=[];
end
if y==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    y=(j-iso_y);
    clear i j k
    y=y(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    y=reshape(y,l,1);
else
    y=[];
end
if z==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    z=(k-iso_z);
    clear i j k
    z=z(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    z=reshape(z,l,1);
else
    z=[];
end
if xy==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    xy=(i-iso_x).*(j-iso_y);
    clear i j k
    xy=xy(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    xy=reshape(xy,l,1);
else
    xy=[];
end
if yz==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    yz=(j-iso_y).*(k-iso_z);
    clear i j k
    yz=yz(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    yz=reshape(yz,l,1);
else
    yz=[];
end
if xz==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    xz=(i-iso_x).*(k-iso_z);
    clear i j k
    xz=xz(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    xz=reshape(xz,l,1);
else
    xz=[];
end
if z2==1 
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    z2=(k-iso_z).*(k-iso_z);
    clear i j k
    z2=z2(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    z2=reshape(z2,l,1);
else
    z2=[];
end
if z2x==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    z2x=(k-iso_z).*(k-iso_z).*(i-iso_x);
    clear i j k
    z2x=z2x(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    z2x=reshape(z2x,l,1);
else
    z2x=[];
end
if z2y==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    z2y=(k-iso_z).*(k-iso_z).*(j-iso_y);
    clear i j k
    z2y=z2y(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    z2y=reshape(z2y,l,1);
else
    z2y=[];
end
if z3==1  
   [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
   z3=(k-iso_z).*(k-iso_z).*(k-iso_z);
   clear i j k
   z3=z3(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
   z3=reshape(z3,l,1);
else
    z3=[];
end
if zxy==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    zxy=(k-iso_z).*(i-iso_x).*(j-iso_y);
    clear i j k
    zxy=zxy(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    zxy=reshape(zxy,l,1);
else
    zxy=[];
end
if x2y2==1  
    [i,j,k]=ndgrid(1:s(1),1:s(2),1:s(3));
    x2y2=(i-iso_x).*(i-iso_x).*(j-iso_y).*(j-iso_y);
    clear i j k
    x2y2=x2y2(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
    x2y2=reshape(x2y2,l,1);
else
    x2y2=[];
end
B=Bhead(xROImin:xROImax,yROImin:yROImax,zROImin:zROImax);
B=reshape(B,l,1);
A=cat(2,x,y,z,xy,yz,xz,z2,z2x,z2y,z3,zxy,x2y2);
I=(inv(A'*A)*A'*B);
I=-I;
n=1;

for m=1:length(dispval)
    if dispval(m)==1
        a=sprintf('%s',disp{m});
        val=strcat(a,'grad');
        switch val
            case 'xgrad'             
                set(handles.xgradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                x=(i-iso_x);
                clear i j k
                x=reshape(x,s(1)*s(2)*s(3),1);
            case 'ygrad'
                set(handles.ygradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                y=(j-iso_y);
                clear i j k
                y=reshape(y,s(1)*s(2)*s(3),1);
            case 'zgrad'
                set(handles.zgradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                z=(k-iso_z);
                clear i j k
                z=reshape(z,s(1)*s(2)*s(3),1);
            case 'xygrad'
                set(handles.xygradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                xy=(i-iso_x).*(j-iso_y);
                clear i j k
                xy=reshape(xy,s(1)*s(2)*s(3),1);
            case 'yzgrad'
                set(handles.yzgradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                yz=(j-iso_y).*(k-iso_z);
                clear i j k
                yz=reshape(yz,s(1)*s(2)*s(3),1);
            case 'xzgrad'
                set(handles.xzgradedit,'string',sprintf('%6.5g',I(n)))
                 [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                 xz=(i-iso_x).*(k-iso_z);
                 clear i j k
                 xz=reshape(xz,s(1)*s(2)*s(3),1);
            case 'z2grad'
                set(handles.z2gradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                z2=(k-iso_z).*(k-iso_z);
                clear i j k
                z2=reshape(z2,s(1)*s(2)*s(3),1);
            case 'z2xgrad'
                set(handles.z2xgradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                z2x=(k-iso_z).*(k-iso_z).*(i-iso_x);
                clear i j k
                z2x=reshape(z2x,s(1)*s(2)*s(3),1);
            case 'z2ygrad'
                set(handles.z2ygradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                z2y=(k-iso_z).*(k-iso_z).*(j-iso_y);
                clear i j k
                z2y=reshape(z2y,s(1)*s(2)*s(3),1);
            case 'z3grad'
                set(handles.z3gradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                z3=(k-iso_z).*(k-iso_z).*(k-iso_z);
                clear i j k
                z3=reshape(z3,s(1)*s(2)*s(3),1);
            case 'zxygrad'
                set(handles.zxygradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                zxy=(k-iso_z).*(i-iso_x).*(j-iso_y);
                clear i j k
                zxy=reshape(zxy,s(1)*s(2)*s(3),1);
            case 'x2y2grad'
                set(handles.x2y2gradedit,'string',sprintf('%6.5g',I(n)))
                [i,j,k]=meshgrid(1:s(1),1:s(2),1:s(3));
                x2y2=(i-iso_x).*(i-iso_x).*(j-iso_y).*(j-iso_y);
                clear i j k
                x2y2=reshape(x2y2,s(1)*s(2)*s(3),1);
        end
        n=n+1;
        clear a val
    end
end

A=cat(2,x,y,z,xy,yz,xz,z2,z2x,z2y,z3,zxy,x2y2);

set(handles.status,'string','')
set(handles.resetpb,'enable','on')
set(handles.updatepb,'enable','on')

function xROImin_Callback(hObject, eventdata, handles)
% hObject    handle to xROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xROImin correct axrect
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if xROImin<1
    xROImin=1;
    set(handles.xROImin,'string','1');
end
if xROImin>=xROImax
    set(handles.xROImin,'string',num2str(xROImax-1));
    xROImin=xROImax-1;
end
axes(handles.axes2)
delete(correct)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
axes(handles.axes3)
delete(axrect)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);


% --- Executes during object creation, after setting all properties.
function xROImin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xROImax_Callback(hObject, eventdata, handles)
% hObject    handle to xROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xROImax correct axrect
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if xROImax>size
    xROImax=size;
    set(handles.xROImax,'string',num2str(size));
end
if xROImin>=xROImax
    set(handles.xROImin,'string',num2str(xROImax-1));
    xROImin=xROImax-1;
end
axes(handles.axes2)
delete(correct)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);
axes(handles.axes3)
delete(axrect)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);

% --- Executes during object creation, after setting all properties.
function xROImax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yROImin_Callback(hObject, eventdata, handles)
% hObject    handle to yROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yROImin sagrect axrect Bhead
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if yROImin<1
    yROImin=1;
    set(handles.yROImin,'string','1');
end
if yROImin>=yROImax
    set(handles.yROImin,'string',num2str(yROImax-1));
    yROImin=yROImax-1;
end
axes(handles.axes1)
delete(sagrect)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
axes(handles.axes3)
delete(axrect)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);

% --- Executes during object creation, after setting all properties.
function yROImin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yROImax_Callback(hObject, eventdata, handles)
% hObject    handle to yROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global yROImax sagrect axrect 
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if yROImax>size
    yROImax=size;
    set(handles.yROImax,'string',num2str(size));
end
if yROImin>=yROImax
    set(handles.yROImin,'string',num2str(yROImax-1));
    yROImin=yROImax-1;
end
axes(handles.axes1)
delete(sagrect)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
axes(handles.axes3)
delete(axrect)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);

% --- Executes during object creation, after setting all properties.
function yROImax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zROImin_Callback(hObject, eventdata, handles)
% hObject    handle to zROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global zROImin sagrect correct
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if zROImin<1
    zROImin=1;
    set(handles.zROImin,'string','1');
end
if zROImin>=zROImax
    set(handles.zROImin,'string',num2str(zROImax-1));
    zROImin=zROImax-1;
end
axes(handles.axes1)
delete(sagrect)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
axes(handles.axes2)
delete(correct)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);


% --- Executes during object creation, after setting all properties.
function zROImin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zROImin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zROImax_Callback(hObject, eventdata, handles)
% hObject    handle to zROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global zROImax sagrect correct
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
size=str2num(get(handles.matrixedit,'String'));
if zROImax>size
    zROImax=size;
    set(handles.zROImax,'string',num2str(size));
end
if zROImin>=zROImax
    set(handles.zROImin,'string',num2str(zROImax-1));
    zROImin=zROImax-1;
end
axes(handles.axes1)
delete(sagrect)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);
axes(handles.axes2)
delete(correct)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);


% --- Executes during object creation, after setting all properties.
function zROImax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zROImax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xpadedit_Callback(hObject, eventdata, handles)
% hObject    handle to xpadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global head xmin_max v
s=size(head);
x=round(str2double(get(hObject,'String')));
if mod(x,2)~=0
    x=x+1;
end
h=zeros(s(1)+(2*x),s(2),s(3));
sh=size(h);
if s(1)+(2*x)>s(1)
    h(x+1:s(1)+x,1:s(2),1:s(3))=head;
    xmin_max=xmin_max+x;
    head=h;
    clear h
else
    x=abs(x);
    h=head(x+1:s(1)-x,1:s(2),1:s(3));
    xmin_max=xmin_max-x;
    if xmin_max(1)<1
        xmin_max(1)=1;
    end
    if xmin_max(2)>sh(1)
        xmin_max(2)=sh(1);
    end
    head=h;
    clear h x
end
f=size(head);
set(handles.xslider,'sliderstep',[(1/f(1)) 10/f(1)],'max',f(1),'min',1,'value',round(f(1)/2));
set(handles.xedit,'string',sprintf('%1.0f',round(f(1)/2)));
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
hx(:,:)=head(x,:,:);
hx=flipdim(rot90(hx,3),2);
hy(:,:)=head(:,y,:);
hy=flipdim(rot90(hy,3),2);
hz(:,:)=head(:,:,z);
hz=flipdim(rot90(hz,3),2);
clear x y z;
axes(handles.axes1)%plots sagital X map
pcolor(hx);shading flat;axis off;colormap jet2;axis equal;caxis(v)
axes(handles.axes5)
colorbar('delete')
caxis(v);
axes(handles.axes2)%plots coronal X map
pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)%plots
pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
%sends the colorbar to axis 5
colorbar('peer',handles.axes5,'location','north')

% --- Executes during object creation, after setting all properties.
function xpadedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ypadedit_Callback(hObject, eventdata, handles)
% hObject    handle to ypadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global head ymin_max v
s=size(head);
x=round(str2double(get(hObject,'String')));
if mod(x,2)~=0
    x=x+1;
end
h=zeros(s(1,1),s(1,2)+(2*x),s(1,3));
sh=size(h);
if s(2)+(2*x)>s(2)
    h(1:s(1,1),x+1:s(1,2)+x,1:s(1,3))=head;
    ymin_max=ymin_max+x;
    head=h;
    clear h
else
    x=abs(x);
    h=head(1:s(1),x+1:s(1,2)-x,1:s(3));
    ymin_max=ymin_max-x;
    if ymin_max(1,1)<1
        ymin_max(1,1)=1;
    end
    if ymin_max(1,2)>sh(2)
        ymin_max(2)=sh(1,2);
    end
    head=h;
    clear h
end
f=size(head);
set(handles.yslider,'sliderstep',[(1/f(1,2)) 10/f(1,2)],'max',f(1,2),'min',1,'value',round(f(1,2)/2));
set(handles.yedit,'string',sprintf('%1.0f',round(f(1,2)/2)));
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
hx(:,:)=head(x,:,:);
hx=flipdim(rot90(hx,3),2);
hy(:,:)=head(:,y,:);
hy=flipdim(rot90(hy,3),2);
hz(:,:)=head(:,:,z);
hz=flipdim(rot90(hz,3),2);
clear x y z;
axes(handles.axes1)%plots sagital X map
pcolor(hx);shading flat;axis off;colormap jet2;axis equal;caxis(v)
axes(handles.axes5)
colorbar('delete')
caxis(v);
axes(handles.axes2)%plots coronal X map
pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)%plots
pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
%sends the colorbar to axis 5
colorbar('peer',handles.axes5,'location','north')


% --- Executes during object creation, after setting all properties.
function ypadedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zpadedit_Callback(hObject, eventdata, handles)
% hObject    handle to zpadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global head zmin_max v
s=size(head);
x=round(str2double(get(hObject,'String')));
if mod(x,2)~=0
    x=x+1;
end
h=zeros(s(1,1),s(1,2),s(1,3)+(2*x));
sh=size(h);
if s(3)+(2*x)>s(3)
    h(1:s(1,1),1:s(1,2),x+1:s(1,3)+x)=head;
    zmin_max=zmin_max+x;
    head=h;
    clear h
else
    x=abs(x);
    h=head(1:s(1,1),1:s(1,2),x+1:s(1,3)-x);
    zmin_max=zmin_max-x;
    if zmin_max(2)<1
        zmin_max(1)=1;
    end
    if zmin_max(2)>sh(3)
        zmin_max(2)=sh(3);
    end
    head=h;
    clear h
end
f=size(head);
set(handles.zslider,'sliderstep',[(1/f(1,3)) 10/f(1,3)],'max',f(1,3),'min',1,'value',round(f(1,3)/2));
set(handles.zedit,'string',sprintf('%1.0f',round(f(1,3)/2)));
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
hx(:,:)=head(x,:,:);
hx=flipdim(rot90(hx,3),2);
hy(:,:)=head(:,y,:);
hy=flipdim(rot90(hy,3),2);
hz(:,:)=head(:,:,z);
hz=flipdim(rot90(hz,3),2);
clear x y z;
axes(handles.axes1)%plots sagital X map
pcolor(hx);shading flat;axis off;colormap jet2;axis equal;caxis(v)
axes(handles.axes5)
colorbar('delete')
caxis(v);
axes(handles.axes2)%plots coronal X map
pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)%plots
pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
%sends the colorbar to axis 5
colorbar('peer',handles.axes5,'location','north')


% --- Executes during object creation, after setting all properties.
function zpadedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zpadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updatepb.
function updatepb_Callback(hObject, eventdata, handles)
% hObject    handle to updatepb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dB0 v dummy Bhead A update rect
set(handles.status,'string','Processing...')
pause(.001)
% if update>=1
%     Bhead=dummy;
% end
s=size(Bhead);
I=[str2num(get(handles.xgradedit,'string'));str2num(get(handles.ygradedit,'string'));str2num(get(handles.zgradedit,'string'));str2num(get(handles.xygradedit,'string'));str2num(get(handles.yzgradedit,'string'));str2num(get(handles.xzgradedit,'string'));str2num(get(handles.z2gradedit,'string'));str2num(get(handles.z2xgradedit,'string'));str2num(get(handles.z2ygradedit,'string'));str2num(get(handles.z3gradedit,'string'));str2num(get(handles.zxygradedit,'string'));str2num(get(handles.x2y2gradedit,'string'))];
B=reshape(Bhead,s(1)*s(2)*s(3),1);
dB0=B+A*I;
dB0=reshape(dB0,s(1),s(2),s(3));
dummy=Bhead;
dB0(Bhead==0)=0;
x=round(get(handles.xslider,'Value'));
y=round(get(handles.yslider,'Value'));
z=round(get(handles.zslider,'Value'));
axes(handles.axes1)
Bxhp(:,:)=dB0(x,:,:);
Byhp(:,:)=dB0(:,y,:);
Bzhp(:,:)=dB0(:,:,z);
Bhead=dB0;
clear dB0 Bhead 
Bxhp=flipdim(rot90(Bxhp,3),2);
Byhp=flipdim(rot90(Byhp,3),2);
Bzhp=flipdim(rot90(Bzhp,3),2);
pcolor(Bxhp);shading flat;axis off;colormap jet2;axis equal;caxis(v)
axes(handles.axes5)
colorbar('delete')
caxis(v);
axes(handles.axes2)
pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)
pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
colorbar('peer',handles.axes5,'location','north')
set(handles.status,'String','');
clear Bxhp Byhp Bzhp;
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
global sagrect axrect correct
axes(handles.axes1)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);

axes(handles.axes2)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);

axes(handles.axes3)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');
clear x y z;
set(handles.autoshimpb,'enable','on')
set(handles.savepb,'enable','on')
set(handles.status,'String','');
update=update+1;

% --- Executes on button press in savepb.
function savepb_Callback(hObject, eventdata, handles)
% hObject    handle to savepb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bhead fileh inputGeoData inputInfo
set(handles.status,'String','Saving...');
pause(.001)
%user interface to create path and file to be saved
if ~(isempty(inputInfo))
    size=str2num(get(handles.matrixedit,'string'));
    if mod(size,2)~=0
        size=size+1;
    end
    w=size/2;

    fid1=fopen(inputInfo.filename,'rb');
    if fid1>0
        fseek(fid1,28,'bof');
        center=fread(fid1,[1 3],'float32');
        scale=fread(fid1,[1 3],'float32');
    end

    fclose(fid1);
    x=inputGeoData(1,:);
    y=inputGeoData(2,:);
    z=inputGeoData(3,:);
    ID=inputGeoData(4,:);
    rows=inputInfo.totNumVox;
    xmin_max(1,1)=inputInfo.minX;
    xmin_max(1,2)=inputInfo.maxX;
    ymin_max(1,1)=inputInfo.minY;
    ymin_max(1,2)=inputInfo.maxY;
    zmin_max(1,1)=inputInfo.minZ;
    zmin_max(1,2)=inputInfo.maxZ;
    mx=center(1,1)-w;
    my=center(1,2)-w;
    mz=center(1,3)-w;
    x=x-mx;
    xmin_max=xmin_max-mx;
    y=y-my;
    ymin_max=ymin_max-my;
    z=z-mz;
    zmin_max=zmin_max-mz;
    cx=center(1,1)-mx;
    cy=center(1,2)-my;
    cz=center(1,3)-mz;
    iso_cx=inputInfo.ctrX;
    iso_cy=inputInfo.ctrY;
    iso_cz=inputInfo.ctrZ;
     
else
    size=str2num(get(handles.matrixedit,'string'));
    if mod(size,2)~=0
        size=size+1;
    end
    w=size/2;
    fid1=fopen(fileh,'rb');
    rows=fread(fid1,1,'float32');
    blank=fread(fid1,[1 2],'float32');
    blank=fread(fid1,[1 2],'float32');
    blank=fread(fid1,[1 2],'float32');
    center=fread(fid1,[1 3],'float32');
    scale=fread(fid1,[1 3],'float32');
    x=fread(fid1,rows,'float32',12);
    frewind(fid1);
    null=fread(fid1,14,'float32');
    y=fread(fid1,rows,'float32',12);
    frewind(fid1);
    null=fread(fid1,15,'float32');
    z=fread(fid1,rows,'float32',12);
    frewind(fid1);
    null=fread(fid1,16,'float32');
    ID=fread(fid1,rows,'float32',12);
    fclose(fid1);
    clear null blank ID fid1 fileh
    mx=center(1,1)-w;
    my=center(1,2)-w;
    mz=center(1,3)-w;
    x=x-mx;
    y=y-my;
    z=z-mz;
end
db0=zeros(rows,1);
dbx=zeros(rows,1);
dby=zeros(rows,1);
dbz=zeros(rows,1);
bhead=Bhead*10^6;
[dx dy dz]=gradient(bhead,(scale(1)*10^-3),(scale(2)*10^-3),(scale(3)*10^-3));
for i=1:rows
    db0(i)=bhead(x(i),y(i),z(i));
    dbx(i)=dx(x(i),y(i),z(i));
    dby(i)=dy(x(i),y(i),z(i));
    dbz(i)=dz(x(i),y(i),z(i));
%     if db0(i,1)==0
%         db0(i,1)=1;
%     end
%     if db0(i,2)==0
%         db0(i,2)=1;
%     end
%     if db0(i,3)==0
%         db0(i,3)=1;
%     end
%     if db0(i,4)==0
%         db0(i,4)=1;
%     end
end
[filename,pathname]=uiputfile('*.db0','Save file as','db0.db0');
if filename>=1
    inputInfo.savefilename=filename;
    inputInfo.pathname=pathname;
    fid=fopen([pathname,filename],'w+');
    fwrite(fid,rows,'float32');
    fwrite(fid,db0(1,1),'float32');
    fwrite(fid,dbx(1,1),'float32');
    fwrite(fid,dby(1,1),'float32');
    fwrite(fid,dbz(1,1),'float32');
    fseek(fid,-12,'eof');
    fwrite(fid,db0(2:rows,1),'float32',12);
    fseek(fid,12,'bof');
    fwrite(fid,dbx(2:rows,1),'float32',12);
    fseek(fid,16,'bof');
    fwrite(fid,dby(2:rows,1),'float32',12);
    fseek(fid,20,'bof');
    fwrite(fid,dbz(2:rows,1),'float32',12);
    set(handles.status,'string','')
    if ~(isempty(inputInfo))
    uiresume
    end
else
    set(handles.status,'string','')
end

set(handles.status,'String','');


% --- Executes on button press in resetpb.
function resetpb_Callback(hObject, eventdata, handles)
% hObject    handle to resetpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xmin_max ymin_max zmin_max Bhead v dummy Bnuc inputInfo
global x y z xy yz xz z2 z2x z2y z3 zxy x2y2 rect;
clear global x y z xy yz xz z2 z2x z2y z3 zxy x2y2;
set(handles.xgrad,'value',0)
set(handles.ygrad,'value',0)
set(handles.zgrad ,'value',0)
set(handles.xygrad,'value',0)
set(handles.yzgrad,'value',0)
set(handles.xzgrad,'value',0)
set(handles.z2grad,'value',0)
set(handles.z2xgrad,'value',0)
set(handles.z2ygrad,'value',0)
set(handles.z3grad,'value',0)
set(handles.zxygrad,'value',0)
set(handles.x2y2grad,'value',0)
set(handles.xgradedit,'string','')
set(handles.ygradedit,'string','')
set(handles.zgradedit,'string','')
set(handles.xygradedit,'string','')
set(handles.yzgradedit,'string','')
set(handles.xzgradedit,'string','')
set(handles.z2gradedit,'string','')
set(handles.z2xgradedit,'string','')
set(handles.z2ygradedit,'string','')
set(handles.z3gradedit,'string','')
set(handles.zxygradedit,'string','')
set(handles.x2y2gradedit,'string','')
set(handles.xROImin,'string',sprintf('%1.0f',min(xmin_max)))
set(handles.xROImax,'string',sprintf('%1.0f',max(xmin_max)))
set(handles.yROImin,'string',sprintf('%1.0f',min(ymin_max)))
set(handles.yROImax,'string',sprintf('%1.0f',max(ymin_max)))
set(handles.zROImin,'string',sprintf('%1.0f',min(zmin_max)))
set(handles.zROImax,'string',sprintf('%1.0f',max(zmin_max)))
i=round(get(handles.xslider,'Value'));
j=round(get(handles.yslider,'Value'));
k=round(get(handles.zslider,'Value'));
s=size(Bhead);
if isempty(inputInfo)
    set(handles.iso_x,'string',sprintf('%1.0f',s(1)/2));
    set(handles.iso_y,'string',sprintf('%1.0f',s(2)/2));
    set(handles.iso_z,'string',sprintf('%1.0f',s(3)/2));
    set(handles.iso_x,'enable','on');
    set(handles.iso_y,'enable','on');
    set(handles.iso_z,'enable','on');
end
xROImin=str2num(get(handles.xROImin,'String'));
xROImax=str2num(get(handles.xROImax,'String'));
yROImin=str2num(get(handles.yROImin,'String'));
yROImax=str2num(get(handles.yROImax,'String'));
zROImin=str2num(get(handles.zROImin,'String'));
zROImax=str2num(get(handles.zROImax,'String'));
Bhead=Bnuc;
Bhead(dummy==0)=0;
axes(handles.axes1)
Bxhp(:,:)=Bhead(i,:,:);
Byhp(:,:)=Bhead(:,j,:);
Bzhp(:,:)=Bhead(:,:,k);
Bxhp=flipdim(rot90(Bxhp,3),2);
Byhp=flipdim(rot90(Byhp,3),2);
Bzhp=flipdim(rot90(Bzhp,3),2);
pcolor(Bxhp);shading flat;axis off;colormap jet2;axis equal;caxis(v)
set(handles.csmaxedit,'string',sprintf('%.1f',max(v(1,2)*10^6)));
set(handles.csminedit,'string',sprintf('%.1f',min(v(1,1)*10^6)));
set(handles.csminslider,'value',v(1,1)*10^6);
set(handles.csmaxslider,'value',v(1,2)*10^6);
axes(handles.axes5)
colorbar('delete')
caxis(v);
axes(handles.axes2)
pcolor(Byhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
axes(handles.axes3)
pcolor(Bzhp);shading flat;axis off;colormap jet2;caxis(v);axis equal
colorbar('peer',handles.axes5,'location','north')
set(handles.status,'String','');
clear Bxhp Byhp Bzhp;
global sagrect axrect correct
axes(handles.axes1)
sagrect=rectangle('position',[yROImin zROImin yROImax-yROImin zROImax-zROImin]);

axes(handles.axes2)
correct=rectangle('position',[xROImin zROImin xROImax-xROImin zROImax-zROImin]);

axes(handles.axes3)
axrect=rectangle('position',[xROImin yROImin xROImax-xROImin yROImax-yROImin]);
clear i j k;
set(handles.autoshimpb,'enable','on')
set(handles.savepb,'enable','on')
set(handles.status,'String','')
set(handles.updatepb,'enable','off')
set(handles.algorithmSelect,'enable','on');
set(handles.resetpb,'enable','off')
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');



function matrixedit_Callback(hObject, eventdata, handles)
% hObject    handle to matrixedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global head xmin_max ymin_max zmin_max v count Bhead run Bnuc min_size rect
global sagrect axrect correct
x=round(str2double(get(hObject,'String')));
if isnan(x)
    x=256;
    set(handles.matrixedit,'string',sprintf('%1.0f',x))
end
select=get(handles.fieldcb,'value');
if x<=min_size
    x=min_size+1;
end
if mod(x,2)~=0
    x=x+1;
end
set(handles.matrixedit,'string',sprintf('%1.0f',x))
if count>0
    s=length(head);  
    h=zeros(x,x,x);
    sh=length(h);
    new=x-s;
    X=str2num(get(handles.iso_x,'string'))+new/2;
    Y=str2num(get(handles.iso_y,'string'))+new/2;
    Z=str2num(get(handles.iso_z,'string'))+new/2;
    xmin_max=xmin_max+new/2;
    ymin_max=ymin_max+new/2;
    zmin_max=zmin_max+new/2;
    old_x=round(get(handles.xslider,'Value'));
    old_y=round(get(handles.yslider,'Value'));
    old_z=round(get(handles.zslider,'Value'));
    old_x=old_x+new/2;
    old_y=old_y+new/2;
    old_z=old_z+new/2;
    min_max(1,1)=min(xmin_max);
    min_max(1,2)=max(xmin_max);
    min_max(2,1)=min(ymin_max);
    min_max(2,2)=max(ymin_max);
    min_max(3,1)=min(zmin_max);
    min_max(3,2)=max(zmin_max);
    for i=1:3
        for j=1:2
            if min_max(i,j)<=0
                min_max(i,j)=1;
            end
            if min_max(i,j)>x
                min_max(i,j)=x;
            end
        end
    end
    xmin_max(1,1)=min_max(1,1);
    xmin_max(1,2)=min_max(1,2);
    ymin_max(1,1)=min_max(2,1);
    ymin_max(1,2)=min_max(2,2);
    zmin_max(1,1)=min_max(3,1);
    zmin_max(1,2)=min_max(3,2);
    set(handles.xROImin,'string',sprintf('%1.0f',min(xmin_max)));
    set(handles.xROImax,'string',sprintf('%1.0f',max(xmin_max)));
    set(handles.yROImin,'string',sprintf('%1.0f',min(ymin_max)));
    set(handles.yROImax,'string',sprintf('%1.0f',max(ymin_max)));
    set(handles.zROImin,'string',sprintf('%1.0f',min(zmin_max)));
    set(handles.zROImax,'string',sprintf('%1.0f',max(zmin_max)));
    if run>=1
        if new >0
            h(new/2+1:s+new/2,new/2+1:s+new/2,new/2+1:s+new/2)=head;
            head=h;
            h(new/2+1:s+new/2,new/2+1:s+new/2,new/2+1:s+new/2)=Bnuc;
            Bnuc=h;
            Bhead=Bnuc;
            Bhead=(head~=0).*Bhead;
            clear h
        else
            new=abs(new);
            h=head(new/2+1:sh+new/2,new/2+1:sh+new/2,new/2+1:sh+new/2);
            head=h;
            h=Bnuc(new/2+1:sh+new/2,new/2+1:sh+new/2,new/2+1:sh+new/2);
            Bnuc=h;
            Bhead=Bnuc;
            Bhead=(head~=0).*Bhead;
            clear h;
        end
    else
        if new >0
            h(new/2+1:s+new/2,new/2+1:s+new/2,new/2+1:s+new/2)=head;
            head=h;
            clear h
        else
            new=abs(new);
            h=head(new/2+1:sh+new/2,new/2+1:sh+new/2,new/2+1:sh+new/2);
            head=h;
            clear h;
        end
    end
    f=size(head);
    x=round(get(handles.xslider,'Value'));
    y=round(get(handles.yslider,'Value'));
    z=round(get(handles.zslider,'Value'));
    set(handles.xslider,'sliderstep',[(1/f(1,1)) 10/f(1,1)],'max',f(1,1),'min',1,'value',old_x);
    set(handles.xedit,'string',sprintf('%1.0f',old_x));
    set(handles.zslider,'sliderstep',[(1/f(1,3)) 10/f(1,3)],'max',f(1,3),'min',1,'value',old_z);
    set(handles.zedit,'string',sprintf('%1.0f',old_z));
    set(handles.yslider,'sliderstep',[(1/f(1,2)) 10/f(1,2)],'max',f(1,2),'min',1,'value',old_y);
    set(handles.yedit,'string',sprintf('%1.0f',old_y));
    set(handles.iso_x,'string',sprintf('%1.0f',X));
    set(handles.iso_y,'string',sprintf('%1.0f',Y));
    set(handles.iso_z,'string',sprintf('%1.0f',Z));
    x=round(get(handles.xslider,'Value'));
    y=round(get(handles.yslider,'Value'));
    z=round(get(handles.zslider,'Value'));
    if run>0
        if select==1
            hx(:,:)=Bnuc(x,:,:);
            hx=flipdim(rot90(hx,3),2);
            hy(:,:)=Bnuc(:,y,:);
            hy=flipdim(rot90(hy,3),2);
            hz(:,:)=Bnuc(:,:,z);
            hz=flipdim(rot90(hz,3),2);
            clear x y z;
        else
            hx(:,:)=Bhead(x,:,:);
            hx=flipdim(rot90(hx,3),2);
            hy(:,:)=Bhead(:,y,:);
            hy=flipdim(rot90(hy,3),2);
            hz(:,:)=Bhead(:,:,z);
            hz=flipdim(rot90(hz,3),2);
            clear x y z;
        end
    else
        hx(:,:)=head(x,:,:);
        hx=flipdim(rot90(hx,3),2);
        hy(:,:)=head(:,y,:);
        hy=flipdim(rot90(hy,3),2);
        hz(:,:)=head(:,:,z);
        hz=flipdim(rot90(hz,3),2);
        clear x y z;
    end
    axes(handles.axes1)%plots sagital X map
    pcolor(hx);shading flat;axis off;colormap jet2;axis equal;caxis(v)
    sagrect=rectangle('position',[min(ymin_max) min(zmin_max) max(ymin_max)-min(ymin_max) max(zmin_max)-min(zmin_max)]);
    axes(handles.axes5)
    colorbar('delete')
    caxis(v);
    axes(handles.axes2)%plots coronal X map
    pcolor(hy);shading flat;axis off;colormap jet2;caxis(v);axis equal
    correct=rectangle('position',[min(xmin_max) min(zmin_max) max(xmin_max)-min(xmin_max) max(zmin_max)-min(zmin_max)]);
    axes(handles.axes3)%plots
    pcolor(hz);shading flat;axis off;colormap jet2;caxis(v);axis equal
    axrect=rectangle('position',[min(xmin_max) min(ymin_max) max(xmin_max)-min(xmin_max) max(ymin_max)-min(ymin_max)]);
%    sends the colorbar to axis 5
    colorbar('peer',handles.axes5,'location','north')
end
clear x
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');



% --- Executes during object creation, after setting all properties.
function matrixedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matrixedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iso_x_Callback(hObject, eventdata, handles)
% hObject    handle to iso_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bnuc rect
x=str2double(get(hObject,'String'));
s=size(Bnuc);
if x<=0
    x=1;
    set(handles.iso_x,'string',sprintf('%1.0f',x));
end
if x>s(1)
    x=s(1);
    set(handles.iso_x,'string',sprintf('%1.0f',x));
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
delete(rect.x)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
delete(rect.y)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
delete(rect.z)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% Hints: get(hObject,'String') returns contents of iso_x as text
%        str2double(get(hObject,'String')) returns contents of iso_x as a double


% --- Executes during object creation, after setting all properties.
function iso_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iso_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iso_y_Callback(hObject, eventdata, handles)
% hObject    handle to iso_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bnuc rect
x=str2double(get(hObject,'String'));
s=size(Bnuc);
if x<=0
    x=1;
    set(handles.iso_y,'string',sprintf('%1.0f',x));
end
if x>s(2)
    x=s(2);
    set(handles.iso_y,'string',sprintf('%1.0f',x));
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
delete(rect.x)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
delete(rect.y)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
delete(rect.z)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% Hints: get(hObject,'String') returns contents of iso_y as text
%        str2double(get(hObject,'String')) returns contents of iso_y as a double


% --- Executes during object creation, after setting all properties.
function iso_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iso_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iso_z_Callback(hObject, eventdata, handles)
% hObject    handle to iso_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Bnuc rect
x=str2double(get(hObject,'String'));
s=size(Bnuc);
if x<=0
    x=1;
    set(handles.iso_z,'string',sprintf('%1.0f',x));
end
if x>s(3)
    x=s(3);
    set(handles.iso_z,'string',sprintf('%1.0f',x));
end
iso_x=str2num(get(handles.iso_x,'string'));
iso_y=str2num(get(handles.iso_y,'string'));
iso_z=str2num(get(handles.iso_z,'string'));
axes(handles.axes1)
delete(rect.x)
rect.x=rectangle('position',[iso_y-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes2)
delete(rect.y)
rect.y=rectangle('position',[iso_x-3 iso_z-3 6 6],'FaceColor','y');
axes(handles.axes3)
delete(rect.z)
rect.z=rectangle('position',[iso_x-3 iso_y-3 6 6],'FaceColor','y');

% Hints: get(hObject,'String') returns contents of iso_z as text
%        str2double(get(hObject,'String')) returns contents of iso_z as a double


% --- Executes during object creation, after setting all properties.
function iso_z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iso_z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



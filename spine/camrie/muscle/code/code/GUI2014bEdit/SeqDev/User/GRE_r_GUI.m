function AngleIncrement = GRE_r_GUI(MatSize2)
    
%% Additional Parameter GUI for GRE_r
        
    hGRE_r_dlg = figure('Visible','on','MenuBar','none','Name','Additional Parameters',...
        'NumberTitle','off','Position',[100,30,190,45],'Resize','off',...
        'Color',[1,1,1],'Toolbar','none','WindowStyle','modal');
    movegui(hGRE_r_dlg,'center');
    
    hRadialType = uicontrol(hGRE_r_dlg,'Style','popupmenu','String',{'Linear','Golden'},...
        'Position',[35 15 60 20],'BackgroundColor',[1,1,1],'BusyAction','cancel');
    
    uicontrol(hGRE_r_dlg,'Style','pushbutton','String','OK',...
        'Position',[115 15 40 20],'Callback',{@OK_Callback});    
    
    uiwait(gcf);

    switch get(hRadialType,'Value')
        % Linear
        case 1
            AngleIncrement = -2*pi / MatSize2;
        % Golden
        case 2
            AngleIncrement = -pi/( (sqrt(5)+1)/2 );
        % Default is Linear
        otherwise
            AngleIncrement = -2*pi / MatSize2;
    end;
    
    if gcf == hGRE_r_dlg
        close(gcf);
    end;
    
end

function OK_Callback(source,eventdata)   
    uiresume(gcbf);
end